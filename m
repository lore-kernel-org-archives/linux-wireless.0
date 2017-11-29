Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41678 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753446AbdK2KTh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Nov 2017 05:19:37 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 6/6] iwlwifi: fix access to prph when transport is stopped
References: <20171125153510.25359-1-luca@coelho.fi>
        <20171125153510.25359-7-luca@coelho.fi>
Date: Wed, 29 Nov 2017 12:19:32 +0200
In-Reply-To: <20171125153510.25359-7-luca@coelho.fi> (Luca Coelho's message of
        "Sat, 25 Nov 2017 17:35:10 +0200")
Message-ID: <87vaht1j63.fsf@kamboji.qca.qualcomm.com> (sfid-20171129_111945_194655_E9DD4BB8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Sara Sharon <sara.sharon@intel.com>
>
> When getting HW rfkill we get stop_device being called from two paths.
> One path is the IRQ calling stop device, and updating op mode and
> stack. As a result, cfg80211 is running rfkill sync work that shuts
> down all devices (second path). In the second path, we eventually get
> to iwl_mvm_stop_device which calls
> iwl_fw_dump_conf_clear->iwl_fw_dbg_stop_recording, that access
> periphery registers. The device may be stopped at this point from the
> first path, which will result with a failure to access those
> registers. Simply checking for the trans status is insufficient, since
> the race will still exist, only minimized. Instead, move the stop from
> iwl_fw_dump_conf_clear (which is getting called only from stop path)
> to the transport stop device function, where the access is always
> safe. This has the added value, of actually stopping dbgc before
> stopping device even when the stop is initiated from the transport.
>
> Fixes: 1efc3843a4ee ("iwlwifi: stop dbgc recording before stopping
> DMA")

No need to resend because of this, but Fixes should be in one line.

-- 
Kalle Valo
