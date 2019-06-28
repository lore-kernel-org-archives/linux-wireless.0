Return-Path: <SRS0=Fjak=U3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D1BC4321A
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Jun 2019 19:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 564AA206A2
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Jun 2019 19:14:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ccJdc5hE";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PuuaiXC0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfF1TOm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Jun 2019 15:14:42 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39942 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfF1TOm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jun 2019 15:14:42 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7A30460767; Fri, 28 Jun 2019 19:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561749281;
        bh=p0/lF8gZG07owNuUq+c9UbyIWgsYbZiHIKEkkannqs0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ccJdc5hEDFUDSvV8vx4/OOS4VAYiMCcry4H8Y6NyqjO7CPq0p5fOXY58kWoxotbF4
         XO4ZRy+rw74KJSbb0cb8YaC2hhgW8gaB1BQg+D2hpwbIHAASNJKnAfCkgTdEgsaC15
         oIB8ODQzh14Q5ayxKRW+MGpBOkbXgjwbSz9+Cqbc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3B664608BA;
        Fri, 28 Jun 2019 19:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561749281;
        bh=p0/lF8gZG07owNuUq+c9UbyIWgsYbZiHIKEkkannqs0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=PuuaiXC0SVvkJbCzMywmDVUW9A1DL5jfIMWAV5eTb3Ovgt1FakNAooyaz4GjZdYAY
         FxegwTwQ4u5xAtHPQ+Igochw7As0PJJRVW5wduGlQSCOY+AcsaaE5us9B+ufyhB9jB
         f9edaBWR7ha4bypH2kWagyWZPQ4g4oJ6aNwXwa5w=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3B664608BA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] ath10k: remove unnecessary 'out of memory' message
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1561661250-30528-1-git-send-email-kvalo@codeaurora.org>
References: <1561661250-30528-1-git-send-email-kvalo@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190628191441.7A30460767@smtp.codeaurora.org>
Date:   Fri, 28 Jun 2019 19:14:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> wrote:

> Fixes checkpatch warning:
> 
> drivers/net/wireless/ath/ath10k/swap.c:110: Possible unnecessary 'out of memory' message
> 
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

2189135437d0 ath10k: remove unnecessary 'out of memory' message
d44c732cffe5 ath10k: pci: remove unnecessary casts

-- 
https://patchwork.kernel.org/patch/11020277/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

