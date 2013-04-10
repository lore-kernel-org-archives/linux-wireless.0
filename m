Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60847 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760271Ab3DJSQu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 14:16:50 -0400
Message-ID: <1365617800.4235.31.camel@jlt4.sipsolutions.net> (sfid-20130410_201654_045375_D4BA60D1)
Subject: Re: [PATCH 3/6] mac80211: ieee80211_queue_stopped returns reasons
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Date: Wed, 10 Apr 2013 20:16:40 +0200
In-Reply-To: <CAG6hwVOamzGVJ8x3omSu_9oY48WK=8nk=3P4CWnba53TfhsqUw@mail.gmail.com> (sfid-20130410_193731_490850_24C6FDAC)
References: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
	 <1365444377-9959-3-git-send-email-thomas@cozybit.com>
	 <1365446248.25475.17.camel@jlt4.sipsolutions.net>
	 <CAG6hwVOBqfP_Mw-pirzEOFytck-7H6_LNiTtO_90gXskbEuNTg@mail.gmail.com>
	 <1365449914.25475.20.camel@jlt4.sipsolutions.net>
	 <CAG6hwVOAwtngWU3uEueG7hZX3z5dxLLc8c8-Vd7Q+e93wM-UaQ@mail.gmail.com>
	 <1365500246.8465.5.camel@jlt4.sipsolutions.net>
	 <CAG6hwVOamzGVJ8x3omSu_9oY48WK=8nk=3P4CWnba53TfhsqUw@mail.gmail.com>
	 (sfid-20130410_193731_490850_24C6FDAC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-10 at 10:36 -0700, Thomas Pedersen wrote:

> > However it seems that ieee80211_queue_stopped() is actually kinda broken
> > and should only return the 'driver-stopped' reason to start with. If you
> > fix that, it's probably good enough for you. I don't think in patch 4
> > you should drop frames for scanning, for example.
> 
> It looks like mac80211 already just checks local->queue_stop_reasons
> for being 0 (or not), so that check would still hold. I'm not 100%
> sure the driver calls to ieee80211_queue_stopped() only returning true
> for REASON_DRIVER are ok? What if the queues are being flushed, or say
> REASON_PS is set?

I looked at the drivers, and while (almost?) all of them use it
incorrectly they really want only REASON_DRIVER. In fact, they'd be
better off with just that even in the incorrect usages.

johannes

