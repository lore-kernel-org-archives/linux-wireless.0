Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:41156 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYADHFT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2008 02:05:19 -0500
Received: by py-out-1112.google.com with SMTP id u52so10921276pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jan 2008 23:05:18 -0800 (PST)
Message-ID: <43e72e890801032305m73c6a76fwfb867ac2af13aa10@mail.gmail.com> (sfid-20080104_070523_981587_89ACAFD8)
Date: Fri, 4 Jan 2008 02:05:17 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: ath5k oops (recent regression, I think)
Cc: "bruno randolf" <bruno@thinktube.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	"Andrew Lutomirski" <luto@myrealbox.com>,
	linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>, ath5k-devel@lists.ath5k.org
In-Reply-To: <1199406854.4172.139.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <cb0375e10712241906u198c695br1e2120e6cfee3b0d@mail.gmail.com>
	 <200712251804.13693.bruno@thinktube.com>
	 <40f31dec0712250623yb2bfeahfa1b7024e1fb67f3@mail.gmail.com>
	 <200712261117.33992.bruno@thinktube.com>
	 <43e72e890801031602q38a8f57fv3ba56a0f44e7e2c6@mail.gmail.com>
	 <1199406854.4172.139.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 3, 2008 7:34 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > We use ieee80211_generic_frame_duration() to compute what we believe
> > is the ACK timeout and set it on the rate duration registers, and we
> > need this value set during reset, as we up the interface. The *real*
> > problem here is we need mac80211 to provide an exported routine which
> > drivers can use even if they don't have an up'd interface yet IMHO.
> > This can be easily fixed by making ieee80211_generic_frame_duration()
> > not rely on sdata and letting the user pass manually if short preamble
> > is desired in the calculation as an arg. I have to go now but will try
> > to address this as soon as I have time unless someone beats me.
>
> That'd be wrong as well because w/o a virtual interface you can't be
> associated and hence you have no way of knowing whether the frame
> duration should be for short preamble or not.

Its not because the setting isn't for the targeted currently used rate
but instead its for setting the table of duration for the entire list
of possible rates for both short *and* for long preamble, whether you
are associated or not, on the current mode (a/b/g, custom) you are in.
Note that right now we actually ignore short preamble timing and just
use long preamble timing but we technically should set both and hence
my suggestion.

> Besides, the old behaviour was to return 0 from the frame_duration()
> function when an invalid interface ID was passed which would always
> happen in this function.
>
> I think you need to rethink what this piece of code is trying to
> accomplish and fix it accordingly.

You're right. We currently are setting rate duration table upon reset
but I believe this is unnecessary as the values *should* remain
intact. We really only should be setting the rate duration table upon
mode change but:

a. I have to take a look at your new mode changes to mac80211 as any
effort to change this now may be removed soon anyway
b. we still should set the rate duration table depending on the mode

One approach we can take here is to just fix
ieee80211_frame_duration() to export it for driver use by removing erp
stuff and let the routine figure out OFDM erp rates, remove passing
ieee80211_local as drivers don't have access to it and move drivers
using ieee80211_generic_frame_duration() to this.

All this needs some more work and for now we need a quick fix for this
oops though as it makes the driver unusable. I'll send a patch based
on bruno but does the check in hw reset instead.

  Luis
