Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:35549 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934494AbcKDOlg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Nov 2016 10:41:36 -0400
Received: by mail-qt0-f173.google.com with SMTP id c47so49229745qtc.2
        for <linux-wireless@vger.kernel.org>; Fri, 04 Nov 2016 07:41:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <27f802e7-79c5-a17f-1883-88e62a6520ef@ezplanet.net>
References: <773DB8A82AB6A046AE0195C68612A31901C5B293@sbs2003.acksys.local>
 <566849DB.9040901@candelatech.com> <079401d132a6$7e7e2050$7b7a60f0$@acksys.fr>
 <CABUTiXWg3t5qK6O5ooDE+4=Xk3Msybs5mu9+tQm_Bb0wdSrfWQ@mail.gmail.com> <27f802e7-79c5-a17f-1883-88e62a6520ef@ezplanet.net>
From: Bruno Antunes <baantunes@gmail.com>
Date: Fri, 4 Nov 2016 14:41:14 +0000
Message-ID: <CABUTiXUBfHB5RiZ8=ODzrK4-rCBJZ8QqZuZhMK_J7c7haFMEcw@mail.gmail.com> (sfid-20161104_154139_642811_407F836A)
Subject: Re: [OpenWrt-Devel] ATH10K VLAN firmware issue
To: Mauro Mozzarelli <openwrt@ezplanet.net>
Cc: OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 November 2016 at 14:18, Mauro Mozzarelli <openwrt@ezplanet.net> wrote:
> Since the capability is implemented in software you might be testing the
> limit of your router's CPU i/o speed.

By loading the module in rawmode?

The AP is an APU and Sta is an APU2.

>
>
>
> On 04/11/16 14:13, Bruno Antunes wrote:
>>
>> Hi all,
>>
>> Old thread but I think the issue is still present.
>>
>> I'm running a setup with VLANs with WDS and ath10k cards.
>>
>> To make it work both cards must be loaded in rawmode, AP
>> and Sta, and with no security.
>>
>> I'm using a OpenWrt trunk r49941 and the most recent firmware,
>> 10.2.4.70.58, from Kalle ath10k firmware tree.
>>
>> Although it works the throughput is very bad.
>> Are there any alternatives to improve the throughput.
>>
>> Best Regards,
>> Bruno
>>
>> On 9 December 2015 at 17:24, voncken <cedric.voncken@acksys.fr> wrote:
>>>
>>>
>>>> -----Message d'origine-----
>>>> De : Ben Greear [mailto:greearb@candelatech.com]
>>>> Envoy=C3=A9 : mercredi 9 d=C3=A9cembre 2015 16:34
>>>> =C3=80 : Cedric VONCKEN; ath10k@lists.infradead.org; linux-wireless
>>>> Objet : Re: ATH10K VLAN firmware issue
>>>>
>>>> This only happens when you use STA  + WDS, or is .1q broken for you in
>>>> other cases as well?
>>>
>>> No, this issue occurs in all modes (STA, STA + WDS, AP).
>>>
>>> Thanks
>>>
>>> Cedric.
>>>
>>>> Thanks,
>>>> Ben
>>>>
>>>> On 12/08/2015 06:29 AM, Cedric VONCKEN wrote:
>>>>>
>>>>>      I'm testing to transmit frame with 802.1q tag (VLAN).
>>>>>
>>>>>      My client is set in STA + WDS and the netdev is bridged with eth=
0.
>>>>>      I have a computer with vlan configuration set connected to the S=
TA
>>>>> eth0.
>>>>>
>>>>>      If I try to transmit frames with 802.1q tag, the frames are not
>>>
>>> sent.
>>>>>
>>>>>      I checked with wireless sniffer, and I don't see the frame with
>>>>> VLAN
>>>>> tag (the frames without VLAN tag are sent).
>>>>>
>>>>>      I tested with firmware 10.2.4.70.14-2 from kale github,
>>>>> 10.1.467-ct-com-full-015 from candelatech and 10.2.4.70-2 from
>>>>> openwrt, and in all cases I have the same issue.
>>>>>
>>>>>      Thanks for your help.
>>>>>
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>> linux-wireless" in the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>> --
>>>> Ben Greear <greearb@candelatech.com>
>>>> Candela Technologies Inc  http://www.candelatech.com
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> _______________________________________________
>> openwrt-devel mailing list
>> openwrt-devel@lists.openwrt.org
>> https://lists.openwrt.org/cgi-bin/mailman/listinfo/openwrt-devel
>
> _______________________________________________
> openwrt-devel mailing list
> openwrt-devel@lists.openwrt.org
> https://lists.openwrt.org/cgi-bin/mailman/listinfo/openwrt-devel
