Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out8.libero.it ([212.52.84.108]:35724 "EHLO
	cp-out8.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbZGVWyL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 18:54:11 -0400
Received: from pcfabio.home.lan (151.48.46.16) by cp-out8.libero.it (8.5.107)
        id 4A5EF75100AEE23E for linux-wireless@vger.kernel.org; Thu, 23 Jul 2009 00:54:09 +0200
From: Fabio Rossi <rossi.f@inwind.it>
To: linux-wireless@vger.kernel.org
Subject: WARNING: at net/mac80211/tx.c:561
Date: Thu, 23 Jul 2009 00:51:56 +0200
MIME-Version: 1.0
Message-Id: <200907230051.57201.rossi.f@inwind.it>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using the last wireless-testing.git and I have experienced the following 
WARNING:

 WARNING: at net/mac80211/tx.c:561 ieee80211_tx_h_rate_ctrl+0x3d1/0x470 
[mac80211]()
 Hardware name: System Name
 wlan0: Dropped data frame as no usable bitrate found while scanning and 
associated. Target station: 00:0c:f6:xx:xx:xx on 5 GHz band
 Modules linked in: ath5k mac80211 ath cfg80211
 Pid: 1270, comm: phy0 Tainted: G        W  2.6.31-rc3-wl #140
 Call Trace:
  [<e1aaa0a1>] ? ieee80211_tx_h_rate_ctrl+0x3d1/0x470 [mac80211]
  [<e1aaa0a1>] ? ieee80211_tx_h_rate_ctrl+0x3d1/0x470 [mac80211]
  [<c101d37c>] warn_slowpath_common+0x7c/0xa0
  [<e1aaa0a1>] ? ieee80211_tx_h_rate_ctrl+0x3d1/0x470 [mac80211]
  [<c101d3e6>] warn_slowpath_fmt+0x26/0x30
  [<e1aaa0a1>] ieee80211_tx_h_rate_ctrl+0x3d1/0x470 [mac80211]
  [<e1af8afb>] ? ath5k_hw_reset_tx_queue+0x51b/0x830 [ath5k]
  [<e1aa8aa5>] ? ieee80211_tx_prepare+0x105/0x320 [mac80211]
  [<e1aaa489>] invoke_tx_handlers+0x69/0xf0 [mac80211]
  [<e1aaa64f>] ieee80211_tx+0x5f/0x1f0 [mac80211]
  [<c139f940>] ? skb_release_data+0x50/0x90
  [<c139fa83>] ? pskb_expand_head+0x103/0x190
  [<e1aaa8e5>] ieee80211_xmit+0x105/0x270 [mac80211]
  [<e1aaaa9e>] ieee80211_tx_skb+0x4e/0x60 [mac80211]
  [<e1aad7a2>] ieee80211_send_probe_req+0x112/0x180 [mac80211]
  [<c1017168>] ? dequeue_task+0x48/0x90
  [<c101e11b>] ? printk+0x1b/0x20
  [<e1a9ea9a>] ieee80211_mgd_probe_ap+0x11a/0x150 [mac80211]
  [<e1a9eb12>] ieee80211_beacon_loss_work+0x12/0x20 [mac80211]
  [<c102c75c>] worker_thread+0xec/0x1c0
  [<c1454b7d>] ? schedule+0x18d/0x370
  [<e1a9eb00>] ? ieee80211_beacon_loss_work+0x0/0x20 [mac80211]
  [<c102f740>] ? autoremove_wake_function+0x0/0x40
  [<c102c670>] ? worker_thread+0x0/0x1c0
  [<c102f494>] kthread+0x74/0x80
  [<c102f420>] ? kthread+0x0/0x80
  [<c10032d3>] kernel_thread_helper+0x7/0x14
 ---[ end trace a5a80f7488aa4974 ]---

I have a 802.11abg wireless NIC and I'm currently using a 802.11g access 
point.

Fabio
