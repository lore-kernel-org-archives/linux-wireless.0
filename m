Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:46005 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933640AbdCJVR0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 16:17:26 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 4/5] brcmfmac: wrap brcmf_fws_del_interface into bcdc layer
Date: Fri, 10 Mar 2017 21:17:05 +0000
Message-Id: <1489180626-6722-5-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170310_221742_148783_05FFC0F0)
In-Reply-To: <1489180626-6722-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1489180626-6722-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <franky.lin@broadcom.com>

Create a new protocol interface function brcmf_proto_del_if for core
module to notify protocol layer upon interface deletion.

Signed-off-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c  | 7 +++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c  | 4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h | 9 +++++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index 2e678a3..ae04125 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -405,6 +405,12 @@ static void brcmf_proto_bcdc_rxreorder(struct brcmf_if *ifp,
 	brcmf_fws_add_interface(ifp);
 }
 
+static void
+brcmf_proto_bcdc_del_if(struct brcmf_if *ifp)
+{
+	brcmf_fws_del_interface(ifp);
+}
+
 int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 {
 	struct brcmf_bcdc *bcdc;
@@ -429,6 +435,7 @@ int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 	drvr->proto->add_tdls_peer = brcmf_proto_bcdc_add_tdls_peer;
 	drvr->proto->rxreorder = brcmf_proto_bcdc_rxreorder;
 	drvr->proto->add_if = brcmf_proto_bcdc_add_if;
+	drvr->proto->del_if = brcmf_proto_bcdc_del_if;
 	drvr->proto->pd = bcdc;
 
 	drvr->hdrlen += BCDC_HEADER_LEN + BRCMF_PROT_FW_SIGNAL_MAX_TXBYTES;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 794a9f6..5bb0378 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -706,7 +706,7 @@ void brcmf_remove_interface(struct brcmf_if *ifp, bool rtnl_locked)
 		return;
 	brcmf_dbg(TRACE, "Enter, bsscfgidx=%d, ifidx=%d\n", ifp->bsscfgidx,
 		  ifp->ifidx);
-	brcmf_fws_del_interface(ifp);
+	brcmf_proto_del_if(ifp->drvr, ifp);
 	brcmf_del_if(ifp->drvr, ifp->bsscfgidx, rtnl_locked);
 }
 
@@ -1013,7 +1013,7 @@ int brcmf_bus_started(struct device *dev)
 		drvr->config = NULL;
 	}
 	if (drvr->fws) {
-		brcmf_fws_del_interface(ifp);
+		brcmf_proto_del_if(ifp->drvr, ifp);
 		brcmf_fws_deinit(drvr);
 	}
 	brcmf_net_detach(ifp->ndev, false);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
index 3d001f3..2c76c96 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
@@ -45,6 +45,7 @@ struct brcmf_proto {
 			      u8 peer[ETH_ALEN]);
 	void (*rxreorder)(struct brcmf_if *ifp, struct sk_buff *skb);
 	void (*add_if)(struct brcmf_if *ifp);
+	void (*del_if)(struct brcmf_if *ifp);
 	void *pd;
 };
 
@@ -127,4 +128,12 @@ static inline bool brcmf_proto_is_reorder_skb(struct sk_buff *skb)
 	drvr->proto->add_if(ifp);
 }
 
+static inline void
+brcmf_proto_del_if(struct brcmf_pub *drvr, struct brcmf_if *ifp)
+{
+	if (!drvr->proto->del_if)
+		return;
+	drvr->proto->del_if(ifp);
+}
+
 #endif /* BRCMFMAC_PROTO_H */
-- 
1.9.1
