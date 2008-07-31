Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbYGaNwq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 09:52:46 -0400
Subject: Re: Issue: iwlist scanning sees the network; dhclient can't connect
From: Dan Williams <dcbw@redhat.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>,
	"Thiago F. Tavares" <ttavares@halogica.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200807311531.54665.mb@bu3sch.de>
References: <1127857B97C63B4285A9B02BEF67AEE601627648@afrodite.halogica.com.br>
	 <1217447463.25919.10.camel@dv>
	 <1217493665.3392.0.camel@Friederike-PC.hoffi>
	 <200807311531.54665.mb@bu3sch.de>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 09:49:19 -0400
Message-Id: <1217512159.12016.1.camel@localhost.localdomain> (sfid-20080731_155250_111229_7EAB64AB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-07-31 at 15:31 +0200, Michael Buesch wrote:
> On Thursday 31 July 2008 10:41:05 Johannes Berg wrote:
> > On Wed, 2008-07-30 at 15:51 -0400, Pavel Roskin wrote:
> > > On Wed, 2008-07-30 at 21:41 +0200, Michael Buesch wrote:
> > > 
> > > > dhclient works fine for me. Although it's true that it sometimes
> > > > messes with up/down state. But you _can_ use it, if you take some care.
> > > 
> > > True.  But b43 has the lowest dhclient survival rate of all drivers I
> > > know.  That's an empirical observation, of course.
> > 
> > I think debian patches out the down/up behaviour. We may be seeing that.
> 
> Oh, that might explain why I don't see this behaviour.

We all agreed at the OLS Wireless Summit that the up/down behavior of
dhclient was just f**king stupid and should be patched out.  Upstream
doesn't seem to be very responsive.

It just kills mac80211-based drivers, and drivers that do firmware
upload on dev->open() because all settings get lost and the driver would
have to re-load everything, which is ton of code in the driver that
shouldn't have to be there.  It's bad for Intel WiMAX devices too
because they do firmware upload in dev->open().

Dan


