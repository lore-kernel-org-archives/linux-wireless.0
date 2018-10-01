Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 821ABC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 15:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39EE520666
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 15:36:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BAN6gnyA";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JSxpyuJv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39EE520666
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbeJAWOz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 18:14:55 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38062 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725266AbeJAWOz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 18:14:55 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BBA9460BF4; Mon,  1 Oct 2018 15:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538408192;
        bh=Jm7w4B6OqVuDo7j0DBLdCDyFCEghQLeEafPNrl7y5jY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=BAN6gnyA6jI+dJoJPBJvchvxRvpmw5RLpXiulYYXi07E0xyAs/I5Nfn17Cp+qqUzm
         MDCCeIrITZj8kI1ZwdXY+qy94ScYdtE7SYfNKXoX6mWHhEqmBwGv8cvmikcdV1M6BU
         bKwvUh+ZsxiezH6Fc4PCpx8fq7op40mKtvunSq7k=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A472560116;
        Mon,  1 Oct 2018 15:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538408192;
        bh=Jm7w4B6OqVuDo7j0DBLdCDyFCEghQLeEafPNrl7y5jY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=JSxpyuJvbs0fNEgTdpChd7skfjUFz6/b86HkmxLXa0rZIsZfK49xrPWVX3gXwCBgM
         40Qno+LnkZtkLIAjqL1xSrBobX+zoIazxbLqvpSOdBpEKbXT8QnZ9iSq1dP6m/BdgD
         5IvjdLnW8XieW5neavDvukugySKq7lfa41y4foEc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A472560116
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath5k: Remove unused BUG_ON
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180921193235.1723-1-natechancellor@gmail.com>
References: <20180921193235.1723-1-natechancellor@gmail.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181001153632.BBA9460BF4@smtp.codeaurora.org>
Date:   Mon,  1 Oct 2018 15:36:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Nathan Chancellor <natechancellor@gmail.com> wrote:

> Clang warns that the address of a pointer will always evaluated as true
> in a boolean context:
> 
> drivers/net/wireless/ath/ath5k/debug.c:1031:14: warning: address of
> array 'ah->sbands' will always evaluate to 'true'
> [-Wpointer-bool-conversion]
>         BUG_ON(!ah->sbands);
>                ~~~~~^~~~~~
> ./include/asm-generic/bug.h:61:45: note: expanded from macro 'BUG_ON'
> #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
>                                             ^~~~~~~~~
> ./include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
> # define unlikely(x)    __builtin_expect(!!(x), 0)
>                                             ^
> 1 warning generated.
> 
> Given that this condition is always false because of the logical not,
> just remove it.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/130
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

0891c7f4a253 ath5k: Remove unused BUG_ON

-- 
https://patchwork.kernel.org/patch/10610881/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

