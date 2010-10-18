Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54628 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933151Ab0JRUhF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 16:37:05 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: backport sock_recv_ts_and_drops in compat
Date: Mon, 18 Oct 2010 22:36:54 +0200
Message-Id: <1287434215-8883-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/16-bluetooth.patch |   60 +++++++++++++------------------------------
 1 files changed, 18 insertions(+), 42 deletions(-)

diff --git a/patches/16-bluetooth.patch b/patches/16-bluetooth.patch
index 8bdc530..e58ccc6 100644
--- a/patches/16-bluetooth.patch
+++ b/patches/16-bluetooth.patch
@@ -56,19 +56,7 @@ here still, but for now we keep this here.
  		bt_sock_reclassify_lock(sock, proto);
  		module_put(bt_proto[proto]->owner);
  	}
-@@ -257,7 +265,11 @@ int bt_sock_recvmsg(struct kiocb *iocb, 
- 	skb_reset_transport_header(skb);
- 	err = skb_copy_datagram_iovec(skb, 0, msg->msg_iov, copied);
- 	if (err == 0)
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
- 		sock_recv_ts_and_drops(msg, sk, skb);
-+#else
-+		sock_recv_timestamp(msg, sk, skb);
-+#endif
- 
- 	skb_free_datagram(sk, skb);
- 
-@@ -336,7 +348,11 @@ int bt_sock_ioctl(struct socket *sock, u
+@@ -445,7 +457,11 @@ int bt_sock_ioctl(struct socket *sock, u
  		if (sk->sk_state == BT_LISTEN)
  			return -EINVAL;
  
@@ -138,7 +126,7 @@ here still, but for now we keep this here.
  
 --- a/net/bluetooth/hci_sysfs.c
 +++ b/net/bluetooth/hci_sysfs.c
-@@ -71,7 +71,11 @@ static struct attribute_group bt_link_gr
+@@ -69,7 +69,11 @@ static struct attribute_group bt_link_gr
  	.attrs = bt_link_attrs,
  };
  
@@ -150,7 +138,7 @@ here still, but for now we keep this here.
  	&bt_link_group,
  	NULL
  };
-@@ -129,7 +133,11 @@ static void del_conn(struct work_struct 
+@@ -127,7 +131,11 @@ static void del_conn(struct work_struct 
  		dev = device_find_child(&conn->dev, NULL, __match_tty);
  		if (!dev)
  			break;
@@ -162,7 +150,7 @@ here still, but for now we keep this here.
  		put_device(dev);
  	}
  
-@@ -381,7 +389,11 @@ static struct attribute_group bt_host_gr
+@@ -377,7 +385,11 @@ static struct attribute_group bt_host_gr
  	.attrs = bt_host_attrs,
  };
  
@@ -287,7 +275,7 @@ here still, but for now we keep this here.
  static int hidp_parse(struct hid_device *hid)
  {
  	struct hidp_session *session = hid->driver_data;
-@@ -815,6 +896,7 @@ fault:
+@@ -811,6 +892,7 @@ fault:
  
  	return err;
  }
@@ -295,7 +283,7 @@ here still, but for now we keep this here.
  
  int hidp_add_connection(struct hidp_connadd_req *req, struct socket *ctrl_sock, struct socket *intr_sock)
  {
-@@ -833,6 +915,39 @@ int hidp_add_connection(struct hidp_conn
+@@ -829,6 +911,39 @@ int hidp_add_connection(struct hidp_conn
  
  	BT_DBG("rd_data %p rd_size %d", req->rd_data, req->rd_size);
  
@@ -335,7 +323,7 @@ here still, but for now we keep this here.
  	down_write(&hidp_session_sem);
  
  	s = __hidp_get_session(&bt_sk(ctrl_sock->sk)->dst);
-@@ -860,6 +975,7 @@ int hidp_add_connection(struct hidp_conn
+@@ -856,6 +971,7 @@ int hidp_add_connection(struct hidp_conn
  	session->flags   = req->flags & (1 << HIDP_BLUETOOTH_VENDOR_ID);
  	session->idle_to = req->idle_to;
  
@@ -343,7 +331,7 @@ here still, but for now we keep this here.
  	if (req->rd_size > 0) {
  		err = hidp_setup_hid(session, req);
  		if (err && err != -ENODEV)
-@@ -871,6 +987,16 @@ int hidp_add_connection(struct hidp_conn
+@@ -867,6 +983,16 @@ int hidp_add_connection(struct hidp_conn
  		if (err < 0)
  			goto purge;
  	}
@@ -360,7 +348,7 @@ here still, but for now we keep this here.
  
  	__hidp_link_session(session);
  
-@@ -902,6 +1028,7 @@ unlink:
+@@ -898,6 +1024,7 @@ unlink:
  		session->input = NULL;
  	}
  
@@ -368,7 +356,7 @@ here still, but for now we keep this here.
  	if (session->hid) {
  		hid_destroy_device(session->hid);
  		session->hid = NULL;
-@@ -913,10 +1040,15 @@ unlink:
+@@ -909,10 +1036,15 @@ unlink:
  purge:
  	skb_queue_purge(&session->ctrl_transmit);
  	skb_queue_purge(&session->intr_transmit);
@@ -384,7 +372,7 @@ here still, but for now we keep this here.
  	input_free_device(session->input);
  	kfree(session);
  	return err;
-@@ -1006,6 +1138,7 @@ int hidp_get_conninfo(struct hidp_connin
+@@ -1002,6 +1134,7 @@ int hidp_get_conninfo(struct hidp_connin
  	return err;
  }
  
@@ -392,7 +380,7 @@ here still, but for now we keep this here.
  static const struct hid_device_id hidp_table[] = {
  	{ HID_BLUETOOTH_DEVICE(HID_ANY_ID, HID_ANY_ID) },
  	{ }
-@@ -1015,6 +1148,7 @@ static struct hid_driver hidp_driver = {
+@@ -1011,6 +1144,7 @@ static struct hid_driver hidp_driver = {
  	.name = "generic-bluetooth",
  	.id_table = hidp_table,
  };
@@ -400,7 +388,7 @@ here still, but for now we keep this here.
  
  static int __init hidp_init(void)
  {
-@@ -1024,11 +1158,14 @@ static int __init hidp_init(void)
+@@ -1020,11 +1154,14 @@ static int __init hidp_init(void)
  
  	BT_INFO("HIDP (Human Interface Emulation) ver %s", VERSION);
  
@@ -415,7 +403,7 @@ here still, but for now we keep this here.
  	if (ret)
  		goto err_drv;
  
-@@ -1036,13 +1173,16 @@ static int __init hidp_init(void)
+@@ -1032,13 +1169,16 @@ static int __init hidp_init(void)
  err_drv:
  	hid_unregister_driver(&hidp_driver);
  err:
@@ -448,19 +436,7 @@ here still, but for now we keep this here.
  {
  	struct sock *sk;
  
-@@ -711,7 +716,11 @@ static int rfcomm_sock_recvmsg(struct ki
- 		copied += chunk;
- 		size   -= chunk;
- 
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32))
- 		sock_recv_ts_and_drops(msg, sk, skb);
-+#else
-+		sock_recv_timestamp(msg, sk, skb);
-+#endif
- 
- 		if (!(flags & MSG_PEEK)) {
- 			atomic_sub(chunk, &sk->sk_rmem_alloc);
-@@ -774,7 +783,11 @@ static int rfcomm_sock_setsockopt_old(st
+@@ -682,7 +687,11 @@ static int rfcomm_sock_setsockopt_old(st
  	return err;
  }
  
@@ -474,7 +450,7 @@ here still, but for now we keep this here.
  	struct bt_security sec;
 --- a/net/bluetooth/rfcomm/tty.c
 +++ b/net/bluetooth/rfcomm/tty.c
-@@ -731,8 +731,12 @@ static int rfcomm_tty_open(struct tty_st
+@@ -729,8 +729,12 @@ static int rfcomm_tty_open(struct tty_st
  	remove_wait_queue(&dev->wait, &wait);
  
  	if (err == 0)
@@ -487,7 +463,7 @@ here still, but for now we keep this here.
  
  	rfcomm_tty_copy_pending(dev);
  
-@@ -752,7 +756,11 @@ static void rfcomm_tty_close(struct tty_
+@@ -750,7 +754,11 @@ static void rfcomm_tty_close(struct tty_
  
  	if (atomic_dec_and_test(&dev->opened)) {
  		if (dev->tty_dev->parent)
@@ -598,7 +574,7 @@ here still, but for now we keep this here.
  		return -EPERM;
  
  	sock->ops = &l2cap_sock_ops;
-@@ -2022,7 +2030,11 @@ static int l2cap_sock_setsockopt_old(str
+@@ -2042,7 +2050,11 @@ static int l2cap_sock_setsockopt_old(str
  	return err;
  }
  
-- 
1.7.0.4

