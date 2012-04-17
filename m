Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:38229 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755911Ab2DQPwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 11:52:21 -0400
Received: by lbbgf7 with SMTP id gf7so10257528lbb.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2012 08:52:18 -0700 (PDT)
Message-ID: <1334677936.4965.13.camel@cumari> (sfid-20120417_175237_946788_9561FDBD)
Subject: Re: [PATCH -next] wireless: TI wlxxx depends on MAC80211
From: Luciano Coelho <coelho@ti.com>
To: Randy Dunlap <rdunlap@xenotime.net>, johannes@sipsolutions.net
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Date: Tue, 17 Apr 2012 18:52:16 +0300
In-Reply-To: <4F8DB687.2090701@xenotime.net>
References: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au>
		 <4F8C784B.2040402@xenotime.net> <1334640620.27247.7.camel@cumari>
	 <4F8DB687.2090701@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-17 at 11:29 -0700, Randy Dunlap wrote: 
> On 04/16/2012 10:30 PM, Luciano Coelho wrote:
> 
> > Hi Randy,
> > 
> > On Mon, 2012-04-16 at 12:51 -0700, Randy Dunlap wrote: 
> >> From: Randy Dunlap <rdunlap@xenotime.net>
> >>
> >> wl12xx build fails with many undefined symbol errors when MAC80211
> >> and CFG80211 are not enabled, so make WLCORE and WL12XX depend
> >> on MAC80211 (which already depends on CFG80211).
> >>
> >> Here are a few of the many build errors:
> >>
> > 
> > [...]
> > 
> >> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> >> Cc:	Luciano Coelho <coelho@ti.com>
> >> Cc:	linux-wireless@vger.kernel.org
> >> Cc:	"John W. Linville" <linville@tuxdriver.com>
> >> ---
> > 
> > Thanks for the patch!
> > 
> > 
> >> --- linux-next-20120416.orig/drivers/net/wireless/ti/wl12xx/Kconfig
> >> +++ linux-next-20120416/drivers/net/wireless/ti/wl12xx/Kconfig
> >> @@ -1,5 +1,6 @@
> >>  config WL12XX
> >>         tristate "TI wl12xx support"
> >> +	depends on MAC80211
> >>         select WLCORE
> > 
> > Do we really need this one? wl12xx selects WLCORE which in turn depends
> > on MAC80211 (with your change below).  Maybe we don't need this?
> 
> Hi,
> 
> [testing...]
> 
> The build fails if either one of these "depends" is omitted.

Yeah, thanks for testing.  I guess it's because, as Johannes said,
select doesn't check the dependencies of the selected module.

Johannes, thanks for the explanation.


-- 
Cheers,
Luca.

