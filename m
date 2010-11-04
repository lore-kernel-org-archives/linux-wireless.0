Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4650 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab0KDUot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 16:44:49 -0400
Message-ID: <4CD31B37.3000504@broadcom.com>
Date: Thu, 4 Nov 2010 13:44:39 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
cc: "Ariel Pedraza" <pedrazaa@yahoo.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: pci id 14e4:4727 (bcm4313) status?
References: <902099.84037.qm@web111406.mail.gq1.yahoo.com>
 <AANLkTik-7MT3YHJdmMXOGGZXxmTk5a-PEy8MFYObmP8+@mail.gmail.com>
In-Reply-To: <AANLkTik-7MT3YHJdmMXOGGZXxmTk5a-PEy8MFYObmP8+@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2010 07:39 AM, Gábor Stefanik wrote:
> On Thu, Nov 4, 2010 at 1:21 PM, Ariel Pedraza<pedrazaa@yahoo.com>  wrote:
>> I have the 14e4:4727 and using the brcm80211, this is an example of what I get and the status of each commands:
>>
>> airmon-ng #ok
>> airmon-ng stop wlan0 #ok
>> ifconfig wlan0 #ok
>> macchanger --mac yy:yy:yy:yy:yy:yy wlan0 #ok
>> airmon-ng start wlan0 #ok
>> airodump-ng mon0 #ok
>> airodump-ng -c canal -w nomarch --bssid xx:xx:xx:xx:xx:xx mon0  #ok, no datas
>>
>> In other terminal:
>> aireplay-ng -1 0 -a xx:xx:xx:xx:xx:xx -h yy:yy:yy:yy:yy:yy mon0 #ok, autentication succesful
>> aireplay-ng -3 -b xx:xx:xx:xx:xx:xx -h yy:yy:yy:yy:yy:yy mon0 #ok, supose to increment datas but NOP!!!
>>
>> In other terminal:
>> aircrack-ng -b xx:xx:xx:xx:xx:xx nomarch.cap #ok, no datas...
>>
>> So... when do you think that the brcm80211 implemetation will be ready to capture datas?
>
> Hmm... filter configuration issue? Apparently the "pass other-BSS
> data" filter flag is not getting written to the hardware. (Do we even
> have such a flag in the brcm80211 FW?)
 >
 > Can you see any data packets in Wireshark on the monitor interface?

The following flags should all work with the brcm80211 FW:

	MCTL_KEEPBADFCS
	MCTL_KEEPCONTROL
	MCTL_PROMISC
	MCTL_BCNS_PROMISC

The only one that's hooked up in the driver at the moment is 
MCTL_BCNS_PROMISC (for FIF_BCN_PRBRESP_PROMISC).  I haven't taken a look 
at what it would take to enable monitor mode in the driver yet (setting 
up the monitor interface, etc).

- Henry

