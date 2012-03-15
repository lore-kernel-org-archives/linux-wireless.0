Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21182 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161435Ab2COU2D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:03 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/26] iwlwifi: clarify config struct comments
Date: Thu, 15 Mar 2012 13:26:47 -0700
Message-Id: <1331843226-29860-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212809_360866_32E99209)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It talks about treating different uCode APIs
as different pieces of hardware which really
isn't how we handle things.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-shared.h |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index b515d65..94b16cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -307,13 +307,9 @@ struct iwl_ht_params {
  * @iq_invert: I/Q inversion
  * @temp_offset_v2: support v2 of temperature offset calibration
  *
- * We enable the driver to be backward compatible wrt API version. The
- * driver specifies which APIs it supports (with @ucode_api_max being the
- * highest and @ucode_api_min the lowest). Firmware will only be loaded if
- * it has a supported API version.
- *
- * The ideal usage of this infrastructure is to treat a new ucode API
- * release as a new hardware revision.
+ * We enable the driver to be backward compatible wrt. hardware features.
+ * API differences in uCode shouldn't be handled here but through TLVs
+ * and/or the uCode API version instead.
  */
 struct iwl_cfg {
 	/* params specific to an individual device within a device family */
-- 
1.7.0.4

