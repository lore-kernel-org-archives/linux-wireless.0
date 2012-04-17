Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12241 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2DQXT0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 19:19:26 -0400
Date: Tue, 17 Apr 2012 18:19:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: ilw@linux.intel.com, wey-yi.w.guy@intel.com,
	johannes.berg@intel.com, linux-wireless@vger.kernel.org
Subject: [PATCH] iwlwifi: Fix compile when CONFIG_IWLWIFI_DEBUG is not
 defined
Message-ID: <4f8dfa7b.3JI0H3iulrLPUzPs%Larry.Finger@lwfinger.net> (sfid-20120418_011958_143805_CDD81257)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If CONFIG_IWLWIFI_DEBUG is not defined, the following error results when
compiling iwlwifi:

  CC [M]  drivers/net/wireless/iwlwifi/iwl-agn-tt.o
In file included from drivers/net/wireless/iwlwifi/iwl-agn-tt.c:40:0:
drivers/net/wireless/iwlwifi/iwl-core.h:97:19: error: static declaration of ‘iwl_alloc_traffic_mem’ follows non-static declaration
drivers/net/wireless/iwlwifi/iwl-agn.h:513:5: note: previous declaration of ‘iwl_alloc_traffic_mem’ was here
make[4]: *** [drivers/net/wireless/iwlwifi/iwl-agn-tt.o] Error 1
make[3]: *** [drivers/net/wireless/iwlwifi] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/drivers/net/wireless/iwlwifi/iwl-agn.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ wireless-testing-new/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -425,6 +425,7 @@ void iwl_testmode_cleanup(struct iwl_pri
 #ifdef CONFIG_IWLWIFI_DEBUG
 void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 			     enum iwl_rxon_context_id ctxid);
+int iwl_alloc_traffic_mem(struct iwl_priv *priv);
 #else
 static inline void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 					   enum iwl_rxon_context_id ctxid)
@@ -510,7 +511,6 @@ void iwl_setup_deferred_work(struct iwl_
 int iwl_send_wimax_coex(struct iwl_priv *priv);
 int iwl_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
 void iwl_debug_config(struct iwl_priv *priv);
-int iwl_alloc_traffic_mem(struct iwl_priv *priv);
 void iwl_set_hw_params(struct iwl_priv *priv);
 void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags);
 int iwl_init_drv(struct iwl_priv *priv);
