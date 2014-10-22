Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:56219 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaJVNsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 09:48:10 -0400
Received: by mail-lb0-f169.google.com with SMTP id 10so2893937lbg.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 06:48:08 -0700 (PDT)
From: Karsten Wiese <fzuuzf@googlemail.com>
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org,
	Karsten Wiese <fzuuzf@googlemail.com>
Subject: [PATCH 1/3] rtl8192cu: Fix for rtlwifi's bluetooth coexist functionality
Date: Wed, 22 Oct 2014 15:47:32 +0200
Message-Id: <1413985654-25070-2-git-send-email-fzuuzf@googlemail.com> (sfid-20141022_154813_736731_7483A5EE)
In-Reply-To: <1413985654-25070-1-git-send-email-fzuuzf@googlemail.com>
References: <1413985654-25070-1-git-send-email-fzuuzf@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize function pointer with a function indicating bt coexist is not there.
Prevents Ooops.

Signed-off-by: Karsten Wiese <fzuuzf@googlemail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index 7c5fbaf..e06bafe 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -101,6 +101,12 @@ static void rtl92cu_deinit_sw_vars(struct ieee80211_hw *hw)
 	}
 }
 
+/* get bt coexist status */
+static bool rtl92cu_get_btc_status(void)
+{
+	return false;
+}
+
 static struct rtl_hal_ops rtl8192cu_hal_ops = {
 	.init_sw_vars = rtl92cu_init_sw_vars,
 	.deinit_sw_vars = rtl92cu_deinit_sw_vars,
@@ -148,6 +154,7 @@ static struct rtl_hal_ops rtl8192cu_hal_ops = {
 	.phy_set_bw_mode_callback = rtl92cu_phy_set_bw_mode_callback,
 	.dm_dynamic_txpower = rtl92cu_dm_dynamic_txpower,
 	.fill_h2c_cmd = rtl92c_fill_h2c_cmd,
+	.get_btc_status = rtl92cu_get_btc_status,
 };
 
 static struct rtl_mod_params rtl92cu_mod_params = {
-- 
1.9.1

