Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:62688 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbbG3Kyu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 06:54:50 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 18/19] wil6210: report boot loader error
Date: Thu, 30 Jul 2015 13:52:06 +0300
Message-Id: <1438253527-3372-19-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150730_130716_660065_7D8DDEB8)
In-Reply-To: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Boot loader reports error starting from the struct v2.

Print error info before reset (power up state) in debug mode,
and print same info as error if target reset timed out.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/boot_loader.h |  5 ++++
 drivers/net/wireless/ath/wil6210/main.c        | 37 +++++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/boot_loader.h b/drivers/net/wireless/ath/wil6210/boot_loader.h
index 1b4fd40..c131b5e 100644
--- a/drivers/net/wireless/ath/wil6210/boot_loader.h
+++ b/drivers/net/wireless/ath/wil6210/boot_loader.h
@@ -36,6 +36,11 @@ struct bl_dedicated_registers_v1 {
 	u8	bl_version_minor;		/* 0x880A53 BL ver. minor */
 	__le16	bl_version_subminor;		/* 0x880A54 BL ver. subminor */
 	__le16	bl_version_build;		/* 0x880A56 BL ver. build */
+	/* valid only for version 2 and above */
+	__le32  bl_assert_code;         /* 0x880A58 BL Assert code */
+	__le32  bl_assert_blink;        /* 0x880A5C BL Assert Branch */
+	__le32  bl_reserved[22];        /* 0x880A60 - 0x880AB4 */
+	__le32  bl_magic_number;        /* 0x880AB8 BL Magic number */
 } __packed;
 
 /* the following struct is the version 0 struct */
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 4422323..d11a147 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -663,6 +663,7 @@ static int wil_get_bl_info(struct wil6210_priv *wil)
 		wil_info(wil, "Boot Loader build unknown for struct v0\n");
 		break;
 	case 1:
+	case 2:
 		wil_memcpy_fromio_32(&bl, wil->csr + HOSTADDR(RGF_USER_BL),
 				     sizeof(bl.bl1));
 		le32_to_cpus(&bl.bl1.boot_loader_ready);
@@ -705,6 +706,37 @@ static int wil_get_bl_info(struct wil6210_priv *wil)
 	return 0;
 }
 
+static void wil_bl_crash_info(struct wil6210_priv *wil, bool is_err)
+{
+	u32 bl_assert_code, bl_assert_blink, bl_magic_number;
+	u32 bl_ver = wil_r(wil, RGF_USER_BL +
+			   offsetof(struct bl_dedicated_registers_v0,
+				    boot_loader_struct_version));
+
+	if (bl_ver < 2)
+		return;
+
+	bl_assert_code = wil_r(wil, RGF_USER_BL +
+			       offsetof(struct bl_dedicated_registers_v1,
+					bl_assert_code));
+	bl_assert_blink = wil_r(wil, RGF_USER_BL +
+				offsetof(struct bl_dedicated_registers_v1,
+					 bl_assert_blink));
+	bl_magic_number = wil_r(wil, RGF_USER_BL +
+				offsetof(struct bl_dedicated_registers_v1,
+					 bl_magic_number));
+
+	if (is_err) {
+		wil_err(wil,
+			"BL assert code 0x%08x blink 0x%08x magic 0x%08x\n",
+			bl_assert_code, bl_assert_blink, bl_magic_number);
+	} else {
+		wil_dbg_misc(wil,
+			     "BL assert code 0x%08x blink 0x%08x magic 0x%08x\n",
+			     bl_assert_code, bl_assert_blink, bl_magic_number);
+	}
+}
+
 static int wil_wait_for_fw_ready(struct wil6210_priv *wil)
 {
 	ulong to = msecs_to_jiffies(1000);
@@ -770,10 +802,13 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 	flush_workqueue(wil->wq_service);
 	flush_workqueue(wil->wmi_wq);
 
+	wil_bl_crash_info(wil, false);
 	rc = wil_target_reset(wil);
 	wil_rx_fini(wil);
-	if (rc)
+	if (rc) {
+		wil_bl_crash_info(wil, true);
 		return rc;
+	}
 
 	rc = wil_get_bl_info(wil);
 	if (rc == -EAGAIN && !load_fw) /* ignore RF error if not going up */
-- 
2.1.4

