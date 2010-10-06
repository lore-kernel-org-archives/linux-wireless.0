Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53552 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab0JFLqV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 07:46:21 -0400
Subject: Re: [PATCH] mac80211: hoist sta->lock from reorder release timer
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ben Greear <greearb@candelatech.com>,
	Ming Lei <tom.leiming@gmail.com>
In-Reply-To: <201010061343.23463.chunkeey@googlemail.com>
References: <201010061200.54364.chunkeey@googlemail.com>
	 <201010061220.50800.chunkeey@googlemail.com>
	 <1286361705.3655.121.camel@jlt3.sipsolutions.net>
	 <201010061343.23463.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 13:46:18 +0200
Message-ID: <1286365578.3655.187.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 13:43 +0200, Christian Lamparter wrote:

> > Basically the thing is that until your patch, the data in the struct
> > didn't actually need locking because it was accessed by the RX path only
> > which is not concurrent.
> > 
> I see. So basically all rx handlers are affected by these rx->sta races.
> 
> John, can you please revert (or at least drop from the upcoming 2.6.37-rcX cycle):
> 
> (mac80211: fix release_reorder_timeout in scan)
> mac80211: fix rcu-unsafe pointer dereference
> mac80211: AMPDU rx reorder timeout timer
> (mac80211: remove unused rate function parameter)
> mac80211: put rx handlers into separate functions

I think it's probably easier to fix than to revert now? There are only a
handful of fields, and it seemed to me that most of them can easily be
moved under the reorder lock.

johannes

