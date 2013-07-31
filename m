Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3.ugent.be ([157.193.49.127]:53858 "EHLO smtp3.ugent.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759763Ab3GaNpl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 09:45:41 -0400
Received: from localhost (mcheck2.ugent.be [157.193.49.249])
	by smtp3.ugent.be (Postfix) with ESMTP id CDB57C375
	for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 15:45:39 +0200 (CEST)
Received: from smtp3.ugent.be ([157.193.49.127])
	by localhost (mcheck2.UGent.be [157.193.43.11]) (amavisd-new, port 10024)
	with ESMTP id MBw7r8v73g33 for <linux-wireless@vger.kernel.org>;
	Wed, 31 Jul 2013 15:45:39 +0200 (CEST)
Received: from mail-lb0-f174.google.com (mail-lb0-f174.google.com [209.85.217.174])
	(Authenticated sender: mathieu.devos@ugent.be)
	by smtp3.ugent.be (Postfix) with ESMTPSA id E8B5DC36F
	for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 15:45:38 +0200 (CEST)
Received: by mail-lb0-f174.google.com with SMTP id w20so609227lbh.33
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 06:45:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51F90937.9080009@broadcom.com>
References: <CAE_+Soy5=MfUUahaP3Ka2onp+jP9aupbhGu_QHco=CP7Y9sqhQ@mail.gmail.com>
	<51F8E228.9080600@broadcom.com>
	<CAE_+Soyxz-RfyVeg-Z4Fv5tmUtH=9wutxgM0CGjHEne9zJq+Kg@mail.gmail.com>
	<51F8EF8F.90109@broadcom.com>
	<CAE_+SozB3cE36SKaHsyO9B1Eypm7KZFExV_uWBSsoiQ-Rn66Dw@mail.gmail.com>
	<51F90937.9080009@broadcom.com>
Date: Wed, 31 Jul 2013 15:45:38 +0200
Message-ID: <CAE_+Soy4Hy+uMAsn30PX9QpqY=Jah2f5qUCa=MkCskJczQB05w@mail.gmail.com> (sfid-20130731_154548_390459_D8E8CC9F)
Subject: Re: Skb and ieee80211 headers
From: Mathieu Devos <mathieu.devos@ugent.be>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alright,

Seems like I have fixed some issues while added some others. Since I
assume that when my hook gets activated the data pointer should be at
the start of the 802.3 header I casted an ethhdr (8023) on top of that
and it seems that on my notebook this is handled correctly (I can
actually check on my own mac addr and see that these frames are
for/from me).
The issue with android: the data pointer (see previous mails) is
totally off and causes a full blown kernel crash. Trying to set it
manually leaves me with nothing really. Could more information about
skb->data manipulation be in those drivers and is there a reason why
not everything is ended with the same data structure (thus
standardizing the part where the hook comes in). My next issue is with
mac_header that seems off just as much in both my notebook LKM and in
my android device (when casting 8023 or 80211 headers on them they
deliver totally wrong headers).
Somebody in the office told me that the 8023 header is added after the
80211 and thus to my logic when casting skb->data -
sizeof(*wirelessheader) I should end at the start of the 80211 header.
This however is wrong, are there more padding bytes present and if so,
how much would I have to move the pointer or is do I have to use a
whole other function for this.

A quick remark as to why I'm doing all this stuff: this is preparation
for my master thesis where I'll be researching the possibility of RINA
(instead of TCP/IP) in the wireless stack (android specifically).
Since this is preparation work I'd love to end this with just having
an sk_buff with correctly placed 802.3 header (works on my notebook,
not on android device) and with a properly set up 802.11 header (so I
can later on map functions from/to rina to 802.3/802.11).

Thanks again for the quick answers and the already provided help.

Kind regards,
Mathieu Devos

On Wed, Jul 31, 2013 at 2:55 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 07/31/2013 02:39 PM, Mathieu Devos wrote:
>>
>> Hi,
>>
>> The wireless chip is a Broadcast BCM4330 chip. After looking around a
>> bit I found that this is a fullMAC and links to the driver on
>> wireless.kernel: http://wireless.kernel.org/en/users/Drivers/brcm80211
>> and also links directly to android itself:
>> https://android.googlesource.com/platform/hardware/broadcom/wlan
>
>
> I suspected. The bcm4330 is indeed a fullmac device, which means the 802.11
> stack is running on the device. The driver on Android is located under:
>
> https://android.googlesource.com/kernel/samsung/+/android-samsung-3.0-ics-mr1/drivers/net/wireless/bcmdhd/
>
> Not sure which android version you have.
>
> The brcm80211 on wireless.kernel.org is the upstream linux driver.
>
> Gr. AvS
>
>
>> Still trying to learn a lot in this tightly packed world of protocol
>> stacks, wireless and all the other poisons. Seems like I still have a
>> long way to go. Thank you already for helping me out with these issues
>> and taking the time to explain these things to me.
>>
>> Kind regards,
>> Mathieu Devos
>>
>> On Wed, Jul 31, 2013 at 1:05 PM, Arend van Spriel <arend@broadcom.com>
>> wrote:
>>>
>>> On 07/31/2013 12:28 PM, Mathieu Devos wrote:
>>>>
>>>>
>>>> Hi,
>>>>
>>>> It's an android smartphone (I 9100 - Samsung galaxy S2) so it does not
>>>> have a normal ethernet 802.3 input even. I check before selecting the
>>>> device that it's wireless (through ieee80211_ptr) and this properly
>>>> returns the wlan0 device which should be on the 80211 standard.
>>>
>>>
>>>
>>> *sigh* Welcome in the world of protocol stacks, wireless, networking
>>> (choose
>>> your poison). Let me draw the picture.
>>>
>>>          o user-space
>>>          |
>>> ----------------------
>>>          | kernel
>>>    +-----------+
>>>    |    NET    | networking subsystem, ie. TCP/IP stack
>>>    +-----------+
>>>          | 802.3
>>> +----------------+
>>> |       | driver |
>>> | +------------+ |
>>> | |802.11 stack| |
>>> | +------------+ |
>>> |       | 802.11 |
>>> +----------------+
>>>          |
>>>          o RF
>>>
>>> The device hooks up to the networking subsystem as an ethernet device and
>>> as
>>> such it receives 802.3 packets. These are converted to 802.11 packets by
>>> the
>>> 802.11 stack. Now depending on your device that happens in the device
>>> driver
>>> or on the device itself. Another option is that this is done by mac80211
>>> (kernel provided 802.11 stack), but that is probably not the case, but to
>>> be
>>> sure I ask again: what wireless device do you have in your galaxy S2?
>>>
>>> Gr. AvS
>>>
>>>
>>>> My goal is to get the ieee80211_header properly on the skb with this
>>>> device, but some of the pointers and original data in the skb seem
>>>> totally off. This leaves me clueless as to where to put this
>>>> ieee80211_header.
>>>> I've tried putting it right on skb->head (wrong I know, but I was
>>>> getting desperate), on skb->mac_header (also wrong, no idea why
>>>> though), I went back from skb->tail with len and even added ETH_HLEN
>>>> to that as well because you can see that before my hook gets
>>>> activated: skb_pull_inline(skb, ETH_HLEN);
>>>> In the end I'm left with a header that is forced onto data but with a
>>>> wrong origin pointer thus basically leaving me with all wrong data in
>>>> the header.
>>>>
>>>> Kind regards,
>>>> Mathieu Devos
>>>>
>>>> On Wed, Jul 31, 2013 at 12:08 PM, Arend van Spriel <arend@broadcom.com>
>>>> wrote:
>>>>>
>>>>>
>>>>> On 07/31/2013 11:39 AM, Mathieu Devos wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> I hope this is the right place to ask for a little bit of help as I'm
>>>>>> currently beyond stuck on a challenge I'm trying to accomplish. I'm
>>>>>> trying to write a "simple" LKM that properly uses a ieee80211 header
>>>>>> to print information about the mac addresses (addr1->addr4) and later
>>>>>> down the road try to send my own data.
>>>>>>
>>>>>> I only need to get L2 working, no need for TCP/IP, just a proper
>>>>>> ieee80211 based on input from skb would be huge for me.
>>>>>>
>>>>>> So my issue: when placing the ieee80211 on my mac_header after I hook
>>>>>> my skb from my wireless device (wlan0 on android - I9100)
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> Not sure what you goal is, but what wireless device is that? You may
>>>>> just
>>>>> get 802.3 packets from the device.
>>>>>
>>>>> Gr. AvS
>>>>>
>>>>>
>>>>>> I get a huge
>>>>>> amount of zero's and random(?) numbers when trying to print the
>>>>>> addresses. This leads me to the first conclusion that mac_header is
>>>>>> placed wrong when using 80211. After that I saw a lot of people just
>>>>>> using the skb->data pointer. Now this gives even weirder issues for me
>>>>>> and actually totally crashes my kernel.
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>
>>>
>>>
>>
>
>
