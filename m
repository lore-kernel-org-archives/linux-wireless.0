Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36231 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab0I2RZk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 13:25:40 -0400
Subject: Re: [PATCH] mac80211: fix rate_control_send_low warnings for delbas
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, stable@kernel.org,
	linux-wireless@vger.kernel.org, Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <AANLkTi=qGb+aEz48kNKUvuhgA2RAr0pbQoENYV_DazWT@mail.gmail.com>
References: <20100928222945.GB10932@tux>
	 <1285748303.3756.19.camel@jlt3.sipsolutions.net>
	 <AANLkTi=qGb+aEz48kNKUvuhgA2RAr0pbQoENYV_DazWT@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 19:25:38 +0200
Message-ID: <1285781138.3756.29.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-29 at 10:10 -0700, Luis R. Rodriguez wrote:

> > I really think that can be done more easily though. For one, clearly we
> > already have the warning, so we don't need more infrastructure to catch
> > such errors?!
> 
> This is true, I just added that to ensure I hit these when testing
> really, I can nuke the counter, but it can help if eventually believe
> we have a proper fix to allow these frames through somehow too.
> 
> > Also, this may end up hiding issues that we don't yet
> > understand, like the nullfunc one you were talking about.
> 
> Yeah, good point, although I am under the impression this is a similar
> situation, we probably try to send a nullfunc to notify the old AP we
> are going to go awake if we are transmitting data while roaming. But
> yeah, its not easily triggerable yet.
> 
> > The delBA one
> > we now understand fully, so it makes more sense to simply suppress
> > sending delBA when we are going to disassociate by way of associating
> > with a new AP, no?
> 
> That's reasonable but we will still need the channel, otherwise how
> would we know its this issue?

Why do we care? We can just always suppress sending the delba when we
get into _set_disassoc() from mgd_assoc(), no?

johannes

