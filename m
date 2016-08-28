Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:38296 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbcH1UwR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Aug 2016 16:52:17 -0400
MIME-Version: 1.0
In-Reply-To: <2913835.hr5kg63Vcv@wuerfel>
References: <20160709232834.31654-1-martin.blumenstingl@googlemail.com>
 <20160821143105.27487-1-martin.blumenstingl@googlemail.com>
 <20160821143105.27487-2-martin.blumenstingl@googlemail.com> <2913835.hr5kg63Vcv@wuerfel>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Sun, 28 Aug 2016 22:51:54 +0200
Message-ID: <CAFBinCAj0gFnKkqBrmUxCwXjsv6NY4KuWGRA4_mnXjq_boYx8w@mail.gmail.com> (sfid-20160828_225221_471129_9172CB3C)
Subject: Re: [PATCH v5 1/3] Documentation: dt: net: add ath9k wireless device binding
To: Arnd Bergmann <arnd@arndb.de>
Cc: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        mcgrof@do-not-panic.com, mark.rutland@arm.com, robh+dt@kernel.org,
        kvalo@codeaurora.org, chunkeey@googlemail.com,
        arend.vanspriel@broadcom.com, julian.calaby@gmail.com,
        bjorn@mork.no, linux@rempel-privat.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 22, 2016 at 11:08 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday, August 21, 2016 4:31:03 PM CEST Martin Blumenstingl wrote:
>> +pci {
>> +       pcie@0 {
>> +               reg = <0 0 0 0 0>;
>
> It's not clear what these two nodes refer to in the example. Is the top-level
> node the PCI host bridge, and the second node the first PCIe port?
>
> Maybe add the properties from a real system here to make this a little
> clearer.
>
> The unit address for the slot should be "00,0", not "0" here.
good point - I'll skip the part where I am describing the bridge as
well and keep it simple.

>> +               ath9k@0,0 {
>
> According to the PCI binding, the name should be the same as the
> compatible string here, or match the class code in the table.
The original example was from an actual system (where an ath9k is
connected to the PCIe bug). Unfortunately the PCIe driver contains
some hacks, so I'm not sure if these values serve as a good example.
Thus I took an example from a device where the ath9k chip is connected
via PCI (no "express" - found in sysfs at:
/sys/bus/pci/devices/0000:00:0e.0):
&pci0 {
    ath9k@168c,002d {
        compatible = "pci168c,002d";
        reg = <0x7000 0 0 0 0>;
        qca,disable-5ghz;
    };
};

>> +                       compatible = "pci168c,0030";
>> +                       reg = <0 0 0 0 0>;
>
> Are the device/fn numbers all zero on your system? This is a bit
> confusing, as it's not immediately clear what the reg properties
> refers to. Also, I think the length should reflect the actual length
> of the config space, either 0x100 or 0x1000.
The first issue is solved with the updated example (see above).
Where would the size go (is it the second-last or last value)?


Thanks for your patience!
Regards,
Martin
