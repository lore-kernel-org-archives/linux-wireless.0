Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbYIOPSh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 11:18:37 -0400
Subject: Re: [RFC] mac80211: notify the user space about low signal quality
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, Helmut Schaa <hschaa@suse.de>
In-Reply-To: <200809151710.43827.hs4233@mail.mn-solutions.de>
References: <200809151416.07552.hschaa@suse.de>
	 <200809151435.28933.hschaa@suse.de>
	 <1221487652.10177.23.camel@localhost.localdomain>
	 <200809151710.43827.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 11:19:12 -0400
Message-Id: <1221491952.10177.65.camel@localhost.localdomain> (sfid-20080915_171839_684795_B48E9A45)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-15 at 17:10 +0200, Holger Schurig wrote:
> > So why does this need a new event?  Can't wpa_supplicant
> > monitor the signal quality (or level/noise if the driver
> > doesn't provide "quality") and do what it needs to do without
> > any changes to the kernel at all?
> 
> It could, but to do this, wpa_supplicant (or whatever) would have 
> to periodically get awake, send the query command to mac80211 
> and get the result.
> 
> With an event, it just sits sleeping until some interesting event 
> arrives. Nicer programming idiom, AFAIK.

Except that everything that listens to WEXT events gets woken up every
time an event comes in anyway.  So any card doing background scanning
will wake up the supplicant too; I honestly think that every few seconds
is OK here.  BTW, make sure you rate-limit the background scanning
events from mac80211 in your patches to every few seconds (I picked 4
for ipw2200) otherwise it floods events and wakes up everything all the
time.

My main problem is that adding a beacon threshold to mac80211 isn't a
great idea because it's not a standard value and it's not something
really applicable to mac80211; it's policy which is different for
different programs, and the way you've implemented it here it's global
for the interface.

Dan


