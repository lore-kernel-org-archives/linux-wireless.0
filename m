Return-Path: <SRS0=qkCK=NK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F177C2BC61
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 08:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C0CB20823
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 08:41:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="G6O/b28A";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LAj1dyHd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C0CB20823
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbeJ3Rdh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 13:33:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53686 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726580AbeJ3Rdh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 13:33:37 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 64E3760795; Tue, 30 Oct 2018 08:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540888867;
        bh=byOqjZC11nM/3YnBeSz6OpHLfhq0NIefwA41GFukemU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G6O/b28Ae1L1NJHcHLd7EbG6otuIcsEwsjLChEm/HT11925+NOUFii8no1WffoZ9x
         Jh1A2H+bCYsYJiKGqbpMjl7ibQjEQ2HhdJa59hYgF9CSGqne8tb3r2o4QC9//jGbgX
         nXF2/FTdDPcW52DSL6YVK7/uwFAIhQvKTD2XWU3U=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id A3C506029D;
        Tue, 30 Oct 2018 08:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540888866;
        bh=byOqjZC11nM/3YnBeSz6OpHLfhq0NIefwA41GFukemU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LAj1dyHd5AtpwfTlx8LzkIxtr1Xkr3oY6M97SkeMK5q8K2CMic+Roy4RUWU9hru1e
         xrxj8Px4glkIuTZzudEIcDY3gw9Ei+PWgrh/wOKePkrI+MB+t4hKWFzq6nPvT6qqgh
         etXZSQEiRFoPNLXWeED+VkKDQzoWAO3LdI3CpXFM=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 30 Oct 2018 14:11:06 +0530
From:   bperumal@codeaurora.org
To:     Rob Herring <robh@kernel.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] dt: bindings: add new dt entry to indentify external
 FEM
In-Reply-To: <20181015192425.GA19699@bogus>
References: <1538653364-1239-1-git-send-email-bperumal@codeaurora.org>
 <1538653364-1239-2-git-send-email-bperumal@codeaurora.org>
 <20181015192425.GA19699@bogus>
Message-ID: <d617b0c39a2faa7c9b23b884bef3f829@codeaurora.org>
X-Sender: bperumal@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-16 00:54, Rob Herring wrote:
> On Thu, Oct 04, 2018 at 05:12:43PM +0530, Bhagavathi Perumal S wrote:
>> This adds new dt entry ext-fem-name, it is used by ath10k driver
>> to select correct timing parameters and configure it in target wifi 
>> hardware.
>> The Front End Module(FEM) normally includes tx power amplifier(PA) and
>> rx low noise amplifier(LNA). The default timing parameters like tx end 
>> to
>> PA off timing values were fine tuned for internal FEM used in 
>> reference
>> design. And these timing values can not be same if ODM modifies 
>> hardware
>> design with different external FEM. This DT entry helps to choose 
>> correct
>> timing values in driver if different external FEM hardware used.
> 
> 'dt-bindings: net: ath10k: ...' for the subject please.
Sure, I will change and send v2 patch.

> 
>> 
>> Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
>> ---
>>  .../bindings/net/wireless/qcom,ath10k.txt          | 22 
>> ++++++++++++++++++++++
>>  1 file changed, 22 insertions(+)
>> 
>> diff --git 
>> a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt 
>> b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> index 7fd4e8c..fbaf309 100644
>> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> @@ -56,6 +56,7 @@ Optional properties:
>>  				     the length can vary between hw versions.
>>  - <supply-name>-supply: handle to the regulator device tree node
>>  			   optional "supply-name" is "vdd-0.8-cx-mx".
>> +- ext-fem-name: name of external front end module used.
> 
> What are valid names? What if the OS doesn't recognize the name? 
> Perhaps
Some valid FEM devices are "microsemi-lx5586", "sky85703-11" and 
"sky85803" etc.
Currently driver accepts only "microsemi-lx5586", Since this FEM 
requires different timing settings,
And it can be extended for other FEM devices in future.
If OS doesn't recognize the name, it uses predefined default timing 
settings.

> this should be a compatible string for the particular module instead?
> Then it could cover any differences, not just the FEM.
> 
No, it is specific to FEM device.

>> 
>>  Example (to supply the calibration data alone):
>> 
>> @@ -150,3 +151,24 @@ wifi@18000000 {
>>  			   <0 141 0 /* CE11 */ >;
>>  		vdd-0.8-cx-mx-supply = <&pm8998_l5>;
>>  };
>> +
>> +Example (to supply the external front end module name):
>> +
>> +In this example, the front end module is defined as a property of the 
>> ath10k
>> +device node.
> 
> Really need a whole new example for 1 property?
Will add this property in existing example.

> 
>> +
>> +pci {
>> +	pcie@0 {
>> +		reg = <0 0 0 0 0>;
>> +		#interrupt-cells = <1>;
>> +		#size-cells = <2>;
>> +		#address-cells = <3>;
>> +		device_type = "pci";
>> +
>> +		ath10k@0,0 {
> 
> wifi@0,0
Added in ath10k@0,0 to make consistent with existing property 
"qcom,ath10k-calibration-data" below,
"
pci {
         pcie@0 {
                 reg = <0 0 0 0 0>;
                 #interrupt-cells = <1>;
                 #size-cells = <2>;
                 #address-cells = <3>;
                 device_type = "pci";

                 ath10k@0,0 {
                         reg = <0 0 0 0 0>;
                         device_type = "pci";
                         qcom,ath10k-calibration-data = [ 01 02 03 ... ];
                 };
         };
};
"

If wifi@0,0 is preferable, then I will add new entry "wifi@0,0" and add 
ext-fem-name into it.

> 
>> +			reg = <0 0 0 0 0>;
>> +			device_type = "pci";
>> +			ext-fem-name = "microsemi-lx5586";
>> +		};
>> +	};
>> +};
>> --
>> 1.9.1
>> 

Thanks, Sorry for the delayed response,
Bhagavathi Perumal S.
