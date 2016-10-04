Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37630 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751957AbcJDLjK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 07:39:10 -0400
Received: by mail-wm0-f48.google.com with SMTP id b201so139291689wmb.0
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2016 04:39:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzYKWJ=uGchDkEOd_jL__h5qiR_BAmkPJ-CiaQC-SF5JtCA@mail.gmail.com>
References: <CANfLQrY6AVJoh8PW+5Ev0seKqnNRxRhK-N735q6Aa4KvdUVEcg@mail.gmail.com>
 <CANfLQrZxEUX0UMwrVNZHps9ztqxmOaeovy34fey2NkErCDDarQ@mail.gmail.com>
 <ed4a7366-3f67-79da-0868-876a69b1da54@broadcom.com> <CABPxzYKWJ=uGchDkEOd_jL__h5qiR_BAmkPJ-CiaQC-SF5JtCA@mail.gmail.com>
From: Gucea Doru <gucea.doru@gmail.com>
Date: Tue, 4 Oct 2016 14:39:08 +0300
Message-ID: <CANfLQrbRvQb5a2AsqY0jGYeuDqC1c_7x8tUbQSm2=QPt1gT5eA@mail.gmail.com> (sfid-20161004_133914_140879_2EBB0DD4)
Subject: Re: bcmdhd: Strange Power Save messages
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Andra Paraschiv <andra.paraschiv7@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 1, 2016 at 2:52 PM, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>>
>>
>> On 29-09-16 13:32, Gucea Doru wrote:
>>> On Tue, Sep 27, 2016 at 12:03 PM, Gucea Doru <gucea.doru@gmail.com> wrote:
>>>> What is the decision triggering the exit from the PS mode immediately
>>>> after the ping request? I am asking this because 802.11 PS legacy
>>>> specifies that the client should wait for a beacon with TIM set in
>>>> order to wake up: in my case, there is no beacon between the ping
>>>> request message and the Null frame that announces the exit from the PS
>>>> mode.
>>>
>>>
>>> Any help would be highly appreciated :)
>>
>> Actually though I already sent you are reply, but alas here it is.
>>
>> bcmdhd is our aosp driver. I am maintaining the upstream brcm80211
>> drivers. Regardless your question is more for firmware running on the
>> device. So like the same behavior would be observed when using brcmfmac
>> with same firmware.
>>
>>> IEEE Std 802.11-2012, section 10.2.1.8 specifies that "when the STA
>>> detects that the bit corresponding to its AID is 1 i the TIM, the STA
>>> shall issue a PS Poll". In my capture there are cases when the STA
>>> exits the PS mode without waiting for a beacon.
>>
>> It is a bit tricky, but the standard does not explicitly say the STA
>> should be in power-save at any other time. So it is difficult to say
>> what event occurred on the STA side to exit PS mode. Also STA means
>> P2P-Client as you say. That means that you have multiple interfaces:
>> regular STA and P2P-Client. So is the STA connected to some other AP or
>> just not connected. wpa_supplicant will do intermittent scan or initiate
>> scheduled scan by which firmware will scan at a certain interval. That
>> is just some things I can come up with and I am sure there are more.

I agree that there may be some events belonging to the regular STA
interface that could trigger the Null Frame (which includes the exit
from PS Mode). However, I would expect to see some management frames
in the air before/after the Null Packet (e.g.: a Probe request in case
of a scheduled scan). But in my case the trigger for the Null frame
seems to be the ping request packet, the scenario is the same every
time: ping request -> Block ACK -> Null Frame (Wireshark trace
confirms this behavior).

I thought that you had a power save optimization algorithm that keeps
the card on a few milliseconds just to see if we can have a fast reply
from the peer. Does this ring a bell? :)

On Sat, Oct 1, 2016 at 3:02 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> Keeping the STA aside, as far as AP is concerned the STA is still in PS,
> so it should set the TIM/DTIM bit to 1 before sending out data to the STA.

Not necessarily, see section 10.2.1.6/l from IEEE Std 802.11-2012:
"When an AP is informed that a STA has changed to the Active mode,
then the AP shall send buffered BUs (if any exist) to the STA without
waiting for a PS Poll...."
