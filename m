Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50150 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758755Ab0HQSbp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 14:31:45 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat-wireless: fix hidp_output_raw_report
Date: Tue, 17 Aug 2010 20:31:09 +0200
Message-Id: <1282069869-22300-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1282069869-22300-1-git-send-email-hauke@hauke-m.de>
References: <1282069869-22300-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The report_type parameter was added with kenrel 2.6.34

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/16-bluetooth.patch |   37 +++++++++++++++++++++++--------------
 1 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/patches/16-bluetooth.patch b/patches/16-bluetooth.patch
index 522b680..29d990a 100644
--- a/patches/16-bluetooth.patch
+++ b/patches/16-bluetooth.patch
@@ -180,19 +180,28 @@ here still, but for now we keep this here.
  	return hidp_queue_report(session, buf, rsize);
  }
  
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
  static int hidp_output_raw_report(struct hid_device *hid, unsigned char *data, size_t count,
  		unsigned char report_type)
  {
-@@ -332,6 +333,7 @@ static int hidp_output_raw_report(struct
+@@ -332,6 +333,16 @@ static int hidp_output_raw_report(struct
  		return -ENOMEM;
  	return count;
  }
++#elif (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
++static int hidp_output_raw_report(struct hid_device *hid, unsigned char *data, size_t count)
++{
++	if (hidp_send_ctrl_message(hid->driver_data,
++			HIDP_TRANS_SET_REPORT | HIDP_DATA_RTYPE_FEATURE,
++			data, count))
++		return -ENOMEM;
++	return count;
++}
 +#endif
  
  static void hidp_idle_timeout(unsigned long arg)
  {
-@@ -596,10 +598,16 @@ static int hidp_session(void *arg)
+@@ -596,10 +607,16 @@ static int hidp_session(void *arg)
  		session->input = NULL;
  	}
  
@@ -213,7 +222,7 @@ here still, but for now we keep this here.
  
  	/* Wakeup user-space polling for socket errors */
  	session->intr_sock->sk->sk_err = EUNATCH;
-@@ -711,6 +719,70 @@ static void hidp_close(struct hid_device
+@@ -711,6 +728,70 @@ static void hidp_close(struct hid_device
  {
  }
  
@@ -284,7 +293,7 @@ here still, but for now we keep this here.
  static int hidp_parse(struct hid_device *hid)
  {
  	struct hidp_session *session = hid->driver_data;
-@@ -815,6 +887,7 @@ fault:
+@@ -815,6 +896,7 @@ fault:
  
  	return err;
  }
@@ -292,7 +301,7 @@ here still, but for now we keep this here.
  
  int hidp_add_connection(struct hidp_connadd_req *req, struct socket *ctrl_sock, struct socket *intr_sock)
  {
-@@ -833,6 +906,39 @@ int hidp_add_connection(struct hidp_conn
+@@ -833,6 +915,39 @@ int hidp_add_connection(struct hidp_conn
  
  	BT_DBG("rd_data %p rd_size %d", req->rd_data, req->rd_size);
  
@@ -332,7 +341,7 @@ here still, but for now we keep this here.
  	down_write(&hidp_session_sem);
  
  	s = __hidp_get_session(&bt_sk(ctrl_sock->sk)->dst);
-@@ -860,6 +966,7 @@ int hidp_add_connection(struct hidp_conn
+@@ -860,6 +975,7 @@ int hidp_add_connection(struct hidp_conn
  	session->flags   = req->flags & (1 << HIDP_BLUETOOTH_VENDOR_ID);
  	session->idle_to = req->idle_to;
  
@@ -340,7 +349,7 @@ here still, but for now we keep this here.
  	if (req->rd_size > 0) {
  		err = hidp_setup_hid(session, req);
  		if (err && err != -ENODEV)
-@@ -871,6 +978,16 @@ int hidp_add_connection(struct hidp_conn
+@@ -871,6 +987,16 @@ int hidp_add_connection(struct hidp_conn
  		if (err < 0)
  			goto purge;
  	}
@@ -357,7 +366,7 @@ here still, but for now we keep this here.
  
  	__hidp_link_session(session);
  
-@@ -902,6 +1019,7 @@ unlink:
+@@ -902,6 +1028,7 @@ unlink:
  		session->input = NULL;
  	}
  
@@ -365,7 +374,7 @@ here still, but for now we keep this here.
  	if (session->hid) {
  		hid_destroy_device(session->hid);
  		session->hid = NULL;
-@@ -913,10 +1031,15 @@ unlink:
+@@ -913,10 +1040,15 @@ unlink:
  purge:
  	skb_queue_purge(&session->ctrl_transmit);
  	skb_queue_purge(&session->intr_transmit);
@@ -381,7 +390,7 @@ here still, but for now we keep this here.
  	input_free_device(session->input);
  	kfree(session);
  	return err;
-@@ -1006,6 +1129,7 @@ int hidp_get_conninfo(struct hidp_connin
+@@ -1006,6 +1138,7 @@ int hidp_get_conninfo(struct hidp_connin
  	return err;
  }
  
@@ -389,7 +398,7 @@ here still, but for now we keep this here.
  static const struct hid_device_id hidp_table[] = {
  	{ HID_BLUETOOTH_DEVICE(HID_ANY_ID, HID_ANY_ID) },
  	{ }
-@@ -1015,6 +1139,7 @@ static struct hid_driver hidp_driver = {
+@@ -1015,6 +1148,7 @@ static struct hid_driver hidp_driver = {
  	.name = "generic-bluetooth",
  	.id_table = hidp_table,
  };
@@ -397,7 +406,7 @@ here still, but for now we keep this here.
  
  static int __init hidp_init(void)
  {
-@@ -1024,11 +1149,14 @@ static int __init hidp_init(void)
+@@ -1024,11 +1158,14 @@ static int __init hidp_init(void)
  
  	BT_INFO("HIDP (Human Interface Emulation) ver %s", VERSION);
  
@@ -412,7 +421,7 @@ here still, but for now we keep this here.
  	if (ret)
  		goto err_drv;
  
-@@ -1036,13 +1164,16 @@ static int __init hidp_init(void)
+@@ -1036,13 +1173,16 @@ static int __init hidp_init(void)
  err_drv:
  	hid_unregister_driver(&hidp_driver);
  err:
-- 
1.7.0.4

