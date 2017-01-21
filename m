Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50570 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750905AbdAUM7R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 21 Jan 2017 07:59:17 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: iwlwifi: fix kernel crash when unregistering thermal zone
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <b6a2209c-1343-cbda-c6c2-ae5eb93148d3@kernel.dk>
References: <b6a2209c-1343-cbda-c6c2-ae5eb93148d3@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org
Message-Id: <20170121125917.47BA060851@smtp.codeaurora.org> (sfid-20170121_135921_749183_F3053557)
Date: Sat, 21 Jan 2017 12:59:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jens Axboe <axboe@kernel.dk> wrote:
> A recent firmware change seems to have enabled thermal zones on the
> iwlwifi driver. Unfortunately, my device fails when registering the
> thermal zone. This doesn't stop the driver from attempting to unregister
> the thermal zone at unload time, triggering a NULL pointer deference in
> strlen() off the thermal_zone_device_unregister() path.
> 
> Don't unregister if name is NULL, for that case we failed registering.
> Do the same for the cooling zone.
> 
> Signed-off-by: Jens Axboe <axboe@fb.com>

Patch applied to wireless-drivers.git, thanks.

92549cdc288f iwlwifi: fix kernel crash when unregistering thermal zone

-- 
https://patchwork.kernel.org/patch/9522187/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
