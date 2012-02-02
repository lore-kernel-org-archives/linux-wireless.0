Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44744 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158Ab2BBVnD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 16:43:03 -0500
Message-ID: <4F2B035E.6000401@hauke-m.de> (sfid-20120202_224308_220766_16764C2B)
Date: Thu, 02 Feb 2012 22:42:54 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Alfonso Fiore <alfonso.fiore@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: can't compile latest compat-wireless under kernel 3.2 even using
 git
References: <CAO=xpBFTW5b1iLnYbX7KQrjEdO0MKX86+8wooEF=DJz=+UJXZw@mail.gmail.com> <4F299D85.3080906@hauke-m.de> <CAO=xpBF29QocL3fnvophm9gO4ATKFhBCCGiPe9mka0mXAuPbfA@mail.gmail.com>
In-Reply-To: <CAO=xpBF29QocL3fnvophm9gO4ATKFhBCCGiPe9mka0mXAuPbfA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/02/2012 07:22 PM, Alfonso Fiore wrote:
> On Wed, Feb 1, 2012 at 9:16 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>>
>> What kernel are you compiling against? skb_complete_wifi_ack() is not
>> declared in linux kernel 3.2.2, just in 3.3-rc2. It looks like the
>> kernel you are compiling against has some modifications conflicting with
>> compat-wireless.
> 
> With some tricks I managed to compile compat-wireless against my
> custom kernel, but that didn't solve my problem. Apparently when I
> thought the latest compat-wireless fixed my problem I was wrong, it
> was just a random glitch.
> Or most probably I completely screwed up my drivers by juggling two kernels.
> Anyway, I booted with 3.0.0-15, recompiled (with make clean) both
> (rebooting each time) compat-wireless-3.3-rc1-2 and
> compat-wireless-2012-01-26 and I still get a very limited performance
> over wireless (max 300 KB/sec).
> 
> *** Is there a chance to activate some logging that could give you an idea
> on why my wireless is not performing? ***
Most drivers and the wireless subsystem itself have some config otpions
to activate debug output. Search in the config.mk in compat-wirless for
the debug options for your devicve and activate them by editing
config.mk and rebuilding compat-wireless

> Twice, randomly, I've seen it going as fast as wired (accessing the
> internet) so I imagine it's something than can be fixed.
> I also test both speedtest.net and wget from a local mirror, so it's
> not a fluctuating link.
Now it is interestingly to know what Wifi device you are using and what
Access point.
> 
> In case you wonder how I compiled the git version of compat-wireless
> for my custom kernel, here is how (and it works, but with the same
> sub-standard performances as compat-wireless-2012-01-26 under 3.0.0):
> 
> Ok so first I compiled linux-next:
> 
> cd linux-next/
> cp /boot/config-3.0.0-15-generic-pae .config
> yes '' | make oldconfig
> make-kpkg clean
> CONCURRENCY_LEVEL=`getconf _NPROCESSORS_ONLN` fakeroot make-kpkg
> --initrd --append-to-version=-linux-next kernel_image kernel_headers
> 
> then I went into my current kernel and changed links:
> 
> cd /lib/modules/3.2.0-interlaced2+
> sudo mv source source_true
> sudo mv build build_true
> sudo ln -s /storage/wireless/linux-next source
> sudo ln -s /storage/wireless/linux-next build
> 
> then I compiled compat-wireless
> 
> cd /storage/wireless/compat-wireless/
> make clean
> make (compilation went well)
> 
> then put back the links:
> 
> cd /lib/modules/3.2.0-interlaced2+
> sudo mv build_true build
> sudo mv source_true source
> 
> and installed compat-wireless:
> cd /storage/wireless/compat-wireless/
> sudo make install
That looks bad.
The easiest and safest ways would be to remove the skb_complete_wifi_ack
backport from include/linux/compat-3.3.h in compat-wireless.

Hauke
