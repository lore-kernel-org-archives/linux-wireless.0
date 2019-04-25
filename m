Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A39EFC43218
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1593F206BF
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 16:53:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hGfsOJi3";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Wcvt2lpg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbfDYQxD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:53:03 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60812 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbfDYQxD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 12:53:03 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F38B160850; Thu, 25 Apr 2019 16:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211183;
        bh=KKTUsFu+xcrsVod61EIe3FBI1iK+tjD1Ws2PMpK7DpE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hGfsOJi3uwQl52A8uWV8QPGeC7G7vqC/wDeEndwhJS7efZR7tFwFL6HZ9rn1uTL+5
         y+KrZFhbw//f3V+YRKoDgnCrXJlKx2uEA91mmK9dJHckr1O4X90GENGU3qzkJ4SfYo
         T+DQwKJKzoqUGTeuYx+7HieeBWhvnvcvETlmDHRA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9B1926019D;
        Thu, 25 Apr 2019 16:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556211181;
        bh=KKTUsFu+xcrsVod61EIe3FBI1iK+tjD1Ws2PMpK7DpE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Wcvt2lpggEXuG3Jd/mCzDqj+L+fzd1xGElFFcAkjnnjQXlBOpd+o2XnmOJvdTzy8q
         COvUMhh2z0O9RuIn100MdXj8bCnLhh0DZzRmLNVGBa+p3xNK22XzNnNKtuQt5eKRFN
         0M20P2SoN/wtJGiduUUNMyLWoSIyTrtUeWhetSb0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9B1926019D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mwl8k: Fix rate_idx underflow
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1555006410-6090-1-git-send-email-ynezz@true.cz>
References: <1555006410-6090-1-git-send-email-ynezz@true.cz>
To:     =?utf-8?q?Petr_=C5=A0tetiar?= <ynezz@true.cz>
Cc:     linux-wireless@vger.kernel.org,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        =?utf-8?q?Petr_=C5=A0tetiar?= <ynezz@true.cz>,
        <stable@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425165302.F38B160850@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 16:53:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Petr Štetiar wrote:

> It was reported on OpenWrt bug tracking system[1], that several users
> are affected by the endless reboot of their routers if they configure
> 5GHz interface with channel 44 or 48.
> 
> The reboot loop is caused by the following excessive number of WARN_ON
> messages:
> 
>  WARNING: CPU: 0 PID: 0 at backports-4.19.23-1/net/mac80211/rx.c:4516
>                              ieee80211_rx_napi+0x1fc/0xa54 [mac80211]
> 
> as the messages are being correctly emitted by the following guard:
> 
>  case RX_ENC_LEGACY:
>       if (WARN_ON(status->rate_idx >= sband->n_bitrates))
> 
> as the rate_idx is in this case erroneously set to 251 (0xfb). This fix
> simply converts previously used magic number to proper constant and
> guards against substraction which is leading to the currently observed
> underflow.
> 
> 1. https://bugs.openwrt.org/index.php?do=details&task_id=2218
> 
> Fixes: 854783444bab ("mwl8k: properly set receive status rate index on 5 GHz receive")
> Cc: <stable@vger.kernel.org>
> Tested-by: Eubert Bao <bunnier@gmail.com>
> Reported-by: Eubert Bao <bunnier@gmail.com>
> Signed-off-by: Petr Štetiar <ynezz@true.cz>

Patch applied to wireless-drivers-next.git, thanks.

6b583201fa21 mwl8k: Fix rate_idx underflow

-- 
https://patchwork.kernel.org/patch/10896599/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

