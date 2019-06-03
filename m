Return-Path: <SRS0=NUxy=UC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB01C04AB5
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Jun 2019 14:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6708623A51
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Jun 2019 14:48:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="pKmumP+l";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="J38/2kwX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbfFCOsa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Jun 2019 10:48:30 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38340 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727650AbfFCOsa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Jun 2019 10:48:30 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 65AD660252; Mon,  3 Jun 2019 14:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559573309;
        bh=4cZEGaj9UQufwOw+P10SLYwCO4sIdBPkTCOKNXaAYrU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=pKmumP+lRXOqMs+XpnojsSc5mMFfAS5NN8gLBJoWy66a6s2PPmuUMpmfpEdFBhrwx
         zVBprnPVkHkZmMBZa16/8RoZUd30RdDI+sSQk/POJhxJ+HYyubcXuDNeMds1Vb/Vml
         1BbTYfvR8bPYqXluXs0u8Z6dcLViK2rgLpu2k+6I=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C2F1460252;
        Mon,  3 Jun 2019 14:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559573308;
        bh=4cZEGaj9UQufwOw+P10SLYwCO4sIdBPkTCOKNXaAYrU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=J38/2kwXDfwSKhj+j4I0uBKwWafBspE+pcysiRe6q0bqMU2P3SObSe00nj3D/4LJ+
         DYTd9FmwlIVklaQJ6xIXLrzztWhpQIQbmA+k+D6gg8J+0URDy/AtDTOFrtSyHhwMMq
         inIaa6I4b7lwFCeSGYQvVZKTiyABHFQF/cEeY6Ys=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C2F1460252
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Sven Eckelmann <seckelmann@datto.com>,
        Sriram R <srirrama@codeaurora.org>
Subject: Re: [PATCH] ath10k: avoid leaving .bss_info_changed prematurely
References: <20190311083107.311-1-sven@narfation.org>
Date:   Mon, 03 Jun 2019 17:48:24 +0300
In-Reply-To: <20190311083107.311-1-sven@narfation.org> (Sven Eckelmann's
        message of "Mon, 11 Mar 2019 09:31:07 +0100")
Message-ID: <878suiwwqv.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sven Eckelmann <sven@narfation.org> writes:

> From: Sven Eckelmann <seckelmann@datto.com>
>
> ath10k_bss_info_changed() handles various events from the upper layers. It
> parses the changed bitfield and then configures the driver/firmware
> accordingly. Each detected event is handled in a separate scope which is
> independent of each other - but in the same function.
>
> The commit f279294e9ee2 ("ath10k: add support for configuring management
> packet rate") changed this behavior by returning from this function
> prematurely when some precondition was not fulfilled. All new event
> handlers added after the BSS_CHANGED_BASIC_RATES event handler would then
> also be skipped.
>
> Signed-off-by: Sven Eckelmann <seckelmann@datto.com>
> ---
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Sriram R <srirrama@codeaurora.org>
>
> Only compile tested

Unfortunately doesn't apply anymore, please rebase.

Applying: ath10k: avoid leaving .bss_info_changed prematurely
Using index info to reconstruct a base tree...
M       drivers/net/wireless/ath/ath10k/mac.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/ath/ath10k/mac.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/mac.c
Recorded preimage for 'drivers/net/wireless/ath/ath10k/mac.c'
error: Failed to merge in the changes.
Patch failed at 0001 ath10k: avoid leaving .bss_info_changed prematurely

-- 
Kalle Valo
