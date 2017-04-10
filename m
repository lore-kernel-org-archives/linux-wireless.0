Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50258 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753503AbdDJL05 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 07:26:57 -0400
Message-ID: <1491823607.31980.47.camel@coelho.fi> (sfid-20170410_132705_614825_05276C9A)
From: Luca Coelho <luca@coelho.fi>
To: =?ISO-8859-1?Q?=22K=E4fer=2C?= "Marcel\"" <mk@djagoo.io>,
        linuxwifi@intel.com, linux-wireless@vger.kernel.org
Date: Mon, 10 Apr 2017 14:26:47 +0300
In-Reply-To: <1491822841.31980.45.camel@coelho.fi>
References: <212619248.282995.1491726087885.JavaMail.open-xchange@app09.ox.hosteurope.de>
         <1491822841.31980.45.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: iwlwifi crashing on X1 Carbon 5th Gen iwlwifi-8265 "Microcode
 SW error detected"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-04-10 at 14:14 +0300, Luca Coelho wrote:
> Hi,
> 
> On Sun, 2017-04-09 at 10:21 +0200, 
> > Hello,
> > 
> > on the new 5th Gen Lenovo X1 Carbon and Intel 8265 on a fresh Arch install
> > iwlwifi keeps crashing the moment network is coming up. Happens on both
> > core/linux-firmware 20170309.695f2d6-1 and aur/linux-firmware-iwlwifi-git.
> > 
> > After it's crashing it's impossible to rmmod iwlmvm and iwlwifi, all netctl and
> > ip commands are hanging, sudo isn't working and even shutdown isn't working.
> > Tried netctl and NetworkManager. Netctl sometimes work for a few minutes before
> > it crashes, NetworkManager is chrashing after a few seconds.
> > Someone reported a bug with Intel 7265D card wich looks exactly the same.
> > https://bugs.archlinux.org/task/53317
> > The firmware files for 8265 found in /lib/firmware are:
> > - iwlwifi-8265-21.ucode
> > - iwlwifi-8265-22.ucode
> > - iwlwifi-8265-27.ucode
> > 
> > The dmesg output is attached to this mail as dmesg.txt
> 
> Please refer to this bug in bugzilla:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=193641

Actually, as Johannes noticed, your case is much more serious, because
it triggers a NULL-dereference in our recovery flow.  And that's what's
causing your machine to go to a bad state.

Can you please report it in bugzilla so we can track and fix the null-
dereference?

Thanks for reporting!

--
Cheers,
Luca.
