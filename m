Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49813 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaEGMfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 08:35:11 -0400
Message-ID: <1399466096.10517.30.camel@jlt4.sipsolutions.net> (sfid-20140507_143516_548374_12D4C980)
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Date: Wed, 07 May 2014 14:34:56 +0200
In-Reply-To: <CA+BoTQmAZ-KhVpbAXMK+5CRdiCEpt6zr4NBREUGEFPSqvwvPOg@mail.gmail.com> (sfid-20140507_142010_671514_98AF37AC)
References: <1397050174-26121-14-git-send-email-michal.kazior@tieto.com>
	 <1398849681-3606-1-git-send-email-michal.kazior@tieto.com>
	 <1399372915.4218.17.camel@jlt4.sipsolutions.net>
	 <CA+BoTQk1upg7yGK-QWoz8QhMeRzLBY60Lk=eUN=iQLaF2pUhQQ@mail.gmail.com>
	 <1399385141.4218.37.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnGRtdOGfJ78EG43cmND2bD9m3WyvmSKx92uBFnKenPkw@mail.gmail.com>
	 <1399450061.5038.10.camel@jlt4.sipsolutions.net>
	 <1399455657.6800.4.camel@dubbel>
	 <CA+BoTQmXb=_jjE4-dL8U_-8=CxRMgo4qckUKF9LizfV2W0iC7A@mail.gmail.com>
	 <1399457760.6800.7.camel@dubbel>
	 <CA+BoTQnF3pVmGumqqHbfuphXbYhAybHUMosX4kJazfHWJDE+Fw@mail.gmail.com>
	 <1399460964.10517.12.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnSJgaN=incAtW08tSqDgW2jRm1cdarMhupArGBAw7FRQ@mail.gmail.com>
	 <1399463646.10517.28.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmAZ-KhVpbAXMK+5CRdiCEpt6zr4NBREUGEFPSqvwvPOg@mail.gmail.com>
	 (sfid-20140507_142010_671514_98AF37AC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 14:20 +0200, Michal Kazior wrote:

> >  1) for_each_vif: switch vif from oldctx to newctx
> >  2) add newctx
> >     for_each_vif: switch vif from oldctx to newctx
> >     del oldctx
> >
> > With the option between 1/2 being selected by the flags. I don't see
> > what the driver has to infer about it being a channel switch - it
> > necessarily is one, no?
> 
> Yeah - existing usecases include only CSA and some primitive ops.
> 
> What I mean is if you want to avoid chanctx overcommit you need to
> perform (2) the other way around (i.e. first unassign and delete
> oldctx and then create newctx), at least internally. This would simply
> be more of a hassle with multiple call transaction API.

Well, sure you really have to do it the other way around - but we'd be
assuming the driver does whatever it can internally, for that call

johannes

