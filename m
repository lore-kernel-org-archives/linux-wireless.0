Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:62844 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbaG3LUM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2014 07:20:12 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 8/8] brcmfmac: Add TDLS support to msgbuf.
Date: Wed, 30 Jul 2014 13:20:07 +0200
Message-ID: <1406719207-5126-9-git-send-email-arend@broadcom.com> (sfid-20140730_132036_778555_4A867A3A)
In-Reply-To: <1406719207-5126-1-git-send-email-arend@broadcom.com>
References: <1406719207-5126-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

TDLS connections require dedicated flowrings. This patches adds
TDLS event handling and flowring creation/deletion based on these
events.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c     |  7 ++
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c | 94 +++++++++++++++++++++-
 drivers/net/wireless/brcm80211/brcmfmac/flowring.h |  9 +++
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |  6 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |  5 ++
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   | 10 +++
 drivers/net/wireless/brcm80211/brcmfmac/proto.c    |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/proto.h    |  7 ++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  | 24 ++++++
 9 files changed, 158 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
index 10b48c2..a159ff3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
@@ -349,6 +349,12 @@ brcmf_proto_bcdc_delete_peer(struct brcmf_pub *drvr, int ifidx,
 {
 }
 
+static void
+brcmf_proto_bcdc_add_tdls_peer(struct brcmf_pub *drvr, int ifidx,
+			       u8 peer[ETH_ALEN])
+{
+}
+
 int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 {
 	struct brcmf_bcdc *bcdc;
@@ -369,6 +375,7 @@ int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 	drvr->proto->txdata = brcmf_proto_bcdc_txdata;
 	drvr->proto->configure_addr_mode = brcmf_proto_bcdc_configure_addr_mode;
 	drvr->proto->delete_peer = brcmf_proto_bcdc_delete_peer;
+	drvr->proto->add_tdls_peer = brcmf_proto_bcdc_add_tdls_peer;
 	drvr->proto->pd = bcdc;
 
 	drvr->hdrlen += BCDC_HEADER_LEN + BRCMF_PROT_FW_SIGNAL_MAX_TXBYTES;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
index 4d55c21..fa17b69 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
@@ -49,6 +49,23 @@ static const u8 brcmf_flowring_prio2fifo[] = {
 };
 
 
+static bool
+brcmf_flowring_is_tdls_mac(struct brcmf_flowring *flow, u8 mac[ETH_ALEN])
+{
+	struct brcmf_flowring_tdls_entry *search;
+
+	search = flow->tdls_entry;
+
+	while (search) {
+		if (memcmp(search->mac, mac, ETH_ALEN) == 0)
+			return true;
+		search = search->next;
+	}
+
+	return false;
+}
+
+
 u32 brcmf_flowring_lookup(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 			  u8 prio, u8 ifidx)
 {
@@ -67,6 +84,10 @@ u32 brcmf_flowring_lookup(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 		mac = (u8 *)ALLFFMAC;
 		fifo = 0;
 	}
+	if ((sta) && (flow->tdls_active) &&
+	    (brcmf_flowring_is_tdls_mac(flow, da))) {
+		sta = false;
+	}
 	hash_idx =  sta ? BRCMF_FLOWRING_HASH_STA(fifo, ifidx) :
 			  BRCMF_FLOWRING_HASH_AP(mac, fifo, ifidx);
 	found = false;
@@ -106,15 +127,17 @@ u32 brcmf_flowring_create(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 		mac = (u8 *)ALLFFMAC;
 		fifo = 0;
 	}
+	if ((sta) && (flow->tdls_active) &&
+	    (brcmf_flowring_is_tdls_mac(flow, da))) {
+		sta = false;
+	}
 	hash_idx =  sta ? BRCMF_FLOWRING_HASH_STA(fifo, ifidx) :
 			  BRCMF_FLOWRING_HASH_AP(mac, fifo, ifidx);
 	found = false;
 	hash = flow->hash;
 	for (i = 0; i < BRCMF_FLOWRING_HASHSIZE; i++) {
-		if (((sta) &&
-		     (hash[hash_idx].ifidx == BRCMF_FLOWRING_INVALID_IFIDX)) ||
-		    ((!sta) &&
-		     (memcmp(hash[hash_idx].mac, ALLZEROMAC, ETH_ALEN) == 0))) {
+		if ((hash[hash_idx].ifidx == BRCMF_FLOWRING_INVALID_IFIDX) &&
+		    (memcmp(hash[hash_idx].mac, ALLZEROMAC, ETH_ALEN) == 0)) {
 			found = true;
 			break;
 		}
@@ -356,12 +379,21 @@ void brcmf_flowring_detach(struct brcmf_flowring *flow)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(flow->dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
+	struct brcmf_flowring_tdls_entry *search;
+	struct brcmf_flowring_tdls_entry *remove;
 	u8 flowid;
 
 	for (flowid = 0; flowid < flow->nrofrings; flowid++) {
 		if (flow->rings[flowid])
 			brcmf_msgbuf_delete_flowring(drvr, flowid);
 	}
+
+	search = flow->tdls_entry;
+	while (search) {
+		remove = search;
+		search = search->next;
+		kfree(remove);
+	}
 	kfree(flow->rings);
 	kfree(flow);
 }
@@ -396,11 +428,25 @@ void brcmf_flowring_delete_peer(struct brcmf_flowring *flow, int ifidx,
 	struct brcmf_bus *bus_if = dev_get_drvdata(flow->dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
 	struct brcmf_flowring_hash *hash;
+	struct brcmf_flowring_tdls_entry *prev;
+	struct brcmf_flowring_tdls_entry *search;
 	u32 i;
 	u8 flowid;
 	bool sta;
 
 	sta = (flow->addr_mode[ifidx] == ADDR_INDIRECT);
+
+	search = flow->tdls_entry;
+	prev = NULL;
+	while (search) {
+		if (memcmp(search->mac, peer, ETH_ALEN) == 0) {
+			sta = false;
+			break;
+		}
+		prev = search;
+		search = search->next;
+	}
+
 	hash = flow->hash;
 	for (i = 0; i < BRCMF_FLOWRING_HASHSIZE; i++) {
 		if ((sta || (memcmp(hash[i].mac, peer, ETH_ALEN) == 0)) &&
@@ -412,5 +458,45 @@ void brcmf_flowring_delete_peer(struct brcmf_flowring *flow, int ifidx,
 			}
 		}
 	}
+
+	if (search) {
+		if (prev)
+			prev->next = search->next;
+		else
+			flow->tdls_entry = search->next;
+		kfree(search);
+		if (flow->tdls_entry == NULL)
+			flow->tdls_active = false;
+	}
+}
+
+
+void brcmf_flowring_add_tdls_peer(struct brcmf_flowring *flow, int ifidx,
+				  u8 peer[ETH_ALEN])
+{
+	struct brcmf_flowring_tdls_entry *tdls_entry;
+	struct brcmf_flowring_tdls_entry *search;
+
+	tdls_entry = kzalloc(sizeof(*tdls_entry), GFP_ATOMIC);
+	if (tdls_entry == NULL)
+		return;
+
+	memcpy(tdls_entry->mac, peer, ETH_ALEN);
+	tdls_entry->next = NULL;
+	if (flow->tdls_entry == NULL) {
+		flow->tdls_entry = tdls_entry;
+	} else {
+		search = flow->tdls_entry;
+		if (memcmp(search->mac, peer, ETH_ALEN) == 0)
+			return;
+		while (search->next) {
+			search = search->next;
+			if (memcmp(search->mac, peer, ETH_ALEN) == 0)
+				return;
+		}
+		search->next = tdls_entry;
+	}
+
+	flow->tdls_active = true;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/flowring.h b/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
index cb9644c..a34cd39 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
@@ -40,6 +40,11 @@ struct brcmf_flowring_ring {
 	struct sk_buff_head skblist;
 };
 
+struct brcmf_flowring_tdls_entry {
+	u8 mac[ETH_ALEN];
+	struct brcmf_flowring_tdls_entry *next;
+};
+
 struct brcmf_flowring {
 	struct device *dev;
 	struct brcmf_flowring_hash hash[BRCMF_FLOWRING_HASHSIZE];
@@ -47,6 +52,8 @@ struct brcmf_flowring {
 	spinlock_t block_lock;
 	enum proto_addr_mode addr_mode[BRCMF_MAX_IFS];
 	u16 nrofrings;
+	bool tdls_active;
+	struct brcmf_flowring_tdls_entry *tdls_entry;
 };
 
 
@@ -70,6 +77,8 @@ void brcmf_flowring_configure_addr_mode(struct brcmf_flowring *flow, int ifidx,
 					enum proto_addr_mode addr_mode);
 void brcmf_flowring_delete_peer(struct brcmf_flowring *flow, int ifidx,
 				u8 peer[ETH_ALEN]);
+void brcmf_flowring_add_tdls_peer(struct brcmf_flowring *flow, int ifidx,
+				  u8 peer[ETH_ALEN]);
 
 
 #endif /* BRCMFMAC_FLOWRING_H */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index fad77dd..4f1daab 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -293,7 +293,11 @@ static void brcmf_fweh_event_worker(struct work_struct *work)
 			goto event_free;
 		}
 
-		ifp = drvr->iflist[emsg.bsscfgidx];
+		if ((event->code == BRCMF_E_TDLS_PEER_EVENT) &&
+		    (emsg.bsscfgidx == 1))
+			ifp = drvr->iflist[0];
+		else
+			ifp = drvr->iflist[emsg.bsscfgidx];
 		err = brcmf_fweh_call_event_handler(ifp, event->code, &emsg,
 						    event->data);
 		if (err) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
index 51b53a7..dd20b18 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
@@ -102,6 +102,7 @@ struct brcmf_event;
 	BRCMF_ENUM_DEF(DCS_REQUEST, 73) \
 	BRCMF_ENUM_DEF(FIFO_CREDIT_MAP, 74) \
 	BRCMF_ENUM_DEF(ACTION_FRAME_RX, 75) \
+	BRCMF_ENUM_DEF(TDLS_PEER_EVENT, 92) \
 	BRCMF_ENUM_DEF(BCMC_CREDIT_SUPPORT, 127) \
 	BRCMF_ENUM_DEF(PSTA_PRIMARY_INTF_IND, 128)
 
@@ -155,6 +156,10 @@ enum brcmf_fweh_event_code {
 #define BRCMF_E_REASON_TSPEC_REJECTED		7
 #define BRCMF_E_REASON_BETTER_AP		8
 
+#define BRCMF_E_REASON_TDLS_PEER_DISCOVERED	0
+#define BRCMF_E_REASON_TDLS_PEER_CONNECTED	1
+#define BRCMF_E_REASON_TDLS_PEER_DISCONNECTED	2
+
 /* action field values for brcmf_ifevent */
 #define BRCMF_E_IF_ADD				1
 #define BRCMF_E_IF_DEL				2
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index 4dd6890..01ac387 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -752,6 +752,15 @@ brcmf_msgbuf_delete_peer(struct brcmf_pub *drvr, int ifidx, u8 peer[ETH_ALEN])
 
 
 static void
+brcmf_msgbuf_add_tdls_peer(struct brcmf_pub *drvr, int ifidx, u8 peer[ETH_ALEN])
+{
+	struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
+
+	brcmf_flowring_add_tdls_peer(msgbuf->flow, ifidx, peer);
+}
+
+
+static void
 brcmf_msgbuf_process_ioctl_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 {
 	struct msgbuf_ioctl_resp_hdr *ioctl_resp;
@@ -1298,6 +1307,7 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	drvr->proto->txdata = brcmf_msgbuf_txdata;
 	drvr->proto->configure_addr_mode = brcmf_msgbuf_configure_addr_mode;
 	drvr->proto->delete_peer = brcmf_msgbuf_delete_peer;
+	drvr->proto->add_tdls_peer = brcmf_msgbuf_add_tdls_peer;
 	drvr->proto->pd = msgbuf;
 
 	init_waitqueue_head(&msgbuf->ioctl_resp_wait);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/proto.c b/drivers/net/wireless/brcm80211/brcmfmac/proto.c
index 44b1cb4..62b9407 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/proto.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/proto.c
@@ -54,7 +54,7 @@ int brcmf_proto_attach(struct brcmf_pub *drvr)
 	if ((proto->txdata == NULL) || (proto->hdrpull == NULL) ||
 	    (proto->query_dcmd == NULL) || (proto->set_dcmd == NULL) ||
 	    (proto->configure_addr_mode == NULL) ||
-	    (proto->delete_peer == NULL)) {
+	    (proto->delete_peer == NULL) || (proto->add_tdls_peer == NULL)) {
 		brcmf_err("Not all proto handlers have been installed\n");
 		goto fail;
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/proto.h b/drivers/net/wireless/brcm80211/brcmfmac/proto.h
index 55942e3..971172ff 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/proto.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/proto.h
@@ -36,6 +36,8 @@ struct brcmf_proto {
 				    enum proto_addr_mode addr_mode);
 	void (*delete_peer)(struct brcmf_pub *drvr, int ifidx,
 			    u8 peer[ETH_ALEN]);
+	void (*add_tdls_peer)(struct brcmf_pub *drvr, int ifidx,
+			      u8 peer[ETH_ALEN]);
 	void *pd;
 };
 
@@ -74,6 +76,11 @@ brcmf_proto_delete_peer(struct brcmf_pub *drvr, int ifidx, u8 peer[ETH_ALEN])
 {
 	drvr->proto->delete_peer(drvr, ifidx, peer);
 }
+static inline void
+brcmf_proto_add_tdls_peer(struct brcmf_pub *drvr, int ifidx, u8 peer[ETH_ALEN])
+{
+	drvr->proto->add_tdls_peer(drvr, ifidx, peer);
+}
 
 
 #endif /* BRCMFMAC_PROTO_H */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index a0e555a..02fe706 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4155,6 +4155,27 @@ static void brcmf_cfg80211_crit_proto_stop(struct wiphy *wiphy,
 	clear_bit(BRCMF_SCAN_STATUS_SUPPRESS, &cfg->scan_status);
 }
 
+static s32
+brcmf_notify_tdls_peer_event(struct brcmf_if *ifp,
+			     const struct brcmf_event_msg *e, void *data)
+{
+	switch (e->reason) {
+	case BRCMF_E_REASON_TDLS_PEER_DISCOVERED:
+		brcmf_dbg(TRACE, "TDLS Peer Discovered\n");
+		break;
+	case BRCMF_E_REASON_TDLS_PEER_CONNECTED:
+		brcmf_dbg(TRACE, "TDLS Peer Connected\n");
+		brcmf_proto_add_tdls_peer(ifp->drvr, ifp->ifidx, (u8 *)e->addr);
+		break;
+	case BRCMF_E_REASON_TDLS_PEER_DISCONNECTED:
+		brcmf_dbg(TRACE, "TDLS Peer Disconnected\n");
+		brcmf_proto_delete_peer(ifp->drvr, ifp->ifidx, (u8 *)e->addr);
+		break;
+	}
+
+	return 0;
+}
+
 static int brcmf_convert_nl80211_tdls_oper(enum nl80211_tdls_operation oper)
 {
 	int ret;
@@ -5691,6 +5712,9 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	if (err) {
 		brcmf_dbg(INFO, "TDLS not enabled (%d)\n", err);
 		wiphy->flags &= ~WIPHY_FLAG_SUPPORTS_TDLS;
+	} else {
+		brcmf_fweh_register(cfg->pub, BRCMF_E_TDLS_PEER_EVENT,
+				    brcmf_notify_tdls_peer_event);
 	}
 
 	return cfg;
-- 
1.9.1

