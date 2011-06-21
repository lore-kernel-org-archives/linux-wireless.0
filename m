Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40761 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839Ab1FUPsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 11:48:33 -0400
Date: Tue, 21 Jun 2011 10:48:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8192cu: Fix missing firmware load
Message-ID: <4e00bd4f.CSs3sJzQ9ObURhJv%Larry.Finger@lwfinger.net> (sfid-20110621_174841_257930_51C6DF67)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 3ac5e26a1e935469a8bdae1d624bc3b59d1fcdc5 entitled
"rtlwifi: rtl8192c-common: Change common firmware routines for addition
of rtl8192se and rtl8192de", the firmware loading code was moved.
Unfortunately, some necessary code was dropped for rtl8192cu.

The dmesg output shows the following:

rtl8192c: Loading firmware file rtlwifi/rtl8192cufw.bin
rtl8192c_common:_rtl92c_fw_free_to_go():<0-0> Polling FW ready fail!! REG_MCUFWDL:0x00000006 .
rtl8192c_common:rtl92c_download_fw():<0-0> Firmware is not ready to run!

In addition, the interface will authenticate and associate, but cannot
transfer data.

This is reported as Kernel Bug #38012.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This fix should be applied to 3.0. It is a mystery how this bug got through
testing. I guess I need a checklist.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -53,6 +53,8 @@ MODULE_FIRMWARE("rtlwifi/rtl8192cufw.bin
 static int rtl92cu_init_sw_vars(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	const struct firmware *firmware;
+	int err;
 
 	rtlpriv->dm.dm_initialgain_enable = 1;
 	rtlpriv->dm.dm_flag = 0;
@@ -64,6 +66,24 @@ static int rtl92cu_init_sw_vars(struct i
 			 ("Can't alloc buffer for fw.\n"));
 		return 1;
 	}
+	/* request fw */
+	err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
+			rtlpriv->io.dev);
+	if (err) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 ("Failed to request firmware!\n"));
+		return 1;
+	}
+	if (firmware->size > 0x4000) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 ("Firmware is too big!\n"));
+		release_firmware(firmware);
+		return 1;
+	}
+	memcpy(rtlpriv->rtlhal.pfirmware, firmware->data, firmware->size);
+	rtlpriv->rtlhal.fwsize = firmware->size;
+	release_firmware(firmware);
+
 	return 0;
 }
 
