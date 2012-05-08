Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34406 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab2EHHJY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 03:09:24 -0400
Received: by dady13 with SMTP id y13so2278999dad.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 00:09:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120507125316.GA25400@localhost>
References: <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>
	<1330652495-25837-10-git-send-email-dmitry.tarnyagin@stericsson.com>
	<20120507125316.GA25400@localhost>
Date: Tue, 8 May 2012 09:09:24 +0200
Message-ID: <CAMG6FYgQLexa=VAqrLmMxscef=bDyqPo6mThYAeZGqB6p5Zo_g@mail.gmail.com> (sfid-20120508_090927_604950_C17FC506)
Subject: Re: [PATCH 09/21] cw1200: txrx.*, implementation of datapath.
From: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bob,

>> +     /* minstrel is buggy a little bit, so distille
>> +      * incoming rates first. */
>
> Can you elaborate a bit on the bugs?  It may be worth fixing them
> in minstrel so that everyone benefits.  From your code it looks
> like you want to reorder them from fastest->slowest, eliminate
> duplicate rates, and change retry counts to respect total retry
> limits.  I agree that the last two are problematic and should
> probably be fixed in minstrel.
>
Yes, correct, you mentioned all the 3 problems with the minstrel.
"Buggy" is not the best word here, minstrel just behaves in this way,
and the behavior is specified. It can be changed (at least last two),
but carefully and with respect to other minstrel clients.

> Changing the rate order may have adverse affects (I'm not sure).
> Minstrel often puts 'probe' rates in early MRR slots to update
> its statistics, these may well be lower than the current rate.
>
Correct, lower rates does not have /good/ statistics - probes are
screened by higher rates. However, it is not a problem, as
verification shown. /Some/ statistics is always collected.

>> +     /* Sort rates in descending order. */
>> +     for (i = 1; i < count; ++i) {
>> +             if (rates[i].idx < 0) {
>> +                     count = i;
>> +                     break;
>> +             }
>> +             if (rates[i].idx > rates[i - 1].idx) {
>> +                     struct ieee80211_tx_rate tmp = rates[i - 1];
>> +                     rates[i - 1] = rates[i];
>> +                     rates[i] = tmp;
>> +             }
>> +     }
>
> This sort seems to be missing an inner loop.  E.g. if input was 2-3-5-4,
> I think you would end up with 2-5-4-3 instead of 5-4-3-2.
>
The algorithm is intended to eliminate one and only one out-of-order rate
from minstrel input. It will not work as a generic purpose sort.
GP-sort would be slower, but cleaner. I'm not sure what is better here.

>> +             /* ">> 1" is an equivalent of "/ 2", but faster */
>> +             int mid_rate = (rates[0].idx + 4) >> 1;
>
> (This is true, but it's only by a couple of instructions for signed
> division since compilers still change divide-by-power-of-two to shifts.
>
As I remember compiler changes divide to a shift only for
unsigned divisions, isn't it? Or do modern gcc-s changes it for signed
divs as well?

> Unsigned /2 typically has the same code as >> 1.  I tend to prefer /2
> for readability unless it's a super hot path, but that's your call.)
>
Well, it's datapath. This code is executed for every SDU in data traffic,
with frequency ~3kHz on target throughput. For me it's a good reason
to explicitly eliminate divisions :)

--
Dmitry Tarnyagin
