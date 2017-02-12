Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm.newmedia-net.de ([217.113.179.122]:35515 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdBLUVy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Feb 2017 15:21:54 -0500
To: Ben Greear <greearb@candelatech.com>,
        Adrian Chadd <adrian@freebsd.org>
References: <0082a9e3-83f3-9bc3-af43-b890b91cfd93@candelatech.com>
 <e71fe0b1-4482-b80b-2624-240b154ff980@dd-wrt.com>
 <CAJ-VmokKafmamWJJ0-=PJ_oNBejbqcHbd8NO7-M9=Z6DFRuhzw@mail.gmail.com>
 <589F50B8.4020609@candelatech.com>
 <bbf485eb-f3aa-f49b-8401-03632bc70a7f@dd-wrt.com>
 <02b7f70a-7da2-f2e4-8904-bdffc3ca90a1@candelatech.com>
 <159ba156-cf2d-db0d-a6af-2557b9bfa6b6@dd-wrt.com>
 <f2982636-263f-d475-6b0b-85effc184ece@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <3b477278-2418-e436-77ad-449e9d54b60b@dd-wrt.com> (sfid-20170212_212207_597536_DA2C8FFC)
Date: Sun, 12 Feb 2017 21:21:45 +0100
MIME-Version: 1.0
In-Reply-To: <f2982636-263f-d475-6b0b-85effc184ece@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: VHT 160Mhz and nss related config.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 12.02.2017 um 17:05 schrieb Ben Greear:
>
>
> On 02/12/2017 02:56 AM, Sebastian Gottschall wrote:
>> Am 11.02.2017 um 20:38 schrieb Ben Greear:
>>> On 02/11/2017 10:21 AM, Sebastian Gottschall wrote:
>>>> Am 11.02.2017 um 18:58 schrieb Ben Greear:
>>>>> On 02/10/2017 08:37 PM, Adrian Chadd wrote:
>>>>>> On 10 February 2017 at 20:22, Sebastian Gottschall
>>>>>> <s.gottschall@dd-wrt.com> wrote:
>>>>>>> i really can't believe this. if this is true the  160 mhz mode 
>>>>>>> would not
>>>>>>> make any sense.
>>>>>>> the maximum tx / rx rate for 4x4 vht80 and 2x2 vht160 is 
>>>>>>> identical. so
>>>>>>> vht160 would not increase performance in any way
>>>>>>
>>>>>> Well, if it can also do 2x2 MU-MIMO at 160MHz then it can be a
>>>>>> perfectly fine STA to a 4x4 160MHz MU-MIMO chip that can actually
>>>>>> transmit 2x2 rates to different MU-MIMO peers.
>>>>>>
>>>>>> That's the outstanding question I have - is it like, 2x2 MU only, or
>>>>>> is it say, 2 concurrently different spatial stream 2x2 MU? Ie, 
>>>>>> can you
>>>>>> have 2 peers, different VHT spatial groups (or 4 peers, 1 spatial
>>>>>> group each) all going at the same time?
>>>>>>
>>>>>> I'm .. not even sure how you're supposed to cleanly negotiate 
>>>>>> that you
>>>>>> can do 4NSS in VHT80 but 2NSS in VHT160 to a peer... that only makes
>>>>>> sense if you're doing lots of 1NSS and 2NSS MU-MIMO peers..
>>>>>
>>>>> I think using the max-rx-rate logic might could imply this, but I 
>>>>> am not sure
>>>>> many drivers fill this out properly.
>>>>>
>>>>> Looks like a mess waiting to happen to me.
>>>>>
>>>>> Even if you can do 1x1 160Mhz MU-MIMO to two stations, and I am 
>>>>> not certain you
>>>>> can since in 80Mhz you can only do a 1x1 and a 2x2 (not two 2x2).
>>>>>
>>>>> So, from what I know currently, 80+80 is not that useful on the 
>>>>> 9984 NIC...
>>>> never tried 80+80 since i need to enhance the channel logic alot in 
>>>> my firmware code to handle it. would be great enough if vht160 
>>>> would work as expected and
>>>> i'm not sure right now if it really works, even if the interface 
>>>> initialized correctly it assocs only with vht80
>>>
>>> 160Mhz is really implemented as 80+80 internally it seems, so what I 
>>> meant is that
>>> 160Mhz or 80+80 both have the 2x2 restriction.
>> since i have a older fw source. can you give me a hint where you 
>> found a indication that its just 2x2?
>
> Look for:
>
> MAX_SPATIAL_STREAMS_SUPPORTED_AT_160MHZ
your findings where correct. frustrating.
>
> Thanks,
> Ben
>


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Berliner Ring 101, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
