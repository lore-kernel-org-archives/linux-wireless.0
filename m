Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40976 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2FGHZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 03:25:21 -0400
From: Naveen Singh <navesing@qca.qualcomm.com>
To: <ath6kl-devel@qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [patch v3] ath6kl: Different version for different FW binaries
Date: Thu, 7 Jun 2012 00:25:19 -0700
Message-ID: <1339053919-27263-1-git-send-email-navesing@qca.qualcomm.com> (sfid-20120607_092524_002990_2EAC77D1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Need to have different FW versioning for different FW binaries.
This is handled by appending different meta data in firmware
binaries.

Signed-off-by: Naveen Singh <navesing@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    8 ++++++++
 drivers/net/wireless/ath/ath6kl/main.c |   21 ++++++++++++---------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index daf24ee..62e25cc 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -943,6 +943,14 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 		}
 
 		switch (ie_id) {
+		case ATH6KL_FW_IE_FW_VERSION:
+			strlcpy(ar->wiphy->fw_version, data,
+				sizeof(ar->wiphy->fw_version));
+
+			ath6kl_dbg(ATH6KL_DBG_BOOT,
+				   "found fw version %s\n",
+				    ar->wiphy->fw_version);
+			break;
 		case ATH6KL_FW_IE_OTP_IMAGE:
 			ath6kl_dbg(ATH6KL_DBG_BOOT, "found otp image ie (%zd B)\n",
 				   ie_len);
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 3e6768a..254e665 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -554,20 +554,23 @@ void ath6kl_ready_event(void *devt, u8 *datap, u32 sw_ver, u32 abi_ver,
 	struct ath6kl *ar = devt;
 
 	memcpy(ar->mac_addr, datap, ETH_ALEN);
-	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: mac addr = %pM\n",
-		   __func__, ar->mac_addr);
+	ath6kl_dbg(ATH6KL_DBG_BOOT, 
+		"ready event mac addr %pM sw_ver 0x%x abi_ver 0x%x cap 0x%x\n", 
+		ar->mac_addr, sw_ver, abi_ver, cap);
 
 	ar->version.wlan_ver = sw_ver;
 	ar->version.abi_ver = abi_ver;
 	ar->hw.cap = cap;
 
-	snprintf(ar->wiphy->fw_version,
-		 sizeof(ar->wiphy->fw_version),
-		 "%u.%u.%u.%u",
-		 (ar->version.wlan_ver & 0xf0000000) >> 28,
-		 (ar->version.wlan_ver & 0x0f000000) >> 24,
-		 (ar->version.wlan_ver & 0x00ff0000) >> 16,
-		 (ar->version.wlan_ver & 0x0000ffff));
+	if (strlen(ar->wiphy->fw_version) == 0x00) {
+		snprintf(ar->wiphy->fw_version,
+			sizeof(ar->wiphy->fw_version),
+			"%u.%u.%u.%u",
+			(ar->version.wlan_ver & 0xf0000000) >> 28,
+			(ar->version.wlan_ver & 0x0f000000) >> 24,
+			(ar->version.wlan_ver & 0x00ff0000) >> 16,
+			(ar->version.wlan_ver & 0x0000ffff));
+	}
 
 	/* indicate to the waiting thread that the ready event was received */
 	set_bit(WMI_READY, &ar->flag);
-- 
1.7.0.4

