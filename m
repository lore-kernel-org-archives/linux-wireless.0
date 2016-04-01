Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40860 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbcDAP4B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 11:56:01 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id A855D40EC8D
	for <linux-wireless@vger.kernel.org>; Fri,  1 Apr 2016 08:56:00 -0700 (PDT)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: mac80211 kasan splat, hacked 4.4.6+, ath10k with modified 10.4.3 fw
Message-ID: <56FE9A10.1060908@candelatech.com> (sfid-20160401_175610_551042_58304FA5)
Date: Fri, 1 Apr 2016 08:56:00 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I saw this splat yesterday evening...  Any ideas on what this could be?

I'll add some bounds checking on the rate->idx in case that is the issue...


(gdb) l *(sta_set_rate_info_tx+0x1b3)
0x38dcc is in sta_set_rate_info_tx (/home/greearb/git/linux-4.4.dev.y/net/mac80211/cfg.c:457).
452			u16 brate;
453	
454			sband = sta->local->hw.wiphy->bands[
455					ieee80211_get_sdata_band(sta->sdata)];
456			brate = sband->bitrates[rate->idx].bitrate;
457			rinfo->legacy = DIV_ROUND_UP(brate, 1 << shift);
458		}
459		if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
460			rinfo->bw = RATE_INFO_BW_40;
461		else if (rate->flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
(gdb)


==================================================================
BUG: KASAN: global-out-of-bounds in sta_set_rate_info_tx+0x1b3/0x262 [mac80211] at addr ffffffffa18a3c0c
Read of size 2 by task cat/19440
Address belongs to variable ath10k_rates+0xac/0xfffffffffffd04c7 [ath10k_core]
CPU: 3 PID: 19440 Comm: cat Tainted: G        W  O    4.4.6+ #22
Hardware name: To be filled by O.E.M. To be filled by O.E.M./HURONRIVER, BIOS 4.6.5 05/02/2012
  0000000000000000 ffff8800a392f878 ffffffff8154ce6c 1ffffffff4314781
  fffffbfff4314781 ffff8800a392f8f0 ffffffff812db48c ffffffffa1158da8
  0000000000000246 0000000000000246 ffff8801d50287c8 0000000400000003
Call Trace:
  [<ffffffff8154ce6c>] dump_stack+0x81/0xb6
  [<ffffffff812db48c>] kasan_report+0x347/0x48b
  [<ffffffffa1158da8>] ? sta_set_rate_info_tx+0x1b3/0x262 [mac80211]
  [<ffffffff812da625>] __asan_load2+0x23/0x68
  [<ffffffffa1158da8>] sta_set_rate_info_tx+0x1b3/0x262 [mac80211]
  [<ffffffffa112de90>] sta_set_sinfo+0x633/0x11e5 [mac80211]
  [<ffffffffa114f92c>] ieee80211_get_station+0x63/0x77 [mac80211]
  [<ffffffffa09f8c64>] rdev_get_station+0x131/0x31f [cfg80211]
  [<ffffffff81b3424f>] ? __mutex_unlock_slowpath+0x17b/0x196
  [<ffffffffa09fcc2c>] cfg80211_wireless_stats+0x13d/0x235 [cfg80211]
  [<ffffffffa09fcaef>] ? cfg80211_wext_giwrate+0x1b2/0x1b2 [cfg80211]
  [<ffffffff811625b7>] ? ___might_sleep+0xfa/0x223
  [<ffffffff81b12736>] get_wireless_stats+0x96/0x9b
  [<ffffffff81b12f2d>] wireless_dev_seq_show+0x53/0x1f1
  [<ffffffff81321392>] seq_read+0x5c6/0x791
  [<ffffffff81320dcc>] ? seq_hlist_start_percpu+0xcb/0xcb
  [<ffffffff8118fb86>] ? __lock_is_held+0x29/0x64
  [<ffffffff81381db4>] proc_reg_read+0x81/0x9b
  [<ffffffff812f1589>] __vfs_read+0xca/0x1da
  [<ffffffff812f14bf>] ? fdget_pos+0x19/0x19
  [<ffffffff81194d96>] ? lock_release+0x249/0x4ec
  [<ffffffff81194a81>] ? lock_acquire+0x167/0x233
  [<ffffffff81192a73>] ? mark_held_locks+0x2d/0x90
  [<ffffffff811cc983>] ? read_seqcount_begin.constprop.23+0x6b/0x87
  [<ffffffff813447bd>] ? __fsnotify_parent+0x31/0x100
  [<ffffffff814659e9>] ? fsnotify_perm+0x88/0x95
  [<ffffffff81466fcf>] ? security_file_permission+0x4d/0x54
  [<ffffffff812f2349>] ? rw_verify_area+0xd7/0x12e
  [<ffffffff812f2443>] vfs_read+0xa3/0x100
  [<ffffffff812f3176>] SyS_read+0xb5/0x10f
  [<ffffffff812f30c1>] ? do_sendfile+0x3d5/0x3d5
  [<ffffffff81192cdf>] ? trace_hardirqs_on_caller+0x209/0x250
  [<ffffffff81004017>] ? trace_hardirqs_on_thunk+0x17/0x19
  [<ffffffff81b36d76>] entry_SYSCALL_64_fastpath+0x16/0x7a
Memory state around the buggy address:
  ffffffffa18a3b00: fa fa fa fa 04 fa fa fa fa fa fa fa 00 00 00 00
  ffffffffa18a3b80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 fa fa
 >ffffffffa18a3c00: fa fa fa fa 00 00 00 00 00 00 00 00 00 00 00 00
                       ^
  ffffffffa18a3c80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffffffffa18a3d00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================
Disabling lock debugging due to kernel taint
==================================================================
-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

