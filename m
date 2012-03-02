Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:41794 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030227Ab2CBPci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 10:32:38 -0500
Message-ID: <4F50E814.3070400@stericsson.com> (sfid-20120302_163242_176670_F70ECA57)
Date: Fri, 2 Mar 2012 16:32:36 +0100
From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 07/21] cw1200: queue.*, implementation of TX queues of
 the cw1200 driver.
References: <d53e019b1a0bcd29c2c367fbe5665413f2d33938-submit>  <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>  <1330652495-25837-8-git-send-email-dmitry.tarnyagin@stericsson.com>  (sfid-20120302_024202_033691_19CC47E6) <1330677233.3367.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1330677233.3367.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On Fri, 2012-03-02 at 02:41 +0100, Dmitry Tarnyagin wrote:
>> +static inline void __cw1200_queue_lock(struct cw1200_queue *queue)
>> +{
>> +	struct cw1200_queue_stats *stats = queue->stats;
>> +	if (queue->tx_locked_cnt++ == 0) {
> Is there some common lock that prevents this getting corrupted? mac80211
> and higher layers do not have any synchronisation between the different
> TX queues, and you'll need to call this from a few places ... maybe it
> needs to be atomic_t?
>
>
__cw1200_queue_lock is always protected by spin_lock_bh(&queue->lock);

Dmitry.

