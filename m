Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:53525 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752946Ab2BYFjD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 00:39:03 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: handle auto authentication mode correctly
Date: Fri, 24 Feb 2012 21:36:05 -0800
Message-Id: <1330148165-28949-2-git-send-email-bzhao@marvell.com> (sfid-20120225_063908_422062_68D96DF1)
In-Reply-To: <1330148165-28949-1-git-send-email-bzhao@marvell.com>
References: <1330148165-28949-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

When authentication type is configured to NL80211_AUTHTYPE_AUTOMATIC,
driver tries to connect using open mode. The association is failed
if AP is configured in shared mode.

This patch adds code to try association using shared mode as well if
open mode association fails.

Now since we returned exact error code in association response handler
(instead of -1), corresponding changes are done in
mwifiex_process_cmdresp().

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
This patch depends on
[PATCH 3.3] mwifiex: reset encryption mode flag before association

 drivers/net/wireless/mwifiex/cfg80211.c  |   10 ++++++----
 drivers/net/wireless/mwifiex/cmdevt.c    |    8 +++-----
 drivers/net/wireless/mwifiex/join.c      |    2 +-
 drivers/net/wireless/mwifiex/main.h      |    1 +
 drivers/net/wireless/mwifiex/sta_ioctl.c |   11 +++++++++++
 5 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 6f4389a..56f2826 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -871,6 +871,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	priv->sec_info.wpa2_enabled = false;
 	priv->wep_key_curr_index = 0;
 	priv->sec_info.encryption_mode = 0;
+	priv->sec_info.is_authtype_auto = 0;
 	ret = mwifiex_set_encode(priv, NULL, 0, 0, 1);
 
 	if (mode == NL80211_IFTYPE_ADHOC) {
@@ -892,11 +893,12 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	}
 
 	/* Now handle infra mode. "sme" is valid for infra mode only */
-	if (sme->auth_type == NL80211_AUTHTYPE_AUTOMATIC
-			|| sme->auth_type == NL80211_AUTHTYPE_OPEN_SYSTEM)
+	if (sme->auth_type == NL80211_AUTHTYPE_AUTOMATIC) {
 		auth_type = NL80211_AUTHTYPE_OPEN_SYSTEM;
-	else if (sme->auth_type == NL80211_AUTHTYPE_SHARED_KEY)
-		auth_type = NL80211_AUTHTYPE_SHARED_KEY;
+		priv->sec_info.is_authtype_auto = 1;
+	} else {
+		auth_type = sme->auth_type;
+	}
 
 	if (sme->crypto.n_ciphers_pairwise) {
 		priv->sec_info.encryption_mode =
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 6623db6..c82eb7f 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -771,7 +771,7 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 
 	/* Check init command response */
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING) {
-		if (ret == -1) {
+		if (ret) {
 			dev_err(adapter->dev, "%s: cmd %#x failed during "
 				"initialization\n", __func__, cmdresp_no);
 			mwifiex_init_fw_complete(adapter);
@@ -781,10 +781,8 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	}
 
 	if (adapter->curr_cmd) {
-		if (adapter->curr_cmd->wait_q_enabled && (!ret))
-			adapter->cmd_wait_q.status = 0;
-		else if (adapter->curr_cmd->wait_q_enabled && (ret == -1))
-			adapter->cmd_wait_q.status = -1;
+		if (adapter->curr_cmd->wait_q_enabled)
+			adapter->cmd_wait_q.status = ret;
 
 		/* Clean up and put current command back to cmd_free_q */
 		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index ee439fc..5c95e48 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -585,7 +585,7 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 		       le16_to_cpu(assoc_rsp->cap_info_bitmap),
 		       le16_to_cpu(assoc_rsp->a_id));
 
-		ret = -1;
+		ret = le16_to_cpu(assoc_rsp->status_code);
 		goto done;
 	}
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 4c86217..dddb556 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -219,6 +219,7 @@ struct mwifiex_802_11_security {
 	u8 wapi_key_on;
 	u8 wep_enabled;
 	u32 authentication_mode;
+	u8 is_authtype_auto;
 	u32 encryption_mode;
 };
 
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 866026e..e10161f 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -249,6 +249,17 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 		 * application retrieval */
 		priv->assoc_rsp_size = 0;
 		ret = mwifiex_associate(priv, bss_desc);
+
+		/* If auth type is auto and association fails using open mode,
+		 * try to connect using shared mode */
+		if (ret == WLAN_STATUS_NOT_SUPPORTED_AUTH_ALG &&
+		    priv->sec_info.is_authtype_auto &&
+		    priv->sec_info.wep_enabled) {
+			priv->sec_info.authentication_mode =
+						NL80211_AUTHTYPE_SHARED_KEY;
+			ret = mwifiex_associate(priv, bss_desc);
+		}
+
 		if (bss)
 			cfg80211_put_bss(bss);
 	} else {
-- 
1.7.0.2

