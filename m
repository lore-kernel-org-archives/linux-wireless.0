Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:50400 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbbAXLz7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 06:55:59 -0500
Received: by mail-pd0-f170.google.com with SMTP id p10so2933944pdj.1
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2015 03:55:59 -0800 (PST)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net, ap420073@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192cu: Set fw_ready flag
Date: Sat, 24 Jan 2015 20:55:40 +0900
Message-Id: <1422100540-6338-1-git-send-email-ap420073@gmail.com> (sfid-20150124_125602_898657_1655CBA6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After rtl8192cu download firmware routine, set fw_ready flag.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 5513217..2468850 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1000,6 +1000,7 @@ int rtl92cu_hw_init(struct ieee80211_hw *hw)
 	local_save_flags(flags);
 	local_irq_enable();
 
+	rtlhal->fw_ready = false;
 	rtlhal->hw_type = HARDWARE_TYPE_RTL8192CU;
 	err = _rtl92cu_init_mac(hw);
 	if (err) {
@@ -1013,6 +1014,8 @@ int rtl92cu_hw_init(struct ieee80211_hw *hw)
 		err = 1;
 		goto exit;
 	}
+
+	rtlhal->fw_ready = true;
 	rtlhal->last_hmeboxnum = 0; /* h2c */
 	_rtl92cu_phy_param_tab_init(hw);
 	rtl92cu_phy_mac_config(hw);
-- 
1.9.1

