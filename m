Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:38346 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbXIPMIV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:08:21 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1643781wah
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:08:21 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 15/24] rt2x00: Beacon ring entries should have QID_MGMT
Date: Sun, 16 Sep 2007 14:19:04 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161419.06153.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Put the QID values into a define, and make sure
that Beacon and ATIM rings are assigned a value of
13 (QID_MGMT) instead of 15 (QID_OTHER)

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c  |    5 ++++-
 drivers/net/wireless/rt2x00/rt2x00ring.h |    6 ++++++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 7730d9d..6992727 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -422,8 +422,11 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 */
 	if (control->queue < rt2x00dev->hw->queues)
 		desc.queue = control->queue;
+	else if (control->queue == IEEE80211_TX_QUEUE_BEACON ||
+		 control->queue == IEEE80211_TX_QUEUE_AFTER_BEACON)
+		desc.queue = QUEUE_MGMT;
 	else
-		desc.queue = 15;
+		desc.queue = QUEUE_OTHER;
 
 	/*
 	 * Read required fields from ieee80211 header.
diff --git a/drivers/net/wireless/rt2x00/rt2x00ring.h b/drivers/net/wireless/rt2x00/rt2x00ring.h
index 78e128a..122c752 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ring.h
+++ b/drivers/net/wireless/rt2x00/rt2x00ring.h
@@ -54,7 +54,13 @@ struct data_entry_desc {
 #define ENTRY_TXD_REQ_TIMESTAMP	5
 #define ENTRY_TXD_BURST		6
 
+/*
+ * Queue ID. ID's 0-4 are data TX rings
+ */
 	int queue;
+#define QUEUE_MGMT		13
+#define QUEUE_RX		14
+#define QUEUE_OTHER		15
 
 	/*
 	 * PLCP values.
-- 
1.5.3
