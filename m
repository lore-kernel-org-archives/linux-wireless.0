Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37582 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbZAWRbF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 12:31:05 -0500
Date: Fri, 23 Jan 2009 11:30:54 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] rtl8187: Increase receive queue depth
Message-ID: <4979fece.HX6OGfl4J6hQFYsf%Larry.Finger@lwfinger.net> (sfid-20090123_183115_415791_621B82E0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The receive queue depth in rtl8187 may not be long enough to keep
the pipe full.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch and the locking fix helped the bug #12380 at
http://bugzilla.kernel.org/, but the test was not clean, and the OP for
that bug has not been able to test. Your call on when it gets included.

If I get a clear indication that this patch helps the bug, I'll repost.

Larry
---


Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -390,7 +390,7 @@ static int rtl8187_init_urbs(struct ieee
 	struct rtl8187_rx_info *info;
 	int ret = 0;
 
-	while (skb_queue_len(&priv->rx_queue) < 8) {
+	while (skb_queue_len(&priv->rx_queue) < 16) {
 		skb = __dev_alloc_skb(RTL8187_MAX_RX, GFP_KERNEL);
 		if (!skb) {
 			ret = -ENOMEM;

---
