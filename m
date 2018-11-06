Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4277C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:46:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DA562085B
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:46:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Xxryb8In";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Dxnb41gn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DA562085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389324AbeKGCMZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:12:25 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33596 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388935AbeKGCMZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:12:25 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0B6156038E; Tue,  6 Nov 2018 16:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541522781;
        bh=w5vsS6AtS4mHQo+tfPGC7VCfVpXM14WGdEAV5mZeyDk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Xxryb8InDIfWNjQuNhtZKJoB5FjCosUMo6wQCX+lRCzM7yZ2yEv74yWklXIt8d2KF
         QU0QAFP9mv0en9qDbUYXlDLH9YQQyUIQi5BOOUAN9Li1F39SrvAVFllCu7csF7SwVu
         9w5+8PeJo85lCTrmHrU7hn5y/4Cn9GvRwSX27e9I=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9B34B6038E;
        Tue,  6 Nov 2018 16:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541522779;
        bh=w5vsS6AtS4mHQo+tfPGC7VCfVpXM14WGdEAV5mZeyDk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Dxnb41gnMtV8FaDK6p8qWn3beaiPoGeV/XnIqbcIFx5L1+Ebuq+ZbpCNwqZDfXz3G
         L4o/ne2ZBpgjeSuYUASk22pvQaSqmgxQrGZ5iaCidqFxKgWh3iLD/iyU2ldc6VAE7Z
         JZcuf9A6y/YLIT1wrsNl6MYwOmlUYV6sfXBqsIl4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9B34B6038E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 4.20 FIX] brcmutil: really fix decoding channel info for
 160 MHz bandwidth
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181026105039.11445-1-zajec5@gmail.com>
References: <20181026105039.11445-1-zajec5@gmail.com>
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
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106164621.0B6156038E@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 16:46:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Previous commit /adding/ support for 160 MHz chanspecs was incomplete.
> It didn't set bandwidth info and didn't extract control channel info. As
> the result it was also using uninitialized "sb" var.
> 
> This change has been tested for two chanspecs found to be reported by
> some devices/firmwares:
> 1) 60/160 (0xee32)
>    Before: chnum:50 control_ch_num:36
>     After: chnum:50 control_ch_num:60
> 2) 120/160 (0xed72)
>    Before: chnum:114 control_ch_num:100
>     After: chnum:114 control_ch_num:120
> 
> Fixes: 330994e8e8ec ("brcmfmac: fix for proper support of 160MHz bandwidth")
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Patch applied to wireless-drivers.git, thanks.

3401d42c7ea2 brcmutil: really fix decoding channel info for 160 MHz bandwidth

-- 
https://patchwork.kernel.org/patch/10657205/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

