Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57207 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954Ab1IVXBT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 19:01:19 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/12] iwlagn: fix slot programming
Date: Thu, 22 Sep 2011 15:14:55 -0700
Message-Id: <1316729700-1770-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110923_010136_437561_1355C225)
In-Reply-To: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When an AP mode interface is added with a DTIM
period of two, the slot programming is wrong.
Fix it by taking into account the DTIM period.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 00e6fc5..ca632f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -370,7 +370,7 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 			slot1 = IWL_MIN_SLOT_TIME;
 		} else if (!ctx_pan->vif->bss_conf.idle &&
 			   !ctx_pan->vif->bss_conf.assoc) {
-			slot1 = bcnint * 3 - IWL_MIN_SLOT_TIME;
+			slot1 = dtim * bcnint * 3 - IWL_MIN_SLOT_TIME;
 			slot0 = IWL_MIN_SLOT_TIME;
 		}
 	} else if (ctx_pan->vif) {
-- 
1.7.0.4

