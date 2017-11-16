Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:38968 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753083AbdKPDO1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Nov 2017 22:14:27 -0500
From: Weixiao Zhang <waveletboy@gmail.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Weixiao Zhang <waveletboy@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mac80211: mwl8k: Expand non-DFS 5G channels
Date: Wed, 15 Nov 2017 21:14:22 -0600
Message-Id: <20171116031422.5408-1-waveletboy@gmail.com> (sfid-20171116_041451_386449_7D2951ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Weixiao Zhang <waveletboy@gmail.com>
---
 drivers/net/wireless/marvell/mwl8k.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index e813b2ca740c..8e4e9b6919e0 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -199,7 +199,7 @@ struct mwl8k_priv {
 	struct ieee80211_channel channels_24[14];
 	struct ieee80211_rate rates_24[13];
 	struct ieee80211_supported_band band_50;
-	struct ieee80211_channel channels_50[4];
+	struct ieee80211_channel channels_50[9];
 	struct ieee80211_rate rates_50[8];
 	u32 ap_macids_supported;
 	u32 sta_macids_supported;
@@ -383,6 +383,11 @@ static const struct ieee80211_channel mwl8k_channels_50[] = {
 	{ .band = NL80211_BAND_5GHZ, .center_freq = 5200, .hw_value = 40, },
 	{ .band = NL80211_BAND_5GHZ, .center_freq = 5220, .hw_value = 44, },
 	{ .band = NL80211_BAND_5GHZ, .center_freq = 5240, .hw_value = 48, },
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5745, .hw_value = 149, },
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5765, .hw_value = 153, },
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5785, .hw_value = 157, },
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5805, .hw_value = 161, },
+	{ .band = NL80211_BAND_5GHZ, .center_freq = 5825, .hw_value = 165, },
 };
 
 static const struct ieee80211_rate mwl8k_rates_50[] = {
-- 
2.11.0
