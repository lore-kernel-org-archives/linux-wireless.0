Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,T_DKIM_INVALID,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8194BC43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 12:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2624F2098A
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 12:15:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DYs7zEfc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mDcHrfxG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2624F2098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbeIYSWS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 14:22:18 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38734 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727507AbeIYSWS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 14:22:18 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 39B5660313; Tue, 25 Sep 2018 12:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1537877701;
        bh=/uhdiU13TUz9kbW7l+/xzKC6FxcTCVuuZeQmHP4YNmA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DYs7zEfct+EJaAz2USDISLYIruqLDcHAgoGOA1jUQtBJcVHyjPxU297v7GpY2z5K/
         yWAUx83Xo8+WILYCV7e6adUGSH0o9ZJF4R47dPo+ilFPG68zKlhASfCKxYc1GQVLZ2
         He7pXCODFhpLmRrmhJ3HwH45gyQ45u0fTSBdKYxo=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 6C21160313;
        Tue, 25 Sep 2018 12:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1537877700;
        bh=/uhdiU13TUz9kbW7l+/xzKC6FxcTCVuuZeQmHP4YNmA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mDcHrfxGaXZd6w1LmrU5qN2zQR3Cvx9j83fVBSzNZrhu3g89M/3pacxtzU5GGijlh
         JOi+GAsdtp286l4VcFbijBSvU4sK3hhZX5vhsJ5IPpTVCJpoiJOE5IXN32Uy2VRcch
         ev31wDvp4zpvr63jX798HCSAuDzn+KhbQ8VMN74U=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 25 Sep 2018 17:45:00 +0530
From:   Govind Singh <govinds@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     ath10k@lists.infradead.org, robh+dt@kernel.org,
        andy.gross@linaro.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] dts: arm64/sdm845: Add WCN3990 WLAN module device
 node
In-Reply-To: <20180924171147.GA87119@ban.mtv.corp.google.com>
References: <20180921090907.25937-1-govinds@codeaurora.org>
 <20180921090907.25937-3-govinds@codeaurora.org>
 <20180924171147.GA87119@ban.mtv.corp.google.com>
Message-ID: <d1b1ed01aef5b2f9866b4bd654ae327a@codeaurora.org>
X-Sender: govinds@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Brian,

On 2018-09-24 22:41, Brian Norris wrote:
> Hi,
> 
> On Fri, Sep 21, 2018 at 02:39:05PM +0530, Govind Singh wrote:
>> Add device node for the ath10k SNOC platform driver probe
>> and add resources required for WCN3990 on SDM845 soc.
>> 
>> Signed-off-by: Govind Singh <govinds@codeaurora.org>
>> ---
>>  arch/arm64/boot/dts/qcom/sdm845-mtp.dts |  7 +++++++
>>  arch/arm64/boot/dts/qcom/sdm845.dtsi    | 25 
>> +++++++++++++++++++++++++
>>  2 files changed, 32 insertions(+)
>> 
>> diff --git a/arch/arm64/boot/dts/qcom/sdm845-mtp.dts 
>> b/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
>> index eedfaf8922e2..4de57f7df93c 100644
>> --- a/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
>> +++ b/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
>> @@ -440,3 +440,10 @@
>>  		bias-pull-up;
>>  	};
>>  };
>> +
>> +&wifi {
> 
> As the bots have already told you, you missed adding a 'wifi' label to
> sdm845.dtsi, so this reference doesn't compile.
> 

Yes, I will correct this in next revision.

>> +	vdd-0.8-cx-mx-supply = <&vreg_l5a_0p8>;
>> +	vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
>> +	vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
>> +	vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
>> +};
>> diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi 
>> b/arch/arm64/boot/dts/qcom/sdm845.dtsi
>> index e080072cdfdb..b0b107641e74 100644
>> --- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
>> +++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
>> @@ -86,6 +86,11 @@
>>  			reg = <0 0x86200000 0 0x2d00000>;
>>  			no-map;
>>  		};
>> +
>> +		wlan_msa_mem: reserved-memory@96700000 {
>> +			no-map;
>> +			reg = <0 0x96700000 0 0x100000>;
>> +		};
>>  	};
>> 
>>  	cpus {
>> @@ -1200,5 +1205,25 @@
>>  				status = "disabled";
>>  			};
>>  		};
>> +
>> +		qcom,wifi {
> 
> That's not a legit node name. Nodes should (a) have a generic name and
> (b) include a unit address when the node contains a 'reg' property. [1]
> 
> So, how about 'wifi@18800000'? (And include the 'wifi:' label, since 
> you
> want to refer to it in other files.)
> 

I am fine with 'wifi@18800000'.

> Also, this seems like the kind of device that should remain 'status =
> "disabled"' in the top-level DTSI, and be overridden with 'status =
> "okay"' in the child DTS.
> 

Sure, i will populate  'status = "disabled"' in next revision, which can 
be enabled from child dtsi
as part of separate change.

> Brian
> 
> [1] See:
> https://elinux.org/Device_Tree_Usage#Node_Names
> https://elinux.org/images/c/cf/Power_ePAPR_APPROVED_v1.1.pdf
> 
>> +			compatible = "qcom,wcn3990-wifi";
>> +			reg = <0x18800000 0x800000>;
>> +			reg-names = "membase";
>> +			memory-region = <&wlan_msa_mem>;
>> +			interrupts =
>> +				<0 413 0 /* CE0 */ >,
>> +				<0 414 0 /* CE1 */ >,
>> +				<0 415 0 /* CE2 */ >,
>> +				<0 416 0 /* CE3 */ >,
>> +				<0 417 0 /* CE4 */ >,
>> +				<0 418 0 /* CE5 */ >,
>> +				<0 420 0 /* CE6 */ >,
>> +				<0 421 0 /* CE7 */ >,
>> +				<0 422 0 /* CE8 */ >,
>> +				<0 423 0 /* CE9 */ >,
>> +				<0 424 0 /* CE10 */ >,
>> +				<0 425 0 /* CE11 */ >;
>> +		};
>>  	};
>>  };
>> --
>> 2.17.0
>> 

Thanks,
Govind
