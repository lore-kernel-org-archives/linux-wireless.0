Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46027 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbaCUMDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 08:03:33 -0400
Message-ID: <1395403409.4164.4.camel@jlt4.sipsolutions.net> (sfid-20140321_130349_852084_621D244F)
Subject: Re: [PATCH] mac80211: don't downgrade VHT20 to HT20
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 21 Mar 2014 13:03:29 +0100
In-Reply-To: <CA+BoTQm_w4qk98pYbJ4Fz5NL-zTq7eCkAepOYGtd=LGVCLTU9A@mail.gmail.com> (sfid-20140320_103959_427442_78E9C470)
References: <1393327628-1078-1-git-send-email-michal.kazior@tieto.com>
	 <1393330040.4170.0.camel@jlt4.sipsolutions.net>
	 <1393330210.4170.1.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnvSxOCxV4UwUmi2_if8NQWWJCht=urAewBZAiEJdHpZA@mail.gmail.com>
	 <1395238934.4142.22.camel@jlt4.sipsolutions.net>
	 <CA+BoTQm_w4qk98pYbJ4Fz5NL-zTq7eCkAepOYGtd=LGVCLTU9A@mail.gmail.com>
	 (sfid-20140320_103959_427442_78E9C470)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-03-20 at 10:39 +0100, Michal Kazior wrote:

> >> The spec also defines VHT BSS operating channel width is derived from
> >> HT Operation Element: STA Channel Width field (Table 10-19) and 20 MHz
> >> is not forbidden for AP/mesh. hostapd seems to go in line with this
> >> and allows VHT20 and VHT40.
> >
> > Yes but how is that related to the *capability* bit? You're talking
> > about the HT/VHT operation information.
> 
> Good point.
> 
> Hostapd sets *both* HT Capability and HT Information IEs to "only
> 20Mhz" for VHT20. I can see Cisco EA6500 do the same thing too.

That used to be fine for HT only, but I guess it's wrong for VHT. It
also means that it cannot switch to 40 MHz on the fly later.

> > So are you saying the station isn't setting 20_40 capability? Or is
> > something else unsetting the bit in case it's a 20MHz network?
> 
> In case of AP mode you get ht_capa/vht_capa from userspace (i.e.
> hostapd). This would again imply hostapd does it wrong or is it
> perhaps the interface describing HT/VHT state is insufficient? Should
> mac80211 treat HT Capab and HT Info separately? Should they be passed
> and processed separately?

It's possible that the interface is insufficient (*), but I'd argue that
if that is the case then it'd be a question of setting the operation
mode rather than any per-station information, since the per-station
information should really be capabilities, while the current operation
mode should be for the interface? If the kernel knows what it's
operating as (*) and knows the station capabilities, everything else
should be clear immediately, no?

(*) right now I suspect that the channel bandwidth is used, which might
be incorrect if we ever want to implement dynamic bandwidth switching in
the AP

johannes

