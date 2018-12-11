Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7968AC07E85
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 05:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3172D2082F
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 05:57:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QRT2wXdS";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mI2jBgr5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3172D2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbeLKF47 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 00:56:59 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51544 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbeLKF47 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 00:56:59 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 61FAE607E2; Tue, 11 Dec 2018 05:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544507818;
        bh=g045CdRn0DvXjtAhQ1L++5aZVQ8qEzugA8QVtOmR7Jw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QRT2wXdSK3CvCcg28H8ZEKUC3vP465EmEadIF/orbWQH7z55WWnck6id3L4bDJHet
         ltp7dY1NBpIUwqemn2u+CDrvNzu6w0dWFzeK7wmoWF6bokhtm24Uulhnhe/SAIlA/t
         2WdwRmj+2iZO8EEesjf0kfH35gsaGxAkKSVe81jI=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id D391A6019F;
        Tue, 11 Dec 2018 05:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544507817;
        bh=g045CdRn0DvXjtAhQ1L++5aZVQ8qEzugA8QVtOmR7Jw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mI2jBgr5TbbY/LcoZ3BQXkxIO5K+fPYkdytx7sTTbbkJMfht1sdi30Ml4CeIIJXEF
         JGq+YUusRM40wNthubc5pYxmKk+rYwx+KT4L3r+YZ4Gve3o8o2b7zow+AX2gjySz+8
         KuTqQ/NrLBFAHd3hNcXszRWcGnCZVT23YQlEt3To=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 11 Dec 2018 11:26:57 +0530
From:   Bhagavathi Perumal S <bperumal@codeaurora.org>
To:     Rob Herring <robh@kernel.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/3] dt-bindings: net: ath10k: fix node name and device
 type in qcom ath10k example
In-Reply-To: <20181210232523.GA14192@bogus>
References: <1544466691-11821-1-git-send-email-bperumal@codeaurora.org>
 <1544466691-11821-2-git-send-email-bperumal@codeaurora.org>
 <20181210232523.GA14192@bogus>
Message-ID: <266a1bec89b88abe4637c33b080d85bb@codeaurora.org>
X-Sender: bperumal@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-12-11 04:55, Rob Herring wrote:
> On Tue, Dec 11, 2018 at 12:01:29AM +0530, Bhagavathi Perumal S wrote:
>> In qcom,ath10k documentation, ath10k is used as node name in the 
>> example of
>> pci based device. Normally, node name shoud be class of device and not 
>> the model
> 
> s/shoud/should/
Thanks, Will correct typo error and send v4 patch.
> 
>> name, so fix it to node name "wifi". And remove the property 
>> device_type pci
>> since only pci bridges should have this property.
>> 
>> Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
>> ---
>>  Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 3 
>> +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>> 
>> diff --git 
>> a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt 
>> b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> index 2196d1a..ef60f25 100644
>> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> @@ -74,9 +74,8 @@ pci {
>>  		#address-cells = <3>;
>>  		device_type = "pci";
>> 
>> -		ath10k@0,0 {
>> +		wifi@0,0 {
>>  			reg = <0 0 0 0 0>;
>> -			device_type = "pci";
>>  			qcom,ath10k-calibration-data = [ 01 02 03 ... ];
>>  		};
>>  	};
>> --
>> 1.9.1
>> 
