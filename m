Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:53844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbYCIVvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:51:07 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1676623fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:51:06 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 12/24] rt2x00: Upgrade queue->lock to use irqsave
Date: Sun, 9 Mar 2008 22:44:30 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092244.30512.IvDoorn@gmail.com> (sfid-20080309_215528_535843_AA67A281)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The queue->lock could be grabbed from interrupt context,
which could lead to lockdep panic like this:

kernel: ======================================================
kernel: [ INFO: soft-safe -> soft-unsafe lock order detected ]
kernel: 2.6.25-0.95.rc4.fc9 #1
kernel: ------------------------------------------------------
kernel: rt2500pci/1251 [HC0[0]:SC0[1]:HE1:SE0] is trying to acquire:
kernel:  (&queue->lock){--..}, at: [<ffffffff88213339>] rt2x00queue_get_entry+0x5a/0x81 [rt2x00lib]
kernel:
kernel: and this task is already holding:
kernel:  (_xmit_IEEE80211){-...}, at: [<ffffffff8122e9a3>] __qdisc_run+0x84/0x1a9
kernel: which would create a new lock dependency:
kernel:  (_xmit_IEEE80211){-...} -> (&queue->lock){--..}
kernel:
kernel: but this new dependency connects a soft-irq-safe lock:
kernel:  (_xmit_ETHER){-+..}
kernel: ... which became soft-irq-safe at:
kernel:   [<ffffffffffffffff>] 0xffffffffffffffff
kernel:
kernel: to a soft-irq-unsafe lock:
kernel:  (&queue->lock){--..}
kernel: ... which became soft-irq-unsafe at:
kernel: ...  [<ffffffff810545a2>] __lock_acquire+0x62d/0xd63
kernel:   [<ffffffff81054d36>] lock_acquire+0x5e/0x78
kernel:   [<ffffffff812a1497>] _spin_lock+0x26/0x53
kernel:   [<ffffffff88212f98>] rt2x00queue_reset+0x16/0x40 [rt2x00lib]
kernel:   [<ffffffff88212fd4>] rt2x00queue_alloc_entries+0x12/0xab [rt2x00lib]
kernel:   [<ffffffff88213091>] rt2x00queue_initialize+0x24/0xf2 [rt2x00lib]
kernel:   [<ffffffff88212036>] rt2x00lib_start+0x3b/0xd4 [rt2x00lib]
kernel:   [<ffffffff88212609>] rt2x00mac_start+0x18/0x1a [rt2x00lib]
kernel:   [<ffffffff881b9a4b>] ieee80211_open+0x1f3/0x46d [mac80211]
kernel:   [<ffffffff8121d980>] dev_open+0x4d/0x8b
kernel:   [<ffffffff8121d41e>] dev_change_flags+0xaf/0x172
kernel:   [<ffffffff81224fc2>] do_setlink+0x276/0x338
kernel:   [<ffffffff81225198>] rtnl_setlink+0x114/0x116
kernel:   [<ffffffff812262fc>] rtnetlink_rcv_msg+0x1d8/0x1f9
kernel:   [<ffffffff8123649a>] netlink_rcv_skb+0x3e/0xac
kernel:   [<ffffffff8122611a>] rtnetlink_rcv+0x29/0x33
kernel:   [<ffffffff81235eed>] netlink_unicast+0x1fe/0x26b
kernel:   [<ffffffff81236224>] netlink_sendmsg+0x2ca/0x2dd
kernel:   [<ffffffff812103b3>] sock_sendmsg+0xfd/0x120
kernel:   [<ffffffff812105a8>] sys_sendmsg+0x1d2/0x23c
kernel:   [<ffffffff8100c1c7>] tracesys+0xdc/0xe1
kernel:   [<ffffffffffffffff>] 0xffffffffffffffff

This can be fixed by using the irqsave/irqrestore versions
during the queue->lock handling.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00debug.c |    5 +++--
 drivers/net/wireless/rt2x00/rt2x00queue.c |   17 +++++++++++------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 21af11a..bfab3b8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -278,6 +278,7 @@ static ssize_t rt2x00debug_read_queue_stats(struct file *file,
 {
 	struct rt2x00debug_intf *intf = file->private_data;
 	struct data_queue *queue;
+	unsigned long irqflags;
 	unsigned int lines = 1 + intf->rt2x00dev->data_queues;
 	size_t size;
 	char *data;
@@ -294,7 +295,7 @@ static ssize_t rt2x00debug_read_queue_stats(struct file *file,
 	    sprintf(data, "qid\tcount\tlimit\tlength\tindex\tdone\tcrypto\n");
 
 	queue_for_each(intf->rt2x00dev, queue) {
-		spin_lock(&queue->lock);
+		spin_lock_irqsave(&queue->lock, irqflags);
 
 		temp += sprintf(temp, "%d\t%d\t%d\t%d\t%d\t%d\t%d\n", queue->qid,
 				queue->count, queue->limit, queue->length,
@@ -302,7 +303,7 @@ static ssize_t rt2x00debug_read_queue_stats(struct file *file,
 				queue->index[Q_INDEX_DONE],
 				queue->index[Q_INDEX_CRYPTO]);
 
-		spin_unlock(&queue->lock);
+		spin_unlock_irqrestore(&queue->lock, irqflags);
 	}
 
 	size = strlen(data);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 9188323..659e9f4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -53,6 +53,7 @@ struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
 					  enum queue_index index)
 {
 	struct queue_entry *entry;
+	unsigned long irqflags;
 
 	if (unlikely(index >= Q_INDEX_MAX)) {
 		ERROR(queue->rt2x00dev,
@@ -60,11 +61,11 @@ struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
 		return NULL;
 	}
 
-	spin_lock(&queue->lock);
+	spin_lock_irqsave(&queue->lock, irqflags);
 
 	entry = &queue->entries[queue->index[index]];
 
-	spin_unlock(&queue->lock);
+	spin_unlock_irqrestore(&queue->lock, irqflags);
 
 	return entry;
 }
@@ -72,13 +73,15 @@ EXPORT_SYMBOL_GPL(rt2x00queue_get_entry);
 
 void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index)
 {
+	unsigned long irqflags;
+
 	if (unlikely(index >= Q_INDEX_MAX)) {
 		ERROR(queue->rt2x00dev,
 		      "Index change on invalid index type (%d)\n", index);
 		return;
 	}
 
-	spin_lock(&queue->lock);
+	spin_lock_irqsave(&queue->lock, irqflags);
 
 	queue->index[index]++;
 	if (queue->index[index] >= queue->limit)
@@ -91,19 +94,21 @@ void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index)
 		queue->count ++;
 	}
 
-	spin_unlock(&queue->lock);
+	spin_unlock_irqrestore(&queue->lock, irqflags);
 }
 EXPORT_SYMBOL_GPL(rt2x00queue_index_inc);
 
 static void rt2x00queue_reset(struct data_queue *queue)
 {
-	spin_lock(&queue->lock);
+	unsigned long irqflags;
+
+	spin_lock_irqsave(&queue->lock, irqflags);
 
 	queue->count = 0;
 	queue->length = 0;
 	memset(queue->index, 0, sizeof(queue->index));
 
-	spin_unlock(&queue->lock);
+	spin_unlock_irqrestore(&queue->lock, irqflags);
 }
 
 void rt2x00queue_init_rx(struct rt2x00_dev *rt2x00dev)
-- 
1.5.4.3

