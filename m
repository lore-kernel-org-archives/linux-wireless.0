Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:34332 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933294AbXGZJN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 05:13:27 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id 1638D8CAD8
	for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2007 11:13:24 +0200 (CEST)
Received: from meerkat.home.warmcat.com (localhost [127.0.0.1])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id 571F714B69
	for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2007 09:15:08 +0000 (UTC)
Message-ID: <46A865B4.40005@warmcat.com>
Date: Thu, 26 Jul 2007 10:13:24 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: wpa_supplicant BUG() on wireless-dev
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks -

Current wireless-dev + iwl3945 + wpa_supplicant --->

BUG: sleeping function called from invalid context at mm/slab.c:3024
in_atomic():1, irqs_disabled():0
2 locks held by wpa_supplicant/1790:
 #0:  (rtnl_mutex){--..}, at: [<c0621387>] mutex_lock+0x21/0x24
 #1:  (&local->sta_bss_lock){-+..}, at: [<f8a3635e>]
ieee80211_sta_scan_results+0x43/0x6b8 [mac80211]
 [<c0405f35>] show_trace_log_lvl+0x1a/0x2f
 [<c0406927>] show_trace+0x12/0x14
 [<c040693f>] dump_stack+0x16/0x18
 [<c0423fb4>] __might_sleep+0xce/0xd5
 [<c047c9d9>] kmem_cache_alloc+0x3b/0xee
 [<f8a367c6>] ieee80211_sta_scan_results+0x4ab/0x6b8 [mac80211]
 [<f8a2d2c5>] ieee80211_ioctl_giwscan+0x3d/0x53 [mac80211]
 [<c061c918>] ioctl_standard_call+0x1f9/0x2c5
 [<c061ca90>] wext_handle_ioctl+0xac/0x375
 [<c05bf83f>] dev_ioctl+0x3e5/0x404
 [<c05b3e41>] sock_ioctl+0x1be/0x1c9
 [<c048ae72>] do_ioctl+0x22/0x67
 [<c048b100>] vfs_ioctl+0x249/0x25c
 [<c048b15c>] sys_ioctl+0x49/0x61
 [<c0404ed2>] sysenter_past_esp+0x5f/0x99
 =======================
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:11:50:ad:ce:38
wlan0: RX authentication from 00:11:50:ad:ce:38 (alg=0 transaction=2
status=0)
wlan0: authenticated
wlan0: associate with AP 00:11:50:ad:ce:38
wlan0: RX AssocResp from 00:11:50:ad:ce:38 (capab=0x431 status=0 aid=2)
wlan0: associated
wlan0: switched to short barker preamble (BSSID=00:11:50:ad:ce:38)

-Andy
