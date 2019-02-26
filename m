Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 132ABC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 12:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D512D217F9
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 12:10:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="e/+Qdk+K";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RMHlIlQA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfBZMKj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 07:10:39 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42178 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfBZMKj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 07:10:39 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 80EC7621F3; Tue, 26 Feb 2019 12:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551183038;
        bh=/dNIoyupdkHSiiw6jdd6ZU3yyT0otJWKYGQvgkzQ/aw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=e/+Qdk+K3LMfIMzwOkTixaMIoc1My3miLpvNZ2ByNBLq6Ka+VJ8jsb83/qSzxC5hb
         NbZttTf1aEIm/HI163cZwF1V4NUnV0rUcvnvaac/vKK/xftfIG0zqYSr1NIKRYj9xi
         TJPfRd0fIgAs98BR6/QF3NoPMcClGzNQiWO4qtus=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 577F561F29;
        Tue, 26 Feb 2019 12:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551182998;
        bh=/dNIoyupdkHSiiw6jdd6ZU3yyT0otJWKYGQvgkzQ/aw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RMHlIlQAtaCKidqOOur2hlObendQYnpiA6ysFlqsJuoPySjKd1QIF0nNRNJERqDr7
         abPZL/UKLKk1pIdUAJwvk173nNrDAg/nbYGsRHkLyJa5lgMeD1oKubs8/B+Ur/7UbO
         XigZblG2gFfLPP/YJNuZB+LohAeKzdqX9F2rD4Vo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 577F561F29
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Surabhi Vishnoi <svishnoi@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Fill rx duration for each peer in fw_stats for WCN3990
References: <1550570110-32010-1-git-send-email-svishnoi@codeaurora.org>
        <20190225171756.9632C609F3@smtp.codeaurora.org>
        <558f033a71573862be59867f22c75294@codeaurora.org>
Date:   Tue, 26 Feb 2019 14:09:54 +0200
In-Reply-To: <558f033a71573862be59867f22c75294@codeaurora.org> (Surabhi
        Vishnoi's message of "Tue, 26 Feb 2019 17:23:40 +0530")
Message-ID: <87ftsalpil.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Surabhi Vishnoi <svishnoi@codeaurora.org> writes:

> I have uploaded the v2 patch which fixes the warning.
> https://patchwork.kernel.org/patch/10829811/

Thanks, but PLEASE do not top post. It's really annoying.

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#do_not_top_post_and_edit_your_quotes

-- 
Kalle Valo
