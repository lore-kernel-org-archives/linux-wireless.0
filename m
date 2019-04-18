Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5595FC10F0E
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 13:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 235EB20674
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 13:08:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dRTzBwW+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IHkM/cQp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388341AbfDRNIv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:08:51 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56254 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727807AbfDRNIu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 09:08:50 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1DFAE60117; Thu, 18 Apr 2019 13:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555592930;
        bh=gLECsLhhmi/RCrChk3fidgQ4C+PjBI8xdCnsnAw1UDc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=dRTzBwW+dU0ydocgH5iGc3HJwa9aapkE0R8zFnotq52JBTRa14u0CqJbf1aLdNWnV
         RpesoLkGczfltRz6hSrR8d9S2nm9lAn9n84xymiUy1MUjAb9yHC6w19Bsf7K0HXSSk
         TVGdkyWxl5jj7H+3NTAc5NuI2r9obmWOzoBMHJx4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 546FF60117;
        Thu, 18 Apr 2019 13:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555592929;
        bh=gLECsLhhmi/RCrChk3fidgQ4C+PjBI8xdCnsnAw1UDc=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=IHkM/cQpSKACMGAmbWxGvOHkfuPO37UzMRh+wzQMj6LslYPApfBMGA1b1o01lvv2a
         82d0W91rQSdchwW1KCE4W9GcSAgAVQLUt1eNYfcqBKXFniOjJZD8uoo1q4pFncRPr8
         9OIF7gZvgqKAU7DySa6m/NJXNz3jPkK02L5qyexc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 546FF60117
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8188ee: Remove extraneous file
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190417003547.26271-1-Larry.Finger@lwfinger.net>
References: <20190417003547.26271-1-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Andrew Morton <akpm@linux-foundation.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190418130850.1DFAE60117@smtp.codeaurora.org>
Date:   Thu, 18 Apr 2019 13:08:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Somehow file drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej was
> incorporated into the sources. Obviously, it can be removed.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Patch applied to wireless-drivers-next.git, thanks.

b5250c9c14c1 rtlwifi: rtl8188ee: Remove extraneous file

-- 
https://patchwork.kernel.org/patch/10904279/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

