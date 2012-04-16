Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28026 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626Ab2DPWBa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 18:01:30 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/16] iwlwifi: remove double verification of ucode sections
Date: Mon, 16 Apr 2012 14:57:04 -0700
Message-Id: <1334613430-30720-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120417_000158_909975_ECA09C0C)
In-Reply-To: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c |   36 --------------------------------
 1 files changed, 0 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index da4d85a..17485e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -808,42 +808,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	IWL_INFO(drv, "loaded firmware version %s", drv->fw.fw_version);
 
 	/*
-	 * For any of the failures below (before allocating pci memory)
-	 * we will try to load a version with a smaller API -- maybe the
-	 * user just got a corrupted version of the latest API.
-	 */
-
-	IWL_DEBUG_INFO(drv, "f/w package hdr ucode version raw = 0x%x\n",
-		       drv->fw.ucode_ver);
-	IWL_DEBUG_INFO(drv, "f/w package hdr runtime inst size = %Zd\n",
-		get_sec_size(&pieces, IWL_UCODE_REGULAR,
-			     IWL_UCODE_SECTION_INST));
-	IWL_DEBUG_INFO(drv, "f/w package hdr runtime data size = %Zd\n",
-		get_sec_size(&pieces, IWL_UCODE_REGULAR,
-			     IWL_UCODE_SECTION_DATA));
-	IWL_DEBUG_INFO(drv, "f/w package hdr init inst size = %Zd\n",
-		get_sec_size(&pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST));
-	IWL_DEBUG_INFO(drv, "f/w package hdr init data size = %Zd\n",
-		get_sec_size(&pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_DATA));
-
-	/* Verify that uCode images will fit in card's SRAM */
-	if (get_sec_size(&pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_INST) >
-							cfg->max_inst_size) {
-		IWL_ERR(drv, "uCode instr len %Zd too large to fit in\n",
-			get_sec_size(&pieces, IWL_UCODE_REGULAR,
-				     IWL_UCODE_SECTION_INST));
-		goto try_again;
-	}
-
-	if (get_sec_size(&pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_DATA) >
-							cfg->max_data_size) {
-		IWL_ERR(drv, "uCode data len %Zd too large to fit in\n",
-			get_sec_size(&pieces, IWL_UCODE_REGULAR,
-				     IWL_UCODE_SECTION_DATA));
-		goto try_again;
-	}
-
-	/*
 	 * In mvm uCode there is no difference between data and instructions
 	 * sections.
 	 */
-- 
1.7.0.4

