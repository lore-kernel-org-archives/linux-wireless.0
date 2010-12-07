Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52037 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab0LGPXl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 10:23:41 -0500
Subject: Re: [PATCH 5/5] mac80211: fix issuing idle calls when device open
 count is 0
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	amod.bodas@atheros.com, stable@kernel.org
In-Reply-To: <AANLkTinZK_xMJUDaDWzOpW7FXUERUNS3Y0btx=WS9KR1@mail.gmail.com>
References: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
	 <1291690135-4535-6-git-send-email-lrodriguez@atheros.com>
	 <1291714709.3607.2.camel@jlt3.sipsolutions.net>
	 <AANLkTinZK_xMJUDaDWzOpW7FXUERUNS3Y0btx=WS9KR1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 16:23:35 +0100
Message-ID: <1291735415.3607.46.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-07 at 07:20 -0800, Paul Stewart wrote:
> On Tue, Dec 7, 2010 at 1:38 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Mon, 2010-12-06 at 18:48 -0800, Luis R. Rodriguez wrote:
> >> --- a/net/mac80211/pm.c
> >> +++ b/net/mac80211/pm.c
> >> @@ -301,7 +301,7 @@ static void __ieee80211_scan_completed_finish(struct ieee80211_hw *hw,
> >>       }
> >>
> >>       mutex_lock(&local->mtx);
> >> -     ieee80211_recalc_idle(local);
> >> +     ieee80211_recalc_idle_force(local);
> >
> > Does this really occur afterwards closing interfaces?
> 
> It appears possible using wpa_supplicant with nl80211, at least using
> the new DBus API.

Actually I believe it happens _during_ ifdown, but when the running bit
is already cleared, so I guess this is about right -- although it
shouldn't matter since the recalc_idle in do_stop should catch it later.

johannes

