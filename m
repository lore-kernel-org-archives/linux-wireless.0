Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60254 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbYJ2KDE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 06:03:04 -0400
Subject: Re: 2.6.28-rc regression: Can't stop Rx DMA
From: Dan Williams <dcbw@redhat.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: reinette chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081029002713.GA16554@isilmar.linta.de>
References: <1ba2fa240810181630t781468dbi23b103e656f64153@mail.gmail.com>
	 <20081019075916.GA12904@isilmar.linta.de>
	 <1225145468.1115.139.camel@rc-desk>
	 <20081027230326.GA23250@isilmar.linta.de>
	 <1225154823.1115.149.camel@rc-desk>
	 <20081028194323.GA14303@isilmar.linta.de>
	 <1225225434.1115.217.camel@rc-desk> <1225235731.1369.8.camel@johannes.berg>
	 <1225236760.1115.245.camel@rc-desk>
	 <20081028233841.GA12554@isilmar.linta.de>
	 <20081029002713.GA16554@isilmar.linta.de>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 06:01:09 -0400
Message-Id: <1225274469.28968.3.camel@localhost.localdomain> (sfid-20081029_110310_345097_2CF71962)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-10-29 at 01:27 +0100, Dominik Brodowski wrote:
> Hi,
> 
> On Wed, Oct 29, 2008 at 12:38:41AM +0100, Dominik Brodowski wrote:
> > On Tue, Oct 28, 2008 at 04:32:40PM -0700, reinette chatre wrote:
> > > On Tue, 2008-10-28 at 16:15 -0700, Johannes Berg wrote:
> > > > On Tue, 2008-10-28 at 13:23 -0700, reinette chatre wrote:
> > > > 
> > > > > (adding linux-wireless so I am keeping the log below)
> > > > > 
> > > > > This helps a lot - thanks!
> > > > > 
> > > > > Could you please recompile wireless with CONFIG_WIRELESS_OLD_REGULATORY?
> > > > 
> > > > Btw, any idea why this helps? Shouldn't the driver just work, albeit
> > > > with a restricted channel set? Are we messing something up like no
> > > > usable channels at all? (I fixed a bug like that IIRC)
> > > > 
> > > 
> > > Without the regulatory information the number of 5G channels to scan is
> > > zero.
> > 
> > But what about the 2.4G channels? This is the one I'd like to use here, and
> > this is the one which is used with the correct firmware...
> > 
> > wlan0	  IEEE 802.11abg  ESSID:"<not reported on this list>"
> > 	  Mode:Managed  Frequency:2.417 GHz
> > 	  Bit Rate=54 Mb/s   Tx-Power=15 dBm   
> >           Retry min limit:7   RTS thr:off   Fragment thr=2352 B   
> >           Power Management:off
> >           Link Quality=96/100  Signal level:-31 dBm  Noise level=-127 dBm
> >           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
> >           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> > 
> > 	
> > Will test with CONFIG_WIRELESS_OLD_REGULATORY soon.
> 
> With CONFIG_WIRELESS_OLD_REGULATORY=y, both the old and the new firmware
> works. Without, only the old firmware works.
> 
> I'd think that at least the error message could be clarified a bit
> (is it really a "Microcode SW error"?)... also, it might be a corner case

Yes, because Intel's firmware (intentionally) crashes when given
commands or input that contravenes the firmware's idea of the regulatory
region.  Thus, you have to go to enormous lengths to keep the driver and
the firmware worldview in sync.  Yes, it's pretty fragile design, but
apparently driven by their interpretation of legal requirements.

Dan


