Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:64921 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbaIMQkW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Sep 2014 12:40:22 -0400
Message-ID: <54147373.1050109@broadcom.com> (sfid-20140913_184026_798392_9A30BA63)
Date: Sat, 13 Sep 2014 18:40:19 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: <linux-wireless@vger.kernel.org>, <zajec5@gmail.com>,
	<devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <arnd@arndb.de>
Subject: Re: [PATCH 1/2] bcma: register bcma as device tree driver
References: <1410615446-7639-1-git-send-email-hauke@hauke-m.de> <54145F0E.8000506@broadcom.com> <54146A8D.1060704@hauke-m.de>
In-Reply-To: <54146A8D.1060704@hauke-m.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/13/14 18:02, Hauke Mehrtens wrote:
> On 09/13/2014 05:13 PM, Arend van Spriel wrote:
>> On 09/13/14 15:37, Hauke Mehrtens wrote:
>>> This driver is used by the bcm53xx ARM SoC code. Now it is possible to
>>> give the address of the chipcommon core in device tree and bcma will
>>> search for all the other cores.
>>>
>>> Signed-off-by: Hauke Mehrtens<hauke@hauke-m.de>
>>> ---
>>>    Documentation/devicetree/bindings/bus/bcma.txt | 41 +++++++++++++
>>>    drivers/bcma/bcma_private.h                    | 16 +++++
>>>    drivers/bcma/host_soc.c                        | 82
>>> ++++++++++++++++++++++++++
>>>    drivers/bcma/main.c                            | 10 ++++
>>>    include/linux/bcma/bcma.h                      |  2 +
>>>    5 files changed, 151 insertions(+)
>>>    create mode 100644 Documentation/devicetree/bindings/bus/bcma.txt
>>>
>>> This is based on wireless-testing and should go into that tree.
>>>
>>> changes since:
>>> RFC:
>>>    - reworded the irq description
>>>    - improved the example
>>>    - hocked into bcma_modeinit() and bcma_modexit()
>>>
>>> diff --git a/Documentation/devicetree/bindings/bus/bcma.txt
>>> b/Documentation/devicetree/bindings/bus/bcma.txt
>>> new file mode 100644
>>> index 0000000..17e095f
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/bus/bcma.txt
>>> @@ -0,0 +1,41 @@
>>> +Broadcom AIX SoC bcma bus driver
>>
>> Hi Hauke,
>>
>> First of all a typo used all over the place: AIX should be AXI.
>
> I will fix that.
>
>> The backplane in Broadcom SoC is ARM AXI with additional plugin option
>> to make it discoverable. Indeed the IRQ info is not included, but I see
>> no reason for specifying the register space for the cores in device-tree
>> as that is discoverable by bcma.
>
> I specified the register space to make it possible to connect the device
> tree entry with the core. After the cores are automatically discovered,
> bcma searches for entry core found, for an device tree entry with the
> same address space and uses the irq number from that entry. If there is
> a core defined in device tree which is not found by bcma it will just be
> ignored. If a core is not specified in device tree it will get
> registered, but it will not get an IRQ.
> This was the most stable way I came up with, I also thought about using
> the core number, like assign the this IRQ to core number 5, but the core
> numbers could change when we do changes to bcma.

I understand. In the example I noticed the core base address was also 
used in the entry label, ie. pcie@18002000. However, I am not sure 
whether that can be obtained by the driver. If it is possible it could 
be used to match the dt entry to a core and the register info would be 
redundant.

> In the Broadcom vendor code there is a list with the IRQ numbers which
> get assigned to a specific core type. For example there is a list with 4
> IRQ numbers which get assigned to the first 4 Ethernet cores. This would
> also work, but I do not know how to do this in device tree.

I am wondering about the IRQ numbers. The SoC would also have a OOB 
routing core, which controls non-axi signals between the cores. I will 
ask internally whether the irq signals are controlled by it and can be 
retrieved from it.

Regards,
Arend
