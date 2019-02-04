Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C687C282CB
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 15:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1A262082E
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 15:53:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SUARJQFe";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="R2VuVrj5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbfBDPxV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 10:53:21 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51958 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbfBDPxV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 10:53:21 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 39CD9606AC; Mon,  4 Feb 2019 15:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549295600;
        bh=SMPwLPzBtfYya59sFklUvIO1WLFavlWHcNWsVcOMSmQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=SUARJQFedsd1ckPgvGNOam/3AsQNRYLa1d2HEWr6I5X2tjzoHv07EM8Cfs5BK0I+H
         /J9jyHYUCIkHNIhF4tkEGaxkIIVtFB8LZ1DLZzZFLD+w4XLYzkDgCb0of1fv9QyVfs
         7jk/VmZcyWS/BaZuEvw5aGEdknzBoecUlr3WGo5I=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 46A9B6047C;
        Mon,  4 Feb 2019 15:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549295599;
        bh=SMPwLPzBtfYya59sFklUvIO1WLFavlWHcNWsVcOMSmQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=R2VuVrj5CvcFQnOfX3g4jr2uJueJClQ/m7iOxr+W+57OBaVjlwHT7coJRgxmy/zvg
         jtvoRaL6AcNbA2D2sAg4CPdRStdp/BtAlujwmHYX6KBjWYgmL2cCaXXwNV1EFAFcXQ
         pYgmDzPUHnjUtrBDu4YQx2TP+e0/3QO7oxmN8S/U=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 46A9B6047C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k/eeprom: Use scnprintf instead of snprintf
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190116000223.GA29196@beast>
References: <20190116000223.GA29196@beast>
To:     Kees Cook <keescook@chromium.org>
Cc:     Willy Tarreau <w@1wt.eu>, Silvio Cesare <silvio.cesare@gmail.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190204155320.39CD9606AC@smtp.codeaurora.org>
Date:   Mon,  4 Feb 2019 15:53:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> Change snprintf to scnprintf. There are generally two cases where using
> snprintf causes problems.
> 
> 1) Uses of size += snprintf(buf, SIZE - size, fmt, ...)  In this case,
> if snprintf would have written more characters than what the buffer
> size (SIZE) is, then size will end up larger than SIZE. In later uses
> of snprintf, SIZE - size will result in a negative number, leading to
> problems. Note that size might already be too large by using size =
> snprintf before the code reaches a case of size += snprintf.
> 
> 2) If size is ultimately used as a length parameter for a copy back to
> user space, then it will potentially allow for a buffer overflow and
> information disclosure when size is greater than SIZE. When the size is
> used to index the buffer directly, we can have memory corruption. This
> also means when size = snprintf... is used, it may also cause problems
> since size may become large. Copying to userspace is mitigated by the
> HARDENED_USERCOPY kernel configuration.
> 
> The solution to these issues is to use scnprintf which returns the number
> of characters actually written to the buffer, so the size variable will
> never exceed SIZE.
> 
> Cc: Willy Tarreau <w@1wt.eu>
> Cc: Silvio Cesare <silvio.cesare@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

4b6e9f3fe1d8 ath9k: eeprom: Use scnprintf instead of snprintf

-- 
https://patchwork.kernel.org/patch/10765259/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

