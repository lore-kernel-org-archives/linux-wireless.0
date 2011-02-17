Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36995 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737Ab1BQWtx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 17:49:53 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: adapt to changes in bluetooth
Date: Thu, 17 Feb 2011 23:49:38 +0100
Message-Id: <1297982979-7592-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * The changed symbols are bool now
 * rfkill_backport.h will be included in rfkill.h

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                  |    4 +-
 patches/16-bluetooth.patch |   73 ++++++++++++++++++++-----------------------
 2 files changed, 36 insertions(+), 41 deletions(-)

diff --git a/config.mk b/config.mk
index e7f04ea..b3e5f28 100644
--- a/config.mk
+++ b/config.mk
@@ -159,8 +159,8 @@ CONFIG_LIB80211_CRYPT_TKIP=m
 # CONFIG_LIB80211_DEBUG=y
 
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/patches/16-bluetooth.patch b/patches/16-bluetooth.patch
index d54e517..f1ffbf4 100644
--- a/patches/16-bluetooth.patch
+++ b/patches/16-bluetooth.patch
@@ -17,7 +17,7 @@ here still, but for now we keep this here.
  	tty_driver_flush_buffer(tty);
  
  	return 0;
-@@ -497,7 +502,11 @@ static int hci_uart_tty_ioctl(struct tty
+@@ -498,7 +503,11 @@ static int hci_uart_tty_ioctl(struct tty
  		return hu->hdev_flags;
  
  	default:
@@ -82,21 +82,6 @@ here still, but for now we keep this here.
  
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
@@ -164,17 +149,17 @@ here still, but for now we keep this here.
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
@@ -189,7 +174,7 @@ here still, but for now we keep this here.
  
  static void hidp_idle_timeout(unsigned long arg)
  {
-@@ -600,8 +611,14 @@ static int hidp_session(void *arg)
+@@ -752,8 +763,14 @@ static int hidp_session(void *arg)
  	}
  
  	if (session->hid) {
@@ -204,7 +189,7 @@ here still, but for now we keep this here.
  	}
  
  	/* Wakeup user-space polling for socket errors */
-@@ -714,6 +731,70 @@ static void hidp_close(struct hid_device
+@@ -866,6 +883,70 @@ static void hidp_close(struct hid_device
  {
  }
  
@@ -275,7 +260,17 @@ here still, but for now we keep this here.
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
@@ -283,7 +278,7 @@ here still, but for now we keep this here.
  
  int hidp_add_connection(struct hidp_connadd_req *req, struct socket *ctrl_sock, struct socket *intr_sock)
  {
-@@ -832,6 +914,39 @@ int hidp_add_connection(struct hidp_conn
+@@ -979,6 +1063,39 @@ int hidp_add_connection(struct hidp_conn
  
  	BT_DBG("rd_data %p rd_size %d", req->rd_data, req->rd_size);
  
@@ -323,7 +318,7 @@ here still, but for now we keep this here.
  	down_write(&hidp_session_sem);
  
  	s = __hidp_get_session(&bt_sk(ctrl_sock->sk)->dst);
-@@ -859,6 +974,7 @@ int hidp_add_connection(struct hidp_conn
+@@ -1010,6 +1127,7 @@ int hidp_add_connection(struct hidp_conn
  	session->flags   = req->flags & (1 << HIDP_BLUETOOTH_VENDOR_ID);
  	session->idle_to = req->idle_to;
  
@@ -331,7 +326,7 @@ here still, but for now we keep this here.
  	if (req->rd_size > 0) {
  		err = hidp_setup_hid(session, req);
  		if (err && err != -ENODEV)
-@@ -870,6 +986,16 @@ int hidp_add_connection(struct hidp_conn
+@@ -1021,6 +1139,16 @@ int hidp_add_connection(struct hidp_conn
  		if (err < 0)
  			goto purge;
  	}
@@ -348,7 +343,7 @@ here still, but for now we keep this here.
  
  	__hidp_link_session(session);
  
-@@ -901,6 +1027,7 @@ unlink:
+@@ -1066,6 +1194,7 @@ unlink:
  		session->input = NULL;
  	}
  
@@ -356,7 +351,7 @@ here still, but for now we keep this here.
  	if (session->hid) {
  		hid_destroy_device(session->hid);
  		session->hid = NULL;
-@@ -912,10 +1039,15 @@ unlink:
+@@ -1077,10 +1206,15 @@ unlink:
  purge:
  	skb_queue_purge(&session->ctrl_transmit);
  	skb_queue_purge(&session->intr_transmit);
@@ -372,7 +367,7 @@ here still, but for now we keep this here.
  	input_free_device(session->input);
  	kfree(session);
  	return err;
-@@ -1005,6 +1137,7 @@ int hidp_get_conninfo(struct hidp_connin
+@@ -1170,6 +1304,7 @@ int hidp_get_conninfo(struct hidp_connin
  	return err;
  }
  
@@ -380,7 +375,7 @@ here still, but for now we keep this here.
  static const struct hid_device_id hidp_table[] = {
  	{ HID_BLUETOOTH_DEVICE(HID_ANY_ID, HID_ANY_ID) },
  	{ }
-@@ -1014,6 +1147,7 @@ static struct hid_driver hidp_driver = {
+@@ -1179,6 +1314,7 @@ static struct hid_driver hidp_driver = {
  	.name = "generic-bluetooth",
  	.id_table = hidp_table,
  };
@@ -388,7 +383,7 @@ here still, but for now we keep this here.
  
  static int __init hidp_init(void)
  {
-@@ -1023,11 +1157,14 @@ static int __init hidp_init(void)
+@@ -1186,11 +1322,14 @@ static int __init hidp_init(void)
  
  	BT_INFO("HIDP (Human Interface Emulation) ver %s", VERSION);
  
@@ -403,7 +398,7 @@ here still, but for now we keep this here.
  	if (ret)
  		goto err_drv;
  
-@@ -1035,13 +1172,16 @@ static int __init hidp_init(void)
+@@ -1198,13 +1337,16 @@ static int __init hidp_init(void)
  err_drv:
  	hid_unregister_driver(&hidp_driver);
  err:
@@ -477,7 +472,7 @@ here still, but for now we keep this here.
  		rfcomm_dlc_close(dev->dlc, 0);
 --- a/net/bluetooth/sco.c
 +++ b/net/bluetooth/sco.c
-@@ -430,8 +430,12 @@ static struct sock *sco_sock_alloc(struc
+@@ -428,8 +428,12 @@ static struct sock *sco_sock_alloc(struc
  	return sk;
  }
  
@@ -490,7 +485,7 @@ here still, but for now we keep this here.
  {
  	struct sock *sk;
  
-@@ -647,7 +651,11 @@ static int sco_sock_sendmsg(struct kiocb
+@@ -645,7 +649,11 @@ static int sco_sock_sendmsg(struct kiocb
  	return err;
  }
  
@@ -504,7 +499,7 @@ here still, but for now we keep this here.
  	int err = 0;
 --- a/net/bluetooth/bnep/sock.c
 +++ b/net/bluetooth/bnep/sock.c
-@@ -195,8 +195,12 @@ static struct proto bnep_proto = {
+@@ -196,8 +196,12 @@ static struct proto bnep_proto = {
  	.obj_size	= sizeof(struct bt_sock)
  };
  
@@ -549,7 +544,7 @@ here still, but for now we keep this here.
  
 --- a/net/bluetooth/l2cap_sock.c
 +++ b/net/bluetooth/l2cap_sock.c
-@@ -520,7 +520,11 @@ static int l2cap_sock_getsockopt(struct
+@@ -525,7 +525,11 @@ static int l2cap_sock_getsockopt(struct
  	return err;
  }
  
@@ -561,7 +556,7 @@ here still, but for now we keep this here.
  {
  	struct sock *sk = sock->sk;
  	struct l2cap_options opts;
-@@ -1067,8 +1071,12 @@ struct sock *l2cap_sock_alloc(struct net
+@@ -1073,8 +1077,12 @@ struct sock *l2cap_sock_alloc(struct net
  	return sk;
  }
  
@@ -574,7 +569,7 @@ here still, but for now we keep this here.
  {
  	struct sock *sk;
  
-@@ -1080,7 +1088,11 @@ static int l2cap_sock_create(struct net
+@@ -1086,7 +1094,11 @@ static int l2cap_sock_create(struct net
  			sock->type != SOCK_DGRAM && sock->type != SOCK_RAW)
  		return -ESOCKTNOSUPPORT;
  
-- 
1.7.1

