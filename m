Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44073 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762578AbXG0J3E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 05:29:04 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 11/17] iwlwifi: endianity cleanup for QoS host command
Date: Fri, 27 Jul 2007 17:26:35 +0800
Message-Id: <11855284212390-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11855284201330-git-send-email-yi.zhu@intel.com>
References: <11855284012123-git-send-email-yi.zhu@intel.com>
 <11855284032407-git-send-email-yi.zhu@intel.com>
 <11855284053896-git-send-email-yi.zhu@intel.com>
 <11855284072074-git-send-email-yi.zhu@intel.com>
 <1185528408776-git-send-email-yi.zhu@intel.com>
 <11855284103871-git-send-email-yi.zhu@intel.com>
 <11855284122218-git-send-email-yi.zhu@intel.com>
 <11855284142478-git-send-email-yi.zhu@intel.com>
 <11855284161716-git-send-email-yi.zhu@intel.com>
 <11855284183313-git-send-email-yi.zhu@intel.com>
 <11855284201330-git-send-email-yi.zhu@intel.com>
To: ipwpatch@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch cleans up endianity issues in QoS host command.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c |   54 ++++++++++++++++----------------------
 drivers/net/wireless/iwl-hw.h   |   12 +++------
 2 files changed, 27 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 8f9714f..d56360c 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -1898,7 +1898,6 @@ static void iwl_reset_qos(struct iwl_priv *priv)
 	u16 cw_min = 15;
 	u16 cw_max = 1023;
 	u8 aifs = 2;
-	u16 burst_time = 0;
 	u8 is_legacy = 0;
 	unsigned long flags;
 	int i;
@@ -1923,63 +1922,56 @@ static void iwl_reset_qos(struct iwl_priv *priv)
 	if (priv->qos_data.qos_active)
 		aifs = 3;
 
-	priv->qos_data.def_qos_parm.ac[0].cw_min = (__le16)
-	    cpu_to_le16(cw_min);
-	priv->qos_data.def_qos_parm.ac[0].cw_max = (__le16)
-	    cpu_to_le16(cw_max);
+	priv->qos_data.def_qos_parm.ac[0].cw_min = cpu_to_le16(cw_min);
+	priv->qos_data.def_qos_parm.ac[0].cw_max = cpu_to_le16(cw_max);
 	priv->qos_data.def_qos_parm.ac[0].aifsn = aifs;
-	priv->qos_data.def_qos_parm.ac[0].edca_txop = (__le16)
-	    cpu_to_le16(burst_time);
+	priv->qos_data.def_qos_parm.ac[0].edca_txop = 0;
 	priv->qos_data.def_qos_parm.ac[0].reserved1 = 0;
 
 	if (priv->qos_data.qos_active) {
 		i = 1;
-		priv->qos_data.def_qos_parm.ac[i].cw_min = (__le16)
-		    cpu_to_le16(cw_min);
-		priv->qos_data.def_qos_parm.ac[i].cw_max = (__le16)
-		    cpu_to_le16(cw_max);
+		priv->qos_data.def_qos_parm.ac[i].cw_min = cpu_to_le16(cw_min);
+		priv->qos_data.def_qos_parm.ac[i].cw_max = cpu_to_le16(cw_max);
 		priv->qos_data.def_qos_parm.ac[i].aifsn = 7;
-		priv->qos_data.def_qos_parm.ac[i].edca_txop = (__le16)
-		    cpu_to_le16(burst_time);
+		priv->qos_data.def_qos_parm.ac[i].edca_txop = 0;
 		priv->qos_data.def_qos_parm.ac[i].reserved1 = 0;
 
 		i = 2;
-		priv->qos_data.def_qos_parm.ac[i].cw_min = (__le16)
+		priv->qos_data.def_qos_parm.ac[i].cw_min =
 		    cpu_to_le16((cw_min + 1) / 2 - 1);
-		priv->qos_data.def_qos_parm.ac[i].cw_max = (__le16)
+		priv->qos_data.def_qos_parm.ac[i].cw_max =
 		    cpu_to_le16(cw_max);
 		priv->qos_data.def_qos_parm.ac[i].aifsn = 2;
 		if (is_legacy)
-			priv->qos_data.def_qos_parm.ac[i].edca_txop = (__le16)
-			    cpu_to_le16(6016);
+			priv->qos_data.def_qos_parm.ac[i].edca_txop =
+				cpu_to_le16(6016);
 		else
-			priv->qos_data.def_qos_parm.ac[i].edca_txop = (__le16)
-			    cpu_to_le16(3008);
+			priv->qos_data.def_qos_parm.ac[i].edca_txop =
+				cpu_to_le16(3008);
 		priv->qos_data.def_qos_parm.ac[i].reserved1 = 0;
 
 		i = 3;
-		priv->qos_data.def_qos_parm.ac[i].cw_min = (__le16)
+		priv->qos_data.def_qos_parm.ac[i].cw_min =
 		    cpu_to_le16((cw_min + 1) / 4 - 1);
-		priv->qos_data.def_qos_parm.ac[i].cw_max = (__le16)
+		priv->qos_data.def_qos_parm.ac[i].cw_max =
 		    cpu_to_le16((cw_max + 1) / 2 - 1);
 		priv->qos_data.def_qos_parm.ac[i].aifsn = 2;
 		priv->qos_data.def_qos_parm.ac[i].reserved1 = 0;
 		if (is_legacy)
-			priv->qos_data.def_qos_parm.ac[i].edca_txop = (__le16)
-			    cpu_to_le16(3264);
+			priv->qos_data.def_qos_parm.ac[i].edca_txop =
+				cpu_to_le16(3264);
 		else
-			priv->qos_data.def_qos_parm.ac[i].edca_txop = (__le16)
-			    cpu_to_le16(1504);
+			priv->qos_data.def_qos_parm.ac[i].edca_txop =
+				cpu_to_le16(1504);
 
 	} else {
 		for (i = 1; i < 4; i++) {
-			priv->qos_data.def_qos_parm.ac[i].cw_min = (__le16)
-			    cpu_to_le16(cw_min);
-			priv->qos_data.def_qos_parm.ac[i].cw_max = (__le16)
-			    cpu_to_le16(cw_max);
+			priv->qos_data.def_qos_parm.ac[i].cw_min =
+				cpu_to_le16(cw_min);
+			priv->qos_data.def_qos_parm.ac[i].cw_max =
+				cpu_to_le16(cw_max);
 			priv->qos_data.def_qos_parm.ac[i].aifsn = aifs;
-			priv->qos_data.def_qos_parm.ac[i].edca_txop = (__le16)
-			    cpu_to_le16(burst_time);
+			priv->qos_data.def_qos_parm.ac[i].edca_txop = 0;
 			priv->qos_data.def_qos_parm.ac[i].reserved1 = 0;
 		}
 	}
diff --git a/drivers/net/wireless/iwl-hw.h b/drivers/net/wireless/iwl-hw.h
index 7512fc7..e73cf88 100644
--- a/drivers/net/wireless/iwl-hw.h
+++ b/drivers/net/wireless/iwl-hw.h
@@ -254,19 +254,15 @@ struct iwl_ac_qos {
 } __attribute__ ((packed));
 
 /* QoS flags defines */
-#define MH_QOS_TXOP_TYPE_MSK 0x10
-#define QOS_PARAM_FLG_UPDATE_EDCA_MSK 0x1
-#define QOS_PARAM_FLG_TGN_MSK 0x2
-#define QOS_PARAM_FLG_TXOP_TYPE_MSK MH_QOS_TXOP_TYPE_MSK
+#define QOS_PARAM_FLG_UPDATE_EDCA_MSK	__constant_cpu_to_le32(0x01)
+#define QOS_PARAM_FLG_TGN_MSK		__constant_cpu_to_le32(0x02)
+#define QOS_PARAM_FLG_TXOP_TYPE_MSK	__constant_cpu_to_le32(0x10)
 
 /*
  *  TXFIFO Queue number defines
  */
 /* number of Access categories (AC) (EDCA), queues 0..3 */
 #define AC_NUM                4
-/* total number of queues */
-#define QUEUE_NUM             7
-/* command queue number */
 
 struct iwl_qosparam_cmd {
 	__le32 qos_flags;
@@ -893,7 +889,7 @@ struct statistics {
 #define CSR_HW_IF_CONFIG_REG_BIT_BOARD_TYPE         (0x00000800)
 #define CSR_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_A    (0x00000000)
 #define CSR_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_B    (0x00001000)
-#define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM	    (0x00200000)
+#define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM     (0x00200000)
 
 #define CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP             (0x00000001)
 #define CSR_UCODE_SW_BIT_RFKILL                     (0x00000002)
-- 
1.5.2
