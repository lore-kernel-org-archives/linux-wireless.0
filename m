Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-01.prod.sin2.secureserver.net ([182.50.145.4]:33499
	"HELO sg2plout10-01.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751944Ab2KSPAG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 10:00:06 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20650.18783.6821.78205@gargle.gargle.HOWL> (sfid-20121119_160011_381727_73392675)
Date: Mon, 19 Nov 2012 20:29:43 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: Add debugfs callbacks for station addition/removal
In-Reply-To: <1353334496.18299.5.camel@jlt4.sipsolutions.net>
References: <1353304116-7124-1-git-send-email-sujith@msujith.org>
	<1353334496.18299.5.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Can the files stay across a firmware restart or suspend/resume? I guess
> with suspend/resume nothing can access them, but accessing them during
> firmware restart might be ... strange? Not that I'm too worried about
> that.

As discussed in irc, leaving it to the drivers would be reasonable.

BTW, here are few warnings that I saw when doing a suspend/resume cycle:

linux-test kernel: WARNING: at /home/sujith/dev/wireless-testing/net/mac80211/chan.c:379 ieee80211_vif_release_channel+0x36/0x70 [mac80211]()
linux-test kernel: Hardware name: LIFEBOOK AH531
linux-test kernel: Pid: 4139, comm: pm-suspend Tainted: G        W  O 3.7.0-rc5-wl-debug #31
linux-test kernel: Call Trace:
linux-test kernel:  [<ffffffff8105697f>] warn_slowpath_common+0x7f/0xc0
linux-test kernel:  [<ffffffff810569da>] warn_slowpath_null+0x1a/0x20
linux-test kernel:  [<ffffffffa056e566>] ieee80211_vif_release_channel+0x36/0x70 [mac80211]
linux-test kernel:  [<ffffffffa059a3ca>] __ieee80211_suspend+0x45a/0xd10 [mac80211]
linux-test kernel:  [<ffffffff81388e27>] ? rtnl_lock+0x17/0x20
linux-test kernel:  [<ffffffffa055cbba>] ieee80211_suspend+0x1a/0x20 [mac80211]
linux-test kernel:  [<ffffffffa03d2945>] wiphy_suspend+0x95/0x180 [cfg80211]
linux-test kernel:  [<ffffffffa03d28b0>] ? wiphy_resume+0x180/0x180 [cfg80211]
linux-test kernel:  [<ffffffff8147852f>] legacy_suspend+0x2a/0x58
linux-test kernel:  [<ffffffff81324fec>] __device_suspend+0x1fc/0x210
linux-test kernel:  [<ffffffff81325a48>] dpm_suspend+0x68/0x240
linux-test kernel:  [<ffffffff81325ea7>] dpm_suspend_start+0x57/0x60
linux-test kernel:  [<ffffffff8109f9c1>] suspend_devices_and_enter+0x81/0x340
linux-test kernel:  [<ffffffff8109fe74>] pm_suspend+0x1f4/0x200
linux-test kernel:  [<ffffffff8109ed87>] state_store+0x87/0xf0
linux-test kernel:  [<ffffffff8124c2cf>] kobj_attr_store+0xf/0x20
linux-test kernel:  [<ffffffff811f73e0>] sysfs_write_file+0xe0/0x150
linux-test kernel:  [<ffffffff81182aa8>] vfs_write+0xa8/0x180
linux-test kernel:  [<ffffffff81182df2>] sys_write+0x52/0xa0
linux-test kernel:  [<ffffffff8147ef19>] system_call_fastpath+0x16/0x1b

and

linux-test kernel: WARNING: at /home/sujith/dev/wireless-testing/net/mac80211/ieee80211_i.h:1503 ieee80211_send_nullfunc+0xfe/0x130 [mac80211]()
linux-test kernel: Hardware name: LIFEBOOK AH531
linux-test kernel: Pid: 4139, comm: pm-suspend Tainted: G        W  O 3.7.0-rc5-wl-debug #31
linux-test kernel: Call Trace:
linux-test kernel:  [<ffffffff8105697f>] warn_slowpath_common+0x7f/0xc0
linux-test kernel:  [<ffffffff810569da>] warn_slowpath_null+0x1a/0x20
linux-test kernel:  [<ffffffffa058501e>] ieee80211_send_nullfunc+0xfe/0x130 [mac80211]
linux-test kernel:  [<ffffffffa0584f81>] ? ieee80211_send_nullfunc+0x61/0x130 [mac80211]
linux-test kernel:  [<ffffffffa05858a5>] ? ieee80211_recalc_ps+0x1e5/0x230 [mac80211]
linux-test kernel:  [<ffffffffa056be8c>] ieee80211_reconfig+0x15ac/0x1c00 [mac80211]
linux-test kernel:  [<ffffffffa055acbd>] ieee80211_resume+0x2d/0x70 [mac80211]
linux-test kernel:  [<ffffffffa03d27c9>] wiphy_resume+0x99/0x180 [cfg80211]
linux-test kernel:  [<ffffffffa03d2730>] ? index_show+0x30/0x30 [cfg80211]
linux-test kernel:  [<ffffffff8132437b>] dpm_run_callback.isra.4+0x3b/0x70
linux-test kernel:  [<ffffffff8132515c>] device_resume+0xbc/0x150
linux-test kernel:  [<ffffffff81325694>] dpm_resume+0x114/0x250
linux-test kernel:  [<ffffffff813259c5>] dpm_resume_end+0x15/0x30
linux-test kernel:  [<ffffffff812a8069>] ? acpi_suspend_begin_old+0x2d/0x2d
linux-test kernel:  [<ffffffff8109f9f6>] suspend_devices_and_enter+0xb6/0x340
linux-test kernel:  [<ffffffff8109fe74>] pm_suspend+0x1f4/0x200
linux-test kernel:  [<ffffffff8109ed87>] state_store+0x87/0xf0
linux-test kernel:  [<ffffffff8124c2cf>] kobj_attr_store+0xf/0x20
linux-test kernel:  [<ffffffff811f73e0>] sysfs_write_file+0xe0/0x150
linux-test kernel:  [<ffffffff81182aa8>] vfs_write+0xa8/0x180
linux-test kernel:  [<ffffffff81182df2>] sys_write+0x52/0xa0
linux-test kernel:  [<ffffffff8147ef19>] system_call_fastpath+0x16/0x1b


Sujith
