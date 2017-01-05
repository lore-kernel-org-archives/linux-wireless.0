Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49216 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S970630AbdAELvG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 06:51:06 -0500
Message-ID: <1483617050.4394.12.camel@sipsolutions.net> (sfid-20170105_125121_593519_500B91F1)
Subject: Re: [PATCH V5 3/3] cfg80211: support ieee80211-freq-limit DT
 property
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Date: Thu, 05 Jan 2017 12:50:50 +0100
In-Reply-To: <CACna6ryzk958T0by_4F96hJxUCR5VsKJjrsjByFO96+HcfmXqg@mail.gmail.com> (sfid-20170104_171308_807288_97C21013)
References: <20170103225715.14072-1-zajec5@gmail.com>
         <20170103225715.14072-3-zajec5@gmail.com>
         <1483536406.7312.3.camel@sipsolutions.net>
         <CACna6ryzk958T0by_4F96hJxUCR5VsKJjrsjByFO96+HcfmXqg@mail.gmail.com>
         (sfid-20170104_171308_807288_97C21013)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > But just setting orig_flags also won't work, since it'd be
> > overwritten again by wiphy_register(), no?
> 
> I told you I successfully tested it, didn't I? Well, I quickly
> checked wiphy_register and couldn't understand how it was possible it
> worked for me...

I guess I didn't believe it ;-)

> OK, so after some debugging I understood why I got this working. It's
> the way brcmfmac handles channels.
> 
> At the beginning all channels are disabled: see __wl_2ghz_channels &
> __wl_5ghz_channels. They have IEEE80211_CHAN_DISABLED set in "flags"
> for every channel.
> 
> In early phase brcmfmac calls wiphy_read_of_freq_limits which sets
> IEEE80211_CHAN_DISABLED in "orig_flags" for unavailable channels.
> 
> Then brcmf_construct_chaninfo kicks in. Normally it removes
> IEEE80211_CHAN_DISABLED from "flags" for most of channels, but it
> doesn't happen anymore due to my change:
> if (channel->orig_flags & IEEE80211_CHAN_DISABLED)
>         continue;
> 
> Then brcmfmac calls wiphy_apply_custom_regulatory which sets some
> bits like IEEE80211_CHAN_NO_80MHZ and IEEE80211_CHAN_NO_160MHZ in
> "flags".
> 
> Finally wiphy_register is called which copies "flags" to
> "original_flags". As brcmfmac /respected/ IEEE80211_CHAN_DISABLED set
> in orig_flags, it also left IEEE80211_CHAN_DISABLED in flags. This
> way I got IEEE80211_CHAN_DISABLED in orig_flags after overwriting
> that field inside wiphy_register.
> 
> That's quite crazy, right?

Yeah, that was pretty crazy.

> I guess you're right after all, I should set IEEE80211_CHAN_DISABLED
> in "flags" field, let wiphy_register copy that to "orig_flags" and
> sanitize brcmfmac.

Makes sense to me. That would also match the way it works when no
custom regulatory notifier is used, which makes the OF function more
widely applicable.

Thanks,
johannes
