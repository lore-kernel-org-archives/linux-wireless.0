Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66643C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27E2C2086C
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:35:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HS/eMiPK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hZe2jreW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbfBTMfS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:35:18 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42892 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbfBTMfS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 07:35:18 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2E6C5611FE; Wed, 20 Feb 2019 12:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550666117;
        bh=XchQazYN+wzROSI46pOmM8vCa9PyIeayFzL3jLjXnI0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HS/eMiPK9Nk4Kj4iRmpRWh46FesJ7bOE1g81f7aOQqhrHjhrylI+bjTnihU2WqL0k
         vLFstJOzTT01a1pjRtKlF5D5zUHZ22jqbfa8WPYbxRHjLjpv9tuxDMOp3CFgmJu4IA
         XaWdq8UKLqVZuyrR/G+j0hiHnJwA4/T/Pn6+HcW8=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 385BB61135;
        Wed, 20 Feb 2019 12:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550666114;
        bh=XchQazYN+wzROSI46pOmM8vCa9PyIeayFzL3jLjXnI0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hZe2jreWh4p5LGd/UqYunQ/lVlLybjTnttqU3vOZOW52IeqRMg7ukqEQDpasl9m6x
         QDT9rdMJcItxHp8iaNoDvFQt+U+5/r93sQYLA0ocMYM4qMcSbvArvba13zAAeuSx2k
         EzvqN6waQD3/nEoF7c9YujpXQvu7J8HLoa950yyQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 385BB61135
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 00/20] iwlwifi: updates intended for v5.1 2019-02-15
References: <20190215114924.2545-1-luca@coelho.fi>
Date:   Wed, 20 Feb 2019 14:35:10 +0200
In-Reply-To: <20190215114924.2545-1-luca@coelho.fi> (Luca Coelho's message of
        "Fri, 15 Feb 2019 13:49:04 +0200")
Message-ID: <87a7iq1vup.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> Here's the nineth set of patches intended for v5.1.  It's the usual
> development, new features, cleanups and bugfixes.
>
> The changes are:
>
> * Some small fixes in the new debugging infrastructure;
> * Greg's debugfs clean-ups;
> * Some janitorial patches from the community;
> * Fix to one false-positive compiler warning;
> * NSS suuport;

I was first baffled about this NSS support, but I guess you mean VHT
extended NSS support (or something like that)?

-- 
Kalle Valo
