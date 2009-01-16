Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46960 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbZAPQ2A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 11:28:00 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 08:28:00 -0800
Date: Fri, 16 Jan 2009 08:27:31 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 10/13] cfg80211: remove check for last_request on
	ignore_reg_update()
Message-ID: <20090116162731.GD29609@tesla> (sfid-20090116_172807_696440_FAEA5BCD)
References: <1232064746-17134-3-git-send-email-lrodriguez@atheros.com> <1232064746-17134-4-git-send-email-lrodriguez@atheros.com> <1232064746-17134-5-git-send-email-lrodriguez@atheros.com> <1232064746-17134-6-git-send-email-lrodriguez@atheros.com> <1232064746-17134-7-git-send-email-lrodriguez@atheros.com> <1232064746-17134-8-git-send-email-lrodriguez@atheros.com> <1232064746-17134-9-git-send-email-lrodriguez@atheros.com> <1232064746-17134-10-git-send-email-lrodriguez@atheros.com> <1232064746-17134-11-git-send-email-lrodriguez@atheros.com> <1232097990.3854.31.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1232097990.3854.31.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 16, 2009 at 01:26:30AM -0800, Johannes Berg wrote:
> On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
> > There is no need to check for last_request as the callers of
> > update_all_wiphy_regulatory() ensure its present.
> 
> Are you sure? I had all this blow up all around me.

Interesting -- well that's the thing, where and why would it have blown up?
I did test it and didn't run into it.

  Luis

> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > ---
> >  net/wireless/reg.c |    2 --
> >  1 files changed, 0 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> > index 8bf999d..6c45832 100644
> > --- a/net/wireless/reg.c
> > +++ b/net/wireless/reg.c
> > @@ -1006,8 +1006,6 @@ static void handle_band_custom(struct wiphy *wiphy, enum ieee80211_band band,
> >  
> >  static bool ignore_reg_update(struct wiphy *wiphy, enum reg_set_by setby)
> >  {
> > -	if (!last_request)
> > -		return true;
> >  	if (setby == REGDOM_SET_BY_CORE &&
> >  		  wiphy->custom_regulatory)
> >  		return true;


