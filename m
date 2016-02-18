Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45401 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425560AbcBRUpe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 15:45:34 -0500
Message-ID: <1455828330.2084.38.camel@sipsolutions.net> (sfid-20160218_214538_603546_D1AF5CEB)
Subject: Re: [PATCH-v2 1/2] mac80211: Take bitrates into account when
 building IEs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 18 Feb 2016 21:45:30 +0100
In-Reply-To: <56C62C4E.7020600@candelatech.com>
References: <1445361858-24976-1-git-send-email-greearb@candelatech.com>
	 <1453807009.2759.23.camel@sipsolutions.net>
	 <56A78E8F.1080505@candelatech.com>
	 <1454576521.2564.6.camel@sipsolutions.net> <56B38FD1.40902@candelatech.com>
	 <1455827536.2084.35.camel@sipsolutions.net>
	 <56C62C4E.7020600@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-02-18 at 12:40 -0800, Ben Greear wrote:

> > 1) sdata->sband[5GHZ].vht = wiphy->sband[5GHZ].vht & user-config
> >     (semantically, not implementation of course)
> > 2) sdata->sband[5GHZ].vht = wiphy->sband[5GHZ].vht

> I think option 1 might be better.  For option 2, I'd be worried about
> someone changing the wiphy somehow and vdevs getting out of sync.

Huh? I'm confused. Those two options above weren't meant as options,
they were meant as two sides of an "if (have-user-config)" branch :)

> Any opinions on the lifetime for the sdata->sband_user_config data?
> 
> For instance, could be cleared when station dis-associates,
> or we could make it persist until changed or until vdev goes away?

Should probably persist.

> And, while this would take care of some of the issues (3x3 vs 2x2?),
> it still wouldn't let someone have full control over the advertised
> rates vs configured-rates and such, would it?

Why not? The sband also contains the rates list. I was just using VHT
as an example.


johannes
