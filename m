Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53749 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab1AGHQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 02:16:11 -0500
Message-ID: <4D26BDB6.7000806@candelatech.com>
Date: Thu, 06 Jan 2011 23:16:06 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@Atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH 2/3] ath9k:  Re-start xmit logic in xmit watchdog timer.
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com> <1294361165-15308-2-git-send-email-greearb@candelatech.com> <20110107065101.GB13800@vasanth-laptop>
In-Reply-To: <20110107065101.GB13800@vasanth-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/2011 10:51 PM, Vasanthakumar Thiagarajan wrote:
> On Fri, Jan 07, 2011 at 06:16:04AM +0530, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> We should not get to this state, but we do.  What is
>> worse, many times the xmit logic still will not start,
>> probably due to tids being paused when they shouldn't be.
>>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>> ---
>>
>> NOTE:  This needs review.  It might be too much of a hack
>> for upstream code, and at best it works around a small part
>> of the problem.
>>
>> :100644 100644 3aae523... 547fb44... M	drivers/net/wireless/ath/ath9k/xmit.c
>>   drivers/net/wireless/ath/ath9k/xmit.c |   21 +++++++++++++++++++++
>>   1 files changed, 21 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
>> index 3aae523..547fb44 100644
>> --- a/drivers/net/wireless/ath/ath9k/xmit.c
>> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>> @@ -2110,6 +2110,27 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
>>   				} else {
>>   					txq->axq_tx_inprogress = true;
>>   				}
>> +			} else {
>> +				/* If the queue has pending buffers, then it
>> +				 * should be doing tx work (and have axq_depth).
>> +				 * Shouldn't get to this state I think..but
>> +				 * perhaps we do.
>> +				 */
>> +				if (!list_empty(&txq->axq_acq)) {
>> +					ath_err(ath9k_hw_common(sc->sc_ah),
>> +						"txq: %p axq_qnum: %i,"
>> +						" axq_link: %p"
>> +						" pending frames: %i"
>> +						" axq_acq is not empty, but"
>> +						" axq_depth is zero.  Calling"
>> +						" ath_txq_schedule to restart"
>> +						" tx logic.\n",
>> +						txq, txq->axq_qnum,
>> +						txq->axq_link,
>> +						txq->pending_frames);
>> +					ATH_DBG_WARN_ON_ONCE(1);
>> +					ath_txq_schedule(sc, txq);
>
> NAK. This complete work monitors the hw q periodically and does a reset if a
> hang is detected. This work is no way meant to schedule aggr. This
> change really does not make any sense. Scheduling a tid periodically
> would introduce reordering issues especially when there are more
> retries.

Ok, but if the system is in the state where it hits this code branch, it seems
that no new packets are sent to the chip to be transmitted.  I see this,
for instance, in debugfs (with my debugfs patches applied):

axq-qnum:                    2          3         1         0
axq-depth:                   0          0         0         0
axq-ampdu_depth:             0          0         0         0
axq-stopped                  1          0         0         0
tx-in-progress               0          0         0         0
pending-frames              70          0         0         0
txq_headidx:                 0          0         0         0
txq_tailidx:                 0          0         0         0
axq_q empty:                   0          1         1         0
axq_acq empty:                 0          1         1         1
txq_fifo_pending:              1          1         1         1

The queue is stopped, axq_acq and axq_q are not empty, there are pending frames,
and no axq-depth.  I cannot figure out why the queue is stopped since
it seems it should be running when axq-depth is zero.

Thanks for the review, I'll back this hack out of my testing tree.

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
