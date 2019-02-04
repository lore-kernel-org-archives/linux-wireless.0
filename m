Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A467C282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 15:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDF652082E
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 15:49:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OhkhSihQ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bvUSkIhZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730343AbfBDPtl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 10:49:41 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:48974 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728216AbfBDPtk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 10:49:40 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6D251608CF; Mon,  4 Feb 2019 15:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549295379;
        bh=46l+d16Eo581xawDZolsQi80POtLTVcoSsp5FYB2WoM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=OhkhSihQU0HZY9WkJdT2EvfJxNMgFyoUzMeSyHPg+de65Qc9/0aTvsARAb39hB0N5
         IDPZCgDe+nu/V33SpPbLdyIssZeXMQTTHfcBM2ez6vZaLfe379U9qJISfc/zbEN98N
         9cbXPDvQ+/HiK1cR4PI7l2DyJhXaWfYYSQvJlTXM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F1126607DF;
        Mon,  4 Feb 2019 15:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549295378;
        bh=46l+d16Eo581xawDZolsQi80POtLTVcoSsp5FYB2WoM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=bvUSkIhZssH8JvK/4DLJwKHACCtiy/RTq+X0MzLSKnbiRn6++GpooMvPR7V/Z3n8y
         Kl8jh82QpwBvN4kQhrwm3mCkotg3VAixKcU3yR9avCrOU1wZUYQRRwV+Td+XKlgc5S
         Pwg2O5h46sGuf1TjWa2tykHeAFKHuDNDZsl03InE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F1126607DF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath10k: Set DMA address mask to 35 bit for WCN3990
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1535992622-5074-1-git-send-email-pillair@codeaurora.org>
References: <1535992622-5074-1-git-send-email-pillair@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190204154939.6D251608CF@smtp.codeaurora.org>
Date:   Mon,  4 Feb 2019 15:49:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> wrote:

> WCN3990 is a 37-bit target but can address memory range
> only upto 35 bits. The 36th bit is used to control the
> smmu/iommu translation and the 37th bit is used by the
> internal bus masters to access the wifi subsystem internal
> SRAM. With the DMA mask set to 37i-bit, the host driver
> can get 37-bit dma address, which leads to incorrect
> address access in the target.
> 
> Hence the host driver can used addresses upto 35-bit
> for WCN3990. Fix the dma mask for wcn3990 to 35-bit,
> instead of 37-bit.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
> 
> Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

5b9030cee1be ath10k: Set DMA address mask to 35 bit for WCN3990

-- 
https://patchwork.kernel.org/patch/10586127/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

