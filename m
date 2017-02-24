Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:36537 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbdBXCun (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 21:50:43 -0500
Received: by mail-qk0-f194.google.com with SMTP id r90so1331990qki.3
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2017 18:50:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170223153532.GA3479@ubuntu-hedt>
References: <20170223130142.GA90803@ubuntu-hedt> <20170223135253.1681-1-ryan@mounce.com.au>
 <20170223153532.GA3479@ubuntu-hedt>
From: Ryan Mounce <ryan@mounce.com.au>
Date: Fri, 24 Feb 2017 13:20:24 +1030
Message-ID: <CAN+fvRYhW4hhHfyzvE8uJZ+qu8hneUni_je=3kdNe+bPa+WQxA@mail.gmail.com> (sfid-20170224_035047_561919_1E1FD992)
Subject: Re: [PATCH v2] wireless-regdb: Update rules for Australia (AU) and
 add 60GHz rules
To: Seth Forshee <seth.forshee@canonical.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 February 2017 at 02:05, Seth Forshee <seth.forshee@canonical.com> wrote:
> On Fri, Feb 24, 2017 at 12:22:53AM +1030, Ryan Mounce wrote:
>> Sourced from the current legislation at
>> https://www.legislation.gov.au/Details/F2016C00432
>>
>> The current rules exceed legal limits between 5250-5330MHz, and permit
>> illegal operation in 5600-5650MHz (disallowed regardless of DFS).
>>
>> Frequency ranges and EIRP limits for all ranges have been updated to
>> match items 59-63, 65 in the linked document. As the rules for AU have
>> never previously mirrored local regulations, changes include a
>> significant increase in the allowable 2.4GHz EIRP and smaller increases
>> in most other bands.
>>
>> In order to allow 80MHz operation between 5650-5730MHz (bordering two
>> bands) the lower, more restrictive band has been rounded up by 5MHz.
>>
>> Signed-off-by: Ryan Mounce <ryan@mounce.com.au>
>> ---
>>  db.txt | 15 ++++++++++-----
>>  1 file changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/db.txt b/db.txt
>> index 05108e0..00e81b6 100644
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
>> +     (2400 - 2483.5 @ 40), (36)
>
> The mention of ETSI EN 300 328 in item 55 (a) leads me to believe that
> this is the limit we should be using, i.e. 500 mW. It is a bit confusing
> though since it seems like such devices would also fall under "digital
> modulation transmitters."

Item 55 applies only to frequency hopping transmitters e.g. Bluetooth.
As a local, I can say with some degree of certainty that 4W/36dBm is
the correct 2.4GHz ISM EIRP for Australia. It is advertised as the
EIRP in the 802.11d IE of commercial devices e.g. Cisco Aironet APs
and widely deployed ISP gateways in Australia, among other devices
that have received relevant approvals.

>> +     (5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW
>
> This looks correct.
>
>> +     (5250 - 5350 @ 80), (23), NO-OUTDOOR, AUTO-BW, DFS
>
> Since this range requires TPC we need to set the power limit at 100 mW.
>
>> +     (5470 - 5600 @ 80), (30), DFS
>> +     (5650 - 5730 @ 80), (30), DFS
>
> These ranges also require TPC so we need to set the limit at 500 mW.

I was unsure about this one. Setting this to 27dBm also affects the
802.11d country information IE, however when the DFS flag is set a 3dB
802.11h power constraint IE is also advertised so stations will limit
themselves to (27-3)=24dBm/250mW.

Given the choice between unnecessarily halving transmit power on
stations and potentially transmitting at twice the permissible power
on APs without TPC I agree that the conservative approach should be
taken for now. Ideally I think that the actual EIRP limits should be
in the regdb and a 3dB constraint should be applied automatically on
APs that cannot support TPC when the DFS flag is set.

>> +     (5730 - 5850 @ 80), (36)
>
> In the document the ranges are 5650-5725 MHz and 5725-5850 MHz. I
> suspect that the existing rules fudge that to line up with the wifi
> channels, which technically is okay because the rules in the former
> range are more restrictive. I wonder if we shouldn't be recording them
> here as per the document and adding AUTO-BW. Johannes, any thoughts?

I've tested with AUTO-BW and it doesn't work in this case as channel
144 will be disabled if it doesn't exist entirely within one band.
Fudging the more restrictive rules by a mere 5MHz to fit 802.11
channels seems to be the status quo.

>> +     (57000 - 66000 @ 2160), (43), NO-OUTDOOR
>
> This looks correct.
>
> Thanks,
> Seth


Regards,
Ryan Mounce
