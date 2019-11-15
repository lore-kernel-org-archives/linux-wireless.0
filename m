Return-Path: <SRS0=1RAM=ZH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB3F5C43141
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Nov 2019 06:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C53982073B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Nov 2019 06:58:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ESv8dWjJ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Z6QD/iJn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfKOG6Q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Nov 2019 01:58:16 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56542 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbfKOG6Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Nov 2019 01:58:16 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6911360878; Fri, 15 Nov 2019 06:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573801095;
        bh=vqnkhyApQKljmrQxtB/6xAndiTpIeYqwAP22gMmqcfo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ESv8dWjJ3yqb6d6+HfCtIcAgF0zUYzc6JeeALeMMdIRtgxRrQz7rwakd17WCFav2X
         TKWpRk0Zc0nIBFAiWBqv8Di+dTaIo7ht9XvX2c4ngH0K6ZSTKOLFVf4kVYXSPtTD3j
         MAQEl6osGuNbEz4mKx374T12PvtkVQe+n7hnL4gw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AC81360878;
        Fri, 15 Nov 2019 06:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573801094;
        bh=vqnkhyApQKljmrQxtB/6xAndiTpIeYqwAP22gMmqcfo=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Z6QD/iJnIY4ohKtssBn/+6TMIh0fL4hA758SMPuglesU3UfVd+4QgZkeShvoo1KDO
         7ykFKiSRLQIpvTwFaQSj8dOKzw9Ek0/Cco2bjKyY4Q2sWrCQ6SNZ2q7P1kFQ9cTDCk
         nHHudZTK/bFpfY5nBjEmfQHts0UR3H9j+Q7J2Hho=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AC81360878
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Revert "ath10k: add cleanup in ath10k_sta_state()"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191113202644.3673049-1-bjorn.andersson@linaro.org>
References: <20191113202644.3673049-1-bjorn.andersson@linaro.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, jeffrey.l.hugo@gmail.com,
        wenwen@cs.uga.edu
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191115065815.6911360878@smtp.codeaurora.org>
Date:   Fri, 15 Nov 2019 06:58:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Bjorn Andersson <bjorn.andersson@linaro.org> wrote:

> This reverts commit 334f5b61a6f29834e881923b98d1e27e5ce9620d.
> 
> This caused ath10k_snoc on Qualcomm MSM8998, SDM845 and QCS404 platforms to
> trigger an assert in the firmware:
> 
> err_qdi.c:456:EF:wlan_process:1:cmnos_thread.c:3900:Asserted in wlan_vdev.c:_wlan_vdev_up:3219
> 
> Revert the offending commit for now.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

f4fe2e53349f ath10k: Revert "ath10k: add cleanup in ath10k_sta_state()"

-- 
https://patchwork.kernel.org/patch/11242743/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

