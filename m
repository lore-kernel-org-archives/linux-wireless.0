Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A820AC282DA
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EE102084A
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 12:38:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BCcp9lWd";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hshPNZyP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbfBAMiu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:38:50 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56592 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfBAMiu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 07:38:50 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 48650609C1; Fri,  1 Feb 2019 12:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024729;
        bh=g21OaZ0lrsbiXxJOof0Tqn1TsOM5El9Y6f318XWou2o=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=BCcp9lWdtIkecEq3k1sxNAKBb6qj/VmXK8M5jBqXpfTOUWopqM+ALup6s16JZeVl0
         DgXLAAyMlQHwQF9EtA2072DI/tXxPrk46dBgf/W09NVha/+dc0dVLx31Mf6HXaAzdM
         oWEVutxJdEQP1SR3TxIDwix7iWeZq72rSO1eEXHc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 30E0F60918;
        Fri,  1 Feb 2019 12:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549024722;
        bh=g21OaZ0lrsbiXxJOof0Tqn1TsOM5El9Y6f318XWou2o=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=hshPNZyPfqEZimm3HmRHyWqQhO7pJwTzYGzuzljfTzfkNc9yU88HF0gqi7q/mPeOD
         LiGhJYtOeydaX1as8V+9yQYrfPYj9oouynQ1hDUQoJuH8TWJOIvthO3oOKyvhEvRcE
         hPfxNn9RJ+OA53CzuyS/KXFaSvgdE9aW/+LrAlG0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 30E0F60918
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: no need to check return value of debugfs_create
 functions
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190122152151.16139-33-gregkh@linuxfoundation.org>
References: <20190122152151.16139-33-gregkh@linuxfoundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190201123849.48650609C1@smtp.codeaurora.org>
Date:   Fri,  1 Feb 2019 12:38:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Patch applied to wireless-drivers-next.git, thanks.

b8f1fe518983 rsi: no need to check return value of debugfs_create functions

-- 
https://patchwork.kernel.org/patch/10775759/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

