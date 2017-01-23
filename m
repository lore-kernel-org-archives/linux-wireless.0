Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36346 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751757AbdAWWT1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:19:27 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com,
        Sara Sharon <sara.sharon@intel.com>
Date: Tue, 24 Jan 2017 00:03:35 +0200
Message-Id: <20170123220350.25305-11-luca@coelho.fi> (sfid-20170123_233339_632288_1F9DCFEC)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
Subject: [PATCH 10/25] iwlwifi: enlarge number of ucode sections
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The maximum number of firmware sections is now 32 instead of 16 for
a000 devices. Set the appropriate define.  Avoid out of bounds access
in case there are more sections than the maximum set by driver.

Make the driver extensible to FW size changes by allocating the
section memory dynamically.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/ucode.c    |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c      | 31 ++++++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h  |  1 -
 drivers/net/wireless/intel/iwlwifi/iwl-fw.h       |  3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       |  4 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c   |  4 +--
 8 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index 8c0719468d00..2a04d0cd71ae 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -163,7 +163,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 				       REGULATORY_DISABLE_BEACON_HINTS;
 
 #ifdef CONFIG_PM_SLEEP
-	if (priv->fw->img[IWL_UCODE_WOWLAN].sec[0].len &&
+	if (priv->fw->img[IWL_UCODE_WOWLAN].num_sec &&
 	    priv->trans->ops->d3_suspend &&
 	    priv->trans->ops->d3_resume &&
 	    device_can_wakeup(priv->trans->dev)) {
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c b/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c
index c7509c51e9d9..d6013bfe991c 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c
@@ -407,7 +407,7 @@ int iwl_run_init_ucode(struct iwl_priv *priv)
 	lockdep_assert_held(&priv->mutex);
 
 	/* No init ucode required? Curious, but maybe ok */
-	if (!priv->fw->img[IWL_UCODE_INIT].sec[0].len)
+	if (!priv->fw->img[IWL_UCODE_INIT].num_sec)
 		return 0;
 
 	iwl_init_notification_wait(&priv->notif_wait, &calib_wait,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index a6719d67ac00..1d1af4bc1530 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -166,8 +166,9 @@ static void iwl_free_fw_desc(struct iwl_drv *drv, struct fw_desc *desc)
 static void iwl_free_fw_img(struct iwl_drv *drv, struct fw_img *img)
 {
 	int i;
-	for (i = 0; i < IWL_UCODE_SECTION_MAX; i++)
+	for (i = 0; i < img->num_sec; i++)
 		iwl_free_fw_desc(drv, &img->sec[i]);
+	kfree(img->sec);
 }
 
 static void iwl_dealloc_ucode(struct iwl_drv *drv)
@@ -240,7 +241,7 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 }
 
 struct fw_img_parsing {
-	struct fw_sec sec[IWL_UCODE_SECTION_MAX];
+	struct fw_sec *sec;
 	int sec_counter;
 };
 
@@ -383,6 +384,7 @@ static int iwl_store_ucode_sec(struct iwl_firmware_pieces *pieces,
 	struct fw_img_parsing *img;
 	struct fw_sec *sec;
 	struct fw_sec_parsing *sec_parse;
+	size_t alloc_size;
 
 	if (WARN_ON(!pieces || !data || type >= IWL_UCODE_TYPE_MAX))
 		return -1;
@@ -390,6 +392,13 @@ static int iwl_store_ucode_sec(struct iwl_firmware_pieces *pieces,
 	sec_parse = (struct fw_sec_parsing *)data;
 
 	img = &pieces->img[type];
+
+	alloc_size = sizeof(*img->sec) * (img->sec_counter + 1);
+	sec = krealloc(img->sec, alloc_size, GFP_KERNEL);
+	if (!sec)
+		return -ENOMEM;
+	img->sec = sec;
+
 	sec = &img->sec[img->sec_counter];
 
 	sec->offset = le32_to_cpu(sec_parse->offset);
@@ -1089,12 +1098,18 @@ static int iwl_alloc_ucode(struct iwl_drv *drv,
 			   enum iwl_ucode_type type)
 {
 	int i;
-	for (i = 0;
-	     i < IWL_UCODE_SECTION_MAX && get_sec_size(pieces, type, i);
-	     i++)
-		if (iwl_alloc_fw_desc(drv, &(drv->fw.img[type].sec[i]),
-				      get_sec(pieces, type, i)))
+	struct fw_desc *sec;
+
+	sec = kcalloc(pieces->img[type].sec_counter, sizeof(*sec), GFP_KERNEL);
+	if (!sec)
+		return -ENOMEM;
+	drv->fw.img[type].sec = sec;
+	drv->fw.img[type].num_sec = pieces->img[type].sec_counter;
+
+	for (i = 0; i < pieces->img[type].sec_counter; i++)
+		if (iwl_alloc_fw_desc(drv, &sec[i], get_sec(pieces, type, i)))
 			return -ENOMEM;
+
 	return 0;
 }
 
@@ -1457,6 +1472,8 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	complete(&drv->request_firmware_complete);
 	device_release_driver(drv->trans->dev);
  free:
+	for (i = 0; i < ARRAY_SIZE(pieces->img); i++)
+		kfree(pieces->img[i].sec);
 	kfree(pieces->dbg_mem_tlv);
 	kfree(pieces);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index c84207576587..d01701ee4777 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -379,7 +379,6 @@ enum iwl_ucode_tlv_capa {
  * For 16.0 uCode and above, there is no differentiation between sections,
  * just an offset to the HW address.
  */
-#define IWL_UCODE_SECTION_MAX 16
 #define CPU1_CPU2_SEPARATOR_SECTION	0xFFFFCCCC
 #define PAGING_SEPARATOR_SECTION	0xAAAABBBB
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
index 710ecb490bfc..d323b70b510a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
@@ -132,7 +132,8 @@ struct fw_desc {
 };
 
 struct fw_img {
-	struct fw_desc sec[IWL_UCODE_SECTION_MAX];
+	struct fw_desc *sec;
+	int num_sec;
 	bool is_dual_cpus;
 	u32 paging_mem_size;
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 606b3fc18d46..b278e44e97ad 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -190,7 +190,7 @@ static int iwl_fill_paging_mem(struct iwl_mvm *mvm, const struct fw_img *image)
 	 * CPU2 paging CSS
 	 * CPU2 paging image (including instruction and data)
 	 */
-	for (sec_idx = 0; sec_idx < IWL_UCODE_SECTION_MAX; sec_idx++) {
+	for (sec_idx = 0; sec_idx < image->num_sec; sec_idx++) {
 		if (image->sec[sec_idx].offset == PAGING_SEPARATOR_SECTION) {
 			sec_idx++;
 			break;
@@ -201,7 +201,7 @@ static int iwl_fill_paging_mem(struct iwl_mvm *mvm, const struct fw_img *image)
 	 * If paging is enabled there should be at least 2 more sections left
 	 * (one for CSS and one for Paging data)
 	 */
-	if (sec_idx >= ARRAY_SIZE(image->sec) - 1) {
+	if (sec_idx >= image->num_sec - 1) {
 		IWL_ERR(mvm, "Paging: Missing CSS and/or paging sections\n");
 		iwl_free_fw_paging(mvm);
 		return -EINVAL;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 039cb2ad2d3e..71f9aa9f7c7d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -677,7 +677,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->wiphy->wowlan = &mvm->wowlan;
 	}
 
-	if (mvm->fw->img[IWL_UCODE_WOWLAN].sec[0].len &&
+	if (mvm->fw->img[IWL_UCODE_WOWLAN].num_sec &&
 	    mvm->trans->ops->d3_suspend &&
 	    mvm->trans->ops->d3_resume &&
 	    device_can_wakeup(mvm->trans->dev)) {
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index b10e3633df1a..bf0ecdcf7402 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -805,7 +805,7 @@ static int iwl_pcie_load_cpu_sections_8000(struct iwl_trans *trans,
 		(*first_ucode_section)++;
 	}
 
-	for (i = *first_ucode_section; i < IWL_UCODE_SECTION_MAX; i++) {
+	for (i = *first_ucode_section; i < image->num_sec; i++) {
 		last_read_idx = i;
 
 		/*
@@ -880,7 +880,7 @@ static int iwl_pcie_load_cpu_sections(struct iwl_trans *trans,
 		(*first_ucode_section)++;
 	}
 
-	for (i = *first_ucode_section; i < IWL_UCODE_SECTION_MAX; i++) {
+	for (i = *first_ucode_section; i < image->num_sec; i++) {
 		last_read_idx = i;
 
 		/*
-- 
2.11.0
