Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:59527 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349AbaFZVS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2014 17:18:26 -0400
Message-ID: <4ac8f03450ae2022eef8615c04ce6221.squirrel@www.infidigm.net> (sfid-20140626_231829_144915_6D634A03)
In-Reply-To: <53AC8517.5040806@hauke-m.de>
References: <335443813713531dd3a660617ee65022.squirrel@www.infidigm.net>
    <53AC8517.5040806@hauke-m.de>
Date: Thu, 26 Jun 2014 16:57:22 -0400
Subject: Re: mac80211 menu option missing in backports using kernel with
 imx_v6_v7_defconfig
From: drwho@infidigm.net
To: "Hauke Mehrtens" <hauke@hauke-m.de>
Cc: backports@vger.kernel.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> when I run the backports menuconfig mac80211 is hidden....
>> make menuconfig
>> CROSS_COMPILE=/home/xxx/gcc-linaro-arm-linux-gnueabi-2012.04-20120426_linux/bin/arm-linux-gnueabi-
>> ARCH=arm KLIB_BUILD=/home/xxx/imx_linux-3.10/ KLIB=~/home/xxx/rootfs/
>>
>> Searching for mac80211 in backport's menuconfig shows its dependences
>> are met
>> Symbol: MAC80211 [=n]
>> Type  : tristate
>> Prompt: Generic IEEE 802.11 Networking Stack (mac80211)
>>    Defined at net/mac80211/Kconfig:1
>>    Depends on: m && <choice> && CFG80211 [=m] && CRYPTO [=y] &&
>> CRYPTO_ARC4 && CRYPTO_AES [=y] && CRYPTO_CCM && CRC32 [=y]
>>    Selects: BACKPORT_AVERAGE [=n]
>>
>> If I point backports to an x86 kernel mac80211 magically appears
>> make menuconfig KLIB_BUILD=/home/xxx/x86_linux-3.10/
>> KLIB=/home/xxx/rootfs/
>>
>> Something in the imx_v6_v7_defconfig making backports unhappy?
>> backports
>> broken? Am I missing something for the cross compile?
>>
>> using backports-3.13.2-1
>>
>> Jon
>
> Have you set CONFIG_CRYPTO_CCM in your kernel config? This is needed for
> mac80211 in backports.
>
> Hauke

Enabling crypto_ccm and crypto_arc4 in the kernel fixed it. Thanks.  I
guess I was looking for [=n] and didn't even see they were disabled.

Jon


