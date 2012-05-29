Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43898 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783Ab2E2Wj7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 18:39:59 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/8] compat-wireless: make patches apply again
Date: Wed, 30 May 2012 00:39:35 +0200
Message-Id: <1338331182-29589-2-git-send-email-hauke@hauke-m.de> (sfid-20120530_004008_180149_5ABBA76D)
In-Reply-To: <1338331182-29589-1-git-send-email-hauke@hauke-m.de>
References: <1338331182-29589-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/05-usb.patch                 |    4 +-
 patches/16-bluetooth.patch           |   72 +++++++++++++++++-----------------
 patches/24-pcmcia.patch              |   28 ++++++-------
 patches/46-use_other_workqueue.patch |    4 +-
 4 files changed, 55 insertions(+), 53 deletions(-)

diff --git a/patches/05-usb.patch b/patches/05-usb.patch
index 9b0cfea..7f78c6c 100644
--- a/patches/05-usb.patch
+++ b/patches/05-usb.patch
@@ -9,9 +9,9 @@ USB opt soft_unbid was added as of 2.6.27.
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
  	.soft_unbind = 1,
 +#endif
+ 	.disable_hub_initiated_lpm = 1,
  };
  
- module_usb_driver(p54u_driver);
 --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
 +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
 @@ -1357,7 +1357,9 @@ static struct usb_driver ath9k_hif_usb_d
@@ -21,6 +21,6 @@ USB opt soft_unbid was added as of 2.6.27.
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
  	.soft_unbind = 1,
 +#endif
+ 	.disable_hub_initiated_lpm = 1,
  };
  
- int ath9k_hif_usb_init(void)
diff --git a/patches/16-bluetooth.patch b/patches/16-bluetooth.patch
index 46794bb..90ec831 100644
--- a/patches/16-bluetooth.patch
+++ b/patches/16-bluetooth.patch
@@ -31,7 +31,7 @@ here still, but for now we keep this here.
  
 --- a/net/bluetooth/af_bluetooth.c
 +++ b/net/bluetooth/af_bluetooth.c
-@@ -122,8 +122,12 @@ int bt_sock_unregister(int proto)
+@@ -111,8 +111,12 @@ int bt_sock_unregister(int proto)
  }
  EXPORT_SYMBOL(bt_sock_unregister);
  
@@ -44,7 +44,7 @@ here still, but for now we keep this here.
  {
  	int err;
  
-@@ -141,7 +145,11 @@ static int bt_sock_create(struct net *ne
+@@ -130,7 +134,11 @@ static int bt_sock_create(struct net *ne
  	read_lock(&bt_proto_lock);
  
  	if (bt_proto[proto] && try_module_get(bt_proto[proto]->owner)) {
@@ -56,7 +56,7 @@ here still, but for now we keep this here.
  		if (!err)
  			bt_sock_reclassify_lock(sock->sk, proto);
  		module_put(bt_proto[proto]->owner);
-@@ -473,7 +481,11 @@ int bt_sock_ioctl(struct socket *sock, u
+@@ -463,7 +471,11 @@ int bt_sock_ioctl(struct socket *sock, u
  		if (sk->sk_state == BT_LISTEN)
  			return -EINVAL;
  
@@ -84,19 +84,21 @@ here still, but for now we keep this here.
  	wake_up_process(session->task);
 --- a/net/bluetooth/hci_sock.c
 +++ b/net/bluetooth/hci_sock.c
-@@ -891,7 +891,11 @@ drop:
+@@ -883,8 +883,13 @@ drop:
  	goto done;
  }
  
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,31))
- static int hci_sock_setsockopt(struct socket *sock, int level, int optname, char __user *optval, unsigned int len)
+ static int hci_sock_setsockopt(struct socket *sock, int level, int optname,
+ 			       char __user *optval, unsigned int len)
 +#else
-+static int hci_sock_setsockopt(struct socket *sock, int level, int optname, char __user *optval, int len)
++static int hci_sock_setsockopt(struct socket *sock, int level, int optname,
++			       char __user *optval, int len)
 +#endif
  {
  	struct hci_ufilter uf = { .opcode = 0 };
  	struct sock *sk = sock->sk;
-@@ -1063,8 +1067,12 @@ static struct proto hci_sk_proto = {
+@@ -1057,8 +1062,12 @@ static struct proto hci_sk_proto = {
  	.obj_size	= sizeof(struct hci_pinfo)
  };
  
@@ -111,7 +113,7 @@ here still, but for now we keep this here.
  
 --- a/net/bluetooth/hci_sysfs.c
 +++ b/net/bluetooth/hci_sysfs.c
-@@ -72,7 +72,11 @@ static struct attribute_group bt_link_gr
+@@ -71,7 +71,11 @@ static struct attribute_group bt_link_gr
  	.attrs = bt_link_attrs,
  };
  
@@ -123,7 +125,7 @@ here still, but for now we keep this here.
  	&bt_link_group,
  	NULL
  };
-@@ -141,7 +145,11 @@ void hci_conn_del_sysfs(struct hci_conn
+@@ -140,7 +144,11 @@ void hci_conn_del_sysfs(struct hci_conn
  		dev = device_find_child(&conn->dev, NULL, __match_tty);
  		if (!dev)
  			break;
@@ -135,7 +137,7 @@ here still, but for now we keep this here.
  		put_device(dev);
  	}
  
-@@ -361,7 +369,11 @@ static struct attribute_group bt_host_gr
+@@ -378,7 +386,11 @@ static struct attribute_group bt_host_gr
  	.attrs = bt_host_attrs,
  };
  
@@ -149,7 +151,7 @@ here still, but for now we keep this here.
  };
 --- a/net/bluetooth/hidp/core.c
 +++ b/net/bluetooth/hidp/core.c
-@@ -398,6 +398,7 @@ err:
+@@ -379,6 +379,7 @@ err:
  	return ret;
  }
  
@@ -157,7 +159,7 @@ here still, but for now we keep this here.
  static int hidp_output_raw_report(struct hid_device *hid, unsigned char *data, size_t count,
  		unsigned char report_type)
  {
-@@ -456,6 +457,16 @@ err:
+@@ -437,6 +438,16 @@ err:
  	mutex_unlock(&session->report_mutex);
  	return ret;
  }
@@ -174,7 +176,7 @@ here still, but for now we keep this here.
  
  static void hidp_idle_timeout(unsigned long arg)
  {
-@@ -757,8 +768,14 @@ static int hidp_session(void *arg)
+@@ -738,8 +749,14 @@ static int hidp_session(void *arg)
  	}
  
  	if (session->hid) {
@@ -189,7 +191,7 @@ here still, but for now we keep this here.
  	}
  
  	/* Wakeup user-space polling for socket errors */
-@@ -869,6 +886,70 @@ static void hidp_close(struct hid_device
+@@ -850,6 +867,70 @@ static void hidp_close(struct hid_device
  {
  }
  
@@ -260,7 +262,7 @@ here still, but for now we keep this here.
  static int hidp_parse(struct hid_device *hid)
  {
  	struct hidp_session *session = hid->driver_data;
-@@ -956,7 +1037,9 @@ static int hidp_setup_hid(struct hidp_se
+@@ -937,7 +1018,9 @@ static int hidp_setup_hid(struct hidp_se
  	hid->dev.parent = &session->conn->dev;
  	hid->ll_driver = &hidp_hid_driver;
  
@@ -270,7 +272,7 @@ here still, but for now we keep this here.
  	hid->hid_output_raw_report = hidp_output_raw_report;
  
  	return 0;
-@@ -967,6 +1050,7 @@ fault:
+@@ -948,6 +1031,7 @@ fault:
  
  	return err;
  }
@@ -278,7 +280,7 @@ here still, but for now we keep this here.
  
  int hidp_add_connection(struct hidp_connadd_req *req, struct socket *ctrl_sock, struct socket *intr_sock)
  {
-@@ -982,6 +1066,39 @@ int hidp_add_connection(struct hidp_conn
+@@ -963,6 +1047,39 @@ int hidp_add_connection(struct hidp_conn
  
  	BT_DBG("rd_data %p rd_size %d", req->rd_data, req->rd_size);
  
@@ -318,7 +320,7 @@ here still, but for now we keep this here.
  	down_write(&hidp_session_sem);
  
  	s = __hidp_get_session(&bt_sk(ctrl_sock->sk)->dst);
-@@ -1029,6 +1146,7 @@ int hidp_add_connection(struct hidp_conn
+@@ -1010,6 +1127,7 @@ int hidp_add_connection(struct hidp_conn
  
  	__hidp_link_session(session);
  
@@ -326,7 +328,7 @@ here still, but for now we keep this here.
  	if (req->rd_size > 0) {
  		err = hidp_setup_hid(session, req);
  		if (err)
-@@ -1040,6 +1158,16 @@ int hidp_add_connection(struct hidp_conn
+@@ -1021,6 +1139,16 @@ int hidp_add_connection(struct hidp_conn
  		if (err < 0)
  			goto purge;
  	}
@@ -343,7 +345,7 @@ here still, but for now we keep this here.
  
  	hidp_set_timer(session);
  
-@@ -1098,6 +1226,7 @@ unlink:
+@@ -1079,6 +1207,7 @@ unlink:
  		session->input = NULL;
  	}
  
@@ -351,7 +353,7 @@ here still, but for now we keep this here.
  	if (session->hid) {
  		hid_destroy_device(session->hid);
  		session->hid = NULL;
-@@ -1111,10 +1240,15 @@ purge:
+@@ -1092,10 +1221,15 @@ purge:
  
  	skb_queue_purge(&session->ctrl_transmit);
  	skb_queue_purge(&session->intr_transmit);
@@ -369,7 +371,7 @@ here still, but for now we keep this here.
  }
 --- a/net/bluetooth/rfcomm/sock.c
 +++ b/net/bluetooth/rfcomm/sock.c
-@@ -325,8 +325,13 @@ static struct sock *rfcomm_sock_alloc(st
+@@ -306,8 +306,13 @@ static struct sock *rfcomm_sock_alloc(st
  	return sk;
  }
  
@@ -383,7 +385,7 @@ here still, but for now we keep this here.
  {
  	struct sock *sk;
  
-@@ -680,7 +685,11 @@ static int rfcomm_sock_setsockopt_old(st
+@@ -661,7 +666,11 @@ static int rfcomm_sock_setsockopt_old(st
  	return err;
  }
  
@@ -397,7 +399,7 @@ here still, but for now we keep this here.
  	struct bt_security sec;
 --- a/net/bluetooth/rfcomm/tty.c
 +++ b/net/bluetooth/rfcomm/tty.c
-@@ -718,8 +718,12 @@ static int rfcomm_tty_open(struct tty_st
+@@ -713,8 +713,12 @@ static int rfcomm_tty_open(struct tty_st
  	remove_wait_queue(&dev->wait, &wait);
  
  	if (err == 0)
@@ -410,7 +412,7 @@ here still, but for now we keep this here.
  
  	rfcomm_tty_copy_pending(dev);
  
-@@ -743,7 +747,11 @@ static void rfcomm_tty_close(struct tty_
+@@ -738,7 +742,11 @@ static void rfcomm_tty_close(struct tty_
  	if (!--dev->port.count) {
  		spin_unlock_irqrestore(&dev->port.lock, flags);
  		if (dev->tty_dev->parent)
@@ -422,7 +424,7 @@ here still, but for now we keep this here.
  
  		/* Close DLC and dettach TTY */
  		rfcomm_dlc_close(dev->dlc, 0);
-@@ -819,7 +827,11 @@ static int rfcomm_tty_write_room(struct
+@@ -814,7 +822,11 @@ static int rfcomm_tty_write_room(struct
  	return room;
  }
  
@@ -434,7 +436,7 @@ here still, but for now we keep this here.
  {
  	BT_DBG("tty %p cmd 0x%02x", tty, cmd);
  
-@@ -1078,7 +1090,11 @@ static void rfcomm_tty_hangup(struct tty
+@@ -1073,7 +1085,11 @@ static void rfcomm_tty_hangup(struct tty
  	}
  }
  
@@ -446,7 +448,7 @@ here still, but for now we keep this here.
  {
  	struct rfcomm_dev *dev = (struct rfcomm_dev *) tty->driver_data;
  
-@@ -1087,7 +1103,11 @@ static int rfcomm_tty_tiocmget(struct tt
+@@ -1082,7 +1098,11 @@ static int rfcomm_tty_tiocmget(struct tt
  	return dev->modem_status;
  }
  
@@ -460,7 +462,7 @@ here still, but for now we keep this here.
  	struct rfcomm_dlc *dlc = dev->dlc;
 --- a/net/bluetooth/sco.c
 +++ b/net/bluetooth/sco.c
-@@ -440,8 +440,12 @@ static struct sock *sco_sock_alloc(struc
+@@ -423,8 +423,12 @@ static struct sock *sco_sock_alloc(struc
  	return sk;
  }
  
@@ -473,7 +475,7 @@ here still, but for now we keep this here.
  {
  	struct sock *sk;
  
-@@ -670,7 +674,11 @@ static int sco_sock_sendmsg(struct kiocb
+@@ -653,7 +657,11 @@ static int sco_sock_sendmsg(struct kiocb
  	return err;
  }
  
@@ -487,7 +489,7 @@ here still, but for now we keep this here.
  	int err = 0;
 --- a/net/bluetooth/bnep/sock.c
 +++ b/net/bluetooth/bnep/sock.c
-@@ -195,8 +195,12 @@ static struct proto bnep_proto = {
+@@ -180,8 +180,12 @@ static struct proto bnep_proto = {
  	.obj_size	= sizeof(struct bt_sock)
  };
  
@@ -517,7 +519,7 @@ here still, but for now we keep this here.
  
 --- a/net/bluetooth/hidp/sock.c
 +++ b/net/bluetooth/hidp/sock.c
-@@ -242,8 +242,12 @@ static struct proto hidp_proto = {
+@@ -229,8 +229,12 @@ static struct proto hidp_proto = {
  	.obj_size	= sizeof(struct bt_sock)
  };
  
@@ -532,7 +534,7 @@ here still, but for now we keep this here.
  
 --- a/net/bluetooth/l2cap_sock.c
 +++ b/net/bluetooth/l2cap_sock.c
-@@ -539,7 +539,14 @@ static int l2cap_sock_setsockopt_old(str
+@@ -538,7 +538,14 @@ static int l2cap_sock_setsockopt_old(str
  	return err;
  }
  
@@ -547,7 +549,7 @@ here still, but for now we keep this here.
  {
  	struct sock *sk = sock->sk;
  	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
-@@ -1079,8 +1086,12 @@ static struct sock *l2cap_sock_alloc(str
+@@ -1166,8 +1173,12 @@ static struct sock *l2cap_sock_alloc(str
  	return sk;
  }
  
@@ -560,7 +562,7 @@ here still, but for now we keep this here.
  {
  	struct sock *sk;
  
-@@ -1092,7 +1103,11 @@ static int l2cap_sock_create(struct net
+@@ -1179,7 +1190,11 @@ static int l2cap_sock_create(struct net
  			sock->type != SOCK_DGRAM && sock->type != SOCK_RAW)
  		return -ESOCKTNOSUPPORT;
  
diff --git a/patches/24-pcmcia.patch b/patches/24-pcmcia.patch
index 0d07aa7..5fcdc94 100644
--- a/patches/24-pcmcia.patch
+++ b/patches/24-pcmcia.patch
@@ -30,13 +30,13 @@
  
  	do {
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
- 		register unsigned int iobase = info->p_dev->resource[0]->start;
+ 		unsigned int iobase = info->p_dev->resource[0]->start;
 +#else
-+		register unsigned int iobase = info->p_dev->io.BasePort1;
++		unsigned int iobase = info->p_dev->io.BasePort1;
 +#endif
- 		register unsigned int offset;
- 		register unsigned char command;
- 		register unsigned long ready_bit;
+ 		unsigned int offset;
+ 		unsigned char command;
+ 		unsigned long ready_bit;
 @@ -378,7 +391,11 @@ static void bluecard_receive(bluecard_in
  		return;
  	}
@@ -196,12 +196,12 @@
  
  	do {
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
- 		register unsigned int iobase = info->p_dev->resource[0]->start;
+ 		unsigned int iobase = info->p_dev->resource[0]->start;
 +#else
-+		register unsigned int iobase = info->p_dev->io.BasePort1;
++		unsigned int iobase = info->p_dev->io.BasePort1;
 +#endif
  		register struct sk_buff *skb;
- 		register int len;
+ 		int len;
  
 @@ -224,7 +228,11 @@ static void bt3c_receive(bt3c_info_t *in
  		return;
@@ -376,12 +376,12 @@
  
  	do {
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
- 		register unsigned int iobase = info->p_dev->resource[0]->start;
+ 		unsigned int iobase = info->p_dev->resource[0]->start;
 +#else
-+		register unsigned int iobase = info->p_dev->io.BasePort1;
++		unsigned int iobase = info->p_dev->io.BasePort1;
 +#endif
  		register struct sk_buff *skb;
- 		register int len;
+ 		int len;
  
 @@ -181,7 +185,11 @@ static void btuart_receive(btuart_info_t
  		return;
@@ -580,12 +580,12 @@
  
  	do {
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
- 		register unsigned int iobase = info->p_dev->resource[0]->start;
+ 		unsigned int iobase = info->p_dev->resource[0]->start;
 +#else
-+		register unsigned int iobase = info->p_dev->io.BasePort1;
++		unsigned int iobase = info->p_dev->io.BasePort1;
 +#endif
  		register struct sk_buff *skb;
- 		register int len;
+ 		int len;
  
 @@ -209,7 +213,11 @@ static void dtl1_receive(dtl1_info_t *in
  		return;
diff --git a/patches/46-use_other_workqueue.patch b/patches/46-use_other_workqueue.patch
index 3e55e1d..4438051 100644
--- a/patches/46-use_other_workqueue.patch
+++ b/patches/46-use_other_workqueue.patch
@@ -4,13 +4,13 @@ position before.
 
 --- a/net/bluetooth/hci_core.c
 +++ b/net/bluetooth/hci_core.c
-@@ -1740,8 +1740,12 @@ int hci_register_dev(struct hci_dev *hde
+@@ -1722,8 +1722,12 @@ int hci_register_dev(struct hci_dev *hde
  
  	write_unlock(&hci_dev_list_lock);
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
  	hdev->workqueue = alloc_workqueue(hdev->name, WQ_HIGHPRI | WQ_UNBOUND |
- 							WQ_MEM_RECLAIM, 1);
+ 					  WQ_MEM_RECLAIM, 1);
 +#else
 +	hdev->workqueue = create_singlethread_workqueue(hdev->name);
 +#endif
-- 
1.7.9.5

