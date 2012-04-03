Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11037 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab2DCUbo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 16:31:44 -0400
Date: Tue, 03 Apr 2012 15:31:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192de: Fix firmware initialization
Message-ID: <4f7b5e2d.2pmIOniVAutvkDS4%Larry.Finger@lwfinger.net> (sfid-20120403_223147_520716_BACAEF74)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before the switch to asynchronous firmware loading (mainline commit b0302ab),
it was necessary to load firmware when initializing the first of the units
in a dual-mac system. After the change, it is necessary to load firmware in
both units.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 3.4 material.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
@@ -91,7 +91,6 @@ static int rtl92d_init_sw_vars(struct ie
 	u8 tid;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	static int header_print;
 
 	rtlpriv->dm.dm_initialgain_enable = true;
 	rtlpriv->dm.dm_flag = 0;
@@ -171,10 +170,6 @@ static int rtl92d_init_sw_vars(struct ie
 	for (tid = 0; tid < 8; tid++)
 		skb_queue_head_init(&rtlpriv->mac80211.skb_waitq[tid]);
 
-	/* Only load firmware for first MAC */
-	if (header_print)
-		return 0;
-
 	/* for firmware buf */
 	rtlpriv->rtlhal.pfirmware = vzalloc(0x8000);
 	if (!rtlpriv->rtlhal.pfirmware) {
@@ -186,7 +181,6 @@ static int rtl92d_init_sw_vars(struct ie
 	rtlpriv->max_fw_size = 0x8000;
 	pr_info("Driver for Realtek RTL8192DE WLAN interface\n");
 	pr_info("Loading firmware file %s\n", rtlpriv->cfg->fw_name);
-	header_print++;
 
 	/* request fw */
 	err = request_firmware_nowait(THIS_MODULE, 1, rtlpriv->cfg->fw_name,

