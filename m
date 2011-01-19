Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:17707 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752994Ab1ASJVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 04:21:43 -0500
Received: from vs3001.wh2.ocn.ne.jp (125.206.180.229)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0969248902
	for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 18:21:42 +0900 (JST)
Subject: [PATCH] RFC: ath5k: Enable 802.11j 4.9GHz frequencies
To: linux-wireless@vger.kernel.org
From: Bruno Randolf <br1@einfach.org>
Cc: bob@bobcopeland.com, lrodriguez@atheros.com, bprodoehl@gmail.com,
	mickflemm@gmail.com
Date: Wed, 19 Jan 2011 18:22:08 +0900
Message-ID: <20110119092208.19777.47542.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RFC:

This enables 4.9GHz frequencies in ath5k if the regdomain is set to MKK9_MKKC
(0xfe).

I have added a helper function to common ath/regd.c since we know about
MKK9_MKKC there, however in the place where i'm using the function we don't
have an ath_regulatory structure yet, so i'm passing the regdomain code as u16.

I'm using MKK9_MKKC only because this is the regdomain in the 802.11j enabled
sample cards we got from our vendor. I'm not sure if this is commonly used or
if there are other domain codes which indicate 802.11j support for Atheros
hardware (allthough some comments in the HAL suggest that). Also I don't know
if this is common between ath9k and ath5k.

Could someone from Atheros shed some light on this? Other comments?
---
 drivers/net/wireless/ath/ath5k/caps.c |   13 ++++++++-----
 drivers/net/wireless/ath/regd.c       |    6 ++++++
 drivers/net/wireless/ath/regd.h       |    1 +
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/caps.c b/drivers/net/wireless/ath/ath5k/caps.c
index 31cad80..52fa808 100644
--- a/drivers/net/wireless/ath/ath5k/caps.c
+++ b/drivers/net/wireless/ath/ath5k/caps.c
@@ -56,9 +56,8 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
 		 * XXX current ieee80211 implementation because the IEEE
 		 * XXX channel mapping does not support negative channel
 		 * XXX numbers (2312MHz is channel -19). Of course, this
-		 * XXX doesn't matter because these channels are out of range
-		 * XXX but some regulation domains like MKK (Japan) will
-		 * XXX support frequencies somewhere around 4.8GHz.
+		 * XXX doesn't matter because these channels are out of the
+		 * XXX legal range.
 		 */
 
 		/*
@@ -66,8 +65,12 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
 		 */
 
 		if (AR5K_EEPROM_HDR_11A(ee_header)) {
-			/* 4920 */
-			ah->ah_capabilities.cap_range.range_5ghz_min = 5005;
+			if (ath_is_11j_regd(
+			      ah->ah_capabilities.cap_eeprom.ee_regdomain))
+				/* 802.11j enabled card */
+				ah->ah_capabilities.cap_range.range_5ghz_min = 4920; /* 4910? */
+			else
+				ah->ah_capabilities.cap_range.range_5ghz_min = 5005;
 			ah->ah_capabilities.cap_range.range_5ghz_max = 6100;
 
 			/* Set supported modes */
diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 2b14775..8d60089 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -158,6 +158,12 @@ ieee80211_regdomain *ath_world_regdomain(struct ath_regulatory *reg)
 	}
 }
 
+bool ath_is_11j_regd(u16 regdomain)
+{
+	return regdomain == MKK9_MKKC;
+}
+EXPORT_SYMBOL(ath_is_11j_regd);
+
 /* Frequency is one where radar detection is required */
 static bool ath_is_radar_freq(u16 center_freq)
 {
diff --git a/drivers/net/wireless/ath/regd.h b/drivers/net/wireless/ath/regd.h
index 345dd97..18d9acb 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -250,6 +250,7 @@ enum CountryCode {
 };
 
 bool ath_is_world_regd(struct ath_regulatory *reg);
+bool ath_is_11j_regd(u16 redomain);
 int ath_regd_init(struct ath_regulatory *reg, struct wiphy *wiphy,
 		  int (*reg_notifier)(struct wiphy *wiphy,
 		  struct regulatory_request *request));

