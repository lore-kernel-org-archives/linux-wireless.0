Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45831 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab2ISTeV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 15:34:21 -0400
Message-ID: <1348083291.7081.11.camel@jlt4.sipsolutions.net> (sfid-20120919_213424_564609_1D0B27CF)
Subject: Re: [PATCH 0/3] mac80211: avoid useless delBA frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Sep 2012 21:34:51 +0200
In-Reply-To: <CA+XVXfcxHENu1HzY+-WkyMr6g+3P2wSyj7BhDsfKgZoB7fZHRg@mail.gmail.com> (sfid-20120919_213223_186953_DD439D7E)
References: <1348049313-7650-1-git-send-email-johannes@sipsolutions.net>
	 <CA+XVXfcxHENu1HzY+-WkyMr6g+3P2wSyj7BhDsfKgZoB7fZHRg@mail.gmail.com>
	 (sfid-20120919_213223_186953_DD439D7E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-09-19 at 22:32 +0300, Arik Nemtsov wrote:
> On Wed, Sep 19, 2012 at 1:08 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > There are a few situations where it's completely pointless
> > to send delBA action frames, so let's remove them.
> 
> Maybe it's a good opportunity to also fix ieee80211_reconfig? I
> remember you mentioned some FW/HW issue there, perhaps this was solved
> in the meantime. Otherwise we can add a HW flag for that I guess.

Not sure what you mean?

FWIW these patches were sitting in my tree as part of a larger set of
changes around the driver ampdu callback to help drivers with internal
queues drop or flush frames appropriately and to react to the different
situations. I didn't think about reconfig at all with this.

johannes

