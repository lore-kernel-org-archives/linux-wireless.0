Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:21396 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756128Ab3AXVAs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 16:00:48 -0500
Date: Thu, 24 Jan 2013 22:01:10 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH 3/4] rt2800usb: move "TX status missed" messages to debug
 level
Message-ID: <20130124210110.GB22800@localhost.localdomain> (sfid-20130124_220051_544538_428A5A52)
References: <20130124205931.GB16252@localhost.localdomain>
 <20130124210028.GA22800@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130124210028.GA22800@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Those messages can flood in dmesg, so do not print them by default.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 011410f..047ead5 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -540,9 +540,9 @@ rt2800usb_txdone_entry_check(struct queue_entry *entry, u32 reg)
 	tx_pid  = rt2x00_get_field32(word, TXWI_W1_PACKETID);
 
 	if (wcid != tx_wcid || ack != tx_ack || (!is_agg && pid != tx_pid)) {
-		WARNING(entry->queue->rt2x00dev,
-			"TX status report missed for queue %d entry %d\n",
-			entry->queue->qid, entry->entry_idx);
+		DEBUG(entry->queue->rt2x00dev,
+		      "TX status report missed for queue %d entry %d\n",
+		      entry->queue->qid, entry->entry_idx);
 		return TXDONE_UNKNOWN;
 	}
 
-- 
1.7.4.4

