Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34302 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaANQVG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 11:21:06 -0500
Message-ID: <1389716461.32635.15.camel@jlt4.sipsolutions.net> (sfid-20140114_172111_556794_EFF0C58D)
Subject: Re: [RFC 4/4] cfg80211: implement multi-BSS CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 14 Jan 2014 17:21:01 +0100
In-Reply-To: <1389194818-7864-5-git-send-email-michal.kazior@tieto.com> (sfid-20140108_163118_648639_B6C7553E)
References: <1389194818-7864-1-git-send-email-michal.kazior@tieto.com>
	 <1389194818-7864-5-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140108_163118_648639_B6C7553E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-08 at 16:26 +0100, Michal Kazior wrote:
> This extends NL80211_CMD_CHANNEL_SWITCH by adding
> a new attribute NL80211_ATTR_SWITCH_NEXT. The
> attribute holds nested channel switch attributes
> (including itself) allowing
> multi-interface/chained CSA.

That's ... creative? Interesting? I'm not sure I like that API much.

OTOH, it's a neat way of reusing all the attributes that we have, etc.

However, I think it'd be easier to implement on both sides of the fence
if we structured this differently and made the "more vifs" to be a
nested attribute with data inside each one of them.

Actually, I'd suggest that in the multi-vif case all of the attributes
should be inside the list, like this:

 wiphy, chswitch=[1=[ifidx,...], 2=[ifidx,...], 3=[ifidx,...]]

alternatively, maybe something that would be nice would be

 wiphy, chswitch=[ifidx1=[...], ifidx2=[...], ifidx3=[...]]

but the common way would be to ignore the array index completely.

Today you get

 wiphy, ifidx, ..., next=[ifidx, ..., next=[ifidx, ..., next=[...]]]

and I don't really like the deep nesting.

I would also argue that doing
 wiphy, ifidx1, ..., more=[1=[ifidx2, ...], ...]
or
 wiphy, ifidx1, ..., next=[...]

is more error prone as it would allow older kernels to parse the whole
thing while ignoring the next/more/whatever, so you'd get some weird
subset of the intended behaviour. Forcing *all* interfaces into the
sub-attribute when more than one is desired (or in fact for a single
one, if you're ok with requiring a kernel with support) would IMHO be
less error prone.

Haven't looked over the code in much detail, but a few small comments:
 * I think you should preserve tracing, it has facilities for arrays too
 * hard-coding a limit of 8 vifs seems pointless, you can easily
allocate dynamic
   memory, no?

johannes

