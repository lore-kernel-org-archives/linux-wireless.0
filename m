Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6C8C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 13:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8D192086B
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 13:13:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NVd/G/q0";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gXi7UeBM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8D192086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389682AbeKPXZg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 18:25:36 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:53436 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbeKPXZf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 18:25:35 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 82902607B9; Fri, 16 Nov 2018 13:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542373994;
        bh=7haAZ9VbauFg7c93zQ+SqlRqK16JF0n01DG6K0ZBBoY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=NVd/G/q0RLlBMqbgt+QSNVwXojjza9lLrSWVTWJBy/nIWxxPCKclXStc1zlCdVBP1
         pVX9Q4NSDaEOdk+Sde+jRRPI1ZPEt8U16YPNeUoXrlkhJ7oa1TZZmpjI7wpGAlC7/E
         fQI2R911+0Z6f/B/Z5LbWvBF/WB1YdLnNMB2qUCY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3CB586035F;
        Fri, 16 Nov 2018 13:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542373993;
        bh=7haAZ9VbauFg7c93zQ+SqlRqK16JF0n01DG6K0ZBBoY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=gXi7UeBMrn4RLcDTrtn76alkjUksWiwZFFSaE/Or9Ip6BeTV6cwcKte931otOxVdM
         OrTG2MSv9b0A9nI3QiGwEWS2rmlsRAkGgK5u5pmcnI0BYVocCxPMzdP6+L02wDuT6l
         t/eg+P6hg4WSdAQzFyXNy5QOqkJVBA9f6ANbol4Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3CB586035F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH FIX] brcmfmac: fix reporting support for 160 MHz channels
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181108150829.24842-1-zajec5@gmail.com>
References: <20181108150829.24842-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        stable@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181116131314.82902607B9@smtp.codeaurora.org>
Date:   Fri, 16 Nov 2018 13:13:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Driver can report IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ so it's
> important to provide valid & complete info about supported bands for
> each channel. By default no support for 160 MHz should be assumed unless
> firmware reports it for a given channel later.
> 
> This fixes info passed to the userspace. Without that change userspace
> could try to use invalid channel and fail to start an interface.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Cc: stable@vger.kernel.org

Patch applied to wireless-drivers.git, thanks.

d1fe6ad6f6bd brcmfmac: fix reporting support for 160 MHz channels

-- 
https://patchwork.kernel.org/patch/10674521/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

