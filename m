Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hotel311.server4you.de ([85.25.146.15]:52504 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbcG1IFd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2016 04:05:33 -0400
From: Daniel Wagner <wagi@monom.org>
To: Bastien Nocera <hadess@hadess.net>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-input@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: [RFC v0 8/8] iwl4965: use firmware_stat instead of completion
Date: Thu, 28 Jul 2016 09:55:12 +0200
Message-Id: <1469692512-16863-9-git-send-email-wagi@monom.org> (sfid-20160728_100558_280949_95CE1018)
In-Reply-To: <1469692512-16863-1-git-send-email-wagi@monom.org>
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

Loading firmware is an operation many drivers implement in various ways
around the completion API. And most of them do it almost in the same
way. Let's reuse the firmware_stat API which is used also by the
firmware_class loader. Apart of streamlining the firmware loading states
we also document it slightly better.

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
---
 drivers/net/wireless/intel/iwlegacy/4965-mac.c | 8 ++++----
 drivers/net/wireless/intel/iwlegacy/common.h   | 3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index a91d170..d5e5808 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -5005,7 +5005,7 @@ il4965_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 	/* We have our copies now, allow OS release its copies */
 	release_firmware(ucode_raw);
-	complete(&il->_4965.firmware_loading_complete);
+	fw_loading_done(il->_4965.fw_st);
 	return;
 
 try_again:
@@ -5019,7 +5019,7 @@ err_pci_alloc:
 	IL_ERR("failed to allocate pci memory\n");
 	il4965_dealloc_ucode_pci(il);
 out_unbind:
-	complete(&il->_4965.firmware_loading_complete);
+	fw_loading_done(il->_4965.fw_st);
 	device_release_driver(&il->pci_dev->dev);
 	release_firmware(ucode_raw);
 }
@@ -6678,7 +6678,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	il_power_initialize(il);
 
-	init_completion(&il->_4965.firmware_loading_complete);
+	firmware_stat_init(&il->_4965.fw_st);
 
 	err = il4965_request_firmware(il, true);
 	if (err)
@@ -6716,7 +6716,7 @@ il4965_pci_remove(struct pci_dev *pdev)
 	if (!il)
 		return;
 
-	wait_for_completion(&il->_4965.firmware_loading_complete);
+	fw_loading_wait(il->_4965.fw_st);
 
 	D_INFO("*** UNLOAD DRIVER ***\n");
 
diff --git a/drivers/net/wireless/intel/iwlegacy/common.h b/drivers/net/wireless/intel/iwlegacy/common.h
index 726ede3..94af7b7 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.h
+++ b/drivers/net/wireless/intel/iwlegacy/common.h
@@ -32,6 +32,7 @@
 #include <linux/leds.h>
 #include <linux/wait.h>
 #include <linux/io.h>
+#include <linux/firmware.h>
 #include <net/mac80211.h>
 #include <net/ieee80211_radiotap.h>
 
@@ -1357,7 +1358,7 @@ struct il_priv {
 			bool last_phy_res_valid;
 			u32 ampdu_ref;
 
-			struct completion firmware_loading_complete;
+			struct firmware_stat fw_st;
 
 			/*
 			 * chain noise reset and gain commands are the
-- 
2.7.4
