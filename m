Return-Path: <SRS0=Fc74=OH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645B0C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 14:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F0F3206B6
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 14:00:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OYZ8KSQD";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jPdOAl+8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F0F3206B6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbeK2BCG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Nov 2018 20:02:06 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33694 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbeK2BCG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Nov 2018 20:02:06 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 51EED60B26; Wed, 28 Nov 2018 14:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543413621;
        bh=f95okssVqu5/kZ0dALYX6IF9C6oBKRHkfjpAu2DR+5k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OYZ8KSQDv0B+6NBR8UnNz81y9Hi+jMTcXNOm9wBxyQH97Q/Rfq19N0ra936FPvPEF
         kdJt4JE0BZfy3FNI/zWuw36uLjdF3Xr5bSiohircb+Q+XqtB04F3v4MqJZH/fEqwxK
         Tmle1iPgh8FM3oeTA48rdm4FK2gA5CbNjcMYnGWg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C684B6147B;
        Wed, 28 Nov 2018 14:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543413620;
        bh=f95okssVqu5/kZ0dALYX6IF9C6oBKRHkfjpAu2DR+5k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jPdOAl+8phQzyKov4eR5rbhEcy2a4ucWSqk8js0VWBMo+5lNLe4ht3OY5J4KykbiT
         sXEGc5bxy6Cloha+iinRWCNQEAsjv4ApVmqI7wnmUggwFKaeupwN/fh/P61J0UaMdF
         Mp93nA2bMbABauS7kVCIuORPJQJtXH465yNtQy5o=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C684B6147B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: update HOST capability qmi message
References: <20181119113101.23359-1-govinds@codeaurora.org>
Date:   Wed, 28 Nov 2018 16:00:16 +0200
In-Reply-To: <20181119113101.23359-1-govinds@codeaurora.org> (Govind Singh's
        message of "Mon, 19 Nov 2018 17:01:01 +0530")
Message-ID: <87lg5d715b.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Govind Singh <govinds@codeaurora.org> writes:

> HOST capability interface data structures are updated
> in HL3.1 fw version. Update the qmi host capability
> members for compatibility across different firmware
> versions.
> With this change HL2.0 fw upgrade is required as this
> change breaks the backward compatibility with HL2.0 fw.

The last sentence is not making any sense to me, does it have a typo or
am I missing something?

If there's a typo I can fix it, no need to resend.

-- 
Kalle Valo
