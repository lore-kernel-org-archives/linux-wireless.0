Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33262 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbYLSCpT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:19 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 21/43] iwl3945: remove duplicate structures from iwl-3945.h
Date: Fri, 19 Dec 2008 10:37:21 +0800
Message-Id: <1229654263-21454-22-git-send-email-yi.zhu@intel.com> (sfid-20081219_034607_548992_4E816918)
In-Reply-To: <1229654263-21454-21-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-17-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-20-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-21-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kolekar, Abhijeet <abhijeet.kolekar@intel.com>

The patch renames and deletes duplicate structure from iwl-3945.h.
The following structures are renamed with iwlwifi counterparts:

	1) iwl3945_ac_qos
	2) iwl3945_ucode
	3) iwl3945_qos_capabity

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |   50 +-------------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 3 files changed, 4 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index f513930..4f8e6b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -275,55 +275,9 @@ struct iwl3945_rx_queue {
 #define IWL_INVALID_RATE     0xFF
 #define IWL_INVALID_VALUE    -1
 
-union iwl3945_ht_rate_supp {
-	u16 rates;
-	struct {
-		u8 siso_rate;
-		u8 mimo_rate;
-	};
-};
-
-union iwl3945_qos_capabity {
-	struct {
-		u8 edca_count:4;	/* bit 0-3 */
-		u8 q_ack:1;		/* bit 4 */
-		u8 queue_request:1;	/* bit 5 */
-		u8 txop_request:1;	/* bit 6 */
-		u8 reserved:1;		/* bit 7 */
-	} q_AP;
-	struct {
-		u8 acvo_APSD:1;		/* bit 0 */
-		u8 acvi_APSD:1;		/* bit 1 */
-		u8 ac_bk_APSD:1;	/* bit 2 */
-		u8 ac_be_APSD:1;	/* bit 3 */
-		u8 q_ack:1;		/* bit 4 */
-		u8 max_len:2;		/* bit 5-6 */
-		u8 more_data_ack:1;	/* bit 7 */
-	} q_STA;
-	u8 val;
-};
-
-/* QoS structures */
-struct iwl3945_qos_info {
-	int qos_active;
-	union iwl3945_qos_capabity qos_cap;
-	struct iwl_qosparam_cmd def_qos_parm;
-};
-
 #define STA_PS_STATUS_WAKE             0
 #define STA_PS_STATUS_SLEEP            1
 
-/* uCode file layout */
-struct iwl3945_ucode {
-	__le32 ver;		/* major/minor/API/serial */
-	__le32 inst_size;	/* bytes of runtime instructions */
-	__le32 data_size;	/* bytes of runtime data */
-	__le32 init_size;	/* bytes of initialization instructions */
-	__le32 init_data_size;	/* bytes of initialization data */
-	__le32 boot_size;	/* bytes of bootstrap instructions */
-	u8 data[0];		/* data in same order as "size" elements */
-};
-
 struct iwl3945_ibss_seq {
 	u8 mac[ETH_ALEN];
 	u16 seq_num;
@@ -561,7 +515,7 @@ struct iwl3945_priv {
 
 	/* uCode images, save to reload in case of failure */
 	u32 ucode_ver;			/* ucode version, copy of
-					   iwl3945_ucode.ver */
+					   iwl_ucode.ver */
 	struct fw_desc ucode_code;	/* runtime inst */
 	struct fw_desc ucode_data;	/* runtime data original */
 	struct fw_desc ucode_data_backup;	/* runtime data save/restore */
@@ -672,7 +626,7 @@ struct iwl3945_priv {
 	u16 assoc_capability;
 	u8 ps_mode;
 
-	struct iwl3945_qos_info qos_data;
+	struct iwl_qos_info qos_data;
 
 	struct workqueue_struct *workqueue;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 73318a9..245f1d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -429,7 +429,7 @@ struct iwl_hw_key {
 	u8 key[32];
 };
 
-union iwl4965_ht_rate_supp {
+union iwl_ht_rate_supp {
 	u16 rates;
 	struct {
 		u8 siso_rate;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 6b6aceb..e37a28f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5238,7 +5238,7 @@ static void iwl3945_nic_start(struct iwl3945_priv *priv)
  */
 static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 {
-	struct iwl3945_ucode *ucode;
+	struct iwl_ucode *ucode;
 	int ret = -EINVAL, index;
 	const struct firmware *ucode_raw;
 	/* firmware file name contains uCode/driver compatibility version */
-- 
1.5.3.6

