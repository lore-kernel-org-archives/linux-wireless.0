Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38925 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752346AbdIRG6r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 02:58:47 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH] mwifiex: avoid storing random_mac in private
Date: Mon, 18 Sep 2017 12:25:02 +0530
Message-ID: <1505717702-10342-1-git-send-email-gbhat@marvell.com> (sfid-20170918_085851_594465_85EBBBB9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Application will keep track of whether MAC address randomization
is enabled or not during scan. But at present driver is storing
'random_mac' in mwifiex_private which implies even after scan is
done driver has some reference to the earlier 'scan request'. To
avoid this, make use of 'mac_addr' variable in 'scan_request' to
store 'random_mac'. This structure will be freed by cfg80211 once
scan is done.

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 11 ++++-------
 drivers/net/wireless/marvell/mwifiex/main.h     |  1 -
 drivers/net/wireless/marvell/mwifiex/scan.c     |  3 ++-
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index ad1ebd8..84c1518 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2529,15 +2529,12 @@ static int mwifiex_set_ibss_params(struct mwifiex_private *priv,
 	priv->scan_request = request;
 
 	if (request->flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
-		ether_addr_copy(priv->random_mac, request->mac_addr);
 		for (i = 0; i < ETH_ALEN; i++) {
-			priv->random_mac[i] &= request->mac_addr_mask[i];
-			priv->random_mac[i] |= get_random_int() &
-					       ~(request->mac_addr_mask[i]);
+			request->mac_addr[i] &= request->mac_addr_mask[i];
+			request->mac_addr[i] |=
+				get_random_int() & ~(request->mac_addr_mask[i]);
 		}
-		ether_addr_copy(user_scan_cfg->random_mac, priv->random_mac);
-	} else {
-		eth_zero_addr(priv->random_mac);
+		ether_addr_copy(user_scan_cfg->random_mac, request->mac_addr);
 	}
 
 	user_scan_cfg->num_ssids = request->n_ssids;
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index a76bd79..a34de85 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -680,7 +680,6 @@ struct mwifiex_private {
 	struct mwifiex_user_scan_chan hidden_chan[MWIFIEX_USER_SCAN_CHAN_MAX];
 	u8 assoc_resp_ht_param;
 	bool ht_param_present;
-	u8 random_mac[ETH_ALEN];
 };
 
 
diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index c9d41ed..cddf412 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1948,7 +1948,8 @@ static void mwifiex_complete_scan(struct mwifiex_private *priv)
 
 	adapter->active_scan_triggered = true;
 	if (priv->scan_request->flags & NL80211_SCAN_FLAG_RANDOM_ADDR)
-		ether_addr_copy(user_scan_cfg->random_mac, priv->random_mac);
+		ether_addr_copy(user_scan_cfg->random_mac,
+				priv->scan_request->mac_addr);
 	user_scan_cfg->num_ssids = priv->scan_request->n_ssids;
 	user_scan_cfg->ssid_list = priv->scan_request->ssids;
 
-- 
1.9.1
