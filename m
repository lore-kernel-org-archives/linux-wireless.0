Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51816 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752033AbdHIH13 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 03:27:29 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH v2 2/3] iwlwifi: mvm: start mac queues when deferred tx frames are purged
References: <78tivleks.fsf@kamboji.qca.qualcomm.com>
        <20170809055853.8560-1-luca@coelho.fi>
Date: Wed, 09 Aug 2017 10:27:24 +0300
In-Reply-To: <20170809055853.8560-1-luca@coelho.fi> (Luca Coelho's message of
        "Wed, 9 Aug 2017 08:58:53 +0300")
Message-ID: <87efsli4kj.fsf@kamboji.qca.qualcomm.com> (sfid-20170809_092732_929464_8B24EB68)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Avraham Stern <avraham.stern@intel.com>
>
> In AP mode, if a station is removed just as it is adding a new stream,
> the queue in question will remain stopped and no more TX will happen
> in this queue, leading to connection failures and other problems.
>
> This is because under DQA, when tx is deferred because a queue needs
> to be allocated, the mac queue for that TID is stopped until the new
> stream is added.  If at this point the station that this stream
> belongs to is removed, all the deferred tx frames are purged, but the
> mac queue is not restarted. As a result, all following tx on this
> queue will not be transmitted.
>
> Fix this by starting the relevant mac queues when the deferred tx
> frames are purged.
>
> Fixes: 24afba7690e4 ("iwlwifi: mvm: support bss dynamic alloc/dealloc of queues")
> Signed-off-by: Avraham Stern <avraham.stern@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Looks good, thanks.

-- 
Kalle Valo
