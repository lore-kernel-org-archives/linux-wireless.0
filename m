Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59072 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758034Ab3CSJwn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 05:52:43 -0400
Received: from mailout-de.gmx.net ([10.1.76.34]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0LobVE-1Uty8A0mmw-00gZe2 for
 <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 10:52:40 +0100
Date: Tue, 19 Mar 2013 10:52:35 +0100
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: linux-wireless@vger.kernel.org
Cc: Daniel Mack <daniel@zonque.org>
Subject: mwifiex: infinite loop in mwifiex_main_process
Message-ID: <20130319095235.GA22962@blumentopf> (sfid-20130319_105403_800348_5CDDF0A1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm working on this, currently testing it
http://www.mail-archive.com/linux-mmc@vger.kernel.org/msg17726.html

Within less than 3 days, the module always crashes. I observe
that mwifiex is looping in mwifiex_main_process, not exiting. The
loop is always entered from the sdio_irq_thread.

I put printk statement to find cause for why it's not exiting:

[18017.211513] scan processing 0
[18017.214686] data sent 0
[18017.217269] ps state 0
[18017.219765] cmd sent 0 / curr cmd   (null)
[18017.224134] is_command_pending 0
[18017.227548] wmm list empty 0
[18017.230592] tx_lock_flag 0

So it seems the wmm list has packets queued, but they are never
sent out. Adding a few more statements, it seems the problem is
in mwifiex_wmm_get_highest_priolist_ptr:

	for (j = adapter->priv_num - 1; j >= 0; --j) {

		spin_lock_irqsave(&adapter->bss_prio_tbl[j].bss_prio_lock,
				flags);
		is_list_empty = list_empty(&adapter->bss_prio_tbl[j]
				.bss_prio_head);
		spin_unlock_irqrestore(&adapter->bss_prio_tbl[j].bss_prio_lock,
				flags);
		if (is_list_empty)
			continue;

		.... <snip> ...

		do {                                                                               
			priv_tmp = bssprio_node->priv;
			hqp = &priv_tmp->wmm.highest_queued_prio;

			for (i = atomic_read(hqp); i >= LOW_PRIO_TID;
					--i) {                     
			...
			... NEVER REACHED ...
			...


So there are packets queued, but the highest_queued_prio is too
low, so they are never sent out.

I was never able to crash it without my patches, though trying
harder now. But maybe my patches only trigger the issue more
often.

Is there a known issue, with highest_queued_prio getting out of
sync with the number of packets queued?

rgds,
Andi

