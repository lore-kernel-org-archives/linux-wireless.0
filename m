Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34934 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756094AbeFOLqS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jun 2018 07:46:18 -0400
Received: by mail-qt0-f194.google.com with SMTP id s9-v6so8699828qtg.2
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jun 2018 04:46:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5B221E56.4000009@broadcom.com>
References: <1528887539-26821-1-git-send-email-tamizhr@codeaurora.org>
 <87fu1q7uq5.fsf@toke.dk> <9fd8762e9d2f4b93b299ab859e389b46@aphydexm01b.ap.qualcomm.com>
 <87a7ry7meo.fsf@toke.dk> <5B221E56.4000009@broadcom.com>
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Date: Fri, 15 Jun 2018 13:46:17 +0200
Message-ID: <CAFED-jkWPMgpHvrp2xE4dtKmLW4DU8j34-_5Ss4rVoBGJi9rrQ@mail.gmail.com> (sfid-20180615_134623_921649_A6302C27)
Subject: Re: [PATCH 0/4] cfg80211/mac80211: Add support to configure and
 monitor txrate threshold
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Tamizh Chelvam Raja <tamizhr@qti.qualcomm.com>,
        Tamizh chelvam <tamizhr@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2018-06-14 9:50 GMT+02:00 Arend van Spriel <arend.vanspriel@broadcom.com>:
> On 6/13/2018 5:10 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>
>> Tamizh Chelvam Raja <tamizhr@qti.qualcomm.com> writes:
>>
>>>> This patchsets introduced new NL command and api to support
>>>> configuring txrate threshold for the connected stations and api to
>>>> notify userspace application upon crossing the configured txrate
>>>> threshold.
>>>> This will be useful for the application which requires station's
>>>> current capability change information.
>>>
>>>
>>> What is the intended use case? Asking mostly out of curiosity :)
>>
>>
>>> [Tamizh] This is to monitor txrate change for a station. By notifying
>>> userspace when the txrate for a station goes out of configured
>>> threshold, It can take steering decisions on the particular station.
>>
Do we really need kernel notification for that?
You can simple monitor all this information same way iw station dump show.
As a metric use tx/rx bitrate, signal or even expected throughput.

Maybe small patch that will average tx/rx bitrate for few seconds
(additional fields in station dump) could be helpful here.

BR
Janusz

>>
>> Yeah, I got that part. I was curious as to what (userspace) application
>> you were planning to use this for? I.e., what kind of steering
>> decisions? :)
>
>
> It sounds like network initiated handover as opposed to station roaming.
> Suspect the user-space application referred to here is a proprietary
> application. At plumbers conf I attended a couple of years ago there was =
an
> idea to have a network management application controlling multiple hostap=
d
> instances for this type of functionality, but not sure if that project ev=
er
> got of the ground.
>
> Regards,
> Arend
>



--=20
Janusz Dziedzic
