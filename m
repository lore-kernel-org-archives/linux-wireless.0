Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2005 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab0CLEpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 23:45:46 -0500
From: Bob Copeland <me@bobcopeland.com>
To: jouni.malinen@atheros.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH/RFC 3/3] mac80211_hwsim: enable user space frame processing
Date: Thu, 11 Mar 2010 23:43:19 -0500
Message-Id: <1268368999-12734-4-git-send-email-me@bobcopeland.com>
In-Reply-To: <1268368999-12734-1-git-send-email-me@bobcopeland.com>
References: <1268368999-12734-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, mac80211 hwsim delivers all packets to all other
simulated radios.  For some use cases, it is worthwhile to
have more control over frame delivery.

This change removes the hardwired in-kernel frame delivery, and
adds read(), write(), and ioctl() callbacks for the radio control
device in its place.  Any transmitted frames from the host are
queued, and a single outbound frame is delivered on each read.
Any frames written to the device with write() are treated as
received frames.  Transmit status information is implemented via
an ioctl.

Thus, a simple simulator can open the device twice to create
a pair of radios, then read frames from one fd and write frames
to the other fd to simulate the medium.

Note, this disables some forms of packet filtering (such as
addr matching and groups).  These can be added back with
a little more work, or we can choose to do this in user-space
instead.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/mac80211_hwsim.c |  381 ++++++++++++++++++++++-----------
 drivers/net/wireless/mac80211_hwsim.h |   42 ++++
 2 files changed, 295 insertions(+), 128 deletions(-)
 create mode 100644 drivers/net/wireless/mac80211_hwsim.h

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0fbadca..5390051 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -25,14 +25,14 @@
 #include <linux/debugfs.h>
 #include <linux/miscdevice.h>
 
+#include "mac80211_hwsim.h"
+
+#define HWSIM_MAX_QUEUE		200	/* depth of TX queue */
+
 MODULE_AUTHOR("Jouni Malinen");
 MODULE_DESCRIPTION("Software simulator of 802.11 radio(s) for mac80211");
 MODULE_LICENSE("GPL");
 
-static int radios = 2;
-module_param(radios, int, 0444);
-MODULE_PARM_DESC(radios, "Number of simulated radios");
-
 static bool fake_hw_scan;
 module_param(fake_hw_scan, bool, 0444);
 MODULE_PARM_DESC(fake_hw_scan, "Install fake (no-op) hw-scan handler");
@@ -303,6 +303,10 @@ struct mac80211_hwsim_data {
 	struct dentry *debugfs;
 	struct dentry *debugfs_ps;
 
+	spinlock_t tx_queue_lock;		/* protects tx_queue */
+	struct sk_buff_head tx_queue;		/* packets to transmit */
+	struct sk_buff_head pending;		/* packets awaiting status */
+
 	/*
 	 * Only radios in the same group can communicate together (the
 	 * channel has to match too). Each bit represents a group. A
@@ -310,6 +314,8 @@ struct mac80211_hwsim_data {
 	 */
 	u64 group;
 	struct dentry *debugfs_group;
+
+	wait_queue_head_t readq, writeq;	/* for poll() on read/write */
 };
 
 
@@ -445,107 +451,43 @@ static bool hwsim_ps_rx_ok(struct mac80211_hwsim_data *data,
 	return true;
 }
 
-
-struct mac80211_hwsim_addr_match_data {
-	bool ret;
-	const u8 *addr;
-};
-
-static void mac80211_hwsim_addr_iter(void *data, u8 *mac,
-				     struct ieee80211_vif *vif)
-{
-	struct mac80211_hwsim_addr_match_data *md = data;
-	if (memcmp(mac, md->addr, ETH_ALEN) == 0)
-		md->ret = true;
-}
-
-
-static bool mac80211_hwsim_addr_match(struct mac80211_hwsim_data *data,
-				      const u8 *addr)
-{
-	struct mac80211_hwsim_addr_match_data md;
-
-	if (memcmp(addr, data->hw->wiphy->perm_addr, ETH_ALEN) == 0)
-		return true;
-
-	md.ret = false;
-	md.addr = addr;
-	ieee80211_iterate_active_interfaces_atomic(data->hw,
-						   mac80211_hwsim_addr_iter,
-						   &md);
-
-	return md.ret;
-}
-
-
 static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 				    struct sk_buff *skb)
 {
-	struct mac80211_hwsim_data *data = hw->priv, *data2;
-	bool ack = false;
+	struct mac80211_hwsim_data *data = hw->priv;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_rx_status rx_status;
+	unsigned long flags;
 
 	if (data->idle) {
 		printk(KERN_DEBUG "%s: Trying to TX when idle - reject\n",
 		       wiphy_name(hw->wiphy));
+		dev_kfree_skb(skb);
 		return false;
 	}
 
-	memset(&rx_status, 0, sizeof(rx_status));
-	/* TODO: set mactime */
-	rx_status.freq = data->channel->center_freq;
-	rx_status.band = data->channel->band;
-	rx_status.rate_idx = info->control.rates[0].idx;
-	/* TODO: simulate real signal strength (and optional packet loss) */
-	rx_status.signal = -50;
-
 	if (data->ps != PS_DISABLED)
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
 
-	/* release the skb's source info */
-	skb_orphan(skb);
-	skb_dst_drop(skb);
-	skb->mark = 0;
-	secpath_reset(skb);
-	nf_reset(skb);
-
-	/* Copy skb to all enabled radios that are on the current frequency */
-	spin_lock(&hwsim_radio_lock);
-	list_for_each_entry(data2, &hwsim_radios, list) {
-		struct sk_buff *nskb;
-
-		if (data == data2)
-			continue;
-
-		if (data2->idle || !data2->started ||
-		    !hwsim_ps_rx_ok(data2, skb) ||
-		    !data->channel || !data2->channel ||
-		    data->channel->center_freq != data2->channel->center_freq ||
-		    !(data->group & data2->group))
-			continue;
-
-		nskb = skb_copy(skb, GFP_ATOMIC);
-		if (nskb == NULL)
-			continue;
-
-		if (mac80211_hwsim_addr_match(data2, hdr->addr1))
-			ack = true;
-		memcpy(IEEE80211_SKB_RXCB(nskb), &rx_status, sizeof(rx_status));
-		ieee80211_rx_irqsafe(data2->hw, nskb);
+	/* queue packet on tx queue for next read() */
+	if (skb_queue_len(&data->tx_queue) >= HWSIM_MAX_QUEUE) {
+		printk(KERN_DEBUG "%s: tx_buffers full, dropping\n",
+			wiphy_name(hw->wiphy));
+		dev_kfree_skb(skb);
+		ieee80211_stop_queues(hw);
+		return false;
 	}
-	spin_unlock(&hwsim_radio_lock);
 
-	return ack;
+	spin_lock_irqsave(&data->tx_queue_lock, flags);
+	skb_queue_tail(&data->tx_queue, skb);
+	spin_unlock_irqrestore(&data->tx_queue_lock, flags);
+
+	wake_up_interruptible(&data->readq);
+	return true;
 }
 
 
 static int mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
-	bool ack;
-	struct ieee80211_tx_info *txi;
-
 	mac80211_hwsim_monitor_rx(hw, skb);
 
 	if (skb->len < 10) {
@@ -554,23 +496,8 @@ static int mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		return NETDEV_TX_OK;
 	}
 
-	ack = mac80211_hwsim_tx_frame(hw, skb);
-	if (ack && skb->len >= 16) {
-		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-		mac80211_hwsim_monitor_ack(hw, hdr->addr2);
-	}
-
-	txi = IEEE80211_SKB_CB(skb);
-
-	if (txi->control.vif)
-		hwsim_check_magic(txi->control.vif);
-	if (txi->control.sta)
-		hwsim_check_sta_magic(txi->control.sta);
+	mac80211_hwsim_tx_frame(hw, skb);
 
-	ieee80211_tx_info_clear_status(txi);
-	if (!(txi->flags & IEEE80211_TX_CTL_NO_ACK) && ack)
-		txi->flags |= IEEE80211_TX_STAT_ACK;
-	ieee80211_tx_status_irqsafe(hw, skb);
 	return NETDEV_TX_OK;
 }
 
@@ -635,7 +562,6 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 
 	mac80211_hwsim_monitor_rx(hw, skb);
 	mac80211_hwsim_tx_frame(hw, skb);
-	dev_kfree_skb(skb);
 }
 
 
@@ -926,12 +852,12 @@ static int mac80211_hwsim_ampdu_action(struct ieee80211_hw *hw,
 
 static void mac80211_hwsim_flush(struct ieee80211_hw *hw, bool drop)
 {
-	/*
-	 * In this special case, there's nothing we need to
-	 * do because hwsim does transmission synchronously.
-	 * In the future, when it does transmissions via
-	 * userspace, we may need to do something.
-	 */
+	struct mac80211_hwsim_data *data = hw->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->tx_queue_lock, flags);
+	skb_queue_purge(&data->tx_queue);
+	spin_unlock_irqrestore(&data->tx_queue_lock, flags);
 }
 
 struct hw_scan_done {
@@ -1062,9 +988,7 @@ static void hwsim_send_ps_poll(void *dat, u8 *mac, struct ieee80211_vif *vif)
 	pspoll->aid = cpu_to_le16(0xc000 | vp->aid);
 	memcpy(pspoll->bssid, vp->bssid, ETH_ALEN);
 	memcpy(pspoll->ta, mac, ETH_ALEN);
-	if (!mac80211_hwsim_tx_frame(data->hw, skb))
-		printk(KERN_DEBUG "%s: PS-Poll frame not ack'ed\n", __func__);
-	dev_kfree_skb(skb);
+	mac80211_hwsim_tx_frame(data->hw, skb);
 }
 
 
@@ -1092,9 +1016,7 @@ static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
 	memcpy(hdr->addr1, vp->bssid, ETH_ALEN);
 	memcpy(hdr->addr2, mac, ETH_ALEN);
 	memcpy(hdr->addr3, vp->bssid, ETH_ALEN);
-	if (!mac80211_hwsim_tx_frame(data->hw, skb))
-		printk(KERN_DEBUG "%s: nullfunc frame not ack'ed\n", __func__);
-	dev_kfree_skb(skb);
+	mac80211_hwsim_tx_frame(data->hw, skb);
 }
 
 
@@ -1208,6 +1130,12 @@ static struct mac80211_hwsim_data *mac80211_hwsim_create_radio(void)
 	}
 	data->dev->driver = &mac80211_hwsim_driver;
 
+	spin_lock_init(&data->tx_queue_lock);
+	skb_queue_head_init(&data->tx_queue);
+	skb_queue_head_init(&data->pending);
+	init_waitqueue_head(&data->readq);
+	init_waitqueue_head(&data->writeq);
+
 	SET_IEEE80211_DEV(hw, data->dev);
 	addr[3] = radio >> 8;
 	addr[4] = radio;
@@ -1278,6 +1206,10 @@ static struct mac80211_hwsim_data *mac80211_hwsim_create_radio(void)
 	/* By default all radios are belonging to the first group */
 	data->group = 1;
 
+	/* enable MRR */
+	hw->max_rates = 4;
+	hw->max_rate_tries = 11;
+
 	/* Work to be done prior to ieee80211_register_hw() */
 	switch (regtest) {
 	case HWSIM_REGTEST_DISABLED:
@@ -1459,10 +1391,216 @@ int mac80211_hwsim_control_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int mac80211_hwsim_control_read(struct file *file, char __user *buf,
+				       size_t count, loff_t *pos)
+{
+	int i;
+	struct mac80211_hwsim_data *data;
+	struct sk_buff *skb;
+	size_t len;
+	struct mac80211_hwsim_tx_packet *response;
+	struct ieee80211_tx_info *txi;
+	unsigned long flags;
+
+	data = file->private_data;
+
+	spin_lock_irqsave(&data->tx_queue_lock, flags);
+	while (skb_queue_empty(&data->tx_queue))
+	{
+		spin_unlock_irqrestore(&data->tx_queue_lock, flags);
+
+		if (file->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+
+		if (wait_event_interruptible(data->readq,
+			!skb_queue_empty(&data->tx_queue)))
+			return -ERESTARTSYS;
+
+		spin_lock_irqsave(&data->tx_queue_lock, flags);
+	}
+
+	skb = skb_dequeue(&data->tx_queue);
+	spin_unlock_irqrestore(&data->tx_queue_lock, flags);
+
+	if (!skb)
+		return -EIO;
+
+	skb_queue_tail(&data->pending, skb);
+
+	len = sizeof(*response) + skb->len;
+	response = kmalloc(len, GFP_KERNEL);
+	if (!response)
+		return -EFAULT;
+
+	txi = IEEE80211_SKB_CB(skb);
+	response->cookie = (unsigned long) skb;
+	response->rts_cts_rate_idx = txi->control.rts_cts_rate_idx;
+	for (i=0; i < IEEE80211_TX_MAX_RATES; i++)
+	{
+		response->rates[i].idx = txi->control.rates[i].idx;
+		response->rates[i].count = txi->control.rates[i].count;
+		response->rates[i].flags = txi->control.rates[i].flags;
+	}
+	response->pkt_len = skb->len;
+	memcpy(response->pkt_data, skb->data, skb->len);
+
+	len = min_t(size_t, count, len);
+
+	if (copy_to_user(buf, response, len)) {
+		kfree(response);
+		return -EFAULT;
+	}
+
+	kfree(response);
+	*pos += len;
+	return len;
+}
+
+static
+int mac80211_hwsim_control_write(struct file *file, const char __user *buf,
+				 size_t count, loff_t *pos)
+{
+	struct mac80211_hwsim_data *data;
+	struct sk_buff *skb;
+	struct ieee80211_rx_status rx_status;
+
+	data = file->private_data;
+
+	skb = dev_alloc_skb(count);
+	if (!skb)
+		return -ENOMEM;
+
+	if (copy_from_user(skb_put(skb, count), buf, count)) {
+		dev_kfree_skb(skb);
+		return -EFAULT;
+	}
+
+	if (data->idle || !data->started ||
+	    !data->channel ||
+	    !hwsim_ps_rx_ok(data, skb)) {
+		dev_kfree_skb(skb);
+		goto out;
+	}
+
+	/* XXX: parse radiotap header to set rx status, get channel etc. */
+
+	memset(&rx_status, 0, sizeof(rx_status));
+	/* TODO: set mactime */
+	rx_status.freq = data->channel->center_freq;
+	rx_status.band = data->channel->band;
+	rx_status.rate_idx = 0;
+	/* TODO: simulate real signal strength (and optional packet loss) */
+	rx_status.signal = -50;
+
+	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
+	ieee80211_rx(data->hw, skb);
+
+out:
+	return count;
+}
+
+static
+unsigned int mac80211_hwsim_control_poll(struct file *file, poll_table *wait)
+{
+	struct mac80211_hwsim_data *data;
+	unsigned int mask = 0;
+	unsigned long flags;
+
+	data = file->private_data;
+
+	spin_lock_irqsave(&data->tx_queue_lock, flags);
+	poll_wait(file, &data->readq, wait);
+
+	if (!skb_queue_empty(&data->tx_queue))
+		mask |= POLLIN | POLLRDNORM;
+
+	spin_unlock_irqrestore(&data->tx_queue_lock, flags);
+	return mask;
+}
+
+static long mac80211_hwsim_control_ioctl(struct file *file, unsigned int cmd,
+					 unsigned long arg)
+{
+	struct mac80211_hwsim_data *data;
+	struct sk_buff *skb = NULL, *tmp;
+	struct mac80211_hwsim_tx_status tx_status;
+	struct ieee80211_tx_info *txi;
+	void __user *buf;
+	struct sk_buff __user *ret_skb;
+	int i;
+
+	if (_IOC_TYPE(cmd) != MAC80211_HWSIM_IOC_MAGIC)
+		return -EINVAL;
+	if (_IOC_NR(cmd) != MAC80211_HWSIM_IOC_STATUS)
+		return -EINVAL;
+
+	buf = (void __user *) arg;
+
+	if (!access_ok(VERIFY_READ, buf, sizeof(tx_status)))
+		return -EFAULT;
+
+	data = file->private_data;
+
+	/* find the appropriate skb and give mac80211 the status */
+	if (copy_from_user(&tx_status, buf, sizeof(tx_status)))
+		return -EFAULT;
+
+	ret_skb = (struct sk_buff __user *) (unsigned long) tx_status.cookie;
+
+	/* look for the skb matching the cookie passed back from user */
+	skb_queue_walk_safe(&data->pending, skb, tmp) {
+		if (skb == ret_skb) {
+			skb_unlink(skb, &data->pending);
+			break;
+		}
+	}
+
+	/* not found */
+	if (skb == (struct sk_buff *) &data->pending)
+		return -EINVAL;
+
+	/* now send TX status */
+	txi = IEEE80211_SKB_CB(skb);
+
+	if (txi->control.vif)
+		hwsim_check_magic(txi->control.vif);
+	if (txi->control.sta)
+		hwsim_check_sta_magic(txi->control.sta);
+
+	ieee80211_tx_info_clear_status(txi);
+	for (i=0; i < IEEE80211_TX_MAX_RATES; i++) {
+		txi->status.rates[i].idx = tx_status.rates[i].idx;
+		txi->status.rates[i].count = tx_status.rates[i].count;
+		txi->status.rates[i].flags = tx_status.rates[i].flags;
+	}
+	txi->status.ampdu_ack_len = tx_status.ampdu_ack_len;
+	txi->status.ampdu_ack_map = tx_status.ampdu_ack_map;
+	txi->status.ack_signal = tx_status.ack_signal;
+
+	if (!(txi->flags & IEEE80211_TX_CTL_NO_ACK) && tx_status.ack)
+		txi->flags |= IEEE80211_TX_STAT_ACK;
+
+	if (tx_status.ack && skb->len >= 16) {
+		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+		mac80211_hwsim_monitor_ack(data->hw, hdr->addr2);
+	}
+
+	ieee80211_tx_status_irqsafe(data->hw, skb);
+
+	if (skb_queue_len(&data->tx_queue) < HWSIM_MAX_QUEUE / 5)
+		ieee80211_wake_queues(data->hw);
+
+	return 0;
+}
+
 static const struct file_operations mac80211_hwsim_control_fops = {
 	.owner		= THIS_MODULE,
 	.open		= mac80211_hwsim_control_open,
-	.release	= mac80211_hwsim_control_release
+	.release	= mac80211_hwsim_control_release,
+	.read		= mac80211_hwsim_control_read,
+	.write		= mac80211_hwsim_control_write,
+	.poll		= mac80211_hwsim_control_poll,
+	.unlocked_ioctl	= mac80211_hwsim_control_ioctl,
 };
 
 static struct miscdevice mac80211_hwsim_miscdev = {
@@ -1473,10 +1611,7 @@ static struct miscdevice mac80211_hwsim_miscdev = {
 
 static int __init init_mac80211_hwsim(void)
 {
-	int i, err = 0;
-
-	if (radios < 1 || radios > 100)
-		return -EINVAL;
+	int err = 0;
 
 	if (fake_hw_scan)
 		mac80211_hwsim_ops.hw_scan = mac80211_hwsim_hw_scan;
@@ -1494,16 +1629,6 @@ static int __init init_mac80211_hwsim(void)
 		goto failed;
 	}
 
-	for (i = 0; i < radios; i++) {
-		struct mac80211_hwsim_data *data =
-			mac80211_hwsim_create_radio();
-
-		if (IS_ERR(data)) {
-			err = PTR_ERR(data);
-			goto failed_free;
-		}
-	}
-
 	hwsim_mon = alloc_netdev(0, "hwsim%d", hwsim_mon_setup);
 	if (hwsim_mon == NULL)
 		goto failed_free;
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
new file mode 100644
index 0000000..307d4bd
--- /dev/null
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -0,0 +1,42 @@
+#ifndef __MAC80211_HWSIM_H
+#define __MAC80211_HWSIM_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define MAC80211_TX_MAX_RATES 5
+
+struct mac80211_hwsim_tx_rate {
+	__s8 idx;
+	__u8 count;
+	__u8 flags;
+} __attribute__((packed));
+
+/* This structure is returned on a read() */
+struct mac80211_hwsim_tx_packet {
+	__u64 cookie;
+	struct mac80211_hwsim_tx_rate rates[MAC80211_TX_MAX_RATES];
+	__s8 rts_cts_rate_idx;
+	__u16 pkt_len;
+	__u8 pkt_data[0];
+} __attribute__((packed));
+
+/* This structure is passed for status ioctl */
+struct mac80211_hwsim_tx_status {
+	__u64 cookie;
+	struct mac80211_hwsim_tx_rate rates[MAC80211_TX_MAX_RATES];
+	__u8 ack;
+	__u8 ampdu_ack_len;
+	__u64 ampdu_ack_map;
+	__u32 ack_signal;
+} __attribute__((packed));
+
+#define MAC80211_HWSIM_IOC_MAGIC	'H'
+#define MAC80211_HWSIM_IOC_STATUS	1
+#define MAC80211_HWSIM_IOCTL_STATUS	_IOW(MAC80211_HWSIM_IOC_MAGIC, MAC80211_HWSIM_IOC_STATUS,struct mac80211_hwsim_tx_status)
+
+#ifdef __KERNEL__
+
+#endif /* __KERNEL__ */
+
+#endif /* __MAC80211_HWSIM_H */
-- 
1.6.3.3


