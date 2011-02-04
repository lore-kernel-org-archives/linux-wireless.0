Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42811 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab1BDOaW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 09:30:22 -0500
Date: Fri, 4 Feb 2011 09:21:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Vivek Natarajan <vnatarajan@atheros.com>, Greg KH <greg@kroah.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath9k: Drain txq before sending a nullfunc frame.
Message-ID: <20110204142130.GB2539@tuxdriver.com>
References: <1296800640-6381-1-git-send-email-vnatarajan@atheros.com>
 <AANLkTi=tANgmxukLg0GQbLRkc-XuEBi-hmpJono=q=m8@mail.gmail.com>
 <AANLkTinSy7tQDXrVo2AdRpyQ2dQvvaeoJEpYdK1YszfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTinSy7tQDXrVo2AdRpyQ2dQvvaeoJEpYdK1YszfQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 03, 2011 at 11:36:27PM -0800, Luis R. Rodriguez wrote:
> Adding Greg for real this time.
> 
>   Luis
> 
> On Thu, Feb 3, 2011 at 11:36 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > On Thu, Feb 3, 2011 at 10:23 PM, Vivek Natarajan <vnatarajan@atheros.com> wrote:
> >> In a highly noisy environment, a data frame which is queued before
> >> a nullfunc frame on a different hw queue may be sent over the air
> >> after the tx completion of nullfunc frame. This causes the station
> >> to enter power save and the AP to see the station as awake and
> >> continues to send the data traffic. Fix this by draining all tx
> >> queues before we send the null function frame with PM bit set.
> >>
> >> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> >
> > Hm nice, this is a good example of one of those random not-so-critical
> > but still nice fixes which I wish would go to stable. John, Greg, any
> > qualms for such things to go to stable if they apply? It was my
> > impression we could send it, but I want to verify with both you guys
> > so neither we or John get bashed if we try to send it as a stable fix.

I think the feeling is that it is silly to mark something for stable if
it is not important enough to be sent as a fix for the current release.

The standard for being sent for the current release seems to
vary a bit between different maintainers, the particular release
(i.e. how grumpy is Linus), and the point of the release cycle (i.e.
loser at -rc1, tighter at -rc6).  But for the most part, to go to the
current release it needs to fix a bug rather than adding a feature.
The strictest definitions of "bug" include crashes, data corrupters,
and some (or possibly all) regressions.  As usual, judging bug
"worthiness" is a bit of a judgment call.

All that said, I think the question is what grey area exists for
something that arrives late in the current release cycle but that
might still be viewed as a (minor) bug fix?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
