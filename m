Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59134 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbeE2Hb4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 03:31:56 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: emmanuel.grumbach@intel.com, jadit2@gmail.com,
        linux-wireless@vger.kernel.org, Hao Wei Tee <angelsl@in04.sg>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH] iwlwifi: pcie: compare with number of IRQs requested for, not number of CPUs
References: <20180529072517.30135-1-luca@coelho.fi>
Date: Tue, 29 May 2018 10:31:51 +0300
In-Reply-To: <20180529072517.30135-1-luca@coelho.fi> (Luca Coelho's message of
        "Tue, 29 May 2018 10:25:17 +0300")
Message-ID: <87fu2a9au0.fsf@kamboji.qca.qualcomm.com> (sfid-20180529_093251_990326_424F52DB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

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
> Signed-off-by: Hao Wei Tee <angelsl@in04.sg>
> Tested-by: Sara Sharon <sara.sharon@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Like we discussed I'll take this directly for 4.17 and add:

Fixes: 2e5d4a8f61dc ("iwlwifi: pcie: Add new configuration to enable MSIX")

-- 
Kalle Valo
