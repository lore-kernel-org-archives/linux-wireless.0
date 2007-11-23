Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.191]:4216 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755914AbXKWPgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 10:36:31 -0500
Received: by rn-out-0102.google.com with SMTP id s46so4290697rnb
        for <linux-wireless@vger.kernel.org>; Fri, 23 Nov 2007 07:36:30 -0800 (PST)
Message-ID: <6995ca080711230736n54330d30s96831a664d46df1c@mail.gmail.com> (sfid-20071123_153635_036678_CB6CB695)
Date: Fri, 23 Nov 2007 10:36:28 -0500
From: "Vadim Peretokin" <vperetokin@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: Belin FD7010 v7
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1195784707.11966.38.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <6995ca080711221239t2947765ds765fd933fce5de31@mail.gmail.com>
	 <1195781993.11966.27.camel@dv>
	 <6995ca080711221804w7310134aw8a5902e45aa09942@mail.gmail.com>
	 <1195784707.11966.38.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That didn't quite work. iwconfig and ifconfig couldn't see the card,
but lswh -C network showed my card. It said "* - network UNCLAIMED",
but it didn't say any logical adresses. I tried a host of adresses
with "sudo ifconfig <adress> up", but nothing would work.

I had a friend help me do some hacks involving telling the driver the
adress of my card, and then iwconfig saw it - but for some reason Wicd
couldn't see it (I'll try again when I get back home and install
Network Manager again.). I have a log of what we did to get it
"working", if it's any help.

And yes, the card does work if you install the net8185.inf driver in
ndiswrapper and then use the -a command to link the card to the
driver. I was just hoping that the card would work out of the box :)

On Nov 22, 2007 9:25 PM, Pavel Roskin <proski@gnu.org> wrote:
>
> On Thu, 2007-11-22 at 21:04 -0500, Vadim Peretokin wrote:
> > Ahh I'm afraid no, I'm not quite there yet and need my laptop
> > functional. But I'll let you know then when the next version of Ubuntu
> > comes about, thank you!
>
> Actually, there is a compatibility package with the latest wireless
> drivers:
> http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2
>
> It's much easier to compile.  No configuration is required.  Just run
> "make" and then "make install" (as root).  Then use "modprobe rtl8180"
> to load the driver.  Ubuntu will probably load it automatically after
> reboot.  Linux 2.6.22 and newer is supported.  No kernel patching is
> needed.  Just make sure to recompile the package when upgrading to the
> next kernel.
>
> Even if that doesn't work, it's possible to use ndiswrapper with the
> Windows driver, so that you don't have to choose your OS because of
> issues with just one driver.
>
> --
> Regards,
> Pavel Roskin
>
>
