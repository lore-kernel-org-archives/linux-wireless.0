Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C358C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 15:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20F9A21019
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 15:31:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="U67W7ShL";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eDPxbjWK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20F9A21019
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbeK3ChW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 21:37:22 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:47682 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728505AbeK3ChW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 21:37:22 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4CBF760B11; Thu, 29 Nov 2018 15:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543505497;
        bh=cL0mUQoICpQAITGArkXbo2GdVMGs+3jONXf0kbVeBCg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=U67W7ShL/m0QPXn5DtMZPkZ87ykV8aC/Mcf7NbRJ7UIIxI4Y5ZV+NBRzLGQXhMPJu
         voMigfemR+X4gEstqSIjsYaXK3UEiHOEB4HijYorDsEHdGvRYmtCqIM84uFcRehtCS
         thmLczf+y2NOTj8seAn+Z1LT+GiceIaRhRIlD1Mg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 29E5360392;
        Thu, 29 Nov 2018 15:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543505496;
        bh=cL0mUQoICpQAITGArkXbo2GdVMGs+3jONXf0kbVeBCg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=eDPxbjWK0CFHILmtIRtDudl3FCdlLM4g6sH/SZ+zbLZOWoxtV4Azm0kOOCw1exG0h
         Z9D6POJdcv6VVz3htPaTES/TfiKSuMmHvCqNIpoqLEoescz8kGwG0T7btOOb8Etg5S
         PlyseTUaN36EgU2RX5Q+dNE3BaMfiNxxEETittxM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 29E5360392
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/4] lib: cordic: Move cordic macros and defines to header
 file
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <f8fe8791a325686cafa8d0b841951e27f68e29d6.1542649316.git-series.plaes@plaes.org>
References: <f8fe8791a325686cafa8d0b841951e27f68e29d6.1542649316.git-series.plaes@plaes.org>
To:     Priit Laes <plaes@plaes.org>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Priit Laes <plaes@plaes.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181129153137.4CBF760B11@smtp.codeaurora.org>
Date:   Thu, 29 Nov 2018 15:31:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Priit Laes <plaes@plaes.org> wrote:

> Now that these macros are in header file, we can eventually
> clean up the duplicate macros present in the drivers that
> utilize the same cordic algorithm implementation.
> 
> Also add CORDIC_ prefix to nonprefixed macros.
> 
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Priit Laes <plaes@plaes.org>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

4 patches applied to wireless-drivers-next.git, thanks.

58d81d64e06f lib: cordic: Move cordic macros and defines to header file
ea3edda9ddba brcmsmac: Use cordic-related macros from common cordic library
8ea3819c0bbe b43: Fix error in cordic routine
d5a433556d09 b43: Use cordic algorithm from kernel library

-- 
https://patchwork.kernel.org/patch/10689235/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

