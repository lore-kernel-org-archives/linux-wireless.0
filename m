Return-Path: <SRS0=Z1rL=YC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73369C47404
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Oct 2019 12:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 415A121835
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Oct 2019 12:58:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="N60HIJME";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="N60HIJME"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731138AbfJIM6I (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Oct 2019 08:58:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57470 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730765AbfJIM6I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Oct 2019 08:58:08 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E715160AA8; Wed,  9 Oct 2019 12:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570625886;
        bh=Ey3JcADzZq0JNAquPvYQB5wL7Yp4FKioADNOOeAivCk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=N60HIJMEuGZWALQrRHiB1H5B4nw14VAadR00WEljjgHMmhw7qShXBWSzTKFB8jTDY
         gyX2BV5nV3uwEjrTKAFYKCoPe2977qUK1LhOhrCyKI0sZgQ6wNT5d6vjwLsGcD28+N
         ChrbB++alstlU/8G0lcjRMfQOlvfWoeVjm0Amyhs=
Received: from x230.qca.qualcomm.com (85-76-42-199-nat.elisa-mobile.fi [85.76.42.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EF8CA601E7;
        Wed,  9 Oct 2019 12:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570625886;
        bh=Ey3JcADzZq0JNAquPvYQB5wL7Yp4FKioADNOOeAivCk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=N60HIJMEuGZWALQrRHiB1H5B4nw14VAadR00WEljjgHMmhw7qShXBWSzTKFB8jTDY
         gyX2BV5nV3uwEjrTKAFYKCoPe2977qUK1LhOhrCyKI0sZgQ6wNT5d6vjwLsGcD28+N
         ChrbB++alstlU/8G0lcjRMfQOlvfWoeVjm0Amyhs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EF8CA601E7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH RESEND] rtlwifi: rtl8192ee: Remove set but not used variable 'err'
References: <1570612107-13286-1-git-send-email-zhengbin13@huawei.com>
Date:   Wed, 09 Oct 2019 15:58:01 +0300
In-Reply-To: <1570612107-13286-1-git-send-email-zhengbin13@huawei.com>
        (zhengbin's message of "Wed, 9 Oct 2019 17:08:27 +0800")
Message-ID: <8736g2rs86.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

zhengbin <zhengbin13@huawei.com> writes:

> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c: In function rtl92ee_download_fw:
> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c:111:6: warning: variable err set but not used [-Wunused-but-set-variable]
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

There's no changelog, why did you resend? Document clearly the changes
so that maintainers don't need to guess what has changed:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing

-- 
Kalle Valo
