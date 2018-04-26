Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:44364 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755161AbeDZKR2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 06:17:28 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 3/6] brcmfmac: use nl80211_band directly to get ieee80211 channel
Date: Thu, 26 Apr 2018 12:16:48 +0200
Message-Id: <1524737811-1965-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180426_121732_549291_AF99FAF8)
In-Reply-To: <1524737811-1965-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1524737811-1965-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <franky.lin@broadcom.com>

The enum nl80211_band used to retrieve wiphy->bands is the same as
wiphy->bands->band which is checked by wiphy_register(). So it can be used
directly as parameter of ieee80211_channel_to_frequency().

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 5d891cb..ff6b351 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2729,7 +2729,7 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 {
 	struct wiphy *wiphy = cfg_to_wiphy(cfg);
 	struct cfg80211_bss *bss;
-	struct ieee80211_supported_band *band;
+	enum nl80211_band band;
 	struct brcmu_chan ch;
 	u16 channel;
 	u32 freq;
@@ -2752,11 +2752,11 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 	channel = bi->ctl_ch;
 
 	if (channel <= CH_MAX_2G_CHANNEL)
-		band = wiphy->bands[NL80211_BAND_2GHZ];
+		band = NL80211_BAND_2GHZ;
 	else
-		band = wiphy->bands[NL80211_BAND_5GHZ];
+		band = NL80211_BAND_5GHZ;
 
-	freq = ieee80211_channel_to_frequency(channel, band->band);
+	freq = ieee80211_channel_to_frequency(channel, band);
 	bss_data.chan = ieee80211_get_channel(wiphy, freq);
 	bss_data.scan_width = NL80211_BSS_CHAN_WIDTH_20;
 	bss_data.boottime_ns = ktime_to_ns(ktime_get_boottime());
-- 
1.9.1
