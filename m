Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52384 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab3BFT2R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 14:28:17 -0500
Message-ID: <1360178909.7910.61.camel@jlt4.sipsolutions.net> (sfid-20130206_202832_779390_E67D47D4)
Subject: Re: [PATCH] net: mac80211/cfg.c: fix error using of sizeof()
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: dinggnu@gmail.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Wed, 06 Feb 2013 20:28:29 +0100
In-Reply-To: <20130206.133304.809962323533002767.davem@davemloft.net>
References: <1360167826-29265-1-git-send-email-dinggnu@gmail.com>
	 <20130206.133304.809962323533002767.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-06 at 13:33 -0500, David Miller wrote:
> From: Cong Ding <dinggnu@gmail.com>
> Date: Wed,  6 Feb 2013 17:23:45 +0100
> 
> > Using 'sizeof' on array given as function argument returns size of a pointer
> > rather than the size of array.
> > 
> > Signed-off-by: Cong Ding <dinggnu@gmail.com>
> > ---
> >  net/mac80211/cfg.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> > index 661b878..af561d5 100644
> > --- a/net/mac80211/cfg.c
> > +++ b/net/mac80211/cfg.c
> > @@ -2058,7 +2058,8 @@ static int ieee80211_set_mcast_rate(struct wiphy *wiphy, struct net_device *dev,
> >  {
> >       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> >  
> > -     memcpy(sdata->vif.bss_conf.mcast_rate, rate, sizeof(rate));
> > +     memcpy(sdata->vif.bss_conf.mcast_rate, rate,
> > +                     sizeof(int) * IEEE80211_NUM_BANDS);
> >  
> 
> This is not indented properly.  The "sizeof(int..." should start at the
> first column after the openning parenthesis of the memcpy() call.

Yeah I fixed it when I applied it ... oh well.

johannes


