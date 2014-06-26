Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from test.hauke-m.de ([5.39.93.123]:45054 "EHLO test.hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbaFZUry (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2014 16:47:54 -0400
Message-ID: <53AC8517.5040806@hauke-m.de> (sfid-20140626_224757_476652_77A7D92F)
Date: Thu, 26 Jun 2014 22:39:51 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: drwho@infidigm.net, backports@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211 menu option missing in backports using kernel with imx_v6_v7_defconfig
References: <335443813713531dd3a660617ee65022.squirrel@www.infidigm.net>
In-Reply-To: <335443813713531dd3a660617ee65022.squirrel@www.infidigm.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/26/2014 09:23 PM, drwho@infidigm.net wrote:
> mac80211 menu option is missing in backports using a kernel with
> imx_v6_v7_defconfig but is fine with x86 kernel config.  This causes all
> the wifi drivers that depend on mac80211 to be hidden.
> 
> I built the kernel with the default imx config...
> export
> PATH=/home/xxx/gcc-linaro-arm-linux-gnueabi-2012.04-20120426_linux/bin/:$PATH
> export
> CROSS_COMPILE=/home/xxx/gcc-linaro-arm-linux-gnueabi-2012.04-20120426_linux/bin/arm-linux-gnueabi-
> export ARCH=arm
> make imx_v6_v7_defconfig
> make uImage LOADADDR=0x70008000
> 
> when I run the backports menuconfig mac80211 is hidden....
> make menuconfig
> CROSS_COMPILE=/home/xxx/gcc-linaro-arm-linux-gnueabi-2012.04-20120426_linux/bin/arm-linux-gnueabi-
> ARCH=arm KLIB_BUILD=/home/xxx/imx_linux-3.10/ KLIB=~/home/xxx/rootfs/
> 
> Searching for mac80211 in backport's menuconfig shows its dependences are met
> Symbol: MAC80211 [=n]
> Type  : tristate
> Prompt: Generic IEEE 802.11 Networking Stack (mac80211)
>    Defined at net/mac80211/Kconfig:1
>    Depends on: m && <choice> && CFG80211 [=m] && CRYPTO [=y] &&
> CRYPTO_ARC4 && CRYPTO_AES [=y] && CRYPTO_CCM && CRC32 [=y]
>    Selects: BACKPORT_AVERAGE [=n]
> 
> If I point backports to an x86 kernel mac80211 magically appears
> make menuconfig KLIB_BUILD=/home/xxx/x86_linux-3.10/ KLIB=/home/xxx/rootfs/
> 
> Something in the imx_v6_v7_defconfig making backports unhappy?  backports
> broken? Am I missing something for the cross compile?
> 
> using backports-3.13.2-1
> 
> Jon

Have you set CONFIG_CRYPTO_CCM in your kernel config? This is needed for
mac80211 in backports.

Hauke
