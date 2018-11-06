Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 005F1C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 10:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBE9920827
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 10:04:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bRbIyC6r";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TwZ/OMYT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBE9920827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387618AbeKFT3D (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 14:29:03 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38636 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387505AbeKFT3D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 14:29:03 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F216060600; Tue,  6 Nov 2018 10:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541498676;
        bh=mNGt2JIAiulEybncc33JCGzC0ihDRsMIKwnWwHsiln4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bRbIyC6rzfBrOpZV+ClX89zqS+9CLuMUkjxjnuBkdZYGhFzSnZ7UX3cQnDbokKV90
         wR7pDhffkUBKnkQUvXw5zHHa/8jFaOTZWe5eA7c7GqC1w3ELz0NjGQBwGACnyF8M/q
         5+pGIOmtTVeMnIonKYGUbqKvmYdWJ9ULLDOP/oAY=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C3ECE603D2;
        Tue,  6 Nov 2018 10:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541498675;
        bh=mNGt2JIAiulEybncc33JCGzC0ihDRsMIKwnWwHsiln4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TwZ/OMYTx/bh5YNNRKktZTnobCiYVIsMV8WGxxTdKKqsuZ0gv1Nqjs314XM5aqZ7P
         M8SZdpoYGSYQ8bztZMGhlCU9N84XUYLUochKzRuhhm4P16yqHVNgfPOMZ4msPkoCUo
         WfymY1NkoZQ2A4IxsPCBIxFL8sMcjIco7NZYjhXI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C3ECE603D2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Maya Erez <merez@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: Re: [PATCH 13/16] wil6210: ignore HALP ICR if already handled
References: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
        <1540975944-30576-14-git-send-email-merez@codeaurora.org>
Date:   Tue, 06 Nov 2018 12:04:32 +0200
In-Reply-To: <1540975944-30576-14-git-send-email-merez@codeaurora.org> (Maya
        Erez's message of "Wed, 31 Oct 2018 10:52:21 +0200")
Message-ID: <875zxabjyn.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Maya Erez <merez@codeaurora.org> writes:

> HALP ICR is set as long as the FW should stay awake.
> To prevent its multiple handling the driver masks this IRQ bit.
> However, if there is a different MISC ICR before the driver clears
> this bit, there is a risk of race condition between HALP mask and
> unmask. This race leads to HALP timeout, in case it is mistakenly
> masked.
> Add an atomic flag to indicate if HALP ICR should be handled.
>
> Signed-off-by: Maya Erez <merez@codeaurora.org>

[...]

> --- a/drivers/net/wireless/ath/wil6210/interrupt.c
> +++ b/drivers/net/wireless/ath/wil6210/interrupt.c
> @@ -575,10 +575,14 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
>  	}
>  
>  	if (isr & BIT_DMA_EP_MISC_ICR_HALP) {
> -		wil_dbg_irq(wil, "irq_misc: HALP IRQ invoked\n");
> -		wil6210_mask_halp(wil);
>  		isr &= ~BIT_DMA_EP_MISC_ICR_HALP;
> -		complete(&wil->halp.comp);
> +		if (atomic_read(&wil->halp.handle_icr)) {
> +			/* no need to handle HALP ICRs until next vote */
> +			atomic_set(&wil->halp.handle_icr, 0);

atomic_read() followed by atomic_set() is IMHO not really atomic :) I
would assume there's a function to reset the variable really in atomic
way.

-- 
Kalle Valo
