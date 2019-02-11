Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E83C282CE
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 16:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F3902075D
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 16:35:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Tm34xRJd";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Q1K370Oq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbfBKQfe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 11:35:34 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44538 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfBKQfe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 11:35:34 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F30BD60A37; Mon, 11 Feb 2019 16:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549902933;
        bh=/bncIqgu0RuJs49ltvCK+VCV0qtT5aB1lGHQSVC+ZHU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Tm34xRJdf2Xv+g4Z6+bDU+78WnhUIJnGUpHLqhpvg5XWfHH6Hi1IV4un+NX+ZnD9Z
         bUssH+YhKgoqzZjJQ+PtKGr9tRlkmSwqJ9fQ0e5BpVtbvUQ4jncKLoaDGIvGQnzMQQ
         mby8JbqF1RcHANVCJ8L2tXXShUI1p0zpm99p0BIw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 662C160A37;
        Mon, 11 Feb 2019 16:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549902931;
        bh=/bncIqgu0RuJs49ltvCK+VCV0qtT5aB1lGHQSVC+ZHU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Q1K370OqV3GVbANiSx7zNRyALQiLh2fA16AWBqlqvlnqsipYB1Fgy/Sy7DjkV7mom
         H0fnBAbQhMg+BzWGg8pkP3zIJfDW8s2j0zGVi7j42DMhQsvbzBqrHaR8WyO+I891kK
         WAIJmLLn2bCFLLTECxptI9Ciu6zWaYe3UULSMDcM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 662C160A37
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fix shadow register implementation for WCN3990
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1548755647-23356-1-git-send-email-pillair@codeaurora.org>
References: <1548755647-23356-1-git-send-email-pillair@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190211163532.F30BD60A37@smtp.codeaurora.org>
Date:   Mon, 11 Feb 2019 16:35:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> wrote:

> WCN3990 supports shadow registers write operation support
> for copy engine for regular operation in powersave mode.
> 
> Since WCN3990 is a 64-bit target, the shadow register
> implementation needs to be done in the copy engine handlers
> for 64-bit target. Currently the shadow register implementation
> is present in the 32-bit target handlers of copy engine.
> 
> Fix the shadow register copy engine write operation
> implementation for 64-bit target(WCN3990).
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
> 
> Fixes: b7ba83f7c414 ("ath10k: add support for shadow register for WNC3990")
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

1863008369ae ath10k: fix shadow register implementation for WCN3990

-- 
https://patchwork.kernel.org/patch/10785903/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

