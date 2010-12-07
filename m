Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37462 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab0LGRbw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 12:31:52 -0500
Subject: Re: [PATCH 5/5] mac80211: fix issuing idle calls when device open
 count is 0
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	amod.bodas@atheros.com, stable@kernel.org
In-Reply-To: <AANLkTinXPOgOJB0ntHra4B_V0z9Qux2yrdiuqkyW7WuJ@mail.gmail.com>
References: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
	 <1291690135-4535-6-git-send-email-lrodriguez@atheros.com>
	 <1291714709.3607.2.camel@jlt3.sipsolutions.net>
	 <AANLkTinZK_xMJUDaDWzOpW7FXUERUNS3Y0btx=WS9KR1@mail.gmail.com>
	 <1291735415.3607.46.camel@jlt3.sipsolutions.net>
	 <AANLkTinXPOgOJB0ntHra4B_V0z9Qux2yrdiuqkyW7WuJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 18:31:38 +0100
Message-ID: <1291743098.3607.49.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-07 at 09:28 -0800, Paul Stewart wrote:

> > Actually I believe it happens _during_ ifdown, but when the running bit
> > is already cleared, so I guess this is about right -- although it
> > shouldn't matter since the recalc_idle in do_stop should catch it later.
> 
> So the scenario is as follows.  If you down an interface
> ieee80211_do_stop() first decrements local->open_count, then later
> calls __ieee80211_recalc_idle, et al.  This means that later in this
> call graph if ieee80211_hw_config() finally gets called, open_count is
> already 0 and therefore drv_config is never called.  Luis' reference
> to scan_completed() above is probable in reference to older versions
> of compat where ieee80211_stop() called ieee80211_scan_cancel()
> directly.  My admittedly casual look at wireless-testing seems to
> imply that path may not exist in current compat, although my tests
> seem to indicate the same class of problem still exists.

Yeah I can see how a problem like this happens -- but I think the change
in scan_finished() is pointless because it'll be handled during
do_stop() anyway.

johannes

