Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51143 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1JaNLR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 09:11:17 -0400
Message-ID: <4EAE9E30.1080403@qca.qualcomm.com> (sfid-20111031_141120_242018_300658A3)
Date: Mon, 31 Oct 2011 15:10:08 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Raja Mani <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/7] ath6kl: Add wmi functions to configure wow mode and
 host sleep mode
References: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com> <1319539047-8756-3-git-send-email-rmani@qca.qualcomm.com> <4EAA9DDC.5090909@qca.qualcomm.com> <4EAE6FFD.6090403@qca.qualcomm.com>
In-Reply-To: <4EAE6FFD.6090403@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/31/2011 11:53 AM, Raja Mani wrote:
>>> +static void ath6kl_wmi_relinquish_implicit_pstream_credits(struct wmi *wmi)
>>> >> +{
>>> >> +	u16 active_tsids;
>>> >> +	u8 stream_exist;
>>> >> +	int i;
>>> >> +
>>> >> +	/*
>>> >> +	 * Relinquish credits from all implicitly created pstreams
>>> >> +	 * since when we go to sleep. If user created explicit
>>> >> +	 * thinstreams exists with in a fatpipe leave them intact
>>> >> +	 * for the user to delete.
>>> >> +	 */
>>> >> +	spin_lock_bh(&wmi->lock);
>>> >> +	stream_exist = wmi->fat_pipe_exist;
>>> >> +	spin_unlock_bh(&wmi->lock);
>>> >> +
>>> >> +	for (i = 0; i<  WMM_NUM_AC; i++) {
>>> >> +		if (stream_exist&  (1<<  i)) {
>>> >> +
>>> >> +			spin_lock_bh(&wmi->lock);
>>> >> +			active_tsids = wmi->stream_exist_for_ac[i];
>>> >> +			spin_unlock_bh(&wmi->lock);
>>> >> +
>>> >> +			/*
>>> >> +			 * If there are no user created thin streams
>>> >> +			 * delete the fatpipe
>>> >> +			 */
>>> >> +			if (!active_tsids) {
>>> >> +				stream_exist&= ~(1<<  i);
>>> >> +				/*
>>> >> +				 * Indicate inactivity to driver layer for
>>> >> +				 * this fatpipe (pstream)
>>> >> +				 */
>>> >> +				ath6kl_indicate_tx_activity(wmi->parent_dev,
>>> >> +							    i, false);
>>> >> +			}
>>> >> +		}
>>> >> +	}
>>> >> +
>>> >> +	spin_lock_bh(&wmi->lock);
>>> >> +	wmi->fat_pipe_exist = stream_exist;
>>> >> +	spin_unlock_bh(&wmi->lock);
>> >
>> > The locking here doesn't really make sense. For example, any changes to
>> > wmi->fat_pipe_exist during the for loop will be overwritten. Also lock
>> > handling with wmi->stream_exist_for_ac[i] looks fishy.
>
> Is it fine just removal of both locking (For "active_tsids = 
> wmi->stream_exist_for_ac[i]" and "wmi->fat_pipe_exist = stream_exist") ?
> 
> I am sure about the impact..Could you please give some point how above 
> locking can be improved ?

I haven't reviewed the locking in detail so it's difficult to say. For
example, you could hold the lock the entire duration of for loop. But
that might create deadlocks. Another option is take it into account the
changes happening to fat_pipe_exist while lock is not held.

Kalle
