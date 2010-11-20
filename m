Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60920 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab0KTLV2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Nov 2010 06:21:28 -0500
Received: by fxm13 with SMTP id 13so1419793fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 20 Nov 2010 03:21:27 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH for-2.6.37] carl9170: fix virtual interface setup crash
Date: Sat, 20 Nov 2010 13:15:27 +0100
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011201315.27401.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a faulty bound check which caused a
crash when too many virtual interface were brought up.

BUG: unable to handle kernel NULL pointer dereference at 00000004
IP: [<f8125f67>] carl9170_op_add_interface+0x1d7/0x2c0 [carl9170]
*pde = 00000000
Oops: 0002 [#1] PREEMPT 
Modules linked in: carl9170 [...]
Pid: 4720, comm: wpa_supplicant Not tainted 2.6.37-rc2-wl+
EIP: 0060:[<f8125f67>] EFLAGS: 00210206 CPU: 0
EIP is at carl9170_op_add_interface+0x1d7/0x2c0 [carl9170]
EAX: 00000000 ...
Process wpa_supplicant
Stack:
 f4f88f34 fffffff4 ..
Call Trace:
 [<f8f4e666>] ? ieee80211_do_open+0x406/0x5c0 [mac80211]
 [...]
Code: <89> 42 04 ...
EIP: [<f8125f67>] carl9170_op_add_interface+0x1d7/0x2c0 [carl9170]
CR2: 0000000000000004

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index f015ab7..02999e5 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -664,7 +664,7 @@ init:
 	}
 
 unlock:
-	if (err && (vif_id != -1)) {
+	if (err && (vif_id >= 0)) {
 		vif_priv->active = false;
 		bitmap_release_region(&ar->vif_bitmap, vif_id, 0);
 		ar->vifs--;
