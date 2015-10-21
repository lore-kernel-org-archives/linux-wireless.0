Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52482 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611AbbJUVxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 17:53:24 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath6kl@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/3] ath6k:  report antenna configuration.
Date: Wed, 21 Oct 2015 14:53:19 -0700
Message-Id: <1445464401-13826-1-git-send-email-greearb@candelatech.com> (sfid-20151021_235338_206575_05C57F08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This lets 'iw phy phy0 info' report antennas for
the radio device:

...
	Available Antennas: TX 0x2 RX 0x2
	Configured Antennas: TX 0x2 RX 0x2
...

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

This patch series is on top of my various local patches in a 4.2.3 kernel.

 drivers/net/wireless/ath/ath6kl/cfg80211.c | 17 +++++++++++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 5b3d79e..ed25ad6 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3231,6 +3231,15 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 					wait, buf, len, no_cck);
 }
 
+static int ath6kl_get_antenna(struct wiphy *wiphy,
+			      u32 *tx_ant, u32 *rx_ant)
+{
+	struct ath6kl *ar = wiphy_priv(wiphy);
+	*tx_ant = ar->hw.tx_ant;
+	*rx_ant = ar->hw.rx_ant;
+	return 0;
+}
+
 static void ath6kl_mgmt_frame_register(struct wiphy *wiphy,
 				       struct wireless_dev *wdev,
 				       u16 frame_type, bool reg)
@@ -3448,6 +3457,7 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.cancel_remain_on_channel = ath6kl_cancel_remain_on_channel,
 	.mgmt_tx = ath6kl_mgmt_tx,
 	.mgmt_frame_register = ath6kl_mgmt_frame_register,
+	.get_antenna = ath6kl_get_antenna,
 	.sched_scan_start = ath6kl_cfg80211_sscan_start,
 	.sched_scan_stop = ath6kl_cfg80211_sscan_stop,
 	.set_bitrate_mask = ath6kl_cfg80211_set_bitrate,
@@ -3795,11 +3805,18 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 		ath6kl_band_5ghz.ht_cap.mcs.rx_mask[0] = 0xff;
 		ath6kl_band_2ghz.ht_cap.mcs.rx_mask[1] = 0xff;
 		ath6kl_band_5ghz.ht_cap.mcs.rx_mask[1] = 0xff;
+		ar->hw.tx_ant = 2;
+		ar->hw.rx_ant = 2;
 	} else {
 		ath6kl_band_2ghz.ht_cap.mcs.rx_mask[0] = 0xff;
 		ath6kl_band_5ghz.ht_cap.mcs.rx_mask[0] = 0xff;
+		ar->hw.tx_ant = 1;
+		ar->hw.rx_ant = 1;
 	}
 
+	wiphy->available_antennas_tx = ar->hw.tx_ant;
+	wiphy->available_antennas_rx = ar->hw.rx_ant;
+
 	if (band_2gig)
 		wiphy->bands[IEEE80211_BAND_2GHZ] = &ath6kl_band_2ghz;
 	if (band_5gig)
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 2b78c86..5f3acfe 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -782,6 +782,8 @@ struct ath6kl {
 		u32 refclk_hz;
 		u32 uarttx_pin;
 		u32 testscript_addr;
+		u8 tx_ant;
+		u8 rx_ant;
 		enum wmi_phy_cap cap;
 
 		u32 flags;
-- 
2.4.3

