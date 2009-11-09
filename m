Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:35374 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbZKIT7r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 14:59:47 -0500
Received: by iwn10 with SMTP id 10so2661501iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 11:59:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4f6ba3b0911091037x4b18177cs3319f56feae42c8b@mail.gmail.com>
References: <1257791082-4126-1-git-send-email-lrodriguez@atheros.com>
	<4f6ba3b0911091037x4b18177cs3319f56feae42c8b@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 9 Nov 2009 11:59:33 -0800
Message-ID: <43e72e890911091159i4cf11970lf7dc167397c68c08@mail.gmail.com>
Subject: Re: [PATCH] mac80211: make HT bogus rate warning more verbose
To: Bob Beers <bob.beers@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 9, 2009 at 10:37 AM, Bob Beers <bob.beers@gmail.com> wrote:
> On Mon, Nov 9, 2009 at 1:24 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> This will help debug an issue when the driver is passing up
>> a bogus HT rate value. The rate must map to a valid MCS index
>> which can be any of the values 0 - 76.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  net/mac80211/rx.c |   18 +++++++++++++++---
>>  1 files changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
>> index 28316b2..5b26d34 100644
>> --- a/net/mac80211/rx.c
>> +++ b/net/mac80211/rx.c
>> @@ -2425,9 +2425,21 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
>>                goto drop;
>>
>>        if (status->flag & RX_FLAG_HT) {
>> -               /* rate_idx is MCS index */
>> -               if (WARN_ON(status->rate_idx < 0 ||
>> -                           status->rate_idx >= 76))
>> +               /*
>> +                * rate_idx is MCS index, which can be 0-76 as documented on:
>> +                *
>> +                * http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11n
>> +                *
>> +                * Anything else would be some sort of driver or hardware error.
>> +                * The driver should catch hardware errors.
>> +                */
>> +               if (WARN((status->rate_idx < 0 ||
>> +                        status->rate_idx >= 76),
>
> If 76 is valid value as indicated in comment above: 0-76,
>  shouldn't this be
>
> +                        status->rate_idx > 76),
>
> ??

Indeed, good catch. I'll fix it in a v2 patch.

  Luis
