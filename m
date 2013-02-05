Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46497 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab3BEJev (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 04:34:51 -0500
Message-ID: <1360056900.8376.0.camel@jlt4.sipsolutions.net> (sfid-20130205_103508_871504_41B096C0)
Subject: Re: [PATCHv7 2/3] mac80211: add radar detection command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Tue, 05 Feb 2013 10:35:00 +0100
In-Reply-To: <20130205084405.GA7865@pandem0nium>
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1359462120-22898-3-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1359643448.8415.62.camel@jlt4.sipsolutions.net>
	 <20130131163126.GB1387@pandem0nium>
	 <1359650902.8415.93.camel@jlt4.sipsolutions.net>
	 <20130131174758.GC2018@pandem0nium>
	 <1359712620.8528.5.camel@jlt4.sipsolutions.net>
	 <20130202221544.GA22363@pandem0nium>
	 <1359999125.17993.15.camel@jlt4.sipsolutions.net>
	 <20130205084405.GA7865@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-05 at 09:44 +0100, Simon Wunderlich wrote:
> On Mon, Feb 04, 2013 at 06:32:05PM +0100, Johannes Berg wrote:
> > On Sat, 2013-02-02 at 23:15 +0100, Simon Wunderlich wrote:
> > > On Fri, Feb 01, 2013 at 10:57:00AM +0100, Johannes Berg wrote:
> > > > On Thu, 2013-01-31 at 18:47 +0100, Simon Wunderlich wrote:
> > > > 
> > 
> > That sounds strange -- how does ath9k even know about an interface
> > that's not UP? Maybe you mean it didn't start an AP?
> 
> Yeah, that is what I meant - the AP wasn't started on this on that interface.

Ok.

> > Why does the driver even report it by interface? It seems it should do
> > it on a channel context, or even on the hw since it can only be a single
> > channel in that case anyway?
> 
> Well, yeah the reporting is currently done per interface. Reporting radars
> for the hw is certainly possible as well - channel contexts are currently
> not implemented in ath9k (where I test). The latest patchset works the same
> way, although we can change that if you prefer. For the current implementation
> (single channel, single vif) it makes no difference, maybe for future implementations.
> I don't know if there are any weird corner cases though, and we probably need to
> adjust the mac80211 interface too when to report radars on certain channels only
> (e.g. extension channel radar).

It really just seems strange to me to report radar on all/any other
interfaces to userspace. If we leave it up to the drivers, we'll get all
kinds of strange behaviour ;-)

So it seems better to let mac80211 manage that?

johannes

