Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:33026 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933822AbdBVXH5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Feb 2017 18:07:57 -0500
Received: by mail-qk0-f195.google.com with SMTP id x71so2622556qkb.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Feb 2017 15:06:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170222213057.GA33925@ubuntu-hedt>
References: <20170218063515.16071-1-ryan@mounce.com.au> <20170222213057.GA33925@ubuntu-hedt>
From: Ryan Mounce <ryan@mounce.com.au>
Date: Thu, 23 Feb 2017 09:35:53 +1030
Message-ID: <CAN+fvRb8R_3QyrnFFp0gd8PCcFXwbitNyh8K=ONqbmsGTrBsHQ@mail.gmail.com> (sfid-20170223_001058_739420_4AD8E69A)
Subject: Re: [PATCH] wireless-regdb: Update rules for Australia (AU) and add
 60GHz rules
To: Seth Forshee <seth.forshee@canonical.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 February 2017 at 08:00, Seth Forshee <seth.forshee@canonical.com> wrote:
> On Sat, Feb 18, 2017 at 05:05:15PM +1030, Ryan Mounce wrote:
>> Sourced from the latest legislation at
>> https://www.legislation.gov.au/Details/F2016C0043
>
> This link isn't working for me.

Oops, I truncated that URL. Working link (also in the patch itself):
https://www.legislation.gov.au/Details/F2016C00432

>> The current rules exceed legal limits between 5250-5330MHz, and permit
>> illegal operation in 5600-5650MHz (reserved for weather radar).
>
> The changes also increases the limits for most other ranges, by quite a
> bit in some cases. Seems that this should also be mentioned in the
> changelog, and I'd like to be able to check those changes against the
> documentation.

All of the updated power limits are converted to dBm but otherwise
straight out of the document, so they shouldn't be a problem. I'll
update the changelog to note this.

The frequency ranges have been "rounded down" to conform with the
apparent convention of only including ranges used by standard 802.11
channels, rather than using the actual frequency ranges as has been
done for some countries (and most 60GHz rules). My preference is the
latter so that there is a clear correlation between the regdb and
relevant documentation, and so that the regdb may become useful beyond
802.11. With your blessing as maintainer I will also make this change
to the patch.

Regards,
Ryan Mounce

> Thanks,
> Seth
>
>>
>> Signed-off-by: Ryan Mounce <ryan@mounce.com.au>
>> ---
>>  db.txt | 15 ++++++++++-----
>>  1 file changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/db.txt b/db.txt
>> index 05108e0..b951e0c 100644
>> --- a/db.txt
>> +++ b/db.txt
>> @@ -85,12 +85,17 @@ country AT: DFS-ETSI
>>       # 60 GHz band channels 1-4, ref: Etsi En 302 567
>>       (57000 - 66000 @ 2160), (40)
>>
>> +# Source:
>> +# https://www.legislation.gov.au/Details/F2016C00432
>> +# Both DFS-ETSI and DFS-FCC are acceptable per AS/NZS 4268 Appendix B
>>  country AU: DFS-ETSI
>> -     (2402 - 2482 @ 40), (20)
>> -     (5170 - 5250 @ 80), (17), AUTO-BW
>> -     (5250 - 5330 @ 80), (24), DFS, AUTO-BW
>> -     (5490 - 5710 @ 160), (24), DFS
>> -     (5735 - 5835 @ 80), (30)
>> +     (2402 - 2482 @ 40), (36)
>> +     (5170 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW
>> +     (5250 - 5330 @ 80), (23), NO-OUTDOOR, AUTO-BW, DFS
>> +     (5490 - 5590 @ 80), (30), DFS
>> +     (5650 - 5730 @ 80), (30), DFS
>> +     (5735 - 5835 @ 80), (36)
>> +     (57000 - 66000 @ 2160), (43), NO-OUTDOOR
>>
>>  country AW: DFS-ETSI
>>       (2402 - 2482 @ 40), (20)
>> --
>> 2.11.0
>>
