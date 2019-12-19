Return-Path: <SRS0=TQ1a=2J=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56948C43603
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Dec 2019 13:53:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25883218AC
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Dec 2019 13:53:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="dCwwDlTg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfLSNx6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 19 Dec 2019 08:53:58 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:14750 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726757AbfLSNx6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Dec 2019 08:53:58 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576763637; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=zaZmRZ6YeKeeaMSMvLqQcKASEO++ARYDbyb8fi6gsjw=; b=dCwwDlTgaM2gF1WIenMCBYw5tUw7UZv/zxm4ZrkEaQD4gzICgYoZrZGhR0BEWZgGHxw9iwYD
 b8wmXgQzWYjFlY4vX8Tf64rbmJbh6AIrLrKZV4OxS/G281SmyYe6WaR/PXWYiLU55ap6+Zpm
 cSRuqIz06yD9QrYzdmtmDlON+Bs=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5dfb80f1.7f7ef611f2d0-smtp-out-n01;
 Thu, 19 Dec 2019 13:53:53 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BAEAAC447B7; Thu, 19 Dec 2019 13:53:53 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1FD38C447A5;
        Thu, 19 Dec 2019 13:53:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1FD38C447A5
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc:     akolli@codeaurora.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath10k: pci: Only dump ATH10K_MEM_REGION_TYPE_IOREG when safe
References: <20191219131539.1003793-1-bryan.odonoghue@linaro.org>
        <20191219131539.1003793-2-bryan.odonoghue@linaro.org>
Date:   Thu, 19 Dec 2019 15:53:50 +0200
In-Reply-To: <20191219131539.1003793-2-bryan.odonoghue@linaro.org> (Bryan
        O'Donoghue's message of "Thu, 19 Dec 2019 13:15:38 +0000")
Message-ID: <87woas5slt.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Bryan O'Donoghue <bryan.odonoghue@linaro.org> writes:

> ath10k_pci_dump_memory_reg() will try to access memory of type
> ATH10K_MEM_REGION_TYPE_IOREG however, if a hardware restart is in progress
> this can crash a system.
>
> Individual ioread32() time has been observed to jump from 15-20 ticks to >
> 80k ticks followed by a secure-watchdog bite and a system reset.
>
> Work around this corner case by only issuing the read transaction when the
> driver state is ATH10K_STATE_ON.
>
> Fixes: 219cc084c6706 ("ath10k: add memory dump support QCA9984")
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

What ath10k hardware and firmware did you test this on? I can add that
to the commit log.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
