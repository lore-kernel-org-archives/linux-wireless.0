Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FF8DC282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 15:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2A7A2082E
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 15:51:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cK8KGdJl";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Gu1WKoKI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730366AbfBDPvG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 10:51:06 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50002 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728216AbfBDPvF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 10:51:05 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2C81C607DF; Mon,  4 Feb 2019 15:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549295465;
        bh=fsx8P1lBupZQWVN6GmSgXm5Z6Cjto2e3b6tsxzUsDFk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=cK8KGdJlrmTaW2StMgq3bTCq0RJflquTWYgGVDRKUQ8O83zErHo59/sP5VJlkL4Ak
         Q61JJ6eK12jhog66xNM2ckX7MSuYEG0p7DDlbCt3sHw3c5EjSZ1r+q0+gTJGWFhrfB
         6KV2Pa1EOjfYZVeH/5qsuaS3+nZd86WmOXkBjtwc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CEA4F6047C;
        Mon,  4 Feb 2019 15:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549295464;
        bh=fsx8P1lBupZQWVN6GmSgXm5Z6Cjto2e3b6tsxzUsDFk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Gu1WKoKIJFZGPrs76P883r8v63ycuPvKtT7Pz6lAiDUVXH20RYUJAptnLrgBRPUWP
         kePJ6/XLRdRuXunmqB8oI+lNgP8O0FbdGFtL6eWn3qjuBT/2Ekm9VsLzCRSr5P0x30
         1RyO2NlyyKPVfVfc/A6omNk0V81yFz8FWFR22CDA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CEA4F6047C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: fix S5 power consumption issue for QCA9377
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1547533867-15131-1-git-send-email-yyuwang@codeaurora.org>
References: <1547533867-15131-1-git-send-email-yyuwang@codeaurora.org>
To:     Yu Wang <yyuwang@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Yu Wang <yyuwang@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190204155105.2C81C607DF@smtp.codeaurora.org>
Date:   Mon,  4 Feb 2019 15:51:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yu Wang <yyuwang@codeaurora.org> wrote:

> After system entering S5 (shut down but system still
> providing power to QCA9377) on Ubuntu platform, power
> consumption of QCA9377 is 69mA, which is too high.
> The root cause is pci_soft_reset is not set for QCA9377
> during pci probe.
> To fix this issue, set 'pci_soft_reset' to 'th10k_pci_warm_reset',
> and then the power consumption drops to a normal value(10mA).
> Verified on Dell Ubuntu platform with firmware:
> WLAN.TF.1.0-00002-QCATFSWPZ-5
> 
> Signed-off-by: Yu Wang <yyuwang@codeaurora.org>
> Signed-off-by: Yu Wang <yyuwang@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

1a86be476cfa ath10k: fix S5 power consumption issue for QCA9377

-- 
https://patchwork.kernel.org/patch/10764017/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

