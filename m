Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38272 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab1BUHmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 02:42:52 -0500
Received: by yxs7 with SMTP id 7so196952yxs.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 23:42:52 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19810.6003.617296.993948@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 13:12:43 +0530
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 16/23] ath9k_htc: Disable powersave if an AP interface is present
In-Reply-To: <20110221051715.GA17236@vasanth-laptop>
References: <19809.52162.358774.683966@gargle.gargle.HOWL>
	<20110221051715.GA17236@vasanth-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan wrote:
> On Mon, Feb 21, 2011 at 07:49:46AM +0530, Sujith wrote:
> > From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> > 
> > Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/htc_drv_main.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> > index f384b35..4779bb1 100644
> > --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> > +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> > @@ -1393,7 +1393,8 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
> >  
> >  	}
> >  
> > -	if (changed & IEEE80211_CONF_CHANGE_PS) {
> > +	if ((priv->ah->opmode != NL80211_IFTYPE_AP) &&
> > +	    (changed & IEEE80211_CONF_CHANGE_PS)) {
> >  		if (conf->flags & IEEE80211_CONF_PS) {
> >  			ath9k_htc_setpower(priv, ATH9K_PM_NETWORK_SLEEP);
> >  			priv->ps_enabled = true;
> 
> Is it not that mac80211 already takes care of that?.

Yeah, it appears to have been fixed recently in mac80211.
So this patch can be dropped.

Sujith
