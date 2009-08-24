Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:55210 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbZHXSDk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 14:03:40 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
Date: Mon, 24 Aug 2009 15:03:37 -0300
Cc: linux-wireless@vger.kernel.org,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>
References: <200908220038.35564.herton@mandriva.com.br> <4A91F100.9040804@lwfinger.net>
In-Reply-To: <4A91F100.9040804@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200908241503.38020.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Dom 23 Ago 2009, às 22:46:40, Larry Finger escreveu:
> Herton Ronaldo Krzesinski wrote:
> > This change implements rfkill support for RTL8187B and RTL8187L devices,
> > using new cfg80211 rfkill API.
> > 
> > Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> > ---
> 
> I found a problem with this patch. When I issue an 'rfkill block 1'
> command, I get the following circular locking warning:

Hmm, this is a issue that was already present before the rfkill patch, but
seems with it, it became more likely to happen. Please try this patch:

[PATCH] rtl8187: fix circular locking (rtl8187_stop/rtl8187_work)

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
Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index b6e9fbd..2017ccc 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1018,9 +1018,10 @@ static void rtl8187_stop(struct ieee80211_hw *dev)
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

> 
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.31-rc6-wl #201
> -------------------------------------------------------
> rfkill/30578 is trying to acquire lock:
>  (&(&priv->work)->work#2){+.+...}, at: [<ffffffff81051215>]
> __cancel_work_timer+0xd9/0x222
> 
> but task is already holding lock:
>  (&priv->conf_mutex#2){+.+.+.}, at: [<ffffffffa064a024>]
> rtl8187_stop+0x31/0x364 [rtl8187]
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&priv->conf_mutex#2){+.+.+.}:
>        [<ffffffff81065957>] __lock_acquire+0x12d0/0x1614
>        [<ffffffff81065d54>] lock_acquire+0xb9/0xdd
>        [<ffffffff8127c32f>] mutex_lock_nested+0x56/0x2a8
>        [<ffffffffa064a392>] rtl8187_work+0x3b/0xf2 [rtl8187]
>        [<ffffffff81050758>] worker_thread+0x1fa/0x30a
>        [<ffffffff81054ca5>] kthread+0x8f/0x97
>        [<ffffffff8100cb7a>] child_rip+0xa/0x20
>        [<ffffffffffffffff>] 0xffffffffffffffff
> 
> -> #0 (&(&priv->work)->work#2){+.+...}:
>        [<ffffffff8106568c>] __lock_acquire+0x1005/0x1614
>        [<ffffffff81065d54>] lock_acquire+0xb9/0xdd
>        [<ffffffff8105124e>] __cancel_work_timer+0x112/0x222
>        [<ffffffff8105136b>] cancel_delayed_work_sync+0xd/0xf
>        [<ffffffffa064a33f>] rtl8187_stop+0x34c/0x364 [rtl8187]
>        [<ffffffffa0242866>] ieee80211_stop_device+0x29/0x61 [mac80211]
>        [<ffffffffa0239194>] ieee80211_stop+0x476/0x530 [mac80211]
>        [<ffffffff8120ce15>] dev_close+0x8a/0xac
>        [<ffffffffa01d9fa7>] cfg80211_rfkill_set_block+0x4a/0x7a [cfg80211]
>        [<ffffffffa01bf4f0>] rfkill_set_block+0x84/0xd9 [rfkill]
>        [<ffffffffa01bfc31>] rfkill_fop_write+0xda/0x124 [rfkill]
>        [<ffffffff810cf286>] vfs_write+0xae/0x14a
>        [<ffffffff810cf3e6>] sys_write+0x47/0x6e
>        [<ffffffff8100ba6b>] system_call_fastpath+0x16/0x1b
>        [<ffffffffffffffff>] 0xffffffffffffffff
> 
> other info that might help us debug this:
> 
> 4 locks held by rfkill/30578:
>  #0:  (rfkill_global_mutex){+.+.+.}, at: [<ffffffffa01bfbbc>]
> rfkill_fop_write+0x65/0x124 [rfkill]
>  #1:  (rtnl_mutex){+.+.+.}, at: [<ffffffff81215a60>] rtnl_lock+0x12/0x14
>  #2:  (&rdev->devlist_mtx){+.+.+.}, at: [<ffffffffa01d9f89>]
> cfg80211_rfkill_set_block+0x2c/0x7a [cfg80211]
>  #3:  (&priv->conf_mutex#2){+.+.+.}, at: [<ffffffffa064a024>]
> rtl8187_stop+0x31/0x364 [rtl8187]
> 
> stack backtrace:
> Pid: 30578, comm: rfkill Not tainted 2.6.31-rc6-wl #201
> Call Trace:
>  [<ffffffff810641ec>] print_circular_bug_tail+0xc1/0xcc
>  [<ffffffff8106568c>] __lock_acquire+0x1005/0x1614
>  [<ffffffff81065d54>] lock_acquire+0xb9/0xdd
>  [<ffffffff81051215>] ? __cancel_work_timer+0xd9/0x222
>  [<ffffffff8105124e>] __cancel_work_timer+0x112/0x222
>  [<ffffffff81051215>] ? __cancel_work_timer+0xd9/0x222
>  [<ffffffff81063791>] ? mark_held_locks+0x4d/0x6b
>  [<ffffffff8127db94>] ? _spin_unlock_irq+0x2b/0x30
>  [<ffffffff81063a04>] ? trace_hardirqs_on_caller+0x10b/0x12f
>  [<ffffffff81063a35>] ? trace_hardirqs_on+0xd/0xf
>  [<ffffffff8127db94>] ? _spin_unlock_irq+0x2b/0x30
>  [<ffffffffa00de2c4>] ? usb_kill_anchored_urbs+0x46/0x5c [usbcore]
>  [<ffffffff8105136b>] cancel_delayed_work_sync+0xd/0xf
>  [<ffffffffa064a33f>] rtl8187_stop+0x34c/0x364 [rtl8187]
>  [<ffffffffa0242866>] ieee80211_stop_device+0x29/0x61 [mac80211]
>  [<ffffffffa0239194>] ieee80211_stop+0x476/0x530 [mac80211]
>  [<ffffffffa0238d68>] ? ieee80211_stop+0x4a/0x530 [mac80211]
>  [<ffffffff81044a28>] ? local_bh_enable_ip+0xc8/0xcd
>  [<ffffffff8127db65>] ? _spin_unlock_bh+0x2f/0x33
>  [<ffffffff8121d116>] ? dev_deactivate+0x162/0x192
>  [<ffffffff8120ce15>] dev_close+0x8a/0xac
>  [<ffffffffa01d9fa7>] cfg80211_rfkill_set_block+0x4a/0x7a [cfg80211]
>  [<ffffffffa01bf4f0>] rfkill_set_block+0x84/0xd9 [rfkill]
>  [<ffffffffa01bfc31>] rfkill_fop_write+0xda/0x124 [rfkill]
>  [<ffffffff8100ba9c>] ? sysret_check+0x27/0x62
>  [<ffffffff810cf286>] vfs_write+0xae/0x14a
>  [<ffffffff810cf3e6>] sys_write+0x47/0x6e
>  [<ffffffff8100ba6b>] system_call_fastpath+0x16/0x1bf
> 
> 
> Larry

-- 
[]'s
Herton
