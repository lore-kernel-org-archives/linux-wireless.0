Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:42928 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756934AbdCHGmC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 01:42:02 -0500
Subject: Re: rate mask resulting in no usable rates - WARN_ON
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <1488933811.4723.1.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <a1cd3a56-0453-7675-6895-9521a412a9cd@candelatech.com> (sfid-20170308_074303_062859_2F42C612)
Date: Tue, 7 Mar 2017 17:13:39 -0800
MIME-Version: 1.0
In-Reply-To: <1488933811.4723.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/07/2017 04:43 PM, Johannes Berg wrote:
> Ben, all,
>
> There are scenarios where setting a rate mask from userspace will
> result in no usable rates, e.g. when you set a rate mask of 6,9,12
> MBps, and the AP reports it only supports 36,48,54 (which some APs do).
> This results in a WARN_ONCE() hitting since we can't find a usable
> rate, and then we fall back to 1 or 6 MBps, which is a mandatory rate
> but the AP didn't report it as supported (is it thus misbehaving?
> doesn't matter much though)
>
> I'd go and reject a setting that results in no usable rates, but
> because the setting is sticky this is very complicated (it's a good
> thing I insisted we have very few of these, but some I couldn't get
> around).
>
> Would there be any objection to making this setting non-sticky, i.e.
> always resetting it for a new association? It's kinda designed to be
> sticky, with the per-band setting, but clearly this is causing big
> problems.
>
> Alternatively, the really proper behaviour would be for this setting to
> actually influence whether or not we can connect to the AP, but that
> will just lead to massive problems because wpa_s will be unaware and
> will pick APs that we can't support with the setting etc. Therefore I'm
> not going to do this.
>
> I could also reset the setting only when it would result in no usable
> rates, but that doesn't even give userspace any good way at all to
> predict it.
>
> Is anyone - other than ChromeOS, which sets it just after association -
> actually using this?

I know several people who use this and depend on it being sticky.  For that
matter, I think LEDE and probably OpenWRT uses 'iw' quite a bit to affect rates.   I wrote
up some patches to help make this less sticky by allowing supplicant to specify
the (V)HT rates at connect time, but I am pretty sure those were not wanted
upstream at the time.

Personally, I'd prefer to be able to specify the advertised and allowed-tx-rates
at assoc time and drive it from supplicant.

For my needs, you need both advertised (like how the station presents itself)
as well as the rateset that you want to transmit with.  That allows you to
configure your station to act like a /b station (advertise 1,2,...11Mbps), but only transmit on
1Mbps, for instance.

Nice thing about doing it in supplicant is that it has fairly good access to
the rates the AP is advertising...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
