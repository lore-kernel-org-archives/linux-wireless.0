Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46858 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab1FAGyv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 02:54:51 -0400
Subject: [PATCH] bluetooth: fix sparse & gcc warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Gustavo F. Padovan" <padovan@profusion.mobi>,
	linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 08:54:45 +0200
Message-ID: <1306911285.3867.6.camel@jlt3.sipsolutions.net> (sfid-20110601_085456_858728_3F865F9C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

sparse complains about a few things that should
be static, and I also noticed another warning
from gcc about a set but unused variable.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/bluetooth/l2cap_core.c  |    6 +++---
 net/bluetooth/mgmt.c        |    2 +-
 net/bluetooth/rfcomm/sock.c |    3 ---
 3 files changed, 4 insertions(+), 7 deletions(-)

--- a/net/bluetooth/l2cap_core.c	2011-06-01 08:42:43.000000000 +0200
+++ b/net/bluetooth/l2cap_core.c	2011-06-01 08:45:04.000000000 +0200
@@ -62,8 +62,8 @@ static u8 l2cap_fixed_chan[8] = { 0x02,
 
 static struct workqueue_struct *_busy_wq;
 
-LIST_HEAD(chan_list);
-DEFINE_RWLOCK(chan_list_lock);
+static LIST_HEAD(chan_list);
+static DEFINE_RWLOCK(chan_list_lock);
 
 static void l2cap_busy_work(struct work_struct *work);
 
@@ -371,7 +371,7 @@ static inline int l2cap_check_security(s
 	return hci_conn_security(conn->hcon, chan->sec_level, auth_type);
 }
 
-u8 l2cap_get_ident(struct l2cap_conn *conn)
+static u8 l2cap_get_ident(struct l2cap_conn *conn)
 {
 	u8 id;
 
--- a/net/bluetooth/mgmt.c	2011-06-01 08:42:24.000000000 +0200
+++ b/net/bluetooth/mgmt.c	2011-06-01 08:42:28.000000000 +0200
@@ -41,7 +41,7 @@ struct pending_cmd {
 	void *user_data;
 };
 
-LIST_HEAD(cmd_list);
+static LIST_HEAD(cmd_list);
 
 static int cmd_status(struct sock *sk, u16 index, u16 cmd, u8 status)
 {
--- a/net/bluetooth/rfcomm/sock.c	2011-06-01 08:50:06.000000000 +0200
+++ b/net/bluetooth/rfcomm/sock.c	2011-06-01 08:50:23.000000000 +0200
@@ -741,7 +741,6 @@ static int rfcomm_sock_setsockopt(struct
 static int rfcomm_sock_getsockopt_old(struct socket *sock, int optname, char __user *optval, int __user *optlen)
 {
 	struct sock *sk = sock->sk;
-	struct sock *l2cap_sk;
 	struct rfcomm_conninfo cinfo;
 	struct l2cap_conn *conn = l2cap_pi(sk)->chan->conn;
 	int len, err = 0;
@@ -786,8 +785,6 @@ static int rfcomm_sock_getsockopt_old(st
 			break;
 		}
 
-		l2cap_sk = rfcomm_pi(sk)->dlc->session->sock->sk;
-
 		cinfo.hci_handle = conn->hcon->handle;
 		memcpy(cinfo.dev_class, conn->hcon->dev_class, 3);
 


