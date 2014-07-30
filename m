Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:56709 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbaG3LUP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2014 07:20:15 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 3/8] brcmfmac: Add protocol addressing mode and peer deletion API.
Date: Wed, 30 Jul 2014 13:20:02 +0200
Message-ID: <1406719207-5126-4-git-send-email-arend@broadcom.com> (sfid-20140730_132025_199470_E3133C8D)
In-Reply-To: <1406719207-5126-1-git-send-email-arend@broadcom.com>
References: <1406719207-5126-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The soon to be added protocol msgbuf requires information about
interface addressing mode and peer deletion. This patch adds the
necessary APIs to proto, implements dummy functions in BCDC and
adds calls to proto wherever necessary by wl_cfg80211.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c     | 13 +++++++++
 drivers/net/wireless/brcm80211/brcmfmac/proto.c    |  8 +++++-
 drivers/net/wireless/brcm80211/brcmfmac/proto.h    | 24 +++++++++++++++-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  | 33 +++++++++++++++++++++-
 4 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
index c229210..10b48c2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
@@ -337,6 +337,17 @@ brcmf_proto_bcdc_txdata(struct brcmf_pub *drvr, int ifidx, u8 offset,
 	return brcmf_bus_txdata(drvr->bus_if, pktbuf);
 }
 
+static void
+brcmf_proto_bcdc_configure_addr_mode(struct brcmf_pub *drvr, int ifidx,
+				     enum proto_addr_mode addr_mode)
+{
+}
+
+static void
+brcmf_proto_bcdc_delete_peer(struct brcmf_pub *drvr, int ifidx,
+			     u8 peer[ETH_ALEN])
+{
+}
 
 int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 {
@@ -356,6 +367,8 @@ int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 	drvr->proto->query_dcmd = brcmf_proto_bcdc_query_dcmd;
 	drvr->proto->set_dcmd = brcmf_proto_bcdc_set_dcmd;
 	drvr->proto->txdata = brcmf_proto_bcdc_txdata;
+	drvr->proto->configure_addr_mode = brcmf_proto_bcdc_configure_addr_mode;
+	drvr->proto->delete_peer = brcmf_proto_bcdc_delete_peer;
 	drvr->proto->pd = bcdc;
 
 	drvr->hdrlen += BCDC_HEADER_LEN + BRCMF_PROT_FW_SIGNAL_MAX_TXBYTES;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/proto.c b/drivers/net/wireless/brcm80211/brcmfmac/proto.c
index b6b4641..d333ff8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/proto.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/proto.c
@@ -30,6 +30,8 @@ int brcmf_proto_attach(struct brcmf_pub *drvr)
 {
 	struct brcmf_proto *proto;
 
+	brcmf_dbg(TRACE, "Enter\n");
+
 	proto = kzalloc(sizeof(*proto), GFP_ATOMIC);
 	if (!proto)
 		goto fail;
@@ -40,7 +42,9 @@ int brcmf_proto_attach(struct brcmf_pub *drvr)
 		goto fail;
 
 	if ((proto->txdata == NULL) || (proto->hdrpull == NULL) ||
-	    (proto->query_dcmd == NULL) || (proto->set_dcmd == NULL)) {
+	    (proto->query_dcmd == NULL) || (proto->set_dcmd == NULL) ||
+	    (proto->configure_addr_mode == NULL) ||
+	    (proto->delete_peer == NULL)) {
 		brcmf_err("Not all proto handlers have been installed\n");
 		goto fail;
 	}
@@ -54,6 +58,8 @@ fail:
 
 void brcmf_proto_detach(struct brcmf_pub *drvr)
 {
+	brcmf_dbg(TRACE, "Enter\n");
+
 	if (drvr->proto) {
 		brcmf_proto_bcdc_detach(drvr);
 		kfree(drvr->proto);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/proto.h b/drivers/net/wireless/brcm80211/brcmfmac/proto.h
index 482fb0b..55942e3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/proto.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/proto.h
@@ -16,6 +16,13 @@
 #ifndef BRCMFMAC_PROTO_H
 #define BRCMFMAC_PROTO_H
 
+
+enum proto_addr_mode {
+	ADDR_INDIRECT	= 0,
+	ADDR_DIRECT
+};
+
+
 struct brcmf_proto {
 	int (*hdrpull)(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
 		       struct sk_buff *skb);
@@ -25,6 +32,10 @@ struct brcmf_proto {
 			uint len);
 	int (*txdata)(struct brcmf_pub *drvr, int ifidx, u8 offset,
 		      struct sk_buff *skb);
+	void (*configure_addr_mode)(struct brcmf_pub *drvr, int ifidx,
+				    enum proto_addr_mode addr_mode);
+	void (*delete_peer)(struct brcmf_pub *drvr, int ifidx,
+			    u8 peer[ETH_ALEN]);
 	void *pd;
 };
 
@@ -48,10 +59,21 @@ static inline int brcmf_proto_set_dcmd(struct brcmf_pub *drvr, int ifidx,
 	return drvr->proto->set_dcmd(drvr, ifidx, cmd, buf, len);
 }
 static inline int brcmf_proto_txdata(struct brcmf_pub *drvr, int ifidx,
-				       u8 offset, struct sk_buff *skb)
+				     u8 offset, struct sk_buff *skb)
 {
 	return drvr->proto->txdata(drvr, ifidx, offset, skb);
 }
+static inline void
+brcmf_proto_configure_addr_mode(struct brcmf_pub *drvr, int ifidx,
+				enum proto_addr_mode addr_mode)
+{
+	drvr->proto->configure_addr_mode(drvr, ifidx, addr_mode);
+}
+static inline void
+brcmf_proto_delete_peer(struct brcmf_pub *drvr, int ifidx, u8 peer[ETH_ALEN])
+{
+	drvr->proto->delete_peer(drvr, ifidx, peer);
+}
 
 
 #endif /* BRCMFMAC_PROTO_H */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 48078a3..a0e555a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -35,6 +35,7 @@
 #include "wl_cfg80211.h"
 #include "feature.h"
 #include "fwil.h"
+#include "proto.h"
 #include "vendor.h"
 
 #define BRCMF_SCAN_IE_LEN_MAX		2048
@@ -493,6 +494,22 @@ brcmf_configure_arp_offload(struct brcmf_if *ifp, bool enable)
 	return err;
 }
 
+static void
+brcmf_cfg80211_update_proto_addr_mode(struct wireless_dev *wdev)
+{
+	struct net_device *ndev = wdev->netdev;
+	struct brcmf_if *ifp = netdev_priv(ndev);
+
+	if ((wdev->iftype == NL80211_IFTYPE_ADHOC) ||
+	    (wdev->iftype == NL80211_IFTYPE_AP) ||
+	    (wdev->iftype == NL80211_IFTYPE_P2P_GO))
+		brcmf_proto_configure_addr_mode(ifp->drvr, ifp->ifidx,
+						ADDR_DIRECT);
+	else
+		brcmf_proto_configure_addr_mode(ifp->drvr, ifp->ifidx,
+						ADDR_INDIRECT);
+}
+
 static bool brcmf_is_apmode(struct brcmf_cfg80211_vif *vif)
 {
 	enum nl80211_iftype iftype;
@@ -512,6 +529,8 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 						     u32 *flags,
 						     struct vif_params *params)
 {
+	struct wireless_dev *wdev;
+
 	brcmf_dbg(TRACE, "enter: %s type %d\n", name, type);
 	switch (type) {
 	case NL80211_IFTYPE_ADHOC:
@@ -525,7 +544,10 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_P2P_DEVICE:
-		return brcmf_p2p_add_vif(wiphy, name, type, flags, params);
+		wdev = brcmf_p2p_add_vif(wiphy, name, type, flags, params);
+		if (!IS_ERR(wdev))
+			brcmf_cfg80211_update_proto_addr_mode(wdev);
+		return wdev;
 	case NL80211_IFTYPE_UNSPECIFIED:
 	default:
 		return ERR_PTR(-EINVAL);
@@ -720,6 +742,8 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	}
 	ndev->ieee80211_ptr->iftype = type;
 
+	brcmf_cfg80211_update_proto_addr_mode(&vif->wdev);
+
 done:
 	brcmf_dbg(TRACE, "Exit\n");
 
@@ -4525,6 +4549,13 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 	struct ieee80211_channel *chan;
 	s32 err = 0;
 
+	if ((e->event_code == BRCMF_E_DEAUTH) ||
+	    (e->event_code == BRCMF_E_DEAUTH_IND) ||
+	    (e->event_code == BRCMF_E_DISASSOC_IND) ||
+	    ((e->event_code == BRCMF_E_LINK) && (!e->flags))) {
+		brcmf_proto_delete_peer(ifp->drvr, ifp->ifidx, (u8 *)e->addr);
+	}
+
 	if (brcmf_is_apmode(ifp->vif)) {
 		err = brcmf_notify_connect_status_ap(cfg, ndev, e, data);
 	} else if (brcmf_is_linkup(e)) {
-- 
1.9.1

