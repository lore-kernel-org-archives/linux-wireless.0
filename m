Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E029CC43444
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B14AD206B6
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 11:38:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LWJZA9xj";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TW6kTg1p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbfAJLiK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 06:38:10 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51646 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbfAJLiK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 06:38:10 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C3D206050D; Thu, 10 Jan 2019 11:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547120289;
        bh=vY9fpVJ3jCUzeRDbQwY56b+r8Z6FNX2cll6Lo2nDneo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LWJZA9xjbXwM8nbtdArdJFn45MLL5wr6sAlJIE/Z6k03mO2arCe6mEav6vTuZITZ9
         r9yyvr5+IAgV7V5e58g1b1oxyEhkMWmqmT9ZrNI54mnHPYMnc+RX6ejH0M31aKrGvx
         vsPWJbokxCdH7JOaQQ+bQCvk2XYV24sDUrvqEvxM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 17F6E601D1;
        Thu, 10 Jan 2019 11:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547120289;
        bh=vY9fpVJ3jCUzeRDbQwY56b+r8Z6FNX2cll6Lo2nDneo=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=TW6kTg1pOzUomFsBI2lrZE6fTsRagGI+dySOUO987Oc1/BM8Ym9DYS5clpZg6e8tI
         5D4w1GlHASKoM9BTKlIr85/ASrZzwnHlFZqTohNsB0S1W4n6xhnbiLe032vMI1fgvd
         X1FLJLtB2ueI85ZIpSJIJrdOItT0pbhX+OpUjsYo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 17F6E601D1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: add a check for the status of usb_register
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181226012227.70524-1-kjlu@umn.edu>
References: <20181226012227.70524-1-kjlu@umn.edu>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     kjlu@umn.edu, pakki001@umn.edu,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
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
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190110113809.C3D206050D@smtp.codeaurora.org>
Date:   Thu, 10 Jan 2019 11:38:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kangjie Lu <kjlu@umn.edu> wrote:

> usb_register() may fail, so let's check its status and issue an error
> message if it fails.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>

Patch applied to wireless-drivers-next.git, thanks.

42daad3343be brcmfmac: add a check for the status of usb_register

-- 
https://patchwork.kernel.org/patch/10742769/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

