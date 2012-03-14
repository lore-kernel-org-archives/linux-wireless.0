Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030733Ab2CNKQm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 06:16:42 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/5] rt2x00: rt2800usb: move additional txdone into new function
Date: Wed, 14 Mar 2012 11:16:17 +0100
Message-Id: <1331720181-18564-1-git-send-email-sgruszka@redhat.com> (sfid-20120314_111646_064271_AE1905FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 2c11137..8e1855a 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -528,15 +528,11 @@ static void rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
-static void rt2800usb_work_txdone(struct work_struct *work)
+static void rt2800usb_txdone_nostatus(struct rt2x00_dev *rt2x00dev)
 {
-	struct rt2x00_dev *rt2x00dev =
-	    container_of(work, struct rt2x00_dev, txdone_work);
 	struct data_queue *queue;
 	struct queue_entry *entry;
 
-	rt2800usb_txdone(rt2x00dev);
-
 	/*
 	 * Process any trailing TX status reports for IO failures,
 	 * we loop until we find the first non-IO error entry. This
@@ -560,6 +556,16 @@ static void rt2800usb_work_txdone(struct work_struct *work)
 				break;
 		}
 	}
+}
+
+static void rt2800usb_work_txdone(struct work_struct *work)
+{
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(work, struct rt2x00_dev, txdone_work);
+
+	rt2800usb_txdone(rt2x00dev);
+
+	rt2800usb_txdone_nostatus(rt2x00dev);
 
 	/*
 	 * The hw may delay sending the packet after DMA complete
-- 
1.7.1

