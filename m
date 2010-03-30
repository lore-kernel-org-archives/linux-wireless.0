Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:52654 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755387Ab0C3FLw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 01:11:52 -0400
Message-ID: <4BB18816.4040603@gmail.com>
Date: Tue, 30 Mar 2010 07:11:50 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: users@rt2x00.serialmonkey.com,
	Ondrej Zary <linux@rainbow-software.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH] rt2500usb: fix powersaving random failures
References: <201003290956.54234.linux@rainbow-software.org> <4BB103B9.8040100@gmail.com> <201003292300.12013.IvDoorn@gmail.com>
In-Reply-To: <201003292300.12013.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/10 23:00, Ivo van Doorn wrote:
> On Monday 29 March 2010, Gertjan van Wingerde wrote:
>> On 03/29/10 09:56, Ondrej Zary wrote:
>>> This patch seems to fix random powersaving failure where the device state is
>>> stuck at 1 (STATE_SLEEP) and does not change to 3 (STATE_AWAKE), resulting in
>>> to associate and these error messages:
>>> phy0 -> rt2500usb_set_device_state: Error - Device failed to enter state 3 (-16).
>>> No probe response from AP xx:xx:xx:xx:xx:xx after 500ms, disconnecting.
>>>
>>> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>>
>> Thanks. This looks good, but I'll rehash it against the latest state of affairs of rt2x00,
>> so that the disabling of powersaving is undone at the same time.
>>
>> John, I'll send you the rehashed patch tomorrow.
> 
> Is this change interesting for the other drivers as well?
> Anyway, this one gets my Ack:
> 
> Acked-By: Ivo van Doorn <IvDoorn@gmail.com>

Correct. That is the other reason to rehash. At least rt2400pci and rt2500pci can use
the same change.

> 
>> ---
>> Gertjan.
>>
>>>
>>> --- linux-2.6.34-rc2-orig/drivers/net/wireless/rt2x00/rt2500usb.c	2010-03-20 02:17:57.000000000 +0100
>>> +++ linux-2.6.34-rc2/drivers/net/wireless/rt2x00/rt2500usb.c	2010-03-29 09:38:02.000000000 +0200
>>> @@ -648,6 +648,10 @@
>>>  
>>>  		rt2x00_set_field16(&reg, MAC_CSR18_AUTO_WAKE, 1);
>>>  		rt2500usb_register_write(rt2x00dev, MAC_CSR18, reg);
>>> +	} else {
>>> +		rt2500usb_register_read(rt2x00dev, MAC_CSR18, &reg);
>>> +		rt2x00_set_field16(&reg, MAC_CSR18_AUTO_WAKE, 0);
>>> +		rt2500usb_register_write(rt2x00dev, MAC_CSR18, reg);
>>>  	}
>>>  
>>>  	rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
>>>
>>
>>
>> _______________________________________________
>> users mailing list
>> users@rt2x00.serialmonkey.com
>> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
>>
> 
> 
> 

