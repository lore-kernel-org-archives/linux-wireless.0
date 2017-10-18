Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48140 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761114AbdJRGr3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 02:47:29 -0400
Subject: Re: [PATCH v6 1/3] dt-bindings: net: add mt76 wireless device binding
To: Rob Herring <robh@kernel.org>,
        Christian Lamparter <chunkeey@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <20171006110249.31013-1-nbd@nbd.name>
 <20171013190749.lzzw4zjzt7fkp3hs@rob-hp-laptop>
 <3828919b-d634-9f03-22ad-1515219c31d4@nbd.name> <1589476.LyXlx7DqTg@debian64>
 <CAL_JsqLNhA2ZjMCKP1FJ1UG_VdMhJYfdyG6CX=3HYZ+k9_HROA@mail.gmail.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <107987d8-4777-0c3f-bef8-fb63467d7593@nbd.name> (sfid-20171018_084734_913607_ABD3DA2C)
Date: Wed, 18 Oct 2017 08:47:26 +0200
MIME-Version: 1.0
In-Reply-To: <CAL_JsqLNhA2ZjMCKP1FJ1UG_VdMhJYfdyG6CX=3HYZ+k9_HROA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-10-18 04:02, Rob Herring wrote:
> On Sat, Oct 14, 2017 at 10:43 AM, Christian Lamparter
> <chunkeey@gmail.com> wrote:
>> On Saturday, October 14, 2017 9:20:46 AM CEST Felix Fietkau wrote:
>>> On 2017-10-13 21:07, Rob Herring wrote:
>>> > On Fri, Oct 06, 2017 at 01:02:47PM +0200, Felix Fietkau wrote:
>>> >> Add documentation describing how device tree can be used to configure
>>> >> wireless chips supported by the mt76 driver.
>>> >>
>>> >> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>>> >> ---
>>> >>  .../bindings/net/wireless/mediatek,mt76.txt        | 24 ++++++++++++++++++++++
>>> >>  1 file changed, 24 insertions(+)
>>> >>  create mode 100644 Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
>>> >>
>>> >> diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
>>> >> new file mode 100644
>>> >> index 000000000000..19522ab97d62
>>> >> --- /dev/null
>>> >> +++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
>>> >> @@ -0,0 +1,24 @@
>>> >> +* MediaTek mt76xx devices
>>> >> +
>>> >> +This node provides properties for configuring the MediaTek mt76xx wireless
>>> >> +device. The node is expected to be specified as a child node of the PCI
>>> >> +controller to which the wireless chip is connected.
>>> >> +
>>> >> +Optional properties:
>>> >> +
>>> >> +- mac-address: See ethernet.txt in the parent directory
>>> >> +- local-mac-address: See ethernet.txt in the parent directory
>>> >> +- ieee80211-freq-limit: See ieee80211.txt
>>> >> +- mediatek,mtd-eeprom: Specify a MTD partition + offset containing EEPROM data
>>> >
>>> > MTD is a Linuxism. And is an EEPROM the only supported device? I'd
>>> > suggest naming if after what the data contains.
>>> PCI cards with this kind of wireless chip usually come with some form of
>>> EEPROM or use the on-chip OTP ROM.
>>> This property is for the case where the chip is built into an embedded
>>> device and the data that would otherwise be on an EEPROM is stored on a
>>> MTD partition instead.
>>> The EEPROM data itself contains multiple things: calibration data,
>>> hardware capabilities, MAC address, etc.
>>> I couldn't think of a better name for it, do you have any suggestions?
> 
> Naming is hard.
> 
>> This sort of reminds me of the failed ath9k nvmem patches:
>> https://patchwork.kernel.org/patch/9622127/
>>
>> Which uses the nvmem system.
>>
>> https://github.com/torvalds/linux/blob/master/Documentation/nvmem/nvmem.txt
>>
>> Rob, would this be acceptable?
> 
> Yeah, alignment with other drivers is a good thing.
This depends on another round of patches which also never made it 
upstream and from reading the thread[1], I'm not actually sure what's 
missing, or what should be changed.

I'm also not convinced that this makes things better in any meaningful 
way. It pulls in extra dependencies (nvmem subsystem), which means 
more kernel bloat for embedded systems, which are currently the only
ones that even need this.

Would it be acceptable to you if I submit an updated version that fixes 
the other things you pointed out?

- Felix

[1]: http://lists.infradead.org/pipermail/linux-mtd/2017-March/072541.html
