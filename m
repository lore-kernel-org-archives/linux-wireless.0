Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:8021 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbbLaFli (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2015 00:41:38 -0500
Message-ID: <5684BFEF.8080302@qti.qualcomm.com> (sfid-20151231_064144_388565_0A61264D)
Date: Thu, 31 Dec 2015 11:11:03 +0530
From: Raja Mani <rmani@qti.qualcomm.com>
MIME-Version: 1.0
To: Rob Herring <robh@kernel.org>
CC: <agross@codeaurora.org>, <devicetree@vger.kernel.org>,
	<ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
	<mmcclint@qca.qualcomm.com>
Subject: Re: [PATCH] dt: bindings: add bindings for ipq4019 wifi block
References: <1450848915-9772-1-git-send-email-rmani@qti.qualcomm.com> <20151230163524.GA26810@rob-hp-laptop>
In-Reply-To: <20151230163524.GA26810@rob-hp-laptop>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wednesday 30 December 2015 10:05 PM, Rob Herring wrote:
> On Wed, Dec 23, 2015 at 11:05:15AM +0530, Raja Mani wrote:
>> Add device tree binding documentation details for wifi block present
>> in Qualcomm IPQ4019 SoC into qcom,ath10k.txt.
>>
>> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
>> ---
>>   .../bindings/net/wireless/qcom,ath10k.txt          | 87 ++++++++++++++++++++--
>>   1 file changed, 82 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> index edefc26..ffd0742 100644
>> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> @@ -1,17 +1,42 @@
>>   * Qualcomm Atheros ath10k wireless devices
>>
>> -For ath10k devices the calibration data can be provided through Device
>> -Tree. The node is a child node of the PCI controller.
>
> So it is now not a PCI device?

Right now, ath10k wireless driver has support for PCI devices. There is
a plan to extend ath10k driver to support wifi devices which are 
connected over AHB as well (enumeration will happen via device tree node).

Qualcomm IPQ4019 SoC has two inbuilt wifi block which are connected over 
AHB bus (not connected over PCI bus) and also has one external PCI
slot where we can connect standalone wifi PCI devices.

In future, ath10k would support both PCI and AHB. For PCI based
devices, only calibration data is supplied via device tree. For AHB
based devices (ie, ipq4019), all wifi properties are supplied
via device tree (including irq, reg addr, cal data,etc).

>
>> -
>>   Required properties:
>> --compatible : Should be "qcom,ath10k"
>> +- compatible: Should be one of the following:
>> +	* "qcom,ath10k"
>> +	* "qcom,ipq4019-wifi"
>
> One is a standalone PCI device and one is embedded block in an SOC?

Yes, it's possible to have this combination (one in SoC + one in
standalone PCI device in the same platform).

> These should be more separated as all these new properties would only
> apply in the latter case.

Sorry, i didn't get this point. I mentioned it under optional
properties. Whichever properties applies to particular wifi, only
those parameters are needed. For example, for PCI based devices,
only calibration data is needed, for AHB based devices most the
properties are needed.

Is it fine if add below text some thing like this ?

"only "qcom,ath10k-calibration-data" is applicable for PCI based
devices, rest of the members are applicable only for AHB based
devices"

Correct me if i am wrong.

>
>>
>>   Optional properties:
>> +- reg: Address and length of the register set for the device.
>> +- core-id: Core number associated to the device.
>
> This needs a better explanation.

Sure, Let me add below text in next version.

"core-id is numeric number associated to the wifi block.
  For example, 0 means first block, 1 means second wifi block,etc."

>
>> +- resets: Must contain an entry for each entry in reset-names.
>> +          See ../reset/reseti.txt for details.
>> +- reset-names: Must include the list of following reset names,
>> +	       "wifi_cpu_init"
>> +	       "wifi_radio_srif"
>> +	       "wifi_radio_warm"
>> +	       "wifi_radio_cold"
>> +	       "wifi_core_warm"
>> +	       "wifi_core_cold"
>> +- clocks: List of clock specifiers, must contain an entry for each required
>> +          entry in clock-names.
>> +- clock-names: Should contain the clock names "wifi_wcss_cmd", "wifi_wcss_ref",
>> +               "wifi_wcss_rtc".
>> +- interrupts: List of interrupt lines. Must contain an entry
>> +	      for each entry in the interrupt-names property.
>> +- interrupt-names: Must include the entries for MSI interrupt
>> +		   names ("msi0" to "msi15") and legacy interrupt
>> +		   name ("legacy"),
>> +- qca,msi_addr: MSI interrupt address.
>> +- qca,msi_base: Base value to add before writing MSI data into
>> +		MSI address register.
>
> Why don't the standard MSI properties work?

Standard msi controller mapping is not needed. Basically, msi property 
defined above just goes to the firmware runs in wifi block. Meaning, 
Driver will read it and push it to firmware. That's all.

>
>>   - qcom,ath10k-calibration-data : calibration data as an array, the
>>   				 length can vary between hw versions
>> +- status: Either "disabled" or "ok".
>> +
>
> No need to document status here.

Sure, will remove it in next version.

>
> Rob
>

Thanks for the review.

--
Raja
