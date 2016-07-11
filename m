Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39132 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbcGKNz7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 09:55:59 -0400
Subject: Re: [PATCH ath9k-txq-work 1/2] ath9k: fix powersave wakeup
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
References: <20160711130405.77451-1-nbd@nbd.name> <871t30wabu.fsf@toke.dk>
Cc: linux-wireless@vger.kernel.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <42df3d55-9d6c-5f45-0ae8-b5d7ef93d34a@nbd.name> (sfid-20160711_155603_780426_DBD05246)
Date: Mon, 11 Jul 2016 15:55:55 +0200
MIME-Version: 1.0
In-Reply-To: <871t30wabu.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-07-11 15:52, Toke Høiland-Jørgensen wrote:
> Felix Fietkau <nbd@nbd.name> writes:
> 
>> drv_wake_tx_queue will only call into the driver if there are frames
>> pending in the mac80211 queue. the driver needs to take care of its own
>> queued frames
> 
> Thanks, makes sense. What's the proper etiquette here? Do I roll these
> up into a v4 (possibly with other changes that show up along the way),
> or do they go in as separate patches?
You need to roll them in, otherwise your patch is going to cause
regressions when it gets merged.

- Felix
