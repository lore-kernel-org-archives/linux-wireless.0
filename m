Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14AA6ECDE47
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C88C020869
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:23:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hMYMJ2O3";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ctlgWwLH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C88C020869
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbeKEUmc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 15:42:32 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46054 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbeKEUmb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 15:42:31 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AC1F960247; Mon,  5 Nov 2018 11:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541416982;
        bh=LJvPMaTF68qXdRiCiIIYLIQdl/hjdYqeIwx27KUxXOM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hMYMJ2O36ZX8H4uJtB+xggwRgskYx8jouwDPAGbjmRZRIYH1GIx/77rJoLOjHk1hS
         9aaPmeos+fvoo5/i2spBixRykZAHCer1h4q5V1jcSXFFiyschkakmjZQvgOVfXGj8z
         w5Rqyu47ehKCBpSn3lpWNprrYAb/obbRgOFnGv7M=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6953760247;
        Mon,  5 Nov 2018 11:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541416981;
        bh=LJvPMaTF68qXdRiCiIIYLIQdl/hjdYqeIwx27KUxXOM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ctlgWwLHSwFzYFatTLA1P5Ba1ovUaHPslGDs1UMLXqQKn3JQmn/kf+z2s/kSYmkM1
         UOk3AIvKjU7dKh0Ow5majtnotcEXI+wZf47TqJTO0PCpb0jxWILZpqxhPiL7FZMf0x
         +PescQTFjCXAeLRXzCn7lgb/xuTHIlP4NzT6W3s8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6953760247
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 01/20] ath6kl: Mark expected switch fall-through
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <7932c27ae4e53aceacb7a0a1ae26db91432e5014.1540239684.git.gustavo@embeddedor.com>
References: <7932c27ae4e53aceacb7a0a1ae26db91432e5014.1540239684.git.gustavo@embeddedor.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181105112302.AC1F960247@smtp.codeaurora.org>
Date:   Mon,  5 Nov 2018 11:23:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Addresses-Coverity-ID: 201383 ("Missing break in switch")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Acked-by: Steve deRosier <derosier@cal-sierra.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

3 patches applied to ath-next branch of ath.git, thanks.

6d9e1ecd1537 ath6kl: Mark expected switch fall-through
003161445bc8 carl9170: rx: mark expected switch fall-through
f458f9f43690 carl9170: tx: mark expected switch fall-throughs

-- 
https://patchwork.kernel.org/patch/10652473/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

