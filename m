Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC540C43219
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 454AD20684
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:59:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Rxj78DOD";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QNP80vzD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfDYQ7k (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:59:40 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34976 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfDYQ7k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:59:40 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A4B6860252; Thu, 25 Apr 2019 16:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211579;
        bh=UMqlT7U55O0RbMd03w8zuxA5twSFB/gucj86wTeUPzc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Rxj78DODhsPvFDtM7Pav7+7hMYMtdGJTP+1Za6RbIFcN9znGi7RqLB9ce0kDHBI5K
         3sEiypEulm4oDy3FQc/ucsmwNYsKLwsV/9uS01meQf5Ijc6Aq1Qp0zvvHISeq8CplK
         wP9v60op4ojbXsgX1SZPEGN/fEP1MF2PugdflYRk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6E5BA602DC;
        Thu, 25 Apr 2019 16:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211579;
        bh=UMqlT7U55O0RbMd03w8zuxA5twSFB/gucj86wTeUPzc=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=QNP80vzDrncEl23GuYCfE3hMjzddLQUGX7Q4Pt32lXAuecH7CKlPr+A3aGhyDRzjl
         dGdbBgoQxK3Mbc7kg5/iHaxijtFJzjG45D1lvi9tOOt/dAHtTZMLEjCpcs5j0Owbby
         EhuJlBh9zQSGOTZ7MymOdaQj7vtyJbbGqR4ZEI0I=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6E5BA602DC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] brcmfmac: send mailbox interrupt twice for specific
 hardware device
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1556175939-174559-1-git-send-email-wright.feng@cypress.com>
References: <1556175939-174559-1-git-send-email-wright.feng@cypress.com>
To:     Wright Feng <Wright.Feng@cypress.com>
Cc:     "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425165939.A4B6860252@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:59:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wright Feng <Wright.Feng@cypress.com> wrote:

> For PCIE wireless device with core revision less than 14, device may miss
> PCIE to System Backplane Interrupt via PCIEtoSBMailbox. So add sending
> mail box interrupt twice as a hardware workaround.
> 
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Failed to compile:

drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c: In function 'brcmf_pcie_send_mb_data':
drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c:703:2: error: 'core' undeclared (first use in this function); did you mean 'cred'?
  core = brcmf_chip_get_core(devinfo->ci, BCMA_CORE_PCIE2);
  ^~~~
  cred
drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c:703:2: note: each undeclared identifier is reported only once for each function it appears in
make[6]: *** [drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.o] Error 1
make[5]: *** [drivers/net/wireless/broadcom/brcm80211/brcmfmac] Error 2
make[4]: *** [drivers/net/wireless/broadcom/brcm80211] Error 2
make[3]: *** [drivers/net/wireless/broadcom] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10916093/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

