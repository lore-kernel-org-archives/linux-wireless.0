Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:8328 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbYGWVmA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 17:42:00 -0400
Received: by py-out-1112.google.com with SMTP id p76so1884014pyb.10
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 14:41:59 -0700 (PDT)
Message-ID: <1ba2fa240807231441u7b870a15rb525771e364f65f3@mail.gmail.com> (sfid-20080723_234204_666296_6D6017A3)
Date: Thu, 24 Jul 2008 00:41:57 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"David Miller" <davem@davemloft.net>
Subject: Another fragmentation multiqueue kludge
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Guy Cohen" <guy.cohen@intel.com>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is the scenario. This is happening with what we have in
wireless-testing code

When hw queue get full we call
 ieeee80211_stop_queue(dev, q);

When this is happens in the middle of the fragmentation . This is
easiest to reproduces  with fragmentation but probably happens also in
other cases.

int __ieee80211_tx()
....

if (netif_subqueue_stopped(local->mdev,
						   tx->extra_frag[i]))
				return IEEE80211_TX_FRAG_AGAIN;


The fragment should  stored into local->queues_pending[queue]
(Actually I'm not sure it is)

now when we HW queue got cleared a bit we call wake queues where
tx_pending_tasklet is woken up ( queue is not woken up here)

void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
{
	struct ieee80211_local *local = hw_to_local(hw);

	if (test_bit(queue, local->queues_pending)) {
		tasklet_schedule(&local->tx_pending_tasklet);
	}
      ..... <snip>
}

The check if the queue  is open causes that queue is actually never
woken up so traffic is stalled. However removing this line causes some
other panic I didn't have time to process.

void ieee80211_tx_pending(unsigned long data)
{
<snip>

	netif_tx_lock_bh(dev);
	for (i = 0; i < ieee80211_num_regular_queues(&local->hw); i++) {
		/* Check that this queue is ok */
		if (__netif_subqueue_stopped(local->mdev, i))
--- This line causes that fact that the actual wake queue is never
called.
			continue;

		if (!test_bit(i, local->queues_pending)) {
			ieee80211_wake_queue(&local->hw, i);
			continue;
		}
</snip>
