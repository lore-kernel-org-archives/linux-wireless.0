Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:1910 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbYLTKCS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 05:02:18 -0500
Received: by nf-out-0910.google.com with SMTP id d3so189866nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2008 02:02:17 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 12/15] Allow drivers to pass the noise value during rxdone
Date: Sat, 20 Dec 2008 10:59:29 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200812201052.00655.IvDoorn@gmail.com> <200812201058.33821.IvDoorn@gmail.com> <200812201059.02959.IvDoorn@gmail.com>
In-Reply-To: <200812201059.02959.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812201059.30095.IvDoorn@gmail.com> (sfid-20081220_110905_007417_EC23AC93)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    1 +
 drivers/net/wireless/rt2x00/rt2x00queue.h |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 3cb417f..841879d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -407,6 +407,7 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 	rx_status->rate_idx = idx;
 	rx_status->qual = rt2x00link_calculate_signal(rt2x00dev, rxdesc.rssi);
 	rx_status->signal = rxdesc.rssi;
+	rx_status->noise = rxdesc.noise;
 	rx_status->flag = rxdesc.flags;
 	rx_status->antenna = rt2x00dev->link.ant.active.rx;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 5a9d2c3..1bd1a95 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -165,6 +165,7 @@ enum rxdone_entry_desc_flags {
  * @timestamp: RX Timestamp
  * @signal: Signal of the received frame.
  * @rssi: RSSI of the received frame.
+ * @noise: Measured noise during frame reception.
  * @size: Data size of the received frame.
  * @flags: MAC80211 receive flags (See &enum mac80211_rx_flags).
  * @dev_flags: Ralink receive flags (See &enum rxdone_entry_desc_flags).
@@ -177,6 +178,7 @@ struct rxdone_entry_desc {
 	u64 timestamp;
 	int signal;
 	int rssi;
+	int noise;
 	int size;
 	int flags;
 	int dev_flags;
-- 
1.5.6.1

