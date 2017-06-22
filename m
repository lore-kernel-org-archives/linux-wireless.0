Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36279 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753068AbdFVNXd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 09:23:33 -0400
Received: by mail-pf0-f195.google.com with SMTP id y7so2928667pfd.3
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jun 2017 06:23:33 -0700 (PDT)
Date: Thu, 22 Jun 2017 18:53:29 +0530
From: Souptick Joarder <jrdr.linux@gmail.com>
To: julian.calaby@gmail.com, Larry.Finger@lwfinger.net,
        chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2] rtlwifi: Remove unnecessary conditions
Message-ID: <20170622132329.GA4825@symbol-HP-ZBook-15> (sfid-20170622_152337_978800_0282F6A2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As wmm_enable is initialized to false, hence the else condition never
execute and boundary is assigned with TX_PAGE_BOUNDARY. So the if-else
condition can be removed and boundary will be assigned with
TX_PAGE_BOUNDARY.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
Changes in v2:
  - Correcting the indent and moving up the change where
    boundary is defined.

 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index f95a645..107c34e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -835,7 +835,7 @@ static int _rtl92cu_init_mac(struct ieee80211_hw *hw)
 	struct rtl_usb_priv *usb_priv = rtl_usbpriv(hw);
 	struct rtl_usb *rtlusb = rtl_usbdev(usb_priv);
 	int err = 0;
-	u32	boundary = 0;
+	u32	boundary = TX_PAGE_BOUNDARY;
 	u8 wmm_enable = false; /* TODO */
 	u8 out_ep_nums = rtlusb->out_ep_nums;
 	u8 queue_sel = rtlusb->out_queue_sel;
@@ -845,13 +845,6 @@ static int _rtl92cu_init_mac(struct ieee80211_hw *hw)
 		pr_err("Failed to init power on!\n");
 		return err;
 	}
-	if (!wmm_enable) {
-		boundary = TX_PAGE_BOUNDARY;
-	} else { /* for WMM */
-		boundary = (IS_NORMAL_CHIP(rtlhal->version))
-					? WMM_CHIP_B_TX_PAGE_BOUNDARY
-					: WMM_CHIP_A_TX_PAGE_BOUNDARY;
-	}
 	if (false == rtl92c_init_llt_table(hw, boundary)) {
 		pr_err("Failed to init LLT Table!\n");
 		return -EINVAL;
--
1.9.1
