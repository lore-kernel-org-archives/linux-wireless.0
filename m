Return-Path: <SRS0=82ey=XA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A63CC3A5A5
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Sep 2019 13:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DF1C207E0
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Sep 2019 13:18:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="B0HZE85k";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="B0HZE85k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731556AbfIENSN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 5 Sep 2019 09:18:13 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40284 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730780AbfIENSN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Sep 2019 09:18:13 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 75AA060710; Thu,  5 Sep 2019 13:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567689492;
        bh=aUuPqj9wb/JmSVV1hNFjJjdcQfTmN3Eohmt0r8g+oJ4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=B0HZE85kueSI3pQ/FfFcLvFa3KTZftrFsNAtUNg7F1aCS1LzagU1K/Nqhfa6e4fJD
         Vvyl2kC8/Shu1zRok9OM7zro3dqtRtInBHPxxLB8yFA++k+obILM+8QUMO3OTbSmiJ
         c5KoezylnQhfQbmUTnz97GuWPfO2Orf08+b3w/qs=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D849E6025A;
        Thu,  5 Sep 2019 13:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567689492;
        bh=aUuPqj9wb/JmSVV1hNFjJjdcQfTmN3Eohmt0r8g+oJ4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=B0HZE85kueSI3pQ/FfFcLvFa3KTZftrFsNAtUNg7F1aCS1LzagU1K/Nqhfa6e4fJD
         Vvyl2kC8/Shu1zRok9OM7zro3dqtRtInBHPxxLB8yFA++k+obILM+8QUMO3OTbSmiJ
         c5KoezylnQhfQbmUTnz97GuWPfO2Orf08+b3w/qs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D849E6025A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org
Subject: Re: [PATCH 01/49] dt: bindings: net: add qcom,ath11k.txt
References: <1566316095-27507-1-git-send-email-kvalo@codeaurora.org>
        <1566316095-27507-2-git-send-email-kvalo@codeaurora.org>
        <20190827171307.GA23128@bogus>
Date:   Thu, 05 Sep 2019 16:18:08 +0300
In-Reply-To: <20190827171307.GA23128@bogus> (Rob Herring's message of "Tue, 27
        Aug 2019 12:13:07 -0500")
Message-ID: <87o8zylw4v.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rob Herring <robh@kernel.org> writes:

> On Tue, Aug 20, 2019 at 06:47:27PM +0300, Kalle Valo wrote:
>
> Missing commit message and Sob (and on the other patches).

My original plan was to commit all this in one commit and use the cover
letter as my commit. But based on your comment I realised we should have
three commits:

1. devicetree bindings doc
2. ath11k itself
3. add entry to MAINTAINERS file

>> ---
>>  .../bindings/net/wireless/qcom,ath11k.txt          | 127 +++++++++++++++++++++
>>  1 file changed, 127 insertions(+)
>
> Please use the DT schema format (YAML). See writing-schema.md.

Oh, I didn't know about the new format. We'll use that.

>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.txt
>> @@ -0,0 +1,127 @@
>> +* Qualcomm Technologies ath11k wireless devices
>> +
>> +Required properties:
>> +- compatible: Should be "qcom,ipq8074-wifi"
>> +
>> +AHB based ipq8074 uses most of the properties defined in this doc.
>> +
>> +Optional properties:
>> +- reg: Address and length of the register set for the device.
>> +- interrupts: List of interrupt lines. Must contain an entry
>> +	      for each entry in the interrupt-names property.
>
> Need to be explicit as to how many interrupts and what they are.

Ok, we'll add that.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
