Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:36230 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750862AbcJKTMP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Oct 2016 15:12:15 -0400
Received: by mail-wm0-f45.google.com with SMTP id o81so3785383wma.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2016 12:12:15 -0700 (PDT)
Subject: Re: bcmdhd: Strange Power Save messages
To: Gucea Doru <gucea.doru@gmail.com>
References: <CANfLQrY6AVJoh8PW+5Ev0seKqnNRxRhK-N735q6Aa4KvdUVEcg@mail.gmail.com>
 <CANfLQrZxEUX0UMwrVNZHps9ztqxmOaeovy34fey2NkErCDDarQ@mail.gmail.com>
 <ed4a7366-3f67-79da-0868-876a69b1da54@broadcom.com>
 <CABPxzYKWJ=uGchDkEOd_jL__h5qiR_BAmkPJ-CiaQC-SF5JtCA@mail.gmail.com>
 <CANfLQrbRvQb5a2AsqY0jGYeuDqC1c_7x8tUbQSm2=QPt1gT5eA@mail.gmail.com>
 <db6d5803-3fec-64d9-5290-32216d1bd031@broadcom.com>
 <CANfLQrY1NahfQF0xheocVFdJHgxhSE5YbFUwcm3t6e0Fur-YGg@mail.gmail.com>
 <8d01e83b-800d-bba4-b948-abbdc5188f6b@broadcom.com>
 <CANfLQra_Vh4cnHvpzU9yxv4_6SJEc1LN8Vqm4-11thOLvGxY2Q@mail.gmail.com>
Cc: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
        Arend van Spriel <arend@broadcom.com>,
        Andra Paraschiv <andra.paraschiv7@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <a948f377-5a87-e1a3-e56f-9768ee6d87a0@broadcom.com> (sfid-20161011_211219_559291_7C958545)
Date: Tue, 11 Oct 2016 21:12:15 +0200
MIME-Version: 1.0
In-Reply-To: <CANfLQra_Vh4cnHvpzU9yxv4_6SJEc1LN8Vqm4-11thOLvGxY2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07-10-16 16:33, Gucea Doru wrote:
> On Thu, Oct 6, 2016 at 10:25 AM, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 6-10-2016 10:07, Gucea Doru wrote:
>>> On Wed, Oct 5, 2016 at 11:12 AM, Arend Van Spriel
>>> <arend.vanspriel@broadcom.com> wrote:
>>>> On 4-10-2016 13:39, Gucea Doru wrote:
>>>>> On Sat, Oct 1, 2016 at 2:52 PM, Arend van Spriel
>>>>>> <arend.vanspriel@broadcom.com> wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 29-09-16 13:32, Gucea Doru wrote:
>>>>>>>> On Tue, Sep 27, 2016 at 12:03 PM, Gucea Doru <gucea.doru@gmail.com> wrote:
>>>>>>>>> What is the decision triggering the exit from the PS mode immediately
>>>>>>>>> after the ping request? I am asking this because 802.11 PS legacy
>>>>>>>>> specifies that the client should wait for a beacon with TIM set in
>>>>>>>>> order to wake up: in my case, there is no beacon between the ping
>>>>>>>>> request message and the Null frame that announces the exit from the PS
>>>>>>>>> mode.
>>>>>>>>
>>>>>>>>
>>>>>>>> Any help would be highly appreciated :)
>>>>>>>
>>>>>>> Actually though I already sent you are reply, but alas here it is.
>>>>>>>
>>>>>>> bcmdhd is our aosp driver. I am maintaining the upstream brcm80211
>>>>>>> drivers. Regardless your question is more for firmware running on the
>>>>>>> device. So like the same behavior would be observed when using brcmfmac
>>>>>>> with same firmware.
>>>>>>>
>>>>>>>> IEEE Std 802.11-2012, section 10.2.1.8 specifies that "when the STA
>>>>>>>> detects that the bit corresponding to its AID is 1 i the TIM, the STA
>>>>>>>> shall issue a PS Poll". In my capture there are cases when the STA
>>>>>>>> exits the PS mode without waiting for a beacon.
>>>>>>>
>>>>>>> It is a bit tricky, but the standard does not explicitly say the STA
>>>>>>> should be in power-save at any other time. So it is difficult to say
>>>>>>> what event occurred on the STA side to exit PS mode. Also STA means
>>>>>>> P2P-Client as you say. That means that you have multiple interfaces:
>>>>>>> regular STA and P2P-Client. So is the STA connected to some other AP or
>>>>>>> just not connected. wpa_supplicant will do intermittent scan or initiate
>>>>>>> scheduled scan by which firmware will scan at a certain interval. That
>>>>>>> is just some things I can come up with and I am sure there are more.
>>>>>
>>>>> I agree that there may be some events belonging to the regular STA
>>>>> interface that could trigger the Null Frame (which includes the exit
>>>>> from PS Mode). However, I would expect to see some management frames
>>>>> in the air before/after the Null Packet (e.g.: a Probe request in case
>>>>> of a scheduled scan). But in my case the trigger for the Null frame
>>>>> seems to be the ping request packet, the scenario is the same every
>>>>> time: ping request -> Block ACK -> Null Frame (Wireshark trace
>>>>> confirms this behavior).
>>>>>
>>>>> I thought that you had a power save optimization algorithm that keeps
>>>>> the card on a few milliseconds just to see if we can have a fast reply
>>>>> from the peer. Does this ring a bell? :)
>>>>
>>>> It does not. That would be implemented in firmware. As said I am working
>>>> on brcmfmac/brcmsmac. So bcmdhd and firmware are not my expertise.
>>>>
>>>
>>> Arend, could you please redirect me to a Broadcom firmware maintainer?
>>
>> Can you please elaborate on your platform, broadcom chipset, and what
>> version of bcmdhd you are using.
>>
> 
> Platform: Nexus 5 running CM13 (Android 6.0.1)
> Broadcom chipset: BCM4339 Wi-Fi Chipset
> bcmdhd version:Dongle Host Driver, version 1.88.45 (r)
> 
> Do you need more information?

So can you indicate the mac addresses of the two nexus devices and which
one is P2P-GO. I entered the wpa key you mentioned in your initial
email, but my wireshark does not seem to be able to decrypt the packets,
which makes it a bit harder to analyze.

Regards,
Arend
