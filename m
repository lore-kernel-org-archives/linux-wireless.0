Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EED9C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 15:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 635C32082F
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 15:43:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZQdAE2/2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XsejuBAq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 635C32082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbeK3CtT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 21:49:19 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59798 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728363AbeK3CtT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 21:49:19 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A81A46020A; Thu, 29 Nov 2018 15:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543506212;
        bh=xiXgIz5jDvOdAJq6DaCgzaW7qQC14yQNhuQKdTidqZA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ZQdAE2/2lPjSVrNJKqkDOZNSvyFMHaPXBIsT1gg9Ie+k5UR8olKhnEozuNFAX0FwL
         FXKtNgWxnIb9zNatiyBlRK6TbDzneleI+ENh7z1YvtrGY/wQY4MWgUTV9cdwTcR4kJ
         ZiAQhPo4lGTCnvhje3l4sUU1MPAffYa1iGp2mcHc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1EAB660246;
        Thu, 29 Nov 2018 15:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543506211;
        bh=xiXgIz5jDvOdAJq6DaCgzaW7qQC14yQNhuQKdTidqZA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=XsejuBAqX7Hzkp188dODhIOw0CsnHrwUgDMKTbp1mFFw7h4lZgD9EP+9X3Mpy7ret
         o1gvj4j4ml6ao1rTzJ9ItDdOaBZ2Hl4LBPtOnAaRi5ilqT/Zb/QOBeFrnOzp05EZh7
         2+EdwE84zxse2Th2hqVEZl5xzquJDRz8JUcZprjo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1EAB660246
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 1/3] brcmfmac: add credit numbers updating support
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181105055137.13333-2-wright.feng@cypress.com>
References: <20181105055137.13333-2-wright.feng@cypress.com>
To:     Wright Feng <Wright.Feng@cypress.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Wright Feng <Wright.Feng@cypress.com>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181129154332.A81A46020A@smtp.codeaurora.org>
Date:   Thu, 29 Nov 2018 15:43:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wright Feng <Wright.Feng@cypress.com> wrote:

> The credit numbers are static and tunable per chip in firmware side.
> However the credit number may be changed that is based on packet pool
> length and will send BRCMF_E_FIFO_CREDIT_MAP event to notify host driver
> updates the credit numbers during interface up.
> The purpose of this patch is making host driver has ability of updating
> the credit numbers when receiving the BRCMF_E_FIFO_CREDIT_MAP event.
> 
> Signed-off-by: Wright Feng <wright.feng@cypress.com>

Arend, what should I do with this patchset?

-- 
https://patchwork.kernel.org/patch/10667393/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

