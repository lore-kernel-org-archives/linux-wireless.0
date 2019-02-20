Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40735C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 17:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CBCE2146E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 17:55:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gf/X0SDj";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IMR17jAs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbfBTRzN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 12:55:13 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38068 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfBTRzN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 12:55:13 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 00096607EF; Wed, 20 Feb 2019 17:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550685312;
        bh=UqEBRIbMVQm4tbU2J6O5QAmaQ3yjOoXT0Qy96nXxc6A=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gf/X0SDjrDJYPIZokEJrGzpYUXbK3nNQNal8xrkXKW16pMc8AGFFkTOPHGtnkbhTT
         GxVSUm85zKM6RMOJkzAwfpXotPzOzRGMmTjRl7SgLjtW69jvOtCx28SZ9a8sOxLfpY
         7/Od9Ol4SPevGxU95JClci+NMmK3ee5YXiPYMUBk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3ED536075A;
        Wed, 20 Feb 2019 17:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550685311;
        bh=UqEBRIbMVQm4tbU2J6O5QAmaQ3yjOoXT0Qy96nXxc6A=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=IMR17jAsQz7OrZHUqftq3WGDvRcJF3/y26nAnBkjNInMJLaOkirxRjqjkJbYHIvaz
         3WFgUZAOCskS8KAJMQaFLvbncGw33LJ/xNR8b43YhtAVx8A5pRPtJRdc+ihknSAoND
         YbIc6AiAHUbiGRABsxo7DG0vlhGeVuiP9SGL0c1Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3ED536075A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] rtlwifi: rtl8192ce: fix typo,
 "PairwiseENcAlgorithm" -> "PairwiseEncAlgorithm"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190220092727.17119-1-colin.king@canonical.com>
References: <20190220092727.17119-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190220175512.00096607EF@smtp.codeaurora.org>
Date:   Wed, 20 Feb 2019 17:55:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is an uppercase 'N' that should be a lowercase 'n', fix this.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

0421dd4167ec rtlwifi: rtl8192ce: fix typo, "PairwiseENcAlgorithm" -> "PairwiseEncAlgorithm"

-- 
https://patchwork.kernel.org/patch/10821751/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

