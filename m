Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47160 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751794AbdHGM6e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 08:58:34 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 2/3] iwlwifi: mvm: start mac queues when deferred tx frames are purged
References: <20170805184743.23650-1-luca@coelho.fi>
        <20170805184743.23650-3-luca@coelho.fi>
Date: Mon, 07 Aug 2017 15:58:27 +0300
In-Reply-To: <20170805184743.23650-3-luca@coelho.fi> (Luca Coelho's message of
        "Sat, 5 Aug 2017 21:47:42 +0300")
Message-ID: <878tivleks.fsf@kamboji.qca.qualcomm.com> (sfid-20170807_145838_866156_540E0800)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Avraham Stern <avraham.stern@intel.com>
>
> Under DQA, when tx is deferred because a queue needs to be allocated,
> the mac queue for that TID is stopped until the new stream is added.
> If at this point the station that this stream belongs to is removed,
> all the deferred tx frames are purged, but the mac queue is not
> restarted. As a result, all following tx on this queue will not be
> transmitted.
>
> Fix this by starting the relevant mac queues when the deferred tx
> frames are purged.
>
> Fixes: 24afba7690e4 ("iwlwifi: mvm: support bss dynamic alloc/dealloc of queues")
> Signed-off-by: Avraham Stern <avraham.stern@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

The commit log is not really explaining the bug from user's point of
view.

-- 
Kalle Valo
