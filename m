Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57758 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751735AbdALNPV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 08:15:21 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH v2 08/13] wil6210: fix for broadcast workaround in PBSS
Date: Thu, 12 Jan 2017 15:06:00 +0200
Message-Id: <1484226365-10433-9-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170112_141534_098124_FBFBB2A2)
In-Reply-To: <1484226365-10433-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1484226365-10433-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

Currently we do not have full support for broadcast from
a station inside a PBSS network.
We have a workaround where instead of broadcast we do a
unicast to every known station in the PBSS.
This workaround was performed only for P2P clients.
This fix will perform the broadcast workaround also for a
regular station inside a PBSS.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  1 +
 drivers/net/wireless/ath/wil6210/txrx.c     | 35 ++++++++++++++++-------------
 2 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index f8499a8..9a92790 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -601,6 +601,7 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 		goto out;
 	}
 	wil->privacy = sme->privacy;
+	wil->pbss = sme->pbss;
 
 	if (wil->privacy) {
 		/* For secure assoc, remove old keys */
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 6e7dc8d..1311688 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1195,17 +1195,6 @@ static struct vring *wil_find_tx_bcast_2(struct wil6210_priv *wil,
 	return v;
 }
 
-static struct vring *wil_find_tx_bcast(struct wil6210_priv *wil,
-				       struct sk_buff *skb)
-{
-	struct wireless_dev *wdev = wil->wdev;
-
-	if (wdev->iftype != NL80211_IFTYPE_AP)
-		return wil_find_tx_bcast_2(wil, skb);
-
-	return wil_find_tx_bcast_1(wil, skb);
-}
-
 static int wil_tx_desc_map(struct vring_tx_desc *d, dma_addr_t pa, u32 len,
 			   int vring_index)
 {
@@ -1905,12 +1894,26 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	pr_once_fw = false;
 
 	/* find vring */
-	if (wil->wdev->iftype == NL80211_IFTYPE_STATION) {
-		/* in STA mode (ESS), all to same VRING */
+	if (wil->wdev->iftype == NL80211_IFTYPE_STATION && !wil->pbss) {
+		/* in STA mode (ESS), all to same VRING (to AP) */
 		vring = wil_find_tx_vring_sta(wil, skb);
-	} else { /* direct communication, find matching VRING */
-		vring = bcast ? wil_find_tx_bcast(wil, skb) :
-				wil_find_tx_ucast(wil, skb);
+	} else if (bcast) {
+		if (wil->pbss)
+			/* in pbss, no bcast VRING - duplicate skb in
+			 * all stations VRINGs
+			 */
+			vring = wil_find_tx_bcast_2(wil, skb);
+		else if (wil->wdev->iftype == NL80211_IFTYPE_AP)
+			/* AP has a dedicated bcast VRING */
+			vring = wil_find_tx_bcast_1(wil, skb);
+		else
+			/* unexpected combination, fallback to duplicating
+			 * the skb in all stations VRINGs
+			 */
+			vring = wil_find_tx_bcast_2(wil, skb);
+	} else {
+		/* unicast, find specific VRING by dest. address */
+		vring = wil_find_tx_ucast(wil, skb);
 	}
 	if (unlikely(!vring)) {
 		wil_dbg_txrx(wil, "No Tx VRING found for %pM\n", eth->h_dest);
-- 
1.9.1
