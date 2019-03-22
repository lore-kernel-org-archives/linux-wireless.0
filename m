Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B1CC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 08:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27C1C2083D
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 08:37:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XfO7jSOk";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FyrTb3sV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfCVIhc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 04:37:32 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44654 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbfCVIhc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 04:37:32 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 125BE6034E; Fri, 22 Mar 2019 08:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553243851;
        bh=y2xsBAj3ssw6qZmHiiEKKJS/XUeAvjnmMutM2M9O6gQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=XfO7jSOkk3PurSyddk6kagpXD7+YIkPE3kN5soXEkB+SPDYxiIJw6iifzVNRZgf0M
         zFOelB4z1SBMgHoGp5mcyPMGkVNI3rcGek7NZhYsH+u5Koz9GJMqojwR3ksrqPqJn0
         h2R0buRNj9ZskBduIIwAK0rEDF4/2XbMOJ1JY2lw=
Received: from x230.qca.qualcomm.com (unknown [195.39.71.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0E5B96034E;
        Fri, 22 Mar 2019 08:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553243850;
        bh=y2xsBAj3ssw6qZmHiiEKKJS/XUeAvjnmMutM2M9O6gQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=FyrTb3sVZOkHCUEaXIyMqNsJ4jV2aL4xGQX9NdYVdwluMZBQI/ojJRm+VEySISIV+
         DtuSBVaKTHLhH7B6mvnVJXo0xBDirWEO0Mw7aSNuhRDd3tJro3PTeiNxI2+bRhQOY6
         xcqbhdhjOkYks3d/ohnD1vYLYeiT3BA6JXlA/l44=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0E5B96034E
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
        <87va0cpmt4.fsf@codeaurora.org>
        <95ca6443-a3ad-1eda-db6a-c684cc358fc9@gmx.de>
Date:   Fri, 22 Mar 2019 10:37:27 +0200
In-Reply-To: <95ca6443-a3ad-1eda-db6a-c684cc358fc9@gmx.de> (Tim Schumacher's
        message of "Fri, 22 Mar 2019 02:47:59 +0100")
Message-ID: <87d0mjnw3c.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tim Schumacher <timschumi@gmx.de> writes:

> On 21.03.19 11:02, Kalle Valo wrote:
>> Tim Schumacher <timschumi@gmx.de> writes:
>>
>>> -	val = REG_READ(ah, AR_SREV) & AR_SREV_ID;
>>> +	srev = REG_READ(ah, AR_SREV);
>>> +
>>> +	if (srev == -EIO) {
>>> +		ath_err(ath9k_hw_common(ah),
>>> +			"Failed to read SREV register");
>>> +		return false;
>>> +	}
>>
>> I really don't like how the error handling is implemented in REG_READ().
>> If the register has value 0xfffffffb (= -EIO ==-5) won't this interpret
>> that as an error?
>>
>
> If the register had that value, it would indeed report an error. However
> (at least if I read the current code and the data sheet correctly), to make
> use of the higher 24 bits of the register, the "small"/old version of the
> SREV_ID (i.e. the rightmost 8 bit) need to be set to 0xFF. Therefore, a
> register read of 0xfffffffb should never happen in this register.

Good, thanks for checking.

> But the error handling is indeed a bit weird. Making the return value a pure
> status indicator and saving the value from the register by passing a
> reference would probably be the best solution to fixing this up.

Yeah, that would be so much better. But that can fixed in another patch,
no need to do that here.

-- 
Kalle Valo
