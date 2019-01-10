Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E18AC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EE89206B6
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:41:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DRx9petN";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="F/b3QI1z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbfAJLk7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 06:40:59 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:52892 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbfAJLk7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 06:40:59 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E1935608C6; Thu, 10 Jan 2019 11:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547120458;
        bh=ZuyFyqWBl0xhneJMqJVuEpW0DA+GfAq38arwCQhQgNU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=DRx9petNQ3nvUVP8ICp4QlUfAt3jk0igNliR6I7AVN1NyicECe9lsJNf6Bw+JZF34
         i7Vo55PbYX6vBTeFkP3seJ0FZ30UcTPW3E7HiaN3V0oWYkto4j8Ujo5p8YVaXNT4hX
         R++Khc4rEE7456WyTGtFQJp2VCXDeRxKlYTGa+dg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3F16E601D1;
        Thu, 10 Jan 2019 11:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547120458;
        bh=ZuyFyqWBl0xhneJMqJVuEpW0DA+GfAq38arwCQhQgNU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=F/b3QI1zDgnbMO8EPWrBOuImkBLQDsTMYwRK2cMDfsbMjwtJDUsOmJfVF/ubsyYzG
         3fFTihmsSpqx5zPGKgV1db7Tjtvb3rNr4zEnBpTlT+vmMQtmK0pp9a9RfwZOxYRt+S
         6NMPgvcjBAzt7oFwjLIOjGSC2UD2cQ5vpV5KaM4s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3F16E601D1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH V2] brcmfmac: fix system warning message during wowl
 suspend
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1546850746-165123-1-git-send-email-chi-hsien.lin@cypress.com>
References: <1546850746-165123-1-git-send-email-chi-hsien.lin@cypress.com>
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Double Lo <Double.Lo@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190110114058.E1935608C6@smtp.codeaurora.org>
Date:   Thu, 10 Jan 2019 11:40:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com> wrote:

> From: Lo-Hsiang Lo <double.lo@cypress.com>
> 
> There is a system warning message, warn_slowpath-fmt, during suspend
> while using supplicant join AP and enable wowl feature by IW command.
> It's caused by brcmf_pno_remove_request path can't find the reqid.
> This fix will not go to remove pno request function if there is no
> pno scan.
> 
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Lo-Hsiang Lo <double.lo@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>

Patch applied to wireless-drivers-next.git, thanks.

3a33bd840523 brcmfmac: fix system warning message during wowl suspend

-- 
https://patchwork.kernel.org/patch/10750153/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

