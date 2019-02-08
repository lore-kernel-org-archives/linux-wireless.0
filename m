Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E55C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 15:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F46C2080F
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 15:30:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="X3364QB2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MhBOBFl1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfBHPaF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 10:30:05 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34008 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbfBHPaF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 10:30:05 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B64E9609EF; Fri,  8 Feb 2019 15:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549639804;
        bh=1PybmroUlTxPrngBAd+6SIxPOc4Bq+7RQPdBF0fhKpU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=X3364QB2BTT5qbgghOKBOkAKAjMC45iCq8Mo+Ncf3wAm4f2yjjpfA2h2dPOeuYDqY
         UZMJgRkhJzwXYfgvDZBxuqz/oUmxveLLD65e+z8azloyeRiaUtWJ+60oo90L6Z/OeF
         A042E91fEWXLBj0iU7R3fxvB2hrAlReboKcrCeVA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BBADA60909;
        Fri,  8 Feb 2019 15:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549639804;
        bh=1PybmroUlTxPrngBAd+6SIxPOc4Bq+7RQPdBF0fhKpU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=MhBOBFl1zggfcf7GZikyAWqU+xaiZFJxqPdr97SC4tAwfnEZBBsovb+GPPK4E2GYh
         2Ww2XGCJGBRqxR8UTCqsxjNlQmwhqPrvM0DFj1JuFSZquKfxxTTVh5bE+6ZCHp9LCI
         cioSVFla9vRSIGElOl9EVVD+cJX95cmiUUIpAT8g=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BBADA60909
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v3 1/5] rsi: Add debug support for wowlan wakeup confirmation
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1549262009-8766-2-git-send-email-siva8118@gmail.com>
References: <1549262009-8766-2-git-send-email-siva8118@gmail.com>
To:     Siva Rebbagondla <siva8118@gmail.com>
Cc:     linux-wireless@vger.kernel.org, rishikesh.basu@redpinesignals.com,
        siva.rebbagondla@redpinesignals.com,
        krishna.pedda@redpinesignals.com, amitkarwar@gmail.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190208153004.B64E9609EF@smtp.codeaurora.org>
Date:   Fri,  8 Feb 2019 15:30:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Siva Rebbagondla <siva8118@gmail.com> wrote:

> From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> 
> When a wowlan magic-packet has received to wake up the device, currently
> driver is not taking care of what kind of packet has received. This patch
> will add debug support for wakeup reason in driver.
> 
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

5 patches applied to wireless-drivers-next.git, thanks.

6f3a5de16d68 rsi: Add debug support for wowlan wakeup confirmation
cbde979b33fa rsi: add hci detach for hibernation and poweroff
a63762d0dc36 rsi: fix wowlan wakeup issue for hibernate(S4)
73f9b2571487 rsi: resolve power save issue after S4 resume
38ef8d9016da rsi: fix for wowlan wakeup failure

-- 
https://patchwork.kernel.org/patch/10794977/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

