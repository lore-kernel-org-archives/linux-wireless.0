Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:54493 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbZHRIYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 04:24:17 -0400
Date: Tue, 18 Aug 2009 10:24:19 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/29] mwl8k: remove usage of deprecated radio_enabled
Message-ID: <20090818082419.GJ18639@mail.wantstofly.org>
References: <20090818035220.GN18639@mail.wantstofly.org> <1250580466.30538.1.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1250580466.30538.1.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 18, 2009 at 09:27:46AM +0200, Johannes Berg wrote:

> > Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
> > ---
> >  drivers/net/wireless/mwl8k.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
> > index 9f54204..3a201a2 100644
> > --- a/drivers/net/wireless/mwl8k.c
> > +++ b/drivers/net/wireless/mwl8k.c
> > @@ -2935,7 +2935,7 @@ static int mwl8k_config_wt(struct work_struct *wt)
> >  	struct mwl8k_priv *priv = hw->priv;
> >  	int rc = 0;
> >  
> > -	if (!conf->radio_enabled) {
> > +	if (conf->flags & IEEE80211_CONF_IDLE) {
> 
> Ok, I thought about doing this but wasn't sure it would work -- you can
> still accept channel changing commands while the radio is off, for
> instance?

The hardware would accept those commands, but they wouldn't have any
effect, since the radio is off.  If/when we then go out of idle later,
the channel set and power set and antenna config commands will be run,
so we'll end up with the right parameters.
