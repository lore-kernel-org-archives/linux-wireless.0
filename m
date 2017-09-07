Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33548 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753640AbdIGQk1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Sep 2017 12:40:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: iwlwifi: mvm: only send LEDS_CMD when the FW supports it
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170907075152.4522-1-luca@coelho.fi>
References: <20170907075152.4522-1-luca@coelho.fi>
To: Luciano Coelho <luca@coelho.fi>
Cc: torvalds@linux-foundation.org, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        davem@davemloft.net, emmanuel.grumbach@intel.com,
        Luca Coelho <luciano.coelho@intel.com>
Message-Id: <20170907164027.2C5926073D@smtp.codeaurora.org> (sfid-20170907_184124_590001_FEB8A4F8)
Date: Thu,  7 Sep 2017 16:40:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <luca@coelho.fi> wrote:

> From: Luca Coelho <luciano.coelho@intel.com>
> 
> The LEDS_CMD command is only supported in some newer FW versions
> (e.g. iwlwifi-8000C-31.ucode), so we can't send it to older versions
> (such as iwlwifi-8000C-27.ucode).
> 
> To fix this, check for a new bit in the FW capabilities TLV that tells
> when the command is supported.
> 
> Note that the current version of -31.ucode in linux-firmware.git
> (31.532993.0) does not have this capability bit set, so the LED won't
> work, even though this version should support it.  But we will update
> this firmware soon, so it won't be a problem anymore.
> 
> Fixes: 7089ae634c50 ("iwlwifi: mvm: use firmware LED command where applicable")
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-drivers.git, thanks.

2eabc84d2f8e iwlwifi: mvm: only send LEDS_CMD when the FW supports it

-- 
https://patchwork.kernel.org/patch/9941719/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
