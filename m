Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58177 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab1BNInV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 03:43:21 -0500
Received: by bwz15 with SMTP id 15so5242662bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 00:43:20 -0800 (PST)
From: Jordi Pujol <jordipujolp@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: synchronize transmission routines
Date: Mon, 14 Feb 2011 09:43:13 +0100
References: <201102131531.29984.jordipujolp@gmail.com>
In-Reply-To: <201102131531.29984.jordipujolp@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_hsOWNVvZbuCotVm"
Message-Id: <201102140943.13801.jordipujolp@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_hsOWNVvZbuCotVm
Content-Type: Text/Plain;
  charset="ibm874"
Content-Transfer-Encoding: 7bit

A new version of this patch to synchronize transmission and receipt for each 
device, 

Jordi Pujol

Live never ending Tale
GNU/Linux Live forever!
http://livenet.selfip.com

--Boundary-00=_hsOWNVvZbuCotVm
Content-Type: text/x-patch;
  charset="UTF-8";
  name="rt2x00_dev_transmission_done_synchronize.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="rt2x00_dev_transmission_done_synchronize.patch"

 rt2x00: synchonize transmission_done routines by device

Signed-off-by: Jordi Pujol <jordipujolp AT gmail DOT com>

--- linux-2.6.37-old/drivers/net/wireless/rt2x00/rt2x00dev.c	2011-01-05 01:50:19.000000000 +0100
+++ linux-2.6.37/drivers/net/wireless/rt2x00/rt2x00dev.c	2011-02-13 18:03:30.324761189 +0100
@@ -271,6 +271,8 @@ void rt2x00lib_txdone(struct queue_entry
 	unsigned int i;
 	bool success;
 
+	mutex_lock(&rt2x00dev->txdone_mutex);
+
 	/*
 	 * Unmap the skb.
 	 */
@@ -415,6 +417,8 @@ void rt2x00lib_txdone(struct queue_entry
 	 */
 	if (!rt2x00queue_threshold(entry->queue))
 		ieee80211_wake_queue(rt2x00dev->hw, qid);
+
+	mutex_unlock(&rt2x00dev->txdone_mutex);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_txdone);
 
@@ -486,6 +490,8 @@ void rt2x00lib_rxdone(struct queue_entry
 	unsigned int header_length;
 	int rate_idx;
 
+	mutex_lock(&rt2x00dev->rxdone_mutex);
+
 	if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
 		goto submit_entry;
 
@@ -573,6 +579,8 @@ submit_entry:
 	rt2x00dev->ops->lib->clear_entry(entry);
 	rt2x00queue_index_inc(entry->queue, Q_INDEX);
 	rt2x00queue_index_inc(entry->queue, Q_INDEX_DONE);
+
+	mutex_unlock(&rt2x00dev->rxdone_mutex);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_rxdone);
 
@@ -972,6 +980,9 @@ int rt2x00lib_probe_dev(struct rt2x00_de
 
 	mutex_init(&rt2x00dev->csr_mutex);
 
+	mutex_init(&rt2x00dev->txdone_mutex);
+	mutex_init(&rt2x00dev->rxdone_mutex);
+
 	set_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 
 	/*
--- linux-2.6.37-old/drivers/net/wireless/rt2x00/rt2x00.h	2011-01-05 01:50:19.000000000 +0100
+++ linux-2.6.37/drivers/net/wireless/rt2x00/rt2x00.h	2011-02-13 18:02:02.480116433 +0100
@@ -908,6 +908,13 @@ struct rt2x00_dev {
 	 * Tasklet for processing tx status reports (rt2800pci).
 	 */
 	struct tasklet_struct txstatus_tasklet;
+
+	/*
+	 * Mutex to synchronize transmission.
+	 */
+	struct mutex txdone_mutex;
+	struct mutex rxdone_mutex;
+
 };
 
 /*

--Boundary-00=_hsOWNVvZbuCotVm--
