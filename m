Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms13.Sony.CO.JP ([211.125.136.230]:58889 "EHLO ms13.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbYG1H0H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 03:26:07 -0400
Received: from ms5.sony.co.jp (ms5.Sony.CO.JP [211.125.136.201])
 by ms13.sony.co.jp (R8/Sony) with ESMTP id m6S6GEkP026692
 for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 15:16:14 +0900 (JST)
Received: from mta6.sony.co.jp (mta6.Sony.CO.JP [137.153.71.9])
 by ms5.sony.co.jp (R8/Sony) with ESMTP id m6S6EvqD000677
 for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 15:14:57 +0900 (JST)
Received: from mta6.sony.co.jp (localhost [127.0.0.1])
 by mta6.sony.co.jp (R8/Sony) with ESMTP id m6S6EvYO016012
 for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 15:14:57 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
 by mta6.sony.co.jp (R8/Sony) with ESMTP id m6S6Ev24016009
 for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 15:14:57 +0900 (JST)
Date: Mon, 28 Jul 2008 15:14:55 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] PS3: gelic: Fix typecheck warnings
Cc: Geoff Levand <geoffrey.levand@am.sony.com>
Message-Id: <20080728150546.714D.40F06B3A@sm.sony.co.jp> (sfid-20080728_092613_997253_5164E736)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The flag variable of spin_lock_irqsave() should be 'unsigned long'.

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---
 drivers/net/ps3_gelic_wireless.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -1024,7 +1024,7 @@ static int gelic_wl_set_encode(struct ne
 	struct gelic_wl_info *wl = port_wl(netdev_priv(netdev));
 	struct iw_point *enc = &data->encoding;
 	__u16 flags;
-	unsigned int irqflag;
+	unsigned long irqflag;
 	int key_index, index_specified;
 	int ret = 0;
 
@@ -1097,7 +1097,7 @@ static int gelic_wl_get_encode(struct ne
 {
 	struct gelic_wl_info *wl = port_wl(netdev_priv(netdev));
 	struct iw_point *enc = &data->encoding;
-	unsigned int irqflag;
+	unsigned long irqflag;
 	unsigned int key_index, index_specified;
 	int ret = 0;
 
@@ -1215,7 +1215,7 @@ static int gelic_wl_set_encodeext(struct
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 	__u16 alg;
 	__u16 flags;
-	unsigned int irqflag;
+	unsigned long irqflag;
 	int key_index;
 	int ret = 0;
 
@@ -1303,7 +1303,7 @@ static int gelic_wl_get_encodeext(struct
 	struct gelic_wl_info *wl = port_wl(netdev_priv(netdev));
 	struct iw_point *enc = &data->encoding;
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
-	unsigned int irqflag;
+	unsigned long irqflag;
 	int key_index;
 	int ret = 0;
 	int max_key_len;
@@ -1426,7 +1426,7 @@ static int gelic_wl_priv_set_psk(struct 
 {
 	struct gelic_wl_info *wl = port_wl(netdev_priv(net_dev));
 	unsigned int len;
-	unsigned int irqflag;
+	unsigned long irqflag;
 	int ret = 0;
 
 	pr_debug("%s:<- len=%d\n", __func__, data->data.length);
@@ -1467,7 +1467,7 @@ static int gelic_wl_priv_get_psk(struct 
 {
 	struct gelic_wl_info *wl = port_wl(netdev_priv(net_dev));
 	char *p;
-	unsigned int irqflag;
+	unsigned long irqflag;
 	unsigned int i;
 
 	pr_debug("%s:<-\n", __func__);

-- 
Masakazu Mokuno

