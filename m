Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:44680 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961Ab3IZPrg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 11:47:36 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH v3 06/13] ath10k: drop the fw versioning sanity check
Date: Thu, 26 Sep 2013 17:47:10 +0200
Message-ID: <1380210437-4391-7-git-send-email-bartosz.markowski@tieto.com> (sfid-20130926_174758_861859_990C5F99)
In-Reply-To: <1380210437-4391-1-git-send-email-bartosz.markowski@tieto.com>
References: <1380210437-4391-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was corrupted and leading to compilation warning
core.c: In function 'ath10k_check_fw_version':
core.c:79: warning: comparison is always true due to limited range of data type

Since we are going to support new FW track in the driver,
the sanity check for fw version number would be an overkill
then. This is just for information purposes anyway.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   25 -------------------------
 drivers/net/wireless/ath/ath10k/hw.h   |    6 ------
 2 files changed, 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 76906d5..31860a6 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -59,27 +59,6 @@ static void ath10k_send_suspend_complete(struct ath10k *ar)
 	wake_up(&ar->event_queue);
 }
 
-static int ath10k_check_fw_version(struct ath10k *ar)
-{
-	char version[32];
-
-	if (ar->fw_version_major >= SUPPORTED_FW_MAJOR &&
-	    ar->fw_version_minor >= SUPPORTED_FW_MINOR &&
-	    ar->fw_version_release >= SUPPORTED_FW_RELEASE &&
-	    ar->fw_version_build >= SUPPORTED_FW_BUILD)
-		return 0;
-
-	snprintf(version, sizeof(version), "%u.%u.%u.%u",
-		 SUPPORTED_FW_MAJOR, SUPPORTED_FW_MINOR,
-		 SUPPORTED_FW_RELEASE, SUPPORTED_FW_BUILD);
-
-	ath10k_warn("WARNING: Firmware version %s is not officially supported.\n",
-		    ar->hw->wiphy->fw_version);
-	ath10k_warn("Please upgrade to version %s (or newer)\n", version);
-
-	return 0;
-}
-
 static int ath10k_init_connect_htc(struct ath10k *ar)
 {
 	int status;
@@ -616,10 +595,6 @@ int ath10k_core_start(struct ath10k *ar)
 
 	ath10k_info("firmware %s booted\n", ar->hw->wiphy->fw_version);
 
-	status = ath10k_check_fw_version(ar);
-	if (status)
-		goto err_disconnect_htc;
-
 	status = ath10k_wmi_cmd_init(ar);
 	if (status) {
 		ath10k_err("could not send WMI init command (%d)\n", status);
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 8c1be768..66e721a 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -20,12 +20,6 @@
 
 #include "targaddrs.h"
 
-/* Supported FW version */
-#define SUPPORTED_FW_MAJOR	1
-#define SUPPORTED_FW_MINOR	0
-#define SUPPORTED_FW_RELEASE	0
-#define SUPPORTED_FW_BUILD	636
-
 /* QCA988X 1.0 definitions (unsupported) */
 #define QCA988X_HW_1_0_CHIP_ID_REV	0x0
 
-- 
1.7.10

