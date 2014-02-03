Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:39826 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbaBCU7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:13 -0500
Received: by mail-ee0-f45.google.com with SMTP id b15so3893522eek.4
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:12 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>, Arik Nemtsov <arik@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 35/62] iwlwifi: add D0i3 references boiler plate
Date: Mon,  3 Feb 2014 22:57:41 +0200
Message-Id: <1391461088-8082-35-git-send-email-egrumbach@gmail.com> (sfid-20140203_223008_755521_6AE15733)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

D0i3 is bus power saving feature. It involves the
firmware - the driver needs to send a list of commands
to the firmware before entering this state. Wake up from
d0i3 also requires a few commands to the firmware.

The trigger to enter D0i3 is an idle timeout that will be
implemented later and will most probably rely on RUNTIME_PM
infrastructure.

In order to prevent entrance to D0i3 in critical flows, we
implement here a reference infrastructure. When a ref is
taken, we can't enter D0i3.

PCIe does't support D0i3.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-config.h |    2 ++
 drivers/net/wireless/iwlwifi/iwl-trans.h  |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 456fcca..2ce89d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -227,6 +227,7 @@ struct iwl_pwr_tx_backoff {
  * @high_temp: Is this NIC is designated to be in high temperature.
  * @host_interrupt_operation_mode: device needs host interrupt operation
  *	mode set
+ * @d0i3: device uses d0i3 instead of d3
  * @nvm_hw_section_num: the ID of the HW NVM section
  * @pwr_tx_backoffs: translation table between power limits and backoffs
  *
@@ -259,6 +260,7 @@ struct iwl_cfg {
 	const bool internal_wimax_coex;
 	const bool host_interrupt_operation_mode;
 	bool high_temp;
+	bool d0i3;
 	u8   nvm_hw_section_num;
 	const struct iwl_pwr_tx_backoff *pwr_tx_backoffs;
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index a350abe..1b2ac31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -443,6 +443,11 @@ struct iwl_trans;
  * @release_nic_access: let the NIC go to sleep. The "flags" parameter
  *	must be the same one that was sent before to the grab_nic_access.
  * @set_bits_mask - set SRAM register according to value and mask.
+ * @ref: grab a reference to the transport/FW layers, disallowing
+ *	certain low power states
+ * @unref: release a reference previously taken with @ref. Note that
+ *	initially the reference count is 1, making an initial @unref
+ *	necessary to allow low power states.
  */
 struct iwl_trans_ops {
 
@@ -489,6 +494,8 @@ struct iwl_trans_ops {
 				   unsigned long *flags);
 	void (*set_bits_mask)(struct iwl_trans *trans, u32 reg, u32 mask,
 			      u32 value);
+	void (*ref)(struct iwl_trans *trans);
+	void (*unref)(struct iwl_trans *trans);
 };
 
 /**
@@ -630,6 +637,18 @@ static inline int iwl_trans_d3_resume(struct iwl_trans *trans,
 	return trans->ops->d3_resume(trans, status, test);
 }
 
+static inline void iwl_trans_ref(struct iwl_trans *trans)
+{
+	if (trans->ops->ref)
+		trans->ops->ref(trans);
+}
+
+static inline void iwl_trans_unref(struct iwl_trans *trans)
+{
+	if (trans->ops->unref)
+		trans->ops->unref(trans);
+}
+
 static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
 				     struct iwl_host_cmd *cmd)
 {
-- 
1.7.9.5

