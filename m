Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14459 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab2DROpu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 10:45:50 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/15] iwlwifi: driver holds its pointer to the transport
Date: Wed, 18 Apr 2012 07:41:08 -0700
Message-Id: <1334760077-5714-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120418_165903_885256_D8F2D6F7)
In-Reply-To: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Instead of using the shared area that we be killed.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 77262f2..8270623 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -114,7 +114,7 @@ struct fw_sec {
 static void iwl_free_fw_desc(struct iwl_drv *drv, struct fw_desc *desc)
 {
 	if (desc->v_addr)
-		dma_free_coherent(trans(drv)->dev, desc->len,
+		dma_free_coherent(drv->trans->dev, desc->len,
 				  desc->v_addr, desc->p_addr);
 	desc->v_addr = NULL;
 	desc->len = 0;
@@ -142,7 +142,7 @@ static int iwl_alloc_fw_desc(struct iwl_drv *drv, struct fw_desc *desc,
 		return -EINVAL;
 	}
 
-	desc->v_addr = dma_alloc_coherent(trans(drv)->dev, sec->size,
+	desc->v_addr = dma_alloc_coherent(drv->trans->dev, sec->size,
 					  &desc->p_addr, GFP_KERNEL);
 	if (!desc->v_addr)
 		return -ENOMEM;
@@ -189,7 +189,7 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 		       drv->firmware_name);
 
 	return request_firmware_nowait(THIS_MODULE, 1, drv->firmware_name,
-				       trans(drv)->dev,
+				       drv->trans->dev,
 				       GFP_KERNEL, drv, iwl_ucode_callback);
 }
 
@@ -880,7 +880,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	release_firmware(ucode_raw);
  out_unbind:
 	complete(&drv->request_firmware_complete);
-	device_release_driver(trans(drv)->dev);
+	device_release_driver(drv->trans->dev);
 }
 
 struct iwl_drv *iwl_drv_start(struct iwl_shared *shrd,
-- 
1.7.0.4

