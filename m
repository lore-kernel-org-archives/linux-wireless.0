Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33727 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab1KTH5x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 02:57:53 -0500
Received: by mail-bw0-f46.google.com with SMTP id 11so5187685bke.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 23:57:52 -0800 (PST)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 09/13] ath5k: Add a module parameter to disable hw rf kill switch
Date: Sun, 20 Nov 2011 09:56:24 +0200
Message-Id: <1321775788-12520-10-git-send-email-mickflemm@gmail.com> (sfid-20111120_085758_634243_2B721EBC)
In-Reply-To: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
References: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a module parameter to disable hw rf kill switch (GPIO interrupt) because
in some cases when the card doesn't come with the laptop, EEPROM configuration
doesn't match laptop's configuration and rf kill interrupt always fires up and
disables hw. I thought of moving this to debugfs and make it per-card but
this way it's easier for users and distros to handle.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
Tested-by: Pavel Roskin <proski@.gnu.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 587c6fb..b901721 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -80,6 +80,11 @@ static int modparam_fastchanswitch;
 module_param_named(fastchanswitch, modparam_fastchanswitch, bool, S_IRUGO);
 MODULE_PARM_DESC(fastchanswitch, "Enable fast channel switching for AR2413/AR5413 radios.");
 
+static int ath5k_modparam_no_hw_rfkill_switch;
+module_param_named(no_hw_rfkill_switch, ath5k_modparam_no_hw_rfkill_switch,
+								bool, S_IRUGO);
+MODULE_PARM_DESC(no_hw_rfkill_switch, "Ignore the GPIO RFKill switch state");
+
 
 /* Module info */
 MODULE_AUTHOR("Jiri Slaby");
@@ -2634,7 +2639,8 @@ int ath5k_start(struct ieee80211_hw *hw)
 	if (ret)
 		goto done;
 
-	ath5k_rfkill_hw_start(ah);
+	if (!ath5k_modparam_no_hw_rfkill_switch)
+		ath5k_rfkill_hw_start(ah);
 
 	/*
 	 * Reset the key cache since some parts do not reset the
@@ -2719,7 +2725,8 @@ void ath5k_stop(struct ieee80211_hw *hw)
 
 	cancel_delayed_work_sync(&ah->tx_complete_work);
 
-	ath5k_rfkill_hw_stop(ah);
+	if (!ath5k_modparam_no_hw_rfkill_switch)
+		ath5k_rfkill_hw_stop(ah);
 }
 
 /*
-- 
1.7.8.rc1

