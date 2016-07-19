Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:35845 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbcGSM6v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 08:58:51 -0400
Received: by mail-lf0-f44.google.com with SMTP id g62so13471609lfe.3
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 05:58:50 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC] ath10k: silence firmware file probing warnings
Date: Tue, 19 Jul 2016 15:00:37 +0200
Message-Id: <1468933237-5226-1-git-send-email-michal.kazior@tieto.com> (sfid-20160719_145855_080368_9188912A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware files are versioned to prevent older
driver instances to load unsupported firmware
blobs. This is reflected with a fallback logic
which attempts to load several firmware files.

This however produced a lot of unnecessary
warnings sometimes confusing users and leading
them to rename firmware files making things even
more confusing.

Hence use request_firmware_direct() which does not
produce extra warnings. This shouldn't really
break anything because most modern systems don't
rely on udev/hotplug helpers to load firmware
files anymore.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c     | 11 +++++------
 drivers/net/wireless/ath/ath10k/testmode.c |  5 ++++-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index e88982921aa3..81bfb71fe876 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -431,7 +431,10 @@ static const struct firmware *ath10k_fetch_fw_file(struct ath10k *ar,
 		dir = ".";
 
 	snprintf(filename, sizeof(filename), "%s/%s", dir, file);
-	ret = request_firmware(&fw, filename, ar->dev);
+	ret = request_firmware_direct(&fw, filename, ar->dev);
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot fw request '%s': %d\n",
+		   filename, ret);
+
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -1089,12 +1092,8 @@ int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
 	/* first fetch the firmware file (firmware-*.bin) */
 	fw_file->firmware = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir,
 						 name);
-	if (IS_ERR(fw_file->firmware)) {
-		ath10k_err(ar, "could not fetch firmware file '%s/%s': %ld\n",
-			   ar->hw_params.fw.dir, name,
-			   PTR_ERR(fw_file->firmware));
+	if (IS_ERR(fw_file->firmware))
 		return PTR_ERR(fw_file->firmware);
-	}
 
 	data = fw_file->firmware->data;
 	len = fw_file->firmware->size;
diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
index 120f4234d3b0..fe49e7a83d00 100644
--- a/drivers/net/wireless/ath/ath10k/testmode.c
+++ b/drivers/net/wireless/ath/ath10k/testmode.c
@@ -149,7 +149,10 @@ static int ath10k_tm_fetch_utf_firmware_api_1(struct ath10k *ar,
 		 ar->hw_params.fw.dir, ATH10K_FW_UTF_FILE);
 
 	/* load utf firmware image */
-	ret = request_firmware(&fw_file->firmware, filename, ar->dev);
+	ret = request_firmware_direct(&fw_file->firmware, filename, ar->dev);
+	ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "testmode fw request '%s': %d\n",
+		   filename, ret);
+
 	if (ret) {
 		ath10k_warn(ar, "failed to retrieve utf firmware '%s': %d\n",
 			    filename, ret);
-- 
2.1.4

