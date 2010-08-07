Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51955 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab0HGNc7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 09:32:59 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/4] compat: backport n_tty_ioctl_helper
Date: Sat,  7 Aug 2010 15:32:18 +0200
Message-Id: <1281187941-7168-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1281187941-7168-1-git-send-email-hauke@hauke-m.de>
References: <1281187941-7168-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function is needed by some bluetooth drivers

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.28.c        |  128 +++++++++++++++++++++++++++++++++++++++++
 include/linux/compat-2.6.28.h |    6 ++
 2 files changed, 134 insertions(+), 0 deletions(-)

diff --git a/compat/compat-2.6.28.c b/compat/compat-2.6.28.c
index 115bd23..bfb645a 100644
--- a/compat/compat-2.6.28.c
+++ b/compat/compat-2.6.28.c
@@ -13,6 +13,8 @@
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28))
 
 #include <linux/usb.h>
+#include <linux/tty.h>
+#include <asm/poll.h>
 
 /* 2.6.28 compat code goes here */
 
@@ -370,4 +372,130 @@ void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page, int off,
 }
 EXPORT_SYMBOL(skb_add_rx_frag);
 
+void tty_write_unlock(struct tty_struct *tty)
+{
+	mutex_unlock(&tty->atomic_write_lock);
+	wake_up_interruptible_poll(&tty->write_wait, POLLOUT);
+}
+
+int tty_write_lock(struct tty_struct *tty, int ndelay)
+{
+	if (!mutex_trylock(&tty->atomic_write_lock)) {
+		if (ndelay)
+			return -EAGAIN;
+		if (mutex_lock_interruptible(&tty->atomic_write_lock))
+			return -ERESTARTSYS;
+	}
+	return 0;
+}
+
+/**
+ *	send_prio_char		-	send priority character
+ *
+ *	Send a high priority character to the tty even if stopped
+ *
+ *	Locking: none for xchar method, write ordering for write method.
+ */
+
+static int send_prio_char(struct tty_struct *tty, char ch)
+{
+	int	was_stopped = tty->stopped;
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26))
+	if (tty->ops->send_xchar) {
+		tty->ops->send_xchar(tty, ch);
+#else
+	if (tty->driver->send_xchar) {
+		tty->driver->send_xchar(tty, ch);
+#endif
+		return 0;
+	}
+
+	if (tty_write_lock(tty, 0) < 0)
+		return -ERESTARTSYS;
+
+	if (was_stopped)
+		start_tty(tty);
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26))
+	tty->ops->write(tty, &ch, 1);
+#else
+	tty->driver->write(tty, &ch, 1);
+#endif
+	if (was_stopped)
+		stop_tty(tty);
+	tty_write_unlock(tty);
+	return 0;
+}
+
+int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
+		       unsigned int cmd, unsigned long arg)
+{
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26))
+	unsigned long flags;
+#endif
+	int retval;
+
+	switch (cmd) {
+	case TCXONC:
+		retval = tty_check_change(tty);
+		if (retval)
+			return retval;
+		switch (arg) {
+		case TCOOFF:
+			if (!tty->flow_stopped) {
+				tty->flow_stopped = 1;
+				stop_tty(tty);
+			}
+			break;
+		case TCOON:
+			if (tty->flow_stopped) {
+				tty->flow_stopped = 0;
+				start_tty(tty);
+			}
+			break;
+		case TCIOFF:
+			if (STOP_CHAR(tty) != __DISABLED_CHAR)
+				return send_prio_char(tty, STOP_CHAR(tty));
+			break;
+		case TCION:
+			if (START_CHAR(tty) != __DISABLED_CHAR)
+				return send_prio_char(tty, START_CHAR(tty));
+			break;
+		default:
+			return -EINVAL;
+		}
+		return 0;
+	case TCFLSH:
+		return tty_perform_flush(tty, arg);
+	case TIOCPKT:
+	{
+		int pktmode;
+
+		if (tty->driver->type != TTY_DRIVER_TYPE_PTY ||
+		    tty->driver->subtype != PTY_TYPE_MASTER)
+			return -ENOTTY;
+		if (get_user(pktmode, (int __user *) arg))
+			return -EFAULT;
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26))
+		spin_lock_irqsave(&tty->ctrl_lock, flags);
+#endif
+		if (pktmode) {
+			if (!tty->packet) {
+				tty->packet = 1;
+				tty->link->ctrl_status = 0;
+			}
+		} else
+			tty->packet = 0;
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26))
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+#endif
+		return 0;
+	}
+	default:
+		/* Try the mode commands */
+		return tty_mode_ioctl(tty, file, cmd, arg);
+	}
+}
+EXPORT_SYMBOL(n_tty_ioctl_helper);
+
 #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28) */
diff --git a/include/linux/compat-2.6.28.h b/include/linux/compat-2.6.28.h
index 7160548..649fbbc 100644
--- a/include/linux/compat-2.6.28.h
+++ b/include/linux/compat-2.6.28.h
@@ -230,6 +230,12 @@ unsigned long round_jiffies_up(unsigned long j);
 extern void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page,
 			    int off, int size);
 
+#define wake_up_interruptible_poll(x, m)			\
+	__wake_up(x, TASK_INTERRUPTIBLE, 1, (void *) (m))
+
+extern int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
+		       unsigned int cmd, unsigned long arg);
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)) */
 
 #endif /* LINUX_26_28_COMPAT_H */
-- 
1.7.0.4

