Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35726 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754282AbdCTQmd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 12:42:33 -0400
MIME-Version: 1.0
In-Reply-To: <1919994.musG4GLznX@bentobox>
References: <20170310080615.22958-1-sven.eckelmann@openmesh.com>
 <20170320150733.25bufnzrhh7xabml@rob-hp-laptop> <1919994.musG4GLznX@bentobox>
From: Adrian Chadd <adrian@freebsd.org>
Date: Mon, 20 Mar 2017 09:42:05 -0700
Message-ID: <CAJ-Vmok=6Tcvr4NE9+KMSQ4OSd80e1DSkgbOqFcWnFT3A1ikgw@mail.gmail.com> (sfid-20170320_174523_026079_BB6248D5)
Subject: Re: [PATCH 1/2] dt: bindings: add new dt entry for ath10k calibration variant
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: Rob Herring <robh@kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Waldemar Rymarkiewicz <ext.waldemar.rymarkiewicz@tieto.com>,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vendors using ath10k will like this. I mean, I'm using ath10k, and I
really like this moving forward. This will make life so much easier in
the long run.

Everyone else isn't using board-2.bin; they're just copying
calibration/board data files over so the reference driver can assemble
a board data file based on wifi0/wifi1/etc probe order, and use that.



-adrian


On 20 March 2017 at 09:28, Sven Eckelmann <sven.eckelmann@openmesh.com> wro=
te:
> On Montag, 20. M=C3=A4rz 2017 10:07:33 CET Rob Herring wrote:
>> On Fri, Mar 10, 2017 at 09:06:14AM +0100, Sven Eckelmann wrote:
>> > The bus + bmi-chip-id + bmi-board-id is not enough to identify the cor=
rect
>> > board data file on QCA4019 based devices. Multiple different boards sh=
are
>> > the same values. Only the original reference designs can currently be
>> > identified and loaded from the board-2.bin. But these will not result =
in
>> > the correct calibration data when combined with the pre-calibration da=
ta
>> > from the device.
>> >
>> > An additional "variant" information has to be provided (via SMBIOS or =
DT)
>> > to select the correct board data for a design which was modified by an=
 ODM.
>> >
>> > Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
>> > ---
>> > Since RFC:
>> >
>> >  - Split patch in DT doc and ath10k part (thanks Christian Lamparter)
>> >  - Remove the words "bmi-chip-id" and "bmi-board-id" and replace them =
with
>> >    more generic "device specific ids"
>> > ---
>> >  Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 3 ++=
+
>> >  1 file changed, 3 insertions(+)
>> >
>> > diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10=
k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> > index 74d7f0af209c..3d2a031217da 100644
>> > --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> > +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> > @@ -41,6 +41,9 @@ Optional properties:
>> >  - qcom,msi_addr: MSI interrupt address.
>> >  - qcom,msi_base: Base value to add before writing MSI data into
>> >             MSI address register.
>> > +- qcom,ath10k-calibration-variant: string to search for in the board-=
2.bin
>> > +                              variant list with the same bus and devi=
ce
>> > +                              specific ids
>>
>> Sounds like you should use a more specific compatible string.
>
> Hm, this would require that each calibration data has an own compatibilit=
y
> string - which then has to be supported by ath10k, right? Doesn't sound l=
ike
> it would work well when each vendor (with an own calibration variant) wou=
ld
> have to modify ath10k to get it working. This sounds especially odd becau=
se
> nothing else in ath10k has to be changed. Only the board data files which=
 will
> be selected by ath10k are different on these devices.
>
> It would then up with something like this as compatibility string:
>
>  * qcom,ipq4019-wifi-asus-rt-ac58u
>  * qcom,ipq4019-wifi-fritzbox-4040
>  * qcom,ipq4019-wifi-netgear-whatever
>  * qcom,ipq4019-wifi-openmesh-i-have-no-idea
>  * ...
>
> But maybe I misunderstood what you've said.
>
> Kind regards,
>         Sven
