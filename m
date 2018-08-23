Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:24234 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729951AbeHWPQm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 11:16:42 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 3/9] wil6210: drop Rx multicast packets that are looped-back to STA
Date: Thu, 23 Aug 2018 14:47:07 +0300
Message-Id: <1535024833-15178-4-git-send-email-merez@codeaurora.org> (sfid-20180823_134750_042030_D3197025)
In-Reply-To: <1535024833-15178-1-git-send-email-merez@codeaurora.org>
References: <1535024833-15178-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <dlansky@codeaurora.org>

Delivering a looped-back multicast packet to network stack can cause
higher layer protocols to fail like for example IPv6 DAD.
In STA mode, upon receiving Rx multicast packet, check if the source
MAC address is equal to our own MAC address and if so drop the packet.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 6a7943e..e7b003b38 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -765,7 +765,14 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 		return;
 	}
 
-	if (wdev->iftype == NL80211_IFTYPE_AP && !vif->ap_isolate) {
+	if (wdev->iftype == NL80211_IFTYPE_STATION) {
+		if (mcast && ether_addr_equal(eth->h_source, ndev->dev_addr)) {
+			/* mcast packet looped back to us */
+			rc = GRO_DROP;
+			dev_kfree_skb(skb);
+			goto stats;
+		}
+	} else if (wdev->iftype == NL80211_IFTYPE_AP && !vif->ap_isolate) {
 		if (mcast) {
 			/* send multicast frames both to higher layers in
 			 * local net stack and back to the wireless medium
-- 
1.9.1
