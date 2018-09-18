Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727229AbeIRRwi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 13:52:38 -0400
Date: Tue, 18 Sep 2018 14:20:16 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] rt2x00: set registers based on current band
Message-ID: <20180918122015.GB15481@redhat.com> (sfid-20180918_142020_934964_02281C3D)
References: <1537201975-3032-1-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1537201975-3032-1-git-send-email-pozega.tomislav@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 17, 2018 at 06:32:51PM +0200, Tomislav Požega wrote:
> Use curr_band instead of rf->channel among various subroutines -
> mostly for 2.4GHz band but in some circumstances for 5GHz band too.

What is the reason for that change ?

> @@ -9265,8 +9278,9 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  	if (WARN_ON_ONCE(!spec->channels))
>  		return -ENODEV;
>  
> -	spec->supported_bands = SUPPORT_BAND_2GHZ;
> -	if (spec->num_channels > 14)
> +	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
> +		spec->supported_bands = SUPPORT_BAND_2GHZ;
> +	if (rt2x00dev->curr_band == NL80211_BAND_5GHZ)
>  		spec->supported_bands |= SUPPORT_BAND_5GHZ;
>  
>  	/*
> @@ -9336,7 +9350,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  			info[i].default_power3 = default_power3[i];
>  	}
>  
> -	if (spec->num_channels > 14) {
> +	if (rt2x00dev->curr_band == NL80211_BAND_5GHZ) {
>  		default_power1 = rt2800_eeprom_addr(rt2x00dev,
>  						    EEPROM_TXPOWER_A1);
>  		default_power2 = rt2800_eeprom_addr(rt2x00dev,

Above looks wrong.

Thanks
Stanislaw
