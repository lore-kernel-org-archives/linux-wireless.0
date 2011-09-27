Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46393 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1I0HuM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 03:50:12 -0400
Subject: Re: [RFC 03/15] mac80211: also expire filtered frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Chadd <adrian@freebsd.org>
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <CAJ-Vmo=9MUaKph=EXwF2VnE+=nHg4s=j=qhR2jnwa-xsXMno7g@mail.gmail.com> (sfid-20110927_042854_028200_8F3D1D54)
References: <20110922154726.521122680@sipsolutions.net>
	 <20110922154849.369194760@sipsolutions.net>
	 <CAB=NE6UP9xYmLY3nJRMVdjPky87hB1YzFTHEzBv0Pt=qv3kAmg@mail.gmail.com>
	 <CAJ-Vmo=9MUaKph=EXwF2VnE+=nHg4s=j=qhR2jnwa-xsXMno7g@mail.gmail.com>
	 (sfid-20110927_042854_028200_8F3D1D54)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 09:50:07 +0200
Message-ID: <1317109807.4082.4.camel@jlt3.sipsolutions.net> (sfid-20110927_095016_239994_B27942B3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-09-27 at 10:26 +0800, Adrian Chadd wrote:
> On 27 September 2011 06:30, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> 
> > No particular comments on the code yet but latency issues has got me
> > thinking about the filtered frames stuff and if we really need it. How
> > much benefit does keeping these frames give us instead of just
> > dropping them?
> 
> Do you guys keep statistics about this sort of thing?

Not sure.

> My macbook pro ends up causing my FreeBSD AP to miss TX'ing a lot of
> frames, even if it's close by. This only occurs when it's on battery
> power.
> 
> I have a feeling it's going to be doing aggressiveish power saving
> stuff and this'll be fixed by me porting over and tidying up the
> filtered frames support.

I'm surprised you don't have filtered frames support! It's pretty
important unless you keep hardware queues almost empty since otherwise
exactly what you describe will happen. The hardware is supposed to keep
track of when a station goes to sleep (only WAKE->DOZE transition, must
rely on driver/stack for DOZE->WAKE transition to avoid packet
reordering) and reject ("filter") frames on the queue in that case.

johannes

