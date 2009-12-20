Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:35611 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbZLTVnS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2009 16:43:18 -0500
Received: by iwn1 with SMTP id 1so3289436iwn.33
        for <linux-wireless@vger.kernel.org>; Sun, 20 Dec 2009 13:43:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200912201510.51812.linux-wireless@mrs.ro>
References: <200912201510.51812.linux-wireless@mrs.ro>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 20 Dec 2009 13:42:58 -0800
Message-ID: <43e72e890912201342w2f5916d0p2b30683ccbb5dbfe@mail.gmail.com>
Subject: Re: Intel 4965 HT rates
To: Valentin Manea <linux-wireless@mrs.ro>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 20, 2009 at 5:10 AM, Valentin Manea <linux-wireless@mrs.ro> wrote:
> Hi,
>
>  I'm running compat-wireless-2.6.33-rc1 and iw list shows some confusing HT
> capabilities:
>        Band 1:
>                HT capabilities: 0x082c
>                        * 20 MHz operation
>                        * SM PS disabled
>                        * 20 MHz short GI
>                        * max A-MSDU len 7935
>
> but for 802.11a channels:
>        Band 2:
>                HT capabilities: 0x086e
>                        * 20/40 MHz operation
>                        * SM PS disabled
>                        * 20 MHz short GI
>                        * 40 MHz short GI
>                        * max A-MSDU len 7935
>
> While I can't tell when this happened, I remember older 2.6.29 releases
> supported HT40 for both bands.

How do you know? What makes you believe that was the case?

> The wireless card is an Intel 4965 on a Thinkpad T61.

The ht_cap that gets parsed and sent back through nl80211 is
initialized in iwl-agn on iwl-core.c on iwlcore_init_ht_hw_capab() as
follows

static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
                              struct ieee80211_sta_ht_cap *ht_info,
                              enum ieee80211_band band)
{
        ....
        if (priv->hw_params.ht40_channel & BIT(band)) {
                ht_info->cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
                ht_info->cap |= IEEE80211_HT_CAP_SGI_40;
                ht_info->mcs.rx_mask[4] = 0x01;
                max_bit_rate = MAX_BIT_RATE_40_MHZ;
        }
        ....
}

And the priv->hw_params.ht40_channel gets initialized for 4965
hardware on iwl4965_hw_set_hw_params():

static int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
{
        ...
        priv->hw_params.ht40_channel = BIT(IEEE80211_BAND_5GHZ);
        ....
}

iwl-5000 and iwl-6000 sets this to both bands:

int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
{
        ....
        priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
                                        BIT(IEEE80211_BAND_5GHZ);
        ....
}

static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
{
        ....
        priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
                                        BIT(IEEE80211_BAND_5GHZ);
        ....
}

So it appears to be done explicitly in software, not sure if hardware
does support HT40 on 2.4 GHz band on the 4965, Intel folks would
though.

  Luis
