Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:7416 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbbGJSbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 14:31:21 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 3/7] brcmfmac: Increase nr of supported flowrings.
Date: Fri, 10 Jul 2015 20:31:07 +0200
Message-ID: <1436553071-32423-4-git-send-email-arend@broadcom.com> (sfid-20150710_203128_526178_A625F285)
In-Reply-To: <1436553071-32423-1-git-send-email-arend@broadcom.com>
References: <1436553071-32423-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Next generation devices will have firmware which will have more
than 256 flowrings. This patch increases the maximum number of
supported flowrings to 512.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c | 38 ++++++++++++----------
 drivers/net/wireless/brcm80211/brcmfmac/flowring.h | 20 ++++++------
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   | 11 +++++--
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h   |  2 +-
 4 files changed, 41 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
index 5944063..e30f8fa 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
@@ -32,7 +32,7 @@
 #define BRCMF_FLOWRING_LOW		(BRCMF_FLOWRING_HIGH - 256)
 #define BRCMF_FLOWRING_INVALID_IFIDX	0xff
 
-#define BRCMF_FLOWRING_HASH_AP(da, fifo, ifidx) (da[5] + fifo + ifidx * 16)
+#define BRCMF_FLOWRING_HASH_AP(da, fifo, ifidx) (da[5] * 2 + fifo + ifidx * 16)
 #define BRCMF_FLOWRING_HASH_STA(fifo, ifidx) (fifo + ifidx * 16)
 
 static const u8 brcmf_flowring_prio2fifo[] = {
@@ -68,7 +68,7 @@ u32 brcmf_flowring_lookup(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 			  u8 prio, u8 ifidx)
 {
 	struct brcmf_flowring_hash *hash;
-	u8 hash_idx;
+	u16 hash_idx;
 	u32 i;
 	bool found;
 	bool sta;
@@ -88,6 +88,7 @@ u32 brcmf_flowring_lookup(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 	}
 	hash_idx =  sta ? BRCMF_FLOWRING_HASH_STA(fifo, ifidx) :
 			  BRCMF_FLOWRING_HASH_AP(mac, fifo, ifidx);
+	hash_idx &= (BRCMF_FLOWRING_HASHSIZE - 1);
 	found = false;
 	hash = flow->hash;
 	for (i = 0; i < BRCMF_FLOWRING_HASHSIZE; i++) {
@@ -98,6 +99,7 @@ u32 brcmf_flowring_lookup(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 			break;
 		}
 		hash_idx++;
+		hash_idx &= (BRCMF_FLOWRING_HASHSIZE - 1);
 	}
 	if (found)
 		return hash[hash_idx].flowid;
@@ -111,7 +113,7 @@ u32 brcmf_flowring_create(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 {
 	struct brcmf_flowring_ring *ring;
 	struct brcmf_flowring_hash *hash;
-	u8 hash_idx;
+	u16 hash_idx;
 	u32 i;
 	bool found;
 	u8 fifo;
@@ -131,6 +133,7 @@ u32 brcmf_flowring_create(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 	}
 	hash_idx =  sta ? BRCMF_FLOWRING_HASH_STA(fifo, ifidx) :
 			  BRCMF_FLOWRING_HASH_AP(mac, fifo, ifidx);
+	hash_idx &= (BRCMF_FLOWRING_HASHSIZE - 1);
 	found = false;
 	hash = flow->hash;
 	for (i = 0; i < BRCMF_FLOWRING_HASHSIZE; i++) {
@@ -140,6 +143,7 @@ u32 brcmf_flowring_create(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 			break;
 		}
 		hash_idx++;
+		hash_idx &= (BRCMF_FLOWRING_HASHSIZE - 1);
 	}
 	if (found) {
 		for (i = 0; i < flow->nrofrings; i++) {
@@ -169,7 +173,7 @@ u32 brcmf_flowring_create(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 }
 
 
-u8 brcmf_flowring_tid(struct brcmf_flowring *flow, u8 flowid)
+u8 brcmf_flowring_tid(struct brcmf_flowring *flow, u16 flowid)
 {
 	struct brcmf_flowring_ring *ring;
 
@@ -179,7 +183,7 @@ u8 brcmf_flowring_tid(struct brcmf_flowring *flow, u8 flowid)
 }
 
 
-static void brcmf_flowring_block(struct brcmf_flowring *flow, u8 flowid,
+static void brcmf_flowring_block(struct brcmf_flowring *flow, u16 flowid,
 				 bool blocked)
 {
 	struct brcmf_flowring_ring *ring;
@@ -224,10 +228,10 @@ static void brcmf_flowring_block(struct brcmf_flowring *flow, u8 flowid,
 }
 
 
-void brcmf_flowring_delete(struct brcmf_flowring *flow, u8 flowid)
+void brcmf_flowring_delete(struct brcmf_flowring *flow, u16 flowid)
 {
 	struct brcmf_flowring_ring *ring;
-	u8 hash_idx;
+	u16 hash_idx;
 	struct sk_buff *skb;
 
 	ring = flow->rings[flowid];
@@ -249,7 +253,7 @@ void brcmf_flowring_delete(struct brcmf_flowring *flow, u8 flowid)
 }
 
 
-u32 brcmf_flowring_enqueue(struct brcmf_flowring *flow, u8 flowid,
+u32 brcmf_flowring_enqueue(struct brcmf_flowring *flow, u16 flowid,
 			   struct sk_buff *skb)
 {
 	struct brcmf_flowring_ring *ring;
@@ -275,7 +279,7 @@ u32 brcmf_flowring_enqueue(struct brcmf_flowring *flow, u8 flowid,
 }
 
 
-struct sk_buff *brcmf_flowring_dequeue(struct brcmf_flowring *flow, u8 flowid)
+struct sk_buff *brcmf_flowring_dequeue(struct brcmf_flowring *flow, u16 flowid)
 {
 	struct brcmf_flowring_ring *ring;
 	struct sk_buff *skb;
@@ -296,7 +300,7 @@ struct sk_buff *brcmf_flowring_dequeue(struct brcmf_flowring *flow, u8 flowid)
 }
 
 
-void brcmf_flowring_reinsert(struct brcmf_flowring *flow, u8 flowid,
+void brcmf_flowring_reinsert(struct brcmf_flowring *flow, u16 flowid,
 			     struct sk_buff *skb)
 {
 	struct brcmf_flowring_ring *ring;
@@ -307,7 +311,7 @@ void brcmf_flowring_reinsert(struct brcmf_flowring *flow, u8 flowid,
 }
 
 
-u32 brcmf_flowring_qlen(struct brcmf_flowring *flow, u8 flowid)
+u32 brcmf_flowring_qlen(struct brcmf_flowring *flow, u16 flowid)
 {
 	struct brcmf_flowring_ring *ring;
 
@@ -322,7 +326,7 @@ u32 brcmf_flowring_qlen(struct brcmf_flowring *flow, u8 flowid)
 }
 
 
-void brcmf_flowring_open(struct brcmf_flowring *flow, u8 flowid)
+void brcmf_flowring_open(struct brcmf_flowring *flow, u16 flowid)
 {
 	struct brcmf_flowring_ring *ring;
 
@@ -336,10 +340,10 @@ void brcmf_flowring_open(struct brcmf_flowring *flow, u8 flowid)
 }
 
 
-u8 brcmf_flowring_ifidx_get(struct brcmf_flowring *flow, u8 flowid)
+u8 brcmf_flowring_ifidx_get(struct brcmf_flowring *flow, u16 flowid)
 {
 	struct brcmf_flowring_ring *ring;
-	u8 hash_idx;
+	u16 hash_idx;
 
 	ring = flow->rings[flowid];
 	hash_idx = ring->hash_id;
@@ -380,7 +384,7 @@ void brcmf_flowring_detach(struct brcmf_flowring *flow)
 	struct brcmf_pub *drvr = bus_if->drvr;
 	struct brcmf_flowring_tdls_entry *search;
 	struct brcmf_flowring_tdls_entry *remove;
-	u8 flowid;
+	u16 flowid;
 
 	for (flowid = 0; flowid < flow->nrofrings; flowid++) {
 		if (flow->rings[flowid])
@@ -404,7 +408,7 @@ void brcmf_flowring_configure_addr_mode(struct brcmf_flowring *flow, int ifidx,
 	struct brcmf_bus *bus_if = dev_get_drvdata(flow->dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
 	u32 i;
-	u8 flowid;
+	u16 flowid;
 
 	if (flow->addr_mode[ifidx] != addr_mode) {
 		for (i = 0; i < ARRAY_SIZE(flow->hash); i++) {
@@ -430,7 +434,7 @@ void brcmf_flowring_delete_peer(struct brcmf_flowring *flow, int ifidx,
 	struct brcmf_flowring_tdls_entry *prev;
 	struct brcmf_flowring_tdls_entry *search;
 	u32 i;
-	u8 flowid;
+	u16 flowid;
 	bool sta;
 
 	sta = (flow->addr_mode[ifidx] == ADDR_INDIRECT);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/flowring.h b/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
index 5551861..3a7d9c2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
@@ -16,7 +16,7 @@
 #define BRCMFMAC_FLOWRING_H
 
 
-#define BRCMF_FLOWRING_HASHSIZE		256
+#define BRCMF_FLOWRING_HASHSIZE		512		/* has to be 2^x */
 #define BRCMF_FLOWRING_INVALID_ID	0xFFFFFFFF
 
 
@@ -24,7 +24,7 @@ struct brcmf_flowring_hash {
 	u8 mac[ETH_ALEN];
 	u8 fifo;
 	u8 ifidx;
-	u8 flowid;
+	u16 flowid;
 };
 
 enum ring_status {
@@ -61,16 +61,16 @@ u32 brcmf_flowring_lookup(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 			  u8 prio, u8 ifidx);
 u32 brcmf_flowring_create(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 			  u8 prio, u8 ifidx);
-void brcmf_flowring_delete(struct brcmf_flowring *flow, u8 flowid);
-void brcmf_flowring_open(struct brcmf_flowring *flow, u8 flowid);
-u8 brcmf_flowring_tid(struct brcmf_flowring *flow, u8 flowid);
-u32 brcmf_flowring_enqueue(struct brcmf_flowring *flow, u8 flowid,
+void brcmf_flowring_delete(struct brcmf_flowring *flow, u16 flowid);
+void brcmf_flowring_open(struct brcmf_flowring *flow, u16 flowid);
+u8 brcmf_flowring_tid(struct brcmf_flowring *flow, u16 flowid);
+u32 brcmf_flowring_enqueue(struct brcmf_flowring *flow, u16 flowid,
 			   struct sk_buff *skb);
-struct sk_buff *brcmf_flowring_dequeue(struct brcmf_flowring *flow, u8 flowid);
-void brcmf_flowring_reinsert(struct brcmf_flowring *flow, u8 flowid,
+struct sk_buff *brcmf_flowring_dequeue(struct brcmf_flowring *flow, u16 flowid);
+void brcmf_flowring_reinsert(struct brcmf_flowring *flow, u16 flowid,
 			     struct sk_buff *skb);
-u32 brcmf_flowring_qlen(struct brcmf_flowring *flow, u8 flowid);
-u8 brcmf_flowring_ifidx_get(struct brcmf_flowring *flow, u8 flowid);
+u32 brcmf_flowring_qlen(struct brcmf_flowring *flow, u16 flowid);
+u8 brcmf_flowring_ifidx_get(struct brcmf_flowring *flow, u16 flowid);
 struct brcmf_flowring *brcmf_flowring_attach(struct device *dev, u16 nrofrings);
 void brcmf_flowring_detach(struct brcmf_flowring *flow);
 void brcmf_flowring_configure_addr_mode(struct brcmf_flowring *flow, int ifidx,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index 898c380..363a31e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -678,7 +678,7 @@ static u32 brcmf_msgbuf_flowring_create(struct brcmf_msgbuf *msgbuf, int ifidx,
 }
 
 
-static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u8 flowid)
+static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u16 flowid)
 {
 	struct brcmf_flowring *flow = msgbuf->flow;
 	struct brcmf_commonring *commonring;
@@ -1318,7 +1318,7 @@ int brcmf_proto_msgbuf_rx_trigger(struct device *dev)
 }
 
 
-void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u8 flowid)
+void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u16 flowid)
 {
 	struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
 	struct msgbuf_tx_flowring_delete_req *delete;
@@ -1369,6 +1369,13 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	u32 count;
 
 	if_msgbuf = drvr->bus_if->msgbuf;
+
+	if (if_msgbuf->nrof_flowrings >= BRCMF_FLOWRING_HASHSIZE) {
+		brcmf_err("driver not configured for this many flowrings %d\n",
+			  if_msgbuf->nrof_flowrings);
+		if_msgbuf->nrof_flowrings = BRCMF_FLOWRING_HASHSIZE - 1;
+	}
+
 	msgbuf = kzalloc(sizeof(*msgbuf), GFP_KERNEL);
 	if (!msgbuf)
 		goto fail;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h
index 3d513e4..ee6906a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h
@@ -33,7 +33,7 @@
 
 
 int brcmf_proto_msgbuf_rx_trigger(struct device *dev);
-void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u8 flowid);
+void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u16 flowid);
 int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr);
 void brcmf_proto_msgbuf_detach(struct brcmf_pub *drvr);
 #else
-- 
1.9.1

