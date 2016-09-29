Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41430 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932987AbcI2Sbd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Sep 2016 14:31:33 -0400
Subject: Re: [PATCH v3 1/3] Documentation: dt: net: add mt76 wireless device
 binding
To: Kalle Valo <kvalo@codeaurora.org>
References: <20160905095128.80560-1-nbd@nbd.name>
 <20160905095128.80560-2-nbd@nbd.name>
 <87eg4uu0f3.fsf@kamboji.qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <e7d435b2-6b59-45af-07eb-b10789d61a9c@nbd.name> (sfid-20160929_203139_612997_DC5CAE5B)
Date: Thu, 29 Sep 2016 20:31:30 +0200
MIME-Version: 1.0
In-Reply-To: <87eg4uu0f3.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-09-08 12:54, Kalle Valo wrote:
> Felix Fietkau <nbd@nbd.name> writes:
> 
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> ---
>>  .../bindings/net/wireless/mediatek,mt76.txt        | 26 ++++++++++++++++++++++
>>  1 file changed, 26 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
>>
>> diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
>> new file mode 100644
>> index 0000000..d51c35f
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
>> @@ -0,0 +1,26 @@
>> +* MediaTek mt76xx devices
>> +
>> +This node provides properties for configuring the MediaTek mt76xx wireless
>> +device. The node is expected to be specified as a child node of the PCI
>> +controller to which the wireless chip is connected.
>> +
>> +Optional properties:
>> +
>> +- mac-address: See ethernet.txt in the parent directory
>> +- local-mac-address: See ethernet.txt in the parent directory
>> +- mediatek,2ghz: Override the 2.4 GHz band capability from EEPROM
>> +- mediatek,5ghz: Override the 5 GHz band capability from EEPROM
>> +- mediatek,mtd-eeprom: Specify a MTD partition + offset containing EEPROM data
>> +
>> +&pcie {
>> +	status = "okay";
>> +
>> +	pcie0 {
>> +		mt76@0,0 {
>> +			reg = <0x0000 0 0 0 0>;
>> +			device_type = "pci";
>> +			mediatek,mtd-eeprom = <&factory 0x8000>;
>> +			mediatek,2ghz = <0>;
>> +		};
>> +	};
>> +};
> 
> I need an ack from device tree maintainers, CCing the devicetree list.
> Do we need to resend or this ok?
> 
> Patchwork link:
> 
> https://patchwork.kernel.org/patch/9313309/
Ping?

- Felix
