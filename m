Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24332 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbZJWUmd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 16:42:33 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/18] iwlwifi: fix gain computation for 5000 series and up
Date: Fri, 23 Oct 2009 13:42:20 -0700
Message-Id: <1256330556-20997-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
References: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

In Rx gain balancing (chain noise) computation for 5000 series and up,
the delta gain calculation should use the average noise of default
chain, not "chain 0" which do not exist for all the devices.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 17555c7..afa88a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -236,7 +236,7 @@ static void iwl5000_gain_computation(struct iwl_priv *priv,
 			data->delta_gain_code[i] = 0;
 			continue;
 		}
-		delta_g = (1000 * ((s32)average_noise[0] -
+		delta_g = (1000 * ((s32)average_noise[default_chain] -
 			(s32)average_noise[i])) / 1500;
 		/* bound gain by 2 bits value max, 3rd bit is sign */
 		data->delta_gain_code[i] =
-- 
1.5.6.3

