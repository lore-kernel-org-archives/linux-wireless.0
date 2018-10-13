Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E653C28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C46020859
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:33:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jYB8kK/y";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ntNVfB+a"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C46020859
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbeJNBLW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 21:11:22 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50386 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbeJNBLW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 21:11:22 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A37E960C60; Sat, 13 Oct 2018 17:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539452000;
        bh=1W1YShEk4kMCnX1FSFT/Kpd2bU2CGOrhbcjBKrYEyzs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jYB8kK/ywh5DJwIxZ/pvPDCi/o8I4SxYgHnt4TIK2zC/JcRWBMyCCLmeLyQOu6aOV
         hGWC8CnXZyqDQKdtbeIkDcuL0+8YQcaDssr04HYSNkp3/fb15xv5gWzla1Di4m6gRx
         z4TAcCS7r0KPNiTc8JXtH0Moqs2f7LcVH651K+zQ=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1392360227;
        Sat, 13 Oct 2018 17:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539452000;
        bh=1W1YShEk4kMCnX1FSFT/Kpd2bU2CGOrhbcjBKrYEyzs=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ntNVfB+amCBcrTdkEwU8da/JO6LfRM6NZ98DlJCRU02ULHKywimHwSQwaul4kGeez
         PWU+8RrdW38jT0c7LnYczjEXVV/fuy4i13tje9DlN6DglxtlTNKL45o3I90zK5NUcW
         FPPrfqlPunS9Pbrnqh8jou6wt+P9OlQpfoQzZFnw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1392360227
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5 1/6] ath10k: Add qmi service helpers for wcn3990 qmi
 client
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180815092637.11455-2-govinds@codeaurora.org>
References: <20180815092637.11455-2-govinds@codeaurora.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org, briannorris@chromium.org,
        niklas.cassel@linaro.org, bjorn.andersson@linaro.org,
        andy.gross@linaro.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181013173320.A37E960C60@smtp.codeaurora.org>
Date:   Sat, 13 Oct 2018 17:33:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Govind Singh <govinds@codeaurora.org> wrote:

> WLAN qmi server running in Q6 exposes host to target
> cold boot qmi handshakes. Add WLAN QMI service helpers
> for ath10k wcn3990 qmi client.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Acked-by: Niklas Cassel <niklas.cassel@linaro.org>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

6 patches applied to ath-next branch of ath.git, thanks.

bc17d4b90cdd ath10k: add qmi service helpers for wcn3990 qmi client
22e8a4602738 ath10k: add support to create boardname for non-bmi target
2b741a8aaa34 dt: bindings: add bindings for msa memory region
cc53aabcc283 firmware: qcom: scm: Add WLAN VMID for Qualcomm SCM interface
35a665766737 ath10k: add debug mask for QMI layer
ba94c753ccb4 ath10k: add QMI message handshake for wcn3990 client

-- 
https://patchwork.kernel.org/patch/10566407/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

