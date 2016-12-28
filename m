Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34361 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750976AbcL1UdJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Dec 2016 15:33:09 -0500
MIME-Version: 1.0
In-Reply-To: <f387d897-a1e9-c932-8317-41246be245b0@broadcom.com>
References: <20161228155955.25518-1-zajec5@gmail.com> <f387d897-a1e9-c932-8317-41246be245b0@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Wed, 28 Dec 2016 21:32:16 +0100
Message-ID: <CACna6rwhC=28fCHDzXok8Ka08g3yhcD2VNgQrfUZUCQRGqksOg@mail.gmail.com> (sfid-20161228_213313_503358_D26611A2)
Subject: Re: [PATCH 1/2] dt-bindings: document common IEEE 802.11 frequency properties
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 December 2016 at 21:05, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 28-12-16 16:59, Rafa=C5=82 Mi=C5=82ecki wrote:
>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>
>> This new file should be used for properties handled at higher level and
>> so usable with all drivers.
>>
>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>> ---
>>  .../devicetree/bindings/net/wireless/ieee80211.txt       | 16 +++++++++=
+++++++
>>  1 file changed, 16 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/wireless/ieee8=
0211.txt
>>
>> diff --git a/Documentation/devicetree/bindings/net/wireless/ieee80211.tx=
t b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
>> new file mode 100644
>> index 0000000..c762769
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
>> @@ -0,0 +1,16 @@
>> +Common IEEE 802.11 properties
>> +
>> +This provides documentation of common properties that are handled by a =
proper
>> +net layer and don't require extra driver code.
>
> Please do not make any assumptions on how DT properties are handled nor
> by what. Just state that these properties apply to all wireless devices
> and are applicable to device specific bindings.

OK, I'll try to improve this description.


>> +Optional properties:
>> + - ieee80211-min-center-freq : minimal supported frequency in KHz
>> + - ieee80211-max-center-freq : maximal supported frequency in KHz
>> +
>> +Example:
>> +
>> +pcie@0,0 {
>> +     reg =3D <0x0000 0 0 0 0>;
>> +     ieee80211-min-center-freq =3D <2437000>;
>> +     ieee80211-max-center-freq =3D <2457000>;
>> +};
>
> Is this the proper level to define it. I was expecting a child node of
> the pci(e) controller. Maybe I am misreading the example.

This is device node, not a controller node (and yes, it's complete
node). You just need to add such a node inside the controller one.

It doesn't seem to be clearly documented, but you can see it in examples in=
:
Documentation/devicetree/bindings/pci/mvebu-pci.txt
Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
Documentation/devicetree/bindings/pci/pci-rcar-gen2.txt

The assignment is done in
pci_scan_device -> pci_set_of_node -> of_pci_find_child_device
(so this isn't controller specific thing).


--=20
Rafa=C5=82
