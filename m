Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41095 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab0JFKK3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 06:10:29 -0400
Subject: Re: [PATCH] mac80211: hoist sta->lock from reorder release timer
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ben Greear <greearb@candelatech.com>,
	Ming Lei <tom.leiming@gmail.com>
In-Reply-To: <201010061200.54364.chunkeey@googlemail.com>
References: <201010061200.54364.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 12:10:26 +0200
Message-ID: <1286359826.3655.85.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 12:00 +0200, Christian Lamparter wrote:

> The timer itself is part of the station's private struct.
> The clean-up routine will deactivate the timer as soon as
> the station is removed. Therefore the extra sta->lock
> protection should not be necessary.

>  	rcu_read_lock();
> -	spin_lock(&sta->lock);
>  	ieee80211_release_reorder_timeout(sta, *ptid);
> -	spin_unlock(&sta->lock);
>  	rcu_read_unlock();

There's a comment on ieee80211_release_reorder_timeout() saying that the
lock must be held -- which is probably not true? We don't generally hold
that lock on the RX path...?

johannes

