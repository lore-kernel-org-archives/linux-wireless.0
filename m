Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051AbYIOP2L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 11:28:11 -0400
Subject: Re: [RFC] mac80211: notify the user space about low signal quality
From: Dan Williams <dcbw@redhat.com>
To: Helmut Schaa <hschaa@suse.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200809151634.06448.hschaa@suse.de>
References: <200809151416.07552.hschaa@suse.de>
	 <200809151435.28933.hschaa@suse.de>
	 <1221487652.10177.23.camel@localhost.localdomain>
	 <200809151634.06448.hschaa@suse.de>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 11:28:49 -0400
Message-Id: <1221492529.10177.76.camel@localhost.localdomain> (sfid-20080915_172816_252391_61B52C2C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-15 at 16:34 +0200, Helmut Schaa wrote:
> Am Montag, 15. September 2008 16:07:31 schrieb Dan Williams:
> > On Mon, 2008-09-15 at 14:35 +0200, Helmut Schaa wrote:
> > > This patch adds a new wext event that notifies the user space about a low
> > > signal quality. The currently used indicator is as follows: If three
> > > successive beacons are received with a signal quality lower then 40%
> > > user space gets informed.
> > >
> > > Any ideas about which indicators should be used? Comments?
> >
> > So why does this need a new event?  Can't wpa_supplicant monitor the
> > signal quality (or level/noise if the driver doesn't provide "quality")
> > and do what it needs to do without any changes to the kernel at all?
> 
> I thought about that as well but I'm not sure if the signal quality/strength 
> is a well enough indicator.

Beacon misses should be a factor in quality, just like failed
decryptions or excessive retries.  Any of these are indications that the
"link" sucks and you might want to try finding a better AP.  Beacon
misses are just one piece of the whole quality thing.

> For example if we want to consider the number of missed beacons the current 
> IWEVQUAL event is not enough to expose this information.
> Additionally some devices can report missed beacons. Maybe even the quality 
> values reported by the drivers are not comparable at all (although they are 
> normalized to be between 0 and 100). Hence my intention was that mac80211 and 
> the driver might know better which indicators matter.

So if the values aren't comparable, we _make_ them comparable.  The
drivers can certainly tell mac80211 which things they are capable of
reporting for quality and the stack can figure them in to the final
"quality" measurement.  However, I do agree that having separate
indicators for the different factors is a good thing.  Thus something
like what Holger suggests would be better from my perspective than an
ethereal concept like a "roaming threshold".  Maybe just a poor choice
of terms?

Dan


