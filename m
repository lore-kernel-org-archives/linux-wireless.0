Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41964 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbZAWSwV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 13:52:21 -0500
Subject: Re: integration of opensource firmware with b43 kernel driver
From: Dan Williams <dcbw@redhat.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200901231908.05835.mb@bu3sch.de>
References: <FF33C500-6653-4A69-B34D-FBE47B2136D3@ing.unibs.it>
	 <497A05DC.4040101@lwfinger.net>  <200901231908.05835.mb@bu3sch.de>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 13:50:37 -0500
Message-Id: <1232736637.2577.40.camel@localhost.localdomain> (sfid-20090123_195226_132301_6198EC8C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-01-23 at 19:08 +0100, Michael Buesch wrote:
> On Friday 23 January 2009 19:01:00 Larry Finger wrote:
> > The driver can certainly be coded to look for the open-source firmware
> > names before trying to load vendor firmware. That way there will not
> > be any confusion.
> 
> I already posted that, but in case you missed it:
> http://bu3sch.de/patches/wireless-testing/20081227-1821/patches/008-b43-probe-open-fw.patch

Preferring the proprietary firmware over the open firmware (for now)
seems like the best approach at this time.  Many people will be quite
happy with the open firmware that we can actually ship in distros, and
those that aren't can do the fwcutter stuff and get their own
proprietary firmware.  If for some reason the open firmware isn't
working, use fwcutter and get the proprietary firmware, which you would
have had to do before anyway.  And those people with chips that aren't
supported by the proprietary firmware yet still have to use the
fwcutter, which they would have had to do anyway.  Win all around.

If in the future there's a set of chips that the open firmware is known
to work exceptionally well on, it could be preferred over the
proprietary firmware at that point.

Dan


