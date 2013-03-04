Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41858 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090Ab3CDOA4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 09:00:56 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/11] iwlwifi: disable 8K A-MSDU by default
Date: Mon,  4 Mar 2013 15:00:43 +0100
Message-Id: <1362405651-26456-3-git-send-email-johannes@sipsolutions.net> (sfid-20130304_150100_299993_2BEC24A2)
In-Reply-To: <1362405651-26456-1-git-send-email-johannes@sipsolutions.net>
References: <1362405609.21028.12.camel@jlt4.sipsolutions.net>
 <1362405651-26456-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Supporting 8K A-MSDU means that we need to allocate order 1
pages for every Rx packet. Even when there is no traffic.
This adds stress on the memory manager. The handling of
compound pages is also less trivial for the memory manager
and not using them will make the allocation code run faster
although I didn't really measure.
Eric also pointed out that having huge buffers with little
data in them is not very nice towards the TCP stack since
the truesize of the skb is huge. This doesn't allow TCP
to have a big Rx window.
See https://patchwork.kernel.org/patch/2167711/ for details.

Note that very few vendors will actually send A-MSDU.
Disable this feature by default.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c       | 3 +--
 drivers/net/wireless/iwlwifi/iwl-modparams.h | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 6f228bb..fbfd2d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1102,7 +1102,6 @@ void iwl_drv_stop(struct iwl_drv *drv)
 
 /* shared module parameters */
 struct iwl_mod_params iwlwifi_mod_params = {
-	.amsdu_size_8K = 1,
 	.restart_fw = 1,
 	.plcp_check = true,
 	.bt_coex_active = true,
@@ -1207,7 +1206,7 @@ MODULE_PARM_DESC(11n_disable,
 	"disable 11n functionality, bitmap: 1: full, 2: agg TX, 4: agg RX");
 module_param_named(amsdu_size_8K, iwlwifi_mod_params.amsdu_size_8K,
 		   int, S_IRUGO);
-MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size");
+MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size (default 0)");
 module_param_named(fw_restart, iwlwifi_mod_params.restart_fw, int, S_IRUGO);
 MODULE_PARM_DESC(fw_restart, "restart firmware in case of error");
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-modparams.h b/drivers/net/wireless/iwlwifi/iwl-modparams.h
index e5e3a79..2c2a729 100644
--- a/drivers/net/wireless/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/iwlwifi/iwl-modparams.h
@@ -91,7 +91,7 @@ enum iwl_power_level {
  * @sw_crypto: using hardware encryption, default = 0
  * @disable_11n: disable 11n capabilities, default = 0,
  *	use IWL_DISABLE_HT_* constants
- * @amsdu_size_8K: enable 8K amsdu size, default = 1
+ * @amsdu_size_8K: enable 8K amsdu size, default = 0
  * @restart_fw: restart firmware, default = 1
  * @plcp_check: enable plcp health check, default = true
  * @wd_disable: enable stuck queue check, default = 0
-- 
1.8.0

