Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12551 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760613AbZARRjN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 12:39:13 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2009 09:39:13 -0800
Date: Sun, 18 Jan 2009 09:38:40 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 08/13] cfg80211: save original values on regulatory
	hints
Message-ID: <20090118173840.GY29609@tesla> (sfid-20090118_183917_716748_26E2B0B6)
References: <1232064746-17134-7-git-send-email-lrodriguez@atheros.com> <1232064746-17134-8-git-send-email-lrodriguez@atheros.com> <1232064746-17134-9-git-send-email-lrodriguez@atheros.com> <1232097921.3854.28.camel@johannes> <20090116163100.GE29609@tesla> <1232138062.3745.6.camel@johannes> <20090116210655.GK29609@tesla> <1232268449.3877.8.camel@johannes> <20090118152844.GR29609@tesla> <1232298725.3819.4.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1232298725.3819.4.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 18, 2009 at 09:12:05AM -0800, Johannes Berg wrote:
> On Sun, 2009-01-18 at 07:28 -0800, Luis R. Rodriguez wrote:
> 
> > Are you suggesting we consider new API for drivers which want the
> > behaviour we want? That works for me too, but then again I'd be applying
> > the save orig_* stuff perhaps at the end of this new, say,
> > regulatory_hint_strict().
> 
> Well, I was more thinking to have a 
> struct regdomain *cfg80211_ask_crda(const char *alpha2);
> 
> but I realise that is very hard to implement with the call to userspace
> etc. So yeah, doing something like the _strict you propose seems more
> appropriate. Maybe call it something else, not _hint,and have it call
> out to userspace regardless (i.e. don't ever ignore that hint, as we
> might ignore other hints), say regulatory_apply(wiphy, alpha2)? Not
> sure, apply seems not quite right either.

I'd definitely would prefer if cfg80211 handled this instead of the drivers
through the reg_notifier(), will go back and try to do that and see if I
can come up with a decent name to indicate what we are doing.

  Luis
