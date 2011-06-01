Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42096 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab1FAGjm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 02:39:42 -0400
Subject: [PATCH] bluetooth: fix error cases
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 08:39:37 +0200
Message-ID: <1306910377.3867.5.camel@jlt3.sipsolutions.net> (sfid-20110601_083948_288860_F079B1E1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The error cases in a few functions can use a
socket variable that was never initialised,
gcc correctly warns about this:
net/bluetooth/l2cap_core.c: In function ‘l2cap_recv_frame’:
include/linux/spinlock.h:325:19: warning: ‘sk’ may be used uninitialized in this function [-Wuninitialized]
net/bluetooth/l2cap_core.c:3789:15: note: ‘sk’ was declared here
include/linux/spinlock.h:325:19: warning: ‘sk’ may be used uninitialized in this function [-Wuninitialized]
net/bluetooth/l2cap_core.c:3756:15: note: ‘sk’ was declared here

Initialise the socket to NULL as clearly intended
by the error handling code.

Also fix a "set but not used" warning.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/bluetooth/l2cap_core.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/bluetooth/l2cap_core.c	2011-06-01 08:33:36.000000000 +0200
+++ b/net/bluetooth/l2cap_core.c	2011-06-01 08:34:35.000000000 +0200
@@ -3667,7 +3667,6 @@ static inline int l2cap_data_channel(str
 {
 	struct l2cap_chan *chan;
 	struct sock *sk = NULL;
-	struct l2cap_pinfo *pi;
 	u16 control;
 	u8 tx_seq;
 	int len;
@@ -3679,7 +3678,6 @@ static inline int l2cap_data_channel(str
 	}
 
 	sk = chan->sk;
-	pi = l2cap_pi(sk);
 
 	BT_DBG("chan %p, len %d", chan, skb->len);
 
@@ -3755,7 +3753,7 @@ done:
 
 static inline int l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm, struct sk_buff *skb)
 {
-	struct sock *sk;
+	struct sock *sk = NULL;
 	struct l2cap_chan *chan;
 
 	chan = l2cap_global_chan_by_psm(0, psm, conn->src);
@@ -3788,7 +3786,7 @@ done:
 
 static inline int l2cap_att_channel(struct l2cap_conn *conn, __le16 cid, struct sk_buff *skb)
 {
-	struct sock *sk;
+	struct sock *sk = NULL;
 	struct l2cap_chan *chan;
 
 	chan = l2cap_global_chan_by_scid(0, cid, conn->src);


