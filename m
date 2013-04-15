Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:64701 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100Ab3DOMiF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 08:38:05 -0400
Received: by mail-wi0-f169.google.com with SMTP id c10so1529105wiw.2
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2013 05:38:04 -0700 (PDT)
Date: Mon, 15 Apr 2013 14:33:58 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: vht off-by-one nss
Message-ID: <20130415123358.GA13843@magnum.frso.rivierawaves.com> (sfid-20130415_143810_758336_1E916D2A)
References: <20130415100909.GA29924@magnum.frso.rivierawaves.com>
 <1366021975.8361.10.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1366021975.8361.10.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 15, 2013 at 12:32:55PM +0200, Johannes Berg wrote:
> On Mon, 2013-04-15 at 12:09 +0200, Karl Beldan wrote:
> > It seems to me we have to perform one of the following, otherwise one
> > driver may set negative rate indexes and iw et.al will report VHT NSSes
> > starting at 0.
> 
> Hmm, yeah, this does seem inconsistent.
> 
> > {
> > diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> > index 0dde213..2317ca9 100644
> > --- a/include/net/mac80211.h
> > +++ b/include/net/mac80211.h
> > @@ -601,8 +601,8 @@ static inline void ieee80211_rate_set_vht(struct ieee80211_tx_rate *rate,
> >  					  u8 mcs, u8 nss)
> >  {
> >  	WARN_ON(mcs & ~0xF);
> > -	WARN_ON(nss & ~0x7);
> > -	rate->idx = (nss << 4) | mcs;
> > +	WARN_ON((nss - 1) & ~0x7);
> > +	rate->idx = ((nss - 1) << 4) | mcs;
> >  }
> >  
> >  static inline u8
> > @@ -614,7 +614,7 @@ ieee80211_rate_get_vht_mcs(const struct ieee80211_tx_rate *rate)
> >  static inline u8
> >  ieee80211_rate_get_vht_nss(const struct ieee80211_tx_rate *rate)
> >  {
> > -	return rate->idx >> 4;
> > +	return (rate->idx >> 4) + 1;
> >  }
> >  
> >  /**
> > }
> 
> I think this is nicer? But it should probably have some comments.
> 
This is what I prefer too.
Ok, I'll send a patch then.


> > diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
> > index 56df249..9631391 100644
> > --- a/drivers/net/wireless/iwlwifi/mvm/tx.c
> > +++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
> > @@ -545,7 +545,7 @@ static void iwl_mvm_hwrate_to_tx_control(u32 rate_n_flags,
> >  		ieee80211_rate_set_vht(
> >  			r, rate_n_flags & RATE_VHT_MCS_RATE_CODE_MSK,
> >  			((rate_n_flags & RATE_VHT_MCS_NSS_MSK) >>
> > -						RATE_VHT_MCS_NSS_POS) + 1);
> > +						RATE_VHT_MCS_NSS_POS));
> >  		r->flags |= IEEE80211_TX_RC_VHT_MCS;
> >  	} else {
> >  		r->idx = iwl_mvm_legacy_rate_to_mac80211_idx(rate_n_flags,
> > diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> > index fdd95bd..358d93c 100644
> > --- a/net/mac80211/cfg.c
> > +++ b/net/mac80211/cfg.c
> > @@ -389,7 +389,7 @@ void sta_set_rate_info_tx(struct sta_info *sta,
> >  	} else if (rate->flags & IEEE80211_TX_RC_VHT_MCS) {
> >  		rinfo->flags |= RATE_INFO_FLAGS_VHT_MCS;
> >  		rinfo->mcs = ieee80211_rate_get_vht_mcs(rate);
> > -		rinfo->nss = ieee80211_rate_get_vht_nss(rate);
> > +		rinfo->nss = ieee80211_rate_get_vht_nss(rate) + 1;
> >  	} else {
> >  		struct ieee80211_supported_band *sband;
> >  		sband = sta->local->hw.wiphy->bands[
> > }
> 
> 
> Wouldn't this one also require an update for VHT radiotap in
> net/mac80211/rx.c around line 320 (RX_FLAG_VHT)?
> 
The radiotap field is set with ieee80211_rx_status.vht_nss, so no need.

 
Karl
