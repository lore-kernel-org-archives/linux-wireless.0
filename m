Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49794C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C5FB2086D
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:56:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Iruz1c1z";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="U/Hv1k9i"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C5FB2086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbeLMO46 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 09:56:58 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:47186 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728003AbeLMO46 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 09:56:58 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 655C560863; Thu, 13 Dec 2018 14:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544713017;
        bh=6aTQlPy7dOLHYuob6LnjGhT16plRuAAQLsTnvoW6lUE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Iruz1c1zX2KM3rwazW8HAoydO2aKNNW7O6t6+Bf450eQcPWcHa3L4PJ0dH6Ayk235
         JOCnbzrPynNPHaC17cHBlhd1+W1PsEDW68yu4h6SVrpX4x6Kz1zQkDmIjcBo3NDY5Z
         iIn9vzq+v/ak2SLFfn4ILRn8tnpsqk4Zm2bS2hbw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EE196601C3;
        Thu, 13 Dec 2018 14:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544713016;
        bh=6aTQlPy7dOLHYuob6LnjGhT16plRuAAQLsTnvoW6lUE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=U/Hv1k9iVWob0zmem0lcEe/5O4L6swFU6Zb2FwOhrGQe3M8pXWKpKTKaC8DRKWanC
         A/5Ay98Il0CisDJOR9CSWo2sIJxqbqLr3g7Rgufo3kvA2rEqWuiCSLdtXsxtMNm9z7
         BhqDNQNIdUIk5qBjasFQASIDxCP5svD6oW8JuhqE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EE196601C3
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
Message-Id: <20181213145657.655C560863@smtp.codeaurora.org>
Date:   Thu, 13 Dec 2018 14:56:57 +0000 (UTC)
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
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

3 patches applied to wireless-drivers-next.git, thanks.

153e22c0ff12 brcmfmac: add credit numbers updating support
a3bdc6deb60b brcmfmac: enable frameburst mode in default firmware setting
e4af3ffb43d5 brcmfmac: handle compressed tx status signal

-- 
https://patchwork.kernel.org/patch/10667393/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

