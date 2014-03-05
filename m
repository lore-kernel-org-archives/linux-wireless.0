Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:62787 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276AbaCEX0T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 18:26:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 2/3] rtlwifi: rtl8723be: Fix sparse errors
Date: Wed,  5 Mar 2014 17:26:00 -0600
Message-Id: <1394061961-11682-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20140306_002643_620018_7B4A9D77)
In-Reply-To: <1394061961-11682-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1394061961-11682-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sparse reports the following:

drivers/net/wireless/rtlwifi/rtl8723be/sw.c:374:14: sparse: duplicate const

drivers/net/wireless/rtlwifi/rtl8723be/hw.c:2214:30: sparse: cast to restricted __le32

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8723be/hw.c | 3 +--
 drivers/net/wireless/rtlwifi/rtl8723be/sw.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
index fc2af71..7e70c71 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
@@ -2210,8 +2210,7 @@ static void rtl8723be_update_hal_rate_mask(struct ieee80211_hw *hw,
 
 	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG,
 		 "ratr_bitmap :%x\n", ratr_bitmap);
-	*(u32 *)&rate_mask = EF4BYTE((ratr_bitmap & 0x0fffffff) |
-				     (ratr_index << 28));
+	*(u32 *)&rate_mask = (ratr_bitmap & 0x0fffffff) | (ratr_index << 28);
 	rate_mask[0] = macid;
 	rate_mask[1] = _rtl8723be_mrate_idx_to_arfr_id(hw, ratr_index) |
 						       (shortgi ? 0x80 : 0x00);
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/sw.c b/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
index cc4ab3f..b4577eb 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
@@ -370,7 +370,7 @@ MODULE_PARM_DESC(ips, "using no link power save (default 1 is open)\n");
 MODULE_PARM_DESC(fwlps, "using linked fw control power save (default 1 is open)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
 
-static const SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
+static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
 
 static struct pci_driver rtl8723be_driver = {
 	.name = KBUILD_MODNAME,
-- 
1.8.4.5

