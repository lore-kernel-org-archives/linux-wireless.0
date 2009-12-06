Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-72-92-88-10.phlapa.fios.verizon.net ([72.92.88.10]:42592
	"EHLO smtp.roinet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934031AbZLFSKe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 13:10:34 -0500
Message-ID: <4B1BF399.1020103@roinet.com>
Date: Sun, 06 Dec 2009 13:10:33 -0500
From: David Acker <dacker@roinet.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	patrik.flykt@nokia.com
Subject: Re: WMM classification guideline for applications?
References: <87d42u6dnd.fsf@purkki.valot.fi> <4B19276F.5080604@roinet.com>	 <878wdi69u9.fsf@purkki.valot.fi>  <4B1933F5.2010408@roinet.com> <1260096387.3461.2.camel@johannes.local>
In-Reply-To: <1260096387.3461.2.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2009-12-04 at 11:08 -0500, David Acker wrote:
> 
>> I am not an expert on how the kernel handles vlans, but it appears that 
>> the priority field's value is set by the user space VLAN creation tools 
>> through an ioctl with SET_VLAN_EGRESS_PRIORITY_CMD which calls 
>> vlan_dev_set_egress_priority to map an skb priority to a vlan priority.
>> vlan_dev_hard_header then uses this information to populate the vlan 
>> priority field based on the skb priority field.
>>
>> In this case it would seem that skb priority and the vlan priority are 
>> both set and there may be a non-trivial mapping between the two. 
> 
> But doesn't that also mean that mac80211 can happily ignore the VLAN
> priority in the packet, because the vlan code will have propagated it to
> the skb->priority, if the administrator wishes to use it?

You are correct on rx.  The tricky part is the non-trivial mapping on 
tx.  If mac80211 only looks at the skb->priority and assumes priority 0 
means best effort, the code could be missing that skb->priority 0 maps 
to vlan priority 7.  If we define that mac80211 only looks at 
skb->priority, perhaps we should allow user space control of the mapping 
of the skb->priority to WMM priority queue.  This could be similar to 
the mapping capabilities in the VLAN code.  That way, an admin can make 
sure that the skb priority is mapped to both an appropriate vlan 
priority and an appropriate WMM priority queue.
-ack


__________ Information from ESET Smart Security, version of virus signature database 4663 (20091205) __________

The message was checked by ESET Smart Security.

http://www.eset.com


