Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34245 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793AbZAWVmy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 16:42:54 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/15] iwlwifi: fix probe mask for 39 scan API
Date: Fri, 23 Jan 2009 13:45:21 -0800
Message-Id: <1232747123-7261-14-git-send-email-reinette.chatre@intel.com> (sfid-20090123_230906_749622_DE43D124)
In-Reply-To: <1232747123-7261-13-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232747123-7261-1-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-2-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-3-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-4-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-5-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-6-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-7-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-8-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-9-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-10-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-11-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-12-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-13-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This pach make use of 39 own scan probe mask
the variables or of different types

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 7571110..e49415c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2432,6 +2432,9 @@ struct iwl3945_scan_channel {
 	__le16 passive_dwell;	/* in 1024-uSec TU (time units), typ 20-500 */
 } __attribute__ ((packed));
 
+/* set number of direct probes u8 type */
+#define IWL39_SCAN_PROBE_MASK(n) ((BIT(n) | (BIT(n) - BIT(1))))
+
 struct iwl_scan_channel {
 	/*
 	 * type is defined as:
@@ -2448,6 +2451,9 @@ struct iwl_scan_channel {
 	__le16 passive_dwell;	/* in 1024-uSec TU (time units), typ 20-500 */
 } __attribute__ ((packed));
 
+/* set number of direct probes __le32 type */
+#define IWL_SCAN_PROBE_MASK(n) 	cpu_to_le32((BIT(n) | (BIT(n) - BIT(1))))
+
 /**
  * struct iwl_ssid_ie - directed scan network information element
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index c8e1dad..3c6a4b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -346,7 +346,6 @@ int iwl_send_scan_abort(struct iwl_priv *priv);
 #define IWL_ACTIVE_QUIET_TIME       __constant_cpu_to_le16(10)  /* msec */
 #define IWL_PLCP_QUIET_THRESH       __constant_cpu_to_le16(1)  /* packets */
 
-#define IWL_SCAN_PROBE_MASK(n) 	cpu_to_le32((BIT(n) | (BIT(n) - BIT(1))))
 
 /*******************************************************************************
  * Calibrations - implemented in iwl-calib.c
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d093255..25a3508 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3267,12 +3267,12 @@ static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
 		 * hearing clear Rx packet).*/
 		if (IWL_UCODE_API(priv->ucode_ver) >= 2) {
 			if (n_probes)
-				scan_ch->type |= IWL_SCAN_PROBE_MASK(n_probes);
+				scan_ch->type |= IWL39_SCAN_PROBE_MASK(n_probes);
 		} else {
 			/* uCode v1 does not allow setting direct probe bits on
 			 * passive channel. */
 			if ((scan_ch->type & 1) && n_probes)
-				scan_ch->type |= IWL_SCAN_PROBE_MASK(n_probes);
+				scan_ch->type |= IWL39_SCAN_PROBE_MASK(n_probes);
 		}
 
 		/* Set txpower levels to defaults */
-- 
1.5.4.3

