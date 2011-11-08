Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:36691 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751678Ab1KHFmE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 00:42:04 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7/7] mwifiex: release bss structure returned by cfg80211_inform_bss()
Date: Mon,  7 Nov 2011 21:41:12 -0800
Message-Id: <1320730872-25619-8-git-send-email-bzhao@marvell.com> (sfid-20111108_064208_104975_7AA313A1)
In-Reply-To: <1320730872-25619-1-git-send-email-bzhao@marvell.com>
References: <1320730872-25619-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Following compilation warning is fixed by releasing referenced BSS
structure returned by cfg80211_inform_bss().

"warning: ignoring return value of cfg80211_inform_bss,
declared with attribute warn_unused_result"

Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
This patch fixes the bug mentioned by Johannes Berg:
See "[PATCH] cfg80211: annotate cfg80211_inform_bss"

 drivers/net/wireless/mwifiex/cfg80211.c |    4 +++-
 drivers/net/wireless/mwifiex/scan.c     |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 462c710..e9ab9a3 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -780,6 +780,7 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 {
 	struct ieee80211_channel *chan;
 	struct mwifiex_bss_info bss_info;
+	struct cfg80211_bss *bss;
 	int ie_len;
 	u8 ie_buf[IEEE80211_MAX_SSID_LEN + sizeof(struct ieee_types_header)];
 	enum ieee80211_band band;
@@ -800,9 +801,10 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 			ieee80211_channel_to_frequency(bss_info.bss_chan,
 						       band));
 
-	cfg80211_inform_bss(priv->wdev->wiphy, chan,
+	bss = cfg80211_inform_bss(priv->wdev->wiphy, chan,
 		bss_info.bssid, 0, WLAN_CAPABILITY_IBSS,
 		0, ie_buf, ie_len, 0, GFP_KERNEL);
+	cfg80211_put_bss(bss);
 	memcpy(priv->cfg_bssid, bss_info.bssid, ETH_ALEN);
 
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index c650e60..8a18bcc 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1760,6 +1760,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 					      cap_info_bitmap, beacon_period,
 					      ie_buf, ie_len, rssi, GFP_KERNEL);
 				*(u8 *)bss->priv = band;
+				cfg80211_put_bss(bss);
 
 				if (priv->media_connected && !memcmp(bssid,
 					priv->curr_bss_params.bss_descriptor
-- 
1.7.0.2

