Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45745 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab1BHPA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 10:00:28 -0500
Date: Tue, 8 Feb 2011 09:49:45 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add missing locking in ieee80211_reconfig
Message-ID: <20110208144945.GB2448@tuxdriver.com>
References: <1297167767-32664-1-git-send-email-eliad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297167767-32664-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 08, 2011 at 02:22:47PM +0200, Eliad Peller wrote:
> When suspending an associated system, and then resuming,
> the station vif is being reconfigured without taking the
> sdata->u.mgd.mtx lock, which results in the following warning:
> 
> WARNING: at net/mac80211/mlme.c:101 ieee80211_ap_probereq_get+0x58/0xb8 [mac)
> Modules linked in: wl12xx_sdio wl12xx firmware_class crc7 mac80211 cfg80211 ]
> Backtrace:
> [<c005432c>] (dump_backtrace+0x0/0x118) from [<c0376a04>] (dump_stack+0x20/0)
>  r7:00000000 r6:bf25f6ec r5:bf286aac r4:00000065
> [<c03769e4>] (dump_stack+0x0/0x24) from [<c0079104>] (warn_slowpath_common+0)
> [<c00790a8>] (warn_slowpath_common+0x0/0x74) from [<c0079148>] (warn_slowpat)
>  r9:000024ff r8:cd160460 r7:00000001 r6:00000000 r5:00000000
> r4:cfb9f4a0
> [<c007911c>] (warn_slowpath_null+0x0/0x34) from [<bf25f6ec>] (ieee80211_ap_p)
> [<bf25f694>] (ieee80211_ap_probereq_get+0x0/0xb8 [mac80211]) from [<bf013d04)
>  r4:cd161440
> [<bf013cd4>] (wl1271_cmd_build_ap_probe_req+0x0/0xf8 [wl12xx]) from [<bf0105)
>  r5:cd161440 r4:000003b4
> [<bf010130>] (wl1271_op_bss_info_changed+0x0/0x808 [wl12xx]) from [<bf254168)
> [<bf253fc4>] (ieee80211_bss_info_change_notify+0x0/0x1f8 [mac80211]) from [<)
>  r8:cfba12a4 r7:cd16071c r6:00000000 r5:cd160460 r4:cfb9f4a0
> [<bf2739b0>] (ieee80211_reconfig+0x0/0x668 [mac80211]) from [<bf269dd4>] (ie)
> [<bf269d74>] (ieee80211_resume+0x0/0x70 [mac80211]) from [<bf21d930>] (wiphy)
>  r5:cd160248 r4:cd160110
> [<bf21d8c4>] (wiphy_resume+0x0/0x7c [cfg80211]) from [<c0240fac>] (legacy_re)
>  r7:00000000 r6:00000000 r5:cd160248 r4:cd1602fc
> [<c0240f74>] (legacy_resume+0x0/0x70) from [<c0241400>] (device_resume+0x168)
>  r8:c04ca8d8 r7:cd16027c r6:00000010 r5:cd160248 r4:cd1602fc
> [<c0241298>] (device_resume+0x0/0x1a0) from [<c0241588>] (dpm_resume_end+0xf)
>  r7:00000000 r6:00000005 r5:cd160248 r4:cd1602fc
> [<c0241490>] (dpm_resume_end+0x0/0x3bc) from [<c00b2a24>] (suspend_devices_a)
> [<c00b2874>] (suspend_devices_and_enter+0x0/0x204) from [<c00b2b68>] (enter_)
>  r7:c037e548 r6:00000003 r5:c043d1d7 r4:00000000
> [<c00b2a78>] (enter_state+0x0/0x148) from [<c00b20a4>] (state_store+0xa4/0xc)
>  r7:c037e548 r6:00000003 r5:00000003 r4:c043d1d7
> [<c00b2000>] (state_store+0x0/0xcc) from [<c01fc90c>] (kobj_attr_store+0x20/)
> [<c01fc8ec>] (kobj_attr_store+0x0/0x24) from [<c0157120>] (sysfs_write_file+)
> [<c0157004>] (sysfs_write_file+0x0/0x150) from [<c0100f84>] (vfs_write+0xc0/)
> [<c0100ec4>] (vfs_write+0x0/0x14c) from [<c01010e4>] (sys_write+0x4c/0x78)
>  r8:40228000 r7:00000004 r6:cf0e69c0 r5:00000000 r4:00000000
> [<c0101098>] (sys_write+0x0/0x78) from [<c00500c0>] (ret_fast_syscall+0x0/0x)
>  r8:c00502c8 r7:00000004 r6:402245e8 r5:40228000 r4:00000004
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>

Thanks for the patch!  But was the backtrace always this ugly?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
