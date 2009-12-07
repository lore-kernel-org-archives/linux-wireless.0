Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-72-92-88-10.phlapa.fios.verizon.net ([72.92.88.10]:53534
	"EHLO smtp.roinet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757674AbZLGBfA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 20:35:00 -0500
Message-ID: <4B1C5BC3.70108@roinet.com>
Date: Sun, 06 Dec 2009 20:34:59 -0500
From: David Acker <dacker@roinet.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	patrik.flykt@nokia.com
Subject: Re: WMM classification guideline for applications?
References: <87d42u6dnd.fsf@purkki.valot.fi> <4B19276F.5080604@roinet.com>	 <878wdi69u9.fsf@purkki.valot.fi>  <4B1933F5.2010408@roinet.com>	 <1260096387.3461.2.camel@johannes.local>  <4B1BF399.1020103@roinet.com> <1260124341.3461.22.camel@johannes.local>
In-Reply-To: <1260124341.3461.22.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sun, 2009-12-06 at 13:10 -0500, David Acker wrote:
>> Johannes Berg wrote:
>>> On Fri, 2009-12-04 at 11:08 -0500, David Acker wrote:
>>>
>>>> I am not an expert on how the kernel handles vlans, but it appears that 
>>>> the priority field's value is set by the user space VLAN creation tools 
>>>> through an ioctl with SET_VLAN_EGRESS_PRIORITY_CMD which calls 
>>>> vlan_dev_set_egress_priority to map an skb priority to a vlan priority.
>>>> vlan_dev_hard_header then uses this information to populate the vlan 
>>>> priority field based on the skb priority field.
>>>>
>>>> In this case it would seem that skb priority and the vlan priority are 
>>>> both set and there may be a non-trivial mapping between the two. 
>>> But doesn't that also mean that mac80211 can happily ignore the VLAN
>>> priority in the packet, because the vlan code will have propagated it to
>>> the skb->priority, if the administrator wishes to use it?
>> You are correct on rx.
> 
> I don't see how RX matters at all, to mac80211?
When a packet is received on a higher priority WMM queue, should it 
reflect that in skb->priority?

> 
>>   The tricky part is the non-trivial mapping on 
>> tx.  If mac80211 only looks at the skb->priority and assumes priority 0 
>> means best effort, the code could be missing that skb->priority 0 maps 
>> to vlan priority 7.  If we define that mac80211 only looks at 
>> skb->priority, perhaps we should allow user space control of the mapping 
>> of the skb->priority to WMM priority queue.  This could be similar to 
>> the mapping capabilities in the VLAN code.  That way, an admin can make 
>> sure that the skb priority is mapped to both an appropriate vlan 
>> priority and an appropriate WMM priority queue.
> 
> I don't understand. If I TX a packet, on a specific VLAN, then it'll go
> through the VLAN code first, get 802.1q tags and then be passed to
> mac80211, which ought be be fine with just looking at the priority value
> the packet now got.

The packet will get tags which will contain the vlan priority mapped 
from the original skb->priority.  What if the administrator wanted all 
applications that used a specific VLAN to have high priority.  Without 
having to change the applications, he could make the mapping of skb 
priority 0 to go a high priority VLAN.  It would be nice if he could 
also make skb->priority 0 go to a high priority WMM queue.  It is fine 
to base every thing on the skb priority but it would be nice if the 
mapping of skb priority to WMM queue was not static.  It should have a 
user space API that is similar in functionality to the VLAN priority API.

As an example, I have a system where a wireless router has multiple 
SSIDs.  One SSID is for guests and has little or no security and is on 
VLAN 1 with a VLAN priority of 0.  Another SSID is for system 
configuration and has high security (802.11i) and is on VLAN 2 with a 
VLAN priority of 7.  The VLAN tagging is handled by the router; clients 
send normal frames.  Their applications do not require any changes.  The 
router will give higher priority to the system configuration VLAN during 
any queuing.  When the packets are sent, I have code (in madwifi in this 
example) to put the packets with VLAN priority 0 in the best effort 
queue while packets in vlan priority 7 go into the voice queue.  This 
code also sets the skb->priority field based on the VLAN priority.  This 
allows the queuing of the packet to the wifi0 device to reflect the 
appropriate ordering.  The router supports meshing such that the WMM 
queues are used for packets between the routers.  In this manner, the 
QoS required for the higher priority VLAN is reflected through the whole 
network, including the eventual wired destination.

To support this in mac80211, it would be nice to specify the mapping of 
skb->priority to WMM queue on a per SSID basis.  This would allow QoS to 
be application driven or SSID driven.
-ack


__________ Information from ESET Smart Security, version of virus signature database 4665 (20091206) __________

The message was checked by ESET Smart Security.

http://www.eset.com


