Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60220 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab0LGJxD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 04:53:03 -0500
Subject: Re: [RFC] cfg80211: Make NL80211_CMD_SET_REG synchronous
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <1291715126-7652-1-git-send-email-helmut.schaa@googlemail.com>
References: <1291715126-7652-1-git-send-email-helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 10:53:02 +0100
Message-ID: <1291715582.3607.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-07 at 10:45 +0100, Helmut Schaa wrote:
> A user space caller of NL80211_CMD_SET_REG previously had no chance to
> verify if the regulatory domain change it requested already happened.
> Listening to NL80211_CMD_REG_CHANGE is not enough since it won't be
> triggered when the regulatory domain didn't change (for example because
> it was already the same before).
> 
> Fix this by making NL80211_CMD_SET_REG synchronous by adding a
> completion struct to the regulatory_hint_user function and wait for the
> completion of the regulatory request before returning.

Way too complicated. regulatory_hint_user() is called in a context that
can sleep, obviously, so you can just make it call something like
run_regulatory_request() that will cancel_work_sync(reg_work) and call
reg_todo() after queueing, instead of schedule_work(reg_work)  -- that
way when it returns all things have been processed.

johannes

