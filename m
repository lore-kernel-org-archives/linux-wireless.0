Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16916 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbaDMLHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 07:07:18 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Jonathan McDowell <noodles@earth.li>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: [Ilw] Re: Intel 7260 not working in 802.11n mode
Date: Sun, 13 Apr 2014 11:07:10 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303DCA5EC@HASMSX103.ger.corp.intel.com> (sfid-20140413_130724_665794_B2CE7819)
References: <20140407003648.GA19740@earth.li>
 <CANUX_P3H=F1C1H6NvdvpTHQh1JqvPjvyUjAygSQgeNyZ-q6=ZQ@mail.gmail.com>
 <20140407064556.GN24850@earth.li>
 <0BA3FCBA62E2DC44AF3030971E174FB303DC6723@HASMSX103.ger.corp.intel.com>
 <20140407152312.GO24850@earth.li>
In-Reply-To: <20140407152312.GO24850@earth.li>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On Mon, Apr 07, 2014 at 07:00:49AM +0000, Grumbach, Emmanuel wrote:
> > > On Mon, Apr 07, 2014 at 08:00:19AM +0300, Emmanuel Grumbach wrote:
> > > > On Mon, Apr 7, 2014 at 3:36 AM, Jonathan McDowell
> > > > <noodles@earth.li>
> > > wrote:
> > > > >
> > > > > I have an Intel 7260 that fails to associate correctly in 802.11n mode.
> > > > > Unfortunately I don't have any access to the AP in question, but
> > > > > I believe it is an ASUS based device. This is on the 5GHz band;
> > > > > there is some odd configuration with the router that results in
> > > > > the driver refusing to associate on the 2.4GHz setup with the
> following error:
> > > > >
> > > > > [  507.495986] iwlwifi 0000:02:00.0: AP 30:00:da:b1:da:d0 beacon
> > > > > interval is
> > > 7, refusing due to firmware bug!
> > > >
> > > > Ok - this is an interesting settings.
> > > > I'll check with our firmware team what can be done here, but
> > > > beacon
> > > > interval=7 is really insane. I can't find what the spec defines as
> > > > legal values right now.
> > >
> > > I wouldn't rule out the person who configured the AP having made a
> > > mistake; the MAC address is a custom one so they may have tweaked
> > > other settings too. However my phone (running Android) can connect
> > > to the 2.4GHz AP just fine and I think the other users of the AP are
> > > running Macs without problems.
> > >
> > > > > On the 5GHz band the driver attempts to associate, but never
> > > > > seems to actually fully associate to the point of getting an IP.
> > > > > If I pass the
> > > > > 11n_disable=1 parameter to the driver then things work fine.
> > > > >
> > > > This is surprising - can you share your logs?
> > >
> > > The log below is without the 11n_disable flag set - if it helps I
> > > can provide the log of when it works too.
> > >
> > > > > I've put a debug log of the failure to associate (kernel 3.14
> > > > > but this has happened with all the version I've tried) up at:
> > > > >
> > > > > http://the.earth.li/~noodles/iwlwifi-fail.log
> > > > >
> > > >
> > > > I can't access: Access forbidden.
> > > >
> > > Sorry, fixed.
> > >
> > Your log seems healthy - you associate at Apr  6 17:17:20 and
> > disassociate at Apr  6 17:18:05 - was that intentional?
> 
> All I did was load the module with the debug parameter set, let Network
> Manager do its thing and wait for the connection to fail, then unload the
> module. NM is reporting that the DHCP times out - log at:
> 
> http://the.earth.li/~noodles/iwlfail-nm.log
> 
> I'd be blaming Network Manager or some other piece of configuration if it
> wasn't for the fact that disabling 11n makes things work.
> 
I really can't see anything bad in this log.
Can you run tracing?

sudo trace-cmd record -e iwlwifi -e iwlwifi_msg -e mac80211 -e cfg80211

this will create a trace.dat file which I'd like to look at.
Thanks.
