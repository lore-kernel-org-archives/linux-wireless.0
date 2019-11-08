Return-Path: <SRS0=s5sB=ZA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F655C5DF60
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Nov 2019 08:54:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E999F214DA
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Nov 2019 08:54:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FIwBAcJ7";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Gkcw6NMq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbfKHIyM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:54:12 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:48354 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbfKHIyM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Nov 2019 03:54:12 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 82BA660D88; Fri,  8 Nov 2019 08:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573203251;
        bh=oSYD5bTk0nZEI+qjwfBwMj09stT85t5HdQnYEDhLbUM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=FIwBAcJ7N1Sb+Xa5ouehdrG/iAlq2MUgQXZM8V/dHVXNfeqWZtr38PhUZJVfJpdtf
         6fyh2y2N7eXl/CPsDi8ufGV6s3tK28DSgAYF4a63AellVrLz22ErbeYmXxXJFFQtN2
         D6Qs9FFEaMwoQqrg80snzTnBiy3Wa9NGu9tz7pTw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D60AF60923;
        Fri,  8 Nov 2019 08:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573203249;
        bh=oSYD5bTk0nZEI+qjwfBwMj09stT85t5HdQnYEDhLbUM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Gkcw6NMqBqENXzsUyhmHaezZtGbb8/tUSbgY/knT31tygrd4Es5eS+dtr41uK9bHP
         bM8ND+PybQ6Pm3rs87FFKFD89rpEJDb4jFp2WszdsOn9xTsi/6ec8SslEvs0fZIL2o
         yUd61s6KyafFFlQUeG/9qiyY2AQRT7KqMtLKr2VA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D60AF60923
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: disable cpuidle during downloading firmware.
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191101054035.42101-1-ikjn@chromium.org>
References: <20191101054035.42101-1-ikjn@chromium.org>
To:     Ikjoon Jang <ikjn@chromium.org>
Cc:     ath10k@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ikjoon Jang <ikjn@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191108085411.82BA660D88@smtp.codeaurora.org>
Date:   Fri,  8 Nov 2019 08:54:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ikjoon Jang <ikjn@chromium.org> wrote:

> Downloading ath10k firmware needs a large number of IOs and
> cpuidle's miss predictions make it worse. In the worst case,
> resume time can be three times longer than the average on sdio.
> 
> This patch disables cpuidle during firmware downloading by
> applying PM_QOS_CPU_DMA_LATENCY in ath10k_download_fw().
> 
> Tested-on: QCA9880
> Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00029
> 
> Signed-off-by: Ikjoon Jang <ikjn@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

3b58d6a599ba ath10k: disable cpuidle during downloading firmware

-- 
https://patchwork.kernel.org/patch/11222331/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

