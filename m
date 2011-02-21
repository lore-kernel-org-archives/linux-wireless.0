Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36279 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab1BUWbp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 17:31:45 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/7] compat-wireless: some updates to bluetooth patch
Date: Mon, 21 Feb 2011 23:31:20 +0100
Message-Id: <1298327484-16938-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1298327484-16938-1-git-send-email-hauke@hauke-m.de>
References: <1298327484-16938-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * rfkill_backport.h will be included in rfkill.h
 * tty does not have a dev member on older kernel versions
 * hid->hid_get_raw_report was introduced in very recent kernel versions
 * the signature of some callback functions changed

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/16-bluetooth.patch |  130 +++++++++++++++++++++++++++++---------------
 1 files changed, 87 insertions(+), 43 deletions(-)

diff --git a/patches/16-bluetooth.patch b/patches/16-bluetooth.patch
index d54e517..57863ac 100644
--- a/patches/16-bluetooth.patch
+++ b/patches/16-bluetooth.patch
@@ -17,7 +17,17 @@ here still, but for now we keep this here.
  	tty_driver_flush_buffer(tty);
  
  	return 0;
-@@ -497,7 +502,11 @@ static int hci_uart_tty_ioctl(struct tty
+@@ -398,7 +403,9 @@ static int hci_uart_register_dev(struct
+ 	hdev->flush = hci_uart_flush;
+ 	hdev->send  = hci_uart_send_frame;
+ 	hdev->destruct = hci_uart_destruct;
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37)
+ 	hdev->parent = hu->tty->dev;
++#endif
+ 
+ 	hdev->owner = THIS_MODULE;
+ 
+@@ -498,7 +505,11 @@ static int hci_uart_tty_ioctl(struct tty
  		return hu->hdev_flags;
  
  	default:
@@ -82,21 +92,6 @@ here still, but for now we keep this here.
  
  	atomic_inc(&session->terminate);
  	cmtp_schedule(session);
---- a/net/bluetooth/hci_core.c
-+++ b/net/bluetooth/hci_core.c
-@@ -40,7 +40,12 @@
- #include <linux/workqueue.h>
- #include <linux/interrupt.h>
- #include <linux/notifier.h>
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
- #include <linux/rfkill.h>
-+#else
-+#include <linux/rfkill_backport.h>
-+#endif
-+
- #include <net/sock.h>
- 
- #include <asm/system.h>
 --- a/net/bluetooth/hci_sock.c
 +++ b/net/bluetooth/hci_sock.c
 @@ -605,7 +605,11 @@ drop:
@@ -164,17 +159,17 @@ here still, but for now we keep this here.
  };
 --- a/net/bluetooth/hidp/core.c
 +++ b/net/bluetooth/hidp/core.c
-@@ -316,6 +316,7 @@ static int hidp_send_report(struct hidp_
- 	return hidp_queue_report(session, buf, rsize);
+@@ -397,6 +397,7 @@ err_eio:
+ 	return -EIO;
  }
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
  static int hidp_output_raw_report(struct hid_device *hid, unsigned char *data, size_t count,
  		unsigned char report_type)
  {
-@@ -335,6 +336,16 @@ static int hidp_output_raw_report(struct
- 		return -ENOMEM;
- 	return count;
+@@ -456,6 +457,16 @@ err:
+ 	mutex_unlock(&session->report_mutex);
+ 	return ret;
  }
 +#elif (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
 +static int hidp_output_raw_report(struct hid_device *hid, unsigned char *data, size_t count)
@@ -189,7 +184,7 @@ here still, but for now we keep this here.
  
  static void hidp_idle_timeout(unsigned long arg)
  {
-@@ -600,8 +611,14 @@ static int hidp_session(void *arg)
+@@ -752,8 +763,14 @@ static int hidp_session(void *arg)
  	}
  
  	if (session->hid) {
@@ -204,7 +199,7 @@ here still, but for now we keep this here.
  	}
  
  	/* Wakeup user-space polling for socket errors */
-@@ -714,6 +731,70 @@ static void hidp_close(struct hid_device
+@@ -866,6 +883,70 @@ static void hidp_close(struct hid_device
  {
  }
  
@@ -275,7 +270,17 @@ here still, but for now we keep this here.
  static int hidp_parse(struct hid_device *hid)
  {
  	struct hidp_session *session = hid->driver_data;
-@@ -814,6 +895,7 @@ fault:
+@@ -950,7 +1031,9 @@ static int hidp_setup_hid(struct hidp_se
+ 	hid->dev.parent = hidp_get_device(session);
+ 	hid->ll_driver = &hidp_hid_driver;
+ 
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,38))
+ 	hid->hid_get_raw_report = hidp_get_raw_report;
++#endif
+ 	hid->hid_output_raw_report = hidp_output_raw_report;
+ 
+ 	return 0;
+@@ -961,6 +1044,7 @@ fault:
  
  	return err;
  }
@@ -283,7 +288,7 @@ here still, but for now we keep this here.
  
  int hidp_add_connection(struct hidp_connadd_req *req, struct socket *ctrl_sock, struct socket *intr_sock)
  {
-@@ -832,6 +914,39 @@ int hidp_add_connection(struct hidp_conn
+@@ -979,6 +1063,39 @@ int hidp_add_connection(struct hidp_conn
  
  	BT_DBG("rd_data %p rd_size %d", req->rd_data, req->rd_size);
  
@@ -323,7 +328,7 @@ here still, but for now we keep this here.
  	down_write(&hidp_session_sem);
  
  	s = __hidp_get_session(&bt_sk(ctrl_sock->sk)->dst);
-@@ -859,6 +974,7 @@ int hidp_add_connection(struct hidp_conn
+@@ -1010,6 +1127,7 @@ int hidp_add_connection(struct hidp_conn
  	session->flags   = req->flags & (1 << HIDP_BLUETOOTH_VENDOR_ID);
  	session->idle_to = req->idle_to;
  
@@ -331,7 +336,7 @@ here still, but for now we keep this here.
  	if (req->rd_size > 0) {
  		err = hidp_setup_hid(session, req);
  		if (err && err != -ENODEV)
-@@ -870,6 +986,16 @@ int hidp_add_connection(struct hidp_conn
+@@ -1021,6 +1139,16 @@ int hidp_add_connection(struct hidp_conn
  		if (err < 0)
  			goto purge;
  	}
@@ -348,7 +353,7 @@ here still, but for now we keep this here.
  
  	__hidp_link_session(session);
  
-@@ -901,6 +1027,7 @@ unlink:
+@@ -1066,6 +1194,7 @@ unlink:
  		session->input = NULL;
  	}
  
@@ -356,7 +361,7 @@ here still, but for now we keep this here.
  	if (session->hid) {
  		hid_destroy_device(session->hid);
  		session->hid = NULL;
-@@ -912,10 +1039,15 @@ unlink:
+@@ -1077,10 +1206,15 @@ unlink:
  purge:
  	skb_queue_purge(&session->ctrl_transmit);
  	skb_queue_purge(&session->intr_transmit);
@@ -372,7 +377,7 @@ here still, but for now we keep this here.
  	input_free_device(session->input);
  	kfree(session);
  	return err;
-@@ -1005,6 +1137,7 @@ int hidp_get_conninfo(struct hidp_connin
+@@ -1170,6 +1304,7 @@ int hidp_get_conninfo(struct hidp_connin
  	return err;
  }
  
@@ -380,7 +385,7 @@ here still, but for now we keep this here.
  static const struct hid_device_id hidp_table[] = {
  	{ HID_BLUETOOTH_DEVICE(HID_ANY_ID, HID_ANY_ID) },
  	{ }
-@@ -1014,6 +1147,7 @@ static struct hid_driver hidp_driver = {
+@@ -1179,6 +1314,7 @@ static struct hid_driver hidp_driver = {
  	.name = "generic-bluetooth",
  	.id_table = hidp_table,
  };
@@ -388,7 +393,7 @@ here still, but for now we keep this here.
  
  static int __init hidp_init(void)
  {
-@@ -1023,11 +1157,14 @@ static int __init hidp_init(void)
+@@ -1186,11 +1322,14 @@ static int __init hidp_init(void)
  
  	BT_INFO("HIDP (Human Interface Emulation) ver %s", VERSION);
  
@@ -403,7 +408,7 @@ here still, but for now we keep this here.
  	if (ret)
  		goto err_drv;
  
-@@ -1035,13 +1172,16 @@ static int __init hidp_init(void)
+@@ -1198,13 +1337,16 @@ static int __init hidp_init(void)
  err_drv:
  	hid_unregister_driver(&hidp_driver);
  err:
@@ -450,7 +455,7 @@ here still, but for now we keep this here.
  	struct bt_security sec;
 --- a/net/bluetooth/rfcomm/tty.c
 +++ b/net/bluetooth/rfcomm/tty.c
-@@ -733,8 +733,12 @@ static int rfcomm_tty_open(struct tty_st
+@@ -735,8 +735,12 @@ static int rfcomm_tty_open(struct tty_st
  	remove_wait_queue(&dev->wait, &wait);
  
  	if (err == 0)
@@ -463,7 +468,7 @@ here still, but for now we keep this here.
  
  	rfcomm_tty_copy_pending(dev);
  
-@@ -754,7 +758,11 @@ static void rfcomm_tty_close(struct tty_
+@@ -756,7 +760,11 @@ static void rfcomm_tty_close(struct tty_
  
  	if (atomic_dec_and_test(&dev->opened)) {
  		if (dev->tty_dev->parent)
@@ -475,9 +480,45 @@ here still, but for now we keep this here.
  
  		/* Close DLC and dettach TTY */
  		rfcomm_dlc_close(dev->dlc, 0);
+@@ -832,7 +840,11 @@ static int rfcomm_tty_write_room(struct
+ 	return room;
+ }
+ 
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,38))
+ static int rfcomm_tty_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
++#else
++static int rfcomm_tty_ioctl(struct tty_struct *tty, struct file *filp, unsigned int cmd, unsigned long arg)
++#endif
+ {
+ 	BT_DBG("tty %p cmd 0x%02x", tty, cmd);
+ 
+@@ -1091,7 +1103,11 @@ static void rfcomm_tty_hangup(struct tty
+ 	}
+ }
+ 
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,38))
+ static int rfcomm_tty_tiocmget(struct tty_struct *tty)
++#else
++static int rfcomm_tty_tiocmget(struct tty_struct *tty, struct file *filp)
++#endif
+ {
+ 	struct rfcomm_dev *dev = (struct rfcomm_dev *) tty->driver_data;
+ 
+@@ -1100,7 +1116,11 @@ static int rfcomm_tty_tiocmget(struct tt
+ 	return dev->modem_status;
+ }
+ 
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,38))
+ static int rfcomm_tty_tiocmset(struct tty_struct *tty, unsigned int set, unsigned int clear)
++#else
++static int rfcomm_tty_tiocmset(struct tty_struct *tty, struct file *filp, unsigned int set, unsigned int clear)
++#endif
+ {
+ 	struct rfcomm_dev *dev = (struct rfcomm_dev *) tty->driver_data;
+ 	struct rfcomm_dlc *dlc = dev->dlc;
 --- a/net/bluetooth/sco.c
 +++ b/net/bluetooth/sco.c
-@@ -430,8 +430,12 @@ static struct sock *sco_sock_alloc(struc
+@@ -428,8 +428,12 @@ static struct sock *sco_sock_alloc(struc
  	return sk;
  }
  
@@ -490,7 +531,7 @@ here still, but for now we keep this here.
  {
  	struct sock *sk;
  
-@@ -647,7 +651,11 @@ static int sco_sock_sendmsg(struct kiocb
+@@ -645,7 +649,11 @@ static int sco_sock_sendmsg(struct kiocb
  	return err;
  }
  
@@ -504,7 +545,7 @@ here still, but for now we keep this here.
  	int err = 0;
 --- a/net/bluetooth/bnep/sock.c
 +++ b/net/bluetooth/bnep/sock.c
-@@ -195,8 +195,12 @@ static struct proto bnep_proto = {
+@@ -196,8 +196,12 @@ static struct proto bnep_proto = {
  	.obj_size	= sizeof(struct bt_sock)
  };
  
@@ -549,19 +590,22 @@ here still, but for now we keep this here.
  
 --- a/net/bluetooth/l2cap_sock.c
 +++ b/net/bluetooth/l2cap_sock.c
-@@ -520,7 +520,11 @@ static int l2cap_sock_getsockopt(struct
+@@ -610,7 +610,14 @@ static int l2cap_sock_setsockopt_old(str
  	return err;
  }
  
++
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,31))
- static int l2cap_sock_setsockopt_old(struct socket *sock, int optname, char __user *optval, unsigned int optlen)
+ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname, char __user *optval, unsigned int optlen)
 +#else
 +static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname, char __user *optval, int optlen)
 +#endif
++
++
  {
  	struct sock *sk = sock->sk;
- 	struct l2cap_options opts;
-@@ -1067,8 +1071,12 @@ struct sock *l2cap_sock_alloc(struct net
+ 	struct bt_security sec;
+@@ -1073,8 +1080,12 @@ struct sock *l2cap_sock_alloc(struct net
  	return sk;
  }
  
@@ -574,7 +618,7 @@ here still, but for now we keep this here.
  {
  	struct sock *sk;
  
-@@ -1080,7 +1088,11 @@ static int l2cap_sock_create(struct net
+@@ -1086,7 +1097,11 @@ static int l2cap_sock_create(struct net
  			sock->type != SOCK_DGRAM && sock->type != SOCK_RAW)
  		return -ESOCKTNOSUPPORT;
  
-- 
1.7.1

