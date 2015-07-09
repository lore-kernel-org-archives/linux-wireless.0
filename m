Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:35393 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbbGISBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 14:01:33 -0400
Received: by lblf12 with SMTP id f12so10068869lbl.2
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 11:01:32 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: WARNING: brcmfmac/core.c:1144 brcmf_netdev_wait_pend8021x
Date: Thu,  9 Jul 2015 20:01:23 +0200
Message-Id: <1436464883-10504-1-git-send-email-zajec5@gmail.com> (sfid-20150709_200146_440816_E8744C4F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello again.

After fixing user space <-> brcmfmac communication for using valid MACs:
[PATCH] brcmfmac: set wiphy's addresses to provide valid MACs
i started testing multiple interfaces.

It seems there are many bugs in brcmfmac :(

So after running 3 AP interfaces and switching my STA device between them I
started seeing WARNINGs triggered by brcmf_netdev_wait_pend8021x. It was
brcmf_cfg80211_del_key that was calling above function.

The problem is that brcmf_netdev_start_xmit increases interfaces's
pend_8021x_cnt on every transmission of ETH_P_PAE but brcmf_txfinalize fails
(from time to time?) do decrease it.

There is a bug in brcmf_txfinalize that stops it from finding an interface for
the received TX transmission success. I added some debugging to brcmfmac as you
can see below and this is what I got:
[   39.394022] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE skb:c72c1dc0 on ifidx:0
[   39.413251] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE skb:c72c1dc0 on ifidx:2
[   39.421887] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE skb:c725a7c0 on ifidx:1
[   39.431720] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE skb:c6a78a00 on ifidx:0
[   39.442829] brcmfmac: [brcmf_txfinalize] Finalized ETH_P_PAE skb:c725a7c0 but got invalid ifidx:1
[   39.451773] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE skb:c726ee80 on ifidx:2
[   39.460384] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE skb:c725a7c0 on ifidx:1
[   39.536224] brcmfmac: [brcmf_txfinalize] Finalized ETH_P_PAE skb:c725a7c0 but got invalid ifidx:1
[   51.884737] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE skb:c714cd00 on ifidx:1
[   51.895577] brcmfmac: [brcmf_txfinalize] Finalized ETH_P_PAE skb:c714cd00 but got invalid ifidx:1
[   51.904592] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE skb:c707de80 on ifidx:2
[   51.913195] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE skb:c7011e80 on ifidx:0
[   51.922900] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE skb:c725a280 on ifidx:1
[   51.933988] brcmfmac: [brcmf_txfinalize] Finalized ETH_P_PAE skb:c725a280 but got invalid ifidx:1
[   51.942979] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE skb:c714cd00 on ifidx:2
[   51.951602] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE skb:c707de80 on ifidx:0
[   55.228402] brcmfmac: [brcmf_netdev_wait_pend8021x] WARNING pend_8021x_cnt:4
[   55.278395] brcmfmac: [brcmf_netdev_wait_pend8021x] WARNING pend_8021x_cnt:4
[   55.328394] brcmfmac: [brcmf_netdev_wait_pend8021x] WARNING pend_8021x_cnt:4
[   55.336211] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE skb:c7070b80 on ifidx:2
[   55.347075] brcmfmac: [brcmf_txfinalize] Finalized ETH_P_PAE skb:c7070b80 and decreased pend_8021x_cnt for ifidx:2 but got negative count -1!
[   55.387991] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE skb:c6a78a00 on ifidx:1
[   55.396601] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE skb:c7070b80 on ifidx:0
[   55.406245] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE skb:c707d400 on ifidx:2
[   55.417257] brcmfmac: [brcmf_txfinalize] Finalized ETH_P_PAE skb:c6a78a00 but got invalid ifidx:1
[   55.426144] brcmfmac: [brcmf_txfinalize] Finalized ETH_P_PAE skb:c707d400 and decreased pend_8021x_cnt for ifidx:2 but got negative count -1!
[   55.439019] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE skb:c714cd00 on ifidx:1
[   55.447611] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE skb:c72c2580 on ifidx:0
[   55.498397] brcmfmac: [brcmf_netdev_wait_pend8021x] WARNING pend_8021x_cnt:6
[   55.504785] brcmfmac: [brcmf_txfinalize] Finalized ETH_P_PAE skb:c714cd00 but got invalid ifidx:1

As you can see brcmf_txfinalize fails to find interface for ifidx:1. Why is
that? It seems that drvr->iflist is an array indexed by bssidx, but
brcmf_txfinalize uses ifidx to access it. Obviously ifidx != bssidx.

This also results in decreasing pend_8021x_cnt for wrong interfaces and some
negative values.

Will you fix this?
---
 drivers/net/wireless/brcm80211/brcmfmac/core.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index 5663870..e521ce5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -238,8 +238,10 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		goto done;
 	}
 
-	if (eh->h_proto == htons(ETH_P_PAE))
+	if (eh->h_proto == htons(ETH_P_PAE)) {
+		pr_info("[%s] Transmitting ETH_P_PAE skb:%p on ifidx:%d\n", __FUNCTION__, skb, ifp->ifidx);
 		atomic_inc(&ifp->pend_8021x_cnt);
+	}
 
 	ret = brcmf_fws_process_skb(ifp, skb);
 
@@ -543,6 +545,8 @@ void brcmf_rx_frame(struct device *dev, struct sk_buff *skb)
 		brcmf_netif_rx(ifp, skb);
 }
 
+static int brcmf_get_pend_8021x_cnt(struct brcmf_if *ifp);
+
 void brcmf_txfinalize(struct brcmf_pub *drvr, struct sk_buff *txp, u8 ifidx,
 		      bool success)
 {
@@ -551,14 +555,24 @@ void brcmf_txfinalize(struct brcmf_pub *drvr, struct sk_buff *txp, u8 ifidx,
 	u16 type;
 
 	ifp = drvr->iflist[ifidx];
-	if (!ifp)
+	if (!ifp) {
+		eh = (struct ethhdr *)(txp->data);
+		type = ntohs(eh->h_proto);
+
+		if (type == ETH_P_PAE) {
+			pr_warn("[%s] Finalized ETH_P_PAE skb:%p but got invalid ifidx:%d\n", __FUNCTION__, txp, ifidx);
+		}
+
 		goto done;
+	}
 
 	eh = (struct ethhdr *)(txp->data);
 	type = ntohs(eh->h_proto);
 
 	if (type == ETH_P_PAE) {
 		atomic_dec(&ifp->pend_8021x_cnt);
+		if (brcmf_get_pend_8021x_cnt(ifp) < 0)
+			pr_warn("[%s] Finalized ETH_P_PAE skb:%p and decreased pend_8021x_cnt for ifidx:%d but got negative count %d!\n", __FUNCTION__, txp, ifidx, brcmf_get_pend_8021x_cnt(ifp));
 		if (waitqueue_active(&ifp->pend_8021x_wait))
 			wake_up(&ifp->pend_8021x_wait);
 	}
@@ -1140,8 +1154,8 @@ int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp)
 	err = wait_event_timeout(ifp->pend_8021x_wait,
 				 !brcmf_get_pend_8021x_cnt(ifp),
 				 msecs_to_jiffies(MAX_WAIT_FOR_8021X_TX));
-
-	WARN_ON(!err);
+	if (!err)
+		pr_err("[%s] WARNING pend_8021x_cnt:%d\n", __FUNCTION__, brcmf_get_pend_8021x_cnt(ifp));
 
 	return !err;
 }
-- 
1.8.4.5

