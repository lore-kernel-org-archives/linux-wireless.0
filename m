Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab2GDLKj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 07:10:39 -0400
Date: Wed, 4 Jul 2012 13:10:02 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Franco Miceli <fmiceli@plan.ceibal.edu.uy>,
	Tom Horsley <horsley1953@gmail.com>
Subject: [PATCH 3.5] rt2x00usb: fix indexes ordering on RX queue kick
Message-ID: <20120704111001.GA2570@redhat.com> (sfid-20120704_131042_932907_048DEB97)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On rt2x00_dmastart() we increase index specified by Q_INDEX and on
rt2x00_dmadone() we increase index specified by Q_INDEX_DONE. So entries
between Q_INDEX_DONE and Q_INDEX are those we currently process in the
hardware. Entries between Q_INDEX and Q_INDEX_DONE are those we can
submit to the hardware.

According to that fix rt2x00usb_kick_queue(), as we need to submit RX
entries that are not processed by the hardware. It worked before only
for empty queue, otherwise was broken.

Note that for TX queues indexes ordering are ok. We need to kick entries
that have filled skb, but was not submitted to the hardware, i.e.
started from Q_INDEX_DONE and have ENTRY_DATA_PENDING bit set.

>From practical standpoint this fixes RX queue stall, usually reproducible
in AP mode, like for example reported here:
https://bugzilla.redhat.com/show_bug.cgi?id=828824

Reported-and-tested-by: Franco Miceli <fmiceli@plan.ceibal.edu.uy>
Reported-and-tested-by: Tom Horsley <horsley1953@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index d357d1e..74ecc33 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -436,8 +436,8 @@ void rt2x00usb_kick_queue(struct data_queue *queue)
 	case QID_RX:
 		if (!rt2x00queue_full(queue))
 			rt2x00queue_for_each_entry(queue,
-						   Q_INDEX_DONE,
 						   Q_INDEX,
+						   Q_INDEX_DONE,
 						   NULL,
 						   rt2x00usb_kick_rx_entry);
 		break;
-- 
1.7.1

