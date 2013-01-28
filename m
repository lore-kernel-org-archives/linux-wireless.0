Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:54326 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab3A1Qi3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 11:38:29 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/14] wil6210: Fix: Tx stall
Date: Mon, 28 Jan 2013 18:31:01 +0200
Message-ID: <1359390669-9310-7-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130128_173832_314301_051CF702)
In-Reply-To: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to multi-tx-queue design, wil_start_xmit() used to be executed
concurrently for different queues. Then, these transmits delivered
to the same queue, creating race.

As result, Tx descriptor may be skipped, causing stall in hardware.

Convert to single Tx queue fixes it.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/netdev.c  |   27 +--------------------------
 drivers/net/wireless/ath/wil6210/wil6210.h |    2 --
 2 files changed, 1 insertion(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 3068b5c..073dc7d 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -35,35 +35,10 @@ static int wil_stop(struct net_device *ndev)
 	return wil_down(wil);
 }
 
-/*
- * AC to queue mapping
- *
- * AC_VO -> queue 3
- * AC_VI -> queue 2
- * AC_BE -> queue 1
- * AC_BK -> queue 0
- */
-static u16 wil_select_queue(struct net_device *ndev, struct sk_buff *skb)
-{
-	static const u16 wil_1d_to_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
-	struct wil6210_priv *wil = ndev_to_wil(ndev);
-	u16 rc;
-
-	skb->priority = cfg80211_classify8021d(skb);
-
-	rc = wil_1d_to_queue[skb->priority];
-
-	wil_dbg_TXRX(wil, "%s() %d -> %d\n", __func__, (int)skb->priority,
-		     (int)rc);
-
-	return rc;
-}
-
 static const struct net_device_ops wil_netdev_ops = {
 	.ndo_open		= wil_open,
 	.ndo_stop		= wil_stop,
 	.ndo_start_xmit		= wil_start_xmit,
-	.ndo_select_queue	= wil_select_queue,
 	.ndo_set_mac_address    = eth_mac_addr,
 	.ndo_validate_addr      = eth_validate_addr,
 };
@@ -97,7 +72,7 @@ void *wil_if_alloc(struct device *dev, void __iomem *csr)
 	ch = wdev->wiphy->bands[IEEE80211_BAND_60GHZ]->channels;
 	cfg80211_chandef_create(&wdev->preset_chandef, ch, NL80211_CHAN_NO_HT);
 
-	ndev = alloc_netdev_mqs(0, "wlan%d", ether_setup, WIL6210_TX_QUEUES, 1);
+	ndev = alloc_netdev(0, "wlan%d", ether_setup);
 	if (!ndev) {
 		dev_err(dev, "alloc_netdev_mqs failed\n");
 		rc = -ENOMEM;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 9b2ebdd..d957286 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -36,8 +36,6 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
 
 #define WIL6210_MEM_SIZE (2*1024*1024UL)
 
-#define WIL6210_TX_QUEUES (4)
-
 #define WIL6210_RX_RING_SIZE (128)
 #define WIL6210_TX_RING_SIZE (128)
 #define WIL6210_MAX_TX_RINGS (24)
-- 
1.7.10.4

