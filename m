Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31216C282CB
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 14:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC20920844
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 14:12:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NrdxSzof";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NrdxSzof"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbfBHOMo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 09:12:44 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50218 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727944AbfBHOMo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 09:12:44 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E38F260791; Fri,  8 Feb 2019 14:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549635163;
        bh=eNZhY7OSgt/VeIAk0Tner2bt5mgsF3pCiuE65nNQpbE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=NrdxSzof5jhYtNqNi9I8l8cnk6DRRWxFHH5ECyglFg6fGA9KKZ4ydbwj9jEZX7R/L
         tMuGqcIQYbvYTjNRZUu4ycj1TitpLJCnElr3amm0F+MdT27dCVdNSsu5JZf9EQocXg
         FfhLJKVHvdYFnwuQBYol+OMvwJzFFdURONAV0tgY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 68682602CC;
        Fri,  8 Feb 2019 14:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549635163;
        bh=eNZhY7OSgt/VeIAk0Tner2bt5mgsF3pCiuE65nNQpbE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=NrdxSzof5jhYtNqNi9I8l8cnk6DRRWxFHH5ECyglFg6fGA9KKZ4ydbwj9jEZX7R/L
         tMuGqcIQYbvYTjNRZUu4ycj1TitpLJCnElr3amm0F+MdT27dCVdNSsu5JZf9EQocXg
         FfhLJKVHvdYFnwuQBYol+OMvwJzFFdURONAV0tgY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 68682602CC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Surabhi Vishnoi <svishnoi@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: Add support to provide higher range mem chunks in wmi init command
References: <1544524740-31372-1-git-send-email-svishnoi@codeaurora.org>
Date:   Fri, 08 Feb 2019 16:12:40 +0200
In-Reply-To: <1544524740-31372-1-git-send-email-svishnoi@codeaurora.org>
        (Surabhi Vishnoi's message of "Tue, 11 Dec 2018 16:09:00 +0530")
Message-ID: <87tvhe74iv.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Surabhi Vishnoi <svishnoi@codeaurora.org> writes:

> With the current implementation of wmi init command,
> there is no provision for the host driver to provide mem
> chunks addresses with more than 32-bit, to the firmware.
> WCN3990 is a 35-bit target and can accept mem chunks addresses
> which are above 32-bit.
>
> If firmware supports address range more than 32 bit, it
> advertises the support by setting the WMI_SERVICE_EXTEND_ADDRESS
> service. Based on this service fill the upper bits of paddr while
> providing the mem chunks in the wmi init command.
>
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01552-QCAHLSWMTPL-1
>
> Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>

Does not apply and I even tried to find a commit from December to make
it work, and as the sha1 is not valid so 3-way merge won't work either.
I strongly recommend to use pristine ath.git master branch (meaning that
there are no other unapplied patches on top) when submitting patches,
otherwise this can happen. Please rebase and resubmit.

Applying: ath10k: Add support to provide higher range mem chunks in wmi init command
fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath10k/wmi-tlv.c).
error: could not build fake ancestor
Patch failed at 0001 ath10k: Add support to provide higher range mem chunks in wmi init comman

-- 
Kalle Valo
