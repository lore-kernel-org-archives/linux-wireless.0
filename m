Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3072 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab3GaLGB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 07:06:01 -0400
Message-ID: <51F8EF8F.90109@broadcom.com> (sfid-20130731_130609_084468_C4D40260)
Date: Wed, 31 Jul 2013 13:05:51 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Mathieu Devos" <mathieu.devos@ugent.be>
cc: linux-wireless@vger.kernel.org
Subject: Re: Skb and ieee80211 headers
References: <CAE_+Soy5=MfUUahaP3Ka2onp+jP9aupbhGu_QHco=CP7Y9sqhQ@mail.gmail.com>
 <51F8E228.9080600@broadcom.com>
 <CAE_+Soyxz-RfyVeg-Z4Fv5tmUtH=9wutxgM0CGjHEne9zJq+Kg@mail.gmail.com>
In-Reply-To: <CAE_+Soyxz-RfyVeg-Z4Fv5tmUtH=9wutxgM0CGjHEne9zJq+Kg@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/31/2013 12:28 PM, Mathieu Devos wrote:
> Hi,
>
> It's an android smartphone (I 9100 - Samsung galaxy S2) so it does not
> have a normal ethernet 802.3 input even. I check before selecting the
> device that it's wireless (through ieee80211_ptr) and this properly
> returns the wlan0 device which should be on the 80211 standard.

*sigh* Welcome in the world of protocol stacks, wireless, networking 
(choose your poison). Let me draw the picture.

	o user-space
	|
----------------------
	| kernel
   +-----------+
   |    NET    | networking subsystem, ie. TCP/IP stack
   +-----------+
	| 802.3
+----------------+
|	| driver |
| +------------+ |
| |802.11 stack| |
| +------------+ |
|       | 802.11 |
+----------------+
	|
	o RF

The device hooks up to the networking subsystem as an ethernet device 
and as such it receives 802.3 packets. These are converted to 802.11 
packets by the 802.11 stack. Now depending on your device that happens 
in the device driver or on the device itself. Another option is that 
this is done by mac80211 (kernel provided 802.11 stack), but that is 
probably not the case, but to be sure I ask again: what wireless device 
do you have in your galaxy S2?

Gr. AvS

> My goal is to get the ieee80211_header properly on the skb with this
> device, but some of the pointers and original data in the skb seem
> totally off. This leaves me clueless as to where to put this
> ieee80211_header.
> I've tried putting it right on skb->head (wrong I know, but I was
> getting desperate), on skb->mac_header (also wrong, no idea why
> though), I went back from skb->tail with len and even added ETH_HLEN
> to that as well because you can see that before my hook gets
> activated: skb_pull_inline(skb, ETH_HLEN);
> In the end I'm left with a header that is forced onto data but with a
> wrong origin pointer thus basically leaving me with all wrong data in
> the header.
>
> Kind regards,
> Mathieu Devos
>
> On Wed, Jul 31, 2013 at 12:08 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> On 07/31/2013 11:39 AM, Mathieu Devos wrote:
>>>
>>> Hi,
>>>
>>> I hope this is the right place to ask for a little bit of help as I'm
>>> currently beyond stuck on a challenge I'm trying to accomplish. I'm
>>> trying to write a "simple" LKM that properly uses a ieee80211 header
>>> to print information about the mac addresses (addr1->addr4) and later
>>> down the road try to send my own data.
>>>
>>> I only need to get L2 working, no need for TCP/IP, just a proper
>>> ieee80211 based on input from skb would be huge for me.
>>>
>>> So my issue: when placing the ieee80211 on my mac_header after I hook
>>> my skb from my wireless device (wlan0 on android - I9100)
>>
>>
>> Not sure what you goal is, but what wireless device is that? You may just
>> get 802.3 packets from the device.
>>
>> Gr. AvS
>>
>>
>>> I get a huge
>>> amount of zero's and random(?) numbers when trying to print the
>>> addresses. This leads me to the first conclusion that mac_header is
>>> placed wrong when using 80211. After that I saw a lot of people just
>>> using the skb->data pointer. Now this gives even weirder issues for me
>>> and actually totally crashes my kernel.
>>
>>
>>
>>
>


