Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:36479 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753382AbdCMOYn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Mar 2017 10:24:43 -0400
Received: by mail-io0-f181.google.com with SMTP id l7so84639388ioe.3
        for <linux-wireless@vger.kernel.org>; Mon, 13 Mar 2017 07:24:43 -0700 (PDT)
Subject: Re: [PATCH] iwlwifi: mvm: cleanup pending frames in DQA mode
To: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org
References: <1489410030.22435.34.camel@coelho.fi>
 <20170313131427.17147-1-luca@coelho.fi>
Cc: torvalds@linux-foundation.org, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, linuxwifi@intel.com,
        sara.sharon@intel.com, liad.kaufman@intel.com,
        luciano.coelho@intel.com
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <57bc6afa-7b78-36ca-98c3-7bbdfc36672d@kernel.dk> (sfid-20170313_152553_739723_6BC761D6)
Date: Mon, 13 Mar 2017 08:24:40 -0600
MIME-Version: 1.0
In-Reply-To: <20170313131427.17147-1-luca@coelho.fi>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/13/2017 07:14 AM, Luca Coelho wrote:
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

It fixes the warning for me.

Tested-by: Jens Axboe <axboe@fb.com>

-- 
Jens Axboe
