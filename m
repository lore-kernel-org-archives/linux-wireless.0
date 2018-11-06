Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B592FC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:19:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DBF32081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:19:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ivBZ+6YU";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YtvXuCvT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DBF32081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389253AbeKGBos (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 20:44:48 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:55900 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389197AbeKGBos (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 20:44:48 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B376A601D7; Tue,  6 Nov 2018 16:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541521131;
        bh=zy6/oyxhTn/t95UoW4OvcuRAb21xefvFe4HswrEgZEM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ivBZ+6YUNoP92KJ6d3eyFvGfl/SPeI+nyqkdG1g9NCUFxDHZnM3TWKoG1MnmYOmiC
         zw9JNuaAwEBI9kdOvGdmwa+antzpvwFmDKNluoeHfaI7qzw/yuKBc+J4mmw7pgFrLi
         6SCQe9b1Yv0xLqrbcZePIp4m1S5QbVzXmsW5uwlk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BF10C601D7;
        Tue,  6 Nov 2018 16:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541521130;
        bh=zy6/oyxhTn/t95UoW4OvcuRAb21xefvFe4HswrEgZEM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=YtvXuCvTkLdYAm7Kh0MFmdGp2PP5V7pfgAfogQ4alN0Yf5k5WYxFRj2UV4eVU279Q
         NVlFzg50sRzU4E8/p8os1BHa+Rzq24c4v4VSIlM1HMbiNsqjAHCVyZq7OE/eoadkho
         u6ZvLSjQ43i8YI6c7yGhaoUnpSnSrBp/+gGQhVXM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BF10C601D7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: ath10k_snoc_{read,write}32() should be static
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181102181000.96834-1-briannorris@chromium.org>
References: <20181102181000.96834-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106161851.B376A601D7@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 16:18:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> They're provided as callbacks in ath10k_hif_ops and should be accessed
> that way, if needed outside of snoc.c, and anyway, they're currently
> unused outside snoc.c.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

97b9608be34f ath10k: ath10k_snoc_{read,write}32() should be static

-- 
https://patchwork.kernel.org/patch/10665971/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

