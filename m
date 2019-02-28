Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A854C4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3994B2184A
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:40:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Z27vSIMa";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ITvVfuoZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731451AbfB1Ike (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 03:40:34 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33342 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfB1Ike (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 03:40:34 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 62C0260EA5; Thu, 28 Feb 2019 08:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551343233;
        bh=XswWS0bkjnsG+xQ/znl1DWm0RIZSrb4ndWFFIo0E3QQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Z27vSIMaf2lQBRJ2fRx81aVtWNJBhS+ZW8PN4ALkJeNsrbX0uY+AOvFuEQphR8c0u
         MPFbAp1HpQySEuC3cj7x3RsK01uJpKLfcMpD3orpdA796+AOZV0V8i4AkuW2m0i1Pq
         8OmTBhHfAsgvSuV4p5ukeeb7Q898H2Hk6OBEL6TY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D775B60A43;
        Thu, 28 Feb 2019 08:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551343231;
        bh=XswWS0bkjnsG+xQ/znl1DWm0RIZSrb4ndWFFIo0E3QQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ITvVfuoZEBHi9u43hsD+9SEFYQBhQ8w5P0rYi7WZE5W6NycVziKDwqIOjuqB0BTuc
         qLdy4lRAxm+ykIH6IHnFve2VTIF4WV2X9NGkH0Q+Pj0R9/NJ136W8wFIxGDQVZcxGB
         JOPFrnzi9Z37zVaaSWaBuh1U0zeeJRIqg/ea5Z5s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D775B60A43
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8723ae: Remove set but not used variable
 'bt_retry_cnt'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190227022334.7750-1-yuehaibing@huawei.com>
References: <20190227022334.7750-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190228084033.62C0260EA5@smtp.codeaurora.org>
Date:   Thu, 28 Feb 2019 08:40:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c: In function '_rtl8723e_dm_bt_coexist_2_ant':
> drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c:1408:5: warning:
>  variable 'bt_retry_cnt' set but not used [-Wunused-but-set-variable]
> 
> It's never used and can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

85c6ac33c87c rtlwifi: rtl8723ae: Remove set but not used variable 'bt_retry_cnt'

-- 
https://patchwork.kernel.org/patch/10831001/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

