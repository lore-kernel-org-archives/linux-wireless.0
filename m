Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41665 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab3A1JhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 04:37:25 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 03/37] iwlwifi: fix calibration parser
Date: Mon, 28 Jan 2013 10:37:10 +0100
Message-Id: <1359365864-4259-4-git-send-email-johannes@sipsolutions.net> (sfid-20130128_103733_980475_4AC4E1F9)
In-Reply-To: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
References: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The firmware TLV for calibration data isn't
really a u64, but two u32 values. Define a
struct for that and change the parser.

Change-Id: Ia50f7fcd54ee0edb570eac84397942316b6fafa5
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c |  8 ++++++--
 drivers/net/wireless/iwlwifi/iwl-fw.h  | 15 ++++++++++++++-
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index a7fb5ba..c675196 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -268,7 +268,7 @@ struct fw_sec_parsing {
  */
 struct iwl_tlv_calib_data {
 	__le32 ucode_type;
-	__le64 calib;
+	struct iwl_tlv_calib_ctrl calib;
 } __packed;
 
 struct iwl_firmware_pieces {
@@ -358,7 +358,11 @@ static int iwl_set_default_calib(struct iwl_drv *drv, const u8 *data)
 			ucode_type);
 		return -EINVAL;
 	}
-	drv->fw.default_calib[ucode_type] = le64_to_cpu(def_calib->calib);
+	drv->fw.default_calib[ucode_type].flow_trigger =
+		def_calib->calib.flow_trigger;
+	drv->fw.default_calib[ucode_type].event_trigger =
+		def_calib->calib.event_trigger;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 0bc8b6f..1ad31a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -139,6 +139,19 @@ struct fw_img {
 #define IWL_UCODE_API(ver)	(((ver) & 0x0000FF00) >> 8)
 #define IWL_UCODE_SERIAL(ver)	((ver) & 0x000000FF)
 
+/*
+ * Calibration control struct.
+ * Sent as part of the phy configuration command.
+ * @flow_trigger: bitmap for which calibrations to perform according to
+ *		flow triggers.
+ * @event_trigger: bitmap for which calibrations to perform according to
+ *		event triggers.
+ */
+struct iwl_tlv_calib_ctrl {
+	__le32 flow_trigger;
+	__le32 event_trigger;
+} __packed;
+
 /**
  * struct iwl_fw - variables associated with the firmware
  *
@@ -168,7 +181,7 @@ struct iwl_fw {
 	u32 init_evtlog_ptr, init_evtlog_size, init_errlog_ptr;
 	u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
 
-	u64 default_calib[IWL_UCODE_TYPE_MAX];
+	struct iwl_tlv_calib_ctrl default_calib[IWL_UCODE_TYPE_MAX];
 	u32 phy_config;
 
 	bool mvm_fw;
-- 
1.8.0

