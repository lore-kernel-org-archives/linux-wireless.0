Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43452 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab0D1OPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 10:15:12 -0400
Date: Wed, 28 Apr 2010 10:04:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Xu, Martin" <martin.xu@intel.com>
Cc: "ath9k-devel@lists.ath5k.org" <ath9k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: kernel warning on 2.6.33 ath9k
Message-ID: <20100428140446.GA2912@tuxdriver.com>
References: <1272406104-6870-1-git-send-email-benoit.papillault@free.fr>
 <1272438045.2772.6.camel@jm-desktop>
 <FC2FB65B4D919844ADE4BE3C2BB739AD1E4FB31B@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <FC2FB65B4D919844ADE4BE3C2BB739AD1E4FB31B@shsmsx501.ccr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 28, 2010 at 04:01:45PM +0800, Xu, Martin wrote:
> Hi
> I found that kernel reports below warning when using ath9k in kernel 2.6.33.
> Someone can kindly tell me whether it is the new found issue or the issue is known and has been fixed in later commit in git tree?
> Thanks!

Looks like this:

	https://bugzilla.kernel.org/show_bug.cgi?id=15839

> ------------[ cut here ]------------
> WARNING: at kernel/softirq.c:143 local_bh_enable_ip+0x32/0x76()
> Hardware name: AO532h          
> Modules linked in: cbc ecryptfs ath9k ath9k_common battery atl1c joydev ath9k_hw uvcvideo
> Pid: 850, comm: wpa_supplicant Not tainted 2.6.33.2-8.1-netbook #1
> Call Trace:
>  [<c1030978>] warn_slowpath_common+0x66/0x7d
>  [<c1035a74>] ? local_bh_enable_ip+0x32/0x76
>  [<c103099c>] warn_slowpath_null+0xd/0x10
>  [<c1035a74>] local_bh_enable_ip+0x32/0x76
>  [<c14789c0>] _raw_spin_unlock_bh+0x17/0x19
>  [<f871dbd3>] ath_tx_node_cleanup+0xe0/0xf9 [ath9k]
>  [<c103ae46>] ? lock_timer_base+0x22/0x41
>  [<f871a005>] ath9k_sta_notify+0x74/0x78 [ath9k]
>  [<c1443987>] __sta_info_unlink+0x139/0x189
>  [<f8719f91>] ? ath9k_sta_notify+0x0/0x78 [ath9k]
>  [<c14439fa>] sta_info_unlink+0x23/0x31
>  [<c1448834>] ieee80211_set_disassoc+0x1bd/0x1e3
>  [<c1448cf8>] ieee80211_mgd_deauth+0x3c/0xfe
>  [<c144df21>] ieee80211_deauth+0x14/0x16
>  [<c143c3fc>] __cfg80211_mlme_deauth+0xe9/0xf2
>  [<c143eea1>] __cfg80211_disconnect+0xcb/0x12e
>  [<c1440b74>] cfg80211_wext_siwmlme+0x64/0x80
>  [<c1441cf6>] ioctl_standard_call+0x1d7/0x26f
>  [<c139281b>] ? dev_get_by_name_rcu+0x73/0x80
>  [<c13928d9>] ? __dev_get_by_name+0x71/0x7e
>  [<c1441e81>] wext_handle_ioctl+0xf3/0x17e
>  [<c1440b10>] ? cfg80211_wext_siwmlme+0x0/0x80
>  [<c1396410>] dev_ioctl+0x578/0x598
>  [<c10091b9>] ? restore_i387_fxsave+0x54/0x66
>  [<c1387b44>] sock_ioctl+0x1cf/0x1db
>  [<c10b0979>] vfs_ioctl+0x28/0x92
>  [<c1387975>] ? sock_ioctl+0x0/0x1db
>  [<c10b0ed6>] do_vfs_ioctl+0x453/0x491
>  [<c1388233>] ? sys_recvmsg+0x2c/0x47
>  [<c1389542>] ? sys_socketcall+0x147/0x18c
>  [<c10b0f43>] sys_ioctl+0x2f/0x49
>  [<c10027d0>] sysenter_do_call+0x12/0x26

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
