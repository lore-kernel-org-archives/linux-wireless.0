Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37882 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbcAGGRg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 01:17:36 -0500
Received: by mail-wm0-f41.google.com with SMTP id f206so106958624wmf.0
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2016 22:17:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1452077048.2541.5.camel@sipsolutions.net>
References: <1451990134-15183-1-git-send-email-janusz.dziedzic@tieto.com>
	<1452077048.2541.5.camel@sipsolutions.net>
Date: Thu, 7 Jan 2016 07:17:35 +0100
Message-ID: <CALhHN=rO7477CNLA6+rE_y0UjL=kx9W0SxaQn-xFY+A=GMTSRQ@mail.gmail.com> (sfid-20160107_071740_869530_47A50DCC)
Subject: Re: [PATCH v2 1/2] mac80211: check requested flags in ieee80211_tx_prepare_skb()
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 January 2016 at 11:44, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2016-01-05 at 11:35 +0100, Janusz Dziedzic wrote:
>> In case driver already set info->flags (eg.
>> IEEE80211_TX_CTL_NO_CCK_RATE
>> in ath9k driver), before this patch we skip this requested flags.
>
> I don't see how we "skip" them?
>
>> +     unsigned int flags = info->flags;
>>
>>       if (ieee80211_tx_prepare(sdata, &tx, NULL, skb) == TX_DROP)
>>               return false;
>>
>>       info->band = band;
>>       info->control.vif = vif;
>>       info->hw_queue = vif->hw_queue[skb_get_queue_mapping(skb)];
>> +     info->flags |= flags;
>
> tx_prepare() doesn't [seem to] do anything to the flags but twiddle a
> few, so ?
>
Yes, you right - this patch is not needed.
Thanks.

BR
Janusz
