Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81338C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 09:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BD7220823
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 09:28:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Cxbfe3J4";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UzAgS6f3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbfBKJ2q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 04:28:46 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34678 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbfBKJ2q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 04:28:46 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id ABE4A60886; Mon, 11 Feb 2019 09:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549877324;
        bh=78XoK4ovJJvUkwn0OPwjtbVMRX5DfhZtSdqbHbmFJ/I=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Cxbfe3J4oMpQmZiS8szCmTC2XhzhhQV7J1lbtDcrGpepabh72tKJCvVLuA/q7KHb5
         jyCjQbDSBZ/YTCBkXl4Inv+Ch0re1H/j30YhlcNfjDtgVHF+FzYpDrZ9fqK/wSh3IF
         iXmjO2wHBBq5Mes5ZCsaRtwqUcxCGbWIWjNoF/V4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C5FE060886;
        Mon, 11 Feb 2019 09:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549877323;
        bh=78XoK4ovJJvUkwn0OPwjtbVMRX5DfhZtSdqbHbmFJ/I=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=UzAgS6f3ci/soMoq+PD4g7VA2938syc0482PJdsIMtlmRbU8BACrjOE62mwxgeqYX
         xLkph9jIJn32QJTApypyasYGt0XCPbRkXeT7I3yvVOSMdJkLjCXpKEl12PfilcphUK
         RLwnthRefDCJ+2XjV8yu1q62M6gjofJgDKw9sZZ4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C5FE060886
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Add support to configure ftm responder role
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1549439910-9315-1-git-send-email-pradeepc@codeaurora.org>
References: <1549439910-9315-1-git-send-email-pradeepc@codeaurora.org>
To:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190211092844.ABE4A60886@smtp.codeaurora.org>
Date:   Mon, 11 Feb 2019 09:28:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Pradeep Kumar Chitrapu <pradeepc@codeaurora.org> wrote:

> Configure fine timing measurement (FTM) responder role from the
> ftm_responder bss param sent by mac80211. With FTM functionality offloaded
> to firmware, adding the interface allows userspace to enable or disable
> FTM responder functionality. ath10k disables it at the time of interface
> creation.
> 
> Supported FW: 10.4
> 
> Tested on IPQ4019 with firmware: 10.4-3.2.1.1-00022
> 
> Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

I had to fix some conflicts, please carefully check my resolution in the pending branch:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=a3e53eb1c7c58b131ebc0581aa44b0912809e430

$ git am -s -3 10798883.mbox
Applying: ath10k: Add support to configure ftm responder role
Using index info to reconstruct a base tree...
M       drivers/net/wireless/ath/ath10k/core.h
M       drivers/net/wireless/ath/ath10k/mac.c
M       drivers/net/wireless/ath/ath10k/wmi.c
M       drivers/net/wireless/ath/ath10k/wmi.h
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/ath/ath10k/wmi.h
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi.h
Auto-merging drivers/net/wireless/ath/ath10k/wmi.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi.c
Auto-merging drivers/net/wireless/ath/ath10k/mac.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/mac.c
Auto-merging drivers/net/wireless/ath/ath10k/core.h
Recorded preimage for 'drivers/net/wireless/ath/ath10k/mac.c'
Recorded preimage for 'drivers/net/wireless/ath/ath10k/wmi.c'
Recorded preimage for 'drivers/net/wireless/ath/ath10k/wmi.h'
error: Failed to merge in the changes.
Patch failed at 0001 ath10k: Add support to configure ftm responder role

-- 
https://patchwork.kernel.org/patch/10798883/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

