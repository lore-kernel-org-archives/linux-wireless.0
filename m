Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 0.mx.nanl.de ([217.115.11.12]:45975 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbaAQJGz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 04:06:55 -0500
Received: from mail-qc0-f172.google.com (mail-qc0-f172.google.com [209.85.216.172])
	by mail.nanl.de (Postfix) with ESMTPSA id E5C5F4607D
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 08:55:33 +0000 (UTC)
Received: by mail-qc0-f172.google.com with SMTP id c9so3315322qcz.17
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 00:57:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACna6rzkKGxBxReQJ0Y=TscY8GJ+r=S+6Cs+g+B0=7k1FFxW2w@mail.gmail.com>
References: <a8aa052ea196de8256dcdc5b3ae81cfa64d3f9ff.1389935084.git.gamerh2o@gmail.com>
 <1389939896.8062.53.camel@porter.coelho.fi> <CACna6rzkKGxBxReQJ0Y=TscY8GJ+r=S+6Cs+g+B0=7k1FFxW2w@mail.gmail.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Fri, 17 Jan 2014 09:56:45 +0100
Message-ID: <CAOiHx=nui0nVGiCLoukRovB3zY5jiKAt__Numo4y4bQv0dzOcQ@mail.gmail.com> (sfid-20140117_100701_833535_9D0B5332)
Subject: Re: [PATCH 1/2] b43: fix the wrong assignment of status.freq in b43_rx()
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Luca Coelho <luca@coelho.fi>, ZHAO Gang <gamerh2o@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 17, 2014 at 8:11 AM, Rafał Miłecki <zajec5@gmail.com> wrote:
> 2014/1/17 Luca Coelho <luca@coelho.fi>:
>> On Fri, 2014-01-17 at 13:27 +0800, ZHAO Gang wrote:
>>> In following patch, replace b43 specific helper function with kernel
>>> api to reduce code duplication.
>>>
>>> Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
>>> ---
>>>  drivers/net/wireless/b43/xmit.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
>>> index 4ae63f4..50e5ddb 100644
>>> --- a/drivers/net/wireless/b43/xmit.c
>>> +++ b/drivers/net/wireless/b43/xmit.c
>>> @@ -821,10 +821,10 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
>>>                * channel number in b43. */
>>>               if (chanstat & B43_RX_CHAN_5GHZ) {
>>>                       status.band = IEEE80211_BAND_5GHZ;
>>> -                     status.freq = b43_freq_to_channel_5ghz(chanid);
>>> +                     status.freq = b43_channel_to_freq_5ghz(chanid);
>>>               } else {
>>>                       status.band = IEEE80211_BAND_2GHZ;
>>> -                     status.freq = b43_freq_to_channel_2ghz(chanid);
>>> +                     status.freq = b43_channel_to_freq_2ghz(chanid);
>>>               }
>>>               break;
>>>       default:
>>
>> Why do you need this patch if you're going to remove these calls in the
>> next patch anyway?
>
> I was thinking about this for a moment too. You could just make a one
> patch and note in commit message that "translation" was reversed.

That would mean mixing fixes and improvements, which is something you
are not supposed to do, so IMHO having these split into two is
correct. Think about stable maintainers wanting the fix but not the
other change because it might introduce unknown side effects.


Jonas
>
> _______________________________________________
> b43-dev mailing list
> b43-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/b43-dev
