Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49020 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751483AbeACLfo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Jan 2018 06:35:44 -0500
Date: Wed, 3 Jan 2018 12:35:41 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Enrico Mioso <mrkiko.rs@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        nbd@nbd.name
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20180103113540.GA10306@redhat.com> (sfid-20180103_123548_324482_710BA23E)
References: <alpine.LNX.2.21.99.1712112132480.7817@localhost.localdomain>
 <20171213152017.GA3554@redhat.com>
 <alpine.LNX.2.21.99.1712161924030.11214@localhost.localdomain>
 <20171218152142.GA15414@redhat.com>
 <20171219122707.GA2672@redhat.com>
 <alpine.LNX.2.21.99.1712191341570.2555@localhost.localdomain>
 <20171219125431.GB2672@redhat.com>
 <alpine.LNX.2.21.99.1712201848250.21776@localhost.localdomain>
 <20171221142558.GB4655@redhat.com>
 <alpine.LNX.2.21.99.1712241311370.28605@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LNX.2.21.99.1712241311370.28605@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Sun, Dec 24, 2017 at 01:19:06PM +0100, Enrico Mioso wrote:
> Unfortunately, the error di appear again. Still, I experienced no stalls.
> But i am starting to think this doesn't happen necessarily when a device is going out of range. Now I think I don't know when this triggers.

<sni>
> Sun Dec 24 10:10:50 2017 authpriv.info dropbear[840]: Exit (root): Disconnect received
> Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.616638] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
> Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.626106] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
> Sun Dec 24 11:04:33 2017 kern.err kernel: [ 1510.635562] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2

I would also try bigger threshold for waking queue like
in below patch for those errors:

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 357c0941aaad..b8bdf57ed7ea 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -416,7 +416,7 @@ static void rt2x00lib_clear_entry(struct rt2x00_dev *rt2x00dev,
 	 * before it was stopped.
 	 */
 	spin_lock_bh(&entry->queue->tx_lock);
-	if (!rt2x00queue_threshold(entry->queue))
+	if (rt2x00queue_available(queue) > 2*queue->threshold)
 		rt2x00queue_unpause_queue(entry->queue);
 	spin_unlock_bh(&entry->queue->tx_lock);
 }
