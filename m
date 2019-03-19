Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B89C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 15:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD50120850
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 15:37:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IAhx9F+S";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MEvIcqlf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbfCSPhQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:37:16 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57038 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbfCSPhP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 11:37:15 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 695E061573; Tue, 19 Mar 2019 15:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553009834;
        bh=59PRLgfEfR9NsFENQelhXyoxOKOPdINqXtFe4jPaFwM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=IAhx9F+SSkilN73ZzSTdKTLwJeL49/TGVhcm4qp4EEeyvf5uDZNniFyhoBMjiOZMk
         7diMu2lwfSGvjvbb5qqtNmYjjQjgHiFYQMhICmLPXmv2x1m8nLWyaV581UCv/hGR1b
         PaIShrnR8wF7alrZLLy6c1YyoU5nSLId1QzBtI6Q=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 95D6F6134E;
        Tue, 19 Mar 2019 15:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553009832;
        bh=59PRLgfEfR9NsFENQelhXyoxOKOPdINqXtFe4jPaFwM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=MEvIcqlfPQg5uTLi/VHCWzXA4HE5xpT/JrtQj+08QBKQKK60r5aPIPPkkbh0CCJK5
         6pYi8cihW5OCxzs2FyBhfJMhJcYATGIaNuA7EtScVc5Up3bN6f+RNGOu0cB5zM382B
         EvPdaIOaueetShZIUPAalyt20D81PDCplLgd8i9w=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 95D6F6134E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] mt76: fix schedule while atomic in mt76x02_reset_state
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <f5d501960f82e62806e4a4566e0b50795b2103db.1552309862.git.lorenzo@kernel.org>
References: <f5d501960f82e62806e4a4566e0b50795b2103db.1552309862.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190319153714.695E061573@smtp.codeaurora.org>
Date:   Tue, 19 Mar 2019 15:37:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Fix following schedule while atomic in mt76x02_reset_state
> since synchronize_rcu is run inside a RCU section
> 
> [44036.944222] mt76x2e 0000:06:00.0: MCU message 31 (seq 3) timed out
> [44036.944281] BUG: sleeping function called from invalid context at kernel/rcu/tree_exp.h:818
> [44036.944284] in_atomic(): 1, irqs_disabled(): 0, pid: 28066, name: kworker/u4:1
> [44036.944287] INFO: lockdep is turned off.
> [44036.944292] CPU: 1 PID: 28066 Comm: kworker/u4:1 Tainted: G        W         5.0.0-rc7-wdn-t1+ #7
> [44036.944294] Hardware name: Dell Inc. Studio XPS 1340/0K183D, BIOS A11 09/08/2009
> [44036.944305] Workqueue: phy1 mt76x02_wdt_work [mt76x02_lib]
> [44036.944308] Call Trace:
> [44036.944317]  dump_stack+0x67/0x90
> [44036.944322]  ___might_sleep.cold.88+0x9f/0xaf
> [44036.944327]  rcu_blocking_is_gp+0x13/0x50
> [44036.944330]  synchronize_rcu+0x17/0x80
> [44036.944337]  mt76_sta_state+0x138/0x1d0 [mt76]
> [44036.944349]  mt76x02_wdt_work+0x1c9/0x610 [mt76x02_lib]
> [44036.944355]  process_one_work+0x2a5/0x620
> [44036.944361]  worker_thread+0x35/0x3e0
> [44036.944368]  kthread+0x11c/0x140
> [44036.944376]  ret_from_fork+0x3a/0x50
> [44036.944384] BUG: scheduling while atomic: kworker/u4:1/28066/0x00000002
> [44036.944387] INFO: lockdep is turned off.
> [44036.944389] Modules linked in: cmac ctr ccm af_packet snd_hda_codec_hdmi
> 
> Introduce __mt76_sta_remove in order to run sta_remove without holding dev->mutex.
> Move __mt76_sta_remove outside of RCU section in mt76x02_reset_state
> 
> Fixes: e4ebb8b403d1 ("mt76: mt76x2: implement full device restart on watchdog reset")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Patch applied to wireless-drivers.git, thanks.

13f61dfc5235 mt76: fix schedule while atomic in mt76x02_reset_state

-- 
https://patchwork.kernel.org/patch/10847437/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

