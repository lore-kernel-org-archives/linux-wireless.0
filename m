Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:56626 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbcDKJpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 05:45:22 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 8/8] brcmfmac: create common function for handling brcmf_proto_hdrpull()
Date: Mon, 11 Apr 2016 11:35:28 +0200
Message-Id: <1460367328-12082-9-git-send-email-arend@broadcom.com> (sfid-20160411_114525_764885_46557956)
In-Reply-To: <1460367328-12082-1-git-send-email-arend@broadcom.com>
References: <1460367328-12082-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In receive path brcmf_proto_hdrpull() needs to be called and handled
similar in brcmf_rx_frame() and brcmf_rx_event(). Move that duplicated
code in separate function.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 43 +++++++++++-----------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 9b53555..1b476d1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -322,26 +322,35 @@ void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
 		netif_rx_ni(skb);
 }
 
-void brcmf_rx_frame(struct device *dev, struct sk_buff *skb, bool handle_event)
+static int brcmf_rx_hdrpull(struct brcmf_pub *drvr, struct sk_buff *skb,
+			    struct brcmf_if **ifp)
 {
-	struct brcmf_if *ifp;
-	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_pub *drvr = bus_if->drvr;
 	int ret;
 
-	brcmf_dbg(DATA, "Enter: %s: rxp=%p\n", dev_name(dev), skb);
-
 	/* process and remove protocol-specific header */
-	ret = brcmf_proto_hdrpull(drvr, true, skb, &ifp);
+	ret = brcmf_proto_hdrpull(drvr, true, skb, ifp);
 
-	if (ret || !ifp || !ifp->ndev) {
+	if (ret || !(*ifp) || !(*ifp)->ndev) {
 		if (ret != -ENODATA && ifp)
-			ifp->stats.rx_errors++;
+			(*ifp)->stats.rx_errors++;
 		brcmu_pkt_buf_free_skb(skb);
-		return;
+		return -ENODATA;
 	}
 
-	skb->protocol = eth_type_trans(skb, ifp->ndev);
+	skb->protocol = eth_type_trans(skb, (*ifp)->ndev);
+	return 0;
+}
+
+void brcmf_rx_frame(struct device *dev, struct sk_buff *skb, bool handle_event)
+{
+	struct brcmf_if *ifp;
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pub *drvr = bus_if->drvr;
+
+	brcmf_dbg(DATA, "Enter: %s: rxp=%p\n", dev_name(dev), skb);
+
+	if (brcmf_rx_hdrpull(drvr, skb, &ifp))
+		return;
 
 	if (brcmf_proto_is_reorder_skb(skb)) {
 		brcmf_proto_rxreorder(ifp, skb);
@@ -359,21 +368,11 @@ void brcmf_rx_event(struct device *dev, struct sk_buff *skb)
 	struct brcmf_if *ifp;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
-	int ret;
 
 	brcmf_dbg(EVENT, "Enter: %s: rxp=%p\n", dev_name(dev), skb);
 
-	/* process and remove protocol-specific header */
-	ret = brcmf_proto_hdrpull(drvr, true, skb, &ifp);
-
-	if (ret || !ifp || !ifp->ndev) {
-		if (ret != -ENODATA && ifp)
-			ifp->stats.rx_errors++;
-		brcmu_pkt_buf_free_skb(skb);
+	if (brcmf_rx_hdrpull(drvr, skb, &ifp))
 		return;
-	}
-
-	skb->protocol = eth_type_trans(skb, ifp->ndev);
 
 	brcmf_fweh_process_skb(ifp->drvr, skb);
 	brcmu_pkt_buf_free_skb(skb);
-- 
1.9.1

