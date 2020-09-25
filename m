Return-Path: <SRS0=Pl1w=DC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E9D6C4363D
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Sep 2020 16:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 353F9235FD
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Sep 2020 16:10:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="I46E5pgD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgIYQKz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Sep 2020 12:10:55 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:24687 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbgIYQKz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Sep 2020 12:10:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601050254; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=7w7d3SaNS8kfmf+xr3dqg+az0d6I2AL4UYl2O+1bjXs=;
 b=I46E5pgD7/PbkSlUVGPUYN8L1qYqVk7QG8n1mZ4tkEKLn8uCVAFJloufMfODaYumk6vR0UX4
 ZSnL6OMJ96n/qbiiLk0VTlKlzcjDRvrO/C5GRMY2DmHYct7Qph3exrG7r/vPSVtVMhRUWUJC
 d6ZnioMi6kODHErd6vxB3fXwx3U=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5f6e1674291b30bc714345e4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 25 Sep 2020 16:10:28
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 138BFC43387; Fri, 25 Sep 2020 16:10:28 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8A8EEC433FF;
        Fri, 25 Sep 2020 16:10:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8A8EEC433FF
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: fix undefined reference to
 'ath11k_debugfs_htt_ext_stats_handler'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1601024241-16594-1-git-send-email-kvalo@codeaurora.org>
References: <1601024241-16594-1-git-send-email-kvalo@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200925161028.138BFC43387@smtp.codeaurora.org>
Date:   Fri, 25 Sep 2020 16:10:28 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> wrote:

> kbuild bot reported than link fails when CONFIG_ATH11K_DEBUGFS is disabled:
> 
> drivers/net/wireless/ath/ath11k/dp_rx.c:1662: undefined reference to `ath11k_debugfs_htt_ext_stats_handler'
> 
> This was because I had missed to move the static inline version of the function
> (which are used when CONFIG_ATH11K_DEBUGFS is disabled) to debufs_htt_stats.h.
> Also move ath11k_debugfs_htt_stats_req() at the same time. And create a stub
> also for ath11k_debugfs_htt_stats_init() for consistency, even if it's not
> needed.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 568f06036ee2 ("ath11k: debugfs: move some function declarations to correct header files")
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to wireless-drivers-next.git, thanks.

bc8befe6f950 ath11k: fix undefined reference to 'ath11k_debugfs_htt_ext_stats_handler'

-- 
https://patchwork.kernel.org/patch/11799379/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

