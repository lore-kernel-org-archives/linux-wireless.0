Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34501 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750890AbdBDSla (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Feb 2017 13:41:30 -0500
Subject: Re: rtlwifi: rtl8192c_common: "BUG: KASAN: slab-out-of-bounds"
To: Dmitry Osipenko <digetx@gmail.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>
References: <beff9033-0051-fd0f-87fe-8269a0d9c8d0@gmail.com>
 <f5682c5a-6c2c-8a35-61b6-1d7a30d2c1f6@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <edbcbe3f-9b5d-cead-5885-27bc55ef550b@lwfinger.net> (sfid-20170204_194158_652576_51C325FF)
Date: Sat, 4 Feb 2017 12:41:27 -0600
MIME-Version: 1.0
In-Reply-To: <f5682c5a-6c2c-8a35-61b6-1d7a30d2c1f6@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------985798A9CBD630C5624863BF"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------985798A9CBD630C5624863BF
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/04/2017 10:58 AM, Dmitry Osipenko wrote:
> Seems the problem is caused by rtl92c_dm_*() casting .priv to "struct
> rtl_pci_priv", while it is "struct rtl_usb_priv".

Those routines are shared by rtl8192ce and rtl8192cu, thus we need to make that 
difference in cast to be immaterial. I think we need to move "struct 
bt_coexist_info" to the beginning of both rtlpci_priv and rtl_usb_priv. Then it 
should not matter.

I do not have a gcc version new enough to turn KASAN testing on, thus the 
attached patch is only compile tested. Does it fix the problem?

Larry


--------------985798A9CBD630C5624863BF
Content-Type: text/x-patch;
 name="reorder_private_data.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="reorder_private_data.patch"

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.h b/drivers/net/wireless/realtek/rtlwifi/pci.h
index 578b1d9..d9039ea 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.h
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.h
@@ -271,10 +271,10 @@ struct mp_adapter {
 };
 
 struct rtl_pci_priv {
+	struct bt_coexist_info bt_coexist;
+	struct rtl_led_ctl ledctl;
 	struct rtl_pci dev;
 	struct mp_adapter ndis_adapter;
-	struct rtl_led_ctl ledctl;
-	struct bt_coexist_info bt_coexist;
 };
 
 #define rtl_pcipriv(hw)		(((struct rtl_pci_priv *)(rtl_priv(hw))->priv))
diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.h b/drivers/net/wireless/realtek/rtlwifi/usb.h
index a6d43d2..cdb9e06 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.h
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.h
@@ -146,8 +146,9 @@ struct rtl_usb {
 };
 
 struct rtl_usb_priv {
-	struct rtl_usb dev;
+	struct bt_coexist_info bt_coexist;
 	struct rtl_led_ctl ledctl;
+	struct rtl_usb dev;
 };
 
 #define rtl_usbpriv(hw)	 (((struct rtl_usb_priv *)(rtl_priv(hw))->priv))

--------------985798A9CBD630C5624863BF--
