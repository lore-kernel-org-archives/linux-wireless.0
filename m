Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E617C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DE7C21736
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:10:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Vmb/rFJs";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OI98hxh4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbfBSPKU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:10:20 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38280 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbfBSPKU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:10:20 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C0D366071A; Tue, 19 Feb 2019 15:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589019;
        bh=iqYquW/jRXJaGP3vvyXdhWzilNINTnMOTiRZn/jZIE8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Vmb/rFJsLHcGDWbRTR7gJg6FCLfdTjrBMO0AvRwWJb6MCBF+sF2aG76HQPdlzdepX
         TpqletICEs+SoAeaO4Y4YlQnZcYlS0D434GrSPPWcpUfZUPflkARtA6XNSfrRhXmaj
         NnMwyHBt5yI+PHRC3FQwemsOT6Sh2Xrrqjfkq2Rg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BEFB460791;
        Tue, 19 Feb 2019 15:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550589018;
        bh=iqYquW/jRXJaGP3vvyXdhWzilNINTnMOTiRZn/jZIE8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=OI98hxh4nrrqD8wL0g+x2rnEAxswA2Eo6rX9CiAaiGwMdPs4GpJJWIfhWgTQC/dep
         7FBwk7FhmlACISQbv2qKQg2OwtggXaEL+WX6b8oTW4YqzOCfncUdwFdX00kVrrLWSi
         EkLSqYbKMbkeQKv0CTwZGqtkmhGqFJmC9kUq+6qI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BEFB460791
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] libertas_tf: lower the debug level of command trace
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190210194735.17939-1-lkundrak@v3.sk>
References: <20190210194735.17939-1-lkundrak@v3.sk>
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190219151019.C0D366071A@smtp.codeaurora.org>
Date:   Tue, 19 Feb 2019 15:10:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lubomir Rintel <lkundrak@v3.sk> wrote:

> Logging each and every command response is way too much for INFO level.
> Silence this, unless CONFIG_LIBERTAS_THINFIRM_DEBUG has been enabled.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> Reviewed-by: Steve deRosier <derosier@cal-sierra.com>

Patch applied to wireless-drivers-next.git, thanks.

744972b2c4d2 libertas_tf: lower the debug level of command trace

-- 
https://patchwork.kernel.org/patch/10804873/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

