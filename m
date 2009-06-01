Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40196 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbZFAMLC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 08:11:02 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A238EA2.4040106@tuffmail.co.uk>
References: <1243524688.10632.0.camel@johannes.local>
	 <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com>
	 <1243763887.19302.29.camel@johannes.local>
	 <1243796509.6570.35.camel@localhost.localdomain>
	 <1243841639.5299.8.camel@johannes.local>  <4A238EA2.4040106@tuffmail.co.uk>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 14:10:56 +0200
Message-Id: <1243858256.5299.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Would everybody be happy with this rolled in?

johannes

Subject: rfkill: userspace API improvements

This adds the two following things to /dev/rfkill:
 1) notification to userspace with a new operation
    RFKILL_OP_NVS_REPORT about default states restored
    from platform non-volatile storage
 2) the ability to ignore input events in the kernel
    while a handler daemon is connected, if the input
    part is compiled in.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/rfkill.h |    8 +++++
 net/rfkill/core.c      |   67 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 74 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/rfkill/core.c	2009-06-01 09:43:26.000000000 +0200
+++ wireless-testing/net/rfkill/core.c	2009-06-01 14:10:48.000000000 +0200
@@ -85,6 +85,7 @@ struct rfkill_data {
 	struct list_head	events;
 	struct mutex		mtx;
 	wait_queue_head_t	read_wait;
+	bool			input_handler;
 };
 
 
@@ -115,7 +116,7 @@ MODULE_PARM_DESC(default_state,
 		 "Default initial state for all radio types, 0 = radio off");
 
 static struct {
-	bool cur, def;
+	bool cur, def, restored;
 } rfkill_global_states[NUM_RFKILL_TYPES];
 
 static unsigned long rfkill_states_default_locked;
@@ -318,6 +319,8 @@ static void rfkill_set_block(struct rfki
 }
 
 #ifdef CONFIG_RFKILL_INPUT
+static atomic_t rfkill_input_disabled = ATOMIC_INIT(0);
+
 /**
  * __rfkill_switch_all - Toggle state of all switches of given type
  * @type: type of interfaces to be affected
@@ -354,6 +357,9 @@ static void __rfkill_switch_all(const en
  */
 void rfkill_switch_all(enum rfkill_type type, bool blocked)
 {
+	if (atomic_read(&rfkill_input_disabled))
+		return;
+
 	mutex_lock(&rfkill_global_mutex);
 
 	if (!rfkill_epo_lock_active)
@@ -376,6 +382,9 @@ void rfkill_epo(void)
 	struct rfkill *rfkill;
 	int i;
 
+	if (atomic_read(&rfkill_input_disabled))
+		return;
+
 	mutex_lock(&rfkill_global_mutex);
 
 	rfkill_epo_lock_active = true;
@@ -401,6 +410,9 @@ void rfkill_restore_states(void)
 {
 	int i;
 
+	if (atomic_read(&rfkill_input_disabled))
+		return;
+
 	mutex_lock(&rfkill_global_mutex);
 
 	rfkill_epo_lock_active = false;
@@ -417,6 +429,9 @@ void rfkill_restore_states(void)
  */
 void rfkill_remove_epo_lock(void)
 {
+	if (atomic_read(&rfkill_input_disabled))
+		return;
+
 	mutex_lock(&rfkill_global_mutex);
 	rfkill_epo_lock_active = false;
 	mutex_unlock(&rfkill_global_mutex);
@@ -451,6 +466,8 @@ bool rfkill_get_global_sw_state(const en
 
 void rfkill_set_global_sw_state(const enum rfkill_type type, bool blocked)
 {
+	BUG_ON(type == RFKILL_TYPE_ALL);
+
 	mutex_lock(&rfkill_global_mutex);
 
 	/* don't allow unblock when epo */
@@ -465,6 +482,7 @@ void rfkill_set_global_sw_state(const en
 
 	rfkill_global_states[type].cur = blocked;
 	rfkill_global_states[type].def = blocked;
+	rfkill_global_states[type].restored = true;
  out:
 	mutex_unlock(&rfkill_global_mutex);
 }
@@ -939,6 +957,7 @@ static int rfkill_fop_open(struct inode 
 	struct rfkill_data *data;
 	struct rfkill *rfkill;
 	struct rfkill_int_event *ev, *tmp;
+	enum rfkill_type i;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -963,6 +982,19 @@ static int rfkill_fop_open(struct inode 
 		rfkill_fill_event(&ev->ev, rfkill, RFKILL_OP_ADD);
 		list_add_tail(&ev->list, &data->events);
 	}
+
+	for (i = 0; i < NUM_RFKILL_TYPES; i++) {
+		if (!rfkill_global_states[i].restored)
+			continue;
+		ev = kzalloc(sizeof(*ev), GFP_KERNEL);
+		if (!ev)
+			goto free;
+		ev->ev.idx = 0;
+		ev->ev.type = RFKILL_TYPE_ALL;
+		ev->ev.op = RFKILL_OP_NVS_REPORT;
+		list_add_tail(&ev->list, &data->events);
+	}
+
 	mutex_unlock(&data->mtx);
 	mutex_unlock(&rfkill_global_mutex);
 
@@ -1103,17 +1135,50 @@ static int rfkill_fop_release(struct ino
 	list_for_each_entry_safe(ev, tmp, &data->events, list)
 		kfree(ev);
 
+#ifdef CONFIG_RFKILL_INPUT
+	if (data->input_handler)
+		atomic_dec(&rfkill_input_disabled);
+#endif
+
 	kfree(data);
 
 	return 0;
 }
 
+#ifdef CONFIG_RFKILL_INPUT
+static long rfkill_fop_ioctl(struct file *file, unsigned int cmd,
+			     unsigned long arg)
+{
+	struct rfkill_data *data = file->private_data;
+
+	if (_IOC_TYPE(cmd) != RFKILL_IOC_MAGIC)
+		return -ENOSYS;
+
+	if (_IOC_NR(cmd) != RFKILL_IOC_NOINPUT)
+		return -ENOSYS;
+
+	mutex_lock(&data->mtx);
+
+	if (!data->input_handler) {
+		atomic_inc(&rfkill_input_disabled);
+		data->input_handler = true;
+	}
+
+	mutex_unlock(&data->mtx);
+
+	return 0;
+}
+#endif
+
 static const struct file_operations rfkill_fops = {
 	.open		= rfkill_fop_open,
 	.read		= rfkill_fop_read,
 	.write		= rfkill_fop_write,
 	.poll		= rfkill_fop_poll,
 	.release	= rfkill_fop_release,
+#ifdef CONFIG_RFKILL_INPUT
+	.unlocked_ioctl	= rfkill_fop_ioctl,
+#endif
 };
 
 static struct miscdevice rfkill_miscdev = {
--- wireless-testing.orig/include/linux/rfkill.h	2009-06-01 13:49:36.000000000 +0200
+++ wireless-testing/include/linux/rfkill.h	2009-06-01 14:08:35.000000000 +0200
@@ -56,12 +56,15 @@ enum rfkill_type {
  * @RFKILL_OP_DEL: a device was removed
  * @RFKILL_OP_CHANGE: a device's state changed -- userspace changes one device
  * @RFKILL_OP_CHANGE_ALL: userspace changes all devices (of a type, or all)
+ * @RFKILL_OP_NVS_REPORT: kernel report about default state that was
+ *	restored from platform non-volatile storage
  */
 enum rfkill_operation {
 	RFKILL_OP_ADD = 0,
 	RFKILL_OP_DEL,
 	RFKILL_OP_CHANGE,
 	RFKILL_OP_CHANGE_ALL,
+	RFKILL_OP_NVS_REPORT,
 };
 
 /**
@@ -82,6 +85,11 @@ struct rfkill_event {
 	__u8  soft, hard;
 } __packed;
 
+/* ioctl for turning off rfkill-input (if present) */
+#define RFKILL_IOC_MAGIC	'R'
+#define RFKILL_IOC_NOINPUT	1
+#define RFKILL_IOCTL_NOINPUT	_IO(RFKILL_IOC_MAGIC, RFKILL_IOC_NOINPUT)
+
 /* and that's all userspace gets */
 #ifdef __KERNEL__
 /* don't allow anyone to use these in the kernel */


