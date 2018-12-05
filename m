Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6AA5C04EB9
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 06:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 890C02084C
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 06:17:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DKgBW+E2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DKgBW+E2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 890C02084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbeLEGRM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 01:17:12 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39962 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbeLEGRM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 01:17:12 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7D57960807; Wed,  5 Dec 2018 06:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543990631;
        bh=GHtjp451JuDRUq4LAPwLiKRsyrwrruuU0f6+fVEUcdw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DKgBW+E2NvJYjJrYHEj8OVyQgn8VzhWIldcsbejZhT4UXsGE5ovyTkmjCymg2lttk
         FPpRPt6O6yLy4bEnwot71Gjytrt8k72bMkyHA9cVMG6IGimEM082uidqMR8OMa1EUg
         KMp3OZeSV/mTDxhFhvCnFgEIyF9uaM0KT4Gu39xo=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 0350A60397;
        Wed,  5 Dec 2018 06:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543990631;
        bh=GHtjp451JuDRUq4LAPwLiKRsyrwrruuU0f6+fVEUcdw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DKgBW+E2NvJYjJrYHEj8OVyQgn8VzhWIldcsbejZhT4UXsGE5ovyTkmjCymg2lttk
         FPpRPt6O6yLy4bEnwot71Gjytrt8k72bMkyHA9cVMG6IGimEM082uidqMR8OMa1EUg
         KMp3OZeSV/mTDxhFhvCnFgEIyF9uaM0KT4Gu39xo=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 05 Dec 2018 11:47:10 +0530
From:   Bhagavathi Perumal S <bperumal@codeaurora.org>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/3] dt-bindings: net: ath10k: add new dt entry to
 identify external FEM
In-Reply-To: <CAKR_QVKFx3oqb7cvyeY_+fKMxKA9PQkSDex-tvxrQcdc7hJ-CQ@mail.gmail.com>
References: <1543858415-23953-1-git-send-email-bperumal@codeaurora.org>
 <1543858415-23953-3-git-send-email-bperumal@codeaurora.org>
 <d7d53ffb-9778-927c-5030-243c2ae57fcc@newmedia-net.de>
 <CAKR_QVKFx3oqb7cvyeY_+fKMxKA9PQkSDex-tvxrQcdc7hJ-CQ@mail.gmail.com>
Message-ID: <31adb268bfd29daa95da923d2172e05e@codeaurora.org>
X-Sender: bperumal@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-12-04 16:53, Tom Psyborg wrote:
> On 04/12/2018, Sebastian Gottschall <s.gottschall@newmedia-net.de> 
> wrote:
>> Hi
>> 
>> you write that
>> 
>> "microsemi-lx5586", "sky85703-11" and "sky85803" is supported, but you 
>> just
>> check for microsemi-lx5586
>>   in part 3
>> 
>> Am 03.12.2018 um 18:33 schrieb Bhagavathi Perumal S:
>>> This adds new dt entry ext-fem-name, it is used by ath10k driver
>>> to select correct timing parameters and configure it in target wifi
>>> hardware.
>>> The Front End Module(FEM) normally includes tx power amplifier(PA) 
>>> and
>>> rx low noise amplifier(LNA). The default timing parameters like tx 
>>> end to
>>> PA off timing values were fine tuned for internal FEM used in 
>>> reference
>>> design. And these timing values can not be same if ODM modifies 
>>> hardware
>>> design with different external FEM. This DT entry helps to choose 
>>> correct
>>> timing values in driver if different external FEM hardware used.
>>> 
>>> Signed-off-by: Bhagavathi Perumal S<bperumal@codeaurora.org>
>>> ---
>>>   Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 8
>>> +++++++-
>>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>> 
>>> diff --git
>>> a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>>> b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>>> index ef60f25..2dd0c52 100644
>>> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>>> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>>> @@ -61,8 +61,13 @@ Optional properties:
>>>   	Value type: <phandle>
>>>   	Definition: reference to the reserved-memory for the msa region
>>>   		    used by the wifi firmware running in Q6.
>>> +- ext-fem-name:
>>> +	Usage: Optional
>>> +	Value type: string
>>> +	Definition: Name of external front end module used. Valid FEM names 
>>> are
>>> +		    "microsemi-lx5586", "sky85703-11" and "sky85803" etc.
>>> 
>>> -Example (to supply the calibration data alone):
>>> +Example (to supply PCI based wifi block details):
>>> 
>>>   In this example, the node is defined as child node of the PCI
>>> controller.
>>> 
>>> @@ -77,6 +82,7 @@ pci {
>>>   		wifi@0,0 {
>>>   			reg = <0 0 0 0 0>;
>>>   			qcom,ath10k-calibration-data = [ 01 02 03 ... ];
>>> +			ext-fem-name = "microsemi-lx5586";
>>>   		};
>>>   	};
>>>   };
>>> -- 1.9.1
>> 
> 
> Sebastian might be right.
> 
> "Valid FEM names are
>>> +		    "microsemi-lx5586", "sky85703-11" and "sky85803" etc."
> 
> etc. inidicate you could put whatever here. where does the actual code
> resides that manages different FEM ?
These are some valid fem names which I added for example.
But currently driver support is added only for "microsemi-lx5586",
since it required different timing settings for proper DFS radar 
detection.
Others use default settings from firmware if driver doesn't send any 
settings
to firmware. Driver support will be extended in future, if different 
settings
applicable for other fems.
I think, I should mention like
"Valid FEM names for example: "microsemi-lx5586", "sky85703-11" and 
"sky85803" etc.".
I will change it.
