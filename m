Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:42253 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab1GNTU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 15:20:57 -0400
Received: by wwg11 with SMTP id 11so779116wwg.1
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 12:20:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1310637144.3874.2.camel@jlt3.sipsolutions.net>
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	<1310600747-9583-6-git-send-email-thomas@cozybit.com>
	<1310637144.3874.2.camel@jlt3.sipsolutions.net>
Date: Thu, 14 Jul 2011 12:20:55 -0700
Message-ID: <CAG6hwVN3eeJw+H8xt9BpV1t6_ujVdsS_Q6xPk7q-wF5+5sUd=A@mail.gmail.com> (sfid-20110714_212100_399233_966A9407)
Subject: Re: [PATCH 5/5] mac80211: mesh beacon includes TIM IE
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 14, 2011 at 2:52 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2011-07-13 at 16:45 -0700, Thomas Pedersen wrote:
>
>>                       goto out;
>> @@ -2269,6 +2270,14 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
>>                       memcpy(skb_put(skb, beacon->head_len), beacon->head,
>>                              beacon->head_len);
>>
>> +                     pos = skb_put(skb, 6);
>
> You just keep adding here -- how is the length of the skb determined?

A little further up:

                        /* headroom, head length, tail length, custom IEs, and
                         * mesh IEs + maximum TIM length */
                        skb = dev_alloc_skb(local->tx_headroom +
                                            beacon->head_len +
                                            beacon->tail_len +
                                            ifmsh->ie_len + 400);

we made room for the max TIM element.
>
> johannes
>
>
