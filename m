Return-Path: <SRS0=+bZT=NF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4893CECDE46
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 17:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED6BD20834
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 17:33:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QrEh9v+d";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SjHPqzlX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED6BD20834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbeJZCHB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Oct 2018 22:07:01 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45662 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbeJZCHB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Oct 2018 22:07:01 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 29C40612EE; Thu, 25 Oct 2018 17:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540488796;
        bh=l51Mlic0BZWb+fOeoi6FYpXjDTL9ViQhzjn45TKEOpU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QrEh9v+dq3mysN7Ffw05787yqQGzhRs7fjLAyLXN2cLZMNdtD+QCOp3DO/SSKmEv6
         hvVFD1BdHor4pfpMgMyhsX5Y46W4C16wDlEXj6yUUUz89M3yYD8pd97Y4SF6KECzdO
         ErfaywsPOHpN8+4zbrm5mMaqUeI+ocGuBUZY58TI=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3142160246;
        Thu, 25 Oct 2018 17:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540488794;
        bh=l51Mlic0BZWb+fOeoi6FYpXjDTL9ViQhzjn45TKEOpU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SjHPqzlXbr/5KlCqLGCh/4Ix3PZgbFe5pabBWuzN/ZTaTn+pYzcggCBCMg3lrHyym
         oXFscynjoF+cFMqtnJaDRY4+wt78Sq6xRDTf3bTMFHQh8xu10knQ/AKGA4WTLWGCkP
         +ZN01C2BGYhTDP/I5NnXceQQY4Kr+8bubVGGCadM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3142160246
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     John Stultz <john.stultz@linaro.org>
Cc:     Tony Lindgren <tony@atomide.com>, Eyal Reizer <eyalr@ti.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        linux-wireless@vger.kernel.org
Subject: Re: Regression: OOPs on boot due to "wlcore: Add support for optional wakeirq"
References: <CALAqxLVOEVP2g6tPc1RF8mEgfffwWVHSuwrvv_a+oB2d0Jp8rg@mail.gmail.com>
        <CALAqxLWEMXAUeNA3DJS9Nx10VvwkqU0G15h7WPP2QepFi5X4hw@mail.gmail.com>
Date:   Thu, 25 Oct 2018 20:33:10 +0300
In-Reply-To: <CALAqxLWEMXAUeNA3DJS9Nx10VvwkqU0G15h7WPP2QepFi5X4hw@mail.gmail.com>
        (John Stultz's message of "Thu, 25 Oct 2018 10:15:26 -0700")
Message-ID: <87y3amdj8p.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ linux-wireless

John Stultz <john.stultz@linaro.org> writes:

> On Thu, Oct 25, 2018 at 10:04 AM, John Stultz <john.stultz@linaro.org> wrote:
>> Hey Tony,
>>   In testing linus/master on my hikey board, I'm hitting the following
>> OOPS on bootup:
>>
>> [    1.870279] Unable to handle kernel read from unreadable memory at
>> virtual address 0000000000000010
>> [    1.870283] Mem abort info:
>> [    1.870287]   ESR = 0x96000005
>> [    1.870292]   Exception class = DABT (current EL), IL = 32 bits
>> [    1.870296]   SET = 0, FnV = 0
>> [    1.870299]   EA = 0, S1PTW = 0
>> [    1.870302] Data abort info:
>> [    1.870306]   ISV = 0, ISS = 0x00000005
>> [    1.870309]   CM = 0, WnR = 0
>> [    1.870312] [0000000000000010] user address but active_mm is swapper
>> [    1.870318] Internal error: Oops: 96000005 [#1] PREEMPT SMP
>> [    1.870327] CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted
>> 4.19.0-05129-gb3d1e8e #48
>> [    1.870331] Hardware name: HiKey Development Board (DT)
>> [    1.870350] Workqueue: events_freezable mmc_rescan
>> [    1.870358] pstate: 60400005 (nZCv daif +PAN -UAO)
>> [    1.870366] pc : wl1271_probe+0x210/0x350
>> [    1.870371] lr : wl1271_probe+0x210/0x350
>> [    1.870374] sp : ffffff80080739b0
>> [    1.870377] x29: ffffff80080739b0 x28: 0000000000000000
>> [    1.870384] x27: 0000000000000000 x26: 0000000000000000
>> [    1.870391] x25: 0000000000000036 x24: ffffffc074ecb598
>> [    1.870398] x23: ffffffc07ffdce78 x22: ffffffc0744ed808
>> [    1.870404] x21: ffffffc074ecbb98 x20: ffffff8008ff9000
>> [    1.870411] x19: ffffffc0744ed800 x18: ffffff8008ff9a48
>> [    1.870418] x17: 0000000000000000 x16: 0000000000000000
>> [    1.870425] x15: ffffffc074ecb503 x14: ffffffffffffffff
>> [    1.870431] x13: ffffffc074ecb502 x12: 0000000000000030
>> [    1.870438] x11: 0101010101010101 x10: 0000000000000040
>> [    1.870444] x9 : ffffffc075400248 x8 : ffffffc075400270
>> [    1.870451] x7 : 0000000000000000 x6 : 0000000000000000
>> [    1.870457] x5 : 0000000000000000 x4 : 0000000000000000
>> [    1.870463] x3 : 0000000000000000 x2 : 0000000000000000
>> [    1.870469] x1 : 0000000000000028 x0 : 0000000000000000
>> [    1.870477] Process kworker/0:0 (pid: 5, stack limit = 0x(____ptrval____))
>> [    1.870480] Call trace:
>> [    1.870485]  wl1271_probe+0x210/0x350
>> [    1.870491]  sdio_bus_probe+0x100/0x128
>> [    1.870500]  really_probe+0x1a8/0x2b8
>> [    1.870506]  driver_probe_device+0x58/0x100
>> [    1.870511]  __device_attach_driver+0x94/0xd8
>> [    1.870517]  bus_for_each_drv+0x70/0xc8
>> [    1.870522]  __device_attach+0xe0/0x140
>> [    1.870527]  device_initial_probe+0x10/0x18
>> [    1.870532]  bus_probe_device+0x94/0xa0
>> [    1.870537]  device_add+0x374/0x5b8
>> [    1.870542]  sdio_add_func+0x60/0x88
>> [    1.870546]  mmc_attach_sdio+0x1b0/0x358
>> [    1.870551]  mmc_rescan+0x2cc/0x390
>> [    1.870558]  process_one_work+0x12c/0x320
>> [    1.870563]  worker_thread+0x48/0x458
>> [    1.870569]  kthread+0xf8/0x128
>> [    1.870575]  ret_from_fork+0x10/0x18
>> [    1.870583] Code: 92400c21 b2760021 a90687a2 97e95bf9 (f9400803)
>> [    1.870587] ---[ end trace 1e15f81d3c139ca9 ]---
>>
>>
>> I've bisected it down to 3c83dd577c7f ("wlcore: Add support for
>> optional wakeirq").
>>
>> It seems since we don't have a wakeirq value in the dts, the wakeirq
>> value in wl1271_probe() is zero, which then causes trouble in
>> irqd_get_trigger_type(irq_get_irq_data(wakeirq)).
>>
>> Should we check wakeirq before we set the second elements of res[]?
>
> Here's my first swing at doing the above. It seems to work ok. Let me
> know if it looks reasonable and I'll submit it as a proper patch.
>
> https://git.linaro.org/people/john.stultz/android-dev.git/commit/?h=dev/hikey-mainline-WIP&id=383fb6e3abb71b8a721f196120a2e3a9da3315ac

If you submit that remember to CC linux-wireless so that patchwork sees
it.

-- 
Kalle Valo
