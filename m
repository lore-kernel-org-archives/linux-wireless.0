Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:65325 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbZEPNln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2009 09:41:43 -0400
Received: by ey-out-2122.google.com with SMTP id 9so747349eyd.37
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2009 06:41:43 -0700 (PDT)
Message-ID: <4A0EC5A6.1050702@gmail.com>
Date: Sat, 16 May 2009 14:54:46 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Subject: Re: [RFC 3/3] orinoco: initiate cfg80211 conversion
References: <1242476577-26320-1-git-send-email-kilroyd@googlemail.com>	 <1242476577-26320-4-git-send-email-kilroyd@googlemail.com> <1242477960.10005.60.camel@johannes.local>
In-Reply-To: <1242477960.10005.60.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2009-05-16 at 13:22 +0100, David Kilroy wrote:
>> +/* Supported bitrates. Must agree with hw.c
>> + * TODO: are the flags correct? */
>> +static const struct ieee80211_rate orinoco_rates[] = {
>> +	{ .bitrate = 10 },
>> +	{ .bitrate = 20, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
>> +	{ .bitrate = 55, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
>> +	{ .bitrate = 110, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
>> +};
> 
> Flags look fine from a protocol POV, I don't know whether your hw
> supports short preamble. On the other hand, this is only reported to
> userspace, we don't do anything with it in cfg80211.

I thought that might be the case. I think I'll remove the flags, as
there's some code that indicates only some of the cards support short
preamble.

>> +	memcpy(priv->rates, orinoco_rates, sizeof(orinoco_rates));
>> +	priv->band.bitrates = priv->rates;
>> +	priv->band.n_bitrates = ARRAY_SIZE(orinoco_rates);
> 
> Is there a need to copy the rates? Normally you should be able to just
> do
> 	priv->band.bitrates = orinoco_rates;

I just copied what rndis was doing. I'll do as you recommend.

> When do you load firmware? We try to only load it when the first
> interface is brought up, but that's sometimes problematic because then
> we don't have enough information.

Firmware is loaded when netdev calls ndo_init. I think netdev is
registerred by the hardware modules (airport, _cs etc) shortly after
allocating orinoco_priv.

>> +	/* allocate wiphy
>> +	 * NOTE: We only support a single virtual interface, so wiphy
>> +	 * and wireless_dev are somewhat synonymous for this device.
>> +	 */
>> +	wiphy = wiphy_new(&orinoco_cfg_ops,
>> +			  sizeof(struct orinoco_private *));
>> +	if (!wiphy)
>> +		return NULL;
> 
> You could with little effort, support virtual monitor interfaces by just
> passing all frames the firmware gives you to those. Probably not worth
> bothering with though.

Yep. I'll look at supporting monitor interfaces later on.

> Other notes:
>  * you could easily migrate over orinoco_ioctl_setmode/getmode
>  * if we improve the cfg80211 iwrange implementation a little
>    and you register which ciphers you support, you can migrate
>    over orinoco_ioctl_getiwrange
>  * iwencode(ext) should be fairly easy too
>  * just get rid of iwnick
>  * rts/frag/retry should be easy to migrate
>  * what are ibss ports?
>  * scan should be easy to port too
>  * iwpriv isn't supported by cfg80211

Yep. I wanted to get the structure layout right before tackling those.

Hermes has different types of 'ports'. We configure the port as either
type 1 or type 3. In addition the port can have what seems to be an ibss
attribute, which allows us to do IEEE ad-hoc. Apparently type 3 allows
us to do a demo ad-hoc mode. Different firmwares need to use different
port settings for different modes of operation (see determine_firmware).

> Anyway looks good for a start, though I would maybe build the structures
> a little different and not put the wdev into priv since priv is per
> hardware.
> 
> Generally the layout I recommend would be like this:
> 
> +-------------+
> |  wiphy      |
> +-------------+
> |  priv       |  == wiphy_priv()
> +-------------+
> 
> and
> 
> +-------------+
> |  netdev     |
> +-------------+
> |  wdev       |  == netdev_priv()
> +-------------+
> 
> For you it doesn't really matter since you can only have one virtual
> interface (well in monitor mode you could have multiple but that seems
> pointless) -- it's still more in line with what other drivers are doing
> though.

That makes a bit more sense. I'll try restructure things this way to be
consistent.


Thanks for the feedback!


Dave.
