Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0076.outbound.protection.outlook.com ([104.47.38.76]:18763
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750762AbdE1BW0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 May 2017 21:22:26 -0400
Subject: Re: [PATCH] Per chain RSSI reporting
To: Michael Ney <neym@vorklift.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Ben Greear <greearb@candelatech.com>,
        Adrian Chadd <adrian@freebsd.org>
References: <SN1PR08MB1373BF583E9CE2AA6A0F6381B0FC0@SN1PR08MB1373.namprd08.prod.outlook.com>
 <CAJ-VmomiKOgV4pJWNKdOCzsUJZYEixvP4p5bQ9X1FBqAGk_o0w@mail.gmail.com>
 <SN1PR08MB137316C4132262145C58CEA3B0FD0@SN1PR08MB1373.namprd08.prod.outlook.com>
 <21095854-07c7-7586-6a6e-e60c11932b84@candelatech.com>
 <CAJ-Vmonp72WpT_aUVo_To+k676Ra8S165efPOyXRvvk=_W0YEQ@mail.gmail.com>
 <4A8583B3-FFB2-4BDE-8041-9478CAD9EF73@vorklift.com>
 <98efa255-b481-ce11-69d5-f2d141d44c2b@ethertronics.com>
 <0B35E5A1-7A94-43EC-87BC-A8402098E3C5@vorklift.com>
From: Norik Dzhandzhapanyan <norikd@ethertronics.com>
Message-ID: <cdc0113a-5819-8393-52f1-465f7af74331@ethertronics.com> (sfid-20170528_032231_874404_BF332770)
Date: Sat, 27 May 2017 18:22:18 -0700
MIME-Version: 1.0
In-Reply-To: <0B35E5A1-7A94-43EC-87BC-A8402098E3C5@vorklift.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Michael for the explanation. It makes complete sense.

Does the same concern then also apply to the existing functionality of the driver's assignment of the combined rssi to the status->signal variable?

The submitted patch breaks nothing in the driver and adds the per chain feature which currently does not exist. I agree the averaging component  could be factored for a more generic application, but at the same time the change impact would be larger and this is what I wanted to avoid. The averaging function can be qualified by a module parameter which will make the patch impact benign to others that are looking for per chain rssi reporting functionality.

Norik


On 05/27/2017 03:10 PM, Michael Ney wrote:
> What I'm referring to is the real world case of an access point communicating with multiple stations.
>
> Take for example. an AP that has four stations attached to it with different average RSSIs:
>
>   - Station 1: -45
>   - Station 2: -70
>   - Station 3: -50
>   - Station 4: -30
>
> Now for argument's sake let us assume that all four stations are transmitting at equal amounts and for every 16 frames transmitted each station sends 4 frames.
>
> Since the moving average you are proposing averages all frames received by the driver, that works out to a moving average that will always be around -48.75 for this example.  For station 2, this will result in a 21.25 error from its actual average RSSI.
>
> This example also doesn't take into account other frames that aren't from stations that are processed through to the driver, such as Beacon frames, which even will affect managed mode and not just Access Points. The only way an average RSSI could be calculated accurately is that for every unique MAC address identified a structure has to be created to store the moving average RSSI data for that peer. This becomes extremely bulky memory-wise. Alternatively, it could be implemented such that it only applies to managed mode and only when the peer identified is the currently connected BSSID.
>
>
>> On May 27, 2017, at 3:30 PM, Norik Dzhandzhapanyan <norikd@ethertronics.com> wrote:
>>
>> Is there an enhanced or conflicting patch pending?
>>
>>
>> On 05/27/2017 10:56 AM, Michael Ney wrote:
>>> The submitted code also doesn't appear to handle RSSI per-peer which would be needed for any use when configured as an access point.
>>>
>>>> On May 27, 2017, at 12:39 PM, Adrian Chadd <adrian@freebsd.org> wrote:
>>>>
>>>> On 27 May 2017 at 09:07, Ben Greear <greearb@candelatech.com> wrote:
>>>>> At low encoding rates, especially if it switches to a single-chain encoding,
>>>>> maybe the on-air signal really is stronger?
>>>>>
>>>>> Have you verified in some other manner than the signals reported by ath10k
>>>>> are
>>>>> wrong?
>>>> Hiya,
>>>>
>>>> So yeah, multipath, higher TX rates == weaker TX signal, TPC, etc are
>>>> all interesting to know about at the receiver. it's hard to separate
>>>> that out from the noise sometimes, but in some controlled deployments
>>>> its really obvious.
>>>>
>>>>
>>>>
>>>> -adrian
>>>>
>>>> _______________________________________________
>>>> ath10k mailing list
>>>> ath10k@lists.infradead.org
>>>> http://lists.infradead.org/mailman/listinfo/ath10k
>> The contents of this transmission are Ethertronics Inc. Confidential and may contain proprietary or legally privileged information which may not be disclosed, copied or distributed without the express written consent of Ethertronics Inc. The information is intended to be for the use of the individual or entity named on this transmission. If you are not the intended recipient, be aware that any disclosure, copying, distribution or use of the contents of this information is prohibited. If you have received this transmission in error, please notify us by telephone immediately so that we can arrange for the retrieval of the original documents at no cost to you. Alternatively, notify the sender by replying to this transmission and delete the message without disclosing it. Thank you
>>
>> _______________________________________________
>> ath10k mailing list
>> ath10k@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/ath10k
