Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5747C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 13:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DE342086A
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 13:08:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="pMBzMQkO";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PRisk6LP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DE342086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbeKPXVC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 18:21:02 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:52122 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbeKPXVC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 18:21:02 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 09750607F5; Fri, 16 Nov 2018 13:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542373722;
        bh=WMP+r3CreM0afRo4FfIeJvJL71yUByWlD431T5Ay6mk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=pMBzMQkO5/cMhFAt2BiKpT5KKjm/tsK9XZdzIaLGp7S3DQO3ilZfvYwVyzOya/cSY
         SN+ao+vwGQqNY5ZdPGaUIdGGe+g1fgNVYy31voD8tfQs16EkfL4wkDbJUO2RG3N4ng
         0jmv43e89Ewz7R8eoGJnIy7La2GXwvEWplpFeflo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 15637606DD;
        Fri, 16 Nov 2018 13:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542373721;
        bh=WMP+r3CreM0afRo4FfIeJvJL71yUByWlD431T5Ay6mk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=PRisk6LPG86nhsMSk2AHVHhZVbpm+Zq7QkH9LhTvhy/z4RV7a6yWMKVgN+zCVM5Aa
         3HUL+09II1yrO0Y+efo4GhU2zy7BniZ9EFE21gWdomiB8HZmqA4FNaB5NLOZbXFzRt
         AFKNG9s5xxVbvoDd3ARj2pIf3iTBqO6SznqWVCMg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 15637606DD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 4.20] ath10k: don't assume 'vif' is non-NULL in flush()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181108004035.136050-1-briannorris@chromium.org>
References: <20181108004035.136050-1-briannorris@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Grant Grundler <grundler@chromium.org>,
        Wen Gong <wgong@codeaurora.org>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181116130842.09750607F5@smtp.codeaurora.org>
Date:   Fri, 16 Nov 2018 13:08:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> mac80211 may call us with vif == NULL, if the station is not currently
> active (e.g., not associated). It is trivially easy to reproduce a crash
> by suspending the system when not connected to an AP:
> 
> [   65.533934] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
> ...
> [   65.574521] pc : ath10k_flush+0x30/0xd0 [ath10k_core]
> [   65.574538] lr : __ieee80211_flush_queues+0x180/0x244 [mac80211]
> [   65.599680] Process kworker/u12:1 (pid: 57, stack limit = 0x(____ptrval____))
> [   65.599682] Call trace:
> [   65.599695]  ath10k_flush+0x30/0xd0 [ath10k_core]
> [   65.642064]  __ieee80211_flush_queues+0x180/0x244 [mac80211]
> [   65.642079]  ieee80211_flush_queues+0x34/0x40 [mac80211]
> [   65.642095]  __ieee80211_suspend+0xfc/0x47c [mac80211]
> [   65.658611]  ieee80211_suspend+0x30/0x3c [mac80211]
> [   65.658627]  wiphy_suspend+0x15c/0x3a8 [cfg80211]
> [   65.672810]  dpm_run_callback+0xf0/0x1f0
> [   65.672814]  __device_suspend+0x3ac/0x4f8
> [   65.672819]  async_suspend+0x34/0xbc
> [   65.684096]  async_run_entry_fn+0x54/0x104
> [   65.684099]  worker_thread+0x4cc/0x72c
> [   65.684102]  kthread+0x134/0x13c
> [   65.684105]  ret_from_fork+0x10/0x18
> 
> Fixes: 9de4162f0999 ("ath10k: add peer flush in ath10k_flush for STATION")
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers.git, thanks.

d987f783a480 ath10k: don't assume 'vif' is non-NULL in flush()

-- 
https://patchwork.kernel.org/patch/10673301/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

