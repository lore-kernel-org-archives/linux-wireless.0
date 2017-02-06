Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56112 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbdBFOBq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 09:01:46 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 14/25] iwlwifi: mvm: overwrite skb info later
References: <20170203143812.7525-1-luca@coelho.fi>
        <20170203143812.7525-15-luca@coelho.fi>
Date: Mon, 06 Feb 2017 16:01:41 +0200
In-Reply-To: <20170203143812.7525-15-luca@coelho.fi> (Luca Coelho's message of
        "Fri, 3 Feb 2017 16:38:01 +0200")
Message-ID: <874m07a056.fsf@codeaurora.org> (sfid-20170206_150157_052469_F20A3513)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> We don't really need clear the skb's status area nor store the
> dev_cmd into it until we really commit to the frame by handing
> it to the transport - defer those operations until just before
> we do that.
>
> This doesn't entirely fix the bug with frames not getting sent
> out after having been deferred due to DQA, because it doesn't
> restore the info->driver_data[0] place that was already set to
> zero (or another value) by the A-MSDU logic.
>
> Fixes: commit 24afba7690e4 ("iwlwifi: mvm: support bss dynamic alloc/dealloc of queues")

s/commit // :)

-- 
Kalle Valo
