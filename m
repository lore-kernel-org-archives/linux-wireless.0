Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70EC5ECDE44
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 09:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E250204FD
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 09:36:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="H3Tw0rNy";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="pNUGLgin"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E250204FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbeKESz1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 13:55:27 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46600 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbeKESz1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 13:55:27 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1FB23611F1; Mon,  5 Nov 2018 09:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541410597;
        bh=83hXxKdlWXHJz/Amse22GhmjLie8dwvrHLJuDSATidE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=H3Tw0rNyNTpkZJjKYE56zfN/9hO6sCv05ex+hkv/F5Q/72/oRQVez2UKlXIeadUb1
         rIDd1ibdiSKmlja0aA5IBADbKZ3w7fFR1vRq8fzTQOtsdGvexlZioQgq3/iURCXf8e
         z1Xss4i6kw/lMVXH4yrch0qF9zCgchFP0KYCfMiE=
Received: from x230.qca.qualcomm.com (37-33-75-124.bb.dnainternet.fi [37.33.75.124])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E043060B7A;
        Mon,  5 Nov 2018 09:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541410596;
        bh=83hXxKdlWXHJz/Amse22GhmjLie8dwvrHLJuDSATidE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=pNUGLginyfl8/Jpcj/IseqhPDcv8Cc8003jR5wADkUW0bmyK34LF3P+a8O1klZuoG
         s+rWaqmfC7Zl9nPzYqBzJ/suXiPRYTJ09llsR2k+ur2Sil74O+ea/AN7TMOLCjYNHb
         +JwURceGVAL3fZAzD4kLnudyIsbpJ2M1z+oi975o=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E043060B7A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     John Stultz <john.stultz@linaro.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Eyal Reizer <eyalr@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC][PATCH] wlcore: Fixup "Add support for optional wakeirq"
References: <1540490241-32021-1-git-send-email-john.stultz@linaro.org>
Date:   Mon, 05 Nov 2018 11:36:32 +0200
In-Reply-To: <1540490241-32021-1-git-send-email-john.stultz@linaro.org> (John
        Stultz's message of "Thu, 25 Oct 2018 10:57:21 -0700")
Message-ID: <87o9b3g927.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

John Stultz <john.stultz@linaro.org> writes:

> After commit 3c83dd577c7f ("wlcore: Add support for optional
> wakeirq") landed upstream, I started seeing the following oops
> on my HiKey board:
>
> [    1.870279] Unable to handle kernel read from unreadable memory at virtual address 0000000000000010
> [    1.870283] Mem abort info:
> [    1.870287]   ESR = 0x96000005
> [    1.870292]   Exception class = DABT (current EL), IL = 32 bits
> [    1.870296]   SET = 0, FnV = 0
> [    1.870299]   EA = 0, S1PTW = 0
> [    1.870302] Data abort info:
> [    1.870306]   ISV = 0, ISS = 0x00000005
> [    1.870309]   CM = 0, WnR = 0
> [    1.870312] [0000000000000010] user address but active_mm is swapper
> [    1.870318] Internal error: Oops: 96000005 [#1] PREEMPT SMP
> [    1.870327] CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 4.19.0-05129-gb3d1e8e #48
> [    1.870331] Hardware name: HiKey Development Board (DT)
> [    1.870350] Workqueue: events_freezable mmc_rescan
> [    1.870358] pstate: 60400005 (nZCv daif +PAN -UAO)
> [    1.870366] pc : wl1271_probe+0x210/0x350
> [    1.870371] lr : wl1271_probe+0x210/0x350
> [    1.870374] sp : ffffff80080739b0
> [    1.870377] x29: ffffff80080739b0 x28: 0000000000000000
> [    1.870384] x27: 0000000000000000 x26: 0000000000000000
> [    1.870391] x25: 0000000000000036 x24: ffffffc074ecb598
> [    1.870398] x23: ffffffc07ffdce78 x22: ffffffc0744ed808
> [    1.870404] x21: ffffffc074ecbb98 x20: ffffff8008ff9000
> [    1.870411] x19: ffffffc0744ed800 x18: ffffff8008ff9a48
> [    1.870418] x17: 0000000000000000 x16: 0000000000000000
> [    1.870425] x15: ffffffc074ecb503 x14: ffffffffffffffff
> [    1.870431] x13: ffffffc074ecb502 x12: 0000000000000030
> [    1.870438] x11: 0101010101010101 x10: 0000000000000040
> [    1.870444] x9 : ffffffc075400248 x8 : ffffffc075400270
> [    1.870451] x7 : 0000000000000000 x6 : 0000000000000000
> [    1.870457] x5 : 0000000000000000 x4 : 0000000000000000
> [    1.870463] x3 : 0000000000000000 x2 : 0000000000000000
> [    1.870469] x1 : 0000000000000028 x0 : 0000000000000000
> [    1.870477] Process kworker/0:0 (pid: 5, stack limit = 0x(____ptrval____))
> [    1.870480] Call trace:
> [    1.870485]  wl1271_probe+0x210/0x350
> [    1.870491]  sdio_bus_probe+0x100/0x128
> [    1.870500]  really_probe+0x1a8/0x2b8
> [    1.870506]  driver_probe_device+0x58/0x100
> [    1.870511]  __device_attach_driver+0x94/0xd8
> [    1.870517]  bus_for_each_drv+0x70/0xc8
> [    1.870522]  __device_attach+0xe0/0x140
> [    1.870527]  device_initial_probe+0x10/0x18
> [    1.870532]  bus_probe_device+0x94/0xa0
> [    1.870537]  device_add+0x374/0x5b8
> [    1.870542]  sdio_add_func+0x60/0x88
> [    1.870546]  mmc_attach_sdio+0x1b0/0x358
> [    1.870551]  mmc_rescan+0x2cc/0x390
> [    1.870558]  process_one_work+0x12c/0x320
> [    1.870563]  worker_thread+0x48/0x458
> [    1.870569]  kthread+0xf8/0x128
> [    1.870575]  ret_from_fork+0x10/0x18
> [    1.870583] Code: 92400c21 b2760021 a90687a2 97e95bf9 (f9400803)
> [    1.870587] ---[ end trace 1e15f81d3c139ca9 ]---
>
> It seems since we don't have a wakeirq value in the dts, the wakeirq
> value in wl1271_probe() is zero, which then causes trouble in
> irqd_get_trigger_type(irq_get_irq_data(wakeirq)).
>
> This patch tries to address this by checking if wakeirq is zero,
> and not trying to add it to the resources if that is the case.
>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Eyal Reizer <eyalr@ti.com>
> Cc: Anders Roxell <anders.roxell@linaro.org>
> Cc: linux-wireless@vger.kernel.org
> Acked-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Any particular reason why you marked this as RFC? I'm asking because I
would like to apply this patch as is and push to 4.20.

I'll just add:

Fixes: 3c83dd577c7f ("wlcore: Add support for optional wakeirq")

-- 
Kalle Valo
