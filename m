Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50169 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab1I0GcI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 02:32:08 -0400
Received: by bkbzt4 with SMTP id zt4so6547941bkb.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 23:32:07 -0700 (PDT)
From: "Andrew V. Stepanov" <stanv@altlinux.org>
To: davem@davemloft.net, johannes@sipsolutions.net,
	linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Andriy Stepanov <stanv@altlinux.ru>
Subject: [PATCH 1/1] rfkill: add module option to become inactive.
Date: Tue, 27 Sep 2011 14:33:44 +0400
Message-Id: <1317119624-2974-1-git-send-email-stanv@altlinux.org> (sfid-20110927_083212_437891_6ED195FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andriy Stepanov <stanv@altlinux.ru>

Use as:
modprobe rfkill unblocked=1
or
/etc/modprobe.d/options
options rfkill unblocked=1

Signed-off-by: Andriy Stepanov <stanv@altlinux.ru>
---
 net/rfkill/core.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index be90640..9d9014a 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -47,6 +47,10 @@
 				 RFKILL_BLOCK_SW_PREV)
 #define RFKILL_BLOCK_SW_SETCALL	BIT(31)
 
+int rfkill_unblocked;
+module_param_named(unblocked, rfkill_unblocked, int, 0);
+MODULE_PARM_DESC(unblocked, "rfkill subsystem become inactive.");
+
 struct rfkill {
 	spinlock_t		lock;
 
@@ -455,6 +459,10 @@ bool rfkill_set_hw_state(struct rfkill *rfkill, bool blocked)
 {
 	bool ret, change;
 
+	if (rfkill_unblocked) {
+		return blocked;
+	}
+
 	ret = __rfkill_set_hw_state(rfkill, blocked, &change);
 
 	if (!rfkill->registered)
@@ -486,6 +494,10 @@ bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
 	unsigned long flags;
 	bool prev, hwblock;
 
+	if (rfkill_unblocked) {
+		return blocked;
+	}
+
 	BUG_ON(!rfkill);
 
 	spin_lock_irqsave(&rfkill->lock, flags);
@@ -511,6 +523,10 @@ void rfkill_init_sw_state(struct rfkill *rfkill, bool blocked)
 {
 	unsigned long flags;
 
+	if (rfkill_unblocked) {
+		return;
+	}
+
 	BUG_ON(!rfkill);
 	BUG_ON(rfkill->registered);
 
@@ -526,6 +542,10 @@ void rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw)
 	unsigned long flags;
 	bool swprev, hwprev;
 
+	if (rfkill_unblocked) {
+		return;
+	}
+
 	BUG_ON(!rfkill);
 
 	spin_lock_irqsave(&rfkill->lock, flags);
@@ -760,6 +780,10 @@ static int rfkill_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 void rfkill_pause_polling(struct rfkill *rfkill)
 {
+	if (rfkill_unblocked) {
+		return;
+	}
+
 	BUG_ON(!rfkill);
 
 	if (!rfkill->ops->poll)
@@ -771,6 +795,10 @@ EXPORT_SYMBOL(rfkill_pause_polling);
 
 void rfkill_resume_polling(struct rfkill *rfkill)
 {
+	if (rfkill_unblocked) {
+		return;
+	}
+
 	BUG_ON(!rfkill);
 
 	if (!rfkill->ops->poll)
@@ -818,6 +846,10 @@ bool rfkill_blocked(struct rfkill *rfkill)
 	unsigned long flags;
 	u32 state;
 
+	if (rfkill_unblocked) {
+		return false;
+	}
+
 	spin_lock_irqsave(&rfkill->lock, flags);
 	state = rfkill->state;
 	spin_unlock_irqrestore(&rfkill->lock, flags);
@@ -836,6 +868,11 @@ struct rfkill * __must_check rfkill_alloc(const char *name,
 	struct rfkill *rfkill;
 	struct device *dev;
 
+	if (rfkill_unblocked) {
+		printk(KERN_DEBUG "rfkill: ignore object allocation.\n");
+		return ERR_PTR(-ENODEV);
+	}
+
 	if (WARN_ON(!ops))
 		return NULL;
 
@@ -915,6 +952,14 @@ int __must_check rfkill_register(struct rfkill *rfkill)
 	struct device *dev = &rfkill->dev;
 	int error;
 
+	if (rfkill_unblocked) {
+		if (rfkill == ERR_PTR(-ENODEV)) {
+			return 0;
+		} else {
+			return -EINVAL;
+		}
+	}
+
 	BUG_ON(!rfkill);
 
 	mutex_lock(&rfkill_global_mutex);
@@ -978,6 +1023,10 @@ void rfkill_unregister(struct rfkill *rfkill)
 {
 	BUG_ON(!rfkill);
 
+	if (rfkill_unblocked) {
+		return;
+	}
+
 	if (rfkill->ops->poll)
 		cancel_delayed_work_sync(&rfkill->poll_work);
 
@@ -999,6 +1048,11 @@ EXPORT_SYMBOL(rfkill_unregister);
 
 void rfkill_destroy(struct rfkill *rfkill)
 {
+
+	if (rfkill_unblocked) {
+		return;
+	}
+
 	if (rfkill)
 		put_device(&rfkill->dev);
 }
-- 
1.7.4.4

