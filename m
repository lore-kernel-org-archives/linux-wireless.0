Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2458 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab3DYJDc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Apr 2013 05:03:32 -0400
Message-ID: <5178F158.60103@broadcom.com> (sfid-20130425_110337_162540_7FEE487C)
Date: Thu, 25 Apr 2013 11:03:20 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Marcel Holtmann" <marcel@holtmann.org>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] cfg80211: Android P2P-Device workaround
References: <1366721149-5440-1-git-send-email-johannes@sipsolutions.net>
 <EC4E16A7-2F9E-4E59-A561-88C85A459BCA@holtmann.org>
 <1366735340.8385.20.camel@jlt4.sipsolutions.net>
 <51779434.4010709@broadcom.com>
 <F323F29D-5EF8-4D01-A4B3-F9AF12326012@holtmann.org>
In-Reply-To: <F323F29D-5EF8-4D01-A4B3-F9AF12326012@holtmann.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/24/2013 04:29 PM, Marcel Holtmann wrote:
> Hi Arend,
>
>>>>> +config CFG80211_ANDROID_P2P_HACK
>>>>> +	bool "Android P2P netdevice hack"
>>>>> +	depends on CFG80211
>>>>> +	depends on !CFG80211_WEXT
>>>>> +	help
>>>>> +	  Enable this option for Android P2P w/ P2P Device.
>>>>> +
>>>>
>>>> do you really think this is a good idea? Wouldn't it be better if
>>>> Android just gets its userspace fixed. This way, they never will and
>>>> you carry this workaround forever.
>>>
>>> Well, I'm about 50/50 on whether to merge this. On the one hand, it's a
>>> very simple patch to carry out of tree, on the other hand more than one
>>> person will need it.
>>>
>>
>> Here is one who needs it. I consider this patch as a temporary solution, but it would be good to have it upstream. We would be using compat-drivers to backport the upstream brcmfmac to the android kernel, which also takes care of cfg80211.
>
> why do I get the feeling that the root-cause for this stupid p2p0 device is the Broadcom binary only driver  ;)

Hi Marcel,

Just like you I can only guess, but you are probably right except that 
the broadcom driver introducing this p2p0 device was propbably the 
bcmdhd driver which is available in android repositories.

Because of the design of the firmware (which is binary) going for a 
net_device was the most straightforward and also because wpa_supplicant 
is all about net_device interfaces.

> I feel like being back in the world of Wireless Extensions ;)

I hear you and we are still not fully rid of that.

Gr. AvS

