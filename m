Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36902 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbeIFUqv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 16:46:51 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] ath10k: optimize pci diag mem read & write operations
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1535596182-18038-2-git-send-email-cjhuang@codeaurora.org>
References: <1535596182-18038-2-git-send-email-cjhuang@codeaurora.org>
To: Carl Huang <cjhuang@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <20180906161038.3EA4F60710@smtp.codeaurora.org> (sfid-20180906_181041_312582_B6906C3E)
Date: Thu,  6 Sep 2018 16:10:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Carl Huang <cjhuang@codeaurora.org> wrote:

> Delay 1ms is too long for both diag read and write operations.
> This is observed when writing a big memory buffer to target or
> reading a big memory buffer from target. Take writing/reading
> 512k bytes as example, the delay itself is 256ms as the maximum
> length of every write/read is 2k size.
> 
> Reduce the delay to 50us for read and write operations.
> 
> Take the ath10k_pci_targ_cpu_to_ce_addr() out of loop and put it
> in the beginning of the loop for ath10k_pci_diag_read_mem().
> 
> The ath10k_pci_targ_cpu_to_ce_addr() is to convert the address
> from target cpu's perspective to CE's perspective, so it makes
> no sense to convert a CE's perspective address again in the loop.
> It's a wrong implementation but happens to work.
> 
> If the target address is below 1M space, then the convert in the loop
> from the second time becomes wrong because the previously converted address
> is larger than 1M. The counterpart ath10k_pci_diag_write_mem() has the
> correct implementation.
> 
> With this change, ath10k_pci_diage_read_mem() works correctly no matter
> the target address is below 1M or above 1M.
> 
> It's tested with QCA6174 hw3.2 and
> firmware-6.bin_WLAN.RM.4.4.1-00111-QCARMSWP-1. QCA9377 is also affected.
> 
> Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

3 patches applied to ath-next branch of ath.git, thanks.

d56bbeea25d1 ath10k: optimize pci diag mem read & write operations
bc346c9a24a4 ath10k: support to access target space below 1M for qca6174 and qca9377
39501ea64116 ath10k: download firmware via diag Copy Engine for QCA6174 and QCA9377.

-- 
https://patchwork.kernel.org/patch/10581149/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
