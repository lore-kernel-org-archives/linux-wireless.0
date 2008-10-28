Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar.linta.de ([213.133.102.198]:41123 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750764AbYJ1Xio (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 19:38:44 -0400
Date: Wed, 29 Oct 2008 00:38:41 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 2.6.28-rc regression: Can't stop Rx DMA
Message-ID: <20081028233841.GA12554@isilmar.linta.de> (sfid-20081029_003848_791037_E9F8188E)
References: <20081018231046.GA10977@isilmar.linta.de> <1ba2fa240810181630t781468dbi23b103e656f64153@mail.gmail.com> <20081019075916.GA12904@isilmar.linta.de> <1225145468.1115.139.camel@rc-desk> <20081027230326.GA23250@isilmar.linta.de> <1225154823.1115.149.camel@rc-desk> <20081028194323.GA14303@isilmar.linta.de> <1225225434.1115.217.camel@rc-desk> <1225235731.1369.8.camel@johannes.berg> <1225236760.1115.245.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1225236760.1115.245.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Oct 28, 2008 at 04:32:40PM -0700, reinette chatre wrote:
> On Tue, 2008-10-28 at 16:15 -0700, Johannes Berg wrote:
> > On Tue, 2008-10-28 at 13:23 -0700, reinette chatre wrote:
> > 
> > > (adding linux-wireless so I am keeping the log below)
> > > 
> > > This helps a lot - thanks!
> > > 
> > > Could you please recompile wireless with CONFIG_WIRELESS_OLD_REGULATORY?
> > 
> > Btw, any idea why this helps? Shouldn't the driver just work, albeit
> > with a restricted channel set? Are we messing something up like no
> > usable channels at all? (I fixed a bug like that IIRC)
> > 
> 
> Without the regulatory information the number of 5G channels to scan is
> zero.

But what about the 2.4G channels? This is the one I'd like to use here, and
this is the one which is used with the correct firmware...

wlan0	  IEEE 802.11abg  ESSID:"<not reported on this list>"
	  Mode:Managed  Frequency:2.417 GHz
	  Bit Rate=54 Mb/s   Tx-Power=15 dBm   
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B   
          Power Management:off
          Link Quality=96/100  Signal level:-31 dBm  Noise level=-127 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

	
Will test with CONFIG_WIRELESS_OLD_REGULATORY soon. Best,

	Dominik
