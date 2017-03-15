Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59078 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753061AbdCOJwV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Mar 2017 05:52:21 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: axboe@kernel.dk, linux-wireless@vger.kernel.org,
        torvalds@linux-foundation.org, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, linuxwifi@intel.com,
        sara.sharon@intel.com, liad.kaufman@intel.com,
        luciano.coelho@intel.com
Subject: Re: [RESEND PATCH 4.11] iwlwifi: mvm: cleanup pending frames in DQA mode
References: <1489410030.22435.34.camel@coelho.fi>
        <20170314075035.19248-1-luca@coelho.fi>
Date: Wed, 15 Mar 2017 11:52:14 +0200
In-Reply-To: <20170314075035.19248-1-luca@coelho.fi> (Luca Coelho's message of
        "Tue, 14 Mar 2017 09:50:35 +0200")
Message-ID: <87pohi6f5d.fsf@purkki.adurom.net> (sfid-20170315_105303_162184_558A7C78)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

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
> ---
>
> Just resending with reported and tested by tags.

Sorry, my usual rant follows :) But never ever use "RESEND", it's so
much simpler to have v2, v3 and so on to figure out what's the (latest)
version I should take.

-- 
Kalle Valo
