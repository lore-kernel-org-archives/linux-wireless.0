Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37322 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbeE2Hku (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 03:40:50 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: iwlwifi: pcie: compare with number of IRQs requested for,
 not number of CPUs
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180529072517.30135-1-luca@coelho.fi>
References: <20180529072517.30135-1-luca@coelho.fi>
To: Luciano Coelho <luca@coelho.fi>
Cc: emmanuel.grumbach@intel.com, jadit2@gmail.com,
        linux-wireless@vger.kernel.org, Hao Wei Tee <angelsl@in04.sg>,
        Luca Coelho <luciano.coelho@intel.com>
Message-Id: <20180529074050.2ECF360591@smtp.codeaurora.org> (sfid-20180529_094054_259610_F5E859A8)
Date: Tue, 29 May 2018 07:40:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <luca@coelho.fi> wrote:

> From: Hao Wei Tee <angelsl@in04.sg>
> 
> When there are 16 or more logical CPUs, we request for
> `IWL_MAX_RX_HW_QUEUES` (16) IRQs only as we limit to that number of
> IRQs, but later on we compare the number of IRQs returned to
> nr_online_cpus+2 instead of max_irqs, the latter being what we
> actually asked for. This ends up setting num_rx_queues to 17 which
> causes lots of out-of-bounds array accesses later on.
> 
> Compare to max_irqs instead, and also add an assertion in case
> num_rx_queues > IWM_MAX_RX_HW_QUEUES.
> 
> This fixes https://bugzilla.kernel.org/show_bug.cgi?id=199551
> 
> Fixes: 2e5d4a8f61dc ("iwlwifi: pcie: Add new configuration to enable MSIX")
> Signed-off-by: Hao Wei Tee <angelsl@in04.sg>
> Tested-by: Sara Sharon <sara.sharon@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-drivers.git, thanks.

ab1068d6866e iwlwifi: pcie: compare with number of IRQs requested for, not number of CPUs

-- 
https://patchwork.kernel.org/patch/10434495/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
