Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.nanl.de ([217.115.11.12]:52848 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab3DMKb5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Apr 2013 06:31:57 -0400
From: Jonas Gorski <jogo@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [RFC/RFT] mwl8k: don't expose non-standard rates
Date: Sat, 13 Apr 2013 12:31:11 +0200
Message-Id: <1365849071-2389-1-git-send-email-jogo@openwrt.org> (sfid-20130413_123213_372050_FD3FCC3C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not advertise the non standard rates 22 Mbps and 72 Mbps to mac80211,
they will make it into the probe responses and cause clients checking them
to refuse association, e.g. wpa_supplicant says:

wlan1:    hardware does not support required rate 8.0 Mbps

Fix this by removing the rates and adapt shifts accordingly.

This fixes at least association with Android ICS or newer as well as
wpa_supplicant with ath9k to a mwl8k running AP.

Signed-off-by: Jonas Gorski <jogo@openwrt.org>
---

I'm sending this patch as RFC/RFT because I'm not 100% confident I
caught everything - the length of the rate arrays are hardcoded in
several places, and some use an offset into it to make it even more
confusing.

So please test that I did not break anything.

 drivers/net/wireless/mwl8k.c |   29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index ee1778c..04f9051 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -193,10 +193,10 @@ struct mwl8k_priv {
 	struct rxd_ops *rxd_ops;
 	struct ieee80211_supported_band band_24;
 	struct ieee80211_channel channels_24[14];
-	struct ieee80211_rate rates_24[14];
+	struct ieee80211_rate rates_24[12];
 	struct ieee80211_supported_band band_50;
 	struct ieee80211_channel channels_50[4];
-	struct ieee80211_rate rates_50[9];
+	struct ieee80211_rate rates_50[8];
 	u32 ap_macids_supported;
 	u32 sta_macids_supported;
 
@@ -357,7 +357,6 @@ static const struct ieee80211_rate mwl8k_rates_24[] = {
 	{ .bitrate = 20, .hw_value = 4, },
 	{ .bitrate = 55, .hw_value = 11, },
 	{ .bitrate = 110, .hw_value = 22, },
-	{ .bitrate = 220, .hw_value = 44, },
 	{ .bitrate = 60, .hw_value = 12, },
 	{ .bitrate = 90, .hw_value = 18, },
 	{ .bitrate = 120, .hw_value = 24, },
@@ -366,7 +365,6 @@ static const struct ieee80211_rate mwl8k_rates_24[] = {
 	{ .bitrate = 360, .hw_value = 72, },
 	{ .bitrate = 480, .hw_value = 96, },
 	{ .bitrate = 540, .hw_value = 108, },
-	{ .bitrate = 720, .hw_value = 144, },
 };
 
 static const struct ieee80211_channel mwl8k_channels_50[] = {
@@ -385,7 +383,6 @@ static const struct ieee80211_rate mwl8k_rates_50[] = {
 	{ .bitrate = 360, .hw_value = 72, },
 	{ .bitrate = 480, .hw_value = 96, },
 	{ .bitrate = 540, .hw_value = 108, },
-	{ .bitrate = 720, .hw_value = 144, },
 };
 
 /* Set or get info from Firmware */
@@ -1003,7 +1000,7 @@ mwl8k_rxd_ap_process(void *_rxd, struct ieee80211_rx_status *status,
 	if (rxd->channel > 14) {
 		status->band = IEEE80211_BAND_5GHZ;
 		if (!(status->flag & RX_FLAG_HT))
-			status->rate_idx -= 5;
+			status->rate_idx -= 4;
 	} else {
 		status->band = IEEE80211_BAND_2GHZ;
 	}
@@ -1111,7 +1108,7 @@ mwl8k_rxd_sta_process(void *_rxd, struct ieee80211_rx_status *status,
 	if (rxd->channel > 14) {
 		status->band = IEEE80211_BAND_5GHZ;
 		if (!(status->flag & RX_FLAG_HT))
-			status->rate_idx -= 5;
+			status->rate_idx -= 4;
 	} else {
 		status->band = IEEE80211_BAND_2GHZ;
 	}
@@ -3080,17 +3077,9 @@ struct mwl8k_cmd_update_set_aid {
 static void legacy_rate_mask_to_array(u8 *rates, u32 mask)
 {
 	int i;
-	int j;
 
-	/*
-	 * Clear nonstandard rates 4 and 13.
-	 */
-	mask &= 0x1fef;
-
-	for (i = 0, j = 0; i < 14; i++) {
-		if (mask & (1 << i))
-			rates[j++] = mwl8k_rates_24[i].hw_value;
-	}
+	for (i = 0; i < 12; i++)
+		rates[i] = mwl8k_rates_24[i].hw_value;
 }
 
 static int
@@ -3972,7 +3961,7 @@ static int mwl8k_cmd_set_new_stn_add(struct ieee80211_hw *hw,
 	if (hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ)
 		rates = sta->supp_rates[IEEE80211_BAND_2GHZ];
 	else
-		rates = sta->supp_rates[IEEE80211_BAND_5GHZ] << 5;
+		rates = sta->supp_rates[IEEE80211_BAND_5GHZ] << 4;
 	cmd->legacy_rates = cpu_to_le32(rates);
 	if (sta->ht_cap.ht_supported) {
 		cmd->ht_rates[0] = sta->ht_cap.mcs.rx_mask[0];
@@ -4407,7 +4396,7 @@ static int mwl8k_cmd_update_stadb_add(struct ieee80211_hw *hw,
 	if (hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ)
 		rates = sta->supp_rates[IEEE80211_BAND_2GHZ];
 	else
-		rates = sta->supp_rates[IEEE80211_BAND_5GHZ] << 5;
+		rates = sta->supp_rates[IEEE80211_BAND_5GHZ] << 4;
 	legacy_rate_mask_to_array(p->legacy_rates, rates);
 	memcpy(p->ht_rates, sta->ht_cap.mcs.rx_mask, 16);
 	p->interop = 1;
@@ -4889,7 +4878,7 @@ mwl8k_bss_info_changed_sta(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			ap_legacy_rates = ap->supp_rates[IEEE80211_BAND_2GHZ];
 		} else {
 			ap_legacy_rates =
-				ap->supp_rates[IEEE80211_BAND_5GHZ] << 5;
+				ap->supp_rates[IEEE80211_BAND_5GHZ] << 4;
 		}
 		memcpy(ap_mcs_rates, ap->ht_cap.mcs.rx_mask, 16);
 
-- 
1.7.10.4

