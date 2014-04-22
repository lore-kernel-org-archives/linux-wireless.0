Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48593 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933680AbaDVSAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 14:00:19 -0400
Date: Tue, 22 Apr 2014 13:53:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: greearb@candelatech.com, ath9k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k:  Prevent divide by zero kernel crash.
Message-ID: <20140422175322.GA16193@tuxdriver.com> (sfid-20140422_200039_192642_709DF2BC)
References: <1397695240-13710-1-git-send-email-greearb@candelatech.com>
 <534F870E.80209@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <534F870E.80209@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please consider Felix's comments while refactoring this for the
current code structure...

John

On Thu, Apr 17, 2014 at 09:47:26AM +0200, Felix Fietkau wrote:
> On 2014-04-17 02:40, greearb@candelatech.com wrote:
> > From: Ben Greear <greearb@candelatech.com>
> > 
> > Make sure we cannot ever assign beacon interval to zero.
> > 
> > Signed-off-by: Ben Greear <greearb@candelatech.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/beacon.c | 4 ++++
> >  drivers/net/wireless/ath/ath9k/recv.c   | 3 ++-
> >  2 files changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
> > index 2e8bba0..5391f01 100644
> > --- a/drivers/net/wireless/ath/ath9k/beacon.c
> > +++ b/drivers/net/wireless/ath/ath9k/beacon.c
> > @@ -443,6 +443,8 @@ static u32 ath9k_mod_tsf64_tu(u64 tsf, u32 div_tu)
> >  {
> >  	u32 tsf_mod, tsf_hi, tsf_lo, mod_hi, mod_lo;
> >  
> > +	if (WARN_ON_ONCE(div_tu == 0))
> > +		div_tu = 100;
> >  	tsf_mod = tsf & (BIT(10) - 1);
> >  	tsf_hi = tsf >> 32;
> >  	tsf_lo = ((u32) tsf) >> 10;
> Why add this warning here if you already have the additions below? We
> don't need multiple layers of defensive checks for the same thing.
> 
> > @@ -667,6 +669,8 @@ static void ath9k_cache_beacon_config(struct ath_softc *sc,
> >  		"Caching beacon data for BSS: %pM\n", bss_conf->bssid);
> >  
> >  	cur_conf->beacon_interval = bss_conf->beacon_int;
> > +	if (WARN_ON_ONCE(cur_conf->beacon_interval == 0))
> > +		cur_conf->beacon_interval = 100;
> >  	cur_conf->dtim_period = bss_conf->dtim_period;
> >  	cur_conf->listen_interval = 1;
> >  	cur_conf->dtim_count = 1;
> > diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> > index b97217d..79c20c7 100644
> > --- a/drivers/net/wireless/ath/ath9k/recv.c
> > +++ b/drivers/net/wireless/ath/ath9k/recv.c
> > @@ -538,7 +538,8 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
> >  		sc->ps_flags &= ~PS_BEACON_SYNC;
> >  		ath_dbg(common, PS,
> >  			"Reconfigure beacon timers based on synchronized timestamp\n");
> > -		ath9k_set_beacon(sc);
> > +		if (!(WARN_ON_ONCE(sc->cur_beacon_conf.beacon_interval == 0)))
> > +			ath9k_set_beacon(sc);
> >  	}
> >  
> >  	if (ath_beacon_dtim_pending_cab(skb)) {
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
