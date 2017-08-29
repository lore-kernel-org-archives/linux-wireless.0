Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34274 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbdH2IWp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 04:22:45 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 2/2] iwlwifi: mvm: Avoid deffering non bufferable frames
References: <20170825082730.31388-1-luca@coelho.fi>
        <20170825082730.31388-3-luca@coelho.fi>
Date: Tue, 29 Aug 2017 11:22:41 +0300
In-Reply-To: <20170825082730.31388-3-luca@coelho.fi> (Luca Coelho's message of
        "Fri, 25 Aug 2017 11:27:30 +0300")
Message-ID: <87efruvl4e.fsf@kamboji.qca.qualcomm.com> (sfid-20170829_102251_331774_A6E740ED)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: David Spinadel <david.spinadel@intel.com>
>
> Use bcast station for all non bufferable frames on AP and AD-HOC.
>
> The host is no longer aware of STAs PS status because of buffer
> station offload, so we can't rely on mac80211 to toggle on
> IEEE80211_TX_CTL_NO_PS_BUFFER bit.
>
> A possible issue with buffering such frames, beside the obvious spec
> violation, is when a station disconnects while in PS but the AP isn't
> aware of that. In such scenarios the AP won't be able to send probe
> responses or auth frames so the STA won't be able to reconnect and
> the AP will have a queue hang.
>
> Fixes: 3e56eadfb6a1 ("iwlwifi: mvm: implement AP/GO uAPSD support")
> Signed-off-by: David Spinadel <david.spinadel@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

"deffering"? Should it be deferring?

-- 
Kalle Valo
