Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45930 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbeH3E2m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Aug 2018 00:28:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 29 Aug 2018 17:29:16 -0700
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC v2 2/2] mac80211: manage txq transmission based on airtime
 deficit
In-Reply-To: <874lfd4idu.fsf@toke.dk>
References: <1535503594-32051-1-git-send-email-rmanohar@codeaurora.org>
 <1535503594-32051-2-git-send-email-rmanohar@codeaurora.org>
 <874lfd4idu.fsf@toke.dk>
Message-ID: <1eab13f53cc86e6b1315f2670811a6bd@codeaurora.org> (sfid-20180830_022927_258513_49E19EFD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-08-29 02:44, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
>> +bool ieee80211_txq_can_transmit(struct ieee80211_hw *hw,
>> +				struct ieee80211_txq *txq)
>> +{
>> +	struct ieee80211_local *local = hw_to_local(hw);
>> +	struct txq_info *txqi, *f_txqi;
>> +	bool can_tx;
>> +
>> +	txqi = to_txq_info(txq);
>> +	/* Check whether txq is paused or not */
>> +	if (test_bit(IEEE80211_TXQ_PAUSE, &txqi->flags))
>> +		return false;
>> +
>> +	can_tx = false;
>> +	spin_lock_bh(&local->active_txq_lock);
>> +	f_txqi = find_txqi(local, txq->ac);
>> +	if (!f_txqi)
>> +		goto out;
>> +
>> +	/* Allow only head node to ensure fairness */
>> +	if (f_txqi != txqi)
>> +		goto out;
>> +
>> +	/* Check if txq is in negative deficit */
>> +	if (!ieee80211_txq_requeued(local, txqi))
>> +		can_tx = true;
>> +
My bad... The above check should be as below

-       if (!ieee80211_txq_requeued(local, txqi))
-               can_tx = true;
+       if (ieee80211_txq_requeued(local, txqi))
+               goto out;

+       can_tx = true;

>> +	list_del_init(&txqi->schedule_order);
> 
> Why are you removing the txq from the list here, and how do you expect
> it to get added back?
> 
Otherwise driver has to call next_txq() to dequeue the node before
processing it. If head node is not removed from list, driver can not 
process
remaining txqs from same pull request (fetch_ind()).

The node is added back in tail when txq is paused in 
ieee80211_sta_register_airtime()

-Rajkumar
