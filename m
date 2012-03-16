Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:46335 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161299Ab2CPDw0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 23:52:26 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/5] mwifiex: add cfg80211 dump_station handler
Date: Thu, 15 Mar 2012 20:51:48 -0700
Message-Id: <1331869911-10624-3-git-send-email-bzhao@marvell.com> (sfid-20120316_045229_374682_B894834C)
In-Reply-To: <1331869911-10624-1-git-send-email-bzhao@marvell.com>
References: <1331869911-10624-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This enables user to dump station information using
"iw dev <devname> station dump" command.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 6505038..4f65419 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -604,6 +604,23 @@ mwifiex_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 	return mwifiex_dump_station_info(priv, sinfo);
 }
 
+/*
+ * CFG802.11 operation handler to dump station information.
+ */
+static int
+mwifiex_cfg80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
+			      int idx, u8 *mac, struct station_info *sinfo)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+
+	if (!priv->media_connected || idx)
+		return -ENOENT;
+
+	memcpy(mac, priv->cfg_bssid, ETH_ALEN);
+
+	return mwifiex_dump_station_info(priv, sinfo);
+}
+
 /* Supported rates to be advertised to the cfg80211 */
 
 static struct ieee80211_rate mwifiex_rates[] = {
@@ -1340,6 +1357,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.connect = mwifiex_cfg80211_connect,
 	.disconnect = mwifiex_cfg80211_disconnect,
 	.get_station = mwifiex_cfg80211_get_station,
+	.dump_station = mwifiex_cfg80211_dump_station,
 	.set_wiphy_params = mwifiex_cfg80211_set_wiphy_params,
 	.set_channel = mwifiex_cfg80211_set_channel,
 	.join_ibss = mwifiex_cfg80211_join_ibss,
-- 
1.7.0.2

