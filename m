Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:46482 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbaCDWy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 17:54:27 -0500
Received: by mail-oa0-f51.google.com with SMTP id i4so225506oah.38
        for <linux-wireless@vger.kernel.org>; Tue, 04 Mar 2014 14:54:26 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 3/9] rtlwifi: rtl8723be: rtl8723com: Remove unused allow_all_destaddr functions
Date: Tue,  4 Mar 2014 16:53:49 -0600
Message-Id: <1393973635-24799-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20140304_235434_570554_3AAA03E9)
In-Reply-To: <1393973635-24799-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1393973635-24799-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In a previous commit, Peter Wu removed this call as configure_filter takes care
of setting/clearing RCR_AAP. This patch makes the same change for rtl8723be.

In addition, a change is made in the logging level for one debug printout.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8723be/sw.c         | 1 -
 drivers/net/wireless/rtlwifi/rtl8723com/fw_common.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/sw.c b/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
index 7834ae5..cc4ab3f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
@@ -239,7 +239,6 @@ static struct rtl_hal_ops rtl8723be_hal_ops = {
 	.enable_hw_sec = rtl8723be_enable_hw_security_config,
 	.set_key = rtl8723be_set_key,
 	.init_sw_leds = rtl8723be_init_sw_leds,
-	.allow_all_destaddr = rtl8723be_allow_all_destaddr,
 	.get_bbreg = rtl8723_phy_query_bb_reg,
 	.set_bbreg = rtl8723_phy_set_bb_reg,
 	.get_rfreg = rtl8723be_phy_query_rf_reg,
diff --git a/drivers/net/wireless/rtlwifi/rtl8723com/fw_common.c b/drivers/net/wireless/rtlwifi/rtl8723com/fw_common.c
index 32c390f..c12da55 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723com/fw_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723com/fw_common.c
@@ -263,7 +263,7 @@ int rtl8723_download_fw(struct ieee80211_hw *hw,
 		 "normal Firmware SIZE %d\n", fwsize);
 
 	if (rtlpriv->cfg->ops->is_fw_header(pfwheader)) {
-		RT_TRACE(rtlpriv, COMP_FW, DBG_EMERG,
+		RT_TRACE(rtlpriv, COMP_FW, DBG_LOUD,
 			 "Firmware Version(%d), Signature(%#x), Size(%d)\n",
 			 pfwheader->version, pfwheader->signature,
 			 (int)sizeof(struct rtl92c_firmware_header));
-- 
1.8.4.5

