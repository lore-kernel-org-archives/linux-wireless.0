Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51280 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab2GFQPy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 12:15:54 -0400
Message-ID: <1341591350.16893.13.camel@jlt3.sipsolutions.net> (sfid-20120706_181558_938680_AD58E510)
Subject: Re: [PATCH 4/4] cfg80211: add cellular base station regulatory hint
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kvalo@qca.qualcomm.com, arend@broadcom.com, henry@logout.com,
	senthilb@qca.qualcomm.com
Date: Fri, 06 Jul 2012 18:15:50 +0200
In-Reply-To: <CAB=NE6XaRZa4HKg25gd5zkWn=LrjcAXq4NMPVcFWn+PdtVwRdw@mail.gmail.com> (sfid-20120706_180734_075991_9264CB9D)
References: <1341357315-8053-1-git-send-email-rodrigue@qca.qualcomm.com>
	 <1341357315-8053-5-git-send-email-rodrigue@qca.qualcomm.com>
	 <1341394944.4482.9.camel@jlt3.sipsolutions.net>
	 <CAB=NE6UfGuOh843dSx7NG7UYtEiDVcLUJbu6nFnBJs-Qk4tszw@mail.gmail.com>
	 <1341474303.4455.5.camel@jlt3.sipsolutions.net>
	 <CAB=NE6Uw1pso+HmVAahMvT3BZ0AheWxXuhJFLedvsHKXsUn11g@mail.gmail.com>
	 <1341556785.4462.0.camel@jlt3.sipsolutions.net>
	 <CAB=NE6XmbAu+xkLHYaBt=z6zdxXME5cOoANUd_3yEr+va_jb8g@mail.gmail.com>
	 <1341583919.16893.3.camel@jlt3.sipsolutions.net>
	 <CAB=NE6XNmrS=kqoptMg67JhBQUJfYa=jUFz+aU-4E91vzqjnTg@mail.gmail.com>
	 <1341589880.16893.11.camel@jlt3.sipsolutions.net>
	 <CAB=NE6XaRZa4HKg25gd5zkWn=LrjcAXq4NMPVcFWn+PdtVwRdw@mail.gmail.com>
	 (sfid-20120706_180734_075991_9264CB9D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-06 at 09:07 -0700, Luis R. Rodriguez wrote:

> > What I really wanted to know though is this: If the core code is
> > enabled, what effect does receiving a "blessed" hint have on devices
> > that don't set the flag? If there's no effect vs. an "unblessed" hint,
> > then I think we don't need another option?
> 
> Ah, OK so yes, as it is right now if the core accepts the hint but
> devices do not listen to it we do have an effect right now which I
> alluded to in my cover letter: country IE hints won't be listened to
> after a base station hint gets accepted. Whether or not we want to
> process country IE hints *after* a cell base station hint gets
> accepted is debatable -- I decided that its easier to implement to
> ignore country IE hints after a cell base station hint and I also
> decided cell base station hints are likely something you'd prefer to
> review over country IE hints. We can certainly change this and I'm
> open to it.
> 
> So yes, as it is right now if you enable onus but your device does not
> support he feature you may detect a regression: country IE hints would
> not be processed if you did receive a base station hint that the core
> processed.

It seems this might be a problem, in the case that I mentioned before:
you do take all the necessary steps to enable this, but then somebody
plugs in a USB device (say this is a tablet-like device?)

It seems it would be better to make the base station/country IE hint
also depend on the feature flag?

johannes

