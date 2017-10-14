Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:38542 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753818AbdJNPny (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 14 Oct 2017 11:43:54 -0400
From: Christian Lamparter <chunkeey@gmail.com>
To: Felix Fietkau <nbd@nbd.name>
Cc: Rob Herring <robh@kernel.org>, linux-wireless@vger.kernel.org,
        kvalo@codeaurora.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v6 1/3] dt-bindings: net: add mt76 wireless device binding
Date: Sat, 14 Oct 2017 17:43:51 +0200
Message-ID: <1589476.LyXlx7DqTg@debian64> (sfid-20171014_174409_283923_0AA4E39A)
In-Reply-To: <3828919b-d634-9f03-22ad-1515219c31d4@nbd.name>
References: <20171006110249.31013-1-nbd@nbd.name> <20171013190749.lzzw4zjzt7fkp3hs@rob-hp-laptop> <3828919b-d634-9f03-22ad-1515219c31d4@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday, October 14, 2017 9:20:46 AM CEST Felix Fietkau wrote:
> On 2017-10-13 21:07, Rob Herring wrote:
> > On Fri, Oct 06, 2017 at 01:02:47PM +0200, Felix Fietkau wrote:
> >> Add documentation describing how device tree can be used to configure
> >> wireless chips supported by the mt76 driver.
> >> 
> >> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> >> ---
> >>  .../bindings/net/wireless/mediatek,mt76.txt        | 24 ++++++++++++++++++++++
> >>  1 file changed, 24 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
> >> 
> >> diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
> >> new file mode 100644
> >> index 000000000000..19522ab97d62
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
> >> @@ -0,0 +1,24 @@
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
> >> +- ieee80211-freq-limit: See ieee80211.txt
> >> +- mediatek,mtd-eeprom: Specify a MTD partition + offset containing EEPROM data
> > 
> > MTD is a Linuxism. And is an EEPROM the only supported device? I'd 
> > suggest naming if after what the data contains.
> PCI cards with this kind of wireless chip usually come with some form of
> EEPROM or use the on-chip OTP ROM.
> This property is for the case where the chip is built into an embedded
> device and the data that would otherwise be on an EEPROM is stored on a
> MTD partition instead.
> The EEPROM data itself contains multiple things: calibration data,
> hardware capabilities, MAC address, etc.
> I couldn't think of a better name for it, do you have any suggestions?
This sort of reminds me of the failed ath9k nvmem patches:
https://patchwork.kernel.org/patch/9622127/

Which uses the nvmem system.

https://github.com/torvalds/linux/blob/master/Documentation/nvmem/nvmem.txt

Rob, would this be acceptable?

Regards,
Christian
