Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51372 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbaCMRaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2014 13:30:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Gang Zhao <gamerh2o@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wlan-ng: fixup staging driver for removal of ieee80211_dsss_chan_to_freq
Date: Thu, 13 Mar 2014 13:16:15 -0400
Message-Id: <1394730975-20389-1-git-send-email-linville@tuxdriver.com> (sfid-20140313_183049_361466_DB640178)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 3ebe8e257307a87c33460aa7d2b75dadd374ed9c ("ieee80211: remove
function ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}") removed
ieee80211_dsss_chan_to_freq, but it neglected to account for this
staging driver...

Cc: Zhao, Gang <gamerh2o@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/staging/wlan-ng/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index a7d24c95191d..7dd2b95416e8 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -416,7 +416,7 @@ static int prism2_scan(struct wiphy *wiphy,
 		memcpy(&ie_buf[2], &(msg2.ssid.data.data), msg2.ssid.data.len);
 		bss = cfg80211_inform_bss(wiphy,
 			ieee80211_get_channel(wiphy,
-			      ieee80211_dsss_chan_to_freq(msg2.dschannel.data)),
+			      ieee80211_channel_to_frequency(msg2.dschannel.data, IEEE80211_BAND_2GHZ)),
 			(const u8 *) &(msg2.bssid.data.data),
 			msg2.timestamp.data, msg2.capinfo.data,
 			msg2.beaconperiod.data,
-- 
1.8.5.3

