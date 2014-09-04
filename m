Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:39387 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbaIDVEL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 17:04:11 -0400
Received: by mail-ob0-f182.google.com with SMTP id va2so8067126obc.27
        for <linux-wireless@vger.kernel.org>; Thu, 04 Sep 2014 14:04:10 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	troy_tan@realsil.com.cn
Subject: [PATCH 2/7 V3.18] rtlwifi: btcoexist: Modify rtl_btc for changes in latest Realtek code
Date: Thu,  4 Sep 2014 16:03:41 -0500
Message-Id: <1409864626-16373-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20140904_230415_404103_76D5FBFC)
In-Reply-To: <1409864626-16373-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1409864626-16373-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: troy_tan@realsil.com.cn
---
 drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.c | 21 +++++++++++++++++----
 drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.h |  2 ++
 drivers/net/wireless/rtlwifi/wifi.h              |  3 +++
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.c
index 0ab94fe..826b1a6 100644
--- a/drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.c
+++ b/drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.c
@@ -22,19 +22,19 @@
  * Larry Finger <Larry.Finger@lwfinger.net>
  *
  *****************************************************************************/
-
 #include "../wifi.h"
-#include "rtl_btc.h"
-#include "halbt_precomp.h"
-
 #include <linux/vmalloc.h>
 #include <linux/module.h>
 
+#include "rtl_btc.h"
+#include "halbt_precomp.h"
+
 static struct rtl_btc_ops rtl_btc_operation = {
 	.btc_init_variables = rtl_btc_init_variables,
 	.btc_init_hal_vars = rtl_btc_init_hal_vars,
 	.btc_init_hw_config = rtl_btc_init_hw_config,
 	.btc_ips_notify = rtl_btc_ips_notify,
+	.btc_lps_notify = rtl_btc_lps_notify,
 	.btc_scan_notify = rtl_btc_scan_notify,
 	.btc_connect_notify = rtl_btc_connect_notify,
 	.btc_mediastatus_notify = rtl_btc_mediastatus_notify,
@@ -44,6 +44,7 @@ static struct rtl_btc_ops rtl_btc_operation = {
 	.btc_is_limited_dig = rtl_btc_is_limited_dig,
 	.btc_is_disable_edca_turbo = rtl_btc_is_disable_edca_turbo,
 	.btc_is_bt_disabled = rtl_btc_is_bt_disabled,
+	.btc_special_packet_notify = rtl_btc_special_packet_notify,
 };
 
 void rtl_btc_init_variables(struct rtl_priv *rtlpriv)
@@ -85,6 +86,11 @@ void rtl_btc_ips_notify(struct rtl_priv *rtlpriv, u8 type)
 	exhalbtc_ips_notify(&gl_bt_coexist, type);
 }
 
+void rtl_btc_lps_notify(struct rtl_priv *rtlpriv, u8 type)
+{
+	exhalbtc_lps_notify(&gl_bt_coexist, type);
+}
+
 void rtl_btc_scan_notify(struct rtl_priv *rtlpriv, u8 scantype)
 {
 	exhalbtc_scan_notify(&gl_bt_coexist, scantype);
@@ -103,6 +109,7 @@ void rtl_btc_mediastatus_notify(struct rtl_priv *rtlpriv,
 
 void rtl_btc_periodical(struct rtl_priv *rtlpriv)
 {
+	/*rtl_bt_dm_monitor();*/
 	exhalbtc_periodical(&gl_bt_coexist);
 }
 
@@ -150,12 +157,18 @@ bool rtl_btc_is_disable_edca_turbo(struct rtl_priv *rtlpriv)
 
 bool rtl_btc_is_bt_disabled(struct rtl_priv *rtlpriv)
 {
+	/* It seems 'bt_disabled' is never be initialized or set. */
 	if (gl_bt_coexist.bt_info.bt_disabled)
 		return true;
 	else
 		return false;
 }
 
+void rtl_btc_special_packet_notify(struct rtl_priv *rtlpriv, u8 pkt_type)
+{
+	return exhalbtc_special_packet_notify(&gl_bt_coexist, pkt_type);
+}
+
 struct rtl_btc_ops *rtl_btc_get_ops_pointer(void)
 {
 	return &rtl_btc_operation;
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.h b/drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.h
index 805b22c..d5218ce 100644
--- a/drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.h
+++ b/drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.h
@@ -31,6 +31,7 @@ void rtl_btc_init_variables(struct rtl_priv *rtlpriv);
 void rtl_btc_init_hal_vars(struct rtl_priv *rtlpriv);
 void rtl_btc_init_hw_config(struct rtl_priv *rtlpriv);
 void rtl_btc_ips_notify(struct rtl_priv *rtlpriv, u8 type);
+void rtl_btc_lps_notify(struct rtl_priv *rtlpriv, u8 type);
 void rtl_btc_scan_notify(struct rtl_priv *rtlpriv, u8 scantype);
 void rtl_btc_connect_notify(struct rtl_priv *rtlpriv, u8 action);
 void rtl_btc_mediastatus_notify(struct rtl_priv *rtlpriv,
@@ -41,6 +42,7 @@ void rtl_btc_btinfo_notify(struct rtl_priv *rtlpriv, u8 *tmpbuf, u8 length);
 bool rtl_btc_is_limited_dig(struct rtl_priv *rtlpriv);
 bool rtl_btc_is_disable_edca_turbo(struct rtl_priv *rtlpriv);
 bool rtl_btc_is_bt_disabled(struct rtl_priv *rtlpriv);
+void rtl_btc_special_packet_notify(struct rtl_priv *rtlpriv, u8 pkt_type);
 
 struct rtl_btc_ops *rtl_btc_get_ops_pointer(void);
 
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 407a793..e44e2df 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -2312,6 +2312,7 @@ struct rtl_btc_ops {
 	void (*btc_init_hal_vars) (struct rtl_priv *rtlpriv);
 	void (*btc_init_hw_config) (struct rtl_priv *rtlpriv);
 	void (*btc_ips_notify) (struct rtl_priv *rtlpriv, u8 type);
+	void (*btc_lps_notify)(struct rtl_priv *rtlpriv, u8 type);
 	void (*btc_scan_notify) (struct rtl_priv *rtlpriv, u8 scantype);
 	void (*btc_connect_notify) (struct rtl_priv *rtlpriv, u8 action);
 	void (*btc_mediastatus_notify) (struct rtl_priv *rtlpriv,
@@ -2323,6 +2324,8 @@ struct rtl_btc_ops {
 	bool (*btc_is_limited_dig) (struct rtl_priv *rtlpriv);
 	bool (*btc_is_disable_edca_turbo) (struct rtl_priv *rtlpriv);
 	bool (*btc_is_bt_disabled) (struct rtl_priv *rtlpriv);
+	void (*btc_special_packet_notify)(struct rtl_priv *rtlpriv,
+					  u8 pkt_type);
 };
 
 struct proxim {
-- 
1.8.4.5

