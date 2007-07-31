Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48225 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764744AbXGaSd4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:33:56 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121186ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:33:55 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/24] rt2x00: Remove rt73usb_get_tsf
Date: Tue, 31 Jul 2007 20:36:55 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312036.55850.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 23d440a413208983ed8b17ac7048516f8bb9ed74 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Fri, 27 Jul 2007 13:58:18 +0200
Subject: [PATCH 01/24] rt2x00: Remove rt73usb_get_tsf

The get_tsf function must be atomic according to mac80211,
this means that rt73usb is not capable of supporting this feature
since all USB register access functions require sleeping.
Place rt73usb_get_tsf between #if 0 statements to disable it,
so that it can be easily readded when the atomic requirement
has been removed.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt73usb.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 3d838d1..bc9b56c 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -1723,6 +1723,13 @@ static int rt73usb_set_retry_limit(struct ieee80211_hw *hw,
 	return 0;
 }
 
+#if 0
+/*
+ * Mac80211 demands get_tsf must be atomic.
+ * This is not possible for rt73usb since all register access
+ * functions require sleeping. Untill mac80211 no longer needs
+ * get_tsf to be atomic, this function should be disabled.
+ */
 static u64 rt73usb_get_tsf(struct ieee80211_hw *hw)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
@@ -1736,6 +1743,7 @@ static u64 rt73usb_get_tsf(struct ieee80211_hw *hw)
 
 	return tsf;
 }
+#endif
 
 static void rt73usb_reset_tsf(struct ieee80211_hw *hw)
 {
@@ -1757,7 +1765,12 @@ static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.set_retry_limit	= rt73usb_set_retry_limit,
 	.conf_tx		= rt2x00lib_conf_tx,
 	.get_tx_stats		= rt2x00lib_get_tx_stats,
+#if 0
+/*
+ * See comment at the rt73usb_get_tsf function.
+ */
 	.get_tsf		= rt73usb_get_tsf,
+#endif
 	.reset_tsf		= rt73usb_reset_tsf,
 	.beacon_update		= rt2x00usb_beacon_update,
 };
-- 
1.5.2.4

