Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41769 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab2HURCI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 13:02:08 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/8] iwlwifi: s/iwl_ucode_callback/iwl_req_fw_callback
Date: Tue, 21 Aug 2012 19:01:49 +0200
Message-Id: <1345568516-20822-1-git-send-email-johannes@sipsolutions.net> (sfid-20120821_190211_999352_AC91E4C7)
In-Reply-To: <1345568455.10280.11.camel@jlt3.sipsolutions.net>
References: <1345568455.10280.11.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This name emphasizes more the role of the function: the
callback called when the ASYNC call to request_firmware
completes.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c |    9 +++++----
 drivers/net/wireless/iwlwifi/iwl-drv.h |    6 +++---
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index cc41cfa..35a9d65 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -194,7 +194,8 @@ static int iwl_alloc_fw_desc(struct iwl_drv *drv, struct fw_desc *desc,
 	return 0;
 }
 
-static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context);
+static void iwl_req_fw_callback(const struct firmware *ucode_raw,
+				void *context);
 
 #define UCODE_EXPERIMENTAL_INDEX	100
 #define UCODE_EXPERIMENTAL_TAG		"exp"
@@ -231,7 +232,7 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 
 	return request_firmware_nowait(THIS_MODULE, 1, drv->firmware_name,
 				       drv->trans->dev,
-				       GFP_KERNEL, drv, iwl_ucode_callback);
+				       GFP_KERNEL, drv, iwl_req_fw_callback);
 }
 
 struct fw_img_parsing {
@@ -760,12 +761,12 @@ static int validate_sec_sizes(struct iwl_drv *drv,
 }
 
 /**
- * iwl_ucode_callback - callback when firmware was loaded
+ * iwl_req_fw_callback - callback when firmware was loaded
  *
  * If loaded successfully, copies the firmware into buffers
  * for the card to fetch (via DMA).
  */
-static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
+static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 {
 	struct iwl_drv *drv = context;
 	struct iwl_fw *fw = &drv->fw;
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.h b/drivers/net/wireless/iwlwifi/iwl-drv.h
index 2cbf137..285de5f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.h
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.h
@@ -90,9 +90,9 @@
  * 4) The bus specific component configures the bus
  * 5) The bus specific component calls to the drv bus agnostic part
  *    (iwl_drv_start)
- * 6) iwl_drv_start fetches the fw ASYNC, iwl_ucode_callback
- * 7) iwl_ucode_callback parses the fw file
- * 8) iwl_ucode_callback starts the wifi implementation to matches the fw
+ * 6) iwl_drv_start fetches the fw ASYNC, iwl_req_fw_callback
+ * 7) iwl_req_fw_callback parses the fw file
+ * 8) iwl_req_fw_callback starts the wifi implementation to matches the fw
  */
 
 struct iwl_drv;
-- 
1.7.10.4

