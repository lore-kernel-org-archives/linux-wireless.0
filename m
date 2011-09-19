Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35592 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab1ISQBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 12:01:35 -0400
Received: by fxe4 with SMTP id 4so4057116fxe.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 09:01:34 -0700 (PDT)
Date: Mon, 19 Sep 2011 19:01:24 +0300
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org
Subject: [RFT][PATCH] ath5k: Add rfkill_disable module parameter
Message-ID: <20110919160124.GA3218@makis.lan> (sfid-20110919_180139_645752_9575EBE5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a module parameter to disable hw rf kill (GPIO interrupt) because in some cases when the card doesn't come with the laptop, EEPROM configuration 
doesn't match laptop's configuration and rf kill interrupt always fires up and disables hw. I thought of moving this to debugfs and make it per-card 
but this way it's easier for users and distros to handle.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index e9ea38d..000a65d 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -80,6 +80,10 @@ static int modparam_fastchanswitch;
 module_param_named(fastchanswitch, modparam_fastchanswitch, bool, S_IRUGO);
 MODULE_PARM_DESC(fastchanswitch, "Enable fast channel switching for AR2413/AR5413 radios.");
 
+static int ath5k_modparam_rfkill_disable;
+module_param_named(rfkill_disable, ath5k_modparam_rfkill_disable, bool, S_IRUGO);
+MODULE_PARM_DESC(rfkill_disable, "Disable hw rfkill support (GPIO interrupt).");
+
 
 /* Module info */
 MODULE_AUTHOR("Jiri Slaby");
@@ -2558,7 +2562,8 @@ int ath5k_start(struct ieee80211_hw *hw)
 	if (ret)
 		goto done;
 
-	ath5k_rfkill_hw_start(ah);
+	if (!ath5k_modparam_rfkill_disable)
+		ath5k_rfkill_hw_start(ah);
 
 	/*
 	 * Reset the key cache since some parts do not reset the
@@ -2643,7 +2648,8 @@ void ath5k_stop(struct ieee80211_hw *hw)
 
 	cancel_delayed_work_sync(&ah->tx_complete_work);
 
-	ath5k_rfkill_hw_stop(ah);
+	if (!ath5k_modparam_rfkill_disable)
+		ath5k_rfkill_hw_stop(ah);
 }
 
 /*

