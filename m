Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:46007 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933598AbdCJVR0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 16:17:26 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 3/5] brcmfmac: wrap brcmf_fws_add_interface into bcdc layer
Date: Fri, 10 Mar 2017 21:17:04 +0000
Message-Id: <1489180626-6722-4-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170310_221741_606032_E5604ECA)
In-Reply-To: <1489180626-6722-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1489180626-6722-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <franky.lin@broadcom.com>

fwsignal is only used by bcdc. Create a new protocol interface function
brcmf_proto_add_if for core module to notify protocol layer upon a new
interface is created.

Signed-off-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c  | 7 +++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c  | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c  | 3 ++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h | 9 +++++++++
 4 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index bee70f3..2e678a3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -399,6 +399,12 @@ static void brcmf_proto_bcdc_rxreorder(struct brcmf_if *ifp,
 	brcmf_fws_rxreorder(ifp, skb);
 }
 
+static void
+brcmf_proto_bcdc_add_if(struct brcmf_if *ifp)
+{
+	brcmf_fws_add_interface(ifp);
+}
+
 int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 {
 	struct brcmf_bcdc *bcdc;
@@ -422,6 +428,7 @@ int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 	drvr->proto->delete_peer = brcmf_proto_bcdc_delete_peer;
 	drvr->proto->add_tdls_peer = brcmf_proto_bcdc_add_tdls_peer;
 	drvr->proto->rxreorder = brcmf_proto_bcdc_rxreorder;
+	drvr->proto->add_if = brcmf_proto_bcdc_add_if;
 	drvr->proto->pd = bcdc;
 
 	drvr->hdrlen += BCDC_HEADER_LEN + BRCMF_PROT_FW_SIGNAL_MAX_TXBYTES;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index a68e1af..794a9f6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -968,7 +968,7 @@ int brcmf_bus_started(struct device *dev)
 	if (ret < 0)
 		goto fail;
 
-	brcmf_fws_add_interface(ifp);
+	brcmf_proto_add_if(drvr, ifp);
 
 	drvr->config = brcmf_cfg80211_attach(drvr, bus_if->dev,
 					     drvr->settings->p2p_enable);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index c79306b..f63f36f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -25,6 +25,7 @@
 #include "fwsignal.h"
 #include "fweh.h"
 #include "fwil.h"
+#include "proto.h"
 
 /**
  * struct brcmf_fweh_queue_item - event item on event queue.
@@ -172,7 +173,7 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 		if (IS_ERR(ifp))
 			return;
 		if (!is_p2pdev)
-			brcmf_fws_add_interface(ifp);
+			brcmf_proto_add_if(drvr, ifp);
 		if (!drvr->fweh.evt_handler[BRCMF_E_IF])
 			if (brcmf_net_attach(ifp, false) < 0)
 				return;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
index 34b59fe..3d001f3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
@@ -44,6 +44,7 @@ struct brcmf_proto {
 	void (*add_tdls_peer)(struct brcmf_pub *drvr, int ifidx,
 			      u8 peer[ETH_ALEN]);
 	void (*rxreorder)(struct brcmf_if *ifp, struct sk_buff *skb);
+	void (*add_if)(struct brcmf_if *ifp);
 	void *pd;
 };
 
@@ -118,4 +119,12 @@ static inline bool brcmf_proto_is_reorder_skb(struct sk_buff *skb)
 	ifp->drvr->proto->rxreorder(ifp, skb);
 }
 
+static inline void
+brcmf_proto_add_if(struct brcmf_pub *drvr, struct brcmf_if *ifp)
+{
+	if (!drvr->proto->add_if)
+		return;
+	drvr->proto->add_if(ifp);
+}
+
 #endif /* BRCMFMAC_PROTO_H */
-- 
1.9.1
