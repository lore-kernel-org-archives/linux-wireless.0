Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:35352 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaAQHLf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 02:11:35 -0500
Received: by mail-ob0-f173.google.com with SMTP id vb8so3939882obc.32
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 23:11:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389939896.8062.53.camel@porter.coelho.fi>
References: <a8aa052ea196de8256dcdc5b3ae81cfa64d3f9ff.1389935084.git.gamerh2o@gmail.com>
	<1389939896.8062.53.camel@porter.coelho.fi>
Date: Fri, 17 Jan 2014 08:11:34 +0100
Message-ID: <CACna6rzkKGxBxReQJ0Y=TscY8GJ+r=S+6Cs+g+B0=7k1FFxW2w@mail.gmail.com> (sfid-20140117_081139_505666_4EA379B4)
Subject: Re: [PATCH 1/2] b43: fix the wrong assignment of status.freq in b43_rx()
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Luca Coelho <luca@coelho.fi>
Cc: ZHAO Gang <gamerh2o@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014/1/17 Luca Coelho <luca@coelho.fi>:
> On Fri, 2014-01-17 at 13:27 +0800, ZHAO Gang wrote:
>> In following patch, replace b43 specific helper function with kernel
>> api to reduce code duplication.
>>
>> Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
>> ---
>>  drivers/net/wireless/b43/xmit.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
>> index 4ae63f4..50e5ddb 100644
>> --- a/drivers/net/wireless/b43/xmit.c
>> +++ b/drivers/net/wireless/b43/xmit.c
>> @@ -821,10 +821,10 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
>>                * channel number in b43. */
>>               if (chanstat & B43_RX_CHAN_5GHZ) {
>>                       status.band = IEEE80211_BAND_5GHZ;
>> -                     status.freq = b43_freq_to_channel_5ghz(chanid);
>> +                     status.freq = b43_channel_to_freq_5ghz(chanid);
>>               } else {
>>                       status.band = IEEE80211_BAND_2GHZ;
>> -                     status.freq = b43_freq_to_channel_2ghz(chanid);
>> +                     status.freq = b43_channel_to_freq_2ghz(chanid);
>>               }
>>               break;
>>       default:
>
> Why do you need this patch if you're going to remove these calls in the
> next patch anyway?

I was thinking about this for a moment too. You could just make a one
patch and note in commit message that "translation" was reversed.
