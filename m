Return-Path: <SRS0=lMj3=ZV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 370BDC432C0
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Nov 2019 07:42:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F20EE217AB
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Nov 2019 07:42:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RFNjmqbh";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="BldBTM3h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfK2HmU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 Nov 2019 02:42:20 -0500
Received: from a27-10.smtp-out.us-west-2.amazonses.com ([54.240.27.10]:42436
        "EHLO a27-10.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726763AbfK2HmU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Nov 2019 02:42:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575013339;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=4XIwvUQih0yy7FiIkvN44JrdUnDIONJWQz0DnPJGZ9M=;
        b=RFNjmqbhOPwwQLbKSv1nMJUF0ALyoiW/IlbLwxHSYpEpC9I2ttGppMeCB8+tSj3v
        aGMzA0uBkcVe+jDMloSsp8PQrAKOJLKD5zx9/zEAuaogCkuCMSneNYwRAZjaCMJ2lyy
        8IyZd3GcQce/VGA2Y2zVg7URz7V/vHeNjXl7EYBY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575013339;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=4XIwvUQih0yy7FiIkvN44JrdUnDIONJWQz0DnPJGZ9M=;
        b=BldBTM3hod+m/vRgSBokBrrnUbQIEbA+7Zl7mHAmXOC5Viu2yec/GszkUE+y7qvM
        TpmjRmGFcrpxAbqzc5MpBCPsM0/PxX+u9uX2onpc8hmWkO81ZXDqcvY4scmHpHzcUMG
        6lTgcd/lkT3g0di2O5vkHcoFH84ZVeGnMedsNfAk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3F3A8C4479F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: set max mtu to 1500 for sdio chip
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <0101016eaacca72d-a73d6fb5-0e3f-4fbb-9045-8363270fe25f-000000@us-west-2.amazonses.com>
References: <0101016eaacca72d-a73d6fb5-0e3f-4fbb-9045-8363270fe25f-000000@us-west-2.amazonses.com>
To:     Wen Gong <wgong@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-ID: <0101016eb61c518b-fe522c68-ad16-4bd3-b6e6-53def1d4aa89-000000@us-west-2.amazonses.com>
Date:   Fri, 29 Nov 2019 07:42:19 +0000
X-SES-Outgoing: 2019.11.29-54.240.27.10
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wen Gong <wgong@codeaurora.org> wrote:

> For sdio chip, the max credit size in firmware is 1556, the 1556
> include payload, ieee80211 header, htt header, htc header. So it
> need to set the max mtu to 1500 to forbidden TX packet which exceed
> 1500 form application.
> 
> Tested with QCA6174 SDIO with firmware
> WLAN.RMH.4.4.1-00017-QCARMSWP-1.
> 
> Signed-off-by: Wen Gong <wgong@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

376a30c7c9a0 ath10k: set max mtu to 1500 for sdio chip

-- 
https://patchwork.kernel.org/patch/11263345/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

