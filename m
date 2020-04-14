Return-Path: <SRS0=D8BG=56=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2BFDC2BB85
	for <linux-wireless@archiver.kernel.org>; Tue, 14 Apr 2020 08:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B241B206D5
	for <linux-wireless@archiver.kernel.org>; Tue, 14 Apr 2020 08:33:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="wpzBjEtH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436918AbgDNIdg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 14 Apr 2020 04:33:36 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:17620 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436916AbgDNIde (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Apr 2020 04:33:34 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586853214; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=tCT0xuU/ISSMS0WMg3pP3w9431J8QI+4GjSwkYP/Svo=;
 b=wpzBjEtH/4y8XdwH+J5ywX+Vftsd+K1ydzxoLK70PiBsgyHy7FqN06gE5ehnM2cHVUSji6M8
 gjSpBNCcuWlgSlP8Y6FlELGhfHYMEtc9yOuV3jH4WusyqdG23H96N81q8dZNQCuieZ8fo6s2
 XDe9RfS7HSrLvqLLXJAwK5iQDnw=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e95755d.7f78043572d0-smtp-out-n01;
 Tue, 14 Apr 2020 08:33:33 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 28E74C4478C; Tue, 14 Apr 2020 08:33:33 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C4BA6C432C2;
        Tue, 14 Apr 2020 08:33:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C4BA6C432C2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: set IRQ_DISABLE_UNLAZY flag for DP interrupts
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1586421013-23025-1-git-send-email-mpubbise@codeaurora.org>
References: <1586421013-23025-1-git-send-email-mpubbise@codeaurora.org>
To:     Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200414083333.28E74C4478C@smtp.codeaurora.org>
Date:   Tue, 14 Apr 2020 08:33:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Manikanta Pubbisetty <mpubbise@codeaurora.org> wrote:

> Unlike CE interrupts, DP interrupts are not enabled/disabled at
> source; they are enabled/disabled only at GIC level, therefore
> it is required to set IRQ_DISABLE_UNLAZY flag to avoid spurious
> interrupts.
> 
> Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

05090864fc7e ath11k: set IRQ_DISABLE_UNLAZY flag for DP interrupts

-- 
https://patchwork.kernel.org/patch/11481417/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
