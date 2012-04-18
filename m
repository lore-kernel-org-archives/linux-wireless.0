Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39112 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566Ab2DROpv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 10:45:51 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/15] iwlwifi: Change disable calibration bit-set to enum
Date: Wed, 18 Apr 2012 07:41:12 -0700
Message-Id: <1334760077-5714-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120418_165904_230423_01CF27C5)
In-Reply-To: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Changed disable calibration bit field defines to enum.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 22386a7..f3eccf6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -742,12 +742,15 @@ struct iwl_wipan_noa_data {
 };
 
 /* Calibration disabling bit mask */
-#define IWL_SENSITIVITY_CALIB_DISABLED	BIT(1)
-#define IWL_CHAIN_NOISE_CALIB_DISABLED	BIT(2)
-#define IWL_TX_POWER_CALIB_DISABLED	BIT(3)
+enum {
+	IWL_CALIB_ENABLE_ALL			= 0,
+
+	IWL_SENSITIVITY_CALIB_DISABLED		= BIT(0),
+	IWL_CHAIN_NOISE_CALIB_DISABLED		= BIT(1),
+	IWL_TX_POWER_CALIB_DISABLED		= BIT(2),
 
-#define IWL_CALIB_ENABLE_ALL	0
-#define IWL_CALIB_DISABLE_ALL	0xFFFFFFFF
+	IWL_CALIB_DISABLE_ALL			= 0xFFFFFFFF,
+};
 
 #define IWL_OP_MODE_GET_DVM(_iwl_op_mode) \
 	((struct iwl_priv *) ((_iwl_op_mode)->op_mode_specific))
-- 
1.7.0.4

