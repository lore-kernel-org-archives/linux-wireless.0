Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:40850 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbZG3PnT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 11:43:19 -0400
Received: by gxk9 with SMTP id 9so2769885gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 08:43:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248940662.8925.6.camel@johannes.local>
References: <1248915719-6208-1-git-send-email-lrodriguez@atheros.com>
	<1248940662.8925.6.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 30 Jul 2009 08:42:59 -0700
Message-ID: <43e72e890907300842l12609fdatd0ac8128b705b4a9@mail.gmail.com>
Subject: Re: [RFT] cfg80211: enable country IE support to all cfg80211 drivers
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 30, 2009 at 12:57 AM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Wed, 2009-07-29 at 18:01 -0700, Luis R. Rodriguez wrote:
>> Since the bss is always set now once we are connected, if the
>> bss has its own information element we refer to it and pass that
>> instead of relying on mac80211's parsing.
>>
>> Now all cfg80211 drivers get country IE support, automatically.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>
>> Johill, I think this is what you wanted in the end, I tested it and
>> I get no country IE hint going through :( I could debug further but I'm
>> done for now and gotta work on some other stuff, not sure when I can
>> get back to this.
>
> Well, you've made a critical mistake:
>
> +       regulatory_hint_11d(wdev->wiphy,
> +                           bss->information_elements,
> +                           bss->len_information_elements);
>
> needs to be
>
>        const u8 *country_ie
>
>        country_ie = ieee80211_bss_get_ie(&bss->pub, WLAN_EID_COUNTRY);
>        if (country_ie)
>                regulatory_hint_11d(wdev->wiphy,
>                                    country_ie + 2,
>                                    country_ie[1]);
>
>
> It's rather likely that it doesn't come first, so whatever is in
> information_elements first would end up not looking like a country IE or
> having the right length, so the _11d function would just throw it out.

Hah, thanks, will try it.

  Luis
