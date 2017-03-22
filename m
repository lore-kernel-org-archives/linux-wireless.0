Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758535AbdCVC6x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Mar 2017 22:58:53 -0400
MIME-Version: 1.0
In-Reply-To: <5158144.BXJK97egUR@bentobox>
References: <20170310080615.22958-1-sven.eckelmann@openmesh.com>
 <1919994.musG4GLznX@bentobox> <CAL_Jsq+aEdjq9MR--Hyrw17KoKv=uZ7OBsAqX1_0+Djpw+QUCg@mail.gmail.com>
 <5158144.BXJK97egUR@bentobox>
From: Rob Herring <robh@kernel.org>
Date: Tue, 21 Mar 2017 21:56:54 -0500
Message-ID: <CAL_JsqKSBA8WcR9Q8+6+kVfYoPggZ83yQ_47LWf971Aegqv4yA@mail.gmail.com> (sfid-20170322_035925_876213_B61C9DB9)
Subject: Re: [PATCH 1/2] dt: bindings: add new dt entry for ath10k calibration variant
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        ext.waldemar.rymarkiewicz@tieto.com,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 21, 2017 at 9:33 AM, Sven Eckelmann
<sven.eckelmann@openmesh.com> wrote:
> On Dienstag, 21. März 2017 08:00:34 CET Rob Herring wrote:
> [...]
>> > It would then up with something like this as compatibility string:
>> >
>> >  * qcom,ipq4019-wifi-asus-rt-ac58u
>> >  * qcom,ipq4019-wifi-fritzbox-4040
>> >  * qcom,ipq4019-wifi-netgear-whatever
>> >  * qcom,ipq4019-wifi-openmesh-i-have-no-idea
>> >  * ...
>>
>> Are these all the same board design or variations? In the latter case,
>> you should have specific compatibles anyway. Now if the variants are
>> the same hardware, but different configurations say for different
>> regions or something, then I'd say a separate property is fine.
>>
>> We already have a "firmware-name" property. Would that work for you?
>
> Hm, maybe we should specify some names better:
>
> "qcom,ipq4019-wifi" == compatibility string for WiFi hardware inside the SoC.
> It is the one which ath10k supports on the Atheros Host Bus (ahb) of the
> QCA4019.
>
> The ath10k driver will use the information from these nodes to initialize the
> device. It will basically:
>
> 1. load a firmware(-5).bin from /lib/firmware/ath10k/QCA4019/hw1.0/
> 2. load the pre-cal (aka first part of calibration) data from
>    /lib/firmware/ath10k/pre-cal-*
> 3. do some firmware magic to identify the reference design
> 4. load board data "files" (BDF) for this reference design from
>     /lib/firmware/ath10k/QCA4019/hw1.0/board-2.bin
> 5. send the BDF data to the firmware to let it compute the final calibration
>    data
> 6. start the actual wifi stuff
>
> The IPQ4018/4019 SoC doesn't contain the actual RF parts. There are a couple
> of reference designs (SoC+RF parts) from QCA which got official numbers. These
> numbers identify the BDFs inside the board-2.bin. And the board-2.bin is not
> the firmware - it is a container for multiple BDFs.
>
>
> To summarize:
>
>  * pre-cal is some data stored in a special partition of the devices and will
>    not be overwritten on updates
>  * board-2.bin are multiple BDF files containing the second part of the
>    calibration data
>  * pre-cal + BDF (+ some OTP stuff) are getting combined to form the complete
>    calibration data
>
> Asus RT-AC58U, Fritzbox 4040 and ZyXEL NBG6617 are products based on the same
> reference design. But of course, some (all?) fiddled around with the RF parts
> and therefore require special BDFs. They still use the same SoC and require
> that the closed source ath10k firmware behaves like on the official reference
> designs. Only the BDFs have to be different.

Is this always the case? There's never some variation beyond the
reference design that a BDF difference can't handle?

> So you could say that the wifi-chip hardware (part of the QCA4018/4019 SoC) is
> the same between these different products. But the hardware around the SoC is
> different and therefore requires a different "configuration"/calibration for
> the surrounding RF hardware. It is not a perfect match for your "separate
> property is fine" compromise. Maybe you still meant this - I let you decide.
>
>
> This is not only a problem on QCA4019 but also for other devices supported by
> ath10k. Waldemar Rymarkiewicz introduced the concept of BDF variants for
> this [1] and implemented the support for SMBIOS. The variant string (generated
> from the SMBIOS data) is then used by ath10k when it searches for the correct
> BDFs in the board-2.bin. Kalle Valo suggested to use the same mechanism for
> QCA401X based boards (which don't use SMBIOS).
>
> The "qcom,ath10k-calibration-variant" is now the (more or less) equivalent of
> the SMBIOS entry - but for device tree users. Let us assume that the variant
> string would be "RT-AC58U" for the Asus RT-AC58U and the first wifi device
> (bmi-board-id=16) gets initialized [2]. Then the step 4 would get splitted in
> following steps:
>
> 4.1. Get the the qcom,ath10k-calibration-variant content
> 4.2. jump to 4.5. when there is no qcom,ath10k-calibration-variant
> 4.3. calculate BDF search name with variant string
>      "bus=ahb,bmi-chip-id=0,bmi-board-id=16,variant=RT-AC58U"
> 4.4. load BDF and when found, jump to 5.
> 4.5. calculate BDF search name without variant string
>      "bus=ahb,bmi-chip-id=0,bmi-board-id=16"
> 4.6. load the BDF
>
>
> There would be no changes in ath10k when adding a new BDF calibration variant
> using qcom,ath10k-calibration-variant. Only the device tree node would have to
> be updated:
>
>  * device tree (simplified):
>     / {
>       model = "ASUS RT-AC58U";
>
>       soc {
>         wifi@a000000 {
>           compatible = "qcom,ipq4019-wifi";
>           reg = <0xa000000 0x200000>;
>           status = "okay";
>           qcom,ath10k-calibration-variant = "RT-AC58U";
>         };
>
>         wifi@a800000 {
>           compatible = "qcom,ipq4019-wifi";
>           reg = <0xa800000 0x200000>;
>           status = "okay";
>           qcom,ath10k-calibration-variant = "RT-AC58U";
>         };
>       };
>     };
>  * ath10k + ath10k-firmware
>    <no change>
>
>
>
>
> This about how the calibration [insert swearword] works for
> "qcom,ipq4019-wifi" and why the "qcom,ath10k-calibration-variant" was used in
> my first implementation. But then you've suggested to "use a more specific
> compatible string". This information was not enough for me to understand what
> you've actually meant. I was therefore proposing some examples which show what
> you maybe could have meant. These were following things:
>
>> >  * qcom,ipq4019-wifi-asus-rt-ac58u
>> >  * qcom,ipq4019-wifi-fritzbox-4040
>> >  * qcom,ipq4019-wifi-netgear-whatever
>> >  * qcom,ipq4019-wifi-openmesh-i-have-no-idea
>
> They are basically "qcom,ipq4019-wifi" + a product specific string. The first
> part is therefore the string which identifies the wifi device(s) in the
> QCA4018/4019 SoC. The product specific string is simply the part (or a
> variation of it) which would been used before in
> "qcom,ath10k-calibration-variant" - just to make it "use a more specific
> compatible string".

It would probably be more like: "asus,rt-ac58u-wifi", "qcom,ipq4019-wifi"

A more specific compatible is insurance that at some later point in
time you can distinguish between 2 boards due to some difference even
if now you believe they are "the same".

> I have no idea if this is really what you meant. I just wanted to give you
> some examples and explanations why I don't feel that this a good idea. I
> thought that this would help you to point me in the right direction and
> explain better what you've meant.
>
> Right now it looks to me like following must be done for your(?) proposal for
> each new board:
>
>  * device tree (simplified):
>     / {
>       model = "ASUS RT-AC58U";
>
>       soc {
>         wifi@a000000 {
>           compatible = "qcom,ipq4019-wifi-asus-rt-ac58u";
>           reg = <0xa000000 0x200000>;
>           status = "okay";
>         };
>
>         wifi@a800000 {
>           compatible = "qcom,ipq4019-wifi-asus-rt-ac58u";
>           reg = <0xa800000 0x200000>;
>           status = "okay";
>         };
>       };
>     };
>  * ath10k + ath10k-firmware
>    - add qcom,ipq4019-wifi-asus-rt-ac58u to
>      Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>    - add qcom,ipq4019-wifi-asus-rt-ac58u to ath10k_ahb_of_match in
>      drivers/net/wireless/ath/ath10k/ahb.c
>    - add a mapping from qcom,ipq4019-wifi-asus-rt-ac58u to the RT-AC58U
>      variant string somewhere in ath10k
>
>
> I hope this is enough to understand it a little bit better.

I think the separate property is fine if this is the only one you
envision needing to add. If there's 10 more properties, then I'd feel
more strongly towards a board specific compatible string.

Rob
