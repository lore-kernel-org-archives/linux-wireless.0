Return-Path: <SRS0=I2fZ=XI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D80A7C49ED7
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Sep 2019 14:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB5C620830
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Sep 2019 14:56:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="H69GWt9A";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RLGtNaks"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390150AbfIMO42 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Sep 2019 10:56:28 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37384 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388211AbfIMO42 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Sep 2019 10:56:28 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A7164602F8; Fri, 13 Sep 2019 14:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568386587;
        bh=WcxNB9eKsGTazqIzGaWkSahlrtNCFR6nD/s98Cco6K4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=H69GWt9A5ymqILxt7Z7nDO0C/RNRRG/yp4F9IEYgI3ahjqsTnr1ieAn1lEOdYBRtB
         LRDelBY8uXetbTr9cIiOgXFhr/RNds8nFtnQV9TBBpq8Svbhh0LjeVjJ4cWVnJJvbm
         LMEmd/QNvTyL3aVFmDsYdGVEvcPJ5kXsnOZ7nkV4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0D2F6602F8;
        Fri, 13 Sep 2019 14:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568386587;
        bh=WcxNB9eKsGTazqIzGaWkSahlrtNCFR6nD/s98Cco6K4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=RLGtNaks1v5PRZU84mgpARyQannc9Q8aJ9MZnpvRZbGYqZIkEH86KGu8QbFyJO/7M
         9+JvIe2Qr8sb/zaEoMBw3sULPL8BOeyrjBcEBEEzWR9HcU9BuEt5qduD1i5CS7WWDw
         0sj3xlF6WZoGYjrYdvcQ/06jOrc2l75cBpxxO4oQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0D2F6602F8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/9] rtlwifi: rtl8723ae: Remove unused GET_XXX and
 SET_XXX macros
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190909015958.29834-2-Larry.Finger@lwfinger.net>
References: <20190909015958.29834-2-Larry.Finger@lwfinger.net>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190913145627.A7164602F8@smtp.codeaurora.org>
Date:   Fri, 13 Sep 2019 14:56:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> As the first step in converting from macros that get/set information
> in the RX and TX descriptors, unused macros are being removed.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

9 patches applied to wireless-drivers-next.git, thanks.

eb4b2d33c167 rtlwifi: rtl8723ae: Remove unused GET_XXX and SET_XXX macros
05e2a0cb8ce3 rtlwifi: rtl8723ae: Replace local bit manipulation macros
a9db071f7816 rtlwifi: rtl8723ae: Convert macros that set descriptor
773755d9112b rtlwifi: rtl8723ae: Convert inline routines to little-endian words
64578a3d3426 rtlwifi: rtl8723be: Remove unused SET_XXX and GET_XXX macros
360226fdc53d rtlwifi: rtl8723be: Replace local bit manipulation macros
d7b259fe6971 rtlwifi: rtl8723be: Convert macros that set descriptor
fca13fd03da7 rtlwifi: rtl8723be: Convert inline routines to little-endian words
e6e5ec3042fe rtlwifi: rtl8188ee: rtl8192ce: rtl8192de: rtl8723ae: rtl8821ae: Remove some unused bit manipulation macros

-- 
https://patchwork.kernel.org/patch/11137143/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

