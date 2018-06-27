Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:46927 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752187AbeF0M2X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 08:28:23 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add stop/start logic for software TXQs
In-Reply-To: <5adc5faf-8af0-7af9-8261-784a7ec0e4f7@codeaurora.org>
References: <1529997415-20551-1-git-send-email-mpubbise@codeaurora.org> <878t71n611.fsf@toke.dk> <5adc5faf-8af0-7af9-8261-784a7ec0e4f7@codeaurora.org>
Date: Wed, 27 Jun 2018 14:28:24 +0200
Message-ID: <87tvpol8gn.fsf@toke.dk> (sfid-20180627_142827_257365_36AA72D1)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Manikanta Pubbisetty <mpubbise@codeaurora.org> writes:

> On 6/26/2018 4:55 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Manikanta Pubbisetty <mpubbise@codeaurora.org> writes:
>>
>>> We can still invoke netif stop/wake APIs when wake_tx_queue is
>>> implemented but this could lead to packet drops in network layer;
>>> adding stop/start logic for software TXQs in mac80211 instead makes
>>> more sense; the change proposed adds the same in mac80211.
>> I agree with the approach; having packets queued in mac80211 while the
>> queues are stopped also means that CoDel can react to them when they are
>> resumed again.
>
> Agreed!!
>
>>
>>> +	list_for_each_entry_rcu(sta, &local->sta_list, list) {
>>> +		if (!atomic_read(&sta->txqs_paused))
>>> +			continue;
>>> +
>>> +		atomic_set(&sta->txqs_paused, 0);
>> I'm not terribly well-versed in the kernel atomics, but doesn't the
>> split of read and set kinda defeat the point of using them? Also, as
>> this is under RCU, why do you need an atomic in the first place?
> Valid point, txqs_paused is set in ieee80211_tx_dequeue; I was thinking=20
> a case where tx_dequeue is called without rcu_read_lock but seems that=20
> is not the case. All drivers using wake_tx_queue seems are using=20
> rcu_read_lock before tx_dequeue; can there be a case where tx_dequeue is=
=20
> called without rcu_read_lock?

I'm pretty sure we would have other problems if there were... :)

-Toke
