Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A057C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 343BC2087C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:00:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="I6FVysA7";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Wqpnz823"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfBZNAg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 08:00:36 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38696 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfBZNAg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 08:00:36 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6B00E61B73; Tue, 26 Feb 2019 13:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551186035;
        bh=Kak5r67CgfjtWD2DVHpbPapWnzX+qg3i6LRoEYcUxcQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=I6FVysA7A3rIOkwN2O0WVGlIG04mXsPF+M9y1iO0P8GgbyzFEBvcWgCqeyPD3WGtq
         uKkckUcP1Wki/S5jGQ1y9sGEEEkOzkSisnq3vNrpVs45AVmmKNpyGPMGx9RP3v9qbF
         KBxujQj6/x0QNMsmKcvJgO3yVPvvYEKAa3kX4w28=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 997F861B79;
        Tue, 26 Feb 2019 13:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551186034;
        bh=Kak5r67CgfjtWD2DVHpbPapWnzX+qg3i6LRoEYcUxcQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Wqpnz823H7oVnZTGczgm1X5gp67s5GHg05wmnV5ZhfyrLLvYiy3U1pHKhoz6dKDbe
         K3npYlXQrokKBQoaUTDtYB5C+dxaOpI7HtJZ7jh+ehGeCgYVNu8MjBmft4gN79MkFx
         f0vYUQsVKzlIanQdMvUYjw45hqj/QtJspI1kS+go=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 997F861B79
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: correct the format of host memory chunks in wmi
 init command
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190214031034.26969-1-yyuwang@codeaurora.org>
References: <20190214031034.26969-1-yyuwang@codeaurora.org>
To:     Yu Wang <yyuwang@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Yu Wang <yyuwang@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190226130035.6B00E61B73@smtp.codeaurora.org>
Date:   Tue, 26 Feb 2019 13:00:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yu Wang <yyuwang@codeaurora.org> wrote:

> This is a theoretical fix, the issue is found in code review.
> When adding the host memory chunks into wmi-tlv init command,
> there is no separate tlv header for each host memory chunk
> in the struct array, which breaches the convention between
> host and firmware, will result in mismatch between the two.
> 
> To fix this issue, add separate tlv headers for the host
> memory chunks in wmi-tlv init command.
> 
> Signed-off-by: Yu Wang <yyuwang@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

d961284df24b ath10k: correct the format of host memory chunks in wmi init command

-- 
https://patchwork.kernel.org/patch/10811667/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

