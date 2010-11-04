Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61878 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab0KDVns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 17:43:48 -0400
Received: by qwf7 with SMTP id 7so1728444qwf.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 14:43:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=MjDUWSULLmVtRCdp2Hm6mDGe5Gw3D-XXKoakh@mail.gmail.com>
References: <902099.84037.qm@web111406.mail.gq1.yahoo.com> <AANLkTik-7MT3YHJdmMXOGGZXxmTk5a-PEy8MFYObmP8+@mail.gmail.com>
 <4CD31B37.3000504@broadcom.com> <AANLkTi=MjDUWSULLmVtRCdp2Hm6mDGe5Gw3D-XXKoakh@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 4 Nov 2010 22:43:27 +0100
Message-ID: <AANLkTimzETvmCfE=iny0-j1KNke7L9nOsSh-5ML3cB5k@mail.gmail.com>
Subject: Re: pci id 14e4:4727 (bcm4313) status?
To: Henry Ptasinski <henryp@broadcom.com>
Cc: Ariel Pedraza <pedrazaa@yahoo.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/4 Gábor Stefanik <netrolller.3d@gmail.com>:
> 2010/11/4 Henry Ptasinski <henryp@broadcom.com>:
>> On 11/04/2010 07:39 AM, Gábor Stefanik wrote:
>>>
>>> On Thu, Nov 4, 2010 at 1:21 PM, Ariel Pedraza<pedrazaa@yahoo.com>  wrote:
>>>>
>>>> I have the 14e4:4727 and using the brcm80211, this is an example of what
>>>> I get and the status of each commands:
>>>>
>>>> airmon-ng #ok
>>>> airmon-ng stop wlan0 #ok
>>>> ifconfig wlan0 #ok
>>>> macchanger --mac yy:yy:yy:yy:yy:yy wlan0 #ok
>>>> airmon-ng start wlan0 #ok
>>>> airodump-ng mon0 #ok
>>>> airodump-ng -c canal -w nomarch --bssid xx:xx:xx:xx:xx:xx mon0  #ok, no
>>>> datas
>>>>
>>>> In other terminal:
>>>> aireplay-ng -1 0 -a xx:xx:xx:xx:xx:xx -h yy:yy:yy:yy:yy:yy mon0 #ok,
>>>> autentication succesful
>>>> aireplay-ng -3 -b xx:xx:xx:xx:xx:xx -h yy:yy:yy:yy:yy:yy mon0 #ok, supose
>>>> to increment datas but NOP!!!
>>>>
>>>> In other terminal:
>>>> aircrack-ng -b xx:xx:xx:xx:xx:xx nomarch.cap #ok, no datas...
>>>>
>>>> So... when do you think that the brcm80211 implemetation will be ready to
>>>> capture datas?
>>>
>>> Hmm... filter configuration issue? Apparently the "pass other-BSS
>>> data" filter flag is not getting written to the hardware. (Do we even
>>> have such a flag in the brcm80211 FW?)
>>
>>>
>>> Can you see any data packets in Wireshark on the monitor interface?
>>
>> The following flags should all work with the brcm80211 FW:
>>
>>        MCTL_KEEPBADFCS
>>        MCTL_KEEPCONTROL
>>        MCTL_PROMISC
>>        MCTL_BCNS_PROMISC
>>
>> The only one that's hooked up in the driver at the moment is
>> MCTL_BCNS_PROMISC (for FIF_BCN_PRBRESP_PROMISC).  I haven't taken a look at
>> what it would take to enable monitor mode in the driver yet (setting up the
>> monitor interface, etc).
>
> For raw monitor mode, all but KEEPBADFCS are needed. If the "fcsfail"
> monitor mode flag is also set, KEEPBADFCS should be enabled too.
> For cooked monitor, AFAIK only KEEPCONTROL (and perhaps BCNS_PROMISC)
> are needed.
>
> However, do not set these based on interface type - use the FIF_ flags instead.

BTW, please consider a KEEPBADPLCP flag in the next firmware release -
it is needed for implementing the "plcpfail" monitor flag.

>
>>
>> - Henry
>>
>>
>
>
>
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
