Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm.newmedia-net.de ([217.113.179.122]:54033 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbdBMWsP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Feb 2017 17:48:15 -0500
To: Ben Greear <greearb@candelatech.com>,
        Adrian Chadd <adrian@freebsd.org>
References: <0082a9e3-83f3-9bc3-af43-b890b91cfd93@candelatech.com>
 <e71fe0b1-4482-b80b-2624-240b154ff980@dd-wrt.com>
 <CAJ-VmokKafmamWJJ0-=PJ_oNBejbqcHbd8NO7-M9=Z6DFRuhzw@mail.gmail.com>
 <589F50B8.4020609@candelatech.com>
 <bbf485eb-f3aa-f49b-8401-03632bc70a7f@dd-wrt.com>
 <36c7dfa2-b39c-ad7a-5e39-3daf8983ed2f@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <f6d4b239-03af-976b-0c97-e7a5858f00da@dd-wrt.com> (sfid-20170213_234818_766770_602A9FE4)
Date: Mon, 13 Feb 2017 23:48:08 +0100
MIME-Version: 1.0
In-Reply-To: <36c7dfa2-b39c-ad7a-5e39-3daf8983ed2f@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: VHT 160Mhz and nss related config.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 13.02.2017 um 20:56 schrieb Ben Greear:
> On 02/11/2017 10:21 AM, Sebastian Gottschall wrote:
>> Am 11.02.2017 um 18:58 schrieb Ben Greear:
>>> On 02/10/2017 08:37 PM, Adrian Chadd wrote:
>>>> On 10 February 2017 at 20:22, Sebastian Gottschall
>>>> <s.gottschall@dd-wrt.com> wrote:
>>>>> i really can't believe this. if this is true the  160 mhz mode 
>>>>> would not
>>>>> make any sense.
>>>>> the maximum tx / rx rate for 4x4 vht80 and 2x2 vht160 is 
>>>>> identical. so
>>>>> vht160 would not increase performance in any way
>>>>
>>>> Well, if it can also do 2x2 MU-MIMO at 160MHz then it can be a
>>>> perfectly fine STA to a 4x4 160MHz MU-MIMO chip that can actually
>>>> transmit 2x2 rates to different MU-MIMO peers.
>>>>
>>>> That's the outstanding question I have - is it like, 2x2 MU only, or
>>>> is it say, 2 concurrently different spatial stream 2x2 MU? Ie, can you
>>>> have 2 peers, different VHT spatial groups (or 4 peers, 1 spatial
>>>> group each) all going at the same time?
>>>>
>>>> I'm .. not even sure how you're supposed to cleanly negotiate that you
>>>> can do 4NSS in VHT80 but 2NSS in VHT160 to a peer... that only makes
>>>> sense if you're doing lots of 1NSS and 2NSS MU-MIMO peers..
>>>
>>> I think using the max-rx-rate logic might could imply this, but I am 
>>> not sure
>>> many drivers fill this out properly.
>>>
>>> Looks like a mess waiting to happen to me.
>>>
>>> Even if you can do 1x1 160Mhz MU-MIMO to two stations, and I am not 
>>> certain you
>>> can since in 80Mhz you can only do a 1x1 and a 2x2 (not two 2x2).
>>>
>>> So, from what I know currently, 80+80 is not that useful on the 9984 
>>> NIC...
>> never tried 80+80 since i need to enhance the channel logic alot in 
>> my firmware code to handle it. would be great enough if vht160 would 
>> work as expected and
>> i'm not sure right now if it really works, even if the interface 
>> initialized correctly it assocs only with vht80
>
> Looks like it is working with the hack I posted:
>
> Station 04:f0:21:2e:49:65 (on wlan2)
>     inactive time:    0 ms
>     rx bytes:    64902998
>     rx packets:    37918
>     tx bytes:    64760298
>     tx packets:    42239
>     tx retries:    0
>     tx failed:    0
>     signal:      -43 dBm
>     signal avg:    -42 dBm
>     tx bitrate:    1053.0 MBit/s VHT-MCS 6 160MHz VHT-NSS 2
>     rx bitrate:    1560.0 MBit/s VHT-MCS 8 160MHz short GI VHT-NSS 2
>     authorized:    yes
>     authenticated:    yes
>     preamble:    long
>     WMM/WME:    yes
>     MFP:        no
>     TDLS peer:    no
>     connected time:    156 seconds
>
> Thanks,
> Ben
>
>
the hack you posted crashes the driver for me. i also see that this 
patch is based on the CT ath10k source. it doesnt apply clean to ath10k. 
needed to merge it manually


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
