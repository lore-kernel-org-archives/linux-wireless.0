Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC51C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D66DA20875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:33:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MAxOSgdI";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CvGQa7qX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D66DA20875
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbeJEPbF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:31:05 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42342 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727750AbeJEPbF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 11:31:05 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D2D5160818; Fri,  5 Oct 2018 08:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538728404;
        bh=84SQIppFyd1UeFz+u85TajCiM1VkmMvPCm+itJxRwvs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=MAxOSgdIOELBUJQZGBrxamgPY75xq3MuzwJVNraRypvstf7Lpbx/hhwk96FNmWkCN
         HBMkYBVODX4FLKuVUMT3vQ+DskkI4jmB3IL64YvTtpEPnCMh2CbmjqCCY6mOLZmerG
         OjDi5v8I+naJEYi8+xrbN9Y6VCgMDowCwrb/2TcA=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 51576601A0;
        Fri,  5 Oct 2018 08:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538728403;
        bh=84SQIppFyd1UeFz+u85TajCiM1VkmMvPCm+itJxRwvs=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=CvGQa7qXIPEmIisd8rnaHOc7vCOKqElV1qjaSPrZCqyOv9rluU1uQcnfWs/jhAbU6
         T2oHK6uH6l6Y6o2jnNqnx44ulItYJ9s7Uh6FZkqD7+zvpYc1t8pAMBzEIdSrQ0rPnG
         rDLSwsVQUwoEn/K8567w+aU7eo5VzoWRgDZi7M18=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 51576601A0
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wlcore: Fix BUG with clear completion on timeout
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181001213805.86511-1-tony@atomide.com>
References: <20181001213805.86511-1-tony@atomide.com>
To:     Tony Lindgren <tony@atomide.com>
Cc:     Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181005083324.D2D5160818@smtp.codeaurora.org>
Date:   Fri,  5 Oct 2018 08:33:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Lindgren <tony@atomide.com> wrote:

> We do not currently clear wl->elp_compl on ELP timeout and we have bogus
> lingering pointer that wlcore_irq then will try to access after recovery
> is done:
> 
> BUG: spinlock bad magic on CPU#1, irq/255-wl12xx/580
> ...
> (spin_dump) from [<c01b9344>] (do_raw_spin_lock+0xc8/0x124)
> (do_raw_spin_lock) from [<c09b3970>] (_raw_spin_lock_irqsave+0x68/0x74)
> (_raw_spin_lock_irqsave) from [<c01a02f0>] (complete+0x24/0x58)
> (complete) from [<bf572610>] (wlcore_irq+0x48/0x17c [wlcore])
> (wlcore_irq [wlcore]) from [<c01c5efc>] (irq_thread_fn+0x2c/0x64)
> (irq_thread_fn) from [<c01c623c>] (irq_thread+0x148/0x290)
> (irq_thread) from [<c016b4b0>] (kthread+0x160/0x17c)
> (kthread) from [<c01010b4>] (ret_from_fork+0x14/0x20)
> ...
> 
> After that the system will hang. Let's fix this by adding a flag for
> recovery and moving the recovery work call to to the error handling
> section.
> 
> And we want to set WL1271_FLAG_INTENDED_FW_RECOVERY and actually clear
> it too in wl1271_recovery_work() and just downgrade the error to a
> warning to prevent overly verbose output.
> 
> Cc: Eyal Reizer <eyalr@ti.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

Patch applied to wireless-drivers-next.git, thanks.

4e651bad8489 wlcore: Fix BUG with clear completion on timeout

-- 
https://patchwork.kernel.org/patch/10622767/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

