Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIM_INVALID,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68F26C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 12:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1ED6A20867
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 12:08:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iEui60kQ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Qp0VIfQd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1ED6A20867
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbeIYSPv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 14:15:51 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33140 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbeIYSPv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 14:15:51 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 239276081A; Tue, 25 Sep 2018 12:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1537877316;
        bh=1uuWVhlAuyMd56AaPAjlob/yQIn5YNj4XC+aFsSafB8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iEui60kQYJkKcT1+Ly51+2fVy4OCbT/1ekS3ScKNFxAkpwaJHdf1tOpo8QY3gdV4D
         /v7KKHvS4ERbBbOGolnVpYgecgUvb321duBu64G5Zgl0yZKHCXlJzpCmVEZ47dIbWj
         18S3TGaKfoDt6oT5J+Qq+GPgZvHZvBKHQocF5kRw=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 36EC860128;
        Tue, 25 Sep 2018 12:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1537877315;
        bh=1uuWVhlAuyMd56AaPAjlob/yQIn5YNj4XC+aFsSafB8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qp0VIfQdoseKBFOHDp6xVDL+berJbdVx6KW3ayz0JPsanMxkGsBnGV3RjE+EJ6lbk
         gU73+nhHpS/XLZKhimhcU+enoBb5gGpTXvJY1IzxKA/rzOnPn5tW9t3DUtgrOeYrqJ
         skzBaTx3opVWvGHF+3Y1LC8mRZweLC0+FceUVM+Q=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 25 Sep 2018 17:38:35 +0530
From:   Govind Singh <govinds@codeaurora.org>
To:     Rob Herring <robh@kernel.org>
Cc:     ath10k@lists.infradead.org, andy.gross@linaro.org,
        devicetree@vger.kernel.org, linux-wireless@vger.kernel.org,
        briannorris@chromium.org
Subject: Re: [PATCH 1/4] dt: bindings: add missing dt properties for WCN3990
 wifi node
In-Reply-To: <5baa1b0a.1c69fb81.c0b19.4038@mx.google.com>
References: <20180921090907.25937-1-govinds@codeaurora.org>
 <20180921090907.25937-2-govinds@codeaurora.org>
 <5baa1b0a.1c69fb81.c0b19.4038@mx.google.com>
Message-ID: <f4785e79ccea53e0b696bdaaf2aa9ffb@codeaurora.org>
X-Sender: govinds@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Rob,

On 2018-09-25 04:21, Rob Herring wrote:
> On Fri, Sep 21, 2018 at 02:39:04PM +0530, Govind Singh wrote:
>> Add missing optional properties in WCN3990 wifi node.
>> 
>> Signed-off-by: Govind Singh <govinds@codeaurora.org>
>> ---
>>  .../bindings/net/wireless/qcom,ath10k.txt     | 22 
>> +++++++++++++------
>>  1 file changed, 15 insertions(+), 7 deletions(-)
>> 
>> diff --git 
>> a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt 
>> b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> index 7fd4e8ce4149..22dea7d83ee8 100644
>> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> @@ -37,12 +37,14 @@ Optional properties:
>>  - clocks: List of clock specifiers, must contain an entry for each 
>> required
>>            entry in clock-names.
>>  - clock-names: Should contain the clock names "wifi_wcss_cmd", 
>> "wifi_wcss_ref",
>> -               "wifi_wcss_rtc".
>> -- interrupts: List of interrupt lines. Must contain an entry
>> -	      for each entry in the interrupt-names property.
>> +               "wifi_wcss_rtc", "cxo_ref_clk_pin", 
>> "smmu_aggre2_noc_clk".
>> +- interrupts: List of interrupt lines. Must contain interrupt-names 
>> property
>> +	      per entry for "qcom,ath10k", "qcom,ipq4019-wifi" compatible
>> +	      targets.
> 
> It would be clearer to list how many interrupts for each set of
> compatibles.
> 

Sure, I will address this in next revision.

>>  - interrupt-names: Must include the entries for MSI interrupt
>>  		   names ("msi0" to "msi15") and legacy interrupt
>> -		   name ("legacy"),
>> +		   name ("legacy") for "qcom,ath10k", "qcom,ipq4019-wifi"
>> +		   compatible targets.
> 
> So no legacy interrupt for wcn3990?
> 

Yes, no legacy interrupt for wcn3990.

>>  - qcom,msi_addr: MSI interrupt address.
>>  - qcom,msi_base: Base value to add before writing MSI data into
>>  		MSI address register.
>> @@ -55,7 +57,8 @@ Optional properties:
>>  - qcom,ath10k-pre-calibration-data : pre calibration data as an 
>> array,
>>  				     the length can vary between hw versions.
>>  - <supply-name>-supply: handle to the regulator device tree node
>> -			   optional "supply-name" is "vdd-0.8-cx-mx".
>> +			   optional "supply-name" are "vdd-0.8-cx-mx",
>> +			   "vdd-1.8-xo", "vdd-1.3-rfa" and "vdd-3.3-ch0".
>> 
>>  Example (to supply the calibration data alone):
>> 
>> @@ -133,8 +136,10 @@ wifi@18000000 {
>>  		compatible = "qcom,wcn3990-wifi";
>>  		reg = <0x18800000 0x800000>;
>>  		reg-names = "membase";
>> -		clocks = <&clock_gcc clk_aggre2_noc_clk>;
>> -		clock-names = "smmu_aggre2_noc_clk"
>> +		clocks = <&clock_gcc clk_aggre2_noc_clk>,
>> +			 <&clock_gcc clk_rf_clk2_pin>;
>> +		clock-names = "smmu_aggre2_noc_clk",
>> +			      "cxo_ref_clk_pin";
> 
> The binding now says there should be 5 clocks...
> 

Only 2 clocks are applicable for wcn3990. I will list no of clocks for 
each set of compatible for more clarity.

>>  		interrupts =
>>  			   <0 130 0 /* CE0 */ >,
>>  			   <0 131 0 /* CE1 */ >,
>> @@ -149,4 +154,7 @@ wifi@18000000 {
>>  			   <0 140 0 /* CE10 */ >,
>>  			   <0 141 0 /* CE11 */ >;
>>  		vdd-0.8-cx-mx-supply = <&pm8998_l5>;
>> +		vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
>> +		vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
>> +		vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
>>  };
>> --
>> 2.17.0
>> 

Thanks,
Govind
