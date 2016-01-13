Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42614 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbcAMCXa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 21:23:30 -0500
MIME-Version: 1.0
In-Reply-To: <5684BFEF.8080302@qti.qualcomm.com>
References: <1450848915-9772-1-git-send-email-rmani@qti.qualcomm.com>
 <20151230163524.GA26810@rob-hp-laptop> <5684BFEF.8080302@qti.qualcomm.com>
From: Rob Herring <robh@kernel.org>
Date: Tue, 12 Jan 2016 20:23:06 -0600
Message-ID: <CAL_JsqLH=Lr5UcgzFUr8AwVDXF8ahiyYfD2gfWng1zfhH21N5g@mail.gmail.com> (sfid-20160113_032343_952928_6F4DA17A)
Subject: Re: [PATCH] dt: bindings: add bindings for ipq4019 wifi block
To: Raja Mani <rmani@qti.qualcomm.com>
Cc: Andy Gross <agross@codeaurora.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-arm-msm <linux-arm-msm@vger.kernel.org>,
	mmcclint@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 30, 2015 at 11:41 PM, Raja Mani <rmani@qti.qualcomm.com> wrote:
>
> On Wednesday 30 December 2015 10:05 PM, Rob Herring wrote:
>>
>> On Wed, Dec 23, 2015 at 11:05:15AM +0530, Raja Mani wrote:
>>>
>>> Add device tree binding documentation details for wifi block present
>>> in Qualcomm IPQ4019 SoC into qcom,ath10k.txt.
>>>
>>> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
>>> ---
>>>   .../bindings/net/wireless/qcom,ath10k.txt          | 87
>>> ++++++++++++++++++++--
>>>   1 file changed, 82 insertions(+), 5 deletions(-)
>>>
>>> diff --git
>>> a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>>> b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>>> index edefc26..ffd0742 100644
>>> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>>> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>>> @@ -1,17 +1,42 @@
>>>   * Qualcomm Atheros ath10k wireless devices
>>>
>>> -For ath10k devices the calibration data can be provided through Device
>>> -Tree. The node is a child node of the PCI controller.
>>
>>
>> So it is now not a PCI device?
>
>
> Right now, ath10k wireless driver has support for PCI devices. There is
> a plan to extend ath10k driver to support wifi devices which are connected
> over AHB as well (enumeration will happen via device tree node).
>
> Qualcomm IPQ4019 SoC has two inbuilt wifi block which are connected over AHB
> bus (not connected over PCI bus) and also has one external PCI
> slot where we can connect standalone wifi PCI devices.
>
> In future, ath10k would support both PCI and AHB. For PCI based
> devices, only calibration data is supplied via device tree. For AHB
> based devices (ie, ipq4019), all wifi properties are supplied
> via device tree (including irq, reg addr, cal data,etc).

Put this information in the binding. It is not clear and you seem to
be removing PCI information.

>>> -
>>>   Required properties:
>>> --compatible : Should be "qcom,ath10k"
>>> +- compatible: Should be one of the following:
>>> +       * "qcom,ath10k"
>>> +       * "qcom,ipq4019-wifi"
>>
>>
>> One is a standalone PCI device and one is embedded block in an SOC?
>
>
> Yes, it's possible to have this combination (one in SoC + one in
> standalone PCI device in the same platform).
>
>> These should be more separated as all these new properties would only
>> apply in the latter case.
>
>
> Sorry, i didn't get this point. I mentioned it under optional
> properties. Whichever properties applies to particular wifi, only
> those parameters are needed. For example, for PCI based devices,
> only calibration data is needed, for AHB based devices most the
> properties are needed.
>
> Is it fine if add below text some thing like this ?
>
> "only "qcom,ath10k-calibration-data" is applicable for PCI based
> devices, rest of the members are applicable only for AHB based
> devices"

Yes, but you need to explain in terms of compatible strings. Which
compatible strings correspond to PCI devices.

>>>   Optional properties:
>>> +- reg: Address and length of the register set for the device.
>>> +- core-id: Core number associated to the device.
>>
>>
>> This needs a better explanation.
>
>
> Sure, Let me add below text in next version.
>
> "core-id is numeric number associated to the wifi block.
>  For example, 0 means first block, 1 means second wifi block,etc."

Are the blocks the same? If not, then use different compatible
strings. Otherwise doesn't the reg property identify which block is
which? Or some other property? Different freq bands? We generally
don't allow indexes like this in the DT, so I need to understand how
you use this.

Rob
