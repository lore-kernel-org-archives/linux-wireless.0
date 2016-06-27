Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36695 "EHLO
	mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbcF0AUq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jun 2016 20:20:46 -0400
Received: by mail-it0-f65.google.com with SMTP id h190so8603287ith.3
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jun 2016 17:20:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160624123430.4097-2-martin.blumenstingl@googlemail.com>
References: <20160624123430.4097-1-martin.blumenstingl@googlemail.com> <20160624123430.4097-2-martin.blumenstingl@googlemail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 27 Jun 2016 10:20:26 +1000
Message-ID: <CAGRGNgUeFJevhRVUPUoUvzLfkqst=jf2sCz3+ew8AeY=4ruR8w@mail.gmail.com> (sfid-20160627_022049_909419_019F7A21)
Subject: Re: [PATCH RFC v3 1/3] Documentation: dt: net: add ath9k wireless
 device binding
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, Felix Fietkau <nbd@nbd.name>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Rob Herring <robh+dt@kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Martin,

On Fri, Jun 24, 2016 at 10:34 PM, Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
> Add documentation how devicetree can be used to configure ath9k based
> devices.
>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
> changes in v2 -> v3:
> - improved wording of the qca,disable-2ghz and qca,disable-5ghz properties
> - replaced qca,eeprom-name with qca,no-eeprom (the eeprom name is now
>   built automatically within ath9k). The naming was chosen to stay
>   consistent with other drivers (such as davicom-dm9000 and via-velocity)
> - added reference to the mac-address and local-mac-address properties
> - removed invalid device_type property from the example
>
>  .../devicetree/bindings/net/wireless/qca,ath9k.txt | 46 ++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
>
> diff --git a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
> new file mode 100644
> index 0000000..ff83fd4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
> @@ -0,0 +1,46 @@
> +* Qualcomm Atheros ath9k wireless devices
> +
> +This node provides properties for configuring the ath9k wireless device. The
> +node is expected to be specified as a child node of the PCI controller to
> +which the wireless chip is connected.
> +
> +Required properties:
> +- compatible: Should be "qca,ath9k"
> +
> +Optional properties:
> +- reg: Address and length of the register set for the device.
> +- qca,gpio-mask: The GPIO mask
> +- qca,gpio-val: The GPIO value
> +- qca,led-pin: The GPIO number to which the LED is connected
> +- qca,led-active-high: The LED is active when the GPIO is HIGH
> +- qca,clk-25mhz: Defines that at 25MHz clock is used
> +- qca,no-eeprom: Indicates that there is on physical EEPROM connected

Typo: ...Indicates that there is _no_ physical EEPROM...

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
