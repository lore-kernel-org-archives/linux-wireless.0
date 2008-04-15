Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54268 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbYDOEQQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 00:16:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 03/12] iwlwifi: add default WEP key host command
Date: Mon, 14 Apr 2008 21:16:05 -0700
Message-Id: <1208232974-3828-4-git-send-email-reinette.chatre@intel.com> (sfid-20080415_051621_843676_69661F7C)
In-Reply-To: <1208232974-3828-3-git-send-email-reinette.chatre@intel.com>
References: <1208232974-3828-1-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-2-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch adds declaration for static WEP host command. This command will
be used for default WEP group keys when no key mapping keys are used.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |   27 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-hcmd.c          |    1 +
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 7e36ecb..65cd8ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -84,6 +84,9 @@ enum {
 	REPLY_REMOVE_STA = 0x19,	/* not used */
 	REPLY_REMOVE_ALL_STA = 0x1a,	/* not used */
 
+	/* Security */
+	REPLY_WEPKEY = 0x20,
+
 	/* RX, TX, LEDs */
 	REPLY_TX = 0x1c,
 	REPLY_RATE_SCALE = 0x47,	/* 3945 only */
@@ -850,6 +853,30 @@ struct iwl4965_add_sta_resp {
 	u8 status;	/* ADD_STA_* */
 } __attribute__ ((packed));
 
+/*
+ * REPLY_WEP_KEY = 0x20
+ */
+struct iwl_wep_key {
+	u8 key_index;
+	u8 key_offset;
+	u8 reserved1[2];
+	u8 key_size;
+	u8 reserved2[3];
+	u8 key[16];
+} __attribute__ ((packed));
+
+struct iwl_wep_cmd {
+	u8 num_keys;
+	u8 global_key_type;
+	u8 flags;
+	u8 reserved;
+	struct iwl_wep_key key[0];
+} __attribute__ ((packed));
+
+#define WEP_KEY_WEP_TYPE 1
+#define WEP_KEYS_MAX 4
+#define WEP_INVALID_OFFSET 0xff
+#define WEP_KEY_LEN_128 13
 
 /******************************************************************************
  * (4)
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 1f8c299..fdb27f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -51,6 +51,7 @@ const char *get_cmd_string(u8 cmd)
 		IWL_CMD(REPLY_ADD_STA);
 		IWL_CMD(REPLY_REMOVE_STA);
 		IWL_CMD(REPLY_REMOVE_ALL_STA);
+		IWL_CMD(REPLY_WEPKEY);
 		IWL_CMD(REPLY_TX);
 		IWL_CMD(REPLY_RATE_SCALE);
 		IWL_CMD(REPLY_LEDS_CMD);
-- 
1.5.3.4

