Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53273 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab2ECQHX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 12:07:23 -0400
Received: by yhmm54 with SMTP id m54so1901705yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 09:07:22 -0700 (PDT)
Message-ID: <4FA2AD36.3010005@lwfinger.net> (sfid-20120503_180731_970214_79BCD961)
Date: Thu, 03 May 2012 11:07:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/9] rtlwifi: fix the selection of the bulk in endpoint
References: <4FA212D9.5020602@gtri.gatech.edu> <4FA21392.5060401@gtri.gatech.edu>
In-Reply-To: <4FA21392.5060401@gtri.gatech.edu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/03/2012 12:11 AM, Joshua Roys wrote:

I am still reviewing the patches; however, the build fails after this patch with

   CC [M]  drivers/net/wireless/rtlwifi/rtl8192cu/trx.o
drivers/net/wireless/rtlwifi/rtl8192cu/trx.c: In function 
‘rtl8192cu_endpoint_mapping’:
drivers/net/wireless/rtlwifi/rtl8192cu/trx.c:206:27: error: ‘usb_priv’ 
undeclared (first use in this function)
drivers/net/wireless/rtlwifi/rtl8192cu/trx.c:206:27: note: each undeclared 
identifier is reported only once for each function it appears in
make[2]: *** [drivers/net/wireless/rtlwifi/rtl8192cu/trx.o] Error 1
make[1]: *** [drivers/net/wireless/rtlwifi/rtl8192cu] Error 2
make: *** [drivers/net/wireless/rtlwifi/] Error 2

You are missing a

struct rtl_usb_priv *usb_priv = rtl_usbpriv(hw);

ahead of line 206.

I also had some compilation problems with patch 9. The problem there was that 
you are basing your changes on the wrong tree. All changes to wireless drivers 
should be from the wireless-testing git tree at

git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git

and not from the mainline tree.

Larry
