Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56124 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2IZEZc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 00:25:32 -0400
Received: by ieak13 with SMTP id k13so443573iea.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2012 21:25:31 -0700 (PDT)
Message-ID: <506283B1.8060900@lwfinger.net> (sfid-20120926_062536_322792_21C604CF)
Date: Tue, 25 Sep 2012 23:25:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: kerolasa@gmail.com
CC: Sami Kerola <kerolasa@iki.fi>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce, system freeze and bios reset
References: <CAG27Bk3tuw+P34btGic9pKwof3xsDw=dBpm-VEgv-RxN-BgVaQ@mail.gmail.com> <5061B0B5.3040103@lwfinger.net> <CAG27Bk21XrQ_E=VFmDZUPYFkg7o5TN=B8B5W3==s4=mGguFxYg@mail.gmail.com>
In-Reply-To: <CAG27Bk21XrQ_E=VFmDZUPYFkg7o5TN=B8B5W3==s4=mGguFxYg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/25/2012 01:00 PM, Sami Kerola wrote:
>
> Well, I had no idea about any firmware update before I compiled
> Linus git
>
> commit e5e77cf9f9a275083f9a365a20d956fa8a67803e
>
> and after boot the driver was more broken.  With rmmod & modprobe
> I realized rtl8192cfwU_B.bin was expected, so I added it to
> /usr/lib/firmware/ manually from
>
> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=blob_plain;f=rtlwifi/rtl8192cfwU_B.bin;hb=HEAD
>
> That made dmesg telling insmod is happy...

My distro (openSUSE) provides regular updates of the firmware from the 
linux-firmware git repository. As you noted, the B-cut firmware for the 
RTL8188CE has been in that repo for some time.

> kerolasa@kerolasa-home ~ dmesg | grep rtl
> [    7.901371] rtl8192ce: ****** This B_CUT device may not work with
> kernels 3.6 and earlier
> [    7.901383] rtl8192ce: Using firmware rtlwifi/rtl8192cfwU_B.bin
> [    8.104591] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
> [    8.105394] rtlwifi: wireless switch is on
>
> ...and quite frankly so am I, even tough this is strange way to
> fix peculiar problem.

What is strange about it? We discovered that certain cards would not work about 
10 days ago. By comparison with the vendor driver, the fix was found; however, 
it was too invasive to be applied at this time to kernel 3.6, thus the partial 
patch was prepared. For most of the affected cards, it is not enough, which is 
why the message says "may not work". You are lucky that it does. As I said 
earlier, the real fix will be in kernel 3.7, and the above message is deleted.

Larry



