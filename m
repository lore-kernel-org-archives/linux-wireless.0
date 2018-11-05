Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A844EC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 10:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A5DA20825
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 10:12:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BxijaqCt";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CBqChTo/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A5DA20825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbeKETbi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 14:31:38 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46556 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbeKETbi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 14:31:38 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C358F607F7; Mon,  5 Nov 2018 10:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541412760;
        bh=N1N0/3hLsNdqfW3R/E/dgY5cD6+s2pM3Iz3U9h03fng=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=BxijaqCtHOu8DegSgcaNZTIIOSfIRktwB853mHxrJbeIzL+OuR06+3rVlinmEGOHa
         fivUSLvmgum3BnJXKGNPPgk4cD5ApbbnflkbzLP9MSB28pRpisiqK5CpRx7yx1XpSp
         yTdjK4GuTXDGukh/2gUPX/nCPdG6L7morBXLt2LQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E9ED1601DA;
        Mon,  5 Nov 2018 10:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541412760;
        bh=N1N0/3hLsNdqfW3R/E/dgY5cD6+s2pM3Iz3U9h03fng=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=CBqChTo/Js6Vy4U6syFesWEXRnqpyN/6CQMNwqQ1Ipwj4XuyAQOKgHKIs53hGe99x
         gImrTilwVIpph8KECP+HdingZJhUEgEinsou2Ta3ezAhNmfaeM7+Kg6LHWE8aB6x3j
         UNbPqb01JxukAeJmgZcF4Zl8B11fFfZoOIF5pTwk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E9ED1601DA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next] ath10k: fix copy-paste error in
 ath10k_qmi_setup_msa_resources()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1539657316-35629-1-git-send-email-weiyongjun1@huawei.com>
References: <1539657316-35629-1-git-send-email-weiyongjun1@huawei.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Govind Singh <govinds@codeaurora.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181105101240.C358F607F7@smtp.codeaurora.org>
Date:   Mon,  5 Nov 2018 10:12:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wei Yongjun <weiyongjun1@huawei.com> wrote:

> The return value from devm_memremap() is not checked correctly.
> The test is done against a wrong variable. This patch fix it.
> 
> Fixes: ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

4ab7fd955e47 ath10k: fix copy-paste error in ath10k_qmi_setup_msa_resources()

-- 
https://patchwork.kernel.org/patch/10642589/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

