Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:61585 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755564AbZBYQAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 11:00:36 -0500
Message-ID: <49A56B1F.80702@lwfinger.net> (sfid-20090225_170040_287347_B4C9A5E2)
Date: Wed, 25 Feb 2009 10:00:31 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	Lorenzo Nava <navalorenx@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Latest test  with open-source firmware
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Francesco and Lorenzo,

In my latest test, I cut the RX and TX queue depths to 32 and ran my usual
stress test. This time I logged whenever there was an increase in the depth of
the txstatus queue, and whenever the queue depth was 16. The results were as
follows:

Feb 24 19:27:08 mtech kernel: b43: Max Queue depth is now 2
Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 3
Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 4
Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 5
Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 6
Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 7
Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 8
Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 9
Feb 24 19:27:12 mtech kernel: b43: Max Queue depth is now 10
Feb 24 19:28:46 mtech kernel: b43: Max Queue depth is now 11
Feb 25 00:07:19 mtech kernel: b43: Max Queue depth is now 12
Feb 25 00:07:19 mtech kernel: b43: Max Queue depth is now 13
Feb 25 00:09:12 mtech kernel: b43: Max Queue depth is now 14
Feb 25 00:09:50 mtech kernel: b43: Max Queue depth is now 15
Feb 25 00:09:50 mtech kernel: b43: Max Queue depth is now 16
Feb 25 00:09:50 mtech kernel: b43: Max queue depth at 16
Feb 25 00:09:54 mtech kernel: b43: Max queue depth at 16
Feb 25 00:10:55 mtech kernel: b43: Max queue depth at 16
Feb 25 00:26:24 mtech kernel: eth1: No ProbeResp from current AP
00:1a:70:46:ba:b1 - assume out of range

The 00:26:24 event was the interface going offline. That happens with
proprietary firmware, thus I think that problem is with the driver, rather than
the firmware. In any case, I got no out-of-order cookies or poisoned skb's.
There were no dropped packets nor PHY transmission errors. The above list is all
the b43 messages in the log.

I have reset the RX queue depth to the original value of 64 and have started
another test. I would expect this change to have no effect, but I'll keep you
informed.

Larry
