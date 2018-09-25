Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIM_INVALID,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D44B5C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 12:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89A5520842
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 12:10:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="i100s5Bn";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="i100s5Bn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89A5520842
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728860AbeIYSRP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 14:17:15 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34056 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbeIYSRO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 14:17:14 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D5E2B607EB; Tue, 25 Sep 2018 12:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1537877399;
        bh=CfVK+BUl/TagymczwG9rRGNzjMLejE2K2KALfq9doHg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i100s5BnDWyN6h5HTBWFfD6/awqf0DQ+GkSBToqDAvZi+zfy1VEvP+VHkVgtaq1RM
         pbmZuxz0e9u/yjlfXojZM/BM6UV2NteXY2CUWTXS/W6QThkHQtiuUqdFsrFJ+YLGNl
         onNsn7AEMAv1JJpFPpfs1rB9ZaGIVMYNUxeVfOP0=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 3110C60310;
        Tue, 25 Sep 2018 12:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1537877399;
        bh=CfVK+BUl/TagymczwG9rRGNzjMLejE2K2KALfq9doHg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i100s5BnDWyN6h5HTBWFfD6/awqf0DQ+GkSBToqDAvZi+zfy1VEvP+VHkVgtaq1RM
         pbmZuxz0e9u/yjlfXojZM/BM6UV2NteXY2CUWTXS/W6QThkHQtiuUqdFsrFJ+YLGNl
         onNsn7AEMAv1JJpFPpfs1rB9ZaGIVMYNUxeVfOP0=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 25 Sep 2018 17:39:59 +0530
From:   Govind Singh <govinds@codeaurora.org>
To:     Rob Herring <robh@kernel.org>
Cc:     ath10k@lists.infradead.org, andy.gross@linaro.org,
        devicetree@vger.kernel.org, linux-wireless@vger.kernel.org,
        briannorris@chromium.org
Subject: Re: [PATCH 3/4] dt: bindings: add bindings for wifi iommu node
In-Reply-To: <5baa1b0b.1c69fb81.79d38.4171@mx.google.com>
References: <20180921090907.25937-1-govinds@codeaurora.org>
 <20180921090907.25937-4-govinds@codeaurora.org>
 <5baa1b0b.1c69fb81.79d38.4171@mx.google.com>
Message-ID: <74c8e0f9eb793720e3dff4e3cff382b5@codeaurora.org>
X-Sender: govinds@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-09-25 04:23, Rob Herring wrote:
> On Fri, Sep 21, 2018 at 02:39:06PM +0530, Govind Singh wrote:
>> WCN3990 wifi module can optionally make use of the IOMMU.
> 
> Can the other compatibles use IOMMU too?
> 

No, only wcn3990 can optionally use IOMMU.

>> Add binding documentation for phandle to the IOMMU and
>> the stream id of wifi iommu block.
>> 
>> Signed-off-by: Govind Singh <govinds@codeaurora.org>
>> ---
>>  .../devicetree/bindings/net/wireless/qcom,ath10k.txt         | 5 
>> +++++
>>  1 file changed, 5 insertions(+)
>> 
>> diff --git 
>> a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt 
>> b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> index 22dea7d83ee8..07e58008c665 100644
>> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> @@ -59,6 +59,10 @@ Optional properties:
>>  - <supply-name>-supply: handle to the regulator device tree node
>>  			   optional "supply-name" are "vdd-0.8-cx-mx",
>>  			   "vdd-1.8-xo", "vdd-1.3-rfa" and "vdd-3.3-ch0".
>> +- iommus:
>> +	Usage: optional
>> +	Value type: <prop-encoded-array>
>> +	Definition: A list of phandle and IOMMU specifier pairs.
>> 
>>  Example (to supply the calibration data alone):
>> 
>> @@ -157,4 +161,5 @@ wifi@18000000 {
>>  		vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
>>  		vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
>>  		vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
>> +		iommus = <&apps_smmu 0x0040 0x1>;
>>  };
>> --
>> 2.17.0
>> 

BR,
Govind
