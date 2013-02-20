Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub029-ca-8.exch029.serverdata.net ([64.78.52.51]:24271 "EHLO
	hub029-CA-8.exch029.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753714Ab3BTSIA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 13:08:00 -0500
MIME-Version: 1.0
Date: Wed, 20 Feb 2013 09:59:54 -0800
From: Yuji Sasaki <sasaki@silexamerica.com>
To: <linux-wireless@vger.kernel.org>
Subject: ath6kl_sdio ad-hoc mode issue
Content-Type: text/plain
Message-ID: <c21396b6-52e9-4f55-a57d-7390c47c51ca@HUB029-CA-8.exch029.domain.local> (sfid-20130220_190804_526468_91143272)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm testing ath6kl_sdio driver (from compat-driver 3.8-rc7-1) on Freescale i.MX28 (Linux 2.6.35.3-571) with silex SD-SDMAN wireless module (AR6233 dualband SIP). When I test ad-hoc functionality, I frequentry experience warning as below;

# ------------[ cut here ]------------
WARNING: at /home/sasaki/bttest/kernel/compat-drivers-3.8-rc7-1-u/net/wireless/ibss.c:35 __cfg80211_ibss_joined+0x74/0x168 [cfg80211]()
Modules linked in: ath6kl_sdio ath6kl_core cfg80211 compat sx570_gpio ipt_REJECT xt_iprange iptable_filter ip_tables x_tables rfkill mxs_mmc mmc_block mmc_core [last unloaded: compat]
Backtrace:
[<c0023334>] (dump_backtrace+0x0/0x114) from [<c0242570>] (dump_stack+0x18/0x1c)
 r7:00000009 r6:00000023 r5:bf691144 r4:00000000
[<c0242558>] (dump_stack+0x0/0x1c) from [<c003a6d8>] (warn_slowpath_common+0x54/0x6c)
[<c003a684>] (warn_slowpath_common+0x0/0x6c) from [<c003a714>] (warn_slowpath_null+0x24/0x2c)
 r9:00100100 r8:c3fed368 r7:00000000 r6:c3e9288c r5:c3fed000
r4:c3fed348
[<c003a6f0>] (warn_slowpath_null+0x0/0x2c) from [<bf691144>] (__cfg80211_ibss_joined+0x74/0x168 [cfg80211])
[<bf6910d0>] (__cfg80211_ibss_joined+0x0/0x168 [cfg80211]) from [<bf6791d0>] (cfg80211_process_wdev_events+0x174/0x1e4 [cfg80211])
 r7:00000000 r6:c3fed348 r5:c3fac000 r4:c3e92880
[<bf67905c>] (cfg80211_process_wdev_events+0x0/0x1e4 [cfg80211]) from [<bf67928c>] (cfg80211_process_rdev_events+0x4c/0x80 [cfg80211])
[<bf679240>] (cfg80211_process_rdev_events+0x0/0x80 [cfg80211]) from [<bf677658>] (cfg80211_event_work+0x28/0x58 [cfg80211])
 r7:c3e5e0c8 r6:bf677630 r5:c3e3800c r4:c3e38000
[<bf677630>] (cfg80211_event_work+0x0/0x58 [cfg80211]) from [<c004e4e8>] (worker_thread+0x19c/0x25c)
 r5:c3e5e0c0 r4:c3fac000
[<c004e34c>] (worker_thread+0x0/0x25c) from [<c00520d0>] (kthread+0x84/0x8c)
[<c005204c>] (kthread+0x0/0x8c) from [<c003e07c>] (do_exit+0x0/0x6b0)
 r7:00000013 r6:c003e07c r5:c005204c r4:c3e6be90
---[ end trace 5ddf6435a0daeb23 ]---

It happens when I start a new ad-hoc group on i.MX28, then join another node (a PC-Linux, Fedora 18 / Kernel 3.7.8-202 + AR5005 ath5k driver) to that ad-hoc gruop.
I tracked down why this warning happens.
The warning is caused at __cfg80211_ibss_joined() in net/wireless/ibss.c, claiming bss pointer returned from cfg80211_get_bss() was NULL.
The reason why cfg80211_get_bss() returns NULL is, the bssid parameter passed to __cfg80211_ibss_joined() was all zero (not NULL pointer).
The reason why all-zero BSSID is passed to __cfg80211_ibss_joined() was found to be because, it is called from ath6kl_cfg80211_disconnect_event() in drivers/net/wireless/ath/ath6kl/cfg80211.c as;

        if (vif->nw_type & ADHOC_NETWORK) {
                if (vif->wdev.iftype != NL80211_IFTYPE_ADHOC) {
                        ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
                                   "%s: ath6k not in ibss mode\n", __func__);
                        return;
                }
                memset(bssid, 0, ETH_ALEN);
                cfg80211_ibss_joined(vif->ndev, bssid, GFP_KERNEL);
                return;
        }

I have no idea why all-zero BSSID is passed to cfg80211_ibss_joined() on disconnect event. As long as I tracked the code, bssid is only refered to retreive cfg80211_bss* pointer in  __cfg80211_ibss_joined(), and it just does not make sense to pass all-zero BSSID...it certainly returns NULL pointer.
I think those two lines will be unnecessary, but I'm not sure the original intention.

--------
Yuji Sasaki
silex technology America, inc.
201 East Sandpointe, #245, Santa Ana, CA 92707, USA
