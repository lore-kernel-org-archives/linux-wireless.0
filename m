Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from avasout08.plus.net ([212.159.14.20]:39528 "EHLO
	avasout08.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab3CTNst convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 09:48:49 -0400
Date: Wed, 20 Mar 2013 13:43:02 +0000
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: isedev@gmail.com
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/RFT] b43: A fix for DMA transmission sequence errors
Message-ID: <20130320134302.26ea16c7@laptop.homenet> (sfid-20130320_144855_453961_0AA059BE)
In-Reply-To: <4518745.W5blfs9sIi@wks001.ise.net>
References: <51421afb.xUa3KbaBuvmUk4RG%Larry.Finger@lwfinger.net>
	<CACna6rxAGN5cx6BXrdpM+-q_6QAQAvfb8+qhe-romE4hdxSs3g@mail.gmail.com>
	<514350EA.2060205@lwfinger.net>
	<4518745.W5blfs9sIi@wks001.ise.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 20 Mar 2013 12:26:23 +0100
ISE Development <isedev@gmail.com> wrote:

> On Friday 15 Mar 2013 11:48:42 Larry Finger wrote:
> > On 03/15/2013 01:37 AM, Rafał Miłecki wrote:
> > > OK, so after early tests, this card doesn't support
> > > full-addressing at all.
> > > 
> > > I'll give this patch a try during the weekend.
> > 
> > Please follow Michael's suggestion, and change
> > 
> > 		if (slot == firstused + 2) {
> > 
> > into
> > 
> > 		if (slot == next_slot(ring, next_slot(ring,
> > firstused))) {
> > 
> > This change is needed just in case "firstused + 2" wraps around.
> > 
> > Thanks,
> > 
> > Larry
> 
> Did you get a chance to validate this patch?
> 
> So far on my system, it has been running for over week without
> problems (over 15GB of traffic).

If it helps as a data point, I have run the patch with the wrap-over
change suggested by Michael Busch and with the unlikely->likely
branching correction and it has been working fine for the last 5 days
on the 3.8.2 kernel, with approx 5GB of traffic. Before that, I put
about 10GB through the previous version of the patch as originally sent
by isedev.

Chris
