Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64667 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbZJGPID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 11:08:03 -0400
Date: Wed, 07 Oct 2009 10:06:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Fix locking problem when stopping rfkill polling
Message-ID: <4accae5d.BgSJpcmlvg+W5PGM%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 26e5ab35b4c7b1d4cb487a11084520aed9a8d05e entitled "b43: Fix PPC
crash in rfkill polling on unload", the call to stop polling should not have
been placed inside the wl->mutex. The result was incorrect locking messages.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

I had not intended for the previous patch to be applied as I was waiting for
the Bugzilla OP to test. He promised to do that today. In any case, that patch
introduced a locking problem that needs to be fixed.

Why do the one-liners cause so many problems?

Larry
---

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -4501,8 +4501,8 @@ static void b43_op_stop(struct ieee80211
 
 	cancel_work_sync(&(wl->beacon_update_trigger));
 
-	mutex_lock(&wl->mutex);
 	wiphy_rfkill_stop_polling(hw->wiphy);
+	mutex_lock(&wl->mutex);
 	if (b43_status(dev) >= B43_STAT_STARTED) {
 		dev = b43_wireless_core_stop(dev);
 		if (!dev)
