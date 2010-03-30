Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:59872 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752546Ab0C3Vow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 17:44:52 -0400
Message-ID: <4BB270D2.8040103@gmail.com>
Date: Tue, 30 Mar 2010 23:44:50 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH] [RFC] rt2500pci: fix powersaving
References: <201003290956.54234.linux@rainbow-software.org> <201003302209.23334.linux@rainbow-software.org> <4BB266E9.2010404@gmail.com> <201003302336.01897.linux@rainbow-software.org>
In-Reply-To: <201003302336.01897.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/30/10 23:35, Ondrej Zary wrote:
> On Tuesday 30 March 2010 23:02:33 Gertjan van Wingerde wrote:
>> On 03/30/10 22:09, Ondrej Zary wrote:
>>> On Tuesday 30 March 2010, Matthijs Kooijman wrote:
>>>> Hi all,
>>>>
>>>>> phy0 -> rt2500pci_set_device_state: Error - Device failed to enter
>>>>> state 1 (-16).
>>>>
>>>> I'm seeing this one on my rt2500pci as well (and also works ok
>>>> otherwise).
>>>
>>> OK, so let's try to fix it.
>>>
>>> The first patch below fixes this problem. And reveals two other problems.
>>> Now the device has problems entering states 3 and 4 (remains stuck in
>>> state 1) - the driver seems to not like this and oopses.
>>> The second patch fixes the "stuck state 1" problem (same fix as in
>>> rt2500usb). The oops does not appear anymore with the second patch - but
>>> I think that it should be fixed anyway separately.
>>> (I'm testing this with "while true; do ifdown wlan0; ifup wlan0; done")
>>
>> Thanks again for your hard and persistent work on this.
>>
>>> oops removed
>>>
>>>
>>> ---
>>> linux-2.6.34-rc2-orig/drivers/net/wireless/rt2x00/rt2500pci.c	2010-03-20
>>> 02:17:57.000000000 +0100 +++
>>> linux-2.6.34-rc2/drivers/net/wireless/rt2x00/rt2500pci.c	2010-03-30
>>> 15:04:50.000000000 +0200 @@ -1079,7 +1079,7 @@
>>>  static int rt2500pci_set_state(struct rt2x00_dev *rt2x00dev,
>>>  			       enum dev_state state)
>>>  {
>>> -	u32 reg;
>>> +	u32 reg, reg2;
>>>  	unsigned int i;
>>>  	char put_to_sleep;
>>>  	char bbp_state;
>>> @@ -1100,11 +1100,12 @@
>>>  	 * device has entered the correct state.
>>>  	 */
>>>  	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
>>> -		rt2x00pci_register_read(rt2x00dev, PWRCSR1, &reg);
>>> -		bbp_state = rt2x00_get_field32(reg, PWRCSR1_BBP_CURR_STATE);
>>> -		rf_state = rt2x00_get_field32(reg, PWRCSR1_RF_CURR_STATE);
>>> +		rt2x00pci_register_read(rt2x00dev, PWRCSR1, &reg2);
>>> +		bbp_state = rt2x00_get_field32(reg2, PWRCSR1_BBP_CURR_STATE);
>>> +		rf_state = rt2x00_get_field32(reg2, PWRCSR1_RF_CURR_STATE);
>>>  		if (bbp_state == state && rf_state == state)
>>>  			return 0;
>>> +		rt2x00pci_register_write(rt2x00dev, PWRCSR1, reg);
>>>  		msleep(10);
>>>  	}
>>
>> Hmmm, checking the old legacy Ralink rt2500 driver it shows that the legacy
>> driver never waits and checks whether the device has come in the right
>> power state. What does happen to the stability of the connection if you
>> simply remove this entire for-loop?
> 
> It works without the loop - But I suspect that the device never enters 
> STATE_SLEEP. With the loop present, it needs 3 loop passes to enter 
> STATE_SLEEP (with that register write added). It never enters STATE_SLEEP 
> without that added register write (I took it from rt2500usb) and that's why 
> the error message was printed in log.
> 

OK. Thanks. I'll go with your patch then.
I'll make a similar change to rt2400pci as well, as it uses exactly the same code,
and I'll audit the other drivers in this respect.

---
Gertjan.
