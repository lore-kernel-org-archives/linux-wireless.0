Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63611 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755621Ab2ECSzF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 14:55:05 -0400
Received: by ghrr11 with SMTP id r11so2094789ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 11:55:04 -0700 (PDT)
Message-ID: <4FA2D484.4090103@lwfinger.net> (sfid-20120503_205513_796587_0EEF3CC2)
Date: Thu, 03 May 2012 13:55:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/9] rtlwifi: avoid race registering with mac80211
References: <4FA212D9.5020602@gtri.gatech.edu> <4FA21339.8060407@gtri.gatech.edu> <4FA2BC00.9020804@lwfinger.net> <4FA2BE8D.6090604@gtri.gatech.edu>
In-Reply-To: <4FA2BE8D.6090604@gtri.gatech.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/03/2012 12:21 PM, Joshua Roys wrote:
>
> Do you think I should have moved the
> set_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
> lines also? Or is the idea of the patch just wrong?

I am still thinking about the problem, but a few things are clear. There can be 
no ieee80211 callbacks until the firmware has been loaded from the file. On 
bootup when user-space code is not running, there will be a delay, which is the 
reason we switched to asynchronous fw loading. Thus, the call to 
ieee80211_register_hw() must not be done until the firmware is available.

If your analysis that the calling of rtl_init_core() is out of order, then the 
following should fix it:


Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
@@ -1853,14 +1853,6 @@ int __devinit rtl_pci_probe(struct pci_d
   	/*like read eeprom and so on */
   	rtlpriv->cfg->ops->read_eeprom_info(hw);

-	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Can't init_sw_vars\n");
-		err = -ENODEV;
-		goto fail3;
-	}
-
-	rtlpriv->cfg->ops->init_sw_leds(hw);
-
   	/*aspm */
   	rtl_pci_init_aspm(hw);

@@ -1879,6 +1871,14 @@ int __devinit rtl_pci_probe(struct pci_d
   		goto fail3;
   	}

+	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Can't init_sw_vars\n");
+		err = -ENODEV;
+		goto fail3;
+	}
+
+	rtlpriv->cfg->ops->init_sw_leds(hw);
+
   	err = sysfs_create_group(&pdev->dev.kobj, &rtl_attribute_group);
   	if (err) {
   		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,

This one works on my system, and is being tested against the Bugzilla entry I 
noted earlier.

Larry


