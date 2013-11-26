Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:35949 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479Ab3KZVvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 16:51:11 -0500
Received: by mail-wg0-f53.google.com with SMTP id k14so3391654wgh.8
        for <linux-wireless@vger.kernel.org>; Tue, 26 Nov 2013 13:51:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKnB8xg1zgKWg1x57OmnjkUgtWU_5KRCb0zV+X4E=YFMqrhLDg@mail.gmail.com>
References: <CAKnB8xgAVp+Ti597RN4_kgPLgXpW1JCr4SQaqfqCzy5A4=o3Ow@mail.gmail.com>
 <CAKnB8xh6tWFdiL4kBQ5r3J_YgiiwhHhvQEqC+9F7c=3eAsrYbg@mail.gmail.com>
 <5294E46C.40102@erley.org> <1385490243.7838.16.camel@dcbw.foobar.com>
 <CAEk6gTAXXNFbRTqVNGZWnVBpNSW=HKz3qztdZ1t1vMZLe530Hg@mail.gmail.com>
 <CAKnB8xiEoAch9dpm5hRzW76PO8tt3cKFxB2jUvdCNrJaf5tWrg@mail.gmail.com>
 <52951195.2030206@erley.org> <CAKnB8xg1zgKWg1x57OmnjkUgtWU_5KRCb0zV+X4E=YFMqrhLDg@mail.gmail.com>
From: matt emery <matt@x204.com>
Date: Tue, 26 Nov 2013 21:50:39 +0000
Message-ID: <CAKnB8xir_AHH+e9CuTSOSAiu9vcKMQ26SDYL2E1YAW+OXE=ing@mail.gmail.com> (sfid-20131126_225116_856691_F8811EB7)
Subject: Re: Fwd: Intel 7260
To: Pat Erley <pat-lkml@erley.org>
Cc: Drasko DRASKOVIC <drasko.draskovic@gmail.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That worked but it's killed my bluetooth !
Matthew Emery
07988 197 438



On 26 November 2013 21:28, matt emery <matt@x204.com> wrote:
> dmesg | grep iwl
> [    4.065349] iwlwifi 0000:03:00.0: enabling device (0000 -> 0002)
> [    4.087754] iwlwifi 0000:03:00.0: irq 48 for MSI/MSI-X
> [    4.100012] iwlwifi 0000:03:00.0: loaded firmware version 22.0.7.0
> op_mode iwlmvm
> [    4.146899] iwlwifi 0000:03:00.0: Detected Intel(R) Dual Band
> Wireless AC 7260, REV=0x144
> [    4.149727] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [    4.152321] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [    4.387220] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
> [    4.945622] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [    4.945802] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
>
>
> egrep -rsn 11n /etc/mod*
> /etc/modprobe.d/iwlwifi.conf:8:options iwlwifi 11n_disable=1
>
>
> ^^^ looks like you may have found it :)
>
> ty i'll set it to 0 and let you know what happens
> Matthew Emery
> 07988 197 438
>
>
>
> On 26 November 2013 21:24, Pat Erley <pat-lkml@erley.org> wrote:
>> On 11/26/2013 03:14 PM, matt emery wrote:
>>>
>>> Hi,
>>>
>>> I'm using WPA2/AES and i have other devices connected to the AP using
>>> N, I can't go open as i am resident on a school campus.
>>>
>>> Can you tell me if it is possible to get N with this card on linux, or
>>> should i wait for a newer firmware or something?
>>>
>>> thanks
>>>
>>> Matt
>>> Matthew Emery
>>> 07988 197 438
>>>
>>>
>>>
>>> On 26 November 2013 20:46, Drasko DRASKOVIC <drasko.draskovic@gmail.com>
>>> wrote:
>>>>
>>>> On Tue, Nov 26, 2013 at 7:24 PM, Dan Williams <dcbw@redhat.com> wrote:
>>>>>>
>>>>>> While I'm not certain about your AP or the 7260 driver, I believe
>>>>>> 802.11n technically requires WPA2 encryption.  Try turning that on and
>>>>>> testing again.
>>>>>
>>>>>
>>>>> This is true, but...
>>>>
>>>>
>>>> 802.11n HT prevents WPA:
>>>>
>>>> http://www.slideshare.net/HPenterprise/demystifying-80211n-and-wpawpa2,slide
>>>> 4
>>>>
>>>> I do not see however that using no encryption is prevented by the
>>>> standard...
>>>>
>>>> BR,
>>>> Drasko
>>>
>>> --
>>
>>
>> then 11n *SHOULD* be possible.  Perhaps 11n is disabled with a module
>> parameter by your distribution?
>>
>> The output of:
>>   dmesg | grep iwl
>>
>> might provide some insight(I see: "iwlwifi 0000:03:00.0 wlan0: disabling
>> HT/VHT due to WEP/TKIP use" on my system connecting to a WPA1 AP.
>>
>> The output of:
>>   egrep -rsn 11n /etc/mod*
>>
>> might help determine if the 11n_disable kernel parameter is set by your
>> distribution.
>>
