Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45810 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751037AbdCMPI4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Mar 2017 11:08:56 -0400
Message-ID: <1489417727.22435.37.camel@coelho.fi> (sfid-20170313_160900_447451_9462088D)
From: Luca Coelho <luca@coelho.fi>
To: Jens Axboe <axboe@kernel.dk>, linux-wireless@vger.kernel.org
Cc: torvalds@linux-foundation.org, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, linuxwifi@intel.com,
        sara.sharon@intel.com, liad.kaufman@intel.com
Date: Mon, 13 Mar 2017 17:08:47 +0200
In-Reply-To: <57bc6afa-7b78-36ca-98c3-7bbdfc36672d@kernel.dk>
References: <1489410030.22435.34.camel@coelho.fi>
         <20170313131427.17147-1-luca@coelho.fi>
         <57bc6afa-7b78-36ca-98c3-7bbdfc36672d@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] iwlwifi: mvm: cleanup pending frames in DQA mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-03-13 at 08:24 -0600, Jens Axboe wrote:
> On 03/13/2017 07:14 AM, Luca Coelho wrote:
> > From: Sara Sharon <sara.sharon@intel.com>
> > 
> > When a station is asleep, the fw will set it as "asleep".
> > All queues that are used only by one station will be stopped by
> > the fw.
> > 
> > In pre-DQA mode this was relevant for aggregation queues. However,
> > in DQA mode a queue is owned by one station only, so all queues
> > will be stopped.
> > As a result, we don't expect to get filtered frames back to
> > mac80211 and don't have to maintain the entire pending_frames
> > state logic, the same way as we do in aggregations.
> > 
> > The correct behavior is to align DQA behavior with the aggregation
> > queue behaviour pre-DQA:
> > - Don't count pending frames.
> > - Let mac80211 know we have frames in these queues so that it can
> > properly handle trigger frames.
> > 
> > When a trigger frame is received, mac80211 tells the driver to send
> > frames from the queues using release_buffered_frames.
> > The driver will tell the fw to let frames out even if the station
> > is asleep. This is done by iwl_mvm_sta_modify_sleep_tx_count.
> 
> It fixes the warning for me.
> 
> Tested-by: Jens Axboe <axboe@fb.com>

Great! Thanks for testing.

I'll queue this for the 4.11-rc series via the normal path (i.e.
wireless-driver->netdev).

--
Cheers,
Luca.
