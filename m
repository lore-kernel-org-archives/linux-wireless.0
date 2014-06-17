Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbaFQGcv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2014 02:32:51 -0400
Message-ID: <539FE0EC.5090003@redhat.com> (sfid-20140617_083255_438820_97A51A36)
Date: Tue, 17 Jun 2014 08:32:12 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	devicetree <devicetree@vger.kernel.org>,
	"open list:ATHEROS ATH5K WIR..." <linux-wireless@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Arend van Spriel <arend@broadcom.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/4] dt: bindings: add bindings for Broadcom bcm43xx
 sdio devices
References: <1402941407-8210-1-git-send-email-hdegoede@redhat.com> <1402941407-8210-2-git-send-email-hdegoede@redhat.com> <CAGVrzcZBzDTfnd6o0ib1FBvBK2VPNitS=rpb4jDkjF=T7Fy=DQ@mail.gmail.com>
In-Reply-To: <CAGVrzcZBzDTfnd6o0ib1FBvBK2VPNitS=rpb4jDkjF=T7Fy=DQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 06/16/2014 10:53 PM, Florian Fainelli wrote:
> 2014-06-16 10:56 GMT-07:00 Hans de Goede <hdegoede@redhat.com>:
>> From: Arend van Spriel <arend@broadcom.com>
>>
>> The Broadcom bcm43xx sdio devices are fullmac devices that may be
>> integrated in ARM platforms. Currently, the brcmfmac driver for
>> these devices support use of platform data. This patch specifies
>> the bindings that allow this platform data to be expressed in the
>> devicetree.
>>
>> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
>> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>> Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> [hdegoede@redhat.com: drop clk / reg_on gpio handling, as there is no consensus
>>  on how to handle this yet]
>> [hdegoede@redhat.com: move from bindings/staging to bindings]
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>  .../bindings/net/wireless/brcm,bcm43xx-fmac.txt    | 29 ++++++++++++++++++++++
>>  1 file changed, 29 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>>
>> diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>> new file mode 100644
>> index 0000000..6a0aaf2
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>> @@ -0,0 +1,29 @@
>> +Broadcom BCM43xx Fullmac wireless SDIO devices
>> +
>> +This node provides properties for controlling the Broadcom wireless device. The
>> +node is expected to be specified as a child node to the SDIO controller that
>> +connects the device to the system.
>> +
>> +Required properties:
>> +
>> + - compatible : Should be "brcm,bcm43xx-fmac".
> 
> In general, the use of a wildcard compatible string is discouraged
> over the use of a more descriptive compatible string. So you should
> find out what is the first chip that is compatible, and use that
> compatible string as long as that compatibility remains.

Right, Arend, what should we use then ?

>> +
>> +Optional properties:
>> + - brcm,drive-strength : drive strength used for SDIO pins on device.
>> +       (default = 6mA).
> 
> It would not hurt if you did specify the unit of the
> "brcm,drive-strength" property here. Also, if the default is 6, maybe
> the example below should be fixed to reflect that so people do not
> think that writing 4 to a register = 6 mA.

Ok will fix in the next version.

> 
>> + - interrupt-parent : the phandle for the interrupt controller to which the
>> +       device interrupts are connected.
>> + - interrupts : specifies attributes for the out-of-band interrupt (host-wake).
>> +       When not specified the device will use in-band SDIO interrupts.
>> + - interrupt-names : name of the out-of-band interrupt, which must be set
>> +       to "host-wake".
>> +
>> +Example:
>> +
>> +bcm4335 {
>> +       compatible = "brcm,bcm43xx-fmac";
>> +       brcm,drive-strength = <4>;
>> +       interrupt-parent = <&gpx2>;
>> +       interrupts = <5 IRQ_TYPE_LEVEL_HIGH>;
>> +       interrupt-names = "host-wake";
>> +};
>> --
>> 2.0.0
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
> 
> 
