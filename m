Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47648 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab1GNUQm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 16:16:42 -0400
Received: by wwe5 with SMTP id 5so683965wwe.1
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 13:16:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110714062522.GA2534@jm.kir.nu>
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	<1310600747-9583-6-git-send-email-thomas@cozybit.com>
	<20110714062522.GA2534@jm.kir.nu>
Date: Thu, 14 Jul 2011 13:16:41 -0700
Message-ID: <CAG6hwVN3HED+LZdKN0zpNfjmK9FmBuBWnZ0qe9gYTPPYmCedTg@mail.gmail.com> (sfid-20110714_221646_251107_E32FE07D)
Subject: Re: [PATCH 5/5] mac80211: mesh beacon includes TIM IE
From: Thomas Pedersen <thomas@cozybit.com>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 13, 2011 at 11:25 PM, Jouni Malinen <j@w1.fi> wrote:
> On Wed, Jul 13, 2011 at 04:45:47PM -0700, Thomas Pedersen wrote:
>> Even though we don't currently implement PS for mesh points, the
>> standard asks us to include a TIM element in beacons. Include an empty
>> element for now.
>
> Is it allowed to not support PS in this type of case? AP does not have
> such option..
>

You're right, it doesn't look like PS support is optional. The
standard requires us to respect the PS states of peers. Support for
this will require some work, but in the meantime, we can include a TIM
element indicating no frames buffered here, as well as a Mesh Awake
Window which never expires.

Otherwise, until we implement proper PS, might it be better not to
include the TIM IE at all?

>> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
>> @@ -2269,6 +2270,14 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
>> +                     pos = skb_put(skb, 6);
>> +                     *pos++ = WLAN_EID_TIM;
>> +                     *pos++ = 4;
>> +                     *pos++ = 0;     /* DTIM count */
>> +                     *pos++ = 0;     /* DTIM period */
>
> The DTIM Period value 0 is reserved and does not really make much
> sense.. Would it be better to set this to 1?

That makes sense, thanks!

>
> --
> Jouni Malinen                                            PGP id EFC895FA
>
