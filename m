Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13449 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab2DFVyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 17:54:24 -0400
Date: Fri, 06 Apr 2012 16:54:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix oops on rate-control failure
Message-ID: <4f7f6609.e9GoU13xXckPTQhJ%Larry.Finger@lwfinger.net> (sfid-20120406_235437_143757_802ADB0B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the rate-control indexing is incorrectly set up, mac80211 issues
a warning and returns NULL from the call to ieee80211_get_tx_rate().
When this happens, avoid a NULL pointer dereference.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/base.c
@@ -838,7 +838,10 @@ void rtl_get_tcb_desc(struct ieee80211_h
 	__le16 fc = hdr->frame_control;
 
 	txrate = ieee80211_get_tx_rate(hw, info);
-	tcb_desc->hw_rate = txrate->hw_value;
+	if (txrate)
+		tcb_desc->hw_rate = txrate->hw_value;
+	else
+		tcb_desc->hw_rate = 0;
 
 	if (ieee80211_is_data(fc)) {
 		/*
