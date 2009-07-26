Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost06.isp.att.net ([207.115.11.56]:59044 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbZGZWv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2009 18:51:58 -0400
Message-ID: <4A6CDE26.3000409@lwfinger.net>
Date: Sun, 26 Jul 2009 17:52:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Possible BUG where mac80211 fails to stop queues
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While stress testing the newest version of the open-source firmware
for BCM43XX devices with the latest pull of wireless-testing, I ran
into a problem of DMA TX queue overrun. Initially I thought this was
due to the firmware change; however, I got the same error with the
standard firmware. I have not seen this before, but it may not be a
regression as it seems to occur only under special circumstances.

The critical code is in b43_dma_tx(), which is called by the .tx
callback routine registered with mac80211.

After the fragment is transmitted by a call to dma_tx_fragment() at
line 1353, the routine checks to see if there are sufficient free
slots (2) to transmit another fragment using the code below:

        if ((free_slots(ring) < TX_SLOTS_PER_FRAME) ||
            should_inject_overflow(ring)) {
                /* This TX ring is full. */
                ieee80211_stop_queue(dev->wl->hw,
				skb_get_queue_mapping(skb));
                ring->stopped = 1;
                if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
                        b43dbg(dev->wl, "Stopped TX ring %d\n",
			       ring->index);
                }
        }


The problem shows up at line 1340 for the next fragment:

       B43_WARN_ON(ring->stopped);

        if (unlikely(free_slots(ring) < TX_SLOTS_PER_FRAME)) {
                b43warn(dev->wl, "DMA queue overflow\n");
                err = -ENOSPC;
                goto out_unlock;
        }

The system generates the warning for ring->stopped and prints the "DMA
queue overflow" message.

My understanding is that mac80211 serializes the calls for each TX
queue, and that the TX callback should not have been entered for this
case.

If I am not understanding the way that mac80211 works, please correct
me. I would also appreciate any suggestions for further debugging.

Larry
