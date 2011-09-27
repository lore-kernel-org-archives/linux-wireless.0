Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:36860 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751979Ab1I0Dhu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 23:37:50 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/4] mwifiex: remove unnecessary mwifiex_dump_station_info() call
Date: Mon, 26 Sep 2011 20:37:23 -0700
Message-Id: <1317094646-7718-1-git-send-email-bzhao@marvell.com> (sfid-20110927_053754_226243_32A6EDE5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

An extra call to mwifiex_dump_station_info() routine in get_station
callback function is redundant

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 6fd53e4..5550741 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -565,8 +565,6 @@ mwifiex_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
-	mwifiex_dump_station_info(priv, sinfo);
-
 	if (!priv->media_connected)
 		return -ENOENT;
 	if (memcmp(mac, priv->cfg_bssid, ETH_ALEN))
-- 
1.7.0.2

