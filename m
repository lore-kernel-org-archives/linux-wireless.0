Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757172AbdCUNBL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Mar 2017 09:01:11 -0400
MIME-Version: 1.0
In-Reply-To: <1919994.musG4GLznX@bentobox>
References: <20170310080615.22958-1-sven.eckelmann@openmesh.com>
 <20170320150733.25bufnzrhh7xabml@rob-hp-laptop> <1919994.musG4GLznX@bentobox>
From: Rob Herring <robh@kernel.org>
Date: Tue, 21 Mar 2017 08:00:34 -0500
Message-ID: <CAL_Jsq+aEdjq9MR--Hyrw17KoKv=uZ7OBsAqX1_0+Djpw+QUCg@mail.gmail.com> (sfid-20170321_140148_637244_F5D8C195)
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

On Mon, Mar 20, 2017 at 11:28 AM, Sven Eckelmann
<sven.eckelmann@openmesh.com> wrote:
> On Montag, 20. März 2017 10:07:33 CET Rob Herring wrote:
>> On Fri, Mar 10, 2017 at 09:06:14AM +0100, Sven Eckelmann wrote:
>> > The bus + bmi-chip-id + bmi-board-id is not enough to identify the correct
>> > board data file on QCA4019 based devices. Multiple different boards share
>> > the same values. Only the original reference designs can currently be
>> > identified and loaded from the board-2.bin. But these will not result in
>> > the correct calibration data when combined with the pre-calibration data
>> > from the device.
>> >
>> > An additional "variant" information has to be provided (via SMBIOS or DT)
>> > to select the correct board data for a design which was modified by an ODM.
>> >
>> > Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
>> > ---
>> > Since RFC:
>> >
>> >  - Split patch in DT doc and ath10k part (thanks Christian Lamparter)
>> >  - Remove the words "bmi-chip-id" and "bmi-board-id" and replace them with
>> >    more generic "device specific ids"
>> > ---
>> >  Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 3 +++
>> >  1 file changed, 3 insertions(+)
>> >
>> > diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> > index 74d7f0af209c..3d2a031217da 100644
>> > --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> > +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> > @@ -41,6 +41,9 @@ Optional properties:
>> >  - qcom,msi_addr: MSI interrupt address.
>> >  - qcom,msi_base: Base value to add before writing MSI data into
>> >             MSI address register.
>> > +- qcom,ath10k-calibration-variant: string to search for in the board-2.bin
>> > +                              variant list with the same bus and device
>> > +                              specific ids
>>
>> Sounds like you should use a more specific compatible string.
>
> Hm, this would require that each calibration data has an own compatibility
> string - which then has to be supported by ath10k, right? Doesn't sound like
> it would work well when each vendor (with an own calibration variant) would
> have to modify ath10k to get it working. This sounds especially odd because
> nothing else in ath10k has to be changed. Only the board data files which will
> be selected by ath10k are different on these devices.
>
> It would then up with something like this as compatibility string:
>
>  * qcom,ipq4019-wifi-asus-rt-ac58u
>  * qcom,ipq4019-wifi-fritzbox-4040
>  * qcom,ipq4019-wifi-netgear-whatever
>  * qcom,ipq4019-wifi-openmesh-i-have-no-idea
>  * ...

Are these all the same board design or variations? In the latter case,
you should have specific compatibles anyway. Now if the variants are
the same hardware, but different configurations say for different
regions or something, then I'd say a separate property is fine.

We already have a "firmware-name" property. Would that work for you?

Rob
