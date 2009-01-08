Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38308 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756528AbZAHSSZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 13:18:25 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <sameo@linux.intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/11] iwl3945: Change crypto parameter name
Date: Thu,  8 Jan 2009 10:19:59 -0800
Message-Id: <1231438802-10991-9-git-send-email-reinette.chatre@intel.com> (sfid-20090108_191839_600558_385EED38)
In-Reply-To: <1231438802-10991-8-git-send-email-reinette.chatre@intel.com>
References: <>
 <1231438802-10991-1-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-2-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-3-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-4-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-5-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-6-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-7-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

Now that we're using iwl_mod_params, we want our module parameters names to be
in sync with the structure.
So, to set iwl_mod_params.sw_crypto, we'd better use a "swcrypto" parameter
name instead of the "hwcrypto" current one.
Moreover, by setting the decrypted flag properly, this patch also fixes the HW
crypto path for 3945 (the current code is not setting it when running HW
crypto).

This is a bug fix for bug #1872
( http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1872 )

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 1b712e3..e8a8e54 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -600,7 +600,7 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
 	/* Set the size of the skb to the size of the frame */
 	skb_put(rxb->skb, le16_to_cpu(rx_hdr->len));
 
-	if (iwl3945_mod_params.sw_crypto)
+	if (!iwl3945_mod_params.sw_crypto)
 		iwl3945_set_decrypted_flag(priv, rxb->skb,
 				       le32_to_cpu(rx_end->status), stats);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index f1158a4..0604475 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -92,6 +92,7 @@ MODULE_LICENSE("GPL");
  /* module parameters */
 struct iwl_mod_params iwl3945_mod_params = {
 	.num_of_queues = IWL39_MAX_NUM_QUEUES,
+	.sw_crypto = 1,
 	/* the rest are 0 by default */
 };
 
@@ -7832,9 +7833,9 @@ module_param_named(antenna, iwl3945_mod_params.antenna, int, 0444);
 MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
 module_param_named(disable, iwl3945_mod_params.disable, int, 0444);
 MODULE_PARM_DESC(disable, "manually disable the radio (default 0 [radio on])");
-module_param_named(hwcrypto, iwl3945_mod_params.sw_crypto, int, 0444);
-MODULE_PARM_DESC(hwcrypto,
-		 "using hardware crypto engine (default 0 [software])\n");
+module_param_named(swcrypto, iwl3945_mod_params.sw_crypto, int, 0444);
+MODULE_PARM_DESC(swcrypto,
+		 "using software crypto (default 1 [software])\n");
 module_param_named(debug, iwl3945_mod_params.debug, uint, 0444);
 MODULE_PARM_DESC(debug, "debug output mask");
 module_param_named(disable_hw_scan, iwl3945_mod_params.disable_hw_scan, int, 0444);
-- 
1.5.4.3

