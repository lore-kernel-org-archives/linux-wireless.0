Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:51234 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752994Ab2A3T7b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 14:59:31 -0500
Received: by mail-lpp01m010-f44.google.com with SMTP id l5so2845662lah.31
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 11:59:29 -0800 (PST)
Subject: Re: [PATCH 00/12] wl12xx: update fw api
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Kalle Valo <kvalo@adurom.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1327931733.3626.72.camel@cumari>
References: <1327924857-1250-1-git-send-email-eliad@wizery.com>
	 <87fwexco94.fsf@purkki.adurom.net>
	 <CAB3XZEfaQAD0p2VJ28znznaB3P_3z3NvEiROJTbyCW+su2gLzg@mail.gmail.com>
	 <1327931733.3626.72.camel@cumari>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Jan 2012 21:59:25 +0200
Message-ID: <1327953565.3626.111.camel@cumari> (sfid-20120130_205934_503384_8DAAC6D6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-01-30 at 15:55 +0200, Luciano Coelho wrote: 
> On Mon, 2012-01-30 at 15:52 +0200, Eliad Peller wrote: 
> > On Mon, Jan 30, 2012 at 3:29 PM, Kalle Valo <kvalo@adurom.com> wrote:
> > > Eliad Peller <eliad@wizery.com> writes:
> > >
> > >> The fw api was changed in the latest FWs (6.3.5.0.95 for wl127x
> > >> and 7.3.5.0.95 for wl128x).
> > >>
> > >> Along with some small adjustments, the main changes
> > >> inroduced by this patheset are configuring the
> > >> templates per-role, and moving to IEEE80211_HW_SUPPORTS_DYNAMIC_PS
> > >> mode.
> > >
> > > I didn't look so carefully, but doesn't this break bisect? I mean if you
> > > change the firmware api in small patches wl12xx can't work properly
> > > until all patches are applied, right?
> > >
> > > I would say that a huge patch doing all the necessary changes in one go
> > > is better, even it's ugly.
> > >
> > yes. it will break bisect (although it shouldn't break compilations).
> > i guess it's a matter of taste, but i think keeping the patches
> > manageable is more important than being able to bisect.
> 
> I tend to agree with Eliad.  If we do all in one go, git blame will be
> horrible.
> 
> But it's a good point and I'm not fully convinced what is the best way
> to go. :\

I think this is okay.  With the 2 squashes I proposed, there will be
only 3 patches where bisect would be broken.

We could add an info in the first patch and remove it in the last one to
make it clear that we're in the middle of the change.

Does anyone go against this?

-- 
Cheers,
Luca.

