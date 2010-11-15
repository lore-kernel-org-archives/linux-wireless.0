Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34167 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514Ab0KORxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 12:53:32 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id oAFHrTJ0002177
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 15 Nov 2010 09:53:30 -0800
Message-ID: <4CE17399.4070703@candelatech.com>
Date: Mon, 15 Nov 2010 09:53:29 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k + hack lockdep warning.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch I added to allow multiple VIFS to share scan results is
causing all sorts of crashes on my ath9k box.  I am not sure if my patch
is buggy, or if it's just that with it the STAs can all attempt to associate
in parallel and thus new races are showing up.

I have not reproduced this on a standard kernel, so please feel free to
ignore, as it might be all my fault.

In the trace below, ath9k has already spewed lost of errors about
DMA not stopping properly...


Nov 15 09:31:54 localhost kernel: e1000e 0000:06:00.0: eth0: Detected Hardware Unit Hang:

=============================================
[ INFO: possible recursive locking detected ]
2.6.37-rc1-wl+ #47
---------------------------------------------
kworker/u:0/5 is trying to acquire lock:
  (&(&txq->axq_lock)->rlock){+.-...}, at: [<f8a4c0aa>] ath_tx_complete_buf+0x1d4/0x26c [ath9k]

but task is already holding lock:
  (&(&txq->axq_lock)->rlock){+.-...}, at: [<f8a4cce6>] ath_tx_flush_tid+0x41/0xb6 [ath9k]

other info that might help us debug this:
6 locks held by kworker/u:0/5:
  #0:  (name){+.+.+.}, at: [<78446e6f>] process_one_work+0x13e/0x2bf
  #1:  ((&sdata->work)){+.+.+.}, at: [<78446e6f>] process_one_work+0x13e/0x2bf
  #2:  (&ifmgd->mtx){+.+.+.}, at: [<f868b0d6>] ieee80211_sta_work+0x21/0x16a [mac80211]
  #3:  (&local->sta_mtx){+.+.+.}, at: [<f868a150>] ieee80211_set_disassoc+0xab/0x1bc [mac80211]
  #4:  (&sta->ampdu_mlme.mtx){+.+...}, at: [<f8688096>] __ieee80211_stop_tx_ba_session+0x25/0x4c [mac80211]
  #5:  (&(&txq->axq_lock)->rlock){+.-...}, at: [<f8a4cce6>] ath_tx_flush_tid+0x41/0xb6 [ath9k]

stack backtrace:
Pid: 5, comm: kworker/u:0 Tainted: G        W   2.6.37-rc1-wl+ #47
Call Trace:
  [<7878bf56>] ? printk+0x18/0x1a
  [<7845bb58>] __lock_acquire+0xb14/0xb8b
  [<78594995>] ? put_dec+0x2a/0x74
  [<785954f3>] ? mac_address_string+0x81/0x89
  [<7845bc41>] lock_acquire+0x72/0x8d
  [<f8a4c0aa>] ? ath_tx_complete_buf+0x1d4/0x26c [ath9k]
  [<7878de3a>] _raw_spin_lock_bh+0x38/0x45
  [<f8a4c0aa>] ? ath_tx_complete_buf+0x1d4/0x26c [ath9k]
  [<f8a4c0aa>] ath_tx_complete_buf+0x1d4/0x26c [ath9k]
  [<f8a4cd31>] ath_tx_flush_tid+0x8c/0xb6 [ath9k]
  [<f8a4d716>] ath_tx_aggr_stop+0x7e/0x86 [ath9k]
  [<f8a486bd>] ath9k_ampdu_action+0x93/0xf4 [ath9k]
  [<f8a4862a>] ? ath9k_ampdu_action+0x0/0xf4 [ath9k]
  [<f8687708>] drv_ampdu_action+0x60/0x68 [mac80211]
  [<f8687faf>] ___ieee80211_stop_tx_ba_session+0xde/0xfd [mac80211]
  [<f86880aa>] __ieee80211_stop_tx_ba_session+0x39/0x4c [mac80211]
  [<f8687683>] ieee80211_sta_tear_down_BA_sessions+0x31/0x56 [mac80211]
  [<f868a0a0>] ? set_sta_flags+0x23/0x28 [mac80211]
  [<f868a175>] ieee80211_set_disassoc+0xd0/0x1bc [mac80211]
  [<f868b1b5>] ieee80211_sta_work+0x100/0x16a [mac80211]
  [<f868fb29>] ieee80211_iface_work+0x268/0x282 [mac80211]
  [<78446ee0>] process_one_work+0x1af/0x2bf
  [<78446e6f>] ? process_one_work+0x13e/0x2bf
  [<f868f8c1>] ? ieee80211_iface_work+0x0/0x282 [mac80211]
  [<7844862e>] worker_thread+0xf9/0x1bf
  [<78448535>] ? worker_thread+0x0/0x1bf
  [<7844b15e>] kthread+0x62/0x67
  [<7844b0fc>] ? kthread+0x0/0x67
  [<784036c6>] kernel_thread_helper+0x6/0x1a


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

