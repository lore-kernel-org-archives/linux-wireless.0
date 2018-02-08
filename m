Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42080 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbeBHMlq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Feb 2018 07:41:46 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: Revert "ath10k: add sanity check to ie_len before parsing
 fw/board ie"
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1518011483-7704-1-git-send-email-kvalo@codeaurora.org>
References: <1518011483-7704-1-git-send-email-kvalo@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Ryan Hsu <ryanhsu@codeaurora.org>
Message-Id: <20180208124146.1680B609EF@smtp.codeaurora.org> (sfid-20180208_134150_317026_4E59D35C)
Date: Thu,  8 Feb 2018 12:41:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> wrote:

> This reverts commit 9ed4f91628737c820af6a1815b65bc06bd31518f.
> 
> The commit introduced a regression that over read the ie with
> the padding.
> 
> - the expected IE information
> 
> ath10k_pci 0000:03:00.0: found firmware features ie (1 B)
> ath10k_pci 0000:03:00.0: Enabling feature bit: 6
> ath10k_pci 0000:03:00.0: Enabling feature bit: 7
> ath10k_pci 0000:03:00.0: features
> ath10k_pci 0000:03:00.0: 00000000: c0 00 00 00 00 00 00 00
> 
> - the wrong IE with padding is read (0x77)
> 
> ath10k_pci 0000:03:00.0: found firmware features ie (4 B)
> ath10k_pci 0000:03:00.0: Enabling feature bit: 6
> ath10k_pci 0000:03:00.0: Enabling feature bit: 7
> ath10k_pci 0000:03:00.0: Enabling feature bit: 8
> ath10k_pci 0000:03:00.0: Enabling feature bit: 9
> ath10k_pci 0000:03:00.0: Enabling feature bit: 10
> ath10k_pci 0000:03:00.0: Enabling feature bit: 12
> ath10k_pci 0000:03:00.0: Enabling feature bit: 13
> ath10k_pci 0000:03:00.0: Enabling feature bit: 14
> ath10k_pci 0000:03:00.0: Enabling feature bit: 16
> ath10k_pci 0000:03:00.0: Enabling feature bit: 17
> ath10k_pci 0000:03:00.0: Enabling feature bit: 18
> ath10k_pci 0000:03:00.0: features
> ath10k_pci 0000:03:00.0: 00000000: c0 77 07 00 00 00 00 00
> 
> Tested-by: Mike Lothian <mike@fireburn.co.uk>
> Signed-off-by: Ryan Hsu <ryanhsu@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-current branch of ath.git, thanks.

9ce8b24aa96e Revert "ath10k: add sanity check to ie_len before parsing fw/board ie"

-- 
https://patchwork.kernel.org/patch/10205215/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
