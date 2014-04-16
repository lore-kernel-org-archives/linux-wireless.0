Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from the.earth.li ([46.43.34.31]:59987 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbaDPGKs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2014 02:10:48 -0400
Date: Wed, 16 Apr 2014 07:10:43 +0100
From: Jonathan McDowell <noodles@earth.li>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Ilw] Re: Intel 7260 not working in 802.11n mode
Message-ID: <20140416061043.GZ24850@earth.li> (sfid-20140416_081052_673178_425C49B8)
References: <20140407003648.GA19740@earth.li>
 <CANUX_P3H=F1C1H6NvdvpTHQh1JqvPjvyUjAygSQgeNyZ-q6=ZQ@mail.gmail.com>
 <20140407064556.GN24850@earth.li>
 <0BA3FCBA62E2DC44AF3030971E174FB303DC6723@HASMSX103.ger.corp.intel.com>
 <20140407152312.GO24850@earth.li>
 <0BA3FCBA62E2DC44AF3030971E174FB303DCA5EC@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB303DCA5EC@HASMSX103.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 13, 2014 at 11:07:10AM +0000, Grumbach, Emmanuel wrote:
> > > Your log seems healthy - you associate at Apr  6 17:17:20 and
> > > disassociate at Apr  6 17:18:05 - was that intentional?
> > 
> > All I did was load the module with the debug parameter set, let Network
> > Manager do its thing and wait for the connection to fail, then unload the
> > module. NM is reporting that the DHCP times out - log at:
> > 
> > http://the.earth.li/~noodles/iwlfail-nm.log
> > 
> > I'd be blaming Network Manager or some other piece of configuration if it
> > wasn't for the fact that disabling 11n makes things work.
> > 
> I really can't see anything bad in this log.
> Can you run tracing?
> 
> sudo trace-cmd record -e iwlwifi -e iwlwifi_msg -e mac80211 -e cfg80211
> 
> this will create a trace.dat file which I'd like to look at.

http://the.earth.li/~noodles/iwlwifi/broken-trace.dat.xz

and for completeness, with disable_11n=1:

http://the.earth.li/~noodles/iwlwifi/working-trace.dat.xz

In both cases I started the trace, flipped the hardware wifi disable
switch, let Network Manager do its thing.

J.

-- 
I just Fedexed my soul to hell. I'm *real* clever.
