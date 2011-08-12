Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42690 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab1HLW4F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 18:56:05 -0400
Received: by gya6 with SMTP id 6so2284304gya.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 15:56:05 -0700 (PDT)
Message-ID: <4E45AF82.5040407@lwfinger.net> (sfid-20110813_005620_076703_F4701033)
Date: Fri, 12 Aug 2011 17:56:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Roman Krylov <volyrkr@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8192* wifi driver
References: <4E45A973.6060305@gmail.com>
In-Reply-To: <4E45A973.6060305@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2011 05:30 PM, Roman Krylov wrote:
> Hi kernel developers!
> I have a USB wifi adapter from Reltek (0bda:8176).
> I had 2.6.38 kernel and tried to install the driver provided by realtek - by
> their support I was suggested to use 8192cu. It did not compile due to
> discontinued support of explicit mutexes in newer kernels.
> I changed it using instructions I've found on the internet, compiled and it
> worked well.
> Now in the linux kernel 3.0.1 I have found rtl8192* drivers in the kernel source
> tree which I included in the install, but they did not work, though modules
> loaded without error.
> Then I took my cranked realtek driver for 2.6.38 and this time I had to remove
> the #include <linux/smp_lock.h> to compile it and it works again.
>
> The question is: can someone take care of importing this driver into the kernel
> tree and support it?
> Let the name be something like 'rtl8192cu_usb' to distinguish from others.

The driver rtl8192cu, which supports your device, has been in the kernel since 
2.6.39. It is well integrated with the other Realtek 802.11n devices and drivers 
(rtl8192ce, rtl8192se, and rtl8192de).

Driver rtl8192cu works here. What failed with your system? Did you install the 
firmware? Check the output of the dmesg command.

The driver you posted does not use mac80211, but implements its own 802.11 
stack. Such drivers are admitted to the staging directories under certain 
circumstances; however, not if they duplicate USB IDs for a mainline driver.

I unpacked your driver and tried to compile it under 3.1-rc1. It failed with

make ARCH=x86_64 CROSS_COMPILE= -C /lib/modules/3.1.0-rc1-wl+/build 
M=/home/finger/realtek/my_rtl8192CU_linux3.x  modules
make[1]: Entering directory `/home/finger/wireless-testing-new'
   CC [M]  /home/finger/realtek/my_rtl8192CU_linux3.x/core/rtw_cmd.o
In file included from 
/home/finger/realtek/my_rtl8192CU_linux3.x/include/drv_types.h:80:0,
                  from /home/finger/realtek/my_rtl8192CU_linux3.x/core/rtw_cmd.c:24:
/home/finger/realtek/my_rtl8192CU_linux3.x/include/rtw_xmit.h:343:24: error: 
field ‘xmit_tasklet’ has incomplete type
In file included from 
/home/finger/realtek/my_rtl8192CU_linux3.x/include/drv_types.h:81:0,
                  from /home/finger/realtek/my_rtl8192CU_linux3.x/core/rtw_cmd.c:24:
/home/finger/realtek/my_rtl8192CU_linux3.x/include/rtw_recv.h:217:24: error: 
field ‘recv_tasklet’ has incomplete type
make[2]: *** [/home/finger/realtek/my_rtl8192CU_linux3.x/core/rtw_cmd.o] Error 1
make[1]: *** [_module_/home/finger/realtek/my_rtl8192CU_linux3.x] Error 2

You really need to find out why rtl8192cu does not work.

Larry
