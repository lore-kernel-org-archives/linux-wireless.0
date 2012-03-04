Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54587 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052Ab2CDUnF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:05 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 043/101] iwlwifi: remove AMT check from transport
Date: Sun,  4 Mar 2012 11:28:57 -0800
Message-Id: <1330889395-533-44-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214608_384874_5A35F6BD)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As iwl_prepare_card_hw() is idempotent (and
many cards support AMT anyway) there's no
point in calling iwl_prepare_card_hw() only
for AMT capable devices -- call it always
and simplify the code that way.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 4a05216..4a2d4b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1033,8 +1033,8 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 	trans_pcie->mcast_queue[IWL_RXON_CTX_BSS] = 0;
 	trans_pcie->mcast_queue[IWL_RXON_CTX_PAN] = IWL_IPAN_MCAST_QUEUE;
 
-	if ((hw_params(trans).sku & EEPROM_SKU_CAP_AMT_ENABLE) &&
-	     iwl_prepare_card_hw(trans)) {
+	/* This may fail if AMT took ownership of the device */
+	if (iwl_prepare_card_hw(trans)) {
 		IWL_WARN(trans, "Exit HW not ready\n");
 		return -EIO;
 	}
-- 
1.7.0.4

