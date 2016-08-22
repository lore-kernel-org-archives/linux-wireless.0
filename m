Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:62979 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752778AbcHVJKX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 05:10:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        mcgrof@do-not-panic.com, mark.rutland@arm.com, robh+dt@kernel.org,
        kvalo@codeaurora.org, chunkeey@googlemail.com,
        arend.vanspriel@broadcom.com, julian.calaby@gmail.com,
        bjorn@mork.no, linux@rempel-privat.de
Subject: Re: [PATCH v5 1/3] Documentation: dt: net: add ath9k wireless device binding
Date: Mon, 22 Aug 2016 11:08:56 +0200
Message-ID: <2913835.hr5kg63Vcv@wuerfel> (sfid-20160822_111027_456059_F6028F24)
In-Reply-To: <20160821143105.27487-2-martin.blumenstingl@googlemail.com>
References: <20160709232834.31654-1-martin.blumenstingl@googlemail.com> <20160821143105.27487-1-martin.blumenstingl@googlemail.com> <20160821143105.27487-2-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, August 21, 2016 4:31:03 PM CEST Martin Blumenstingl wrote:
> +pci {
> +       pcie@0 {
> +               reg = <0 0 0 0 0>;

It's not clear what these two nodes refer to in the example. Is the top-level
node the PCI host bridge, and the second node the first PCIe port?

Maybe add the properties from a real system here to make this a little
clearer.

The unit address for the slot should be "00,0", not "0" here.

> +               #interrupt-cells = <1>;
> +               #size-cells = <2>;
> +               #address-cells = <3>;
> +               device_type = "pci";
> +

I think this needs an empty "ranges" property to be a valid bridge node.

> +               ath9k@0,0 {

According to the PCI binding, the name should be the same as the
compatible string here, or match the class code in the table.

> +                       compatible = "pci168c,0030";
> +                       reg = <0 0 0 0 0>;

Are the device/fn numbers all zero on your system? This is a bit
confusing, as it's not immediately clear what the reg properties
refers to. Also, I think the length should reflect the actual length
of the config space, either 0x100 or 0x1000.

> +                       qca,disable-5ghz;
> +               };
> +       };
> +};

	Arnd
