Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33200 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdCPHyU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 03:54:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [RESEND,4.11] iwlwifi: mvm: cleanup pending frames in DQA mode
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170314075035.19248-1-luca@coelho.fi>
References: <20170314075035.19248-1-luca@coelho.fi>
To: Luciano Coelho <luca@coelho.fi>
Cc: axboe@kernel.dk, linux-wireless@vger.kernel.org,
        torvalds@linux-foundation.org, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, linuxwifi@intel.com,
        sara.sharon@intel.com, liad.kaufman@intel.com,
        luciano.coelho@intel.com
Message-Id: <20170316075418.D00DF6028B@smtp.codeaurora.org> (sfid-20170316_085423_103486_CB4BDC00)
Date: Thu, 16 Mar 2017 07:54:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <luca@coelho.fi> wrote:
> From: Sara Sharon <sara.sharon@intel.com>
> 
> When a station is asleep, the fw will set it as "asleep".
> All queues that are used only by one station will be stopped by
> the fw.
> 
> In pre-DQA mode this was relevant for aggregation queues. However,
> in DQA mode a queue is owned by one station only, so all queues
> will be stopped.
> As a result, we don't expect to get filtered frames back to
> mac80211 and don't have to maintain the entire pending_frames
> state logic, the same way as we do in aggregations.
> 
> The correct behavior is to align DQA behavior with the aggregation
> queue behaviour pre-DQA:
> - Don't count pending frames.
> - Let mac80211 know we have frames in these queues so that it can
> properly handle trigger frames.
> 
> When a trigger frame is received, mac80211 tells the driver to send
> frames from the queues using release_buffered_frames.
> The driver will tell the fw to let frames out even if the station
> is asleep. This is done by iwl_mvm_sta_modify_sleep_tx_count.
> 
> Reported-and-tested-by: Jens Axboe <axboe@kernel.dk>
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Sara Sharon <sara.sharon@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-drivers.git, thanks.

9a3fcf912ef7 iwlwifi: mvm: cleanup pending frames in DQA mode

-- 
https://patchwork.kernel.org/patch/9622617/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
