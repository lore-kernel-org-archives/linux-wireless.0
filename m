Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37748 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab1DAVtj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 17:49:39 -0400
Subject: Re: [PATCH v3 1/2] cfg80211: fix regulatory restore upon user hints
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, gregoryx.alagnou@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTimHCgmoWvC_Ou7BsiDjwxF=YB0h4-g=_afYxsQF@mail.gmail.com>
References: <1301686955-9402-1-git-send-email-lrodriguez@atheros.com>
	 <1301687948.3842.0.camel@jlt3.sipsolutions.net>
	 <AANLkTimJ8F-MFcK6raqcSFMsieGCx_gK_Ud1AF7BNPR2@mail.gmail.com>
	 <1301689736.3842.4.camel@jlt3.sipsolutions.net>
	 <AANLkTimHCgmoWvC_Ou7BsiDjwxF=YB0h4-g=_afYxsQF@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 23:49:34 +0200
Message-ID: <1301694574.3842.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-01 at 14:47 -0700, Luis R. Rodriguez wrote:
> On Fri, Apr 1, 2011 at 1:28 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Fri, 2011-04-01 at 13:10 -0700, Luis R. Rodriguez wrote:
> >>
> >> The order should not matter except that we want the queue to be
> >> cleared before processing core hints when doing restoration, otherwise
> >> the next user hint in the queue can be bogus and it will prevent a
> >> restore.
> >
> > I'm just thinking this temporary clearing could cause us to reject a
> > reply from CRDA that's coming in at the same time that is due to a user
> > request.
> 
> Ah, I see, hmm well I tested this with:
> 
> iw reg set US; iw reg set XA; iw reg set XB; iw reg set CR; iw dev
> wlan0 disconnect; iw reg set FR;

was CRDA running though? If so, it will probably reply right away -- I
don't think you can hit the race easily.

> and things were still being processed in the order sent. There is a
> small race between the unlock of the reg_mutex on
> restore_regulatory_settings() down until where we lock the
> regulatory_hint_core() and regulatory_hint_user(). The chances of a
> user regulatory hint coming in between is very low, I could not do it.
> Then there is also a small race of getting a user reg hint on
> restore_regulatory_settings() in between the regulatory_hint_user()
> and the lock of the reg_mutex again for processing old regulatory
> hints, but the worst that can happen in that case is we squeeze in a
> user regulatory hint in before the other older regulatory hints, and
> this is fine.
> 
> I cannot see any other cases here where we'd block a request from userspace.

No not block a request. I'm just thinking that this taking things off
the list temporarily might erroneously discard a crda response.

johannes

