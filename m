Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61372 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab1LJXWN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 18:22:13 -0500
Received: by ggdk6 with SMTP id k6so42748ggd.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2011 15:22:13 -0800 (PST)
Message-ID: <4EE3E9A1.8000004@lwfinger.net> (sfid-20111211_002220_957050_6A269432)
Date: Sat, 10 Dec 2011 17:22:09 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Roland Gruber <post@rolandgruber.de>
CC: linux-wireless@vger.kernel.org, 651622@bugs.debian.org,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#651622: linux-2.6: Sitecom WLA-2000 v1.001 WLAN stick not
 supported
References: <20111210162607.1020.50335.reportbug@roland>		 <1323537258.18450.100.camel@deadeye> <4EE39C40.4030802@rolandgruber.de>	 <1323543622.25752.4.camel@deadeye> <4EE3D447.7030108@rolandgruber.de> <1323554710.25752.18.camel@deadeye> <4EE3DF19.6080106@rolandgruber.de>
In-Reply-To: <4EE3DF19.6080106@rolandgruber.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2011 04:37 PM, Roland Gruber wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hi,
>
> I have some problem to get a Sitecom USB WLAN stick to run.
> Ben tried to help me but we did not get it to work. So he pointed me to you. :)
>
> It is the Sitecom WLA-2000 v1.001.
>
> Vendor 0df6
> Product 005d
> Chipset Realtek RTL8191S
>
> Dec 10 18:45:10 roland kernel: [18513.016012] usb 2-3: new high speed USB device number 9 using ehci_hcd
> Dec 10 18:45:10 roland kernel: [18513.151122] usb 2-3: New USB device found, idVendor=0df6, idProduct=005d
> Dec 10 18:45:10 roland kernel: [18513.151126] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> Dec 10 18:45:10 roland kernel: [18513.151129] usb 2-3: Product: RTL8191S WLAN Adapter
> Dec 10 18:45:10 roland kernel: [18513.151130] usb 2-3: Manufacturer: Manufacturer Realtek
> Dec 10 18:45:10 roland kernel: [18513.151132] usb 2-3: SerialNumber: 00e04c000001
>
> We tried to use the kernel module rtl8192cu by adding the IDs with "echo 0df6 005d>  /sys/bus/usb/drivers/rtl8192cu/new_id".
> But this led to a kernel oops.
>
> Is there any way to setup the rtl8192cu kernel module so that it accepts the WLAN stick?
> We also tried the module r8192u_usb but it complains about firmware loading problems when connecting the stick.

If rtl8192cu generates an oops when you use the new_id, then it is the wrong 
driver for your device.

The driver for the RTL8188SU is r8712u. Try

modprobe -rv r8712u
echo 0df6 005d >  /sys/bus/usb/drivers/r8712u/new_id

If that works, I can add that device ID to the driver.

Larry


