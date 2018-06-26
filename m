Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39280 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935416AbeFZMbc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 08:31:32 -0400
Subject: Re: [PATCH] mac80211: add stop/start logic for software TXQs
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
References: <1529997415-20551-1-git-send-email-mpubbise@codeaurora.org>
 <878t71n611.fsf@toke.dk>
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Message-ID: <5adc5faf-8af0-7af9-8261-784a7ec0e4f7@codeaurora.org> (sfid-20180626_143137_249866_CEB92BE9)
Date: Tue, 26 Jun 2018 18:01:28 +0530
MIME-Version: 1.0
In-Reply-To: <878t71n611.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 6/26/2018 4:55 PM, Toke Høiland-Jørgensen wrote:
> Manikanta Pubbisetty <mpubbise@codeaurora.org> writes:
>
>> We can still invoke netif stop/wake APIs when wake_tx_queue is
>> implemented but this could lead to packet drops in network layer;
>> adding stop/start logic for software TXQs in mac80211 instead makes
>> more sense; the change proposed adds the same in mac80211.
> I agree with the approach; having packets queued in mac80211 while the
> queues are stopped also means that CoDel can react to them when they are
> resumed again.

Agreed!!

>
>> +	list_for_each_entry_rcu(sta, &local->sta_list, list) {
>> +		if (!atomic_read(&sta->txqs_paused))
>> +			continue;
>> +
>> +		atomic_set(&sta->txqs_paused, 0);
> I'm not terribly well-versed in the kernel atomics, but doesn't the
> split of read and set kinda defeat the point of using them? Also, as
> this is under RCU, why do you need an atomic in the first place?
Valid point, txqs_paused is set in ieee80211_tx_dequeue; I was thinking 
a case where tx_dequeue is called without rcu_read_lock but seems that 
is not the case. All drivers using wake_tx_queue seems are using 
rcu_read_lock before tx_dequeue; can there be a case where tx_dequeue is 
called without rcu_read_lock?

Manikanta
