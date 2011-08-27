Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56273 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab1H0S4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 14:56:18 -0400
Received: by gxk21 with SMTP id 21so3753587gxk.19
        for <linux-wireless@vger.kernel.org>; Sat, 27 Aug 2011 11:56:18 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix a smatch warnings
Date: Sat, 27 Aug 2011 13:56:00 -0500
Message-Id: <1314471360-861-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110827_205622_501080_D76CBFCA)
To: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch shows the following warnings:

  CHECK   drivers/net/wireless/ath/ath9k/htc_drv_main.c
drivers/net/wireless/ath/ath9k/htc_drv_main.c +1315 ath9k_htc_configure_filter(27) warn: inconsistent returns mutex:&priv->mutex: locked (1303) unlocked (1315)

  CHECK   drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
drivers/net/wireless/ath/ath9k/ar9003_eeprom.c +3321 ar9300_eeprom_restore_internal(20) warn: returning -1 instead of -ENOMEM is sloppy

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is next material.

Larry
---

To ath9k developers:

Smatch also show the following information, which I have not addressed:

  CHECK   drivers/net/wireless/ath/key.c
drivers/net/wireless/ath/key.c +546 ath_key_config(77) info: why not propagate 'idx' from ath_reserve_key_cache_slot() instead of -28?
  CHECK   drivers/net/wireless/ath/ath9k/hif_usb.c
drivers/net/wireless/ath/ath9k/hif_usb.c +760 ath9k_hif_usb_dealloc_tx_urbs(23) error: double free of 'tx_buf->buf'
  CHECK   drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
drivers/net/wireless/ath/ath9k/htc_drv_beacon.c +339 ath9k_htc_send_buffered(44) error: double lock 'bottom_half:'
drivers/net/wireless/ath/ath9k/htc_drv_beacon.c +347 ath9k_htc_send_buffered(52) error: double unlock 'bottom_half:'
  CHECK   drivers/net/wireless/ath/ath9k/ar9003_phy.c
drivers/net/wireless/ath/ath9k/ar9003_phy.c +209 ar9003_hw_spur_mitigate_mrc_cck(40) error: potential null derefence 'spur_fbin_ptr'.
  CHECK   drivers/net/wireless/ath/ath9k/ar9003_paprd.c
drivers/net/wireless/ath/ath9k/ar9003_paprd.c +164 ar9003_paprd_setup_single_table(28) info: why not propagate 'training_power' from ar9003_get_training_power_5g() instead of -34?

---
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c  |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 3b4ae07..fc2d607 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3318,7 +3318,7 @@ static int ar9300_eeprom_restore_internal(struct ath_hw *ah,
 
 	word = kzalloc(2048, GFP_KERNEL);
 	if (!word)
-		return -1;
+		return -ENOMEM;
 
 	memcpy(mptr, &ar9300_default, mdata_size);
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 7212acb..2a3a2ce 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1300,6 +1300,7 @@ static void ath9k_htc_configure_filter(struct ieee80211_hw *hw,
 	if (priv->op_flags & OP_INVALID) {
 		ath_dbg(ath9k_hw_common(priv->ah), ATH_DBG_ANY,
 			"Unable to configure filter on invalid state\n");
+		mutex_unlock(&priv->mutex);
 		return;
 	}
 	ath9k_htc_ps_wakeup(priv);
-- 
1.7.3.4

