Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:27737 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187AbZHUNaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 09:30:30 -0400
Received: by fg-out-1718.google.com with SMTP id e21so178757fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2009 06:30:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250842695.13872.5.camel@johannes.local>
References: <4A8DED03.2050502@cs.ucla.edu> <1250842695.13872.5.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 21 Aug 2009 15:30:11 +0200
Message-ID: <69e28c910908210630m47eda1eegcd502c212736decd@mail.gmail.com>
Subject: Re: [PATCH] Implementation of the IEEE80211_RADIOTAP_RATE option
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rafael Laufer <rlaufer@cs.ucla.edu>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 21, 2009 at 10:18 AM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Thu, 2009-08-20 at 17:40 -0700, Rafael Laufer wrote:
>> This patch implements the IEEE80211_RADIOTAP_RATE
>> option when parsing radiotap headers to allow rate
>> selection on a per-packet basis.
>>
>>
>> Signed-off-by: Rafael Laufer <rlaufer@cs.ucla.edu>
>> ---
>>  Implementation of the IEEE80211_RADIOTAP_RATE
>>  option when parsing radiotap headers to allow
>>  rate selection on a per-packet basis.
>>
>>  net/mac80211/tx.c |   18 +++++++++++++++++-
>>  1 files changed, 17 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
>> index 10a1099..41d636b 100644
>> --- a/net/mac80211/tx.c
>> +++ b/net/mac80211/tx.c
>> @@ -549,7 +549,10 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
>>        * If we're associated with the sta at this point we know we can at
>>        * least send the frame at the lowest bit rate.
>>        */
>> -     rate_control_get_rate(tx->sdata, tx->sta, &txrc);
>> +
>> +     /* in monitor mode, we already have the rate from the radiotap header */
>> +     if (likely(!(info->flags & IEEE80211_TX_CTL_INJECTED)))
>> +             rate_control_get_rate(tx->sdata, tx->sta, &txrc);
>
> NAK, the rate is optional in the radiotap header, and if not given then
> regular rate control must be used.
>
> johannes
>

Also, I think something more powerful than the current "rate" field
would be needed, with support for MCS indexes, channel width, retry
count, etc. - one that can configure all values rate_control_get_rate
would perform. I'm planning a Radiotap meeting on Freenode with the
radiotap.h maintainers in various OSes participating, so the field 14+
mess can be cleaned up once for all - that's when I'll probably
propose this field.

Maybe a new IEEE80211_TX_CTL_ or IEEE80211_TX_RC_ flag will also be
needed, so Radiotap can indicate whether rate_control_get_rate needs
to be called.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
