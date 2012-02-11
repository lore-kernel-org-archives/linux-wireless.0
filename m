Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63738 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2BKB0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Feb 2012 20:26:35 -0500
Received: by pbcun15 with SMTP id un15so2900956pbc.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Feb 2012 17:26:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F358902.3040009@01019freenet.de>
References: <CAO=xpBHy9p4yzhxaWTfG+jjw7f_OzbACmxxPnDL8AmLBS-JdwQ@mail.gmail.com>
 <CAO=xpBGT7ovdSOV77AV6wpUcTDFYr0t8GEab474mVmZm0-BhVA@mail.gmail.com>
 <20120207171538.3336af0c@mj> <CAO=xpBGRs_kYtt_w6aG2dFjO4Pgd9MrjPwn7YfuLe7bw3mGiPg@mail.gmail.com>
 <4F34BF3C.9030809@01019freenet.de> <CAO=xpBFKOAdTEi1DMfJxWCCv9oEtJpuLjuN4uNPNRgN1iWG85Q@mail.gmail.com>
 <4F358902.3040009@01019freenet.de>
From: Alfonso Fiore <alfonso.fiore@gmail.com>
Date: Sat, 11 Feb 2012 02:26:04 +0100
Message-ID: <CAO=xpBEvmd7=0EK68+MUQMgFVXL47tQYGc-2X8Rt0NfJdszUkw@mail.gmail.com> (sfid-20120211_022650_177069_D47BEFAF)
Subject: Re: Setting up an AP @ 5 GHz 802.11a - hostapd refuses [Could not
 select hw_mode and channel. (-1)]
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 10, 2012 at 10:15 PM, Andreas Hartmann
<andihartmann@01019freenet.de> wrote:
>
> Alfonso Fiore schrieb:
> > On Fri, Feb 10, 2012 at 7:54 AM, Andreas Hartmann
> [...]
> > # find / | grep ath5k.ko
> > /lib/modules/3.0.0-voyage/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
> > /lib/modules/3.0.0/updates/drivers/net/wireless/ath/ath5k/ath5k.ko
> > /root/compat-wireless-3.3-rc1-2/drivers/net/wireless/ath/ath5k/ath5k.ko
> > /root/compat-wireless-3.3-rc1-2/drivers/net/wireless/ath/ath5k/.ath5k.ko.cmd
> >
> > I tried depmod -a and also a simple reboot (which I always do after
> > make install) but the "updates" module is never loaded.
> >
> > Any idea?
>
> Sorry for being late. I worked on my machine and wasn't able to read any
> mails.
>
>
> I do have a config file for depmod in /etc/depmod.d called
> 00-system.conf, which has the following entries:

Hi Andreas,

I do not have a /etc/depmod.d folder. I imagine it is something about
my embedded distribution (voyage 0.8.0).

I asked for help there. I will post back is they have any suggestion.

I imagine there is a reason why this feature is not part of the distribution...

Still I'm happy to test.

# dpkg -l | grep module-init
ii  module-init-tools                  3.12-1
tools for managing Linux kernel modules

I created the folder and then /etc/depmod.d/00-system.conf same like yours.

then I run "depmod -a" but lsmod shows the ath5k module is not loaded.

If I overwrite the original .ko files I get this error:
ath5k: version magic '3.0.0 SMP preempt mod_unload 486 ' should be
'3.0.0-voyage SMP preempt mod_unload 486 '

if you have other ideas, I'm happy to try them!

thank you,
alfonso

>
> --------------------------------------------------------------------
> #
> # /etc/depmod.conf - configuration file for the depmod(8) command,
> # for its format see depmod.conf(5).
> #
> # Please don't edit this file, place your settings into the /etc/depmod.d
> # directory.
>
>
> # search order:
> # 1 updates/ (KMPs)
> # 2 extra/ (KMPs or manually compiled modules)
> # 3 weak-updates/ (KMPs built for older kernels)
> # 4 everything else
> search updates extra weak-updates built-in
>
> # do not generate modules.*map files
> make_map_files no
> ----------------------------------------------------------------------
>
> Version of my inittools is: module-init-tools-3.12-6.1.x86_64. I don't
> have a depmod.conf file.
>
> After creating / changing this file, issue depmod -a again!
>
>
>
> Hope that helps!
>
> Regards,
> Andreas
