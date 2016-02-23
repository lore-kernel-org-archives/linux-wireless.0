Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59393 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbcBWLGc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 06:06:32 -0500
Message-ID: <1456225589.2041.24.camel@sipsolutions.net> (sfid-20160223_120635_778128_07E3CD8A)
Subject: Re: [PATCH-v2 1/2] mac80211: Take bitrates into account when
 building IEs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 23 Feb 2016 12:06:29 +0100
In-Reply-To: <56C63D8B.9020900@candelatech.com>
References: <1445361858-24976-1-git-send-email-greearb@candelatech.com>
	 <1453807009.2759.23.camel@sipsolutions.net>
	 <56A78E8F.1080505@candelatech.com>
	 <1454576521.2564.6.camel@sipsolutions.net> <56B38FD1.40902@candelatech.com>
	 <1455827536.2084.35.camel@sipsolutions.net>
	 <56C62C4E.7020600@candelatech.com>
	 <1455828330.2084.38.camel@sipsolutions.net>
	 <56C630B7.7020604@candelatech.com>
	 <1455830078.2084.47.camel@sipsolutions.net>
	 <56C63D8B.9020900@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-02-18 at 13:54 -0800, Ben Greear wrote:

> > Yeah, it does, at least if you assume that the capabilities can
> > actually change. We assume they don't though, hostapd/wpa_s for
> > example will never re-query them after startup.
> 
> Restarting supplicant, even if it came to that, might be less
> of an issue than having to re-create the vdev to have it grab
> proper new settings from the wiphy...

> Well, it would be easy enough to make a method that updated an
> vdev/sdata->vht from wiphy, so could just call that as needed (ie,
> when certain things set or are changed by wiphy).

Yeah, I think we'll just have to deal with this when it comes along.
This multi-antenna-sharing case (unfortunately I forgot who was talking
about it) is the only thing that comes to mind where we really may have
to deal with this.


johannes
