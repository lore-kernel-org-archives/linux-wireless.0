Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:37456 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579AbYIOQp4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 12:45:56 -0400
From: Helmut Schaa <hschaa@suse.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [RFC] mac80211: notify the user space about low signal quality
Date: Mon, 15 Sep 2008 18:45:35 +0200
Cc: linux-wireless@vger.kernel.org
References: <200809151416.07552.hschaa@suse.de> <200809151634.06448.hschaa@suse.de> <1221492529.10177.76.camel@localhost.localdomain>
In-Reply-To: <1221492529.10177.76.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809151845.35841.hschaa@suse.de> (sfid-20080915_184559_140211_92A544A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 15. September 2008 schrieb Dan Williams:
> On Mon, 2008-09-15 at 16:34 +0200, Helmut Schaa wrote:
> > Am Montag, 15. September 2008 16:07:31 schrieb Dan Williams:
> > > On Mon, 2008-09-15 at 14:35 +0200, Helmut Schaa wrote:
> > > > This patch adds a new wext event that notifies the user space about a low
> > > > signal quality. The currently used indicator is as follows: If three
> > > > successive beacons are received with a signal quality lower then 40%
> > > > user space gets informed.
> > > >
> > > > Any ideas about which indicators should be used? Comments?
> > >
> > > So why does this need a new event?  Can't wpa_supplicant monitor the
> > > signal quality (or level/noise if the driver doesn't provide "quality")
> > > and do what it needs to do without any changes to the kernel at all?
> > 
> > I thought about that as well but I'm not sure if the signal quality/strength 
> > is a well enough indicator.
> 
> Beacon misses should be a factor in quality, just like failed
> decryptions or excessive retries.  Any of these are indications that the
> "link" sucks and you might want to try finding a better AP.  Beacon
> misses are just one piece of the whole quality thing.

Right.

> > For example if we want to consider the number of missed beacons the current 
> > IWEVQUAL event is not enough to expose this information.
> > Additionally some devices can report missed beacons. Maybe even the quality 
> > values reported by the drivers are not comparable at all (although they are 
> > normalized to be between 0 and 100). Hence my intention was that mac80211 and 
> > the driver might know better which indicators matter.
> 
> So if the values aren't comparable, we _make_ them comparable.  The
> drivers can certainly tell mac80211 which things they are capable of
> reporting for quality and the stack can figure them in to the final
> "quality" measurement.  However, I do agree that having separate
> indicators for the different factors is a good thing.  Thus something
> like what Holger suggests would be better from my perspective than an
> ethereal concept like a "roaming threshold".  Maybe just a poor choice
> of terms?

Ok, I'll sum that up. Moving the policy into user space is a good thing if the
quality values are comparable. Once mac80211 recognices a noticable quality
change we could use IWEVQUAL to notify user space about it. Furthermore (if
desired) the signal could be extended to not only report a value between 0
and 100 but could also contain flags indicating lost beacons, excessive retries
etc.

Helmut
