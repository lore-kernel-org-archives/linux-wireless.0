Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbYIOOpJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 10:45:09 -0400
Subject: Re: More thoughts about roaming ...
From: Dan Williams <dcbw@redhat.com>
To: Helmut Schaa <hschaa@suse.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200809151618.19161.hschaa@suse.de>
References: <200809151416.07552.hschaa@suse.de>
	 <1221487160.10177.14.camel@localhost.localdomain>
	 <200809151618.19161.hschaa@suse.de>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 10:45:48 -0400
Message-Id: <1221489948.10177.57.camel@localhost.localdomain> (sfid-20080915_164514_443408_530030F2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-15 at 16:18 +0200, Helmut Schaa wrote:
> Am Montag, 15. September 2008 15:59:20 schrieb Dan Williams:
> > On Mon, 2008-09-15 at 14:16 +0200, Helmut Schaa wrote:
> > > Hi,
> > >
> > > As a result of the thread "Pondering: how to improve mac80211 roaming
> > > ..." I thought a bit more about that topic. Here is a quick suggestion
> > > for a first version:
> > >
> > > * Enhance mac80211 software scan to interrupt the current scan and switch
> > >   back to the operating channel every once in a while (only if at least
> > > one STA interface is associated) => background scan.
> > >
> > > * Enhance mac80211 to check the signal quality frequently (or any other
> > >   indicator like beacon misses) and decide when the signal quality is too
> > > low. Indicate that to the user space.
> > >
> > > * wpa_supplicant (or any other user space application) gets notified
> > > about the low signal quality and triggers a scan in order to find a
> > > better AP. wpa_supplicant already chooses the AP with the best signal
> > > strength.
> >
> > I'm pretty sure it doesn't.  The code in wpa_supplicant_select_bss()
> > doesn't have any logic to detect signal strength, nor does any driver
> > report signal strength to the supplicant.  Drivers set the level (well,
> > only wext/nl80211, ndis, iphone/osx, and bsd) but I'm pretty sure
> > nothing in the supplicant uses it.
> 
> Once the supplicant receives the actual scan results it orders them by
> security, rate, signal level and finally quality (see 
> src/drivers/scan_helpers.c, wpa_scan_sort_results). Hence if multiple APs
> have the same SSID the one with the best signal level (or quality) will
> be the first in the scan results and wpa_supplicant just selects the first
> matching AP. Works fine here ;)

Ah, ok.  Hadn't caught that part.

> > Maybe now is the time to switch that on.  That needs to be coupled with
> > some additions to cfg80211 to turn firmware/driver roaming on and off,
> > along with a capability bit somewhere to indicate that the
> > driver/firmware support turning roaming on/off.
> 
> True. Which cards that can do roaming in driver/firmware?

Most fullmac ones.  airo, atmel, orinoco, libertas, ipw2100/2200/2915,
etc.

Dan


