Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9F4C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:59:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37BB42081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:59:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OQKnxF2M";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WgcvXNFC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37BB42081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389418AbeKGCZI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:25:08 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57444 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389285AbeKGCZI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:25:08 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8EEBA601DA; Tue,  6 Nov 2018 16:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523541;
        bh=3qxRrWbsTr0ipwqwGuO7qLBYgUYpNTuY592JMIFuF04=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=OQKnxF2Mn+5BEJAycKKg5pK7FeI2OQTFukclf9oCX8IiEntIhv/QwPFTV2giuFvj7
         7edCCHY8X64AT880i8YeiHy1Xroo7sXJ2DZ809tRQz3k/nn4tsNqqvj87Q+dKFGx1Q
         rTm+gBnzzYVQgogrfQAFrI0adnTLrZeBBlTuGFcI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7F53F601D7;
        Tue,  6 Nov 2018 16:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541523541;
        bh=3qxRrWbsTr0ipwqwGuO7qLBYgUYpNTuY592JMIFuF04=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=WgcvXNFCrFiLsVEaduvFNSFnl0WMjyz/+5DuhjE69iRBE2dxbJGncLXSRSB3/55nK
         3cVRz4EwGQLFI+siuNdoWsz1mV4LxjS3lBJgjazk5DtGRMKFQd61QraFGLTpu+GXa6
         rSpKGXDBvGnHC5MlY9Hg1cF85mQOMFiG/FGE4+Y8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7F53F601D7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] rtl8xxxu: Mark expected switch fall-throughs
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <08817d137b32d5d091eacc6fee0a3eca68d49d94.1540208577.git.gustavo@embeddedor.com>
References: <08817d137b32d5d091eacc6fee0a3eca68d49d94.1540208577.git.gustavo@embeddedor.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     linux-kernel@vger.kernel.org,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106165901.8EEBA601DA@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 16:59:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Addresses-Coverity-ID: 1357355 ("Missing break in switch")
> Addresses-Coverity-ID: 1357378 ("Missing break in switch")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

2 patches applied to wireless-drivers-next.git, thanks.

e20c50cdca19 rtl8xxxu: Mark expected switch fall-throughs
307b00c5e695 rtl8xxxu: Fix missing break in switch

-- 
https://patchwork.kernel.org/patch/10651953/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

