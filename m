Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:62255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933590AbcCIRqH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 12:46:07 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/21] iwlwifi: mvm: set the correct amsdu enum values
Date: Wed,  9 Mar 2016 19:45:36 +0200
Message-Id: <1457545550-30677-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_184613_866341_B54206B8)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The amsdu enum values are off by 1 bit. Fix it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
index eb9b870..7a16e55 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
@@ -264,9 +264,8 @@ enum iwl_rx_mpdu_mac_flags2 {
 };
 
 enum iwl_rx_mpdu_amsdu_info {
-	IWL_RX_MPDU_AMSDU_SUBFRAME_IDX_MASK	= 0x3f,
-	IWL_RX_MPDU_AMSDU_LAST_SUBFRAME		= 0x40,
-	/* 0x80 bit reserved for now */
+	IWL_RX_MPDU_AMSDU_SUBFRAME_IDX_MASK	= 0x7f,
+	IWL_RX_MPDU_AMSDU_LAST_SUBFRAME		= 0x80,
 };
 
 enum iwl_rx_l3l4_flags {
-- 
2.5.0

