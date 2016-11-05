Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm.newmedia-net.de ([217.113.179.122]:39240 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbcKEIFO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Nov 2016 04:05:14 -0400
To: Ben Greear <greearb@candelatech.com>,
        yu-chieh kung <jay0607@gmail.com>,
        Bruno Antunes <baantunes@gmail.com>
References: <773DB8A82AB6A046AE0195C68612A31901C5B293@sbs2003.acksys.local>
 <566849DB.9040901@candelatech.com>
 <079401d132a6$7e7e2050$7b7a60f0$@acksys.fr>
 <CABUTiXWg3t5qK6O5ooDE+4=Xk3Msybs5mu9+tQm_Bb0wdSrfWQ@mail.gmail.com>
 <27f802e7-79c5-a17f-1883-88e62a6520ef@ezplanet.net>
 <CABUTiXUBfHB5RiZ8=ODzrK4-rCBJZ8QqZuZhMK_J7c7haFMEcw@mail.gmail.com>
 <CAGJdtRCKidEfDF7sc4BRGSfOTmcGJUJ4KZt0xU1vj4bGAnuu1Q@mail.gmail.com>
 <c58ffbe0-c305-3282-34e9-98814c6f0d14@candelatech.com>
 <68bd7ebd-b12a-5dbf-a267-5913127718a1@candelatech.com>
Cc: Mauro Mozzarelli <openwrt@ezplanet.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <846c145b-3b15-45ca-249a-040518bc2dad@dd-wrt.com> (sfid-20161105_090554_729478_A82355B3)
Date: Sat, 5 Nov 2016 09:05:03 +0100
MIME-Version: 1.0
In-Reply-To: <68bd7ebd-b12a-5dbf-a267-5913127718a1@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: [OpenWrt-Devel] ATH10K VLAN firmware issue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

would be good if qca can fix this bug finally in all available 
firmwares. its a very annoying issue since a long time

Sebastian


Am 04.11.2016 um 23:23 schrieb Ben Greear:
> The bug appears that vlan-tx-stripping is unconditionally enabled in
> at least my firmware.  I have re-compiled w/out that flag set, and it 
> appears
> to work for me.
>
> Please download this firmware, rename it firmware-2.bin, make sure you 
> remove/rename
> any firmware-5.bin (etc) so mine will load, and see if that fixes your 
> problem.
>
> Please note that it is very likely you will have to use same MAC address
> for the VLAN devices that the underlying station uses in order for 
> this to work.
>
> https://www.candelatech.com/downloads/tmp/firmware-2-full-community.bin
>
>
> Thanks,
> Ben
>
>
> On 11/04/2016 02:50 PM, Ben Greear wrote:
>> I can reproduce this in my CT firmware. I'll see if I can fix it,
>> but for stock firmware, it might be that changing the driver to use 
>> Ethernet packet type
>> of native-wifi would make .1q vlans work.
>>
>> Thanks,
>> Ben
>>
>> On 11/04/2016 10:28 AM, yu-chieh kung wrote:
>>> I met the same problem before,
>>> if i modify the 1q header to other value (0xaa00) before go into 
>>> firmware.
>>> I can capture the packet in the air
>>> I think the vlan packet is dropped in firmware.
>>>
>>> 2016-11-04 22:41 GMT+08:00 Bruno Antunes <baantunes@gmail.com>:
>>>> On 4 November 2016 at 14:18, Mauro Mozzarelli 
>>>> <openwrt@ezplanet.net> wrote:
>>>>> Since the capability is implemented in software you might be 
>>>>> testing the
>>>>> limit of your router's CPU i/o speed.
>>>>
>>>> By loading the module in rawmode?
>>>>
>>>> The AP is an APU and Sta is an APU2.
>>>>
>>>>>
>>>>>
>>>>>
>>>>> On 04/11/16 14:13, Bruno Antunes wrote:
>>>>>>
>>>>>> Hi all,
>>>>>>
>>>>>> Old thread but I think the issue is still present.
>>>>>>
>>>>>> I'm running a setup with VLANs with WDS and ath10k cards.
>>>>>>
>>>>>> To make it work both cards must be loaded in rawmode, AP
>>>>>> and Sta, and with no security.
>>>>>>
>>>>>> I'm using a OpenWrt trunk r49941 and the most recent firmware,
>>>>>> 10.2.4.70.58, from Kalle ath10k firmware tree.
>>>>>>
>>>>>> Although it works the throughput is very bad.
>>>>>> Are there any alternatives to improve the throughput.
>>>>>>
>>>>>> Best Regards,
>>>>>> Bruno
>>>>>>
>>>>>> On 9 December 2015 at 17:24, voncken <cedric.voncken@acksys.fr> 
>>>>>> wrote:
>>>>>>>
>>>>>>>
>>>>>>>> -----Message d'origine-----
>>>>>>>> De : Ben Greear [mailto:greearb@candelatech.com]
>>>>>>>> Envoyé : mercredi 9 décembre 2015 16:34
>>>>>>>> À : Cedric VONCKEN; ath10k@lists.infradead.org; linux-wireless
>>>>>>>> Objet : Re: ATH10K VLAN firmware issue
>>>>>>>>
>>>>>>>> This only happens when you use STA  + WDS, or is .1q broken for 
>>>>>>>> you in
>>>>>>>> other cases as well?
>>>>>>>
>>>>>>> No, this issue occurs in all modes (STA, STA + WDS, AP).
>>>>>>>
>>>>>>> Thanks
>>>>>>>
>>>>>>> Cedric.
>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Ben
>>>>>>>>
>>>>>>>> On 12/08/2015 06:29 AM, Cedric VONCKEN wrote:
>>>>>>>>>
>>>>>>>>>      I'm testing to transmit frame with 802.1q tag (VLAN).
>>>>>>>>>
>>>>>>>>>      My client is set in STA + WDS and the netdev is bridged 
>>>>>>>>> with eth0.
>>>>>>>>>      I have a computer with vlan configuration set connected 
>>>>>>>>> to the STA
>>>>>>>>> eth0.
>>>>>>>>>
>>>>>>>>>      If I try to transmit frames with 802.1q tag, the frames 
>>>>>>>>> are not
>>>>>>>
>>>>>>> sent.
>>>>>>>>>
>>>>>>>>>      I checked with wireless sniffer, and I don't see the 
>>>>>>>>> frame with
>>>>>>>>> VLAN
>>>>>>>>> tag (the frames without VLAN tag are sent).
>>>>>>>>>
>>>>>>>>>      I tested with firmware 10.2.4.70.14-2 from kale github,
>>>>>>>>> 10.1.467-ct-com-full-015 from candelatech and 10.2.4.70-2 from
>>>>>>>>> openwrt, and in all cases I have the same issue.
>>>>>>>>>
>>>>>>>>>      Thanks for your help.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> -- 
>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>>> linux-wireless" in the body of a message to 
>>>>>>>>> majordomo@vger.kernel.org
>>>>>>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>>>>>>>
>>>>>>>> -- 
>>>>>>>> Ben Greear <greearb@candelatech.com>
>>>>>>>> Candela Technologies Inc  http://www.candelatech.com
>>>>>>>
>>>>>>> -- 
>>>>>>> To unsubscribe from this list: send the line "unsubscribe 
>>>>>>> linux-wireless"
>>>>>>> in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>>>>
>>>>>> _______________________________________________
>>>>>> openwrt-devel mailing list
>>>>>> openwrt-devel@lists.openwrt.org
>>>>>> https://lists.openwrt.org/cgi-bin/mailman/listinfo/openwrt-devel
>>>>>
>>>>> _______________________________________________
>>>>> openwrt-devel mailing list
>>>>> openwrt-devel@lists.openwrt.org
>>>>> https://lists.openwrt.org/cgi-bin/mailman/listinfo/openwrt-devel
>>>>
>>>> _______________________________________________
>>>> ath10k mailing list
>>>> ath10k@lists.infradead.org
>>>> http://lists.infradead.org/mailman/listinfo/ath10k
>>>
>>
>>
>
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
