Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:54495 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbZHRIZg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 04:25:36 -0400
Date: Tue, 18 Aug 2009 10:25:37 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/29] mwl8k: remove usage of deprecated radio_enabled
Message-ID: <20090818082537.GK18639@mail.wantstofly.org>
References: <20090818035220.GN18639@mail.wantstofly.org> <1250580509.30538.2.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1250580509.30538.2.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 18, 2009 at 09:28:29AM +0200, Johannes Berg wrote:

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
> >  		mwl8k_cmd_802_11_radio_disable(hw);
> >  		priv->current_channel = NULL;
> >  		rc = 0;
> 
> So I think the return; a little below needs to be removed to allow doing
> other things while the radio is off? I'm not sure which actually happen
> but I never audited the code to make sure nothing happens.

The logic is just:

	if (idle) {
		issue "radio disable" command
	} else {
		issue "radio enable" command
		set channel
		set tx power
		set antenna config
	}

So if a channel change hapens while we are idle, that event won't get
lost -- it'll just happen later.
