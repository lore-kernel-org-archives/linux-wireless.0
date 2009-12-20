Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mrs.ro ([109.74.194.28]:56528 "EHLO mrs.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbZLTWga (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2009 17:36:30 -0500
From: Valentin Manea <linux-wireless@mrs.ro>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Intel 4965 HT rates
Date: Mon, 21 Dec 2009 00:36:21 +0200
Cc: linux-wireless@vger.kernel.org
References: <200912201510.51812.linux-wireless@mrs.ro> <43e72e890912201342w2f5916d0p2b30683ccbb5dbfe@mail.gmail.com>
In-Reply-To: <43e72e890912201342w2f5916d0p2b30683ccbb5dbfe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200912210036.21895.linux-wireless@mrs.ro>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hmmm,

  Sorry, you are right, Intel describes this as a feature for the 4965. I was 
probably running a very old driver(it was before they added support for the 
5000 series), because I remember specifically the router reporting a 117Mbs 
bitrate.
I'm still trying to track down that driver as it seems quite silly to have 
this artificial limitation.

Thanks,
Valentin

On Sunday 20 December 2009 11:42:58 pm Luis R. Rodriguez wrote:
> On Sun, Dec 20, 2009 at 5:10 AM, Valentin Manea <linux-wireless@mrs.ro> 
wrote:
> > Hi,
> >
> >  I'm running compat-wireless-2.6.33-rc1 and iw list shows some confusing
> > HT capabilities:
> >        Band 1:
> >                HT capabilities: 0x082c
> >                        * 20 MHz operation
> >                        * SM PS disabled
> >                        * 20 MHz short GI
> >                        * max A-MSDU len 7935
> >
> > but for 802.11a channels:
> >        Band 2:
> >                HT capabilities: 0x086e
> >                        * 20/40 MHz operation
> >                        * SM PS disabled
> >                        * 20 MHz short GI
> >                        * 40 MHz short GI
> >                        * max A-MSDU len 7935
> >
> > While I can't tell when this happened, I remember older 2.6.29 releases
> > supported HT40 for both bands.
> 
> How do you know? What makes you believe that was the case?
> 
> > The wireless card is an Intel 4965 on a Thinkpad T61.
> 
> The ht_cap that gets parsed and sent back through nl80211 is
> initialized in iwl-agn on iwl-core.c on iwlcore_init_ht_hw_capab() as
> follows
> 
> static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
>                               struct ieee80211_sta_ht_cap *ht_info,
>                               enum ieee80211_band band)
> {
>         ....
>         if (priv->hw_params.ht40_channel & BIT(band)) {
>                 ht_info->cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
>                 ht_info->cap |= IEEE80211_HT_CAP_SGI_40;
>                 ht_info->mcs.rx_mask[4] = 0x01;
>                 max_bit_rate = MAX_BIT_RATE_40_MHZ;
>         }
>         ....
> }
> 
> And the priv->hw_params.ht40_channel gets initialized for 4965
> hardware on iwl4965_hw_set_hw_params():
> 
> static int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
> {
>         ...
>         priv->hw_params.ht40_channel = BIT(IEEE80211_BAND_5GHZ);
>         ....
> }
> 
> iwl-5000 and iwl-6000 sets this to both bands:
> 
> int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
> {
>         ....
>         priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
>                                         BIT(IEEE80211_BAND_5GHZ);
>         ....
> }
> 
> static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
> {
>         ....
>         priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
>                                         BIT(IEEE80211_BAND_5GHZ);
>         ....
> }
> 
> So it appears to be done explicitly in software, not sure if hardware
> does support HT40 on 2.4 GHz band on the 4965, Intel folks would
> though.
> 
>   Luis
> 
