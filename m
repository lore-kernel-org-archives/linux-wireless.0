Return-Path: <SRS0=0pA5=NS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A60E4C0044C
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 10:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6301B2086B
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 10:47:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CPDLw1zY";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hN8HtxpR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6301B2086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730656AbeKGURS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Nov 2018 15:17:18 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44844 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbeKGURS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Nov 2018 15:17:18 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 985BA60AD8; Wed,  7 Nov 2018 10:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541587649;
        bh=hthC/oTpv5mahJpEPqMH3i8+CVeUaEgjjz6Mqp45oCs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CPDLw1zYp8wStj4O1LVoFJLEwl594yCPG2VSDjuSNe77rea5Iu6m3QTZqT4FRqOxK
         tXimpkmCoAuUTNx8fU1VS6RPuJvxrmFNKLCDhotEyGPY63wEt+p8IK8WevQe+PQ8Ny
         prcTMAaRLsVtJgwuBhHtOsBPhkb5D56eG3T7dP/Q=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 2978E60247;
        Wed,  7 Nov 2018 10:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541587648;
        bh=hthC/oTpv5mahJpEPqMH3i8+CVeUaEgjjz6Mqp45oCs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hN8HtxpRLQT5qpakLI23Z3k7RZWeJvIKR/S6cCXgmA4OAVc5u4RSRXdg0v8tqwG9w
         6L7SbO0ow+F1PFiBfvJ3HJQyXwDaQz4mfqw3qh3bZHXQdIt5WuU6enUGNeEQZmjJ0X
         L7uOJYTR+VGIRmm/UU6fB3czTB4g3vGDE2neV7m0=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 07 Nov 2018 16:17:28 +0530
From:   Bhagavathi Perumal S <bperumal@codeaurora.org>
To:     Rob Herring <robh@kernel.org>
Cc:     ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] dt: bindings: add new dt entry to indentify external
 FEM
In-Reply-To: <CAL_JsqLTxzFSQ6jvZo7CCcxBML6Y5j2AvAOotnVDJGTh-1K7ZA@mail.gmail.com>
References: <1538653364-1239-1-git-send-email-bperumal@codeaurora.org>
 <1538653364-1239-2-git-send-email-bperumal@codeaurora.org>
 <20181015192425.GA19699@bogus>
 <d617b0c39a2faa7c9b23b884bef3f829@codeaurora.org>
 <CAL_JsqLTxzFSQ6jvZo7CCcxBML6Y5j2AvAOotnVDJGTh-1K7ZA@mail.gmail.com>
Message-ID: <9632d0a95cf96d777081d2a1d3c12dca@codeaurora.org>
X-Sender: bperumal@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-30 21:02, Rob Herring wrote:
> On Tue, Oct 30, 2018 at 3:41 AM <bperumal@codeaurora.org> wrote:
>> 
>> On 2018-10-16 00:54, Rob Herring wrote:
>> > On Thu, Oct 04, 2018 at 05:12:43PM +0530, Bhagavathi Perumal S wrote:
>> >> This adds new dt entry ext-fem-name, it is used by ath10k driver
>> >> to select correct timing parameters and configure it in target wifi
>> >> hardware.
>> >> The Front End Module(FEM) normally includes tx power amplifier(PA) and
>> >> rx low noise amplifier(LNA). The default timing parameters like tx end
>> >> to
>> >> PA off timing values were fine tuned for internal FEM used in
>> >> reference
>> >> design. And these timing values can not be same if ODM modifies
>> >> hardware
>> >> design with different external FEM. This DT entry helps to choose
>> >> correct
>> >> timing values in driver if different external FEM hardware used.
>> >
>> > 'dt-bindings: net: ath10k: ...' for the subject please.
>> Sure, I will change and send v2 patch.
>> 
>> >
>> >>
>> >> Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
>> >> ---
>> >>  .../bindings/net/wireless/qcom,ath10k.txt          | 22
>> >> ++++++++++++++++++++++
>> >>  1 file changed, 22 insertions(+)
>> >>
>> >> diff --git
>> >> a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> >> b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> >> index 7fd4e8c..fbaf309 100644
>> >> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> >> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> >> @@ -56,6 +56,7 @@ Optional properties:
>> >>                                   the length can vary between hw versions.
>> >>  - <supply-name>-supply: handle to the regulator device tree node
>> >>                         optional "supply-name" is "vdd-0.8-cx-mx".
>> >> +- ext-fem-name: name of external front end module used.
>> >
>> > What are valid names? What if the OS doesn't recognize the name?
>> > Perhaps
>> Some valid FEM devices are "microsemi-lx5586", "sky85703-11" and
>> "sky85803" etc.
>> Currently driver accepts only "microsemi-lx5586", Since this FEM
>> requires different timing settings,
> 
> Assuming you keep this, then you need to enumerate what are valid
> values in the binding. Otherwise, 'ext-fem-name = "rob"' is valid.

Sure, Will enumerate valid values in v2 patch.
> 
>> And it can be extended for other FEM devices in future.
>> If OS doesn't recognize the name, it uses predefined default timing
>> settings.
>> 
>> > this should be a compatible string for the particular module instead?
>> > Then it could cover any differences, not just the FEM.
>> >
>> No, it is specific to FEM device.
> 
> You will be better off having either a specific compatible string or
> using VID/PID as this is a PCI device. Then you can handle other
> differences you may find between h/w versions without a DT change.
> 

FEM is a part of wifi device, and not a separate PCI device. Different 
external
FEM can be used in a same wifi device, so it might not be feasible to 
define
a compatible string to cover any other differences. IMO we can go with
the property name instead of defining compatible string specific to
every FEM device.

>> >>
>> >>  Example (to supply the calibration data alone):
>> >>
>> >> @@ -150,3 +151,24 @@ wifi@18000000 {
>> >>                         <0 141 0 /* CE11 */ >;
>> >>              vdd-0.8-cx-mx-supply = <&pm8998_l5>;
>> >>  };
>> >> +
>> >> +Example (to supply the external front end module name):
>> >> +
>> >> +In this example, the front end module is defined as a property of the
>> >> ath10k
>> >> +device node.
>> >
>> > Really need a whole new example for 1 property?
>> Will add this property in existing example.
>> 
>> >
>> >> +
>> >> +pci {
>> >> +    pcie@0 {
>> >> +            reg = <0 0 0 0 0>;
>> >> +            #interrupt-cells = <1>;
>> >> +            #size-cells = <2>;
>> >> +            #address-cells = <3>;
>> >> +            device_type = "pci";
>> >> +
>> >> +            ath10k@0,0 {
>> >
>> > wifi@0,0
>> Added in ath10k@0,0 to make consistent with existing property
>> "qcom,ath10k-calibration-data" below,
>> "
> 
> I don't see how that matters.
> 
>> pci {
>>          pcie@0 {
>>                  reg = <0 0 0 0 0>;
>>                  #interrupt-cells = <1>;
>>                  #size-cells = <2>;
>>                  #address-cells = <3>;
>>                  device_type = "pci";
>> 
>>                  ath10k@0,0 {
>>                          reg = <0 0 0 0 0>;
>>                          device_type = "pci";
>>                          qcom,ath10k-calibration-data = [ 01 02 03 ... 
>> ];
>>                  };
>>          };
>> };
>> "
>> 
>> If wifi@0,0 is preferable, then I will add new entry "wifi@0,0" and 
>> add
>> ext-fem-name into it.
> 
> Node names are supposed to reflect the class of device, not the model.
> See the DT spec for a list.

Will change accordingly.

> 
>> 
>> >
>> >> +                    reg = <0 0 0 0 0>;
>> >> +                    device_type = "pci";
> 
> Also, this is wrong. Only PCI bridges should have this property. dtc
> will give you a warning on this.

Will remove it in v2 patch.

> 
>> >> +                    ext-fem-name = "microsemi-lx5586";
>> >> +            };
>> >> +    };
>> >> +};
>> >> --
>> >> 1.9.1
>> >>
>> 
>> Thanks, Sorry for the delayed response,
>> Bhagavathi Perumal S.
