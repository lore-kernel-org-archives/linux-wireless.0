Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57430 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752155AbdBFOFY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 09:05:24 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 15/25] iwlwifi: mvm/pcie: adjust A-MSDU tx_cmd length in PCIe
References: <20170203143812.7525-1-luca@coelho.fi>
        <20170203143812.7525-16-luca@coelho.fi>
Date: Mon, 06 Feb 2017 16:05:19 +0200
In-Reply-To: <20170203143812.7525-16-luca@coelho.fi> (Luca Coelho's message of
        "Fri, 3 Feb 2017 16:38:02 +0200")
Message-ID: <87zihz8leo.fsf@codeaurora.org> (sfid-20170206_150554_050421_A75DCEAD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> Instead of setting the tx_cmd length in the mvm code, which is
> complicated by the fact that DQA may want to temporarily store
> the SKB on the side, adjust the length in the PCIe code which
> also knows about this since it's responsible for duplicating
> all those headers that are account for in this code.
>
> As the PCIe code already relies on the tx_cmd->len field, this
> doesn't really introduce any new dependencies.
>
> To make this possible we need to move the memcpy() of the TX
> command until after it was updated.
>
> This does even simplify the code though, since the PCIe code
> already does a lot of manipulations to build A-MSDUs correctly
> and changing the length becomes a simple operation to see how
> much was added/removed, rather than predicting it.
>
> Fixes: commit 24afba7690e4 ("iwlwifi: mvm: support bss dynamic alloc/dealloc of queues")

Ditto.

-- 
Kalle Valo
