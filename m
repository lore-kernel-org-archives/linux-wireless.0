Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36257 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab2B2IbM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 03:31:12 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Luciano Coelho <coelho@ti.com>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/7] wl12xx: reset link Tx queues when freeing it
References: <1330382494-31148-1-git-send-email-arik@wizery.com>
	<1330382494-31148-3-git-send-email-arik@wizery.com>
	<1330422678.18637.28.camel@cumari>
Date: Wed, 29 Feb 2012 10:31:10 +0200
In-Reply-To: <1330422678.18637.28.camel@cumari> (Luciano Coelho's message of
	"Tue, 28 Feb 2012 11:51:18 +0200")
Message-ID: <87pqcyavn5.fsf@purkki.adurom.net> (sfid-20120229_093122_120362_BD89D2DA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <coelho@ti.com> writes:

>> @@ -973,8 +974,14 @@ void wl12xx_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
>>  	struct sk_buff *skb;
>>  	struct ieee80211_tx_info *info;
>>  
>> -	for (i = 0; i < NUM_TX_QUEUES; i++)
>> -		wl->tx_queue_count[i] = 0;
>> +	/* only reset the queues if something bad happened */
>> +	if (WARN_ON(wl1271_tx_total_queue_count(wl) != 0)) {
>
> Let's make all these WARN_ONs as WARN_ON_ONCE as it is recommended
> nowadays.  This will make Kalle Valo happier. :)

Hehe. Actually the dislike against WARN_ON() was started by John, I
again started the war to killing BUG_ON() :)

But nevertheless, this changes makes also me happy. I have seen cases
where the whole system reboots because of WARN_ON() spam, so
WARN_ON_ONCE() is much better in in cases where's a possibility that it
will get printed a lot. Of course printk_ratelimit() is another option,
but for some reason it isn't that popular.

-- 
Kalle Valo
