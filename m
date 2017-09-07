Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53452 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755286AbdIGMjL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Sep 2017 08:39:11 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: torvalds@linux-foundation.org, Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, davem@davemloft.net,
        emmanuel.grumbach@intel.com, Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH] iwlwifi: mvm: only send LEDS_CMD when the FW supports it
References: <CA+55aFxjHSW7v4Ttu7mGPkxdGpR-WtVoxDT5qtwxUC-Dge5a5A@mail.gmail.com>
        <20170907075152.4522-1-luca@coelho.fi>
Date: Thu, 07 Sep 2017 15:39:05 +0300
In-Reply-To: <20170907075152.4522-1-luca@coelho.fi> (Luca Coelho's message of
        "Thu, 7 Sep 2017 10:51:52 +0300")
Message-ID: <877exan0nq.fsf@kamboji.qca.qualcomm.com> (sfid-20170907_143952_398820_62386690)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

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

Linus, do you want to apply this directly or should we take it via the
normal route (wireless-drivers -> net)? If your prefer the latter when
I'm planning to submit this to Dave in a day or two and expecting it to
get to your tree in about a week, depending of course what is Dave's
schedule.

-- 
Kalle Valo
