Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55858C10F00
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23642218B0
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:41:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NLI3TuNz";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iODsBp1x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731383AbfB1Ik7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 03:40:59 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33644 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfB1Ik7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 03:40:59 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0B1AF60CF0; Thu, 28 Feb 2019 08:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551343258;
        bh=FO0Q8S7TMHf/tsPhoiPTlaFhQd62+yAcKbZmHZOQOnA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=NLI3TuNzPwPL8lB1IkEwjg+sZKAfibFPte3p4rliB4lHKAT986wjhn4sijkjSaAhF
         bFbvKySFoln4wkf2ACH5hBhxUQqEgTQTSeGFaBZ6gQ+9sFt4S74Su9CVYagzrUakuv
         S9qOMCdl3VGj+F+8YvMChiDQ9kAqIRm4W2xWUAXM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6475D60DAA;
        Thu, 28 Feb 2019 08:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551343257;
        bh=FO0Q8S7TMHf/tsPhoiPTlaFhQd62+yAcKbZmHZOQOnA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=iODsBp1x9a95uqKKesKWu2QX6wlwDe+G6UhYyaoMFbuxYWI184HjlZqBEScsvGu6q
         MYtQ43eNOV+Wz+fs6zU3m2VZRHMEHl3+wKvUQI9clfYia1aIgWd0ud7DQWt5UCh3hb
         5v/T8V6B84KJFTrdF345PpDfpPNVgiOgEPHBz5IU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6475D60DAA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8192se: Remove set but not used variable
 'seg_ptr'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190227022347.7927-1-yuehaibing@huawei.com>
References: <20190227022347.7927-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190228084058.0B1AF60CF0@smtp.codeaurora.org>
Date:   Thu, 28 Feb 2019 08:40:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c: In function '_rtl92s_firmware_downloadcode':
> drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c:139:17: warning:
>  variable 'seg_ptr' set but not used [-Wunused-but-set-variable]
> 
> It's not used after commit 59ae1d127ac0 ("networking: introduce and use
> skb_put_data()")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

037e0c5df649 rtlwifi: rtl8192se: Remove set but not used variable 'seg_ptr'

-- 
https://patchwork.kernel.org/patch/10831003/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

