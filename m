Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3757 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731AbXFKTzg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 15:55:36 -0400
Date: Mon, 11 Jun 2007 15:18:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	linux-wireless@vger.kernel.org, Joe Jezak <josejx@gentoo.org>,
	Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH] softmac: use list_for_each_entry
Message-ID: <20070611191854.GG10397@tuxdriver.com>
References: <20070527142740.GB13105@APFDCB5C> <1180643064.18266.2.camel@johannes.berg> <46604279.3070908@lwfinger.net> <1180725169.11026.29.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1180725169.11026.29.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 01, 2007 at 09:12:49PM +0200, Johannes Berg wrote:
> On Fri, 2007-06-01 at 10:59 -0500, Larry Finger wrote:

> > In the earlier discussion, we also concluded that the product of a conversion from softmac to 
> > mac80211 should not be included in mainline, with the exception of the b-only code. Depending on how 
> > long the port and testing take, and the state of bcm43xx-mac80211 at that time, a reversal of that 
> > earlier decision may be in order.
> 
> I'd think that once somebody has time for it both port and testing
> should go pretty soon, and I'd think that we can do that sooner than fix
> the current bcm43xx-mac80211, in which case IMHO the result should be
> included in mainline seeing that zd1211rw will probably be ready for
> mac80211 in the .23 timeframe. That means that at that point we might
> even be able to drop softmac already if the second straightforward (here
> I mean without any other changes to the driver) bcm43xx port is ready :)

FWIW, I would like to see a mac80211-based port of the current
bcm43xx driver available as soon as it is ready, without waiting to
strip-out the non-b portions.  This should help us abandon softmac
as soon as possible.

Plus, we may need to consider preserving the driver in its current
form (aside from the softmac -> mac80211 port) for some time as a
compatibility aid for those who already have working configurations
with the "bcm43xx" driver.  Forcing a happy user to locate new firmware
for no obvious benefit to them is not very nice (as I have learned
so well w/ Fedora 7)...

John
-- 
John W. Linville
linville@tuxdriver.com
