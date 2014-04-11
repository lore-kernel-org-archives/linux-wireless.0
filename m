Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:62329 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaDKGcC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2014 02:32:02 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFTv2 3/5] ath10k: rework peer accounting
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-4-git-send-email-michal.kazior@tieto.com>
	<87k3axhdqc.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=c+dTcK_diBKi6VJVgUkyBv21bDkRf+9GvGyhhqqMuNQ@mail.gmail.com>
Date: Fri, 11 Apr 2014 09:31:56 +0300
In-Reply-To: <CA+BoTQ=c+dTcK_diBKi6VJVgUkyBv21bDkRf+9GvGyhhqqMuNQ@mail.gmail.com>
	(Michal Kazior's message of "Thu, 10 Apr 2014 09:11:13 +0200")
Message-ID: <87mwfsfkbn.fsf@kamboji.qca.qualcomm.com> (sfid-20140411_083207_333616_BB8E6D78)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 10 April 2014 08:59, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> It was troublesome to iterate over peers and
>>> perform sleepable calls. This will be necessary
>>> for some upcomming changes to tx flushing.
>>>
>>> Make peer allocation and initial setup
>>> protected by both ar->conf_mutex and
>>> ar->data_lock. This way it's possible to iterate
>>> over peers with conf_mutex and call sleepable
>>> functions.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>
>> First comments, but I need to read this much more carefully still:
>>
>>> --- a/drivers/net/wireless/ath/ath10k/core.h
>>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>>> @@ -199,9 +199,14 @@ struct ath10k_dfs_stats {
>>>  #define ATH10K_MAX_NUM_PEER_IDS (1 << 11) /* htt rx_desc limit */
>>>
>>>  struct ath10k_peer {
>>> +     /* protected by conf_mutex + data_lock */
>>>       struct list_head list;
>>
>> This really needs a lot more documentation. And besides, don't we
>> actually want to protect struct ath10k::peers, not this?
>
> Parts of the structure needs to be locked differently.
>
> I suppose we can say we just protect everything with data_lock except
> `struct list_head list` which needs to be write-protected by both
> conf_mutex and data_lock. But then again, addr and vdev_id don't need
> any locking as they are immutable (and set before adding to the list).

I guess this depends from the point of view. In my opinion struct
ath10k::peers is the actual list and that's why the main documentation
needs to be above struct ath10k::peers field. And I would guess that's
there most people check there for documentation first.

But if we have special rules within struct ath10k_peer (excluding the
list field), we can document that within struct ath10k_peer.

-- 
Kalle Valo
