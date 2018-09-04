Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35004 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbeIDJhm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 05:37:42 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH v2] ath10k:  fix vdev-start timeout on error
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1531512596-31355-1-git-send-email-greearb@candelatech.com>
References: <1531512596-31355-1-git-send-email-greearb@candelatech.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Ben Greear <greearb@candelatech.com>
Message-Id: <20180904051416.C1C6460708@smtp.codeaurora.org> (sfid-20180904_071419_869741_7B2C959B)
Date: Tue,  4 Sep 2018 05:14:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com wrote:

> The vdev-start-response message should cause the
> completion to fire, even in the error case.  Otherwise,
> the user still gets no useful information and everything
> is blocked until the timeout period.
> 
> Add some warning text to print out the invalid status
> code to aid debugging, and propagate failure code.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

This had few checkpatch warnings:

drivers/net/wireless/ath/ath10k/wmi.h:6647: code indent should use tabs where possible
drivers/net/wireless/ath/ath10k/wmi.h:6647: please, no spaces at the start of a line
drivers/net/wireless/ath/ath10k/wmi.h:6648: code indent should use tabs where possible
drivers/net/wireless/ath/ath10k/wmi.h:6648: please, no spaces at the start of a line

I fixed those in the pending branch.

-- 
https://patchwork.kernel.org/patch/10524087/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
