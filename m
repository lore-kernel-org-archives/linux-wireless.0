Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 072F1C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 13:51:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCD412085B
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 13:51:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CDj5vqsG";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cY1LIvEP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732228AbfAaNvj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 08:51:39 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:53310 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbfAaNvi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 08:51:38 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F2F6860907; Thu, 31 Jan 2019 13:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548942697;
        bh=s/9vfArZkHcYq/+TU3pNDpzA1RawHT72gLVAHafcYPw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=CDj5vqsGKXydKdqEX6BBLstsK41awRQxn5SKu1dBn/xPo3HsI+wrl7LHITDuMCzvz
         fazN9DuEKFe1iU3EuUuXgsgDQKVCRLNHHqOLHviIdb7hXCPaI9kGrNnJaCIACKBG6S
         pWq8vXaaJC6ApomOPwyBCmgB8qgMPavrrsnv93oU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 66B4560907;
        Thu, 31 Jan 2019 13:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548942694;
        bh=s/9vfArZkHcYq/+TU3pNDpzA1RawHT72gLVAHafcYPw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cY1LIvEPZxtmSHIyuUODi6841usehCOjgmrSVIZn1tmE388ZZn9GUFLNMptYMz2XZ
         zKZnfZKA1MxBpw5ANr5P3auRsvPnVxJ1v/q9dKxBYFrxhT+/0a+3wY94VJDbYF/MZY
         FoCqIdZuiDSmercvtdXRGJTit+24LN/UUHwgBnx8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 66B4560907
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Rakesh Pillai <pillair@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: Set DMA address mask to 35 bit for WCN3990
References: <1535992622-5074-1-git-send-email-pillair@codeaurora.org>
        <20190130185721.GT31919@minitux>
Date:   Thu, 31 Jan 2019 15:51:30 +0200
In-Reply-To: <20190130185721.GT31919@minitux> (Bjorn Andersson's message of
        "Wed, 30 Jan 2019 10:57:22 -0800")
Message-ID: <871s4tj5p9.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Bjorn Andersson <bjorn.andersson@linaro.org> writes:

> On Mon 03 Sep 09:37 PDT 2018, Rakesh Pillai wrote:
>
>> WCN3990 is a 37-bit target but can address memory range
>> only upto 35 bits. The 36th bit is used to control the
>> smmu/iommu translation and the 37th bit is used by the
>> internal bus masters to access the wifi subsystem internal
>> SRAM. With the DMA mask set to 37i-bit, the host driver
>> can get 37-bit dma address, which leads to incorrect
>> address access in the target.
>> 
>> Hence the host driver can used addresses upto 35-bit
>> for WCN3990. Fix the dma mask for wcn3990 to 35-bit,
>> instead of 37-bit.
>> 
>> Tested HW: WCN3990
>> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
>> 
>> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
>
> This solves the problem I'm seeing on my SDM845, where I see a
> translation fault on a 32-bit address from the IOMMU, which we
> previously mapped the 36 bit version of (my dma-ranges is set to 36
> bits).
>
> So:
>
> Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Thanks for the reminder. This got piled up in my deferred queue in
patchwork and I hadn't looked at it yet. I'll queue this for -next.

> However, some of the changes in this patch and the fact that I get a
> translation error on the lower 32 bits of the mapped iova, makes me
> suspect that while the hardware is capable of 37 bits, the driver only
> dealt with the lower 32.  And if that's the case I would like to see
> that mentioned in the commit message.

Rakesh mentioned that it's actually 35 bits. Should something changed in
the commit log still? I can do that if needed.

-- 
Kalle Valo
