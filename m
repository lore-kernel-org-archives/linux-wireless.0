Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15281 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760061AbZKFWxB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:53:01 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/20] iwlwifi: no periodic Tx/IQ calibration for 6x00/6x50 series
Date: Fri,  6 Nov 2009 14:52:49 -0800
Message-Id: <1257547983-12590-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
References: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For both 6x00 and 6x50 series devices, periodic Tx IQ calibration is
disabled in uCode, driver do not need to set the periodic Tx/IQ calibration
bit in calibration command.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 70e117f..9ab7954 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -166,9 +166,7 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 			BIT(IWL_CALIB_XTAL)		|
 			BIT(IWL_CALIB_LO)		|
 			BIT(IWL_CALIB_TX_IQ) 		|
-			BIT(IWL_CALIB_TX_IQ_PERD)	|
 			BIT(IWL_CALIB_BASE_BAND);
-
 	return 0;
 }
 
-- 
1.5.6.3

