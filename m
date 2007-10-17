Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2244 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762686AbXJQTjE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 15:39:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath5k: avoid oops when ah_capabilities.cap_mode not set
Date: Wed, 17 Oct 2007 15:03:00 -0400
Message-Id: <1192647780430-git-send-email-linville@tuxdriver.com> (sfid-20071017_203933_904592_108E1899)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ah_capabilities.cap_mode doesn't get set for some cards, causing the
kernel to oops when these unknown/unsupported cards are inserted.
Add some NULL checks to avoid this.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath5k/base.c |    3 +++
 drivers/net/wireless/ath5k/hw.c   |    4 ++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index da72056..40f5ce6 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2007,6 +2007,9 @@ static int ath_getchannels(struct ieee80211_hw *hw)
 		}
 
 		hw_rates = ath5k_hw_get_rate_table(ah, mode->mode);
+		if (!hw_rates)
+			return -EINVAL;
+
 		mode->num_rates    = ath_copy_rates(mode->rates, hw_rates,
 			max_r);
 		mode->num_channels = ath_copy_channels(ah, mode->channels,
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 504f642..7202e50 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -670,6 +670,8 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 				/*Get rate table for this operation mode*/
 				rt = ath5k_hw_get_rate_table(hal,
 						MODE_IEEE80211B);
+				if (!rt)
+					return -EINVAL;
 
 				/*Write rate duration table*/
 				for (i = 0; i < rt->rate_count; i++) {
@@ -695,6 +697,8 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 				rt = ath5k_hw_get_rate_table(hal,
 				    channel->val & CHANNEL_TURBO ?
 				    MODE_ATHEROS_TURBO : MODE_ATHEROS_TURBOG);
+				if (!rt)
+					return -EINVAL;
 
 				/* Write rate duration table */
 				for (i = 0; i < rt->rate_count; i++)
-- 
1.5.2.4

