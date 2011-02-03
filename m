Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:42119 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1BCWoQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 17:44:16 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: use modified ieee80211_channel_to_frequency() API
Date: Thu,  3 Feb 2011 14:46:00 -0800
Message-Id: <1296773161-11642-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

After Bruno Randolf's recent code changes (commit 59eb21a6
"cfg80211: Extend channel to frequency mapping for 802.11j")
ieee80211_channel_to_frequency() API expects an extra "band"
parameter. Update the driver code to provide this extra
parameter.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index c961e0f..45fabaa 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -916,7 +916,8 @@ mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 	ie_len = ie_buf[1] + sizeof(struct ieee_types_header);
 
 	chan = __ieee80211_get_channel(priv->wdev->wiphy,
-			ieee80211_channel_to_frequency(bss_info.bss_chan));
+			ieee80211_channel_to_frequency(bss_info.bss_chan,
+						priv->curr_bss_params.band));
 
 	cfg80211_inform_bss(priv->wdev->wiphy, chan,
 		bss_info.bssid, 0, WLAN_CAPABILITY_IBSS,
-- 
1.7.0.2

