Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.infomaniak.ch ([84.16.68.89]:39330 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbZERNJS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 09:09:18 -0400
From: Alexandre Becholey <alexandre.becholey@epfl.ch>
To: linux-wireless@vger.kernel.org
Cc: Alexandre Becholey <alexandre.becholey@epfl.ch>
Subject: [PATCH]rt73usb: fix for master mode.
Date: Mon, 18 May 2009 14:55:36 +0200
Message-Id: <1242651336-12621-1-git-send-email-alexandre.becholey@epfl.ch>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.6.3"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------1.6.3
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit

Report status unknown as if there were successfully transmitted.
This will avoid hostapd to disassociate because it doesn't understand what a status unknown is.

Signed-off-by: Alexandre Becholey <alexandre.becholey@epfl.ch>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


--------------1.6.3
Content-Type: text/x-patch; name="0001-rt73usb-fix-for-master-mode.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="0001-rt73usb-fix-for-master-mode.patch"

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index f227084..0bbee06 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -280,6 +280,9 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK)) {
 		if (test_bit(TXDONE_SUCCESS, &txdesc->flags))
 			tx_info->flags |= IEEE80211_TX_STAT_ACK;
+                /* Report unkown status as if it was success */
+                else if (test_bit(TXDONE_UNKNOWN, &txdesc->flags))
+                        tx_info->flags |= IEEE80211_TX_STAT_ACK;
 		else if (test_bit(TXDONE_FAILURE, &txdesc->flags))
 			rt2x00dev->low_level_stats.dot11ACKFailureCount++;
 	}

--------------1.6.3--


