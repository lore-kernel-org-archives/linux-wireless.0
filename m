Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33320 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbbHUFty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2015 01:49:54 -0400
Received: by oio137 with SMTP id 137so36306051oio.0
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2015 22:49:53 -0700 (PDT)
Subject: Re: 8712U driver for CentOS 6.6
To: Lee Maou Sheng <maousheng.lee@archerlogic.com>,
	linux-wireless@vger.kernel.org
References: <002c01d0dbc3$0fc94a20$2f5bde60$@archerlogic.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <55D6BBF9.5050603@lwfinger.net> (sfid-20150821_075015_264927_48F84D18)
Date: Fri, 21 Aug 2015 00:49:45 -0500
MIME-Version: 1.0
In-Reply-To: <002c01d0dbc3$0fc94a20$2f5bde60$@archerlogic.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/20/2015 10:40 PM, Lee Maou Sheng wrote:
> Hi sir,
>
> I am from Singapore and currently our company is trying to install Prolink
> WN2001 wireless adapter into Dell PowerEdge T20 with Centos 6.6 installed. I
> am using https://github.com/chunkeey/rtl8192su for the driver.
>
> The information I have as below:
>
> uname -a
> Linux ts41 2.6.32-573.3.1.el6.x86_64 #1 SMP Thu Aug 13 22:55:16 UTC 2015
> x86_64 x86_64 x86_64 GNU/Linux
>
> lsusb
> Bus 001 Device 003: ID 07b8:8179 AboCom Systems Inc
>
> make
> [root@ts41 rtl8192su]# make
> make -C /lib/modules/2.6.32-573.3.1.el6.x86_64/build
> M=/var/tmp/rtl8192su/rtlwifi CONFIG_RTL_CARDS=y CONFIG_RTLWIFI=m
> CONFIG_RTLWIFI_DEBUG=y CONFIG_RTLWIFI_DEBUGFS=y CONFIG_RTLWIFI_USB=m
> CONFIG_RTLWIFI_PCI=m CONFIG_RTL8192SU=m CONFIG_RTL8192SE=m
> CONFIG_RTL8192S_COMMON=m CONFIG_RTL8192CU=n CONFIG_RTL8192DE=n
> CONFIG_RTL8192CE=n CONFIG_RTL8192C_COMMON=n CONFIG_RTL8723AE=n
> CONFIG_RTL8188EE=n  EXTRA_CFLAGS="-DDEBUG -DCONFIG_RTLWIFI_DEBUGFS=m"
> make[1]: Entering directory `/usr/src/kernels/2.6.32-573.3.1.el6.x86_64'
>    CC [M]  /var/tmp/rtl8192su/rtlwifi/usb.o
> /var/tmp/rtl8192su/rtlwifi/usb.c: In function '_rtl_prep_rx_urb':
> /var/tmp/rtl8192su/rtlwifi/usb.c:437: error: implicit declaration of
> function 'usb_alloc_coherent'
> /var/tmp/rtl8192su/rtlwifi/usb.c:438: warning: assignment makes pointer from
> integer without a cast
> /var/tmp/rtl8192su/rtlwifi/usb.c: In function '_rtl_usb_cleanup_rx':
> /var/tmp/rtl8192su/rtlwifi/usb.c:688: error: implicit declaration of
> function 'usb_free_coherent'
> make[2]: *** [/var/tmp/rtl8192su/rtlwifi/usb.o] Error 1
> make[1]: *** [_module_/var/tmp/rtl8192su/rtlwifi] Error 2
> make[1]: Leaving directory `/usr/src/kernels/2.6.32-573.3.1.el6.x86_64'
> make: *** [all] Error 2

That device is not an RTL8192SU. It is an RTL8188EU, which has a driver at 
http://github.com/lwfinger/rtl8188eu.git; however, that version probably will 
not build on a kernel as old as 2.6.32. I try to allow a build for kernels as 
old as 3.0, but yours is quite a bit older.

Is there any reason that you cannot upgrade to a newer kernel? The driver you 
need was added to the kernel in 3.19.

Larry

