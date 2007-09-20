Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55366 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbXITEJ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 00:09:29 -0400
Date: Wed, 19 Sep 2007 22:53:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix compilation warning for rx.c
Message-ID: <46f1eeb4.JYjX14vAF5Qf45cZ%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A recent change in MAC formatting leads to an "ISO C90 forbids mixed
declarations and code" warning. If the DECLARE_MAC macro is moved,
the code compiles without warnings.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

 
Index: net-2.6.24/net/mac80211/rx.c
===================================================================
--- net-2.6.24.orig/net/mac80211/rx.c
+++ net-2.6.24/net/mac80211/rx.c
@@ -418,8 +418,8 @@ ieee80211_rx_h_load_key(struct ieee80211
 static void ap_sta_ps_start(struct net_device *dev, struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata;
-	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
 	DECLARE_MAC_BUF(mac);
+	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
 
 	if (sdata->bss)
 		atomic_inc(&sdata->bss->num_sta_ps);
