Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.ugent.be ([157.193.71.182]:58366 "EHLO smtp1.ugent.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757712Ab3HBHtZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 03:49:25 -0400
Received: from localhost (mcheck2.ugent.be [157.193.49.249])
	by smtp1.ugent.be (Postfix) with ESMTP id C50098590
	for <linux-wireless@vger.kernel.org>; Fri,  2 Aug 2013 09:49:23 +0200 (CEST)
Received: from smtp1.ugent.be ([157.193.71.182])
	by localhost (mcheck2.UGent.be [157.193.43.11]) (amavisd-new, port 10024)
	with ESMTP id 6t4ejheTKmao for <linux-wireless@vger.kernel.org>;
	Fri,  2 Aug 2013 09:49:23 +0200 (CEST)
Received: from mail-la0-f43.google.com (mail-la0-f43.google.com [209.85.215.43])
	(Authenticated sender: mathieu.devos@ugent.be)
	by smtp1.ugent.be (Postfix) with ESMTPSA id CD7FD8415
	for <linux-wireless@vger.kernel.org>; Fri,  2 Aug 2013 09:49:22 +0200 (CEST)
Received: by mail-la0-f43.google.com with SMTP id ep20so221556lab.30
        for <linux-wireless@vger.kernel.org>; Fri, 02 Aug 2013 00:49:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE_+Soydmjwp=gXxc74R3BGczbU7OKF2U3hehBi3kqGaEv_pwg@mail.gmail.com>
References: <CAE_+Soy5=MfUUahaP3Ka2onp+jP9aupbhGu_QHco=CP7Y9sqhQ@mail.gmail.com>
	<51F8E228.9080600@broadcom.com>
	<CAE_+Soyxz-RfyVeg-Z4Fv5tmUtH=9wutxgM0CGjHEne9zJq+Kg@mail.gmail.com>
	<51F8EF8F.90109@broadcom.com>
	<CAE_+SozB3cE36SKaHsyO9B1Eypm7KZFExV_uWBSsoiQ-Rn66Dw@mail.gmail.com>
	<51F90937.9080009@broadcom.com>
	<CAE_+Soy4Hy+uMAsn30PX9QpqY=Jah2f5qUCa=MkCskJczQB05w@mail.gmail.com>
	<51F9276F.1040908@broadcom.com>
	<CAE_+Soydmjwp=gXxc74R3BGczbU7OKF2U3hehBi3kqGaEv_pwg@mail.gmail.com>
Date: Fri, 2 Aug 2013 09:49:22 +0200
Message-ID: <CAE_+SoyLKkzkjHLdf6rO1m2+KJaF7ZuG6GQBWpFWRScrgWmWWQ@mail.gmail.com> (sfid-20130802_094928_891238_65E9B69D)
Subject: Re: Skb and ieee80211 headers
From: Mathieu Devos <mathieu.devos@ugent.be>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

An update is in order here I believe (and an apology because I
resorted to asking my questions on IRC and not sticking to the mailing
list, for that: sorry).
Let's start things off quickly with my main goal with this: the code
that I'm trying to write is supposed to be an adapter for a new type
of internet (RINA), this is in function of my master thesis (I'm new
to Linux Kernel itself). So what exactly does this mean? I'd like to
be able to hook packets (skb) in the kernel with an LKM and just use
one layer (datalink layer) with the hardware layer being handled by
the drivers and the hardware itself. Everything on top of that should
be RINA specific code.
The specifics about the master thesis is that this all should be done
on android, thus using the wireless stack. I believed that in an
skbuff you had the formed 802.3 header through drivers but you still
also had the original 802.11 header, this however, is now proven
wrong, the 802.11 header is thrown out after the drivers are done with
it thus it's impossible for me to map RINA to the 802.11 header. After
resuming testing with this news I'm still left with a couple of
questions however:

- Can I still use the added functionality of 802.11 as compared to
802.3 by talking directly to the device and setting it's fields? I'm
thinking of using "struct wireless_device" and/or "struct wiphy" and
the functions that come with it.

- Is it possible to find a general form of skb frame with correctly
set headers? I have currently tested my code
(https://github.com/mathieudevos/kernelmodules/blob/master/ethernet_test.c)
and on one android device (galaxy S2 I9100, BCM4330 wireless chip) I
had my 802.3 header by at my skb->head. On my own htc one X (htc
endeavoru, wireless chip unknown still) I had my 802.3 header at my
skb->mac_header and on my notebook (wireless 5100 AGN) this header was
present on skb->data. Is it coincidence that these 3 are totally
different and is there a function (that perhaps calls the drivers) to
set these skb's in the correct prepared form? And if so, will this
break when I void the layers on top of the mac layer.

While I know that a part of this still needs to be researched, for
instance say it's possible to set certain fields of the device to use
added 802.11 functionality I won't be setting the channel manually,
that's still left to the driver, but other added functions might be
more useful for RINA.
What I'm hoping to achieve before really heading off into this new
linux adventure is to be able to properly receive an SKB that has the
same format on my devices and later down the road try to send set up
an SKB and send that one myself.

I'd like to finish with another apology for not sticking to the
mailing list, for that I'm truly sorry.


Kind regards,
Mathieu Devos



On Wed, Jul 31, 2013 at 5:11 PM, Mathieu Devos <mathieu.devos@ugent.be> wrote:
> This is my hook: it gets called after I set dev to wlan0. I used a
> guide for this and it seems to work for my notebook where I'm able to
> find the 802.3 header but still no 802.11.
>
> static int ptype_function(struct sk_buff *skb, struct net_device *dev,
> struct packet_type *ptype, struct net_device *dev2);
>
> static void throw_hook(struct net_device *dev){
>    ptype.type = htons(ETH_P_ALL);
>    ptype.func = &ptype_function;
>    ptype.dev = dev;
>    dev_add_pack(&ptype);
>    printk(KERN_CRIT "Done setting up packet type");
> }
>
> All code can be found here:
> android: https://github.com/mathieudevos/kernelmodules/blob/master/ethernet_test.c
> notebook: https://github.com/mathieudevos/wifi_kernelmodules/blob/master/ethernet_test.c
>
> Kind regards,
> Mathieu Devos
>
> On Wed, Jul 31, 2013 at 5:04 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> On 07/31/2013 03:45 PM, Mathieu Devos wrote:
>>>
>>> Alright,
>>>
>>> Seems like I have fixed some issues while added some others. Since I
>>> assume that when my hook gets activated the data pointer should be at
>>> the start of the 802.3 header I casted an ethhdr (8023) on top of that
>>> and it seems that on my notebook this is handled correctly (I can
>>> actually check on my own mac addr and see that these frames are
>>> for/from me).
>>
>>
>> How does your hook work? Are you intercepting packets?
>>
>> Regards,
>> Arend
>>
>>
>>> On Wed, Jul 31, 2013 at 2:55 PM, Arend van Spriel <arend@broadcom.com>
>>> wrote:
>>>>
>>>> On 07/31/2013 02:39 PM, Mathieu Devos wrote:
>>>>>
>>>>>
>>>>> Hi,
>>>>>
>>>>> The wireless chip is a Broadcast BCM4330 chip. After looking around a
>>>>> bit I found that this is a fullMAC and links to the driver on
>>>>> wireless.kernel: http://wireless.kernel.org/en/users/Drivers/brcm80211
>>>>> and also links directly to android itself:
>>>>> https://android.googlesource.com/platform/hardware/broadcom/wlan
>>>>
>>>>
>>>>
>>>> I suspected. The bcm4330 is indeed a fullmac device, which means the
>>>> 802.11
>>>> stack is running on the device. The driver on Android is located under:
>>>>
>>>>
>>>> https://android.googlesource.com/kernel/samsung/+/android-samsung-3.0-ics-mr1/drivers/net/wireless/bcmdhd/
>>>>
>>>> Not sure which android version you have.
>>>>
>>>> The brcm80211 on wireless.kernel.org is the upstream linux driver.
>>>>
>>>> Gr. AvS
>>>>
>>>>
>>>>> Still trying to learn a lot in this tightly packed world of protocol
>>>>> stacks, wireless and all the other poisons. Seems like I still have a
>>>>> long way to go. Thank you already for helping me out with these issues
>>>>> and taking the time to explain these things to me.
>>>>>
>>>>> Kind regards,
>>>>> Mathieu Devos
>>>>>
>>>>> On Wed, Jul 31, 2013 at 1:05 PM, Arend van Spriel <arend@broadcom.com>
>>>>> wrote:
>>>>>>
>>>>>>
>>>>>> On 07/31/2013 12:28 PM, Mathieu Devos wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>> It's an android smartphone (I 9100 - Samsung galaxy S2) so it does not
>>>>>>> have a normal ethernet 802.3 input even. I check before selecting the
>>>>>>> device that it's wireless (through ieee80211_ptr) and this properly
>>>>>>> returns the wlan0 device which should be on the 80211 standard.
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> *sigh* Welcome in the world of protocol stacks, wireless, networking
>>>>>> (choose
>>>>>> your poison). Let me draw the picture.
>>>>>>
>>>>>>           o user-space
>>>>>>           |
>>>>>> ----------------------
>>>>>>           | kernel
>>>>>>     +-----------+
>>>>>>     |    NET    | networking subsystem, ie. TCP/IP stack
>>>>>>     +-----------+
>>>>>>           | 802.3
>>>>>> +----------------+
>>>>>> |       | driver |
>>>>>> | +------------+ |
>>>>>> | |802.11 stack| |
>>>>>> | +------------+ |
>>>>>> |       | 802.11 |
>>>>>> +----------------+
>>>>>>           |
>>>>>>           o RF
>>>>>>
>>>>>> The device hooks up to the networking subsystem as an ethernet device
>>>>>> and
>>>>>> as
>>>>>> such it receives 802.3 packets. These are converted to 802.11 packets
>>>>>> by
>>>>>> the
>>>>>> 802.11 stack. Now depending on your device that happens in the device
>>>>>> driver
>>>>>> or on the device itself. Another option is that this is done by
>>>>>> mac80211
>>>>>> (kernel provided 802.11 stack), but that is probably not the case, but
>>>>>> to
>>>>>> be
>>>>>> sure I ask again: what wireless device do you have in your galaxy S2?
>>>>>>
>>>>>> Gr. AvS
>>>>>>
>>>>>>
>>>>>>> My goal is to get the ieee80211_header properly on the skb with this
>>>>>>> device, but some of the pointers and original data in the skb seem
>>>>>>> totally off. This leaves me clueless as to where to put this
>>>>>>> ieee80211_header.
>>>>>>> I've tried putting it right on skb->head (wrong I know, but I was
>>>>>>> getting desperate), on skb->mac_header (also wrong, no idea why
>>>>>>> though), I went back from skb->tail with len and even added ETH_HLEN
>>>>>>> to that as well because you can see that before my hook gets
>>>>>>> activated: skb_pull_inline(skb, ETH_HLEN);
>>>>>>> In the end I'm left with a header that is forced onto data but with a
>>>>>>> wrong origin pointer thus basically leaving me with all wrong data in
>>>>>>> the header.
>>>>>>>
>>>>>>> Kind regards,
>>>>>>> Mathieu Devos
>>>>>>>
>>>>>>> On Wed, Jul 31, 2013 at 12:08 PM, Arend van Spriel
>>>>>>> <arend@broadcom.com>
>>>>>>> wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> On 07/31/2013 11:39 AM, Mathieu Devos wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Hi,
>>>>>>>>>
>>>>>>>>> I hope this is the right place to ask for a little bit of help as
>>>>>>>>> I'm
>>>>>>>>> currently beyond stuck on a challenge I'm trying to accomplish. I'm
>>>>>>>>> trying to write a "simple" LKM that properly uses a ieee80211 header
>>>>>>>>> to print information about the mac addresses (addr1->addr4) and
>>>>>>>>> later
>>>>>>>>> down the road try to send my own data.
>>>>>>>>>
>>>>>>>>> I only need to get L2 working, no need for TCP/IP, just a proper
>>>>>>>>> ieee80211 based on input from skb would be huge for me.
>>>>>>>>>
>>>>>>>>> So my issue: when placing the ieee80211 on my mac_header after I
>>>>>>>>> hook
>>>>>>>>> my skb from my wireless device (wlan0 on android - I9100)
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> Not sure what you goal is, but what wireless device is that? You may
>>>>>>>> just
>>>>>>>> get 802.3 packets from the device.
>>>>>>>>
>>>>>>>> Gr. AvS
>>>>>>>>
>>>>>>>>
>>>>>>>>> I get a huge
>>>>>>>>> amount of zero's and random(?) numbers when trying to print the
>>>>>>>>> addresses. This leads me to the first conclusion that mac_header is
>>>>>>>>> placed wrong when using 80211. After that I saw a lot of people just
>>>>>>>>> using the skb->data pointer. Now this gives even weirder issues for
>>>>>>>>> me
>>>>>>>>> and actually totally crashes my kernel.
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>
>>>>>>
>>>>>>
>>>>>
>>>>
>>>>
>>>
>>
>>
