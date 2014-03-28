Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:63864 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511AbaC1Dgh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2014 23:36:37 -0400
Received: by mail-pa0-f48.google.com with SMTP id hz1so4390897pad.7
        for <linux-wireless@vger.kernel.org>; Thu, 27 Mar 2014 20:36:37 -0700 (PDT)
From: Adam Lee <adam.lee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v3 2/2] rtlwifi: rtl8188ee: enable MSI interrupts mode
Date: Fri, 28 Mar 2014 11:36:19 +0800
Message-Id: <1395977779-16093-2-git-send-email-adam.lee@canonical.com> (sfid-20140328_043646_886977_17DA47C9)
In-Reply-To: <1395977779-16093-1-git-send-email-adam.lee@canonical.com>
References: <1395715732-9545-1-git-send-email-adam.lee@canonical.com>
 <1395977779-16093-1-git-send-email-adam.lee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some HP notebooks using this rtl8188ee hardware module can't get
AP scan results with pin-based interrupts mode, enabling MSI interrupts
mode could fix it.

As RealTek's testing results, RTL8188EE works well with both MSI mode
and pin-based mode fallback.

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

