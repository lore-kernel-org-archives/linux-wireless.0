Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE88AC43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 16:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FCDA2087F
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 16:44:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PIcVMmlk";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fUbnCcoc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbfAHQoB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 11:44:01 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57188 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727739AbfAHQoB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 11:44:01 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D6BCB6020A; Tue,  8 Jan 2019 16:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546965840;
        bh=KyQRsjjAvfwHS6hwU8JJhlCyzitJl51QdVNv1Lc3d5g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PIcVMmlkoeONxtrE0KA7WvJEGAe/7AiLbahsOMqwhh+2H+5xJZ2tEV4ar6aLZjnO/
         RwTzib64LDLYTdzdchKdcNmcljqIugJHNEZA06Cm68OkKB1ejj8NUL4Y7ubRPLtY3h
         +JX8xIrWFOhIowV/UDckDJN/jed/amjQ4Bx9OCAc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 985BF6079B;
        Tue,  8 Jan 2019 16:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546965839;
        bh=KyQRsjjAvfwHS6hwU8JJhlCyzitJl51QdVNv1Lc3d5g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fUbnCcoc1rg6U/dCkqVNvTS7na1pkWFYF61TInpRACI7vWgBu9IGqM2/IOqpqrspY
         UmT3vHCUKZenBJDhDgYJ+qk61rqwwG+SSqWckMe2KcPZJCOSqOagxt3oPfIiDYr6ur
         /U5mQSvCBiFj2Wb5ewinfYXY39i0a82WcGreVkxM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 985BF6079B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: brcm80211: add a check for the status of usb_register
References: <20181226012227.70524-1-kjlu@umn.edu>
Date:   Tue, 08 Jan 2019 18:43:53 +0200
In-Reply-To: <20181226012227.70524-1-kjlu@umn.edu> (Kangjie Lu's message of
        "Tue, 25 Dec 2018 19:22:24 -0600")
Message-ID: <87zhsbqeuu.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kangjie Lu <kjlu@umn.edu> writes:

> usb_register() may fail, so let's check its status and issue an error
> message if it fails.
>
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 6 +++++-

The title prefix should be "brcmfmac: " but I can fix that.

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_title_is_wrong

-- 
Kalle Valo
