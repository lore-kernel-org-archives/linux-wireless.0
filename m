Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:58505 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932628AbcH2MMv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 08:12:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: Re: [PATCH v5 1/3] Documentation: dt: net: add ath9k wireless device binding
Date: Mon, 29 Aug 2016 14:12:23 +0200
Cc: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        mcgrof@do-not-panic.com, mark.rutland@arm.com, robh+dt@kernel.org,
        kvalo@codeaurora.org, chunkeey@googlemail.com,
        arend.vanspriel@broadcom.com, julian.calaby@gmail.com,
        bjorn@mork.no, linux@rempel-privat.de
References: <20160709232834.31654-1-martin.blumenstingl@googlemail.com> <2913835.hr5kg63Vcv@wuerfel> <CAFBinCAj0gFnKkqBrmUxCwXjsv6NY4KuWGRA4_mnXjq_boYx8w@mail.gmail.com>
In-Reply-To: <CAFBinCAj0gFnKkqBrmUxCwXjsv6NY4KuWGRA4_mnXjq_boYx8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201608291412.23530.arnd@arndb.de> (sfid-20160829_141254_192423_F51F0C8E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 28 August 2016, Martin Blumenstingl wrote:
> On Mon, Aug 22, 2016 at 11:08 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Sunday, August 21, 2016 4:31:03 PM CEST Martin Blumenstingl wrote:
> >> +               ath9k@0,0 {
> >
> > According to the PCI binding, the name should be the same as the
> > compatible string here, or match the class code in the table.
> The original example was from an actual system (where an ath9k is
> connected to the PCIe bug). Unfortunately the PCIe driver contains
> some hacks, so I'm not sure if these values serve as a good example.
> Thus I took an example from a device where the ath9k chip is connected
> via PCI (no "express" - found in sysfs at:
> /sys/bus/pci/devices/0000:00:0e.0):
> &pci0 {
>     ath9k@168c,002d {
>         compatible = "pci168c,002d";
>         reg = <0x7000 0 0 0 0>;
>         qca,disable-5ghz;
>     };
> };

Ok, that would be a better example.


> >> +                       compatible = "pci168c,0030";
> >> +                       reg = <0 0 0 0 0>;
> >
> > Are the device/fn numbers all zero on your system? This is a bit
> > confusing, as it's not immediately clear what the reg properties
> > refers to. Also, I think the length should reflect the actual length
> > of the config space, either 0x100 or 0x1000.
> The first issue is solved with the updated example (see above).
> Where would the size go (is it the second-last or last value)?

The last one.

	Arnd
