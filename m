Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37761 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752519AbdHICbv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 22:31:51 -0400
Received: by mail-pg0-f66.google.com with SMTP id 83so4635428pgb.4
        for <linux-wireless@vger.kernel.org>; Tue, 08 Aug 2017 19:31:51 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH] mwifiex: uap: enable 11d based on userspace configruation
Date: Wed,  9 Aug 2017 02:31:43 +0000
Message-Id: <1502245903-22246-1-git-send-email-huxinming820@gmail.com> (sfid-20170809_043155_239938_CBA0BBB1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch check whether userspace beacon data include country
ie, if so then download command to enable 11d setup in firmeare
accordingly.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c |  2 ++
 drivers/net/wireless/marvell/mwifiex/main.h     |  3 +++
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c  | 34 ++++++++++++++++---------
 3 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index c4382d0..2aa5adc 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2018,6 +2018,8 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 		priv->state_11h.is_11h_active = false;
 	}
 
+	mwifiex_config_uap_11d(priv, &params->beacon);
+
 	if (mwifiex_config_start_uap(priv, bss_cfg)) {
 		mwifiex_dbg(priv->adapter, ERROR,
 			    "Failed to start AP\n");
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 84be38e..ee8876a 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1565,6 +1565,9 @@ int mwifiex_config_start_uap(struct mwifiex_private *priv,
 void mwifiex_uap_del_sta_data(struct mwifiex_private *priv,
 			      struct mwifiex_sta_node *node);
 
+void mwifiex_config_uap_11d(struct mwifiex_private *priv,
+			    struct cfg80211_beacon_data *beacon_data);
+
 void mwifiex_init_11h_params(struct mwifiex_private *priv);
 int mwifiex_is_11h_active(struct mwifiex_private *priv);
 int mwifiex_11h_activate(struct mwifiex_private *priv, bool flag);
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
index 477c29c..18f7d9b 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
@@ -444,6 +444,28 @@ void mwifiex_set_sys_config_invalid_data(struct mwifiex_uap_bss_param *config)
 	return;
 }
 
+/* This function enable 11D if userspace set the country IE.
+ */
+void mwifiex_config_uap_11d(struct mwifiex_private *priv,
+			    struct cfg80211_beacon_data *beacon_data)
+{
+	enum state_11d_t state_11d;
+	const u8 *country_ie;
+
+	country_ie = cfg80211_find_ie(WLAN_EID_COUNTRY, beacon_data->tail,
+				      beacon_data->tail_len);
+	if (country_ie) {
+		/* Send cmd to FW to enable 11D function */
+		state_11d = ENABLE_11D;
+		if (mwifiex_send_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
+				     HostCmd_ACT_GEN_SET, DOT11D_I,
+				     &state_11d, true)) {
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "11D: failed to enable 11D\n");
+		}
+	}
+}
+
 /* This function parses BSS related parameters from structure
  * and prepares TLVs. These TLVs are appended to command buffer.
 */
@@ -848,8 +870,6 @@ void mwifiex_uap_set_channel(struct mwifiex_private *priv,
 int mwifiex_config_start_uap(struct mwifiex_private *priv,
 			     struct mwifiex_uap_bss_param *bss_cfg)
 {
-	enum state_11d_t state_11d;
-
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_SYS_CONFIG,
 			     HostCmd_ACT_GEN_SET,
 			     UAP_BSS_PARAMS_I, bss_cfg, true)) {
@@ -858,16 +878,6 @@ int mwifiex_config_start_uap(struct mwifiex_private *priv,
 		return -1;
 	}
 
-	/* Send cmd to FW to enable 11D function */
-	state_11d = ENABLE_11D;
-	if (mwifiex_send_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
-			     HostCmd_ACT_GEN_SET, DOT11D_I,
-			     &state_11d, true)) {
-		mwifiex_dbg(priv->adapter, ERROR,
-			    "11D: failed to enable 11D\n");
-		return -1;
-	}
-
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_START,
 			     HostCmd_ACT_GEN_SET, 0, NULL, true)) {
 		mwifiex_dbg(priv->adapter, ERROR,
-- 
1.9.1
