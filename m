Return-Path: <SRS0=+qZr=YS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C91CA9EA0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Oct 2019 07:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9817D20867
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Oct 2019 07:39:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ojn1qcFD";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NBvnw95M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407220AbfJYHjD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Oct 2019 03:39:03 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48986 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406055AbfJYHjD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Oct 2019 03:39:03 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BE27360FA8; Fri, 25 Oct 2019 07:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571989142;
        bh=sJYrULRu+ClTuIbmxHelyJEkUfWqlypN16ZQnx14C/Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Ojn1qcFDeRPxgqDo258jzzYxGYvfp5sZCCMXtUebe6AJYFh3L30ONDpJEPQlpn+ZS
         eCx3n9smsgByvqQN+cMH1HCZP1r7i3UJj9kKMokfq40wZfbXnMM0KYX9h5nWh1UtsV
         N2aFxGd40UCqm5eRYX2d+fMyYC33WbLuANRT+2hA=
Received: from potku.adurom.net (unknown [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1A5ED60FB8;
        Fri, 25 Oct 2019 07:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571989142;
        bh=sJYrULRu+ClTuIbmxHelyJEkUfWqlypN16ZQnx14C/Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=NBvnw95M8wp6y9vK7rJXrdWH3Af1CxI1IP9wuWLf1DSHRTjwUm3kpS5zh+n47CD0B
         FMawynwXBQrjPr492nA5E/eFg20yp2N+QO7ZbjTYobZEdfxjkS0pmr4cqutr4bYQ0d
         55Aih15KeTOS0dXtUmZRBr5la2uDl0vx+f2U9gCs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1A5ED60FB8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw88: fix GENMASK_ULL for u64
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191024091948.10569-1-yhchuang@realtek.com>
References: <20191024091948.10569-1-yhchuang@realtek.com>
To:     <yhchuang@realtek.com>
Cc:     <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191025073902.BE27360FA8@smtp.codeaurora.org>
Date:   Fri, 25 Oct 2019 07:39:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<yhchuang@realtek.com> wrote:

> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> This fixes compile warning:
> 
>     In file included from include/linux/bitops.h:5:0,
>                      from include/linux/kernel.h:12,
>                      from include/asm-generic/bug.h:19,
>                      from arch/mips/include/asm/bug.h:42,
>                      from include/linux/bug.h:5,
>                      from include/net/mac80211.h:16,
>                      from drivers/net/wireless/realtek/rtw88/main.h:8,
>                      from drivers/net/wireless/realtek/rtw88/main.c:5:
>     drivers/net/wireless/realtek/rtw88/main.c: In function 'rtw_update_rate_mask':
>       include/linux/bits.h:23:11: warning: right shift count is negative
>       [-Wshift-count-negative]
>        (~UL(0) >> (BITS_PER_LONG - 1 - (h))))
>                ^
>     drivers/net/wireless/realtek/rtw88/main.c:622:17: note: in expansion of macro 'GENMASK'
>       u64 cfg_mask = GENMASK(63, 0);
>                      ^~~~~~~
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Fixes: f39e9bd49a3d ("rtw88: add set_bitrate_mask support")
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Reported-by: kbuild test robot <lkp@intel.com>

Patch applied to wireless-drivers-next.git, thanks.

5c70e9714254 rtw88: fix GENMASK_ULL for u64

-- 
https://patchwork.kernel.org/patch/11208607/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

