Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46339 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab1HOSbG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 14:31:06 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] comapt-wireless: make patches apply again
Date: Mon, 15 Aug 2011 20:30:54 +0200
Message-Id: <1313433054-30868-1-git-send-email-hauke@hauke-m.de> (sfid-20110815_203110_691967_39364DD5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/16-bluetooth.patch |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/patches/16-bluetooth.patch b/patches/16-bluetooth.patch
index 8d0ba3e..b6d251a 100644
--- a/patches/16-bluetooth.patch
+++ b/patches/16-bluetooth.patch
@@ -90,8 +90,8 @@ here still, but for now we keep this here.
 +	capi_ctr_reseted(ctrl);
 +#endif
  
- 	kthread_stop(session->task);
- }
+ 	atomic_inc(&session->terminate);
+ 	wake_up_process(session->task);
 --- a/net/bluetooth/hci_sock.c
 +++ b/net/bluetooth/hci_sock.c
 @@ -547,7 +547,11 @@ drop:
@@ -199,7 +199,7 @@ here still, but for now we keep this here.
  	}
  
  	/* Wakeup user-space polling for socket errors */
-@@ -863,6 +880,70 @@ static void hidp_close(struct hid_device
+@@ -865,6 +882,70 @@ static void hidp_close(struct hid_device
  {
  }
  
@@ -270,7 +270,7 @@ here still, but for now we keep this here.
  static int hidp_parse(struct hid_device *hid)
  {
  	struct hidp_session *session = hid->driver_data;
-@@ -947,7 +1028,9 @@ static int hidp_setup_hid(struct hidp_se
+@@ -949,7 +1030,9 @@ static int hidp_setup_hid(struct hidp_se
  	hid->dev.parent = hidp_get_device(session);
  	hid->ll_driver = &hidp_hid_driver;
  
@@ -280,7 +280,7 @@ here still, but for now we keep this here.
  	hid->hid_output_raw_report = hidp_output_raw_report;
  
  	return 0;
-@@ -958,6 +1041,7 @@ fault:
+@@ -960,6 +1043,7 @@ fault:
  
  	return err;
  }
@@ -288,7 +288,7 @@ here still, but for now we keep this here.
  
  int hidp_add_connection(struct hidp_connadd_req *req, struct socket *ctrl_sock, struct socket *intr_sock)
  {
-@@ -977,6 +1061,39 @@ int hidp_add_connection(struct hidp_conn
+@@ -979,6 +1063,39 @@ int hidp_add_connection(struct hidp_conn
  
  	BT_DBG("rd_data %p rd_size %d", req->rd_data, req->rd_size);
  
@@ -328,7 +328,7 @@ here still, but for now we keep this here.
  	down_write(&hidp_session_sem);
  
  	s = __hidp_get_session(&bt_sk(ctrl_sock->sk)->dst);
-@@ -1010,6 +1127,7 @@ int hidp_add_connection(struct hidp_conn
+@@ -1012,6 +1129,7 @@ int hidp_add_connection(struct hidp_conn
  	session->flags   = req->flags & (1 << HIDP_BLUETOOTH_VENDOR_ID);
  	session->idle_to = req->idle_to;
  
@@ -336,7 +336,7 @@ here still, but for now we keep this here.
  	if (req->rd_size > 0) {
  		err = hidp_setup_hid(session, req);
  		if (err && err != -ENODEV)
-@@ -1021,6 +1139,16 @@ int hidp_add_connection(struct hidp_conn
+@@ -1023,6 +1141,16 @@ int hidp_add_connection(struct hidp_conn
  		if (err < 0)
  			goto purge;
  	}
@@ -374,10 +374,10 @@ here still, but for now we keep this here.
 +	if (session->hid)
 +		hid_free_device(session->hid);
 +#endif
- 	input_free_device(session->input);
  	kfree(session);
  	return err;
-@@ -1180,6 +1314,7 @@ int hidp_get_conninfo(struct hidp_connin
+ }
+@@ -1179,6 +1313,7 @@ int hidp_get_conninfo(struct hidp_connin
  	return err;
  }
  
@@ -385,7 +385,7 @@ here still, but for now we keep this here.
  static const struct hid_device_id hidp_table[] = {
  	{ HID_BLUETOOTH_DEVICE(HID_ANY_ID, HID_ANY_ID) },
  	{ }
-@@ -1189,6 +1324,7 @@ static struct hid_driver hidp_driver = {
+@@ -1188,6 +1323,7 @@ static struct hid_driver hidp_driver = {
  	.name = "generic-bluetooth",
  	.id_table = hidp_table,
  };
@@ -393,7 +393,7 @@ here still, but for now we keep this here.
  
  static int __init hidp_init(void)
  {
-@@ -1196,11 +1332,14 @@ static int __init hidp_init(void)
+@@ -1195,11 +1331,14 @@ static int __init hidp_init(void)
  
  	BT_INFO("HIDP (Human Interface Emulation) ver %s", VERSION);
  
@@ -408,7 +408,7 @@ here still, but for now we keep this here.
  	if (ret)
  		goto err_drv;
  
-@@ -1208,13 +1347,16 @@ static int __init hidp_init(void)
+@@ -1207,13 +1346,16 @@ static int __init hidp_init(void)
  err_drv:
  	hid_unregister_driver(&hidp_driver);
  err:
-- 
1.7.4.1

