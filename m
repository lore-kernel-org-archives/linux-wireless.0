Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab1HJR1I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 13:27:08 -0400
Subject: Re: [PATCH 1/2] ssb: fix DMA translation for some specific boards
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
In-Reply-To: <20110810184406.6cad6d17@milhouse> (sfid-20110810_184423_775264_26C1F383)
References: <1312992688-6976-1-git-send-email-zajec5@gmail.com>
	 <20110810184028.3cb9c532@milhouse>
	 <CACna6rxBof9T+vaZ=wHZJcXY12XVrYvFbHEdXk1+=_LAwjmtig@mail.gmail.com>
	 <20110810184406.6cad6d17@milhouse> (sfid-20110810_184423_775264_26C1F383)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 19:27:03 +0200
Message-ID: <1312997223.4325.24.camel@jlt3.sipsolutions.net> (sfid-20110810_192712_208582_E81541AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-10 at 18:44 +0200, Michael Büsch wrote:

> > >> +     if (dev->id.coreid == SSB_DEV_80211)
> > >> +             return (chip_id == 0x4322 || chip_id == 43221 ||
> > >> +                     chip_id == 43231 || chip_id == 43222);
> > >> +     return 0;
> > >> +}
> > >
> > > ACK, apart from this coding style violation (missing curly braces).
> > 
> > From kernel CodingStyle:
> > > Do not unnecessarily use braces where a single statement will do.
> > >
> > > if (condition)
> > > 	action();
> > 
> > I guess simple "return" (even when using line break) is still like
> > single statement...
> > Am I wrong?
> > 
> 
> Last time I checked this only applied to single-line-statements.
> Maybe it changed, though.

Just sidestep the issue and invert the test ;-)
(However, CodingStyle says nothing about single lines, only statements,
and I tend to agree)

johannes


