Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39972 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751489AbdLNLdH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 06:33:07 -0500
Subject: Re: [PATCH v3 1/3] mac80211: Add TXQ scheduling API
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
References: <20171027141451.22768-1-toke@toke.dk>
 <20171031112747.5778-1-toke@toke.dk>
From: Felix Fietkau <nbd@nbd.name>
Cc: Johannes Berg <johannes@sipsolutions.net>
Message-ID: <b2ed2696-db3d-4797-b5e2-161172fd2413@nbd.name> (sfid-20171214_123311_222037_50997587)
Date: Thu, 14 Dec 2017 12:33:04 +0100
MIME-Version: 1.0
In-Reply-To: <20171031112747.5778-1-toke@toke.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-10-31 12:27, Toke Høiland-Jørgensen wrote:
> This adds an API to mac80211 to handle scheduling of TXQs and changes the
> interface between driver and mac80211 for TXQ handling as follows:
> 
> - The wake_tx_queue callback interface no longer includes the TXQ. Instead,
>   the driver is expected to retrieve that from ieee80211_next_txq()
> 
> - Two new mac80211 functions are added: ieee80211_next_txq() and
>   ieee80211_schedule_txq(). The former returns the next TXQ that should be
>   scheduled, and is how the driver gets a queue to pull packets from. The
>   latter is called internally by mac80211 to start scheduling a queue, and
>   the driver is supposed to call it to re-schedule the TXQ after it is
>   finished pulling packets from it (unless the queue emptied).
> 
> The ath9k and ath10k drivers are changed to use the new API.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
Sorry that I didn't have time to give this a thorough review earlier,
since I was pretty busy with other projects. Now that I'm working on
porting mt76 to this new API, some things in this patch strike me as
rather odd, and there might be some bugs and nasty limitations here:

In the new API you can no longer select txq entries by hardware queue.
When using multiple WMM queues, this could lead to station entries being
requeued unnecessarily (because there is no room in the hw queue for the
txq entry that ieee80211_next_txq happens to return).
Since ieee80211_next_txq also refills the airtime fairness quantum, this
might lead to some minor fairness issues.

In ath9k the code used to have a loop that goes through all pending txq
entries until it has filled the hw queues again. You replaced that with
some calls to ath_txq_schedule which now only considers one single txq.
There are several reasons why this queue could potentially not be serviced:
- ieee80211_tx_dequeue returned no frame
- frame does not fit within BA window
- txq was for another queue which is already filled
Depending on the exact circumstances with enough stations this might
lead to hardware queues getting starved.

In ath10k the issues are different. You left a loop to service queues in
place, and if I'm reading it correctly, you could be facing an infinite
loop here:
Let's assume that ath10k_mac_tx_push_pending gets called and there are
multiple txqs pending.
The first txq has 16 frames pending, gets serviced, requeued.
Second txq has lots of frames pending, 16 frames are pushed out, the txq
is requeued.
Back to the first one, ath10k_mac_tx_push_txq returns -ENOENT, so no
requeue.
Back to the second one, hardware queues are filled,
ath10k_mac_tx_can_push returns false, so ret stays 0, txq gets requeued.
By now first == txq can never happen anymore because the first txq is
not scheduled anymore.
Seems like an infinite loop to me.

I think dealing with these corner cases will be easier if we support
filtering by queue in ieee80211_next_txq, so I will send a patch for that.

- Felix
