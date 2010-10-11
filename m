Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51560 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab0JKMAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 08:00:35 -0400
Subject: Re: [Patch 1/1] wext: fix 32/64 bit alignment issue for 'point'
 type
From: Johannes Berg <johannes@sipsolutions.net>
To: gerrit@erg.abdn.ac.uk
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <56374.148.187.160.35.1286798194.squirrel@148.187.160.35>
References: <20100930102508.GB3581@gerrit.erg.abdn.ac.uk>
	 <1285857487.5137.2.camel@jlt3.sipsolutions.net>
	 <42875.148.187.160.35.1285917725.squirrel@148.187.160.35>
	 <1285921839.3739.16.camel@jlt3.sipsolutions.net>
	 <20101011051410.GA3977@gerrit.erg.abdn.ac.uk>
	 <1286790947.3634.9.camel@jlt3.sipsolutions.net>
	 <56374.148.187.160.35.1286798194.squirrel@148.187.160.35>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 14:00:32 +0200
Message-ID: <1286798432.3634.39.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-11 at 12:56 +0100, gerrit@erg.abdn.ac.uk wrote:
> > However, I don't understand this patch. Your original patch would have
> > fixed this just as well, since after it
> >
> > IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN
> >
> > would be
> >
> > (IW_EV_LCP_PK_LEN + 4) - IW_EV_LCP_PK_LEN == 4
> >
> > and at the same time fixes the userspace problem, if anyone really wants
> > to use wext in new applications that don't use iwlib still...
> >
> Good catch, this is much better (I got lost in all the other constants).
> I will check if I have not missed anything and resubmit if there are no
> side effects.

Alright, thanks. I'm pretty sure you can't have missed anything, since
git grep for the constant shows only this single use, and iwlib ships a
header file that already contains your correction :-)

I'm not sure if there's a real or perceived length limit on git commit
logs, but it might be nice to archive your discussion of the problem
(today's, I mean) in the git log.

Anyway, thanks for investigating this!

johannes

