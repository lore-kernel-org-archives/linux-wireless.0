Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45898 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671Ab0JWNCJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Oct 2010 09:02:09 -0400
Received: by fxm16 with SMTP id 16so1470874fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 23 Oct 2010 06:02:08 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH for-2.6.37] carl9170: fix scheduling while atomic
Date: Sat, 23 Oct 2010 15:02:02 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010231502.02582.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the following mishap:

BUG: scheduling while atomic: wpa_supplicant/4164/0x00000002
Modules linked in: carl9170 mac80211 [...]
Pid: 4164, comm: wpa_supplicant Not tainted 2.6.36-wl+ #119
Call Trace:
 [<c13779a9>] ? schedule+0x349/0x4c0
 [<c13780d6>] ? schedule_timeout+0x106/0x1e0
 [<c1037f50>] ? process_timeout+0x0/0x10
 [<c1377e8d>] ? wait_for_common+0x9d/0x140
 [<c1029110>] ? default_wake_function+0x0/0x10
 [<f80c6080>] ? carl9170_exec_cmd+0xf0/0x250 [carl9170]
 [<f80c695e>] ? carl9170_set_mac_reg+0x5e/0x70 [carl9170]
 [<f80c3f76>] ? carl9170_op_add_interface+0x176/0x310 [carl9170]
 [...]

rcu_read_unlock() call was erroneously placed after the
sync. function carl9170_mod_virtual_mac. 

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 4e96910..d56f440 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -639,8 +639,8 @@ init:
 		if (err)
 			goto unlock;
 	} else {
-		err = carl9170_mod_virtual_mac(ar, vif_id, vif->addr);
 		rcu_read_unlock();
+		err = carl9170_mod_virtual_mac(ar, vif_id, vif->addr);
 
 		if (err)
 			goto unlock;
