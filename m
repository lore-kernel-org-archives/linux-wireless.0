Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54642 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab2AMPQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jan 2012 10:16:09 -0500
Date: Fri, 13 Jan 2012 10:08:01 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH] wireless: b43: fix Oops on card eject during transfer
Message-ID: <20120113150800.GB18899@tuxdriver.com> (sfid-20120113_161615_319551_AD21E27D)
References: <Pine.LNX.4.64.1201061256190.16279@axis700.grange>
 <CAGRGNgUj3EUPKc0SX+3yCbygdbhS7_CN4hgR7ZAzjXuULw9fLg@mail.gmail.com>
 <Pine.LNX.4.64.1201061653050.18586@axis700.grange>
 <Pine.LNX.4.64.1201130028340.1646@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <Pine.LNX.4.64.1201130028340.1646@axis700.grange>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well, you weren't interested in making the minor change suggested
by Julian.  So I set it aside with the intent of making the change
myself, then neglected to follow through. :-(  I'll try to get to
that today.  Or, feel free to submit a new version yourself.

John

On Fri, Jan 13, 2012 at 12:29:13AM +0100, Guennadi Liakhovetski wrote:
> Hi
> 
> I haven't seen this patch going into any tree or being included in any 
> pull request. What's the status?
> 
> Thanks
> Guennadi
> 
> On Fri, 6 Jan 2012, Guennadi Liakhovetski wrote:
> 
> > Hi Julian
> > 
> > On Sat, 7 Jan 2012, Julian Calaby wrote:
> > 
> > > Hi Guennadi,
> > > 
> > > On Fri, Jan 6, 2012 at 22:58, Guennadi Liakhovetski
> > > <g.liakhovetski@gmx.de> wrote:
> > > > An Oops has once been observed, when the SDIO card had been ejected during
> > > > IO. The PC value shows, that the dev pointer in b43_op_stop() was NULL.
> > > >
> > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > > ---
> > > >
> > > > Might also be good for stable
> > > >
> > > >  drivers/net/wireless/b43/main.c |    3 +++
> > > >  1 files changed, 3 insertions(+), 0 deletions(-)
> > > >
> > > > diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> > > > index 5634d9a..3849c25 100644
> > > > --- a/drivers/net/wireless/b43/main.c
> > > > +++ b/drivers/net/wireless/b43/main.c
> > > > @@ -4834,6 +4834,9 @@ static void b43_op_stop(struct ieee80211_hw *hw)
> > > >        cancel_work_sync(&(wl->beacon_update_trigger));
> > > >
> > > >        mutex_lock(&wl->mutex);
> > > > +       if (!dev)
> > > > +               goto out_unlock;
> > > 
> > > Is there any reason to take this mutex, then jump to a label that
> > > releases it immediately?
> > > 
> > > Would it be better to add a new label after the mutex_unlock() below
> > > and jump to there immediately after the cancel_work_sync() call above?
> > 
> > The reason is exactly that: to avoid adding one more label. It is an 
> > exceptional case, that that branch would be taken, so, there's no reason 
> > to optimize for it. Whereas adding one label would clutter the code 
> > needlessly, IMHO.
> > 
> > Thanks
> > Guennadi
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
