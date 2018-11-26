Return-Path: <SRS0=hJv2=OF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69960C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 05:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2713D20663
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 05:52:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="k5+jrNwZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jSGHK9k+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2713D20663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbeKZQpE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 26 Nov 2018 11:45:04 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35124 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbeKZQpE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Nov 2018 11:45:04 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8D4C96086B; Mon, 26 Nov 2018 05:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543211524;
        bh=onqZfehxsVfiQszx+oFSaMUdFoLQknb7stjIZRIy6FE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=k5+jrNwZpBj4DeD6NjSrzwXJhI4mgoIMB8JRKT+1UDz/Lk6AlHkTudlKlkKke5h5w
         C3zhIAFHilTbibO7QW+dy54UVZSts8orccH0xECDyOkUB7Jiomq4nOz4NF9ptiAD+/
         og+aijfxvDHK1TRwTctYg9ZOvGf/uGne67xXGAQI=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3335B602BD;
        Mon, 26 Nov 2018 05:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543211523;
        bh=onqZfehxsVfiQszx+oFSaMUdFoLQknb7stjIZRIy6FE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jSGHK9k+9ZLIWG5jop13DzrXIE7tbY9O+4g5v/WDzWOsZLiWZ0+vQDQUNHKgL6eat
         Ybci14NsVZ1iaM/ghmykGKrCRMU6dUYvixN4imN0CbIPM/J1XU2LJepMjBZbhJ1zR0
         KtoeYMGFKuvoC6fYJ52vZpYiL//XN9ec61CbZiVc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3335B602BD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     marcel@holtmann.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ell:: build: bump SO version of libell
References: <20181124131258.15978-1-jengelh@inai.de>
Date:   Mon, 26 Nov 2018 07:52:00 +0200
In-Reply-To: <20181124131258.15978-1-jengelh@inai.de> (Jan Engelhardt's
        message of "Sat, 24 Nov 2018 14:12:58 +0100")
Message-ID: <87a7lw9yin.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Jan Engelhardt <jengelh@inai.de> writes:

> Commit 0.13-7-g4a386a1 changed the ABI of l_signal_create. This
> warrants a bump in the SO version.
> ---
>  Makefile.am | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Makefile.am b/Makefile.am
> index d115360..5a44f40 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -8,8 +8,8 @@ ACLOCAL_AMFLAGS = -I build-aux
>  # Interfaces added:		CURRENT++ REVISION=0 AGE++
>  # Interfaces removed:		CURRENT++ REVISION=0 AGE=0
>  
> -ELL_CURRENT = 0
> -ELL_REVISION = 2
> +ELL_CURRENT = 1
> +ELL_REVISION = 0
>  ELL_AGE = 0
>  
>  pkginclude_HEADERS = ell/ell.h \

For what project is this? I can't figure out why this was sent to
linux-wireless, maybe by mistake?

-- 
Kalle Valo
