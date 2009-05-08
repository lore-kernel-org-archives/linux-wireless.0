Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20575 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757452AbZEHUi0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 16:38:26 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/11] iwlwifi: default WMM AC parameters
Date: Fri,  8 May 2009 13:44:45 -0700
Message-Id: <1241815486-13510-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1241815486-13510-10-git-send-email-reinette.chatre@intel.com>
References: <1241815486-13510-1-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-2-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-3-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-4-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-5-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-6-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-7-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-8-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-9-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-10-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Set the default WMM AC parameters for BK/BE/VI/VO parameters:

AC        CWmin         CW max      AIFSN      TXOP Limit    TXOP Limit
                                              (802.11b)      (802.11a/g)
AC_BK      15            1023        7           0               0
AC_BE      15            1023        3           0               0
AC_VI       7              15        2          188             94
                                              (6.016ms)       (3.008ms)
AC_VO       3               7        2          102             47
                                              (3.264ms)       (1.504ms)

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index a630128..a3dc6ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -273,6 +273,14 @@ void iwl_activate_qos(struct iwl_priv *priv, u8 force)
 }
 EXPORT_SYMBOL(iwl_activate_qos);
 
+/*
+ * AC        CWmin         CW max      AIFSN      TXOP Limit    TXOP Limit
+ *                                              (802.11b)      (802.11a/g)
+ * AC_BK      15            1023        7           0               0
+ * AC_BE      15            1023        3           0               0
+ * AC_VI       7              15        2          6.016ms       3.008ms
+ * AC_VO       3               7        2          3.264ms       1.504ms
+ */
 void iwl_reset_qos(struct iwl_priv *priv)
 {
 	u16 cw_min = 15;
@@ -304,6 +312,7 @@ void iwl_reset_qos(struct iwl_priv *priv)
 	if (priv->qos_data.qos_active)
 		aifs = 3;
 
+	/* AC_BE */
 	priv->qos_data.def_qos_parm.ac[0].cw_min = cpu_to_le16(cw_min);
 	priv->qos_data.def_qos_parm.ac[0].cw_max = cpu_to_le16(cw_max);
 	priv->qos_data.def_qos_parm.ac[0].aifsn = aifs;
@@ -311,6 +320,7 @@ void iwl_reset_qos(struct iwl_priv *priv)
 	priv->qos_data.def_qos_parm.ac[0].reserved1 = 0;
 
 	if (priv->qos_data.qos_active) {
+		/* AC_BK */
 		i = 1;
 		priv->qos_data.def_qos_parm.ac[i].cw_min = cpu_to_le16(cw_min);
 		priv->qos_data.def_qos_parm.ac[i].cw_max = cpu_to_le16(cw_max);
@@ -318,11 +328,12 @@ void iwl_reset_qos(struct iwl_priv *priv)
 		priv->qos_data.def_qos_parm.ac[i].edca_txop = 0;
 		priv->qos_data.def_qos_parm.ac[i].reserved1 = 0;
 
+		/* AC_VI */
 		i = 2;
 		priv->qos_data.def_qos_parm.ac[i].cw_min =
 			cpu_to_le16((cw_min + 1) / 2 - 1);
 		priv->qos_data.def_qos_parm.ac[i].cw_max =
-			cpu_to_le16(cw_max);
+			cpu_to_le16(cw_min);
 		priv->qos_data.def_qos_parm.ac[i].aifsn = 2;
 		if (is_legacy)
 			priv->qos_data.def_qos_parm.ac[i].edca_txop =
@@ -332,11 +343,12 @@ void iwl_reset_qos(struct iwl_priv *priv)
 				cpu_to_le16(3008);
 		priv->qos_data.def_qos_parm.ac[i].reserved1 = 0;
 
+		/* AC_VO */
 		i = 3;
 		priv->qos_data.def_qos_parm.ac[i].cw_min =
 			cpu_to_le16((cw_min + 1) / 4 - 1);
 		priv->qos_data.def_qos_parm.ac[i].cw_max =
-			cpu_to_le16((cw_max + 1) / 2 - 1);
+			cpu_to_le16((cw_min + 1) / 2 - 1);
 		priv->qos_data.def_qos_parm.ac[i].aifsn = 2;
 		priv->qos_data.def_qos_parm.ac[i].reserved1 = 0;
 		if (is_legacy)
-- 
1.5.6.3

