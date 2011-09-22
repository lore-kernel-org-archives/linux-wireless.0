Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:33976 "HELO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751026Ab1IVEnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 00:43:18 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/4] mwifiex: pass correct band parameter to ieee80211_channel_to_frequency()
Date: Wed, 21 Sep 2011 21:43:24 -0700
Message-Id: <1316666605-30954-3-git-send-email-bzhao@marvell.com> (sfid-20110922_064321_413297_A1DD2506)
In-Reply-To: <1316666605-30954-1-git-send-email-bzhao@marvell.com>
References: <1316666605-30954-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

ieee80211_channel_to_frequency() routine expects band parameter in
the form of "enum ieee80211_band band". Currently driver specific
band (BAND_A, BAND_AN etc.) is passed to the routine.

This patch makes sure that correct parameter is passed.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |    4 +++-
 drivers/net/wireless/mwifiex/sta_ioctl.c |    5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 62932c2..0ddcdca 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -768,6 +768,7 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 	struct mwifiex_bss_info bss_info;
 	int ie_len;
 	u8 ie_buf[IEEE80211_MAX_SSID_LEN + sizeof(struct ieee_types_header)];
+	enum ieee80211_band band;
 
 	if (mwifiex_get_bss_info(priv, &bss_info))
 		return -1;
@@ -780,9 +781,10 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 			bss_info.ssid.ssid_len);
 	ie_len = ie_buf[1] + sizeof(struct ieee_types_header);
 
+	band = mwifiex_band_to_radio_type(priv->curr_bss_params.band);
 	chan = __ieee80211_get_channel(priv->wdev->wiphy,
 			ieee80211_channel_to_frequency(bss_info.bss_chan,
-						priv->curr_bss_params.band));
+						       band));
 
 	cfg80211_inform_bss(priv->wdev->wiphy, chan,
 		bss_info.bssid, 0, WLAN_CAPABILITY_IBSS,
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 157d312..a9dfeb1 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -655,6 +655,7 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 	u16 curr_chan = 0;
 	struct cfg80211_bss *bss = NULL;
 	struct ieee80211_channel *chan;
+	enum ieee80211_band band;
 
 	memset(&bss_info, 0, sizeof(bss_info));
 
@@ -691,9 +692,9 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 		goto done;
 	}
 
+	band = mwifiex_band_to_radio_type(priv->curr_bss_params.band);
 	chan = __ieee80211_get_channel(priv->wdev->wiphy,
-			ieee80211_channel_to_frequency(channel,
-						priv->curr_bss_params.band));
+			ieee80211_channel_to_frequency(channel, band));
 
 	/* Find the BSS we want using available scan results */
 	bss = cfg80211_get_bss(priv->wdev->wiphy, chan, bss_info.bssid,
-- 
1.7.0.2

