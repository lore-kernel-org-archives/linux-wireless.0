Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56719 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751438AbcI3IsI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 04:48:08 -0400
Subject: Re: [PATCH v3 1/3] Documentation: dt: net: add mt76 wireless device
 binding
To: Arnd Bergmann <arnd@arndb.de>
References: <20160905095128.80560-1-nbd@nbd.name>
 <87eg4uu0f3.fsf@kamboji.qca.qualcomm.com>
 <e7d435b2-6b59-45af-07eb-b10789d61a9c@nbd.name>
 <201609300041.41876.arnd@arndb.de>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <3334122f-0d79-f910-a414-5b9cafd9901f@nbd.name> (sfid-20160930_104814_431551_2CDEB731)
Date: Fri, 30 Sep 2016 10:48:04 +0200
MIME-Version: 1.0
In-Reply-To: <201609300041.41876.arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-09-30 00:41, Arnd Bergmann wrote:
> On Thursday 29 September 2016, Felix Fietkau wrote:
>> On 2016-09-08 12:54, Kalle Valo wrote:
>> > Felix Fietkau <nbd@nbd.name> writes:
>> > 
>> >> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> >> ---
>> >>  .../bindings/net/wireless/mediatek,mt76.txt        | 26 ++++++++++++++++++++++
>> >>  1 file changed, 26 insertions(+)
>> >>  create mode 100644 Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
>> >>
>> >> diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
>> >> new file mode 100644
>> >> index 0000000..d51c35f
>> >> --- /dev/null
>> >> +++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
>> >> @@ -0,0 +1,26 @@
>> >> +* MediaTek mt76xx devices
>> >> +
>> >> +This node provides properties for configuring the MediaTek mt76xx wireless
>> >> +device. The node is expected to be specified as a child node of the PCI
>> >> +controller to which the wireless chip is connected.
>> >> +
>> >> +Optional properties:
>> >> +
>> >> +- mac-address: See ethernet.txt in the parent directory
>> >> +- local-mac-address: See ethernet.txt in the parent directory
>> >> +- mediatek,2ghz: Override the 2.4 GHz band capability from EEPROM
>> >> +- mediatek,5ghz: Override the 5 GHz band capability from EEPROM
>> >> +- mediatek,mtd-eeprom: Specify a MTD partition + offset containing EEPROM data
>> >> +
>> >> +&pcie {
>> >> +	status = "okay";
>> >> +
>> >> +	pcie0 {
>> >> +		mt76@0,0 {
>> >> +			reg = <0x0000 0 0 0 0>;
> 
> Maybe have an examplep of a real register address other than zero?
This is a real example referring to the first device on a PCI bus.
I copy&pasted this from a .dts file that we use in LEDE.

>> >> +			device_type = "pci";
>> >> +			mediatek,mtd-eeprom = <&factory 0x8000>;
>> >> +			mediatek,2ghz = <0>;
> 
> It's not clear what the possible values for the 2ghz property are,
> can you be more verbose in the description? How is <0> different
> from no property?
0 means disabled, no property means unchanged (compared to EEPROM).

- Felix
