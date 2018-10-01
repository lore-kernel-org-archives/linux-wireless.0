Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961D1C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B1FE208D9
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:05:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AdEkJ09c";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kl6PaUm9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B1FE208D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbeJAUnD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 16:43:03 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33304 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729289AbeJAUnD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 16:43:03 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D498460C4F; Mon,  1 Oct 2018 14:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538402705;
        bh=9JRNKaRRfnKKoolrwPIe/CucgCmZiJUdwaQY4/yuKoY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=AdEkJ09cAOdhA/nvrFymF2mAF1Vd07ayHd9EGFE2AvfB0fYaRaAHTvp26PkMJej0q
         nXBNG94Bkc1u7zGjlHhB/m8lj2aGhtRgTdU4MqINdI1FjWBHUMICTWssOo7V4dVVvl
         RypvbrNu1uLRsiJhNGjy1V4GmiwD/y5M54jIEmhw=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4468B60C4F;
        Mon,  1 Oct 2018 14:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538402705;
        bh=9JRNKaRRfnKKoolrwPIe/CucgCmZiJUdwaQY4/yuKoY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=kl6PaUm9ipaYEJsdZi7dln+DOuzI8/qnnyYHf/2xqphLLgOzQzliz9sI09BIUhuzo
         hJ3fJ1W9HvxQ+Ey05CmQj0xvdyGb9heIlNQSbAIHijC9BUj5Nx/1Jc4xVF0AhVRDm2
         jw9FHfq0NM2yLSta0I7YNd+J27hPbEmmoTIswNHs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4468B60C4F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] ath10k: Move napi_enable to hif_start for consistent
 pairing
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180920050426.4113-1-govinds@codeaurora.org>
References: <20180920050426.4113-1-govinds@codeaurora.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181001140505.D498460C4F@smtp.codeaurora.org>
Date:   Mon,  1 Oct 2018 14:05:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Govind Singh <govinds@codeaurora.org> wrote:

> There is unbalanced napi_{enable,disable}() behavior as they
> are being called from hif_snoc_{power_up/stop).
> 
> The fix is to call napi_enable() from ath10k_snoc_hif_start()
> so that it matches with napi_disable() being called from
> ath10k_snoc_hif_stop().
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

752ed2a229c6 ath10k: move napi_enable to hif_start for consistent pairing
393b9b0f830e ath10k: disable napi before resource cleanup to avoid "use after free"

-- 
https://patchwork.kernel.org/patch/10606859/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

