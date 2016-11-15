Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49616 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752186AbcKOOz1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 09:55:27 -0500
Message-ID: <582B21DD.6000306@candelatech.com> (sfid-20161115_155530_443575_D05B5A56)
Date: Tue, 15 Nov 2016 06:55:25 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: voncken <cedric.voncken@acksys.fr>
CC: linux-wireless@vger.kernel.org,
        'OpenWrt Development List' <openwrt-devel@lists.openwrt.org>,
        ath10k@lists.infradead.org
Subject: Re: [OpenWrt-Devel] ATH10K VLAN firmware issue
References: <773DB8A82AB6A046AE0195C68612A31901C5B293@sbs2003.acksys.local> <566849DB.9040901@candelatech.com> <079401d132a6$7e7e2050$7b7a60f0$@acksys.fr> <CABUTiXWg3t5qK6O5ooDE+4=Xk3Msybs5mu9+tQm_Bb0wdSrfWQ@mail.gmail.com> <27f802e7-79c5-a17f-1883-88e62a6520ef@ezplanet.net> <CABUTiXUBfHB5RiZ8=ODzrK4-rCBJZ8QqZuZhMK_J7c7haFMEcw@mail.gmail.com> <CAGJdtRCKidEfDF7sc4BRGSfOTmcGJUJ4KZt0xU1vj4bGAnuu1Q@mail.gmail.com> <c58ffbe0-c305-3282-34e9-98814c6f0d14@candelatech.com> <68bd7ebd-b12a-5dbf-a267-5913127718a1@candelatech.com> <846c145b-3b15-45ca-249a-040518bc2dad@dd-wrt.com> <581DEE2E.3010502@candelatech.com> <001a01d23f4d$cd1df550$6759dff0$@acksys.fr>
In-Reply-To: <001a01d23f4d$cd1df550$6759dff0$@acksys.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The beta-18 release on my web page has the fix and should work fine.

Probably soon I will promote the beta-18 to final release
status.  Any help in testing and verifying the beta works well
is welcome.

Thanks,
Ben

On 11/15/2016 06:37 AM, voncken wrote:
> 	Hi Ben,
>
> 	Do you plan to release a candelatech firmware with this fix?
>
> 	Regards.
>
> Cedric Voncken.
>> -----Message d'origine-----
>> De : linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>> owner@vger.kernel.org] De la part de Ben Greear
>> Envoyé : samedi 5 novembre 2016 15:35
>> À : Sebastian Gottschall; yu-chieh kung; Bruno Antunes
>> Cc : Mauro Mozzarelli; linux-wireless@vger.kernel.org; OpenWrt
>> Development List; ath10k@lists.infradead.org
>> Objet : Re: [OpenWrt-Devel] ATH10K VLAN firmware issue
>>
>> Looks to me like 10.4 defaults to the right value, but possibly there
>> are other issues with it.  I tested my CT 10.4 and it worked OK with
>> vlans for me.
>>
>> Thanks,
>> Ben
>>
>> On 11/05/2016 01:05 AM, Sebastian Gottschall wrote:
>>> would be good if qca can fix this bug finally in all available
>>> firmwares. its a very annoying issue since a long time
>>>
>>> Sebastian
>>>
>>>
>>> Am 04.11.2016 um 23:23 schrieb Ben Greear:
>>>> The bug appears that vlan-tx-stripping is unconditionally enabled in
>>>> at least my firmware.  I have re-compiled w/out that flag set, and
>> it
>>>> appears to work for me.
>>>>
>>>> Please download this firmware, rename it firmware-2.bin, make sure
>>>> you remove/rename any firmware-5.bin (etc) so mine will load, and
>> see if that fixes your problem.
>>>>
>>>> Please note that it is very likely you will have to use same MAC
>>>> address for the VLAN devices that the underlying station uses in
>> order for this to work.
>>>>
>>>> https://www.candelatech.com/downloads/tmp/firmware-2-full-
>> community.b
>>>> in
>>>>
>>>>
>>>> Thanks,
>>>> Ben
>>>>
>>>>
>>>> On 11/04/2016 02:50 PM, Ben Greear wrote:
>>>>> I can reproduce this in my CT firmware. I'll see if I can fix it,
>>>>> but for stock firmware, it might be that changing the driver to use
>>>>> Ethernet packet type of native-wifi would make .1q vlans work.
>>>>>
>>>>> Thanks,
>>>>> Ben
>>>>>
>>>>> On 11/04/2016 10:28 AM, yu-chieh kung wrote:
>>>>>> I met the same problem before,
>>>>>> if i modify the 1q header to other value (0xaa00) before go into
>> firmware.
>>>>>> I can capture the packet in the air I think the vlan packet is
>>>>>> dropped in firmware.
>>>>>>
>>>>>> 2016-11-04 22:41 GMT+08:00 Bruno Antunes <baantunes@gmail.com>:
>>>>>>> On 4 November 2016 at 14:18, Mauro Mozzarelli
>> <openwrt@ezplanet.net> wrote:
>>>>>>>> Since the capability is implemented in software you might be
>>>>>>>> testing the limit of your router's CPU i/o speed.
>>>>>>>
>>>>>>> By loading the module in rawmode?
>>>>>>>
>>>>>>> The AP is an APU and Sta is an APU2.
>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> On 04/11/16 14:13, Bruno Antunes wrote:
>>>>>>>>>
>>>>>>>>> Hi all,
>>>>>>>>>
>>>>>>>>> Old thread but I think the issue is still present.
>>>>>>>>>
>>>>>>>>> I'm running a setup with VLANs with WDS and ath10k cards.
>>>>>>>>>
>>>>>>>>> To make it work both cards must be loaded in rawmode, AP and
>>>>>>>>> Sta, and with no security.
>>>>>>>>>
>>>>>>>>> I'm using a OpenWrt trunk r49941 and the most recent firmware,
>>>>>>>>> 10.2.4.70.58, from Kalle ath10k firmware tree.
>>>>>>>>>
>>>>>>>>> Although it works the throughput is very bad.
>>>>>>>>> Are there any alternatives to improve the throughput.
>>>>>>>>>
>>>>>>>>> Best Regards,
>>>>>>>>> Bruno
>>>>>>>>>
>>>>>>>>> On 9 December 2015 at 17:24, voncken <cedric.voncken@acksys.fr>
>> wrote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>> -----Message d'origine-----
>>>>>>>>>>> De : Ben Greear [mailto:greearb@candelatech.com] Envoyé :
>>>>>>>>>>> mercredi 9 décembre 2015 16:34 À : Cedric VONCKEN;
>>>>>>>>>>> ath10k@lists.infradead.org; linux-wireless Objet : Re: ATH10K
>>>>>>>>>>> VLAN firmware issue
>>>>>>>>>>>
>>>>>>>>>>> This only happens when you use STA  + WDS, or is .1q broken
>>>>>>>>>>> for you in other cases as well?
>>>>>>>>>>
>>>>>>>>>> No, this issue occurs in all modes (STA, STA + WDS, AP).
>>>>>>>>>>
>>>>>>>>>> Thanks
>>>>>>>>>>
>>>>>>>>>> Cedric.
>>>>>>>>>>
>>>>>>>>>>> Thanks,
>>>>>>>>>>> Ben
>>>>>>>>>>>
>>>>>>>>>>> On 12/08/2015 06:29 AM, Cedric VONCKEN wrote:
>>>>>>>>>>>>
>>>>>>>>>>>>       I'm testing to transmit frame with 802.1q tag (VLAN).
>>>>>>>>>>>>
>>>>>>>>>>>>       My client is set in STA + WDS and the netdev is bridged
>> with eth0.
>>>>>>>>>>>>       I have a computer with vlan configuration set connected
>>>>>>>>>>>> to the STA eth0.
>>>>>>>>>>>>
>>>>>>>>>>>>       If I try to transmit frames with 802.1q tag, the frames
>>>>>>>>>>>> are not
>>>>>>>>>>
>>>>>>>>>> sent.
>>>>>>>>>>>>
>>>>>>>>>>>>       I checked with wireless sniffer, and I don't see the
>>>>>>>>>>>> frame with VLAN tag (the frames without VLAN tag are sent).
>>>>>>>>>>>>
>>>>>>>>>>>>       I tested with firmware 10.2.4.70.14-2 from kale github,
>>>>>>>>>>>> 10.1.467-ct-com-full-015 from candelatech and 10.2.4.70-2
>>>>>>>>>>>> from openwrt, and in all cases I have the same issue.
>>>>>>>>>>>>
>>>>>>>>>>>>       Thanks for your help.
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> --
>>>>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>>>>>> linux-wireless" in the body of a message to
>>>>>>>>>>>> majordomo@vger.kernel.org More majordomo info at
>>>>>>>>>>>> http://vger.kernel.org/majordomo-info.html
>>>>>>>>>>>>
>>>>>>>>>>> --
>>>>>>>>>>> Ben Greear <greearb@candelatech.com> Candela Technologies Inc
>>>>>>>>>>> http://www.candelatech.com
>>>>>>>>>>
>>>>>>>>>> --
>>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>> linux-wireless"
>>>>>>>>>> in
>>>>>>>>>> the body of a message to majordomo@vger.kernel.org More
>>>>>>>>>> majordomo info at http://vger.kernel.org/majordomo-info.html
>>>>>>>>>
>>>>>>>>> _______________________________________________
>>>>>>>>> openwrt-devel mailing list
>>>>>>>>> openwrt-devel@lists.openwrt.org
>>>>>>>>> https://lists.openwrt.org/cgi-bin/mailman/listinfo/openwrt-
>> devel
>>>>>>>>
>>>>>>>> _______________________________________________
>>>>>>>> openwrt-devel mailing list
>>>>>>>> openwrt-devel@lists.openwrt.org
>>>>>>>> https://lists.openwrt.org/cgi-bin/mailman/listinfo/openwrt-devel
>>>>>>>
>>>>>>> _______________________________________________
>>>>>>> ath10k mailing list
>>>>>>> ath10k@lists.infradead.org
>>>>>>> http://lists.infradead.org/mailman/listinfo/ath10k
>>>>>>
>>>>>
>>>>>
>>>>
>>>>
>>>
>>>
>>
>> --
>> Ben Greear <greearb@candelatech.com>
>> Candela Technologies Inc  http://www.candelatech.com
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
