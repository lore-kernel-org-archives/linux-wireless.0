Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:58518 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934725AbcI2WmD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Sep 2016 18:42:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v3 1/3] Documentation: dt: net: add mt76 wireless device binding
Date: Fri, 30 Sep 2016 00:41:41 +0200
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20160905095128.80560-1-nbd@nbd.name> <87eg4uu0f3.fsf@kamboji.qca.qualcomm.com> <e7d435b2-6b59-45af-07eb-b10789d61a9c@nbd.name>
In-Reply-To: <e7d435b2-6b59-45af-07eb-b10789d61a9c@nbd.name>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201609300041.41876.arnd@arndb.de> (sfid-20160930_004207_801132_10A17A21)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 29 September 2016, Felix Fietkau wrote:
> On 2016-09-08 12:54, Kalle Valo wrote:
> > Felix Fietkau <nbd@nbd.name> writes:
> > 
> >> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> >> ---
> >>  .../bindings/net/wireless/mediatek,mt76.txt        | 26 ++++++++++++++++++++++
> >>  1 file changed, 26 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
> >> new file mode 100644
> >> index 0000000..d51c35f
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
> >> @@ -0,0 +1,26 @@
> >> +* MediaTek mt76xx devices
> >> +
> >> +This node provides properties for configuring the MediaTek mt76xx wireless
> >> +device. The node is expected to be specified as a child node of the PCI
> >> +controller to which the wireless chip is connected.
> >> +
> >> +Optional properties:
> >> +
> >> +- mac-address: See ethernet.txt in the parent directory
> >> +- local-mac-address: See ethernet.txt in the parent directory
> >> +- mediatek,2ghz: Override the 2.4 GHz band capability from EEPROM
> >> +- mediatek,5ghz: Override the 5 GHz band capability from EEPROM
> >> +- mediatek,mtd-eeprom: Specify a MTD partition + offset containing EEPROM data
> >> +
> >> +&pcie {
> >> +	status = "okay";
> >> +
> >> +	pcie0 {
> >> +		mt76@0,0 {
> >> +			reg = <0x0000 0 0 0 0>;

Maybe have an examplep of a real register address other than zero?

> >> +			device_type = "pci";
> >> +			mediatek,mtd-eeprom = <&factory 0x8000>;
> >> +			mediatek,2ghz = <0>;

It's not clear what the possible values for the 2ghz property are,
can you be more verbose in the description? How is <0> different
from no property?

	Arnd
