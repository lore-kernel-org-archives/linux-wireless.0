Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbYHGTk3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 15:40:29 -0400
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere fw
From: Dan Williams <dcbw@redhat.com>
To: Dave <kilroyd@googlemail.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net
In-Reply-To: <489B425F.5060704@gmail.com>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
	 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>
	 <1217825304.10989.20.camel@dv>
	 <1217864060.3139.10.camel@localhost.localdomain>
	 <1217970944.2908.11.camel@dv>
	 <1217973349.30531.1.camel@localhost.localdomain>
	 <1217976491.2908.36.camel@dv>
	 <1218028414.16977.5.camel@localhost.localdomain>
	 <4899FB91.8070501@gmail.com>
	 <1218056165.12240.0.camel@localhost.localdomain>
	 <489A12E2.8060909@gmail.com>
	 <1218077300.30724.10.camel@localhost.localdomain>
	 <489B425F.5060704@gmail.com>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 15:42:09 -0400
Message-Id: <1218138129.32083.14.camel@localhost.localdomain> (sfid-20080807_214033_847755_426E9D17)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-08-07 at 19:43 +0100, Dave wrote:
> Dan Williams wrote:
> > On Wed, 2008-08-06 at 22:08 +0100, Dave wrote:
> >> Dan Williams wrote:
> >>> Well, since the driver supports SSID scanning, we can use ap_scan=1
> >>> anyway.  ap_scan=2 is actually pretty evil since it depends on WEXT
> >>> ordering and whatnot.
> >>
> >> ap_scan=1 requires the use of SIOCSIWWAP (to set desired BSSID), which
> >> the Agere firmware doesn't support. The firmware only supports setting a
> >> desired SSID (via SIOCSIWESSID), so Agere based orinoco is stuck with
> >> ap_scan=2 :(
> >>
> >> Symbol and Intersil don't have this problem.
> > 
> > In practice that shouldn't be a problem because drivers (at least
> > ipw2200 does this) usually roam BSSIDs anyway.  Technically a bug I
> > think.  But honestly, the driver needs to work with ap_scan=1 and I
> > don't see why it couldn't.
> 
> I had a reread of <http://hostap.epitest.fi/wpa_supplicant/devel/driver_wrapper.html>. 
> 
> As a FullMAC driver without support for selecting the BSSID to associate with (or frequency in Managed mode), the only way I can see to make the driver work with ap_scan=1 is to silently ignore the SIOCSIWFREQ and SIOCSIWAP. I don't think this is an approach I would want to pursue.

Well, the current orinoco driver returns "success" (0) for SIOCSIWAP on
Agere firmware.  Thus, ap_scan=1 should work just fine for you because
the supplicant won't complain when setting the BSS fails, and the driver
will happily do whatever it wants to with the SSID anyway (just like
ipw2200 currently does I might add).

> That said, what's wrong with the ap_scan=2 mode? You've stated it's not great (and I'm prepared to believe it), but what is the actual problem?

The whole ap_scan thing is a bunch of crap necessitated by previously
bad drivers.  Since things are a lot better now, IMO there's not much of
a point to having ap_scan at all.  We should just be using ap_scan=1
+scan_ssid=1 everywhere and fix the drivers that don't work.

But the problem with ap_scan=2 is really about the failure window.
ap_scan=2 basically dumps a load of options on the driver, and unless
the options _exactly_ match the configuration of the AP, you won't
connect.  The supplicant isn't able to make intelligent choices about
which networks in its config file match the scan result, thus there's a
lot more potential for failure unless you know exactly what your network
is set up to do, and these capabilities aren't always exposed through
beacons.  So ap_scan=2 just opens up a huge window of failure and stuff
can't ever Just Work because no intelligence can be applied.

Dan


