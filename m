Return-Path: <SRS0=FCSK=W6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB0AC3A5A2
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 639D723402
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 13:31:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ovbRAxIB";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="O6uzXl9n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfICNbi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 09:31:38 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45756 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728094AbfICNbh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 09:31:37 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 609F06085C; Tue,  3 Sep 2019 13:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517496;
        bh=by5fl6zo+ZrhsJJMhajMU5tEQKjknqS9fCgsp2dtaCA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ovbRAxIBbJ2Vj+CLXWMHA+tyfd1gFPBcUpe5lRBcxHIjS/ZjDsnI3jbZwuMZCoqQm
         Nr8+KUh4IdB69k6X3mW/yf3iOIPs6xVwcudQ9TQFuKmKKC/LEKU4VfIEaNcsu5nqLc
         SHhZ7HJV5z0Q0QTfRPzhd2kJ6qMJWmwJJ9xwUjJw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CF316605A2;
        Tue,  3 Sep 2019 13:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517495;
        bh=by5fl6zo+ZrhsJJMhajMU5tEQKjknqS9fCgsp2dtaCA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=O6uzXl9nbTPAY0CUOjQBN0p9+EPb7CbZink7EY9jjZm8eRycVLKIrpjhsC4SbWl8E
         NxBC9x9ECOg5tKIIkvXf+F0GBacB9/nqGFymjOkOKFrPUxSbzYs7g/kixel4GFUx7q
         14XKFPcU7bPbGqSQtM0TmE8Cx9UCiqPnYTBZEz0Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CF316605A2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/5] rtlwifi: rtl8192ee: Remove unused GET_XXX and SET_XXX
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190831180644.7937-2-Larry.Finger@lwfinger.net>
References: <20190831180644.7937-2-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903133136.609F06085C@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 13:31:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> As the first step in converting from macros that get/set information
> in the RX and TX descriptors, unused macros are being removed.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

5 patches applied to wireless-drivers-next.git, thanks.

8ef113ff0fed rtlwifi: rtl8192ee: Remove unused GET_XXX and SET_XXX
11f92ca1475c rtlwifi: rtl8192ee: Replace local bit manipulation macros
7f1c7460e932 rtlwifi: rtl8192ee: Convert macros that set descriptor
200e8bd4df8f rtlwifi: rtl8192ee: Convert inline routines to little-endian words
9dc35d8a555b rtlwifi: rtl8192ee: Remove some variable initializations

-- 
https://patchwork.kernel.org/patch/11124953/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

