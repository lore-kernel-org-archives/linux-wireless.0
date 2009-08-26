Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:35423 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbZHZQyN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 12:54:13 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [PATCH 1/2] rtl8187: fix circular locking (rtl8187_stop/rtl8187_work)
Date: Wed, 26 Aug 2009 13:54:08 -0300
Message-Id: <1251305649-12508-1-git-send-email-herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger reports following lockdep warning:

[ INFO: possible circular locking dependency detected ]
2.6.31-rc6-wl #201
-------------------------------------------------------
rfkill/30578 is trying to acquire lock:
 (&(&priv->work)->work#2){+.+...}, at: [<ffffffff81051215>]
__cancel_work_timer+0xd9/0x222

but task is already holding lock:
 (&priv->conf_mutex#2){+.+.+.}, at: [<ffffffffa064a024>]
rtl8187_stop+0x31/0x364 [rtl8187]

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&priv->conf_mutex#2){+.+.+.}:
       [<ffffffff81065957>] __lock_acquire+0x12d0/0x1614
       [<ffffffff81065d54>] lock_acquire+0xb9/0xdd
       [<ffffffff8127c32f>] mutex_lock_nested+0x56/0x2a8
       [<ffffffffa064a392>] rtl8187_work+0x3b/0xf2 [rtl8187]
       [<ffffffff81050758>] worker_thread+0x1fa/0x30a
       [<ffffffff81054ca5>] kthread+0x8f/0x97
       [<ffffffff8100cb7a>] child_rip+0xa/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&(&priv->work)->work#2){+.+...}:
       [<ffffffff8106568c>] __lock_acquire+0x1005/0x1614
       [<ffffffff81065d54>] lock_acquire+0xb9/0xdd
       [<ffffffff8105124e>] __cancel_work_timer+0x112/0x222
       [<ffffffff8105136b>] cancel_delayed_work_sync+0xd/0xf
       [<ffffffffa064a33f>] rtl8187_stop+0x34c/0x364 [rtl8187]
       [<ffffffffa0242866>] ieee80211_stop_device+0x29/0x61 [mac80211]
       [<ffffffffa0239194>] ieee80211_stop+0x476/0x530 [mac80211]
       [<ffffffff8120ce15>] dev_close+0x8a/0xac
       [<ffffffffa01d9fa7>] cfg80211_rfkill_set_block+0x4a/0x7a [cfg80211]
       [<ffffffffa01bf4f0>] rfkill_set_block+0x84/0xd9 [rfkill]
       [<ffffffffa01bfc31>] rfkill_fop_write+0xda/0x124 [rfkill]
       [<ffffffff810cf286>] vfs_write+0xae/0x14a
       [<ffffffff810cf3e6>] sys_write+0x47/0x6e
       [<ffffffff8100ba6b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

The problem here is that rtl8187_stop, while helding priv->conf_mutex,
runs cancel_delayed_work_sync on an workqueue that runs rtl8187_work,
which also takes priv->conf_mutex lock. Move cancel_delayed_work_sync
out of rtl8187_stop priv->conf_mutex locking region.

Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 5830f6c..75b63ac 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1017,9 +1017,10 @@ static void rtl8187_stop(struct ieee80211_hw *dev)
 		dev_kfree_skb_any(skb);
 
 	usb_kill_anchored_urbs(&priv->anchored);
+	mutex_unlock(&priv->conf_mutex);
+
 	if (!priv->is_rtl8187b)
 		cancel_delayed_work_sync(&priv->work);
-	mutex_unlock(&priv->conf_mutex);
 }
 
 static int rtl8187_add_interface(struct ieee80211_hw *dev,
-- 
1.6.4.1

