Return-Path: <SRS0=+qZr=YS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0B2CA9EA0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Oct 2019 07:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B224920867
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Oct 2019 07:41:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Mng/FsLF";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SljavbjB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407292AbfJYHlF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Oct 2019 03:41:05 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50052 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406055AbfJYHlF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Oct 2019 03:41:05 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 173E860FB4; Fri, 25 Oct 2019 07:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571989265;
        bh=VkDNXTxi5tmSfmj+pzf7jwxgrFJaxKhc7+lAfV16+fM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Mng/FsLFz9CT3k7fpoiY7S8xkzSebmRUUxwNUOEFb8EmtneEtafUBeuOjM5eYnbkf
         dI+dLmKTCePQqjvm8JHtH0tqQlOWu+DqOG4ohigQa8Pa0qIbJl0LPT6oeySgaBRSDR
         FDWXiIlBS/HJYYcFPku/XJRmcE19eYTCLB0AcLk0=
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9DBAF60B69;
        Fri, 25 Oct 2019 07:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571989264;
        bh=VkDNXTxi5tmSfmj+pzf7jwxgrFJaxKhc7+lAfV16+fM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SljavbjBZ5fltcrKksNCf/5Aavbmbc+QRRpe+TI7du0AaDMJSvVOmrP8GY8NwECuV
         nIyoZoNsDU6oCTzMaNThp+pNV4OMZ+6QqjciEbeYyH8tNUumVR8KEaUBTwmALohznK
         MbvjxMwXjRekBWgzYGZrHXuLByu9xnvHIaxsnRTw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9DBAF60B69
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     <yhchuang@realtek.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rtw88: fix GENMASK_ULL for u64
References: <20191024091948.10569-1-yhchuang@realtek.com>
        <87ftjie9t3.fsf@tynnyri.adurom.net>
Date:   Fri, 25 Oct 2019 10:41:00 +0300
In-Reply-To: <87ftjie9t3.fsf@tynnyri.adurom.net> (Kalle Valo's message of
        "Thu, 24 Oct 2019 13:07:20 +0300")
Message-ID: <877e4te0hf.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> <yhchuang@realtek.com> writes:
>
>> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>>
>> This fixes compile warning:
>>
>>     In file included from include/linux/bitops.h:5:0,
>>                      from include/linux/kernel.h:12,
>>                      from include/asm-generic/bug.h:19,
>>                      from arch/mips/include/asm/bug.h:42,
>>                      from include/linux/bug.h:5,
>>                      from include/net/mac80211.h:16,
>>                      from drivers/net/wireless/realtek/rtw88/main.h:8,
>>                      from drivers/net/wireless/realtek/rtw88/main.c:5:
>>     drivers/net/wireless/realtek/rtw88/main.c: In function 'rtw_update_rate_mask':
>>       include/linux/bits.h:23:11: warning: right shift count is negative
>>       [-Wshift-count-negative]
>>        (~UL(0) >> (BITS_PER_LONG - 1 - (h))))
>>                ^
>>     drivers/net/wireless/realtek/rtw88/main.c:622:17: note: in expansion of macro 'GENMASK'
>>       u64 cfg_mask = GENMASK(63, 0);
>>                      ^~~~~~~
>>
>> Fixes: f39e9bd49a3d ("rtw88: add set_bitrate_mask support")
>> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
>
> I'll add:
>
> Reported-by: kbuild test robot <lkp@intel.com>

Oh nice, patchwork automatically added the tag from my email above and I
didn't have to do anything :)

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
