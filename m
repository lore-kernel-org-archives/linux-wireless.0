Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38796 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab2EPUtz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:49:55 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] iwlwifi: fix memory leak if opmode fails to init
Date: Wed, 16 May 2012 22:49:49 +0200
Message-Id: <1337201389-21553-4-git-send-email-johannes@sipsolutions.net> (sfid-20120516_225003_559630_3526AB5D)
In-Reply-To: <1337201389-21553-1-git-send-email-johannes@sipsolutions.net>
References: <1337201389-21553-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If drv->op_mode is NULL after trying to init the
opmode, we go to the wrong label. Fix this, and
clean up the code a bit.

Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Reviewed-by: Guy Cohen <guy.cohen@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 3c72bad..d742900 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -657,17 +657,17 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 	return -EINVAL;
 }
 
-static int alloc_pci_desc(struct iwl_drv *drv,
-			  struct iwl_firmware_pieces *pieces,
-			  enum iwl_ucode_type type)
+static int iwl_alloc_ucode(struct iwl_drv *drv,
+			   struct iwl_firmware_pieces *pieces,
+			   enum iwl_ucode_type type)
 {
 	int i;
 	for (i = 0;
 	     i < IWL_UCODE_SECTION_MAX && get_sec_size(pieces, type, i);
 	     i++)
 		if (iwl_alloc_fw_desc(drv, &(drv->fw.img[type].sec[i]),
-						get_sec(pieces, type, i)))
-			return -1;
+				      get_sec(pieces, type, i)))
+			return -ENOMEM;
 	return 0;
 }
 
@@ -825,8 +825,8 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	 * 1) unmodified from disk
 	 * 2) backup cache for save/restore during power-downs */
 	for (i = 0; i < IWL_UCODE_TYPE_MAX; i++)
-		if (alloc_pci_desc(drv, &pieces, i))
-			goto err_pci_alloc;
+		if (iwl_alloc_ucode(drv, &pieces, i))
+			goto out_free_fw;
 
 	/* Now that we can no longer fail, copy information */
 
@@ -866,7 +866,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	drv->op_mode = iwl_dvm_ops.start(drv->trans, drv->cfg, &drv->fw);
 
 	if (!drv->op_mode)
-		goto out_unbind;
+		goto out_free_fw;
 
 	return;
 
@@ -877,7 +877,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		goto out_unbind;
 	return;
 
- err_pci_alloc:
+ out_free_fw:
 	IWL_ERR(drv, "failed to allocate pci memory\n");
 	iwl_dealloc_ucode(drv);
 	release_firmware(ucode_raw);
-- 
1.7.10

