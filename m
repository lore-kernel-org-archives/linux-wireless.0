Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:45373 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208AbbCMS6j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 14:58:39 -0400
Message-ID: <5503335B.3020000@broadcom.com> (sfid-20150313_195846_651241_6412FC71)
Date: Fri, 13 Mar 2015 19:58:35 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: James Cameron <quozl@laptop.org>
CC: Dan Williams <dcbw@redhat.com>, voncken <cedric.voncken@acksys.fr>,
	"'wim torfs'" <wtorfs@gmail.com>, <linux-wireless@vger.kernel.org>
Subject: Re: ARP dropped during WPA handshake
References: <773DB8A82AB6A046AE0195C68612A319019FECAF@sbs2003.acksys.local> <5502D558.90306@gmail.com> <033201d05d93$5aa1c030$0fe54090$@acksys.fr> <1426255583.19064.6.camel@redhat.com> <034401d05da5$d5c0be30$81423a90$@acksys.fr> <1426264174.19064.19.camel@redhat.com> <20150313183409.GF18964@us.netrek.org>
In-Reply-To: <20150313183409.GF18964@us.netrek.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/13/15 19:34, James Cameron wrote:
> On Fri, Mar 13, 2015 at 11:29:34AM -0500, Dan Williams wrote:
>> On Fri, 2015-03-13 at 16:53 +0100, voncken wrote:
>>>>> Below, a tcpdump capture from sta.
>>>>> 17:43:12.964096 EAPOL key (3) v2, len 95
>>>>> 17:43:12.998439 EAPOL key (3) v1, len 117
>>>>> 17:43:13.062409 ARP, Request who-has 10.32.61.100 tell 10.32.0.1,
>>>>> length 28
>>>>> 17:43:13.079989 EAPOL key (3) v2, len 151
>>>>> 17:43:13.082764 EAPOL key (3) v1, len 95
>>>>> 17:43:14.062381 ARP, Request who-has 10.32.61.100 tell 10.32.0.1,
>>>>> length 28
>>>>> 17:43:14.127101 ARP, Reply 10.32.61.100 is-at b8:88:e3:45:1d:c6 (oui
>>>>> Unknown), length 46
>>>>> 17:43:14.127123 IP 10.69.1.201.41690>  10.32.61.100.5001: UDP, length
>>>>> 1470
>>>>> 17:43:14.127136 IP 10.69.1.201.41690>  10.32.61.100.5001: UDP, length
>>>>> 1470
>>>>>
>>>>> You can see the ARP request during the WPA Handshake.
>>>>
>>>> During the initial WPA handshake the connection is not fully set up, and so
>>>> no general traffic can (nor should) pass between the STA and AP.
>>>> That includes ARP and any L2/L3+ protocols, except for EAP and wifi
>>>> management packets.
>>>>
>>>> The interface itself must be IFF_UP before it can pass traffic, including the
>>>> WPA handshake traffic.  IFF_UP only means that the interface can be
>>>> configured at the L2 level and the hardware is active, it does *not* mean the
>>>> interface can pass traffic.
>>>>
>>>> Whatever is causing the ARPs shouldn't be doing that yet, and should be fixed
>>>> to use the interface's "operstate" or IFF_LOWER_UP instead of IFF_UP.  Only
>>>> when the supplicant changes the interface's operstate to IF_OPER_UP is the
>>>> interface *actually* ready to pass traffic.  IFF_UP is not sufficient.
>>>>
>>>
>>> Thanks for your reply.
>>>
>>> It seems wpa_supplicant set the operstate to IF_OPER_DORMANT when he received the ASSOCIATED Event from the driver (through netlink). And set the operstate to IF_OPER_UP in case of wpa handshake success.
>>>
>>> Is it normal the local ip stack send arp when netdev it is on IF_OPER_DORMANT state?
>>
>> I'm not sure the kernel stack cares much as long as the device is up.
>> It is requesting the ARP because some application is attempting to
>> communicate with that IP address.  That application should probably be
>> waiting until the interface is actually ready to communicate, which
>> means IF_OPER_UP.
>>
>> But if this is the first WPA handshake with the AP during the initial
>> connection, the wifi device shouldn't even have an IP address yet, so
>> nothing should be doing ARP on the interface yet.
>
> I thought that ARP was a means to get an IP address before an
> interface had an IP address, so the interface spends some time without
> an IP address yet generating ARP.

ARP is an Address Resolution Protocol to obtain the ethernet or MAC 
address for a destination ip address by sending a broadcast message. One 
common application involving arp queries is 'ping'.

Regards,
Arend

>> Perhaps whatever is assigning the IP address to the interface is
>> doing it too early, before the interface is IF_OPER_UP?
>>
>> Dan
>> 	
>>>
>>>>
>>>>
>>>>> 	Any suggestion will be appreciate.
>>>>>
>>>>> Cedric.
>>>>>>
>>>>>>> Thanks for your help.
>>>>>>>
>>>>>>> Cedric Voncken
>>>>>>>
>>>>>>>
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>> linux-wireless" in the body of a message to
>>>>>>> majordomo@vger.kernel.org More majordomo info at
>>>>>>> http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>> linux-wireless" in the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

