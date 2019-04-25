Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C56A5C4321A
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D49220679
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:56:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RXYo+p/N";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QZ6RkZhX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbfDYQ4I (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:56:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33528 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfDYQ4I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:56:08 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A01826058E; Thu, 25 Apr 2019 16:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211367;
        bh=9eRvulVlbXBMxvEM3hAkuZAFM7cLKLUpXX0LT4/fs40=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=RXYo+p/NUTrx3R1Ki7MmkUpNk+H/mSL0nxr7EFgm6OwRQbKVNmqkmyOvMhd4rYc8X
         cdBCXo1gnXo+3pa0/yWEOsYiQiljYlUghuTdXfZaBBw5AgS+PrwoCqs9RIDy18rL7c
         9OKo7ndguDSwZGaQvo/f4pa9brd3YAx+5Xl8LHNw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 27DB960252;
        Thu, 25 Apr 2019 16:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211367;
        bh=9eRvulVlbXBMxvEM3hAkuZAFM7cLKLUpXX0LT4/fs40=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=QZ6RkZhXHMkoDJKqL79MfPto+ZvJiSOA+C6dhtT+Lz/rct5fFtV1pVycx2O9M2uuM
         QkLLk3joC1ioMP3Y0zx3I8P8VbL0mH5UNw6wXeqeybsJ8G/RKK38Y0fRuc244pep6N
         okiQ2vfXMQdgCxr0yaYWMoZorzsgjdoOKVBEWOyA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 27DB960252
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 wireless-drivers-next] rtlwifi: rtl8723ae: Fix missing
 break in switch statement
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190416151722.GA31598@embeddedor>
References: <20190416151722.GA31598@embeddedor>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425165607.A01826058E@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:56:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> Add missing break statement in order to prevent the code from falling
> through to case 0x1025, and erroneously setting rtlhal->oem_id to
> RT_CID_819X_ACER when rtlefuse->eeprom_svid is equal to 0x10EC and
> none of the cases in switch (rtlefuse->eeprom_smid) match.
> 
> This bug was found thanks to the ongoing efforts to enable
> -Wimplicit-fallthrough.
> 
> Fixes: 238ad2ddf34b ("rtlwifi: rtl8723ae: Clean up the hardware info routine")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied to wireless-drivers-next.git, thanks.

84242b82d81c rtlwifi: rtl8723ae: Fix missing break in switch statement

-- 
https://patchwork.kernel.org/patch/10903325/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

