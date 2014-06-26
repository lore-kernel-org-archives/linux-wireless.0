Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:22410 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844AbaFZToq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2014 15:44:46 -0400
Message-ID: <335443813713531dd3a660617ee65022.squirrel@www.infidigm.net> (sfid-20140626_214449_244489_756502E9)
Date: Thu, 26 Jun 2014 15:23:42 -0400
Subject: mac80211 menu option missing in backports using kernel with
 imx_v6_v7_defconfig
From: drwho@infidigm.net
To: backports@vger.kernel.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 menu option is missing in backports using a kernel with
imx_v6_v7_defconfig but is fine with x86 kernel config.  This causes all
the wifi drivers that depend on mac80211 to be hidden.

I built the kernel with the default imx config...
export
PATH=/home/xxx/gcc-linaro-arm-linux-gnueabi-2012.04-20120426_linux/bin/:$PATH
export
CROSS_COMPILE=/home/xxx/gcc-linaro-arm-linux-gnueabi-2012.04-20120426_linux/bin/arm-linux-gnueabi-
export ARCH=arm
make imx_v6_v7_defconfig
make uImage LOADADDR=0x70008000

when I run the backports menuconfig mac80211 is hidden....
make menuconfig
CROSS_COMPILE=/home/xxx/gcc-linaro-arm-linux-gnueabi-2012.04-20120426_linux/bin/arm-linux-gnueabi-
ARCH=arm KLIB_BUILD=/home/xxx/imx_linux-3.10/ KLIB=~/home/xxx/rootfs/

Searching for mac80211 in backport's menuconfig shows its dependences are met
Symbol: MAC80211 [=n]
Type  : tristate
Prompt: Generic IEEE 802.11 Networking Stack (mac80211)
   Defined at net/mac80211/Kconfig:1
   Depends on: m && <choice> && CFG80211 [=m] && CRYPTO [=y] &&
CRYPTO_ARC4 && CRYPTO_AES [=y] && CRYPTO_CCM && CRC32 [=y]
   Selects: BACKPORT_AVERAGE [=n]

If I point backports to an x86 kernel mac80211 magically appears
make menuconfig KLIB_BUILD=/home/xxx/x86_linux-3.10/ KLIB=/home/xxx/rootfs/

Something in the imx_v6_v7_defconfig making backports unhappy?  backports
broken? Am I missing something for the cross compile?

using backports-3.13.2-1

Jon





