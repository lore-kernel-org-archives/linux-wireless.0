Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38949 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab3FQREM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 13:04:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Uocqd-0004ko-6r
	for linux-wireless@vger.kernel.org; Mon, 17 Jun 2013 19:04:07 +0200
Received: from ip-109-84-0-66.web.vodafone.de ([109.84.0.66])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 19:04:07 +0200
Received: from zielscheibe by ip-109-84-0-66.web.vodafone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 19:04:07 +0200
To: linux-wireless@vger.kernel.org
From: Tobias Kluge <zielscheibe@gmail.com>
Subject: Re: rtl8192cu fail to connect with a AP
Date: Mon, 17 Jun 2013 17:03:50 +0000 (UTC)
Message-ID: <loom.20130617T185506-165@post.gmane.org> (sfid-20130617_190415_769870_0C88B53A)
References: <loom.20130617T154136-827@post.gmane.org> <51BF2996.9060102@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@...> writes:

> 
> On 06/17/2013 09:06 AM, Tobias Kluge wrote:
> > Hi,
> >
> > I've recently bought a TP-Link TL-WN8200ND USB WiFi dongle, it uses the
> > Realtek 8192cu chipset.
> > After several attempts with different kernels (starting with 3.2.6) and
> > compat-wireless drivers, I'm still running into the same problem. The device
> > can successful scan for networks in reach, but cannot connect to any of
> > them, regardless the encryption (tried every mode, including no encryption
> > at all).
> >
> > At the moment I'm using the kernel release 3.10.0-rc6 and the device is
> > still not recognized by the "rtl8192cu" driver module without manually
> > setting the device ID into the SySFS
> >
> > "echo "2357 0100" > /sys/bus/usb/drivers/rtl8192cu/new_id"
> 
> No one had reported that this device used rtl8192cu, thus it is not in the 
> device tables, nor is it in the USB database as shown by the bare entry in
your 
> lsusb output. Attached is a patch that will add your device to the tables.
That 
> will be submitted to the maintainer relatively soon.
> 
> There were a number of changes to that driver that just appeared in 3.10-rc6. 
> These fixed a number of bug reports on the Red Hat bugzilla as shown in the 
> commit message for commit 5b8df24. I had built 3.10-rc6 from the mainline git 
> tree; however, I had not booted it till now. With it, my Edimax EW-7811Un 
> adapter with an RTL8188CUS chip could connect to WEP, WPA1 and WPA2 APs; 
> however, when I dug out my Alfa AWUS036NHR with an RTL8188RU chip, it
could not 
> connect to any of my APs. I now need to check the results for the 
> wireless-testing git tree, which I normally use, to see if there is a
difference 
> in the two trees.
> 
> Larry
> 
> 
> 
> Index: wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> ===================================================================
> --- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> +++ wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
>  <at>  <at>  -359,6 +359,7  <at>  <at>  static struct usb_device_id
rtl8192c_usb
>  	{RTL_USB_DEVICE(0x2001, 0x330a, rtl92cu_hal_cfg)}, /*D-Link-Alpha*/
>  	{RTL_USB_DEVICE(0x2019, 0xab2b, rtl92cu_hal_cfg)}, /*Planex -Abocom*/
>  	{RTL_USB_DEVICE(0x20f4, 0x624d, rtl92cu_hal_cfg)}, /*TRENDNet*/
> +	{RTL_USB_DEVICE(0x2357, 0x0100, rtl92cu_hal_cfg)}, /*TP-Link WN8200ND*/
>  	{RTL_USB_DEVICE(0x7392, 0x7822, rtl92cu_hal_cfg)}, /*Edimax -Edimax*/
>  	{}
>  };
> 
> 

Thank you for your effort Larry,

compiled the latest stable kernel (3.9.6) with your fixed device table, the
dongle is now recognized properly, when the module (rtl8192cu) is loaded.
The connection issue to any AP still remains, with the same dmesg output. I
don't believe that the changes you mentioned in 3.10.0-rc6 are the trouble
makers with this device. I tried many different kernels before (3.26, 3.8.0
binaries from the Ubuntu sources, 3.9.6, 3.10.0-rc6 build from scratch). I
hope you can see some possibilities to fix this problem.

Thank you in advance
Tobias


