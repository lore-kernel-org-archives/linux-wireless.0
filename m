Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34395 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbaCXGBG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 02:01:06 -0400
Received: by mail-pa0-f47.google.com with SMTP id lj1so4968575pab.34
        for <linux-wireless@vger.kernel.org>; Sun, 23 Mar 2014 23:01:06 -0700 (PDT)
From: Adam Lee <adam.lee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
	stable@kernel.org, "John W. Linville" <linville@tuxdriver.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: [PATCH] rtlwifi: rtl8188ee: enable MSI interrupts support
Date: Mon, 24 Mar 2014 14:00:41 +0800
Message-Id: <1395640841-14477-1-git-send-email-adam.lee@canonical.com> (sfid-20140324_070117_047163_F2F90774)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some HP notebooks using this rtl8188ee hardware module can't get
AP scan results with pin-based interrupts, enabling MSI interrupts could
fix it.

Signed-off-by: Adam Lee <adam.lee@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8188ee/sw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
index 347af1e..1b4101b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
@@ -93,6 +93,7 @@ int rtl88e_init_sw_vars(struct ieee80211_hw *hw)
 	u8 tid;
 
 	rtl8188ee_bt_reg_init(hw);
+	rtlpci->msi_support = true;
 
 	rtlpriv->dm.dm_initialgain_enable = 1;
 	rtlpriv->dm.dm_flag = 0;
-- 
1.9.1

