Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:53502 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaEHIfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2014 04:35:46 -0400
Received: by mail-qa0-f54.google.com with SMTP id j15so2218080qaq.27
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2014 01:35:46 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 8 May 2014 10:35:46 +0200
Message-ID: <CAMfPB_zT33JxJ+OYpgc3nySfBX29Eg66_YwMt7EZM1onymXOLQ@mail.gmail.com> (sfid-20140508_103551_980264_1DE2A91E)
Subject: rtl8192cu regulatory domain
From: Alessandro Lannocca <alessandro.lannocca@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everyone, I'm using backports20140417 on fedora 20 running
kernel 3.14; I have an rtl8192cu-based wifi card (AWUS036NHR) I bought
from amazon italy; I usually had to 'pimp' the CH1_11 rule definition
in regd.c to be able to use channels 12-13 here in italy, however this
morning i stumbled accross this patch:

Signed-off-by John Williams <john@xxxxxxxxxxxxx>

--- linux-3.2/drivers/net/wireless/rtlwifi/regd.c.orig
+++ linux-3.2/drivers/net/wireless/rtlwifi/regd.c
@@ -405,7 +405,7 @@
  return -EINVAL;

  /* init country_code from efuse channel plan */
- rtlpriv->regd.country_code = rtlpriv->efuse.channel_plan;
+ rtlpriv->regd.country_code = rtlpriv->efuse.eeprom_channelplan;

  RT_TRACE(rtlpriv, COMP_REGD, DBG_TRACE,
  (KERN_DEBUG "rtl: EEPROM regdomain: 0x%0x\n",

--

I just dropped by to say that it works and I'm no more stuck into
channels 1-11 nor into hacky-whacky ugly workarounds; maybe this patch
could be pushed into production.


Credits: I found this patch in a ml message by Mr. John Williams dated
Mon, 5 Mar 2012 21:39:56 +0000

Thank you all for your work :)

Alessandro Lannocca
