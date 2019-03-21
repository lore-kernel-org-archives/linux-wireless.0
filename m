Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF37C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 10:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E1FD218B0
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 10:03:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AFUpvsI1";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KUVY6vcx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbfCUKCz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 06:02:55 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49390 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728214AbfCUKCy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 06:02:54 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9D25061340; Thu, 21 Mar 2019 10:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553162573;
        bh=rX7DF4oh7NXEJSuZVEdUG2Y/o23SCQFXYK+f7URV7AY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=AFUpvsI1IB89QRXqng/uMv+DtJGYYSqd/BEcycapUsIlatw0q7vc/37u/FNFtKE4/
         RJGLYRsbdsdp8Jxlj9vCONhJLH4SYuk+v5r9468/C8L7EMhEGOdFp1SsHvoiNhFcJh
         UzNj95/G5auWq88si0fKm1q7HNtbNT/vGSjIO7s4=
Received: from x230.qca.qualcomm.com (unknown [195.39.71.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6A9E161194;
        Thu, 21 Mar 2019 10:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553162572;
        bh=rX7DF4oh7NXEJSuZVEdUG2Y/o23SCQFXYK+f7URV7AY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KUVY6vcx37GIjUETvE5ll8B1rG2tX3azrfl/69wGMN6f8lfb7du3SH8Pj7XbA17X1
         w1iWWGjRH1HmaRmy8u0F6yM8o8VfMHrQlwGKvIiG7Ght7IgzY4iESuepEp6E9c1ZLg
         PKJQHgKmeKo6UfGGzxiZU+OsQ30UM6Tb2ztmbHbg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6A9E161194
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tim Schumacher <timschumi@gmx.de>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: Check for errors when reading SREV register
References: <20190318190557.21599-1-timschumi@gmx.de>
Date:   Thu, 21 Mar 2019 12:02:47 +0200
In-Reply-To: <20190318190557.21599-1-timschumi@gmx.de> (Tim Schumacher's
        message of "Mon, 18 Mar 2019 20:05:57 +0100")
Message-ID: <87va0cpmt4.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tim Schumacher <timschumi@gmx.de> writes:

> Right now, if an error is encountered during the SREV register
> read (i.e. an EIO in ath9k_regread()), that error code gets
> passed all the way to __ath9k_hw_init(), where it is visible
> during the "Chip rev not supported" message.
>
>     ath9k_htc 1-1.4:1.0: ath9k_htc: HTC initialized with 33 credits
>     ath: phy2: Mac Chip Rev 0x0f.3 is not supported by this driver
>     ath: phy2: Unable to initialize hardware; initialization status: -95
>     ath: phy2: Unable to initialize hardware; initialization status: -95
>     ath9k_htc: Failed to initialize the device
>
> Check for -EIO explicitly in ath9k_hw_read_revisions() and return
> a boolean based on the success of the operation. Check for that in
> __ath9k_hw_init() and abort with a more debugging-friendly message
> if reading the revisions wasn't successful.
>
>     ath9k_htc 1-1.4:1.0: ath9k_htc: HTC initialized with 33 credits
>     ath: phy2: Failed to read SREV register
>     ath: phy2: Could not read hardware revision
>     ath: phy2: Unable to initialize hardware; initialization status: -95
>     ath: phy2: Unable to initialize hardware; initialization status: -95
>     ath9k_htc: Failed to initialize the device
>
> This helps when debugging by directly showing the first point of
> failure and it could prevent possible errors if a 0x0f.3 revision
> is ever supported.
>
> Signed-off-by: Tim Schumacher <timschumi@gmx.de>

[...]

> -	val = REG_READ(ah, AR_SREV) & AR_SREV_ID;
> +	srev = REG_READ(ah, AR_SREV);
> +
> +	if (srev == -EIO) {
> +		ath_err(ath9k_hw_common(ah),
> +			"Failed to read SREV register");
> +		return false;
> +	}

I really don't like how the error handling is implemented in REG_READ().
If the register has value 0xfffffffb (= -EIO ==-5) won't this interpret
that as an error?

-- 
Kalle Valo
