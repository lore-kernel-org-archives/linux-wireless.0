Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40522 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759827Ab2FHBfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 21:35:14 -0400
Received: by eaak11 with SMTP id k11so642750eaa.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 18:35:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH5vBdK0a_R_4PXcVqUrkak9MStQJR+z6-P+L8dbLHnWz-vCYg@mail.gmail.com>
References: <bug-2338-2785@http.bugzilla.intellinuxwireless.org/>
	<20120607161818.241F322210D14@mail.opensource.intel.com>
	<CAH5vBdK0a_R_4PXcVqUrkak9MStQJR+z6-P+L8dbLHnWz-vCYg@mail.gmail.com>
Date: Thu, 7 Jun 2012 18:35:12 -0700
Message-ID: <CAH5vBdJJzru9=s9KtPbbnPMWGQBrCPsxcgtOYSmhzPD5=6YNPw@mail.gmail.com> (sfid-20120608_033553_474728_97BF7717)
Subject: Re: [Bug 2338] unstable roaming (WPA2 Enterprise encryption + domain
 user/pass authentication)
From: cheng renquan <crquan@gmail.com>
To: Meenakshi V <meenakshi.venkataraman@intel.com>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 7, 2012 at 6:33 PM, cheng renquan <crquan@gmail.com> wrote:
> trace.dat with v3.4.0, just recorded; I saw an Ooops in cfg80211

[ 4762.047944] ------------[ cut here ]------------
[ 4762.047964] WARNING: at net/wireless/mlme.c:490
cfg80211_mlme_disassoc+0x10e/0x120 [cfg80211]()
[ 4762.047968] Hardware name: 2522BF3
[ 4762.047970] Modules linked in: ipv6 fuse uvcvideo videobuf2_vmalloc
videobuf2_memops videobuf2_core iwlwifi sr_mod cdrom videodev mac80211
nouveau cfg80211 mxm_wmi drm_kms_helper e1000e ttm thinkpad_acpi wmi
[ 4762.047994] Pid: 2129, comm: wpa_supplicant Tainted: G        W    3.4.0 #21
[ 4762.047998] Call Trace:
[ 4762.048006]  [<ffffffff8107736f>] warn_slowpath_common+0x7f/0xc0
[ 4762.048012]  [<ffffffff810773ca>] warn_slowpath_null+0x1a/0x20
[ 4762.048022]  [<ffffffffa0089b1e>]
cfg80211_mlme_disassoc+0x10e/0x120 [cfg80211]
[ 4762.048030]  [<ffffffff815e911d>] ? mutex_lock+0x1d/0x50
[ 4762.048041]  [<ffffffffa007ae93>] nl80211_disassociate+0xb3/0xf0 [cfg80211]
[ 4762.048049]  [<ffffffff81526870>] genl_rcv_msg+0x250/0x2d0
[ 4762.048053]  [<ffffffff81526620>] ? genl_rcv+0x40/0x40
[ 4762.048058]  [<ffffffff81526191>] netlink_rcv_skb+0xa1/0xb0
[ 4762.048063]  [<ffffffff81526605>] genl_rcv+0x25/0x40
[ 4762.048068]  [<ffffffff81525b6d>] netlink_unicast+0x19d/0x1f0
[ 4762.048076]  [<ffffffff81184220>] ? __pollwait+0xf0/0xf0
[ 4762.048081]  [<ffffffff81525e95>] netlink_sendmsg+0x2d5/0x340
[ 4762.048086]  [<ffffffff81184220>] ? __pollwait+0xf0/0xf0
[ 4762.048092]  [<ffffffff814e9480>] sock_sendmsg+0xf0/0x130
[ 4762.048098]  [<ffffffff814f2031>] ? consume_skb+0x31/0x70
[ 4762.048106]  [<ffffffff815a47a4>] ? packet_recvmsg+0xe4/0x520
[ 4762.048111]  [<ffffffff814ea75a>] ? move_addr_to_kernel+0x5a/0xc0
[ 4762.048117]  [<ffffffff814f5ab6>] ? verify_iovec+0x56/0xd0
[ 4762.048121]  [<ffffffff814e991e>] __sys_sendmsg+0x3fe/0x410
[ 4762.048126]  [<ffffffff81184fc1>] ? core_sys_select+0x2a1/0x350
[ 4762.048133]  [<ffffffff8116b680>] ? kmem_cache_free+0x20/0xf0
[ 4762.048139]  [<ffffffff811860fb>] ? __d_free+0x4b/0x70
[ 4762.048147]  [<ffffffff810bba60>] ? ktime_get_ts+0xb0/0xf0
[ 4762.048152]  [<ffffffff81184383>] ? poll_select_copy_remaining+0xf3/0x140
[ 4762.048157]  [<ffffffff814eb489>] sys_sendmsg+0x49/0x90
[ 4762.048165]  [<ffffffff815f31d2>] system_call_fastpath+0x16/0x1b
[ 4762.048169] ---[ end trace 8bbe2208f47c00d4 ]---
[ 4768.283282] wlan0: authenticate with 00:17:df:aa:01:ef
[ 4768.314368] wlan0: direct probe to 00:17:df:aa:01:ef (try 1/3)
[ 4768.514292] wlan0: direct probe to 00:17:df:aa:01:ef (try 2/3)
[ 4768.714887] wlan0: direct probe to 00:17:df:aa:01:ef (try 3/3)
[ 4768.915540] wlan0: authentication with 00:17:df:aa:01:ef timed out
[ 4768.929227] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active
station id 0 addr 00:17:df:aa:01:ef
[ 4889.387064] wlan0: authenticate with 6c:9c:ed:ec:fc:df
[ 4889.391505] wlan0: send auth to 6c:9c:ed:ec:fc:df (try 1/3)
[ 4889.392784] wlan0: authenticated
[ 4889.393877] wlan0: associate with 6c:9c:ed:ec:fc:df (try 1/3)
[ 4889.396689] wlan0: RX AssocResp from 6c:9c:ed:ec:fc:df (capab=0x11
status=0 aid=4)
[ 4889.396697] wlan0: associated
