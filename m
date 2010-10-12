Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44874 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab0JLIyE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 04:54:04 -0400
Received: by wye20 with SMTP id 20so1182880wye.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 01:53:59 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Subject: [PATCH v2 0/4] wl1271: TX optimizations & fixes
Date: Tue, 12 Oct 2010 10:53:49 +0200
Message-Id: <1286873633-10080-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patches fix some issues in the TX path, as well as optimize it.

The first patch fixes an issue in wl1271_tx_work. In case the aggregation
buffer is completely filled, the content of the buffer is transferred and no
more packets are sent. Fixed by flushing the buffer and continue aggregating
packets.

The second patch solves a TX starvation issue in wl1271_irq_work. Since TX is
handled by wl1271_tx_work, packets are transmitted after all interrupts are
handled in wl1271_irq_work. Since these include TX completion interrupts the
FW status might be read multiple times needlessly, which could hurt performance.

The third patch is more of a cosmetic change. Instead of traversing the array
of TX descriptors in order to find a free entry, use a bitmap for that
purpose.

The last patch fixes an issue with the TX queue low watermark. The number of
items in the TX queue is checked against the low watermark in
wl1271_tx_complete. However, the fact that a TX completion interrupt was fired
does not necessarily mean that there are any less skbs in the TX queue. Fixed
by moving the handling logic to the TX work, after skbs are actually dequeued.

These patches were tested on a Zoom2 platform (SDIO only). While throughput in
RX scenarios was hardly affected, throughput in TX scenarios was significantly
improved.

Changes from v1:
- Fix a theoretical potential deadlock in irq_work and tx_work. Instead of
  cancelling redundant work, avoid scheduling it in the first place.
- Check if the low watermark was reached only if skbs were really dequeued

Ido Yariv (4):
  wl1271: TX aggregation optimization
  wl1271: Fix TX starvation
  wl1271: Allocate TX descriptors more efficiently
  wl1271: Fix TX queue low watermark handling

 drivers/net/wireless/wl12xx/wl1271.h      |    2 +
 drivers/net/wireless/wl12xx/wl1271_main.c |   20 ++++-
 drivers/net/wireless/wl12xx/wl1271_tx.c   |  114 ++++++++++++++++++----------
 drivers/net/wireless/wl12xx/wl1271_tx.h   |    1 +
 4 files changed, 92 insertions(+), 45 deletions(-)

