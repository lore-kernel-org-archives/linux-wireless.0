Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE15C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 15:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EA232147D
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 15:33:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZLuOPykA";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Aaix9crg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EA232147D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731104AbeKVCIn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 21:08:43 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42404 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730072AbeKVCIn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 21:08:43 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7136E60588; Wed, 21 Nov 2018 15:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542814428;
        bh=49C9OVi5ypqjPRzLDElWrqr9vAguqx8X6pWUMO6zBcM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZLuOPykAgMeNM/v1c7dDWk0vedeF4jvPHMsRt3FccGnPZ5SpUxaIPif49bxm/UjAT
         33xjW7EwPjz46HMnHYTMNi3+QkBOwQ/76ojoHgC/HG32MKy4gyr9UnjS4G8pQD9Ns7
         JeHSAp6b0uIijABOq+11575UI0NkLGRwe+EeatEg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DEEE160541;
        Wed, 21 Nov 2018 15:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542814427;
        bh=49C9OVi5ypqjPRzLDElWrqr9vAguqx8X6pWUMO6zBcM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Aaix9crg8fhQn2JsUvSNsoz7Q2oRLoNjesBDY5zzrX4kn7ugL8qpdD6F5uxfLfH/e
         RNsdQdbkPsnFutDHELkOK/tGFqlPtNthW2epIOzFFKDON3BJdI93f/sKrtcTDfrEVu
         zF3QjydthXiSDgU1LpaCqxiTRhPRCVC5/b97j5W4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DEEE160541
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list\@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>
Subject: Re: [PATCH 0/8] brcmfmac: chip related changes
References: <1542783402-112482-1-git-send-email-chi-hsien.lin@cypress.com>
Date:   Wed, 21 Nov 2018 17:33:42 +0200
In-Reply-To: <1542783402-112482-1-git-send-email-chi-hsien.lin@cypress.com>
        (Chi-Hsien Lin's message of "Wed, 21 Nov 2018 06:57:09 +0000")
Message-ID: <87ftvubg2x.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com> writes:

> This patch series includes various chip-related changes:
> * 43012 support
> * 4373 saverestore support
> * SDIO bus settings
> * 4354 raw chipid
>
> Changelog:
> V3:
>  - Update comments for patch 3.
>  - Add defines for sr_control0 register bits in patch 7.
> V2:
>  - Update commit message for patch 1.
>  - Update comments for patch 2.
>  - Remove CY_4373_F1_MESBUSYCTRL from patch 3.
>  - Collapse patch 6 (43102 sr support) in 4 (43012 support). Add helper functions.
>  - Remove sr_eng_en variable from patch 8.
>  - Collapse patch 10 and 11 in 9 (sdio_aos disable).

As you submitted v4 an hour later I assume this one was a mistake and
I'll drop it.

-- 
Kalle Valo
