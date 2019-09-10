Return-Path: <SRS0=RZjE=XF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0909C3A5A2
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Sep 2019 13:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C35A72084D
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Sep 2019 13:18:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dJMKrYrP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AxfgXMXX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731542AbfIJNSp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 10 Sep 2019 09:18:45 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35720 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbfIJNSo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Sep 2019 09:18:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BC3BD60779; Tue, 10 Sep 2019 13:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568121523;
        bh=jxJ9F7I16sMuycArxBq68I5GFTjVQE3Aq0gdFEmzW+8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=dJMKrYrPsnVD0KlTQ513TKRTS8nJ2RhpysNcy5fI3CJ2oBACQft5R2+f5tQUBK2N7
         GPnCIYphd+ODMlNmpyADQsFGsGlf2Tn/aRVrfFgQGsw28CyMjPmgbDdtRZiPqsIS6B
         bU0MAT22d9G9BkWZieZ5lXzWuCbb/v6vLS23/r30=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5BE6B602BC;
        Tue, 10 Sep 2019 13:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568121523;
        bh=jxJ9F7I16sMuycArxBq68I5GFTjVQE3Aq0gdFEmzW+8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=AxfgXMXXNwiQAfzPzoymgkCNEOpocSRprTZrAQwqPnlumJqLFLutp+x/tJRg8CobR
         cBYblKOwUOqeAqvY65fKVkFlMusAwWh+7Tp/yu3DqFD5VGPoPXm+iWxDfXklmFvLty
         KvBFLvkl4UaTk8pNO96qR33q+rrQYHNZeDFdqh9M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5BE6B602BC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: add mic bytes for pmf management packet
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1560757079-19266-1-git-send-email-wgong@codeaurora.org>
References: <1560757079-19266-1-git-send-email-wgong@codeaurora.org>
To:     Wen Gong <wgong@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190910131843.BC3BD60779@smtp.codeaurora.org>
Date:   Tue, 10 Sep 2019 13:18:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wen Gong <wgong@codeaurora.org> wrote:

> For PMF case, the action,deauth,disassoc management need to encrypt
> by hardware, it need to reserve 8 bytes for encryption, otherwise
> the packet will be sent out with error format, then PMF case will
> fail.
> 
> After add the 8 bytes, it will pass the PMF case.
> 
> Tested with QCA6174 SDIO with firmware
> WLAN.RMH.4.4.1-00005-QCARMSWP-1.
> 
> Signed-off-by: Wen Gong <wgong@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

83ac260151e7 ath10k: add mic bytes for pmf management packet

-- 
https://patchwork.kernel.org/patch/10998135/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

