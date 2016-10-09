Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33002 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751136AbcJIKuh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Oct 2016 06:50:37 -0400
MIME-Version: 1.0
In-Reply-To: <20161009012856.GK18158@rob-hp-laptop>
References: <20160906214623.20424-1-martin.blumenstingl@googlemail.com>
 <20161002214743.2263-1-martin.blumenstingl@googlemail.com>
 <20161002214743.2263-2-martin.blumenstingl@googlemail.com> <20161009012856.GK18158@rob-hp-laptop>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Sun, 9 Oct 2016 11:54:11 +0200
Message-ID: <CAFBinCA_4JMGZ5ZPzqaSoZqfTS3HvUCu0CuGtFXypHHmQUHx-A@mail.gmail.com> (sfid-20161009_125041_449772_149B72C3)
Subject: Re: [PATCH v7 1/3] Documentation: dt: net: add ath9k wireless device binding
To: Rob Herring <robh@kernel.org>
Cc: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        mcgrof@do-not-panic.com, mark.rutland@arm.com,
        kvalo@codeaurora.org, chunkeey@googlemail.com,
        arend.vanspriel@broadcom.com, julian.calaby@gmail.com,
        bjorn@mork.no, linux@rempel-privat.de, nbd@nbd.name
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 9, 2016 at 3:28 AM, Rob Herring <robh@kernel.org> wrote:
> On Sun, Oct 02, 2016 at 11:47:41PM +0200, Martin Blumenstingl wrote:
>> Add documentation how devicetree can be used to configure ath9k based
>> devices.
>>
>> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>> ---
>>  .../devicetree/bindings/net/wireless/qca,ath9k.txt | 30 ++++++++++++++++++++++
>>  1 file changed, 30 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
>>
>> diff --git a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
>> new file mode 100644
>> index 0000000..9b58ede
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
>> @@ -0,0 +1,30 @@
>> +* Qualcomm Atheros ath9k wireless devices
>> +
>> +This node provides properties for configuring the ath9k wireless device. The
>> +node is expected to be specified as a child node of the PCI controller to
>> +which the wireless chip is connected.
>> +
>> +Required properties:
>> +- compatible: For PCI and PCIe devices this should be an identifier following
>> +             the format as defined in "PCI Bus Binding to Open Firmware"
>> +             Revision 2.1. One of the possible formats is "pciVVVV,DDDD"
>> +             where VVVV is the PCI vendor ID and DDDD is PCI device ID.
>
> Are there some known values you can document here? Like the one in the
> example.
what do you have in mind there?

there are lots of supported device IDs just with vendor 0x168c (Atheros):
echo $(grep 'PCI_VDEVICE(ATHEROS'
drivers/net/wireless/ath/ath9k/pci.c; grep '{
PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS'
drivers/net/wireless/ath/ath9k/pci.c -A1) | grep -Eo "0x[
0-9A-Z]{4}" | sort -u
Also some device IDs seem to be used by different chips, for example
0x0029 is used for both, AR9220 and AR9223 - see [0]

I could extend the documentation with something like:
vendor ID is usually 168c (Atheros) and device ID is one of the
following, depending on the actual chipset:
- 002d: AR9227 (PCI variant of AR9287)
- 002e: AR9287 (PCI-e)
- ...

>> +- reg: Address and length of the register set for the device.
>> +
>> +Optional properties:
>> +- qca,no-eeprom: Indicates that there is no physical EEPROM connected to the
>> +                     ath9k wireless chip (in this case the calibration /
>> +                     EEPROM data will be loaded from userspace using the
>> +                     kernel firmware loader).
>> +- mac-address: See ethernet.txt in the parent directory
>> +- local-mac-address: See ethernet.txt in the parent directory
>> +
>> +
>> +In this example, the node is defined as child node of the PCI controller:
>> +&pci0 {
>> +     ath9k@168c,002d {
>
> wifi@...
will fix that, thanks for the hint


[0] https://wireless.wiki.kernel.org/en/users/drivers/ath9k/devices
