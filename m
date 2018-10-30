Return-Path: <SRS0=qkCK=NK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E4DCC2BC61
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 12:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFF2120831
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 12:40:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="N6RoUTGj";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="B0rR7S0t"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFF2120831
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbeJ3VdU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 17:33:20 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36834 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbeJ3VdU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 17:33:20 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4567E60792; Tue, 30 Oct 2018 12:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540903202;
        bh=kDQlJSw336nRfcEev5qgkcaP3FBX3+FdOh/aiYrRPNs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N6RoUTGjmrrWf+keyAxhQW/lirUx8ys0W9IEx5uFF9BpDGViR4LTKS/EQzgmnUMcL
         5I0iBKcGbfr1njrmpBTf4/KL+81ptCCfe+P8TGLptym8l0onV0675EH2DbtT3eOU3A
         P7i5QKKxeUlUcrx8I173Kn3PQTx0Kza98xRgS4UM=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 460966034F;
        Tue, 30 Oct 2018 12:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540903201;
        bh=kDQlJSw336nRfcEev5qgkcaP3FBX3+FdOh/aiYrRPNs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B0rR7S0tewQ/G1F4wIR7fbUsXpaqumQGO8vxjo6RdQT9ny69tPLrh7vC7Yz77POE7
         WHdRe0RqUNxiGKKwNZtmUsvawq4Tk1TueIHcDZyy8fIDLQxBBLJB2CAHyxWDidQMX+
         W4wwcbSOA/s0Xhq5MXi6/xjaY0DBmKO3FfVmflZA=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 30 Oct 2018 18:10:01 +0530
From:   Govind Singh <govinds@codeaurora.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     devicetree@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <andy.gross@linaro.org>,
        "open list:ARM/QUALCOMM SUPPORT" <linux-soc@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] dt: bindings: add missing dt properties for
 WCN3990 wifi node
In-Reply-To: <CAD=FV=WP-Xx+xeCGTxSFcSrmhAv-6F3zm-0hnLxhHi84u-fUkQ@mail.gmail.com>
References: <1539172376-19269-1-git-send-email-govinds@codeaurora.org>
 <1539172376-19269-2-git-send-email-govinds@codeaurora.org>
 <CAD=FV=WP-Xx+xeCGTxSFcSrmhAv-6F3zm-0hnLxhHi84u-fUkQ@mail.gmail.com>
Message-ID: <04b30aa1384356011365dae5054c799f@codeaurora.org>
X-Sender: govinds@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-17 04:23, Doug Anderson wrote:
> Hi,
> 
> On Wed, Oct 10, 2018 at 4:53 AM Govind Singh <govinds@codeaurora.org> 
> wrote:
>> 
>> Add missing optional properties in WCN3990 wifi node.
>> 
>> Signed-off-by: Govind Singh <govinds@codeaurora.org>
>> ---
>>  .../bindings/net/wireless/qcom,ath10k.txt          | 28 
>> ++++++++++++++++------
>>  1 file changed, 21 insertions(+), 7 deletions(-)
> 
> Point of order: please CC LKML on _all_ your patches.  Yes, it's a
> firehose.  CCing LKML allows your patches to be found on
> lore.kernel.org's patchwork and also allows people to find your
> patches via <https://lkml.kernel.org/r/MSG_ID> links.
> 
> 
>> diff --git 
>> a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt 
>> b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> index 7fd4e8c..f831bb1 100644
>> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> @@ -37,12 +37,20 @@ Optional properties:
>>  - clocks: List of clock specifiers, must contain an entry for each 
>> required
>>            entry in clock-names.
>>  - clock-names: Should contain the clock names "wifi_wcss_cmd", 
>> "wifi_wcss_ref",
>> -               "wifi_wcss_rtc".
>> -- interrupts: List of interrupt lines. Must contain an entry
>> -             for each entry in the interrupt-names property.
>> +              "wifi_wcss_rtc" for "qcom,ipq4019-wifi" compatible 
>> target and
>> +              "cxo_ref_clk_pin", "smmu_aggre2_noc_clk" for 
>> "qcom,wcn3990-wifi"
>> +              compatible target.
> 
> I always get confused with these big bindings patches that hide
> everything under a big "Optional properties" section to avoid
> specifying which properties are actually optional and which ones are
> required.
> 
> After your patch and thinking about "qcom,wcn3990-wifi" in particular,
> it's unclear to me which of the following is true (or maybe something
> totally different I didn't think of)
> 
> A) On wcn3990-wifi these clocks should be a required property but it's
> only listed under "Optional" because it's not used for some of the
> different WiFi drivers using this same bindings.
> 
These clocks are optional as it is voted by firmware in newer fw 
versions.
During transient state in case of fw crash, fw might remove the vote in
its error/fatal handler. The apps vote helps in avoiding un-clocked 
hw(copy engine)
access in transient state till driver recovers.

> B) On wcn3990-wifi these clocks should either both be there or neither.
> 
With the above explanation can you suggest where these controls should 
fall.

> C) On wcm3990-wifi you can specify zero, either, or both of these
> clocks.  AKA they are independently optional.
> 


> It might make sense to reorganize this bindings to make this clearer?
> ...not just for clock but for interrupts / regulators as well.  Maybe
> you need to break this down into sections per class of compatible
> string, or add a list per compatible string down below?
> 
can you pls point me to some reference for the change you are expecting.
I will check and rework accordingly.

> Also: even stranger is that even though you list two clocks here the
> current driver I see in linuxnext only has "cxo_ref_clk_pin".
> 
smmu_aggre2_noc_clk is not applicable to SDM845 and required for other 
msm platforms.
I will remove smmu_aggre2_noc_clk reference and add when this clock is 
available
in upstream for respective target.

> 
>> +- interrupts: reference to the list of 17 interrupt no's for 
>> "qcom,ipq4019-wifi"
>> +             compatible target.
>> +             reference to the list of 12 interrupt no's for 
>> "qcom,wcn3990-wifi"
>> +             compatible target.
>> +             Must contain interrupt-names property per entry for
>> +             "qcom,ath10k", "qcom,ipq4019-wifi" compatible targets.
> 
> ...and just to add some credence to my concerns above, "interrupts"
> are currently listed under "Optional" properties but I don't think
> that the wcn3990 driver will actually work if you don't specify any of
> the interrupts, right?  AKA for wcn3990 they are _not_ optional and
> you must have exactly 12 interrupts.
> 
Yes, for other chip-set(QCAxx) also it should not be optional.
I will move interrupt block to Required properties.

> 
> One separate issue I have is with your example, which you didn't
> change in this patch.  You should fix the example with the same
> feedback that I had to your patch ("dts: arm64/sdm845: Add WCN3990
> WLAN module device node").
> 

sure , will do in next revision.

> -Doug
