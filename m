Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from the.earth.li ([46.43.34.31]:45071 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833AbaDGGp6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2014 02:45:58 -0400
Date: Mon, 7 Apr 2014 07:45:56 +0100
From: Jonathan McDowell <noodles@earth.li>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: Re: Intel 7260 not working in 802.11n mode
Message-ID: <20140407064556.GN24850@earth.li> (sfid-20140407_084630_731452_B7C62282)
References: <20140407003648.GA19740@earth.li>
 <CANUX_P3H=F1C1H6NvdvpTHQh1JqvPjvyUjAygSQgeNyZ-q6=ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P3H=F1C1H6NvdvpTHQh1JqvPjvyUjAygSQgeNyZ-q6=ZQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 07, 2014 at 08:00:19AM +0300, Emmanuel Grumbach wrote:
> On Mon, Apr 7, 2014 at 3:36 AM, Jonathan McDowell <noodles@earth.li> wrote:
> >
> > I have an Intel 7260 that fails to associate correctly in 802.11n mode.
> > Unfortunately I don't have any access to the AP in question, but I
> > believe it is an ASUS based device. This is on the 5GHz band; there is
> > some odd configuration with the router that results in the driver
> > refusing to associate on the 2.4GHz setup with the following error:
> >
> > [  507.495986] iwlwifi 0000:02:00.0: AP 30:00:da:b1:da:d0 beacon interval is 7, refusing due to firmware bug!
> 
> Ok - this is an interesting settings.
> I'll check with our firmware team what can be done here, but beacon
> interval=7 is really insane. I can't find what the spec defines as
> legal values right now.

I wouldn't rule out the person who configured the AP having made a
mistake; the MAC address is a custom one so they may have tweaked other
settings too. However my phone (running Android) can connect to the
2.4GHz AP just fine and I think the other users of the AP are running
Macs without problems.

> > On the 5GHz band the driver attempts to associate, but never seems to
> > actually fully associate to the point of getting an IP. If I pass the
> > 11n_disable=1 parameter to the driver then things work fine.
> >
> This is surprising - can you share your logs?

The log below is without the 11n_disable flag set - if it helps I can
provide the log of when it works too.

> > I've put a debug log of the failure to associate (kernel 3.14 but this
> > has happened with all the version I've tried) up at:
> >
> > http://the.earth.li/~noodles/iwlwifi-fail.log
> >
> 
> I can't access: Access forbidden.

Sorry, fixed.

> > If there is more information I should be providing please let me know.
> > I'm sure it's related to the AP in question as I've had successful 11n
> > associations with other setups, but it's annoying to have to explicitly
> > disable 11n when in this location and then not in others.

J.

-- 
/-\                             |   Where's your fishing rod, lawn
|@/  Debian GNU/Linux Developer |              ornament?
\-                              |
