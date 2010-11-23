Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45203 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab0KWTZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:25:04 -0500
Received: by ewy5 with SMTP id 5so2669075ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:25:03 -0800 (PST)
Date: Tue, 23 Nov 2010 21:24:54 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 18/30] ath5k: Always set IFS intervals on reset
Message-ID: <20101123192454.GR4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Make sure we always set IFS timings even if no
 coverage class is set. If we don't we'll miss the
 needed changes for different bwmodes.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    1 +
 drivers/net/wireless/ath/ath5k/pcu.c   |    2 +-
 drivers/net/wireless/ath/ath5k/qcu.c   |    8 ++++++++
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index ddbbf4c..e258830 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1224,6 +1224,7 @@ int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac);
 /* Helpers */
 int ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
 		int len, struct ieee80211_rate *rate);
+unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah);
 unsigned int ath5k_hw_get_default_sifs(struct ath5k_hw *ah);
 extern int ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype opmode);
 void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class);
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 4556f29..420ab61 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -129,7 +129,7 @@ int ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
  *
  * @ah: The &struct ath5k_hw
  */
-static unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah)
+unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah)
 {
 	struct ieee80211_channel *channel = ah->ah_current_channel;
 	unsigned int slot_time;
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 69bff04..1849eee 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -652,5 +652,13 @@ int ath5k_hw_init_queues(struct ath5k_hw *ah)
 		AR5K_REG_ENABLE_BITS(ah, AR5K_DCU_GBL_IFS_MISC,
 				AR5K_DCU_GBL_IFS_MISC_TURBO_MODE);
 
+	/* If we didn't set IFS timings through
+	 * ath5k_hw_set_coverage_class make sure
+	 * we set them here */
+	if (!ah->ah_coverage_class) {
+		unsigned int slot_time = ath5k_hw_get_default_slottime(ah);
+		ath5k_hw_set_ifs_intervals(ah, slot_time);
+	}
+
 	return 0;
 }
