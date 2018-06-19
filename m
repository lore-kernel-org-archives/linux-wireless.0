Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36532 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756300AbeFSH2N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 03:28:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 19 Jun 2018 12:58:11 +0530
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        =?UTF-8?Q?Toke_H?= =?UTF-8?Q?=C3=B8iland-J=C3=B8rgensen?=
        <toke@toke.dk>, Tamizh Chelvam Raja <tamizhr@qti.qualcomm.com>,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] cfg80211/mac80211: Add support to configure and
 monitor txrate threshold
In-Reply-To: <CAFED-jkWPMgpHvrp2xE4dtKmLW4DU8j34-_5Ss4rVoBGJi9rrQ@mail.gmail.com>
References: <1528887539-26821-1-git-send-email-tamizhr@codeaurora.org>
 <87fu1q7uq5.fsf@toke.dk>
 <9fd8762e9d2f4b93b299ab859e389b46@aphydexm01b.ap.qualcomm.com>
 <87a7ry7meo.fsf@toke.dk> <5B221E56.4000009@broadcom.com>
 <CAFED-jkWPMgpHvrp2xE4dtKmLW4DU8j34-_5Ss4rVoBGJi9rrQ@mail.gmail.com>
Message-ID: <793f824c63cfcfecf8e708d1ffc54c63@codeaurora.org> (sfid-20180619_092817_167851_542F4793)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-06-15 17:16, Janusz Dziedzic wrote:
> 2018-06-14 9:50 GMT+02:00 Arend van Spriel 
> <arend.vanspriel@broadcom.com>:
>> On 6/13/2018 5:10 PM, Toke Høiland-Jørgensen wrote:
>>> 
>>> Tamizh Chelvam Raja <tamizhr@qti.qualcomm.com> writes:
>>> 
>>>>> This patchsets introduced new NL command and api to support
>>>>> configuring txrate threshold for the connected stations and api to
>>>>> notify userspace application upon crossing the configured txrate
>>>>> threshold.
>>>>> This will be useful for the application which requires station's
>>>>> current capability change information.
>>>> 
>>>> 
>>>> What is the intended use case? Asking mostly out of curiosity :)
>>> 
>>> 
>>>> [Tamizh] This is to monitor txrate change for a station. By 
>>>> notifying
>>>> userspace when the txrate for a station goes out of configured
>>>> threshold, It can take steering decisions on the particular station.
>>> 
> Do we really need kernel notification for that?
> You can simple monitor all this information same way iw station dump 
> show.

In this case user space application need to fetch the station statistics 
periodically and parse those detail.
Let say AP has more number of stations(like more than 50) in all 
bands(2G and 5G), then the system overhead will be more for fetching the 
detail periodically.
But with this kernel notification we can avoid those overhead and more 
or less this is similar to the CQM(rssi, txe,..) notification in STA 
mode.

Thanks,
Tamizh.

> As a metric use tx/rx bitrate, signal or even expected throughput.
> 
> Maybe small patch that will average tx/rx bitrate for few seconds
> (additional fields in station dump) could be helpful here.
> 
> BR
> Janusz
> 
>>> 
>>> Yeah, I got that part. I was curious as to what (userspace) 
>>> application
>>> you were planning to use this for? I.e., what kind of steering
>>> decisions? :)
>> 
>> 
>> It sounds like network initiated handover as opposed to station 
>> roaming.
>> Suspect the user-space application referred to here is a proprietary
>> application. At plumbers conf I attended a couple of years ago there 
>> was an
>> idea to have a network management application controlling multiple 
>> hostapd
>> instances for this type of functionality, but not sure if that project 
>> ever
>> got of the ground.
>> 
>> Regards,
>> Arend
>> 
