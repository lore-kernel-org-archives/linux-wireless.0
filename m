Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36491 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1BMObe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Feb 2011 09:31:34 -0500
Received: by bwz15 with SMTP id 15so4697493bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Feb 2011 06:31:33 -0800 (PST)
From: Jordi Pujol <jordipujolp@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] rt2x00: synchronize transmission routines
Date: Sun, 13 Feb 2011 15:31:29 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Bt+VN0iS9l5r2Jn"
Message-Id: <201102131531.29984.jordipujolp@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_Bt+VN0iS9l5r2Jn
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello,

This patch will synchronize the transmission routines of rt2x00lib to avoid 
processing interferences in systems with multiple execution threads.
Has been tested on an AMD 64 X2 6000 running Debian unstable
and a custom x86_64 kernel at version 2.6.37
The Wireless adapter is a D-Link USB,
 ID 07d1:3c03 D-Link System AirPlus G DWL-G122 Wireless Adapter(rev.C1) 
[Ralink RT73]

Now It works a lot better.

*** BEGIN PATCH
 rt2x00: synchonize transmission_done routines

Signed-off-by: Jordi Pujol <jordipujolp AT gmail DOT com>

--- linux-2.6.37-old/drivers/net/wireless/rt2x00/rt2x00dev.c	2011-01-05 
01:50:19.000000000 +0100
+++ linux-2.6.37/drivers/net/wireless/rt2x00/rt2x00dev.c	2011-02-12 
14:59:58.043409531 +0100
@@ -258,6 +258,11 @@ void rt2x00lib_dmadone(struct queue_entr
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_dmadone);
 
+/*
+ * rt2x00lib_txdone_mutex: synchonize rt2x00lib_txdone
+ */
+static DEFINE_MUTEX(rt2x00lib_txdone_mutex);
+
 void rt2x00lib_txdone(struct queue_entry *entry,
 		      struct txdone_entry_desc *txdesc)
 {
@@ -271,6 +276,8 @@ void rt2x00lib_txdone(struct queue_entry
 	unsigned int i;
 	bool success;
 
+	mutex_lock(&rt2x00lib_txdone_mutex);
+
 	/*
 	 * Unmap the skb.
 	 */
@@ -415,6 +422,8 @@ void rt2x00lib_txdone(struct queue_entry
 	 */
 	if (!rt2x00queue_threshold(entry->queue))
 		ieee80211_wake_queue(rt2x00dev->hw, qid);
+
+	mutex_unlock(&rt2x00lib_txdone_mutex);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_txdone);
 
@@ -486,6 +486,11 @@ static int rt2x00lib_rxdone_read_signal(
 	return 0;
 }
 
+/*
+ * rt2x00lib_rxdone_mutex: synchonize rt2x00lib_rxdone
+ */
+static DEFINE_MUTEX(rt2x00lib_rxdone_mutex);
+
 void rt2x00lib_rxdone(struct queue_entry *entry)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
@@ -495,6 +500,8 @@ void rt2x00lib_rxdone(struct queue_entry
 	unsigned int header_length;
 	int rate_idx;
 
+	mutex_lock(&rt2x00lib_rxdone_mutex);
+
 	if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
 		goto submit_entry;
 
@@ -582,6 +589,8 @@ submit_entry:
 	rt2x00dev->ops->lib->clear_entry(entry);
 	rt2x00queue_index_inc(entry->queue, Q_INDEX);
 	rt2x00queue_index_inc(entry->queue, Q_INDEX_DONE);
+
+	mutex_unlock(&rt2x00lib_rxdone_mutex);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_rxdone);
 
*** END PATCH

Kind regards,

Jordi Pujol

Live never ending Tale
GNU/Linux Live forever!
http://livenet.selfip.com

--Boundary-00=_Bt+VN0iS9l5r2Jn
Content-Type: text/x-patch;
  charset="UTF-8";
  name="rt2x00lib_transmission_done_synchronize.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="rt2x00lib_transmission_done_synchronize.patch"

 rt2x00: synchonize transmission_done routines

Signed-off-by: Jordi Pujol <jordipujolp AT gmail DOT com>

--- linux-2.6.37-old/drivers/net/wireless/rt2x00/rt2x00dev.c	2011-01-05 01:50:19.000000000 +0100
+++ linux-2.6.37/drivers/net/wireless/rt2x00/rt2x00dev.c	2011-02-12 14:59:58.043409531 +0100
@@ -258,6 +258,11 @@ void rt2x00lib_dmadone(struct queue_entr
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_dmadone);
 
+/*
+ * rt2x00lib_txdone_mutex: synchonize rt2x00lib_txdone
+ */
+static DEFINE_MUTEX(rt2x00lib_txdone_mutex);
+
 void rt2x00lib_txdone(struct queue_entry *entry,
 		      struct txdone_entry_desc *txdesc)
 {
@@ -271,6 +276,8 @@ void rt2x00lib_txdone(struct queue_entry
 	unsigned int i;
 	bool success;
 
+	mutex_lock(&rt2x00lib_txdone_mutex);
+
 	/*
 	 * Unmap the skb.
 	 */
@@ -415,6 +422,8 @@ void rt2x00lib_txdone(struct queue_entry
 	 */
 	if (!rt2x00queue_threshold(entry->queue))
 		ieee80211_wake_queue(rt2x00dev->hw, qid);
+
+	mutex_unlock(&rt2x00lib_txdone_mutex);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_txdone);
 
@@ -486,6 +486,11 @@ static int rt2x00lib_rxdone_read_signal(
 	return 0;
 }
 
+/*
+ * rt2x00lib_rxdone_mutex: synchonize rt2x00lib_rxdone
+ */
+static DEFINE_MUTEX(rt2x00lib_rxdone_mutex);
+
 void rt2x00lib_rxdone(struct queue_entry *entry)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
@@ -495,6 +500,8 @@ void rt2x00lib_rxdone(struct queue_entry
 	unsigned int header_length;
 	int rate_idx;
 
+	mutex_lock(&rt2x00lib_rxdone_mutex);
+
 	if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
 		goto submit_entry;
 
@@ -582,6 +589,8 @@ submit_entry:
 	rt2x00dev->ops->lib->clear_entry(entry);
 	rt2x00queue_index_inc(entry->queue, Q_INDEX);
 	rt2x00queue_index_inc(entry->queue, Q_INDEX_DONE);
+
+	mutex_unlock(&rt2x00lib_rxdone_mutex);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_rxdone);
 

--Boundary-00=_Bt+VN0iS9l5r2Jn--
