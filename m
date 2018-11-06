Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4AB5C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C8992081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:05:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iuDu4ycM";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZobPlA9c"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C8992081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389663AbeKGCbZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:31:25 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33516 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389607AbeKGCbZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:31:25 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 598066038E; Tue,  6 Nov 2018 17:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523916;
        bh=RQw9X9L7FngH6BdDJrjVfpvOo8jNs7Ohz3LVUBOyTVo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=iuDu4ycM0i2YIzHayW5QPgjasSJsDXKDN5xoKJKoImQJ2ztDgdAKFLuxBb0xPVpzv
         R4stKXhvFwRvQYdMVsmOhU75NLuaOVSCggKUnocuxFuOwgeYCu05yVM63EUzAGj/9c
         8Dzg41VaJHEzrTZpJjUnaCcd0291K9dYYZzpmtT8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D2743601DA;
        Tue,  6 Nov 2018 17:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523915;
        bh=RQw9X9L7FngH6BdDJrjVfpvOo8jNs7Ohz3LVUBOyTVo=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ZobPlA9cZl/FpdEuArDIDSlODWi9UjgJN7yM+eBbe7mfvqZZJiZBFEcPUr5s4j7Fx
         fl+in/uurgVdXmKexPBVuIWRfdzrBjtdbKEZg0zD5oYa/cPqPmfl6q4JRGM0iXm07d
         Cc4yzR0WUndbAspjUdpDnQVb7dFH0XwhVcGvJIEk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D2743601DA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8192de: Fix misleading REG_MCUFWDL information
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1541417130-9898-1-git-send-email-zhangshaokun@hisilicon.com>
References: <1541417130-9898-1-git-send-email-zhangshaokun@hisilicon.com>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     <linux-wireless@vger.kernel.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Ping-Ke Shih <pkshih@realtek.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106170516.598066038E@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 17:05:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Shaokun Zhang <zhangshaokun@hisilicon.com> wrote:

> RT_TRACE shows REG_MCUFWDL value as a decimal value with a '0x'
> prefix, which is somewhat misleading.
> 
> Fix it to print hexadecimal, as was intended.
> 
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

7d129adff3af rtlwifi: rtl8192de: Fix misleading REG_MCUFWDL information

-- 
https://patchwork.kernel.org/patch/10667863/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

