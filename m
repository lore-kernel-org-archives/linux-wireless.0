Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:38539 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbYFZUne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 16:43:34 -0400
Message-ID: <4863FFBB.9020504@lwfinger.net> (sfid-20080626_224338_199071_EF5EE646)
Date: Thu, 26 Jun 2008 15:44:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
CC: Pavel Roskin <proski@gnu.org>, Matthew Garrett <mjg@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	herton@mandriva.com.br, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, andreamrl@tiscali.it, linville@redhat.com
Subject: Re: [RFC][PATCH] Realtek 8187B wireless support with product id	0x8197/0x8189
References: <779389.39286.qm@web23108.mail.ird.yahoo.com>	 <48630FE7.7060800@lwfinger.net> <4863D05A.7070801@yahoo.co.uk>	 <4863E113.1040609@lwfinger.net> <1214505894.18729.11.camel@dv> <4863F1DE.3080503@yahoo.co.uk>
In-Reply-To: <4863F1DE.3080503@yahoo.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> Pavel Roskin wrote:
>> On Thu, 2008-06-26 at 13:33 -0500, Larry Finger wrote:
>>
>>> Do I understand correctly that it might be better to check for the 
>>> existence of endpoint 02 for an 8187 device? Or would it be better to 
>>> look for endpoint 12 to set it as an 8187B?
>>
>> It's probably OK either way, but I would look at some number that takes
>> more than just 2 values (true and false).  Say, the number of endpoints
>> would be such number.  This way, it there is some elusive 8187A or
>> 8187C, it may have a different number and won't be mistaken for known
>> chipsets.
>>
>> Of course, we cannot guarantee anything.  It's just a matter of general
>> sanity that may or may not help.  But sometimes it helps.
> 
> Larry's 8187 indeed looks like a 8187B i.e. the OEM being naughty and needs
> some serious lashing there... where does it come from - what brand and what
> is it bundled with?

It is a Level One WNC-0301USB dongle. I bought it as an interim 
replacement when the PCIe interface in my laptop expired and I could 
not get it fixed at that time. I was quite put out when Linux couldn't 
drive it as I needed Linux for my E-mail and it had to be wireless. I 
tried ndiswrapper with it, but that didn't work either. I finally 
settled on running Windows XP with Linux as a virtual machine running 
under VirtualBox. It wasn't pretty, but it worked.

> The 8187/8187b code actually *uses* the
> endpoints to send management frames for association - that's a 
> functional difference and it is not possible to drive a 8187 as if it is 
> a 8187b or
> vice versa. In the absence of
> more authoritative answers like reading from a register or something, 
> counting
> the endpoints - I would actually go a bit further and demand the used 
> endpoints
> being there and in the right direction and propertes (int/bulk) - would 
> seem
> to be a good idea. As for what to do "if things don't add up", at least 
> a warning through dmesg "give the OEM some lashing for calling a 8187b 
> 0x8187".


Good idea. It probably won't change anything other than make us feel good.


> I think Larry's question could be re-phrased as: if there is a preculiar 
> device
> with *both* end point 2 and endpoint 12, what to treat it as?
> 
> I would be inclined to treat it as the newer chip - but some big 
> warning, or
> even refusing to carry on, is probably in order.


I will prepare a patch with these warnings.


> Herton's code also seem to distinguish revC/revD/revE of different 
> 8187B's -
> I don't seem to have seen those distinctions in the original vendor 
> code, but
> maybe I haven't look hard enough :-).

I have not found them either. FWIW, my device is reported as 
RTL8187BvE V0 + rtl8225z2. The decision comes from 
rtl818x_ioread8(priv, (u8 *)0xFFE1), but I don't know what is at that 
address.

Larry
