Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:60259 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891Ab3DTEEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Apr 2013 00:04:10 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: don't try to associate when bss_mode is not STA
Date: Fri, 19 Apr 2013 21:00:44 -0700
Message-ID: <1366430444-7237-1-git-send-email-bzhao@marvell.com> (sfid-20130420_060426_052297_FF203B3D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have blocked association attempts on interfaces configured in
AP and AD-HOC modes. P2P mode should be blocked too.

Furthermore, an error code must be returned if we are unable to
associate.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 2a604eb..a0cb077 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1666,17 +1666,13 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 			 struct cfg80211_connect_params *sme)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
-	int ret = 0;
-
-	if (priv->bss_mode == NL80211_IFTYPE_ADHOC) {
-		wiphy_err(wiphy, "received infra assoc request "
-				"when station is in ibss mode\n");
-		goto done;
-	}
+	int ret;
 
-	if (priv->bss_mode == NL80211_IFTYPE_AP) {
-		wiphy_err(wiphy, "skip association request for AP interface\n");
-		goto done;
+	if (priv->bss_mode != NL80211_IFTYPE_STATION) {
+		wiphy_err(wiphy,
+			  "%s: reject infra assoc request in non-STA mode\n",
+			  dev->name);
+		return -EINVAL;
 	}
 
 	wiphy_dbg(wiphy, "info: Trying to associate to %s and bssid %pM\n",
@@ -1684,7 +1680,6 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 
 	ret = mwifiex_cfg80211_assoc(priv, sme->ssid_len, sme->ssid, sme->bssid,
 				     priv->bss_mode, sme->channel, sme, 0);
-done:
 	if (!ret) {
 		cfg80211_connect_result(priv->netdev, priv->cfg_bssid, NULL, 0,
 					NULL, 0, WLAN_STATUS_SUCCESS,
-- 
1.7.0.2

