Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:54260 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbYIOOeK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 10:34:10 -0400
From: Helmut Schaa <hschaa@suse.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [RFC] mac80211: notify the user space about low signal quality
Date: Mon, 15 Sep 2008 16:34:06 +0200
Cc: linux-wireless@vger.kernel.org
References: <200809151416.07552.hschaa@suse.de> <200809151435.28933.hschaa@suse.de> <1221487652.10177.23.camel@localhost.localdomain>
In-Reply-To: <1221487652.10177.23.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809151634.06448.hschaa@suse.de> (sfid-20080915_163413_416488_C7A7C487)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 15. September 2008 16:07:31 schrieb Dan Williams:
> On Mon, 2008-09-15 at 14:35 +0200, Helmut Schaa wrote:
> > This patch adds a new wext event that notifies the user space about a low
> > signal quality. The currently used indicator is as follows: If three
> > successive beacons are received with a signal quality lower then 40%
> > user space gets informed.
> >
> > Any ideas about which indicators should be used? Comments?
>
> So why does this need a new event?  Can't wpa_supplicant monitor the
> signal quality (or level/noise if the driver doesn't provide "quality")
> and do what it needs to do without any changes to the kernel at all?

I thought about that as well but I'm not sure if the signal quality/strength 
is a well enough indicator.

For example if we want to consider the number of missed beacons the current 
IWEVQUAL event is not enough to expose this information.
Additionally some devices can report missed beacons. Maybe even the quality 
values reported by the drivers are not comparable at all (although they are 
normalized to be between 0 and 100). Hence my intention was that mac80211 and 
the driver might know better which indicators matter.

Helmut
