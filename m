Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:58107 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbaBCU7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:14 -0500
Received: by mail-ee0-f50.google.com with SMTP id d17so3854751eek.23
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:13 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 36/62] iwlwifi: add enter/exit D0i3 ops
Date: Mon,  3 Feb 2014 22:57:42 +0200
Message-Id: <1391461088-8082-36-git-send-email-egrumbach@gmail.com> (sfid-20140203_223008_163583_AB11DAA1)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Add new enter_d0i3 and exit_d0i3 ops that
will be called by the transport on D0i3 enter/exit.

Each one of these ops will include the host commands
mentionned in the previous patch.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    2 ++
 drivers/net/wireless/iwlwifi/iwl-op-mode.h |   22 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c     |   18 ++++++++++++++++++
 3 files changed, 42 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index a75aac9..c8cbdbe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -126,6 +126,7 @@ do {                                            			\
 /* 0x00000F00 - 0x00000100 */
 #define IWL_DL_POWER		0x00000100
 #define IWL_DL_TEMP		0x00000200
+#define IWL_DL_RPM		0x00000400
 #define IWL_DL_SCAN		0x00000800
 /* 0x0000F000 - 0x00001000 */
 #define IWL_DL_ASSOC		0x00001000
@@ -189,5 +190,6 @@ do {                                            			\
 #define IWL_DEBUG_RADIO(p, f, a...)	IWL_DEBUG(p, IWL_DL_RADIO, f, ## a)
 #define IWL_DEBUG_POWER(p, f, a...)	IWL_DEBUG(p, IWL_DL_POWER, f, ## a)
 #define IWL_DEBUG_11H(p, f, a...)	IWL_DEBUG(p, IWL_DL_11H, f, ## a)
+#define IWL_DEBUG_RPM(p, f, a...)	IWL_DEBUG(p, IWL_DL_RPM, f, ## a)
 
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index b5be51f..f83b244 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -131,6 +131,8 @@ struct iwl_cfg;
  * @nic_config: configure NIC, called before firmware is started.
  *	May sleep
  * @wimax_active: invoked when WiMax becomes active. May sleep
+ * @enter_d0i3: configure the fw to enter d0i3. May sleep.
+ * @exit_d0i3: configure the fw to exit d0i3. May sleep.
  */
 struct iwl_op_mode_ops {
 	struct iwl_op_mode *(*start)(struct iwl_trans *trans,
@@ -148,6 +150,8 @@ struct iwl_op_mode_ops {
 	void (*cmd_queue_full)(struct iwl_op_mode *op_mode);
 	void (*nic_config)(struct iwl_op_mode *op_mode);
 	void (*wimax_active)(struct iwl_op_mode *op_mode);
+	int (*enter_d0i3)(struct iwl_op_mode *op_mode);
+	int (*exit_d0i3)(struct iwl_op_mode *op_mode);
 };
 
 int iwl_opmode_register(const char *name, const struct iwl_op_mode_ops *ops);
@@ -226,4 +230,22 @@ static inline void iwl_op_mode_wimax_active(struct iwl_op_mode *op_mode)
 	op_mode->ops->wimax_active(op_mode);
 }
 
+static inline int iwl_op_mode_enter_d0i3(struct iwl_op_mode *op_mode)
+{
+	might_sleep();
+
+	if (!op_mode->ops->enter_d0i3)
+		return 0;
+	return op_mode->ops->enter_d0i3(op_mode);
+}
+
+static inline int iwl_op_mode_exit_d0i3(struct iwl_op_mode *op_mode)
+{
+	might_sleep();
+
+	if (!op_mode->ops->exit_d0i3)
+		return 0;
+	return op_mode->ops->exit_d0i3(op_mode);
+}
+
 #endif /* __iwl_op_mode_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index cf33a12..0f87bc3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -812,6 +812,22 @@ static void iwl_mvm_cmd_queue_full(struct iwl_op_mode *op_mode)
 	iwl_mvm_nic_restart(mvm);
 }
 
+static int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
+{
+	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
+
+	IWL_DEBUG_RPM(mvm, "MVM entering D0i3\n");
+	return 0;
+}
+
+static int iwl_mvm_exit_d0i3(struct iwl_op_mode *op_mode)
+{
+	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
+
+	IWL_DEBUG_RPM(mvm, "MVM exiting D0i3\n");
+	return 0;
+}
+
 static const struct iwl_op_mode_ops iwl_mvm_ops = {
 	.start = iwl_op_mode_mvm_start,
 	.stop = iwl_op_mode_mvm_stop,
@@ -823,4 +839,6 @@ static const struct iwl_op_mode_ops iwl_mvm_ops = {
 	.nic_error = iwl_mvm_nic_error,
 	.cmd_queue_full = iwl_mvm_cmd_queue_full,
 	.nic_config = iwl_mvm_nic_config,
+	.enter_d0i3 = iwl_mvm_enter_d0i3,
+	.exit_d0i3 = iwl_mvm_exit_d0i3,
 };
-- 
1.7.9.5

