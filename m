Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:45694 "HELO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751977Ab2EQEda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 00:33:30 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/3] mwifiex: fix kernel warning in ibss start/join path
Date: Wed, 16 May 2012 21:24:56 -0700
Message-Id: <1337228696-22312-3-git-send-email-bzhao@marvell.com> (sfid-20120517_063333_463261_998602DE)
In-Reply-To: <1337228696-22312-1-git-send-email-bzhao@marvell.com>
References: <1337228696-22312-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Since cfg80211_ibss_joined() is called inside ibss join callback
routine, following kernel warning is hit while starting/joining
an ibss network.

"WARNING: at net/wireless/ibss.c:63 cfg80211_ibss_joined+0x35/0xb6
[cfg80211]()"

Update "wdev->ssid" and "wdev->ssid_len" in ibss join callback to
fix this warning.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 015fec3..194a42b 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1294,6 +1294,8 @@ mwifiex_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 				     params->channel, NULL, params->privacy);
 done:
 	if (!ret) {
+		memcpy(priv->wdev->ssid, params->ssid, params->ssid_len);
+		priv->wdev->ssid_len = params->ssid_len;
 		cfg80211_ibss_joined(priv->netdev, priv->cfg_bssid, GFP_KERNEL);
 		dev_dbg(priv->adapter->dev,
 			"info: joined/created adhoc network with bssid"
-- 
1.7.0.2

