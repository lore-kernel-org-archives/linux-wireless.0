Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34506 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab0CSWLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 18:11:12 -0400
Date: Fri, 19 Mar 2010 18:10:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>, stable@kernel.org
Subject: Re: [PATCH v3] ssb: do not read SPROM if it does not exist
Message-ID: <20100319221048.GG9552@tuxdriver.com>
References: <1269030785-5347-1-git-send-email-linville@tuxdriver.com> <1269031309-23297-1-git-send-email-linville@tuxdriver.com> <201003192212.55680.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201003192212.55680.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 19, 2010 at 10:12:55PM +0100, Michael Buesch wrote:
> On Friday 19 March 2010 21:41:49 John W. Linville wrote:

> > diff --git a/drivers/ssb/scan.c b/drivers/ssb/scan.c
> > index 0d6c028..6d51895 100644
> > --- a/drivers/ssb/scan.c
> > +++ b/drivers/ssb/scan.c
> > @@ -306,6 +306,10 @@ int ssb_bus_scan(struct ssb_bus *bus,
> >  		}
> >  		tmp = scan_read32(bus, 0, SSB_CHIPCO_CAP);
> >  		bus->chipco.capabilities = tmp;
> > +		if (bus->chipco.dev->id.revision >= 11) {
> > +			tmp = scan_read32(bus, 0, SSB_CHIPCO_CHIPSTAT);
> > +			bus->chipco.status = tmp;
> > +		}
> 
> Hm, Ok. There's another issue here. We're that early in the scan that
> id.xxxx is not assigned, yet. I think chipco.dev might even be NULL here, so
> it'd crash.
> This gets a little bit ugly. The revisions are read later in the scan function.
> And as you can see there the actual read is pretty ugly, too.
> 
> What if we do not read the status _that_ early? We're really very very
> early here. If you move the read into the chipcommon driver init, it will be much
> easier.

Yeah, that makes sense.  Patch to follow...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
