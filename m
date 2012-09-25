Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37571 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757953Ab2IYSAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 14:00:55 -0400
Received: by weyt9 with SMTP id t9so1068313wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2012 11:00:53 -0700 (PDT)
MIME-Version: 1.0
Reply-To: kerolasa@gmail.com
In-Reply-To: <5061B0B5.3040103@lwfinger.net>
References: <CAG27Bk3tuw+P34btGic9pKwof3xsDw=dBpm-VEgv-RxN-BgVaQ@mail.gmail.com>
	<5061B0B5.3040103@lwfinger.net>
Date: Tue, 25 Sep 2012 19:00:53 +0100
Message-ID: <CAG27Bk21XrQ_E=VFmDZUPYFkg7o5TN=B8B5W3==s4=mGguFxYg@mail.gmail.com> (sfid-20120925_200059_120912_EA853A83)
Subject: Re: rtl8192ce, system freeze and bios reset
From: Sami Kerola <kerolasa@iki.fi>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 25, 2012 at 2:25 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:

Hi Larry et.al.,

> As I do not have a Toshiba laptop, I have no idea what the
> change in BIOS setting might have done.

All I know it happen every time, so if someone has any idea how
to debug what is going on proposals are welcome.

> I doubt that adding the rtl8192cfwU_B.bin firmware to your
> system made any difference.  The device that needs that
> firmware is a B-cut RTL8188CE, and the code to drive it has
> been submitted to wireless-testing, but not yet merged.  I
> expect that it will be in kernel 3.7.  Kernel 3.6-rc7 from
> mainline contains code that detects the B-cut device and logs a
> warning, but there are no other changes.
>
> The output of the dmesg command will say what firmware has been
> loaded.

Well, I had no idea about any firmware update before I compiled
Linus git

commit e5e77cf9f9a275083f9a365a20d956fa8a67803e

and after boot the driver was more broken.  With rmmod & modprobe
I realized rtl8192cfwU_B.bin was expected, so I added it to
/usr/lib/firmware/ manually from

http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=blob_plain;f=rtlwifi/rtl8192cfwU_B.bin;hb=HEAD

That made dmesg telling insmod is happy...

kerolasa@kerolasa-home ~ dmesg | grep rtl
[    7.901371] rtl8192ce: ****** This B_CUT device may not work with
kernels 3.6 and earlier
[    7.901383] rtl8192ce: Using firmware rtlwifi/rtl8192cfwU_B.bin
[    8.104591] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[    8.105394] rtlwifi: wireless switch is on

...and quite frankly so am I, even tough this is strange way to
fix peculiar problem.

-- 
   Sami Kerola
   http://www.iki.fi/kerolasa/
