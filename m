Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40225 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921AbZFBLMs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 07:12:48 -0400
Message-Id: <20090602110149.979830513@sipsolutions.net>
References: <20090602110136.631660156@sipsolutions.net>
Date: Tue, 02 Jun 2009 13:01:38 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 2/6 v6] rfkill: create useful userspace interface
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new code added by this patch will make rfkill create
a misc character device /dev/rfkill that userspace can use
to control rfkill soft blocks and get status of devices as
well as events when the status changes.

Using it is very simple -- when you open it you can read
a number of times to get the initial state, and every
further read blocks (you can poll) on getting the next
event from the kernel. The same structure you read is
also used when writing to it to change the soft block of
a given device, all devices of a given type, or all
devices.

This also makes CONFIG_RFKILL_INPUT selectable again in
order to be able to test without it present since its
functionality can now be replaced by userspace entirely
and distros and users may not want the input part of
rfkill interfering with their userspace code. We will
also write a userspace daemon to handle all that and
consequently add the input code to the feature removal
schedule.

In order to have rfkilld support both kernels with and
without CONFIG_RFKILL_INPUT (or new kernels after its
eventual removal) we also add an ioctl (that only exists
if rfkill-input is present) to disable rfkill-input.
It is not very efficient, but at least gives the correct
behaviour in all cases.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
---
v4: set default global state from userspace for rfkill hotplug
    (pointed out by Marcel)
v5: add ioctl
v6: hook up compat_ioctl

 Documentation/feature-removal-schedule.txt |    7 
 include/linux/rfkill.h                     |   84 +++++--
 net/rfkill/Kconfig                         |    4 
 net/rfkill/core.c                          |  330 ++++++++++++++++++++++++++++-
 4 files changed, 394 insertions(+), 31 deletions(-)

--- wireless-testing.orig/include/linux/rfkill.h	2009-06-01 22:34:04.000000000 +0200
+++ wireless-testing/include/linux/rfkill.h	2009-06-02 11:39:11.000000000 +0200
@@ -22,34 +22,17 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#include <linux/types.h>
 
 /* define userspace visible states */
 #define RFKILL_STATE_SOFT_BLOCKED	0
 #define RFKILL_STATE_UNBLOCKED		1
 #define RFKILL_STATE_HARD_BLOCKED	2
 
-/* and that's all userspace gets */
-#ifdef __KERNEL__
-/* don't allow anyone to use these in the kernel */
-enum rfkill_user_states {
-	RFKILL_USER_STATE_SOFT_BLOCKED	= RFKILL_STATE_SOFT_BLOCKED,
-	RFKILL_USER_STATE_UNBLOCKED	= RFKILL_STATE_UNBLOCKED,
-	RFKILL_USER_STATE_HARD_BLOCKED	= RFKILL_STATE_HARD_BLOCKED,
-};
-#undef RFKILL_STATE_SOFT_BLOCKED
-#undef RFKILL_STATE_UNBLOCKED
-#undef RFKILL_STATE_HARD_BLOCKED
-
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/list.h>
-#include <linux/mutex.h>
-#include <linux/device.h>
-#include <linux/leds.h>
-
 /**
  * enum rfkill_type - type of rfkill switch.
  *
+ * @RFKILL_TYPE_ALL: toggles all switches (userspace only)
  * @RFKILL_TYPE_WLAN: switch is on a 802.11 wireless network device.
  * @RFKILL_TYPE_BLUETOOTH: switch is on a bluetooth device.
  * @RFKILL_TYPE_UWB: switch is on a ultra wideband device.
@@ -58,6 +41,7 @@ enum rfkill_user_states {
  * @NUM_RFKILL_TYPES: number of defined rfkill types
  */
 enum rfkill_type {
+	RFKILL_TYPE_ALL = 0,
 	RFKILL_TYPE_WLAN,
 	RFKILL_TYPE_BLUETOOTH,
 	RFKILL_TYPE_UWB,
@@ -66,6 +50,62 @@ enum rfkill_type {
 	NUM_RFKILL_TYPES,
 };
 
+/**
+ * enum rfkill_operation - operation types
+ * @RFKILL_OP_ADD: a device was added
+ * @RFKILL_OP_DEL: a device was removed
+ * @RFKILL_OP_CHANGE: a device's state changed -- userspace changes one device
+ * @RFKILL_OP_CHANGE_ALL: userspace changes all devices (of a type, or all)
+ */
+enum rfkill_operation {
+	RFKILL_OP_ADD = 0,
+	RFKILL_OP_DEL,
+	RFKILL_OP_CHANGE,
+	RFKILL_OP_CHANGE_ALL,
+};
+
+/**
+ * struct rfkill_event - events for userspace on /dev/rfkill
+ * @idx: index of dev rfkill
+ * @type: type of the rfkill struct
+ * @op: operation code
+ * @hard: hard state (0/1)
+ * @soft: soft state (0/1)
+ *
+ * Structure used for userspace communication on /dev/rfkill,
+ * used for events from the kernel and control to the kernel.
+ */
+struct rfkill_event {
+	__u32 idx;
+	__u8  type;
+	__u8  op;
+	__u8  soft, hard;
+} __packed;
+
+/* ioctl for turning off rfkill-input (if present) */
+#define RFKILL_IOC_MAGIC	'R'
+#define RFKILL_IOC_NOINPUT	1
+#define RFKILL_IOCTL_NOINPUT	_IO(RFKILL_IOC_MAGIC, RFKILL_IOC_NOINPUT)
+
+/* and that's all userspace gets */
+#ifdef __KERNEL__
+/* don't allow anyone to use these in the kernel */
+enum rfkill_user_states {
+	RFKILL_USER_STATE_SOFT_BLOCKED	= RFKILL_STATE_SOFT_BLOCKED,
+	RFKILL_USER_STATE_UNBLOCKED	= RFKILL_STATE_UNBLOCKED,
+	RFKILL_USER_STATE_HARD_BLOCKED	= RFKILL_STATE_HARD_BLOCKED,
+};
+#undef RFKILL_STATE_SOFT_BLOCKED
+#undef RFKILL_STATE_UNBLOCKED
+#undef RFKILL_STATE_HARD_BLOCKED
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/device.h>
+#include <linux/leds.h>
+
 /* this is opaque */
 struct rfkill;
 
@@ -84,11 +124,7 @@ struct rfkill;
  *	the rfkill core query your driver before setting a requested
  *	block.
  * @set_block: turn the transmitter on (blocked == false) or off
- *	(blocked == true) -- this is called only while the transmitter
- *	is not hard-blocked, but note that the core's view of whether
- *	the transmitter is hard-blocked might differ from your driver's
- *	view due to race conditions, so it is possible that it is still
- *	called at the same time as you are calling rfkill_set_hw_state().
+ *	(blocked == true) -- ignore and return 0 when hard blocked.
  *	This callback must be assigned.
  */
 struct rfkill_ops {
--- wireless-testing.orig/net/rfkill/core.c	2009-06-01 22:34:04.000000000 +0200
+++ wireless-testing/net/rfkill/core.c	2009-06-02 11:39:29.000000000 +0200
@@ -28,6 +28,10 @@
 #include <linux/mutex.h>
 #include <linux/rfkill.h>
 #include <linux/spinlock.h>
+#include <linux/miscdevice.h>
+#include <linux/wait.h>
+#include <linux/poll.h>
+#include <linux/fs.h>
 
 #include "rfkill.h"
 
@@ -49,6 +53,8 @@ struct rfkill {
 
 	unsigned long		state;
 
+	u32			idx;
+
 	bool			registered;
 	bool			suspended;
 
@@ -69,6 +75,18 @@ struct rfkill {
 };
 #define to_rfkill(d)	container_of(d, struct rfkill, dev)
 
+struct rfkill_int_event {
+	struct list_head	list;
+	struct rfkill_event	ev;
+};
+
+struct rfkill_data {
+	struct list_head	list;
+	struct list_head	events;
+	struct mutex		mtx;
+	wait_queue_head_t	read_wait;
+	bool			input_handler;
+};
 
 
 MODULE_AUTHOR("Ivo van Doorn <IvDoorn@gmail.com>");
@@ -90,6 +108,7 @@ MODULE_LICENSE("GPL");
  */
 static LIST_HEAD(rfkill_list);	/* list of registered rf switches */
 static DEFINE_MUTEX(rfkill_global_mutex);
+static LIST_HEAD(rfkill_fds);	/* list of open fds of /dev/rfkill */
 
 static unsigned int rfkill_default_state = 1;
 module_param_named(default_state, rfkill_default_state, uint, 0444);
@@ -171,12 +190,48 @@ static inline void rfkill_led_trigger_un
 }
 #endif /* CONFIG_RFKILL_LEDS */
 
-static void rfkill_uevent(struct rfkill *rfkill)
+static void rfkill_fill_event(struct rfkill_event *ev, struct rfkill *rfkill,
+			      enum rfkill_operation op)
+{
+	unsigned long flags;
+
+	ev->idx = rfkill->idx;
+	ev->type = rfkill->type;
+	ev->op = op;
+
+	spin_lock_irqsave(&rfkill->lock, flags);
+	ev->hard = !!(rfkill->state & RFKILL_BLOCK_HW);
+	ev->soft = !!(rfkill->state & (RFKILL_BLOCK_SW |
+					RFKILL_BLOCK_SW_PREV));
+	spin_unlock_irqrestore(&rfkill->lock, flags);
+}
+
+static void rfkill_send_events(struct rfkill *rfkill, enum rfkill_operation op)
+{
+	struct rfkill_data *data;
+	struct rfkill_int_event *ev;
+
+	list_for_each_entry(data, &rfkill_fds, list) {
+		ev = kzalloc(sizeof(*ev), GFP_KERNEL);
+		if (!ev)
+			continue;
+		rfkill_fill_event(&ev->ev, rfkill, op);
+		mutex_lock(&data->mtx);
+		list_add_tail(&ev->list, &data->events);
+		mutex_unlock(&data->mtx);
+		wake_up_interruptible(&data->read_wait);
+	}
+}
+
+static void rfkill_event(struct rfkill *rfkill)
 {
 	if (!rfkill->registered || rfkill->suspended)
 		return;
 
 	kobject_uevent(&rfkill->dev.kobj, KOBJ_CHANGE);
+
+	/* also send event to /dev/rfkill */
+	rfkill_send_events(rfkill, RFKILL_OP_CHANGE);
 }
 
 static bool __rfkill_set_hw_state(struct rfkill *rfkill,
@@ -260,9 +315,12 @@ static void rfkill_set_block(struct rfki
 	spin_unlock_irqrestore(&rfkill->lock, flags);
 
 	rfkill_led_trigger_event(rfkill);
-	rfkill_uevent(rfkill);
+	rfkill_event(rfkill);
 }
 
+#ifdef CONFIG_RFKILL_INPUT
+static atomic_t rfkill_input_disabled = ATOMIC_INIT(0);
+
 /**
  * __rfkill_switch_all - Toggle state of all switches of given type
  * @type: type of interfaces to be affected
@@ -299,6 +357,9 @@ static void __rfkill_switch_all(const en
  */
 void rfkill_switch_all(enum rfkill_type type, bool blocked)
 {
+	if (atomic_read(&rfkill_input_disabled))
+		return;
+
 	mutex_lock(&rfkill_global_mutex);
 
 	if (!rfkill_epo_lock_active)
@@ -321,6 +382,9 @@ void rfkill_epo(void)
 	struct rfkill *rfkill;
 	int i;
 
+	if (atomic_read(&rfkill_input_disabled))
+		return;
+
 	mutex_lock(&rfkill_global_mutex);
 
 	rfkill_epo_lock_active = true;
@@ -331,6 +395,7 @@ void rfkill_epo(void)
 		rfkill_global_states[i].def = rfkill_global_states[i].cur;
 		rfkill_global_states[i].cur = true;
 	}
+
 	mutex_unlock(&rfkill_global_mutex);
 }
 
@@ -345,6 +410,9 @@ void rfkill_restore_states(void)
 {
 	int i;
 
+	if (atomic_read(&rfkill_input_disabled))
+		return;
+
 	mutex_lock(&rfkill_global_mutex);
 
 	rfkill_epo_lock_active = false;
@@ -361,6 +429,9 @@ void rfkill_restore_states(void)
  */
 void rfkill_remove_epo_lock(void)
 {
+	if (atomic_read(&rfkill_input_disabled))
+		return;
+
 	mutex_lock(&rfkill_global_mutex);
 	rfkill_epo_lock_active = false;
 	mutex_unlock(&rfkill_global_mutex);
@@ -391,9 +462,12 @@ bool rfkill_get_global_sw_state(const en
 {
 	return rfkill_global_states[type].cur;
 }
+#endif
 
 void rfkill_set_global_sw_state(const enum rfkill_type type, bool blocked)
 {
+	BUG_ON(type == RFKILL_TYPE_ALL);
+
 	mutex_lock(&rfkill_global_mutex);
 
 	/* don't allow unblock when epo */
@@ -537,6 +611,15 @@ static ssize_t rfkill_type_show(struct d
 	return sprintf(buf, "%s\n", rfkill_get_type_str(rfkill->type));
 }
 
+static ssize_t rfkill_idx_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct rfkill *rfkill = to_rfkill(dev);
+
+	return sprintf(buf, "%d\n", rfkill->idx);
+}
+
 static u8 user_state_from_blocked(unsigned long state)
 {
 	if (state & RFKILL_BLOCK_HW)
@@ -594,6 +677,7 @@ static ssize_t rfkill_claim_store(struct
 static struct device_attribute rfkill_dev_attrs[] = {
 	__ATTR(name, S_IRUGO, rfkill_name_show, NULL),
 	__ATTR(type, S_IRUGO, rfkill_type_show, NULL),
+	__ATTR(index, S_IRUGO, rfkill_idx_show, NULL),
 	__ATTR(state, S_IRUGO|S_IWUSR, rfkill_state_show, rfkill_state_store),
 	__ATTR(claim, S_IRUGO|S_IWUSR, rfkill_claim_show, rfkill_claim_store),
 	__ATTR_NULL
@@ -708,7 +792,7 @@ struct rfkill * __must_check rfkill_allo
 	if (WARN_ON(!name))
 		return NULL;
 
-	if (WARN_ON(type >= NUM_RFKILL_TYPES))
+	if (WARN_ON(type == RFKILL_TYPE_ALL || type >= NUM_RFKILL_TYPES))
 		return NULL;
 
 	rfkill = kzalloc(sizeof(*rfkill), GFP_KERNEL);
@@ -754,7 +838,9 @@ static void rfkill_uevent_work(struct wo
 
 	rfkill = container_of(work, struct rfkill, uevent_work);
 
-	rfkill_uevent(rfkill);
+	mutex_lock(&rfkill_global_mutex);
+	rfkill_event(rfkill);
+	mutex_unlock(&rfkill_global_mutex);
 }
 
 static void rfkill_sync_work(struct work_struct *work)
@@ -785,6 +871,7 @@ int __must_check rfkill_register(struct 
 		goto unlock;
 	}
 
+	rfkill->idx = rfkill_no;
 	dev_set_name(dev, "rfkill%lu", rfkill_no);
 	rfkill_no++;
 
@@ -819,6 +906,7 @@ int __must_check rfkill_register(struct 
 
 	INIT_WORK(&rfkill->sync_work, rfkill_sync_work);
 	schedule_work(&rfkill->sync_work);
+	rfkill_send_events(rfkill, RFKILL_OP_ADD);
 
 	mutex_unlock(&rfkill_global_mutex);
 	return 0;
@@ -848,6 +936,7 @@ void rfkill_unregister(struct rfkill *rf
 	device_del(&rfkill->dev);
 
 	mutex_lock(&rfkill_global_mutex);
+	rfkill_send_events(rfkill, RFKILL_OP_DEL);
 	list_del_init(&rfkill->node);
 	mutex_unlock(&rfkill_global_mutex);
 
@@ -862,6 +951,227 @@ void rfkill_destroy(struct rfkill *rfkil
 }
 EXPORT_SYMBOL(rfkill_destroy);
 
+static int rfkill_fop_open(struct inode *inode, struct file *file)
+{
+	struct rfkill_data *data;
+	struct rfkill *rfkill;
+	struct rfkill_int_event *ev, *tmp;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&data->events);
+	mutex_init(&data->mtx);
+	init_waitqueue_head(&data->read_wait);
+
+	mutex_lock(&rfkill_global_mutex);
+	mutex_lock(&data->mtx);
+	/*
+	 * start getting events from elsewhere but hold mtx to get
+	 * startup events added first
+	 */
+	list_add(&data->list, &rfkill_fds);
+
+	list_for_each_entry(rfkill, &rfkill_list, node) {
+		ev = kzalloc(sizeof(*ev), GFP_KERNEL);
+		if (!ev)
+			goto free;
+		rfkill_fill_event(&ev->ev, rfkill, RFKILL_OP_ADD);
+		list_add_tail(&ev->list, &data->events);
+	}
+	mutex_unlock(&data->mtx);
+	mutex_unlock(&rfkill_global_mutex);
+
+	file->private_data = data;
+
+	return nonseekable_open(inode, file);
+
+ free:
+	mutex_unlock(&data->mtx);
+	mutex_unlock(&rfkill_global_mutex);
+	mutex_destroy(&data->mtx);
+	list_for_each_entry_safe(ev, tmp, &data->events, list)
+		kfree(ev);
+	kfree(data);
+	return -ENOMEM;
+}
+
+static unsigned int rfkill_fop_poll(struct file *file, poll_table *wait)
+{
+	struct rfkill_data *data = file->private_data;
+	unsigned int res = POLLOUT | POLLWRNORM;
+
+	poll_wait(file, &data->read_wait, wait);
+
+	mutex_lock(&data->mtx);
+	if (!list_empty(&data->events))
+		res = POLLIN | POLLRDNORM;
+	mutex_unlock(&data->mtx);
+
+	return res;
+}
+
+static bool rfkill_readable(struct rfkill_data *data)
+{
+	bool r;
+
+	mutex_lock(&data->mtx);
+	r = !list_empty(&data->events);
+	mutex_unlock(&data->mtx);
+
+	return r;
+}
+
+static ssize_t rfkill_fop_read(struct file *file, char __user *buf,
+			       size_t count, loff_t *pos)
+{
+	struct rfkill_data *data = file->private_data;
+	struct rfkill_int_event *ev;
+	unsigned long sz;
+	int ret;
+
+	mutex_lock(&data->mtx);
+
+	while (list_empty(&data->events)) {
+		if (file->f_flags & O_NONBLOCK) {
+			ret = -EAGAIN;
+			goto out;
+		}
+		mutex_unlock(&data->mtx);
+		ret = wait_event_interruptible(data->read_wait,
+					       rfkill_readable(data));
+		mutex_lock(&data->mtx);
+
+		if (ret)
+			goto out;
+	}
+
+	ev = list_first_entry(&data->events, struct rfkill_int_event,
+				list);
+
+	sz = min_t(unsigned long, sizeof(ev->ev), count);
+	ret = sz;
+	if (copy_to_user(buf, &ev->ev, sz))
+		ret = -EFAULT;
+
+	list_del(&ev->list);
+	kfree(ev);
+ out:
+	mutex_unlock(&data->mtx);
+	return ret;
+}
+
+static ssize_t rfkill_fop_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *pos)
+{
+	struct rfkill *rfkill;
+	struct rfkill_event ev;
+
+	/* we don't need the 'hard' variable but accept it */
+	if (count < sizeof(ev) - 1)
+		return -EINVAL;
+
+	if (copy_from_user(&ev, buf, sizeof(ev) - 1))
+		return -EFAULT;
+
+	if (ev.op != RFKILL_OP_CHANGE && ev.op != RFKILL_OP_CHANGE_ALL)
+		return -EINVAL;
+
+	if (ev.type >= NUM_RFKILL_TYPES)
+		return -EINVAL;
+
+	mutex_lock(&rfkill_global_mutex);
+
+	if (ev.op == RFKILL_OP_CHANGE_ALL) {
+		if (ev.type == RFKILL_TYPE_ALL) {
+			enum rfkill_type i;
+			for (i = 0; i < NUM_RFKILL_TYPES; i++)
+				rfkill_global_states[i].cur = ev.soft;
+		} else {
+			rfkill_global_states[ev.type].cur = ev.soft;
+		}
+	}
+
+	list_for_each_entry(rfkill, &rfkill_list, node) {
+		if (rfkill->idx != ev.idx && ev.op != RFKILL_OP_CHANGE_ALL)
+			continue;
+
+		if (rfkill->type != ev.type && ev.type != RFKILL_TYPE_ALL)
+			continue;
+
+		rfkill_set_block(rfkill, ev.soft);
+	}
+	mutex_unlock(&rfkill_global_mutex);
+
+	return count;
+}
+
+static int rfkill_fop_release(struct inode *inode, struct file *file)
+{
+	struct rfkill_data *data = file->private_data;
+	struct rfkill_int_event *ev, *tmp;
+
+	mutex_lock(&rfkill_global_mutex);
+	list_del(&data->list);
+	mutex_unlock(&rfkill_global_mutex);
+
+	mutex_destroy(&data->mtx);
+	list_for_each_entry_safe(ev, tmp, &data->events, list)
+		kfree(ev);
+
+#ifdef CONFIG_RFKILL_INPUT
+	if (data->input_handler)
+		atomic_dec(&rfkill_input_disabled);
+#endif
+
+	kfree(data);
+
+	return 0;
+}
+
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
+static const struct file_operations rfkill_fops = {
+	.open		= rfkill_fop_open,
+	.read		= rfkill_fop_read,
+	.write		= rfkill_fop_write,
+	.poll		= rfkill_fop_poll,
+	.release	= rfkill_fop_release,
+#ifdef CONFIG_RFKILL_INPUT
+	.unlocked_ioctl	= rfkill_fop_ioctl,
+	.compat_ioctl	= rfkill_fop_ioctl,
+#endif
+};
+
+static struct miscdevice rfkill_miscdev = {
+	.name	= "rfkill",
+	.fops	= &rfkill_fops,
+	.minor	= MISC_DYNAMIC_MINOR,
+};
 
 static int __init rfkill_init(void)
 {
@@ -875,10 +1185,19 @@ static int __init rfkill_init(void)
 	if (error)
 		goto out;
 
+	error = misc_register(&rfkill_miscdev);
+	if (error) {
+		class_unregister(&rfkill_class);
+		goto out;
+	}
+
 #ifdef CONFIG_RFKILL_INPUT
 	error = rfkill_handler_init();
-	if (error)
+	if (error) {
+		misc_deregister(&rfkill_miscdev);
 		class_unregister(&rfkill_class);
+		goto out;
+	}
 #endif
 
  out:
@@ -891,6 +1210,7 @@ static void __exit rfkill_exit(void)
 #ifdef CONFIG_RFKILL_INPUT
 	rfkill_handler_exit();
 #endif
+	misc_deregister(&rfkill_miscdev);
 	class_unregister(&rfkill_class);
 }
 module_exit(rfkill_exit);
--- wireless-testing.orig/net/rfkill/Kconfig	2009-06-01 22:34:04.000000000 +0200
+++ wireless-testing/net/rfkill/Kconfig	2009-06-01 22:36:50.000000000 +0200
@@ -18,7 +18,7 @@ config RFKILL_LEDS
 	default y
 
 config RFKILL_INPUT
-	bool
+	bool "RF switch input support"
 	depends on RFKILL
 	depends on INPUT = y || RFKILL = INPUT
-	default y
+	default y if !EMBEDDED
--- wireless-testing.orig/Documentation/feature-removal-schedule.txt	2009-06-01 22:32:03.000000000 +0200
+++ wireless-testing/Documentation/feature-removal-schedule.txt	2009-06-01 22:36:50.000000000 +0200
@@ -437,3 +437,10 @@ Why:	Superseded by tdfxfb. I2C/DDC suppo
 	driver but this caused driver conflicts.
 Who:	Jean Delvare <khali@linux-fr.org>
 	Krzysztof Helt <krzysztof.h1@wp.pl>
+
+---------------------------
+
+What:	CONFIG_RFKILL_INPUT
+When:	2.6.33
+Why:	Should be implemented in userspace, policy daemon.
+Who:	Johannes Berg <johannes@sipsolutions.net>

-- 

