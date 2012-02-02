Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39318 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab2BBSXO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 13:23:14 -0500
Received: by pbdu11 with SMTP id u11so2221332pbd.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 10:23:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F299D85.3080906@hauke-m.de>
References: <CAO=xpBFTW5b1iLnYbX7KQrjEdO0MKX86+8wooEF=DJz=+UJXZw@mail.gmail.com>
 <4F299D85.3080906@hauke-m.de>
From: Alfonso Fiore <alfonso.fiore@gmail.com>
Date: Thu, 2 Feb 2012 19:22:43 +0100
Message-ID: <CAO=xpBF29QocL3fnvophm9gO4ATKFhBCCGiPe9mka0mXAuPbfA@mail.gmail.com> (sfid-20120202_192317_927073_4CD35F3E)
Subject: Re: can't compile latest compat-wireless under kernel 3.2 even using git
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 1, 2012 at 9:16 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>
> What kernel are you compiling against? skb_complete_wifi_ack() is not
> declared in linux kernel 3.2.2, just in 3.3-rc2. It looks like the
> kernel you are compiling against has some modifications conflicting with
> compat-wireless.

With some tricks I managed to compile compat-wireless against my
custom kernel, but that didn't solve my problem. Apparently when I
thought the latest compat-wireless fixed my problem I was wrong, it
was just a random glitch.
Or most probably I completely screwed up my drivers by juggling two kernels.
Anyway, I booted with 3.0.0-15, recompiled (with make clean) both
(rebooting each time) compat-wireless-3.3-rc1-2 and
compat-wireless-2012-01-26 and I still get a very limited performance
over wireless (max 300 KB/sec).

*** Is there a chance to activate some logging that could give you an idea
on why my wireless is not performing? ***

Twice, randomly, I've seen it going as fast as wired (accessing the
internet) so I imagine it's something than can be fixed.
I also test both speedtest.net and wget from a local mirror, so it's
not a fluctuating link.

In case you wonder how I compiled the git version of compat-wireless
for my custom kernel, here is how (and it works, but with the same
sub-standard performances as compat-wireless-2012-01-26 under 3.0.0):

Ok so first I compiled linux-next:

cd linux-next/
cp /boot/config-3.0.0-15-generic-pae .config
yes '' | make oldconfig
make-kpkg clean
CONCURRENCY_LEVEL=`getconf _NPROCESSORS_ONLN` fakeroot make-kpkg
--initrd --append-to-version=-linux-next kernel_image kernel_headers

then I went into my current kernel and changed links:

cd /lib/modules/3.2.0-interlaced2+
sudo mv source source_true
sudo mv build build_true
sudo ln -s /storage/wireless/linux-next source
sudo ln -s /storage/wireless/linux-next build

then I compiled compat-wireless

cd /storage/wireless/compat-wireless/
make clean
make (compilation went well)

then put back the links:

cd /lib/modules/3.2.0-interlaced2+
sudo mv build_true build
sudo mv source_true source

and installed compat-wireless:
cd /storage/wireless/compat-wireless/
sudo make install

thanks for any idea,
alfonso
