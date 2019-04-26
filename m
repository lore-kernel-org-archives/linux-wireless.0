Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75BF4C43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 11:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AD85208C3
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 11:52:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AcXXH3ZI";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KoPyoJCJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfDZLv5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 07:51:57 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41930 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfDZLv5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 07:51:57 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 597B760746; Fri, 26 Apr 2019 11:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556279516;
        bh=EF48OwBCkCA0Gk/7YnvvMjtq0kK3+IEOAtHkI4o9mB8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=AcXXH3ZIVVu84KDzSxo3Cj581HpTTZYe0svGF2q4DqSjTORwYOIBP3eSBnlGQb015
         iabIyhspX4LTKQAZ7uWsLRnsbLO/EiRYNimiUNUztRJcg6SyEnXva2VprmMAamCI63
         CaTBtNzGUFTb09x0Sf/9NH36snDUQa6mT0JWjfqo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 28F776028C;
        Fri, 26 Apr 2019 11:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556279515;
        bh=EF48OwBCkCA0Gk/7YnvvMjtq0kK3+IEOAtHkI4o9mB8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KoPyoJCJGBnH4uz7fDYN2/PUGTkQgcZMxB5XbITJeaC4CG7JoE7l7tueBrW9Jbq7s
         5AIEuLtPdFL0V3HnhAlFEFGMY0rowzFv2TDJKaK0EKzilE8lGAUAO4+VBBEV4CFuW6
         qvKVBUM7vmAspBCRaQsRs5skEStPBsu/a3781+0o=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 28F776028C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        pakki001@umn.edu, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: ath: fix missing checks for bmi reads and writes
References: <20190315051903.10664-1-kjlu@umn.edu>
Date:   Fri, 26 Apr 2019 14:51:51 +0300
In-Reply-To: <20190315051903.10664-1-kjlu@umn.edu> (Kangjie Lu's message of
        "Fri, 15 Mar 2019 00:19:03 -0500")
Message-ID: <87k1fhugq0.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kangjie Lu <kjlu@umn.edu> writes:

> ath10k_bmi_write32 and ath10k_bmi_read32 can fail. The fix
> checks their statuses to avoid potential undefined behaviors.
>
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>

[...]

> @@ -2500,8 +2515,15 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
>  		if (status)
>  			goto err;
>  
> -		if (ar->hif.bus == ATH10K_BUS_SDIO)
> -			ath10k_init_sdio(ar);
> +		if (ar->hif.bus == ATH10K_BUS_SDIO) {
> +			status = ath10k_init_sdio(ar);
> +			if (status) {
> +				ath10k_err(ar,
> +					   "could not init HTC (%d)\n",
> +					   status);

I'll fix the warning message as well, we are not initialisating HTC
here.

-- 
Kalle Valo
