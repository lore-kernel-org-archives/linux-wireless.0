Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56802.mail.re3.yahoo.com ([66.196.97.76]:24681 "HELO
	web56802.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753768Ab0DWIqp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 04:46:45 -0400
Message-ID: <260332.71011.qm@web56802.mail.re3.yahoo.com>
Date: Fri, 23 Apr 2010 01:46:44 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [rt2x00] rt3070 fails to initialize with rt2800usb
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
In-Reply-To: <4BD0B6BD.50509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > The problem as I recall first occurred in late January
> or some time in February when  someone decided to
> remove large portion of the VIDs from the code because of
> driver collisions and I suppose the purpose of it was to
> reshuffle VID tables and insert some sort of order. Since
> then, compat-wireless does not automatically provide drivers
> for the rt307x via rt2800usb. To this point, only manual
> modification and inserting of the VIDs above solves the
> problem.
> > 
> > I'm a 100% certain of this. Even if your cards have
> different VIDs /not 148f:3070/, just install compat-wireless
> with enabled rt307X support and see if "modinfo rt2800usb
> |grep 3070" returns something. Then you'll be able to verify
> my reports.
> > 
> 
> As I mentioned, I am not experiencing this. See attached
> the modinfo output for the modules that I built with a clean
> compat-wireless package.
> 
> The only way I can explain this is that on your system, for
> some reason, changes to config.mk are not picked up by the
> build system.
> 
> Can you try removing the include/linux/compat_autoconf.h
> file (from the root of the compat-wireless tree), and then
> run a make clean, followed by a make.
> 
> ---
> Gertjan.

Unfortunately, removing this file changes nothing. The rt2800usb still doesn't pick up the 148f:3070 VID as modinfo would show. That is with enabled rt307x support in config.mk and removed compat_autoconf.h in the compat directory. I'm on a Ubuntu 9.10 / 2.6.31-20 kernel. The problem appears to be deeper that I thought.

I don't mind manually modifying VID table to enable support for my devices, but this would mean a large number of users won't be able to take advantage of the new code via compat-wireless. I'm puzzled how results differ, you appear to be testing it on Fedora system with .2.6.32 and Ubuntu 2.6.31 fails. I'm running out of explanations.

Walter.


      
