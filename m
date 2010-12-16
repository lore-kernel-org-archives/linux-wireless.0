Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44819 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab0LPLa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 06:30:27 -0500
Subject: Re: [PATCH] mac80211: Push idle state to driver before stop
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org, luis.rodriguez@atheros.com
In-Reply-To: <AANLkTi=pZAnyp5ztSqCo-MEF=_arECfAYg43JJ_j1Gb4@mail.gmail.com>
References: <20101215194246.D5FCE204D8@glenhelen.mtv.corp.google.com>
	 <1292482775.3542.8.camel@jlt3.sipsolutions.net>
	 <AANLkTi=pZAnyp5ztSqCo-MEF=_arECfAYg43JJ_j1Gb4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 12:30:24 +0100
Message-ID: <1292499024.3612.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-16 at 03:17 -0800, Paul Stewart wrote:

> > I thought this was solved in ath9k differently? Was that somehow
> > inadequate?
> 
> Unfortunately previous attempts to solve this problem failed.

I thought ath9k was fixed to simply go idle when stopped? Why didn't
that help?

> Here's a slightly better rationale, as I'm getting to understand the problem.
> ieee80211_do_stop() decrements "open_count" so early during the function
> that if the device is not idle at this point (e.g, due to scanning),
> drv_config()
> will never be called on the the lower-level driver, since ieee80211_hw_config()
> tests for "open_count > 0" and silently returns no-error.

Yes, I realise that -- but also Luis said this change wasn't sufficient
in his tests, he also needed something in scan code itself. Also, this
is really quite intentional if you read the comments around the area
you're modifying -- mac80211 assumes that after it shuts down the device
with stop(), the device will be powered off under control of the driver
until start().

I just don't think it'll be easy to actually make sure that we always go
IDLE before calling stop(). This patch might solve part of the problem,
but what about hardware scan, that might have to be stopped by the
driver during stop()? Similar things might come up with other features.

Therefore I'm not sure we should even try. If we stop() the hardware,
what's preventing the driver from doing whatever it needs to put the
device into a low power state?

johannes

