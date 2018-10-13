Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A75DC28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32CD82064A
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:17:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W40LYS3O";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kD/LodPa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32CD82064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbeJNAzc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 20:55:32 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43190 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbeJNAzc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 20:55:32 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 81AC060C60; Sat, 13 Oct 2018 17:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539451054;
        bh=4sMXcUEzv4QFzSzFpCN+s13J8pjahobsh+RVzUm6oCI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=W40LYS3OBusbe+kCPBATT3QOi31QWMvqwByJCpi0nsEwQyFiv3ZblE/erDsm+V/5W
         kJrEaEp2eFoH0fxvtF4Th+J3BltbWoHMgy7ztIcWpNsRQnAbqRbETogUL+/JD9F6LV
         VGgSC76ykkTR+olZ0RbNUYEq9viW6M9rxItloboM=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EACA36079B;
        Sat, 13 Oct 2018 17:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539451054;
        bh=4sMXcUEzv4QFzSzFpCN+s13J8pjahobsh+RVzUm6oCI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=kD/LodPaJoilCbYW0TMpU28t+11/PSeiXgT721pbEYxINQid0FZBMxCbXSGCodQLa
         ueLXH5EgVdADCPvHnp4CYMxgXppuzfGvU4p1agbYRNhVAtTJCITHXALhIehT4bXj78
         a089QJc0qQv0Ho2eFS/6yi8E5igsRkROiaRsc89k=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EACA36079B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Set probe request oui during driver start
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1538503393-17543-1-git-send-email-pillair@codeaurora.org>
References: <1538503393-17543-1-git-send-email-pillair@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181013171734.81AC060C60@smtp.codeaurora.org>
Date:   Sat, 13 Oct 2018 17:17:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> wrote:

> Currently the wmi command for setting probe request
> oui, needed for mac randomization, is sent during
> the mac register. At this time, during the driver
> init the wmi has already been detached. This can
> cause unexpected behavior since the firmware is
> already down and the wmi has been detached.
> 
> Send the wmi command for setting probe request
> oui during the driver start. This will make sure
> that the firmware is started and wmi is initialized
> before we send this command.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
> 
> Fixes: 60e1d0fb290197fe505dff6e4e3b7e4d258dbf60
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

f1157695c527 ath10k: set probe request oui during driver start

-- 
https://patchwork.kernel.org/patch/10623963/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

