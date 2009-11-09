Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:44845 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbZKIRPI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 12:15:08 -0500
Received: by bwz27 with SMTP id 27so3685794bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 09:15:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1257785423.29454.177.camel@johannes.local>
References: <f74418680911090807g4e83a15cr2ce21ea21a86ea23@mail.gmail.com>
	<1257785423.29454.177.camel@johannes.local>
From: Matteo Croce <technoboy85@gmail.com>
Date: Mon, 9 Nov 2009 18:14:50 +0100
Message-ID: <40101cc30911090914qa641306x9901604c088b38e2@mail.gmail.com>
Subject: Re: [PATCH]: setting bit-rate when injecting
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 9, 2009 at 5:50 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>>       sband = tx->local->hw.wiphy->bands[tx->channel->band];
>>
>> @@ -979,6 +984,25 @@
>>                               tx->flags |= IEEE80211_TX_FRAGMENTED;
>>                       break;
>>
>> +             case IEEE80211_RADIOTAP_RATE:
>> +                     rates = sband->bitrates;
>> +                     for (i = 0; i < sband->n_bitrates; i++) {
>> +                             if (rates[i].bitrate/5 == *iterator.this_arg) {
>> +                                     info->control.rates[0].idx = i;
>> +                                     break;
>> +                             }
>> +                     }
>> +                     info->control.rates[0].flags = 0;
>
> This leaves the number of retries at ... 0. That makes no sense. What
> driver are you using that this actually works with?!

Oh no, the retries are set in the IEEE80211_RADIOTAP_DATA_RETRIES case,
parsed from the radiotap header
