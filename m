Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from erley.org ([97.107.129.9]:34542 "EHLO remote.erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756572Ab3KZVYm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 16:24:42 -0500
Message-ID: <52951195.2030206@erley.org> (sfid-20131126_222446_005746_960B0D41)
Date: Tue, 26 Nov 2013 15:24:37 -0600
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: matt emery <matt@x204.com>,
	Drasko DRASKOVIC <drasko.draskovic@gmail.com>
CC: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Subject: Re: Fwd: Intel 7260
References: <CAKnB8xgAVp+Ti597RN4_kgPLgXpW1JCr4SQaqfqCzy5A4=o3Ow@mail.gmail.com> <CAKnB8xh6tWFdiL4kBQ5r3J_YgiiwhHhvQEqC+9F7c=3eAsrYbg@mail.gmail.com> <5294E46C.40102@erley.org> <1385490243.7838.16.camel@dcbw.foobar.com> <CAEk6gTAXXNFbRTqVNGZWnVBpNSW=HKz3qztdZ1t1vMZLe530Hg@mail.gmail.com> <CAKnB8xiEoAch9dpm5hRzW76PO8tt3cKFxB2jUvdCNrJaf5tWrg@mail.gmail.com>
In-Reply-To: <CAKnB8xiEoAch9dpm5hRzW76PO8tt3cKFxB2jUvdCNrJaf5tWrg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/26/2013 03:14 PM, matt emery wrote:
> Hi,
>
> I'm using WPA2/AES and i have other devices connected to the AP using
> N, I can't go open as i am resident on a school campus.
>
> Can you tell me if it is possible to get N with this card on linux, or
> should i wait for a newer firmware or something?
>
> thanks
>
> Matt
> Matthew Emery
> 07988 197 438
>
>
>
> On 26 November 2013 20:46, Drasko DRASKOVIC <drasko.draskovic@gmail.com> wrote:
>> On Tue, Nov 26, 2013 at 7:24 PM, Dan Williams <dcbw@redhat.com> wrote:
>>>> While I'm not certain about your AP or the 7260 driver, I believe
>>>> 802.11n technically requires WPA2 encryption.  Try turning that on and
>>>> testing again.
>>>
>>> This is true, but...
>>
>> 802.11n HT prevents WPA:
>> http://www.slideshare.net/HPenterprise/demystifying-80211n-and-wpawpa2,slide
>> 4
>>
>> I do not see however that using no encryption is prevented by the standard...
>>
>> BR,
>> Drasko
> --

then 11n *SHOULD* be possible.  Perhaps 11n is disabled with a module 
parameter by your distribution?

The output of:
   dmesg | grep iwl

might provide some insight(I see: "iwlwifi 0000:03:00.0 wlan0: disabling 
HT/VHT due to WEP/TKIP use" on my system connecting to a WPA1 AP.

The output of:
   egrep -rsn 11n /etc/mod*

might help determine if the 11n_disable kernel parameter is set by your 
distribution.

