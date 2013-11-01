Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3793 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab3KANHd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:07:33 -0400
Message-ID: <5273A784.4040900@broadcom.com> (sfid-20131101_140737_451957_2D4F96CE)
Date: Fri, 1 Nov 2013 14:07:16 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"j@w1.fi" <j@w1.fi>
Subject: Re: [PATCH] cfg80211: Introduce critical protocol indication
 for p2p connection.
References: <1383230452-12608-1-git-send-email-usdutt@qti.qualcomm.com>
 (sfid-20131031_154108_037102_6F3E1A6D)
 <1383230593.14302.1.camel@jlt4.sipsolutions.net>
 <26F3B0343EE4744AA14EEEF9E1E534511F7A65CC@aphydexd01a>
 <1383233115.14302.2.camel@jlt4.sipsolutions.net>
 <26F3B0343EE4744AA14EEEF9E1E534511F7A6606@aphydexd01a>
 <52729681.5020004@broadcom.com>
 <26F3B0343EE4744AA14EEEF9E1E534511F7A8160@aphydexd01a>
In-Reply-To: <26F3B0343EE4744AA14EEEF9E1E534511F7A8160@aphydexd01a>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/01/2013 12:25 PM, Undekari, Sunil Dutt wrote:
> Hi Arend,
>
>> So how would the scenario look like. The host driver will get involved in setting up the P2P connection so that knowledge is already available to defer the scans or am I missing something.
> The host driver shall perform the scan's to find a better BSS in the
> The host driver / firmware performs (initiates) a scan on the STA interface in the process of finding a better BSS to roam. This scan is offloaded to the driver / firmware for a better roam experience.
> This scans would definitely affect the p2p connection triggered by the supplicant.
> Thus, I was suggesting a way to extend the already existing critical protocol indications to also include p2p protocol/connections, so that drivers can defer the scan's (any off channel operations for that matter) on any other interface during this period.

I got that. What I meant to say is that you can defer the roaming 
related scans when cfg80211 does a .add_virtual_intf() call to the 
driver and recommence upon .del_virtual_intf(). I guess this effectively 
disables roaming, right?

Regards,
Arend

> Regards,
> Sunil.
>
>
>
> -----Original Message-----
> From: Arend van Spriel [mailto:arend@broadcom.com]
> Sent: Thursday, October 31, 2013 11:12 PM
> To: Undekari, Sunil Dutt
> Cc: Johannes Berg; linux-wireless@vger.kernel.org; j@w1.fi
> Subject: Re: [PATCH] cfg80211: Introduce critical protocol indication for p2p connection.
>
> On 10/31/13 16:54, Undekari, Sunil Dutt wrote:
>>> Just do it in the supplicant - that has full control over what's going on with a given device.
>>> Trying to have the kernel manage multiple things that may or may not be exclusive and are all done in userspace is going to be a futile exercise.
>> Please note that the scans that are mentioned by me in this context are not triggered by the supplicant, rather the host driver would initiate them.
>
> So how would the scenario look like. The host driver will get involved in setting up the P2P connection so that knowledge is already available to defer the scans or am I missing something.
>
> Regards,
> Arend
>
>> The driver / firmware would do such scans for a better roam performance.
>> I would say, some handshake between the supplicant and the driver would be needed for a better understanding on the operations.
>> Please have your say.
>> Regards,
>> Sunil
>>
>> -----Original Message-----
>> From: Johannes Berg [mailto:johannes@sipsolutions.net]
>> Sent: Thursday, October 31, 2013 8:55 PM
>> To: Undekari, Sunil Dutt
>> Cc: linux-wireless@vger.kernel.org; j@w1.fi
>> Subject: Re: [PATCH] cfg80211: Introduce critical protocol indication for p2p connection.
>>
>> On Thu, 2013-10-31 at 15:22 +0000, Undekari, Sunil Dutt wrote:
>>>> That's not what the critical protocol stuff was designed for, so no.
>>> I would consider the P2P connection phase (P2P+WPS+WPA) to be
>>> critical and any off channel operations (scan) triggered by the host
>>> driver would result in the delayed / failed P2P connection attempt.
>>> I suppose there should be an indication to the host driver w.r.t p2p
>>> connection attempt so that any off load operations on any other
>>> interface sharing the same radio would be avoided by the driver.
>>> Since there is already an existing interface through the critical
>>> protocol indication, I thought of extending it to also include a P2P
>>> protocol/connection. This new proto id would be an indication to the
>>> drivers to allow the scan on the current interface and avoid any
>>> scans on another considering the fact that a p2p connection requires a scan.
>>> Do you propose an alternative (a new interface?) to achieve the same?
>>
>> Just do it in the supplicant - that has full control over what's going on with a given device.
>>
>> Trying to have the kernel manage multiple things that may or may not be exclusive and are all done in userspace is going to be a futile exercise.
>>
>> johannes
>>
>> N     r  y   b X  ǧv ^ )޺{.n +    {  *ޕ , {ay ʇڙ ,j
>>    f   h   z  w
>     j:+v   w j m         zZ+     ݢj"  ! i
>
>


