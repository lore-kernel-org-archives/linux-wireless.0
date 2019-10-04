Return-Path: <SRS0=IBNP=X5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59AC6C4360C
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Oct 2019 13:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C5C820873
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Oct 2019 13:46:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lQ+1Tx9o";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BCB4y/AV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388736AbfJDNqS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:46:18 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50510 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388333AbfJDNqS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Oct 2019 09:46:18 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B236961A26; Fri,  4 Oct 2019 13:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570196777;
        bh=qYuzctfeAB3P/iEMcvGLCy+OrdcVxNVXQhcGiHtST7s=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=lQ+1Tx9oJui7MilLuhJTZeX3buQ8l7OwhBDBSuf6BHYFmbjFUJix8ya1AFx6P+GAs
         SfDOcFRgiuxWoVPsg6doUm8JmLivSyePBXYpxYdYgEKiIasVz3ceKjPI9mgOND0s0k
         pZ1tX0/AOy6izAwUHdH0KO/6wpOaseXdeQU/Cuog=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 896C061A21;
        Fri,  4 Oct 2019 13:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570196776;
        bh=qYuzctfeAB3P/iEMcvGLCy+OrdcVxNVXQhcGiHtST7s=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=BCB4y/AVewXrEJo0nXlLazoNIL19lXniMteZ9LkVuY1kLCkhMb/yJ7oz8QsrHpWz0
         U46XePelmD2YOvUmFBNr2qDm9o+gZ2F7bHoTgtxIDwItx5avnRYawarYAtfzaPzNrn
         OqND16QTC1cFPwvrJEPepY718kxGlaFmzeZuOL1s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 896C061A21
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH V3] brcmfmac: add support for SAE authentication offload
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1570008643-113848-1-git-send-email-chi-hsien.lin@cypress.com>
References: <1570008643-113848-1-git-send-email-chi-hsien.lin@cypress.com>
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Stanley Hsu <Stanley.Hsu@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191004134617.B236961A26@smtp.codeaurora.org>
Date:   Fri,  4 Oct 2019 13:46:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com> wrote:

> From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> 
> The firmware may have SAE authentication code built-in. This is
> detected by the driver and indicated in the wiphy features flags.
> User-space can use this flag to determine whether or not to provide
> the password material for SAE authentication in the nl80211 CONNECT
> command.
> 
> Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>

Patch applied to wireless-drivers-next.git, thanks.

3b1e0a7bdfee brcmfmac: add support for SAE authentication offload

-- 
https://patchwork.kernel.org/patch/11170687/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

