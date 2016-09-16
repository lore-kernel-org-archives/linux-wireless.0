Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34119 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934636AbcIPMpn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2016 08:45:43 -0400
Date: Fri, 16 Sep 2016 07:45:41 -0500
From: Rob Herring <robh@kernel.org>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
        ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        mcgrof@do-not-panic.com, mark.rutland@arm.com,
        kvalo@codeaurora.org, chunkeey@googlemail.com,
        arend.vanspriel@broadcom.com, julian.calaby@gmail.com,
        bjorn@mork.no, nbd@nbd.name, arnd@arndb.de
Subject: Re: [PATCH v6 1/3] Documentation: dt: net: add ath9k wireless device
 binding
Message-ID: <20160916124541.GB9689@rob-hp-laptop> (sfid-20160916_144547_803739_9CDC7481)
References: <20160821143105.27487-1-martin.blumenstingl@googlemail.com>
 <20160906214623.20424-1-martin.blumenstingl@googlemail.com>
 <20160906214623.20424-2-martin.blumenstingl@googlemail.com>
 <3b93ec95-ec7c-863a-06b7-fab4f2688855@rempel-privat.de>
 <CAFBinCAOQmk3KY1b+D1iKAOEBfasYyei681cae4PbD+201mzbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFBinCAOQmk3KY1b+D1iKAOEBfasYyei681cae4PbD+201mzbQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 09, 2016 at 10:57:06PM +0200, Martin Blumenstingl wrote:
> On Fri, Sep 9, 2016 at 9:48 AM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> >> +Optional properties:
> >> +- reg: Address and length of the register set for the device.
> >> +- qca,clk-25mhz: Defines that a 25MHz clock is used
> >
> > Some SoCs even Atheros WiSoCs use WiFi clock for System Clock. In this
> > case we need to use clock framework any way, so why not in this case too?
> > Provide dummy static clock in DT and connect it with this node?
> >
> >         osc25m: oscillator {
> >                 compatible = "fixed-clock";
> >                 #clock-cells = <0>;
> >                 clock-frequency = <25000000>;
> >                 clock-accuracy = <30000>;
> >         };
> >
> >         acc: clock-controller@80040000 {
> >                 compatible = "some-clock-controller";
> >                 #clock-cells = <1>;
> >                 clocks = <&osc25m>;
> >                 reg = <0x80040000 0x204>;
> >         };
> >
> >
> > &pci0 {
> >         ath9k@168c,002d {
> >                 compatible = "pci168c,002d";
> >                 reg = <0x7000 0 0 0 0x1000>;
> >                 clocks = <&osc25m>;
> >                 qca,disable-5ghz;
> >         };
> > };
> >
> >
> > driver will need to use clk_get and compare frequency instead of
> > of_property_read_bool(np, "qca,clk-25mhz"). In this case you will need
> > to define source clock only one time and reuse it by all affected DT
> > nodes. If we have 40MHz clock you will only need to change it in
> > fixed-clock.
> that does sound like a good idea, thanks for that input!
> However, I will remove the property for the first version because I am
> trying to get PCI(e) devices supported. OF support for AHB (WiSoC)
> needs more work (in other places, like ahb.c) anyways.
> But this suggestion should be remembered!
> 
> >> +- qca,no-eeprom: Indicates that there is no physical EEPROM connected to the
> >> +                     ath9k wireless chip (in this case the calibration /
> >> +                     EEPROM data will be loaded from userspace using the
> >> +                     kernel firmware loader).
> >> +- qca,disable-2ghz: Overrides the settings from the EEPROM and disables the
> >> +                     2.4GHz band. Setting this property is only needed
> >> +                     when the RF circuit does not support the 2.4GHz band
> >> +                     while it is enabled nevertheless in the EEPROM.
> >> +- qca,disable-5ghz: Overrides the settings from the EEPROM and disables the
> >> +                     5GHz band. Setting this property is only needed when
> >> +                     the RF circuit does not support the 5GHz band while
> >> +                     it is enabled nevertheless in the EEPROM.
> >
> > This option can be reused for every WiFi controller. Not only for qca.
> > So may be instead of adding vendor specific name, make it reusable for
> > all vendors. Instead of qca,disable-5ghz and qca,disable-2ghz make
> > disable-5ghz and disable-2ghz?

Fine, but if you do this then document in a common location.

> I am personally fine with anything that fits best into the grand
> scheme of things.
> There are three scenarios I can think of which may be influenced by
> devicetree configuration:
> a) let the driver decide automatically whether the 2.4GHz and/or 5GHz
> band is/are enabled
> b) explicitly disable either bands (because the driver thinks due to
> whatever reason that a band is supported while in reality it isn't)
> c) explicitly enable a band (for example because the driver cannot
> automagically detect which band should be enabled)
> 
> for ath9k we default to a) but also allow b): the EEPROM (device
> specific calibration data) contains information about which bands are
> enabled (or not). But some manufacturers are shipping devices for
> example with the 5G band enabled, while the actual hardware doesn't
> support it.

And you can't determine that based on different device IDs? If you can 
use vendor/device ID, then you should. If not, then this is fine.

Is it possible to have no EEPROM at all? If so, you might want to just 
put the raw EEPROM data into DT rather than a property for every field 
(I'm assuming there's more than just what you have properties for now).

Rob
