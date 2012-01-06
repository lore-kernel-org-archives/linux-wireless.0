Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:50557 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030367Ab2AFQB0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 11:01:26 -0500
Date: Fri, 6 Jan 2012 17:01:22 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Julian Calaby <julian.calaby@gmail.com>
cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH] wireless: b43: fix Oops on card eject during transfer
In-Reply-To: <CAGRGNgUj3EUPKc0SX+3yCbygdbhS7_CN4hgR7ZAzjXuULw9fLg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1201061653050.18586@axis700.grange> (sfid-20120106_170130_221225_1D58CE8D)
References: <Pine.LNX.4.64.1201061256190.16279@axis700.grange>
 <CAGRGNgUj3EUPKc0SX+3yCbygdbhS7_CN4hgR7ZAzjXuULw9fLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian

On Sat, 7 Jan 2012, Julian Calaby wrote:

> Hi Guennadi,
> 
> On Fri, Jan 6, 2012 at 22:58, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > An Oops has once been observed, when the SDIO card had been ejected during
> > IO. The PC value shows, that the dev pointer in b43_op_stop() was NULL.
> >
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >
> > Might also be good for stable
> >
> >  drivers/net/wireless/b43/main.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> > index 5634d9a..3849c25 100644
> > --- a/drivers/net/wireless/b43/main.c
> > +++ b/drivers/net/wireless/b43/main.c
> > @@ -4834,6 +4834,9 @@ static void b43_op_stop(struct ieee80211_hw *hw)
> >        cancel_work_sync(&(wl->beacon_update_trigger));
> >
> >        mutex_lock(&wl->mutex);
> > +       if (!dev)
> > +               goto out_unlock;
> 
> Is there any reason to take this mutex, then jump to a label that
> releases it immediately?
> 
> Would it be better to add a new label after the mutex_unlock() below
> and jump to there immediately after the cancel_work_sync() call above?

The reason is exactly that: to avoid adding one more label. It is an 
exceptional case, that that branch would be taken, so, there's no reason 
to optimize for it. Whereas adding one label would clutter the code 
needlessly, IMHO.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
