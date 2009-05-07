Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:51995 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbZEGGSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2009 02:18:45 -0400
Received: from [192.168.1.193] (S0106001cf062885c.vc.shawcable.net [24.82.155.236])
	by mail.holtmann.org (Postfix) with ESMTP id 774698B547
	for <linux-wireless@vger.kernel.org>; Thu,  7 May 2009 08:18:48 +0200 (CEST)
Subject: Warning when terminating wpa_supplicant (wext driver)
From: Marcel Holtmann <marcel@holtmann.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Wed, 06 May 2009 23:18:27 -0700
Message-Id: <1241677107.2918.4.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys,

so I am running the wireless-testing.git tree from today and when
terminating wpa_supplicant (wext driver), I get this warning in my
kernel logs:

------------[ cut here ]------------
WARNING: at net/mac80211/agg-tx.c:142 ___ieee80211_stop_tx_ba_session+0x6b/0x7e [mac80211]()
Hardware name: 7454CTO
Modules linked in: tun fuse sco bluetooth binfmt_misc uinput iwlagn snd_hda_codec_conexant snd_hda_intel iwlcore snd_hda_codec i2400m_usb mbm cdc_ether i2400m usbnet uvcvideo snd_pcm mii mac80211 cdc_acm cdc_wdm snd_timer snd cfg80211 wimax soundcore snd_page_alloc uhci_hcd ehci_hcd [last unloaded: microcode]
Pid: 2741, comm: wpa_supplicant Not tainted 2.6.30-rc4-wl #17
Call Trace:
 [<ffffffff80234b58>] warn_slowpath+0xb1/0xe5
 [<ffffffffa014bda4>] ? iwl_tx_agg_stop+0x297/0x2bd [iwlcore]
 [<ffffffffa018612c>] ? iwl_mac_ampdu_action+0x2ab/0x332 [iwlagn]
 [<ffffffffa0088b02>] ___ieee80211_stop_tx_ba_session+0x6b/0x7e [mac80211]
 [<ffffffffa0088c80>] __ieee80211_stop_tx_ba_session+0x63/0x7b [mac80211]
 [<ffffffffa008890c>] ieee80211_sta_tear_down_BA_sessions+0x1b/0x3b [mac80211]
 [<ffffffffa008f105>] ieee80211_stop+0x9f/0x561 [mac80211]
 [<ffffffff80548124>] ? _spin_unlock_bh+0x1e/0x20
 [<ffffffff804b4583>] ? dev_deactivate+0x156/0x186
 [<ffffffff804a72f3>] dev_close+0x74/0x96
 [<ffffffff804a6f93>] dev_change_flags+0xba/0x180
 [<ffffffff804e3008>] devinet_ioctl+0x278/0x604
 [<ffffffff804e423e>] inet_ioctl+0x92/0xaa
 [<ffffffff80497b8e>] sock_ioctl+0x1f1/0x21b
 [<ffffffff802a5970>] vfs_ioctl+0x2a/0x78
 [<ffffffff802a5dfa>] do_vfs_ioctl+0x43c/0x478
 [<ffffffff802a5e8b>] sys_ioctl+0x55/0x77
 [<ffffffff8020af6b>] system_call_fastpath+0x16/0x1b
---[ end trace 8a26567db4679b5c ]---

The hardware is an Intel 5350 card if that actually matters.

Regards

Marcel


