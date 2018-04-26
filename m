Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:44914 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754625AbeDZKSk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 06:18:40 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Dmitry Shmidt <dimitrysh@google.com>,
        linux-wireless@vger.kernel.org,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 2/6] brcmfmac: reports boottime_ns while informing bss
Date: Thu, 26 Apr 2018 12:18:35 +0200
Message-Id: <1524737915-2217-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180426_121900_745133_07DA08FA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <franky.lin@broadcom.com>

Provides a timestamp in bss information so user space can see when the
bss info was updated. Since tsf is not available from the dongle events
boottime is reported instead.

Reported-by: Dmitry Shmidt <dimitrysh@google.com>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 26 +++++++++++-----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 89b8625..5d891cb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2728,7 +2728,6 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 				   struct brcmf_bss_info_le *bi)
 {
 	struct wiphy *wiphy = cfg_to_wiphy(cfg);
-	struct ieee80211_channel *notify_channel;
 	struct cfg80211_bss *bss;
 	struct ieee80211_supported_band *band;
 	struct brcmu_chan ch;
@@ -2738,7 +2737,7 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 	u16 notify_interval;
 	u8 *notify_ie;
 	size_t notify_ielen;
-	s32 notify_signal;
+	struct cfg80211_inform_bss bss_data = { 0 };
 
 	if (le32_to_cpu(bi->length) > WL_BSS_INFO_MAX) {
 		brcmf_err("Bss info is larger than buffer. Discarding\n");
@@ -2758,27 +2757,28 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 		band = wiphy->bands[NL80211_BAND_5GHZ];
 
 	freq = ieee80211_channel_to_frequency(channel, band->band);
-	notify_channel = ieee80211_get_channel(wiphy, freq);
+	bss_data.chan = ieee80211_get_channel(wiphy, freq);
+	bss_data.scan_width = NL80211_BSS_CHAN_WIDTH_20;
+	bss_data.boottime_ns = ktime_to_ns(ktime_get_boottime());
 
 	notify_capability = le16_to_cpu(bi->capability);
 	notify_interval = le16_to_cpu(bi->beacon_period);
 	notify_ie = (u8 *)bi + le16_to_cpu(bi->ie_offset);
 	notify_ielen = le32_to_cpu(bi->ie_length);
-	notify_signal = (s16)le16_to_cpu(bi->RSSI) * 100;
+	bss_data.signal = (s16)le16_to_cpu(bi->RSSI) * 100;
 
 	brcmf_dbg(CONN, "bssid: %pM\n", bi->BSSID);
 	brcmf_dbg(CONN, "Channel: %d(%d)\n", channel, freq);
 	brcmf_dbg(CONN, "Capability: %X\n", notify_capability);
 	brcmf_dbg(CONN, "Beacon interval: %d\n", notify_interval);
-	brcmf_dbg(CONN, "Signal: %d\n", notify_signal);
-
-	bss = cfg80211_inform_bss(wiphy, notify_channel,
-				  CFG80211_BSS_FTYPE_UNKNOWN,
-				  (const u8 *)bi->BSSID,
-				  0, notify_capability,
-				  notify_interval, notify_ie,
-				  notify_ielen, notify_signal,
-				  GFP_KERNEL);
+	brcmf_dbg(CONN, "Signal: %d\n", bss_data.signal);
+
+	bss = cfg80211_inform_bss_data(wiphy, &bss_data,
+				       CFG80211_BSS_FTYPE_UNKNOWN,
+				       (const u8 *)bi->BSSID,
+				       0, notify_capability,
+				       notify_interval, notify_ie,
+				       notify_ielen, GFP_KERNEL);
 
 	if (!bss)
 		return -ENOMEM;
-- 
1.9.1
