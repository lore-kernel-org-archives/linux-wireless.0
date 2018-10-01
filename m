Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D92C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 15:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D215208D9
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 15:32:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cq3NpQxG";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="E5LuBjyb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D215208D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbeJAWKY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 18:10:24 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33930 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729536AbeJAWKY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 18:10:24 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C727D60C86; Mon,  1 Oct 2018 15:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538407922;
        bh=lSIulFUMZDeHC3jcU5LtyALqdUJhjBTM6HxAnkQAim4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=cq3NpQxGIFoJ3l4py2BB+bFE7DQeULmFOYzZe1x4T1S7TRNaKnhD9iWAL054epu6D
         Sxh4xNMeXkWazI/aPl/zbfB/f2bi0QUQ5xbWWbvtVrmy97Ux86tM7zibzNzlfJ4tWO
         F6kOM9cIsIlQvd326CmbLrpBQtgFAO1RmvirmXps=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 24F6960C1B;
        Mon,  1 Oct 2018 15:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538407917;
        bh=lSIulFUMZDeHC3jcU5LtyALqdUJhjBTM6HxAnkQAim4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=E5LuBjybNVRD8Cq1m98c84l/qa2WqknIOQO6V1dhEIAeEuPC5TjALtjqXsq/Jaso7
         +kF7wVu616bhOPEA3M6bkLS/GP+VfIMKwAcsnk2Kj/aoXlfvTPfXRluDNwiDzhAzWb
         c8ymxxK+PE9ap/IQQOEdqp4xh9jmpJ88F8hQ2eZg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 24F6960C1B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: Remove unnecessary boolean condition
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180921094828.16976-1-natechancellor@gmail.com>
References: <20180921094828.16976-1-natechancellor@gmail.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181001153202.C727D60C86@smtp.codeaurora.org>
Date:   Mon,  1 Oct 2018 15:32:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Nathan Chancellor <natechancellor@gmail.com> wrote:

> Clang warns that the address of a pointer will always evaluated as true
> in a boolean context.
> 
> drivers/net/wireless/rsi/rsi_91x_mac80211.c:927:50: warning: address of
> array 'key->key' will always evaluate to 'true'
> [-Wpointer-bool-conversion]
>         if (vif->type == NL80211_IFTYPE_STATION && key->key &&
>                                                 ~~ ~~~~~^~~
> 1 warning generated.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/136
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

f613e4803dd6 rsi: Remove unnecessary boolean condition

-- 
https://patchwork.kernel.org/patch/10609513/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

