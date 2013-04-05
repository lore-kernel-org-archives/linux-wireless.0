Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42576 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765141Ab3DENUJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 09:20:09 -0400
Message-ID: <1365168001.8515.28.camel@jlt4.sipsolutions.net> (sfid-20130405_152013_689663_10A88192)
Subject: Re: [PATCH 1/3] cfg80211: add get_max_tp() API
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@open-mesh.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 05 Apr 2013 15:20:01 +0200
In-Reply-To: <20130405083956.GA14463@open-mesh.com>
References: <1365105442-31876-1-git-send-email-antonio@open-mesh.com>
	 <CAGXE3d98a4pBG=gWKUm9A2RJRN+eic4Zi8dh4grTuqQmW3GOsg@mail.gmail.com>
	 <20130405083956.GA14463@open-mesh.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-04-05 at 10:39 +0200, Antonio Quartulli wrote:

> In the batman-adv module (which implements a routing protocol for mesh networks
> on layer 2) we are trying to switch metric from packet loss to throughput and
> the idea is to read the estimation from the rate control component (thanks to
> the API mechanism in cfg/mac80211 this can be eventually changed later).

While this makes some sense, going into the details of your patchset I
find that it's overly complex.

I think you should fix minstrel to report the best rate in
txrc.reported_rate. This would also have the effect of not showing
sampling attempts to userspace in the "current TX rate", which generally
makes a lot of sense.

After doing that, reading the rate becomes a get_station_info() call or
so.

One more detail:

int cfg80211_get_max_tp(struct wireless_dev *wdev, u8 *peer, u32 *tp)

I really don't think that the wireless_dev should be necessary for this,
it ought to be just a netdev IMHO. Also, the peer should be const :)

johannes

