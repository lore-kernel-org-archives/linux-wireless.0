Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58372 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab2BOEDL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 23:03:11 -0500
Received: by pbcun15 with SMTP id un15so1050639pbc.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2012 20:03:10 -0800 (PST)
Date: Tue, 14 Feb 2012 20:03:07 -0800
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: wl12xx: BUG: scheduling while atomic: kworker
Message-ID: <20120215040307.GA4387@shredder> (sfid-20120215_050328_165375_C3295EB2)
References: <CAG6hwVNXru0bN+MZNf+vwN=LGFn9G8EpzK+A=FOCHwe0yYCbyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAG6hwVNXru0bN+MZNf+vwN=LGFn9G8EpzK+A=FOCHwe0yYCbyQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, gmail ate the formatting. Resending:

# [  151.065338] BUG: scheduling while atomic: kworker/0:1/425/0x00000200
[  151.066009] 9 locks held by kworker/0:1/425:
[  151.077178]  #0:  (events){.+.+.+}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  151.085113]  #1:  ((&rdev->conn_work)){+.+.+.}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  151.094116]  #2:  (rtnl_mutex){+.+.+.}, at: [<bf0199d0>] cfg80211_conn_work+0x18/0x13c [cfg80211]
[  151.097900]  #3:  (&rdev->mtx){+.+.+.}, at: [<bf0199e0>] cfg80211_conn_work+0x28/0x13c [cfg80211]
[  151.113037]  #4:  (&rdev->devlist_mtx){+.+.+.}, at: [<bf0199ec>] cfg80211_conn_work+0x34/0x13c [cfg80]
[  151.123199]  #5:  (&wdev->mtx){+.+.+.}, at: [<bf019a34>] cfg80211_conn_work+0x7c/0x13c [cfg80211]
[  151.132629]  #6:  (&ifmgd->mtx){+.+.+.}, at: [<bf073620>] ieee80211_mgd_auth+0xc4/0x3b0 [mac80211]
[  151.135681]  #7:  (rcu_read_lock){.+.+.+}, at: [<bf059f4c>] ieee80211_xmit+0x0/0x150 [mac80211]
[  151.144165]  #8:  (rcu_read_lock){.+.+.+}, at: [<bf059e7c>] ieee80211_tx+0x24/0xf4 [mac80211]
[  151.153472] Modules linked in: arc4 wl12xx_sdio wl12xx mac80211 cfg80211
[  151.166839] [<c001a330>] (unwind_backtrace+0x0/0xf0) from [<c0430c38>] (__schedule+0x730/0x7b4)
[  151.177032] [<c0430c38>] (__schedule+0x730/0x7b4) from [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8)
[  151.186462] [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8) from [<c04303c0>] (wait_for_common+0xac/0x150)
[  151.196258] [<c04303c0>] (wait_for_common+0xac/0x150) from [<c033bd24>] (mmc_wait_for_req_done+0x1c/0)
[  151.206329] [<c033bd24>] (mmc_wait_for_req_done+0x1c/0x74) from [<c03448e0>] (mmc_io_rw_extended+0x15)
[  151.216766] [<c03448e0>] (mmc_io_rw_extended+0x15c/0x1f8) from [<c0345a78>] (sdio_io_rw_ext_helper+0x)
[  151.227355] [<c0345a78>] (sdio_io_rw_ext_helper+0x154/0x1d4) from [<c0345b64>] (sdio_memcpy_toio+0x20)
[  151.237609] [<c0345b64>] (sdio_memcpy_toio+0x20/0x28) from [<bf0f2170>] (wl12xx_sdio_raw_write+0x50/0)
[  151.249053] [<bf0f2170>] (wl12xx_sdio_raw_write+0x50/0xa4 [wl12xx_sdio]) from [<bf0c710c>] (wl1271_cm)
[  151.261260] [<bf0c710c>] (wl1271_cmd_send+0x80/0x3b4 [wl12xx]) from [<bf0c98f4>] (wl12xx_start_dev+0x)
[  151.272674] [<bf0c98f4>] (wl12xx_start_dev+0x90/0x144 [wl12xx]) from [<bf0cab2c>] (wl12xx_tx_get_hlid)
[  151.284179] [<bf0cab2c>] (wl12xx_tx_get_hlid+0xc8/0xcc [wl12xx]) from [<bf0c36c4>] (wl1271_op_tx+0x44)
[  151.284179] [<bf0c36c4>] (wl1271_op_tx+0x44/0x150 [wl12xx]) from [<bf059ce8>] (__ieee80211_tx.isra.4+)
[  151.307586] [<bf059ce8>] (__ieee80211_tx.isra.4+0x150/0x2c0 [mac80211]) from [<bf059f18>] (ieee80211_)
[  151.319702] [<bf059f18>] (ieee80211_tx+0xc0/0xf4 [mac80211]) from [<bf05a008>] (ieee80211_xmit+0xbc/0)
[  151.330841] [<bf05a008>] (ieee80211_xmit+0xbc/0x150 [mac80211]) from [<bf05b2a8>] (ieee80211_tx_skb_t)
[  151.342956] [<bf05b2a8>] (ieee80211_tx_skb_tid+0x3c/0x48 [mac80211]) from [<bf06f998>] (ieee80211_pro)
[  151.355773] [<bf06f998>] (ieee80211_probe_auth+0x128/0x2f8 [mac80211]) from [<bf073774>] (ieee80211_m)
[  151.355773] [<bf073774>] (ieee80211_mgd_auth+0x218/0x3b0 [mac80211]) from [<bf016e94>] (__cfg80211_ml)
[  151.381378] [<bf016e94>] (__cfg80211_mlme_auth+0xec/0x160 [cfg80211]) from [<bf018e1c>] (cfg80211_con)
[  151.394073] [<bf018e1c>] (cfg80211_conn_do_work+0x14c/0x218 [cfg80211]) from [<bf019a78>] (cfg80211_c)
[  151.406799] [<bf019a78>] (cfg80211_conn_work+0xc0/0x13c [cfg80211]) from [<c0057da0>] (process_one_wo)
[  151.417877] [<c0057da0>] (process_one_work+0x188/0x508) from [<c00584d0>] (worker_thread+0x170/0x370)
[  151.427581] [<c00584d0>] (worker_thread+0x170/0x370) from [<c005d080>] (kthread+0x84/0x90)
[  151.436279] [<c005d080>] (kthread+0x84/0x90) from [<c0014130>] (kernel_thread_exit+0x0/0x8)
[  151.450561] BUG: scheduling while atomic: kworker/0:1/425/0x00000200
[  151.457580] 9 locks held by kworker/0:1/425:
[  151.457580]  #0:  (events){.+.+.+}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  151.465515]  #1:  ((&rdev->conn_work)){+.+.+.}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  151.479003]  #2:  (rtnl_mutex){+.+.+.}, at: [<bf0199d0>] cfg80211_conn_work+0x18/0x13c [cfg80211]
[  151.488494]  #3:  (&rdev->mtx){+.+.+.}, at: [<bf0199e0>] cfg80211_conn_work+0x28/0x13c [cfg80211]
[  151.488494]  #4:  (&rdev->devlist_mtx){+.+.+.}, at: [<bf0199ec>] cfg80211_conn_work+0x34/0x13c [cfg80]
[  151.497924]  #5:  (&wdev->mtx){+.+.+.}, at: [<bf019a34>] cfg80211_conn_work+0x7c/0x13c [cfg80211]
[  151.517486]  #6:  (&ifmgd->mtx){+.+.+.}, at: [<bf073620>] ieee80211_mgd_auth+0xc4/0x3b0 [mac80211]
[  151.527130]  #7:  (rcu_read_lock){.+.+.+}, at: [<bf059f4c>] ieee80211_xmit+0x0/0x150 [mac80211]
[  151.528991]  #8:  (rcu_read_lock){.+.+.+}, at: [<bf059e7c>] ieee80211_tx+0x24/0xf4 [mac80211]
[  151.528991] Modules linked in: arc4 wl12xx_sdio wl12xx mac80211 cfg80211
[  151.552673] [<c001a330>] (unwind_backtrace+0x0/0xf0) from [<c0430c38>] (__schedule+0x730/0x7b4)
[  151.561828] [<c0430c38>] (__schedule+0x730/0x7b4) from [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8)
[  151.561828] [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8) from [<c04303c0>] (wait_for_common+0xac/0x150)
[  151.581024] [<c04303c0>] (wait_for_common+0xac/0x150) from [<c033bd24>] (mmc_wait_for_req_done+0x1c/0)
[  151.591094] [<c033bd24>] (mmc_wait_for_req_done+0x1c/0x74) from [<c03448e0>] (mmc_io_rw_extended+0x15)
[  151.591094] [<c03448e0>] (mmc_io_rw_extended+0x15c/0x1f8) from [<c0345a78>] (sdio_io_rw_ext_helper+0x)
[  151.612121] [<c0345a78>] (sdio_io_rw_ext_helper+0x154/0x1d4) from [<c0345b64>] (sdio_memcpy_toio+0x20)
[  151.622375] [<c0345b64>] (sdio_memcpy_toio+0x20/0x28) from [<bf0f2170>] (wl12xx_sdio_raw_write+0x50/0)
[  151.633758] [<bf0f2170>] (wl12xx_sdio_raw_write+0x50/0xa4 [wl12xx_sdio]) from [<bf0c7164>] (wl1271_cm)
[  151.645904] [<bf0c7164>] (wl1271_cmd_send+0xd8/0x3b4 [wl12xx]) from [<bf0c98f4>] (wl12xx_start_dev+0x)
[  151.657379] [<bf0c98f4>] (wl12xx_start_dev+0x90/0x144 [wl12xx]) from [<bf0cab2c>] (wl12xx_tx_get_hlid)
[  151.668884] [<bf0cab2c>] (wl12xx_tx_get_hlid+0xc8/0xcc [wl12xx]) from [<bf0c36c4>] (wl1271_op_tx+0x44)
[  151.680084] [<bf0c36c4>] (wl1271_op_tx+0x44/0x150 [wl12xx]) from [<bf059ce8>] (__ieee80211_tx.isra.4+)
[  151.680267] [<bf059ce8>] (__ieee80211_tx.isra.4+0x150/0x2c0 [mac80211]) from [<bf059f18>] (ieee80211_)
[  151.704132] [<bf059f18>] (ieee80211_tx+0xc0/0xf4 [mac80211]) from [<bf05a008>] (ieee80211_xmit+0xbc/0)
[  151.715515] [<bf05a008>] (ieee80211_xmit+0xbc/0x150 [mac80211]) from [<bf05b2a8>] (ieee80211_tx_skb_t)
[  151.727630] [<bf05b2a8>] (ieee80211_tx_skb_tid+0x3c/0x48 [mac80211]) from [<bf06f998>] (ieee80211_pro)
[  151.740447] [<bf06f998>] (ieee80211_probe_auth+0x128/0x2f8 [mac80211]) from [<bf073774>] (ieee80211_m)
[  151.740447] [<bf073774>] (ieee80211_mgd_auth+0x218/0x3b0 [mac80211]) from [<bf016e94>] (__cfg80211_ml)
[  151.766052] [<bf016e94>] (__cfg80211_mlme_auth+0xec/0x160 [cfg80211]) from [<bf018e1c>] (cfg80211_con)
[  151.778869] [<bf018e1c>] (cfg80211_conn_do_work+0x14c/0x218 [cfg80211]) from [<bf019a78>] (cfg80211_c)
[  151.791473] [<bf019a78>] (cfg80211_conn_work+0xc0/0x13c [cfg80211]) from [<c0057da0>] (process_one_wo)
[  151.791473] [<c0057da0>] (process_one_work+0x188/0x508) from [<c00584d0>] (worker_thread+0x170/0x370)
[  151.812225] [<c00584d0>] (worker_thread+0x170/0x370) from [<c005d080>] (kthread+0x84/0x90)
[  151.820922] [<c005d080>] (kthread+0x84/0x90) from [<c0014130>] (kernel_thread_exit+0x0/0x8)
[  151.830627] BUG: scheduling while atomic: kworker/0:1/425/0x00000200
[  151.837310] 9 locks held by kworker/0:1/425:
[  151.841796]  #0:  (events){.+.+.+}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  151.849731]  #1:  ((&rdev->conn_work)){+.+.+.}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  151.854797]  #2:  (rtnl_mutex){+.+.+.}, at: [<bf0199d0>] cfg80211_conn_work+0x18/0x13c [cfg80211]
[  151.854797]  #3:  (&rdev->mtx){+.+.+.}, at: [<bf0199e0>] cfg80211_conn_work+0x28/0x13c [cfg80211]
[  151.877593]  #4:  (&rdev->devlist_mtx){+.+.+.}, at: [<bf0199ec>] cfg80211_conn_work+0x34/0x13c [cfg80]
[  151.877624]  #5:  (&wdev->mtx){+.+.+.}, at: [<bf019a34>] cfg80211_conn_work+0x7c/0x13c [cfg80211]
[  151.877624]  #6:  (&ifmgd->mtx){+.+.+.}, at: [<bf073620>] ieee80211_mgd_auth+0xc4/0x3b0 [mac80211]
[  151.906799]  #7:  (rcu_read_lock){.+.+.+}, at: [<bf059f4c>] ieee80211_xmit+0x0/0x150 [mac80211]
[  151.910034]  #8:  (rcu_read_lock){.+.+.+}, at: [<bf059e7c>] ieee80211_tx+0x24/0xf4 [mac80211]
[  151.925231] Modules linked in: arc4 wl12xx_sdio wl12xx mac80211 cfg80211
[  151.925231] [<c001a330>] (unwind_backtrace+0x0/0xf0) from [<c0430c38>] (__schedule+0x730/0x7b4)
[  151.941497] [<c0430c38>] (__schedule+0x730/0x7b4) from [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8)
[  151.950927] [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8) from [<c04303c0>] (wait_for_common+0xac/0x150)
[  151.960723] [<c04303c0>] (wait_for_common+0xac/0x150) from [<c033bd24>] (mmc_wait_for_req_done+0x1c/0)
[  151.970794] [<c033bd24>] (mmc_wait_for_req_done+0x1c/0x74) from [<c03448e0>] (mmc_io_rw_extended+0x15)
[  151.981201] [<c03448e0>] (mmc_io_rw_extended+0x15c/0x1f8) from [<c0345a78>] (sdio_io_rw_ext_helper+0x)
[  151.991821] [<c0345a78>] (sdio_io_rw_ext_helper+0x154/0x1d4) from [<c0345b64>] (sdio_memcpy_toio+0x20)
[  152.002044] [<c0345b64>] (sdio_memcpy_toio+0x20/0x28) from [<bf0f2170>] (wl12xx_sdio_raw_write+0x50/0)
[  152.002044] [<bf0f2170>] (wl12xx_sdio_raw_write+0x50/0xa4 [wl12xx_sdio]) from [<bf0c7164>] (wl1271_cm)
[  152.025604] [<bf0c7164>] (wl1271_cmd_send+0xd8/0x3b4 [wl12xx]) from [<bf0c98f4>] (wl12xx_start_dev+0x)
[  152.037017] [<bf0c98f4>] (wl12xx_start_dev+0x90/0x144 [wl12xx]) from [<bf0cab2c>] (wl12xx_tx_get_hlid)
[  152.048583] [<bf0cab2c>] (wl12xx_tx_get_hlid+0xc8/0xcc [wl12xx]) from [<bf0c36c4>] (wl1271_op_tx+0x44)
[  152.059814] [<bf0c36c4>] (wl1271_op_tx+0x44/0x150 [wl12xx]) from [<bf059ce8>] (__ieee80211_tx.isra.4+)
[  152.071990] [<bf059ce8>] (__ieee80211_tx.isra.4+0x150/0x2c0 [mac80211]) from [<bf059f18>] (ieee80211_)
[  152.083862] [<bf059f18>] (ieee80211_tx+0xc0/0xf4 [mac80211]) from [<bf05a008>] (ieee80211_xmit+0xbc/0)
[  152.095275] [<bf05a008>] (ieee80211_xmit+0xbc/0x150 [mac80211]) from [<bf05b2a8>] (ieee80211_tx_skb_t)
[  152.107391] [<bf05b2a8>] (ieee80211_tx_skb_tid+0x3c/0x48 [mac80211]) from [<bf06f998>] (ieee80211_pro)
[  152.107391] [<bf06f998>] (ieee80211_probe_auth+0x128/0x2f8 [mac80211]) from [<bf073774>] (ieee80211_m)
[  152.132995] [<bf073774>] (ieee80211_mgd_auth+0x218/0x3b0 [mac80211]) from [<bf016e94>] (__cfg80211_ml)
[  152.145660] [<bf016e94>] (__cfg80211_mlme_auth+0xec/0x160 [cfg80211]) from [<bf018e1c>] (cfg80211_con)
[  152.158477] [<bf018e1c>] (cfg80211_conn_do_work+0x14c/0x218 [cfg80211]) from [<bf019a78>] (cfg80211_c)
[  152.171203] [<bf019a78>] (cfg80211_conn_work+0xc0/0x13c [cfg80211]) from [<c0057da0>] (process_one_wo)
[  152.182281] [<c0057da0>] (process_one_work+0x188/0x508) from [<c00584d0>] (worker_thread+0x170/0x370)
[  152.191986] [<c00584d0>] (worker_thread+0x170/0x370) from [<c005d080>] (kthread+0x84/0x90)
[  152.200683] [<c005d080>] (kthread+0x84/0x90) from [<c0014130>] (kernel_thread_exit+0x0/0x8)
[  152.211700] BUG: scheduling while atomic: kworker/0:1/425/0x00000200
[  152.218658] 9 locks held by kworker/0:1/425:
[  152.223144]  #0:  (events){.+.+.+}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  152.231079]  #1:  ((&rdev->conn_work)){+.+.+.}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  152.231109]  #2:  (rtnl_mutex){+.+.+.}, at: [<bf0199d0>] cfg80211_conn_work+0x18/0x13c [cfg80211]
[  152.231109]  #3:  (&rdev->mtx){+.+.+.}, at: [<bf0199e0>] cfg80211_conn_work+0x28/0x13c [cfg80211]
[  152.258941]  #4:  (&rdev->devlist_mtx){+.+.+.}, at: [<bf0199ec>] cfg80211_conn_work+0x34/0x13c [cfg80]
[  152.258972]  #5:  (&wdev->mtx){+.+.+.}, at: [<bf019a34>] cfg80211_conn_work+0x7c/0x13c [cfg80211]
[  152.278564]  #6:  (&ifmgd->mtx){+.+.+.}, at: [<bf073620>] ieee80211_mgd_auth+0xc4/0x3b0 [mac80211]
[  152.288177]  #7:  (rcu_read_lock){.+.+.+}, at: [<bf059f4c>] ieee80211_xmit+0x0/0x150 [mac80211]
[  152.292236]  #8:  (rcu_read_lock){.+.+.+}, at: [<bf059e7c>] ieee80211_tx+0x24/0xf4 [mac80211]
[  152.299530] Modules linked in: arc4 wl12xx_sdio wl12xx mac80211 cfg80211
[  152.313720] [<c001a330>] (unwind_backtrace+0x0/0xf0) from [<c0430c38>] (__schedule+0x730/0x7b4)
[  152.322875] [<c0430c38>] (__schedule+0x730/0x7b4) from [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8)
[  152.332305] [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8) from [<c04303c0>] (wait_for_common+0xac/0x150)
[  152.342102] [<c04303c0>] (wait_for_common+0xac/0x150) from [<c033bd24>] (mmc_wait_for_req_done+0x1c/0)
[  152.352172] [<c033bd24>] (mmc_wait_for_req_done+0x1c/0x74) from [<c03448e0>] (mmc_io_rw_extended+0x15)
[  152.362579] [<c03448e0>] (mmc_io_rw_extended+0x15c/0x1f8) from [<c0345a78>] (sdio_io_rw_ext_helper+0x)
[  152.373199] [<c0345a78>] (sdio_io_rw_ext_helper+0x154/0x1d4) from [<c0345bdc>] (sdio_memcpy_fromio+0x)
[  152.383605] [<c0345bdc>] (sdio_memcpy_fromio+0x18/0x20) from [<bf0f2214>] (wl12xx_sdio_raw_read+0x50/)
[  152.395019] [<bf0f2214>] (wl12xx_sdio_raw_read+0x50/0xa4 [wl12xx_sdio]) from [<bf0c71c4>] (wl1271_cmd)
[  152.407318] [<bf0c71c4>] (wl1271_cmd_send+0x138/0x3b4 [wl12xx]) from [<bf0c98f4>] (wl12xx_start_dev+0)
[  152.418731] [<bf0c98f4>] (wl12xx_start_dev+0x90/0x144 [wl12xx]) from [<bf0cab2c>] (wl12xx_tx_get_hlid)
[  152.430297] [<bf0cab2c>] (wl12xx_tx_get_hlid+0xc8/0xcc [wl12xx]) from [<bf0c36c4>] (wl1271_op_tx+0x44)
[  152.430389] [<bf0c36c4>] (wl1271_op_tx+0x44/0x150 [wl12xx]) from [<bf059ce8>] (__ieee80211_tx.isra.4+)
[  152.453704] [<bf059ce8>] (__ieee80211_tx.isra.4+0x150/0x2c0 [mac80211]) from [<bf059f18>] (ieee80211_)
[  152.465820] [<bf059f18>] (ieee80211_tx+0xc0/0xf4 [mac80211]) from [<bf05a008>] (ieee80211_xmit+0xbc/0)
[  152.476959] [<bf05a008>] (ieee80211_xmit+0xbc/0x150 [mac80211]) from [<bf05b2a8>] (ieee80211_tx_skb_t)
[  152.489074] [<bf05b2a8>] (ieee80211_tx_skb_tid+0x3c/0x48 [mac80211]) from [<bf06f998>] (ieee80211_pro)
[  152.501861] [<bf06f998>] (ieee80211_probe_auth+0x128/0x2f8 [mac80211]) from [<bf073774>] (ieee80211_m)
[  152.502197] [<bf073774>] (ieee80211_mgd_auth+0x218/0x3b0 [mac80211]) from [<bf016e94>] (__cfg80211_ml)
[  152.527496] [<bf016e94>] (__cfg80211_mlme_auth+0xec/0x160 [cfg80211]) from [<bf018e1c>] (cfg80211_con)
[  152.527496] [<bf018e1c>] (cfg80211_conn_do_work+0x14c/0x218 [cfg80211]) from [<bf019a78>] (cfg80211_c)
[  152.552795] [<bf019a78>] (cfg80211_conn_work+0xc0/0x13c [cfg80211]) from [<c0057da0>] (process_one_wo)
[  152.563964] [<c0057da0>] (process_one_work+0x188/0x508) from [<c00584d0>] (worker_thread+0x170/0x370)
[  152.573669] [<c00584d0>] (worker_thread+0x170/0x370) from [<c005d080>] (kthread+0x84/0x90)
[  152.582366] [<c005d080>] (kthread+0x84/0x90) from [<c0014130>] (kernel_thread_exit+0x0/0x8)
[  152.591827] BUG: scheduling while atomic: kworker/0:1/425/0x00000200
[  152.598510] 9 locks held by kworker/0:1/425:
[  152.598510]  #0:  (events){.+.+.+}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  152.610900]  #1:  ((&rdev->conn_work)){+.+.+.}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  152.614593]  #2:  (rtnl_mutex){+.+.+.}, at: [<bf0199d0>] cfg80211_conn_work+0x18/0x13c [cfg80211]
[  152.629364]  #3:  (&rdev->mtx){+.+.+.}, at: [<bf0199e0>] cfg80211_conn_work+0x28/0x13c [cfg80211]
[  152.638793]  #4:  (&rdev->devlist_mtx){+.+.+.}, at: [<bf0199ec>] cfg80211_conn_work+0x34/0x13c [cfg80]
[  152.648956]  #5:  (&wdev->mtx){+.+.+.}, at: [<bf019a34>] cfg80211_conn_work+0x7c/0x13c [cfg80211]
[  152.648956]  #6:  (&ifmgd->mtx){+.+.+.}, at: [<bf073620>] ieee80211_mgd_auth+0xc4/0x3b0 [mac80211]
[  152.662261]  #7:  (rcu_read_lock){.+.+.+}, at: [<bf059f4c>] ieee80211_xmit+0x0/0x150 [mac80211]
[  152.677337]  #8:  (rcu_read_lock){.+.+.+}, at: [<bf059e7c>] ieee80211_tx+0x24/0xf4 [mac80211]
[  152.686462] Modules linked in: arc4 wl12xx_sdio wl12xx mac80211 cfg80211
[  152.691711] [<c001a330>] (unwind_backtrace+0x0/0xf0) from [<c0430c38>] (__schedule+0x730/0x7b4)
[  152.702728] [<c0430c38>] (__schedule+0x730/0x7b4) from [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8)
[  152.712158] [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8) from [<c04303c0>] (wait_for_common+0xac/0x150)
[  152.721923] [<c04303c0>] (wait_for_common+0xac/0x150) from [<c033bd24>] (mmc_wait_for_req_done+0x1c/0)
[  152.731994] [<c033bd24>] (mmc_wait_for_req_done+0x1c/0x74) from [<c03448e0>] (mmc_io_rw_extended+0x15)
[  152.742431] [<c03448e0>] (mmc_io_rw_extended+0x15c/0x1f8) from [<c0345a78>] (sdio_io_rw_ext_helper+0x)
[  152.753051] [<c0345a78>] (sdio_io_rw_ext_helper+0x154/0x1d4) from [<c0345bdc>] (sdio_memcpy_fromio+0x)
[  152.763458] [<c0345bdc>] (sdio_memcpy_fromio+0x18/0x20) from [<bf0f2214>] (wl12xx_sdio_raw_read+0x50/)
[  152.774871] [<bf0f2214>] (wl12xx_sdio_raw_read+0x50/0xa4 [wl12xx_sdio]) from [<bf0c71c4>] (wl1271_cmd)
[  152.787170] [<bf0c71c4>] (wl1271_cmd_send+0x138/0x3b4 [wl12xx]) from [<bf0c98f4>] (wl12xx_start_dev+0)
[  152.798645] [<bf0c98f4>] (wl12xx_start_dev+0x90/0x144 [wl12xx]) from [<bf0cab2c>] (wl12xx_tx_get_hlid)
[  152.810150] [<bf0cab2c>] (wl12xx_tx_get_hlid+0xc8/0xcc [wl12xx]) from [<bf0c36c4>] (wl1271_op_tx+0x44)
[  152.821380] [<bf0c36c4>] (wl1271_op_tx+0x44/0x150 [wl12xx]) from [<bf059ce8>] (__ieee80211_tx.isra.4+)
[  152.833312] [<bf059ce8>] (__ieee80211_tx.isra.4+0x150/0x2c0 [mac80211]) from [<bf059f18>] (ieee80211_)
[  152.845428] [<bf059f18>] (ieee80211_tx+0xc0/0xf4 [mac80211]) from [<bf05a008>] (ieee80211_xmit+0xbc/0)
[  152.857025] [<bf05a008>] (ieee80211_xmit+0xbc/0x150 [mac80211]) from [<bf05b2a8>] (ieee80211_tx_skb_t)
[  152.868896] [<bf05b2a8>] (ieee80211_tx_skb_tid+0x3c/0x48 [mac80211]) from [<bf06f998>] (ieee80211_pro)
[  152.882019] [<bf06f998>] (ieee80211_probe_auth+0x128/0x2f8 [mac80211]) from [<bf073774>] (ieee80211_m)
[  152.882019] [<bf073774>] (ieee80211_mgd_auth+0x218/0x3b0 [mac80211]) from [<bf016e94>] (__cfg80211_ml)
[  152.907318] [<bf016e94>] (__cfg80211_mlme_auth+0xec/0x160 [cfg80211]) from [<bf018e1c>] (cfg80211_con)
[  152.907318] [<bf018e1c>] (cfg80211_conn_do_work+0x14c/0x218 [cfg80211]) from [<bf019a78>] (cfg80211_c)
[  152.932647] [<bf019a78>] (cfg80211_conn_work+0xc0/0x13c [cfg80211]) from [<c0057da0>] (process_one_wo)
[  152.943786] [<c0057da0>] (process_one_work+0x188/0x508) from [<c00584d0>] (worker_thread+0x170/0x370)
[  152.953491] [<c00584d0>] (worker_thread+0x170/0x370) from [<c005d080>] (kthread+0x84/0x90)
[  152.962158] [<c005d080>] (kthread+0x84/0x90) from [<c0014130>] (kernel_thread_exit+0x0/0x8)
[  152.970977] sched: RT throttling activated
[  152.976654] BUG: scheduling while atomic: kworker/0:1/425/0x00000200
[  152.983459] 9 locks held by kworker/0:1/425:
[  152.983703]  #0:  (events){.+.+.+}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  152.991607]  #1:  ((&rdev->conn_work)){+.+.+.}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  153.005126]  #2:  (rtnl_mutex){+.+.+.}, at: [<bf0199d0>] cfg80211_conn_work+0x18/0x13c [cfg80211]
[  153.005126]  #3:  (&rdev->mtx){+.+.+.}, at: [<bf0199e0>] cfg80211_conn_work+0x28/0x13c [cfg80211]
[  153.024414]  #4:  (&rdev->devlist_mtx){+.+.+.}, at: [<bf0199ec>] cfg80211_conn_work+0x34/0x13c [cfg80]
[  153.034606]  #5:  (&wdev->mtx){+.+.+.}, at: [<bf019a34>] cfg80211_conn_work+0x7c/0x13c [cfg80211]
[  153.034606]  #6:  (&ifmgd->mtx){+.+.+.}, at: [<bf073620>] ieee80211_mgd_auth+0xc4/0x3b0 [mac80211]
[  153.053649]  #7:  (rcu_read_lock){.+.+.+}, at: [<bf059f4c>] ieee80211_xmit+0x0/0x150 [mac80211]
[  153.057708]  #8:  (rcu_read_lock){.+.+.+}, at: [<bf059e7c>] ieee80211_tx+0x24/0xf4 [mac80211]
[  153.066192] Modules linked in: arc4 wl12xx_sdio wl12xx mac80211 cfg80211
[  153.079193] [<c001a330>] (unwind_backtrace+0x0/0xf0) from [<c0430c38>] (__schedule+0x730/0x7b4)
[  153.088348] [<c0430c38>] (__schedule+0x730/0x7b4) from [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8)
[  153.097778] [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8) from [<c04303c0>] (wait_for_common+0xac/0x150)
[  153.107574] [<c04303c0>] (wait_for_common+0xac/0x150) from [<c033bd24>] (mmc_wait_for_req_done+0x1c/0)
[  153.117645] [<c033bd24>] (mmc_wait_for_req_done+0x1c/0x74) from [<c03448e0>] (mmc_io_rw_extended+0x15)
[  153.128082] [<c03448e0>] (mmc_io_rw_extended+0x15c/0x1f8) from [<c0345a78>] (sdio_io_rw_ext_helper+0x)
[  153.138671] [<c0345a78>] (sdio_io_rw_ext_helper+0x154/0x1d4) from [<c0345bdc>] (sdio_memcpy_fromio+0x)
[  153.149108] [<c0345bdc>] (sdio_memcpy_fromio+0x18/0x20) from [<bf0f2214>] (wl12xx_sdio_raw_read+0x50/)
[  153.149108] [<bf0f2214>] (wl12xx_sdio_raw_read+0x50/0xa4 [wl12xx_sdio]) from [<bf0c7244>] (wl1271_cmd)
[  153.172790] [<bf0c7244>] (wl1271_cmd_send+0x1b8/0x3b4 [wl12xx]) from [<bf0c98f4>] (wl12xx_start_dev+0)
[  153.184295] [<bf0c98f4>] (wl12xx_start_dev+0x90/0x144 [wl12xx]) from [<bf0cab2c>] (wl12xx_tx_get_hlid)
[  153.184295] [<bf0cab2c>] (wl12xx_tx_get_hlid+0xc8/0xcc [wl12xx]) from [<bf0c36c4>] (wl1271_op_tx+0x44)
[  153.207000] [<bf0c36c4>] (wl1271_op_tx+0x44/0x150 [wl12xx]) from [<bf059ce8>] (__ieee80211_tx.isra.4+)
[  153.207183] [<bf059ce8>] (__ieee80211_tx.isra.4+0x150/0x2c0 [mac80211]) from [<bf059f18>] (ieee80211_)
[  153.231048] [<bf059f18>] (ieee80211_tx+0xc0/0xf4 [mac80211]) from [<bf05a008>] (ieee80211_xmit+0xbc/0)
[  153.242675] [<bf05a008>] (ieee80211_xmit+0xbc/0x150 [mac80211]) from [<bf05b2a8>] (ieee80211_tx_skb_t)
[  153.254547] [<bf05b2a8>] (ieee80211_tx_skb_tid+0x3c/0x48 [mac80211]) from [<bf06f998>] (ieee80211_pro)
[  153.267669] [<bf06f998>] (ieee80211_probe_auth+0x128/0x2f8 [mac80211]) from [<bf073774>] (ieee80211_m)
[  153.267669] [<bf073774>] (ieee80211_mgd_auth+0x218/0x3b0 [mac80211]) from [<bf016e94>] (__cfg80211_ml)
[  153.292968] [<bf016e94>] (__cfg80211_mlme_auth+0xec/0x160 [cfg80211]) from [<bf018e1c>] (cfg80211_con)
[  153.305786] [<bf018e1c>] (cfg80211_conn_do_work+0x14c/0x218 [cfg80211]) from [<bf019a78>] (cfg80211_c)
[  153.318389] [<bf019a78>] (cfg80211_conn_work+0xc0/0x13c [cfg80211]) from [<c0057da0>] (process_one_wo)
[  153.329467] [<c0057da0>] (process_one_work+0x188/0x508) from [<c00584d0>] (worker_thread+0x170/0x370)
[  153.329467] [<c00584d0>] (worker_thread+0x170/0x370) from [<c005d080>] (kthread+0x84/0x90)
[  153.347869] [<c005d080>] (kthread+0x84/0x90) from [<c0014130>] (kernel_thread_exit+0x0/0x8)
[  153.357299] BUG: scheduling while atomic: kworker/0:1/425/0x00000200
[  153.364013] 9 locks held by kworker/0:1/425:
[  153.364013]  #0:  (events){.+.+.+}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  153.364013]  #1:  ((&rdev->conn_work)){+.+.+.}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  153.385406]  #2:  (rtnl_mutex){+.+.+.}, at: [<bf0199d0>] cfg80211_conn_work+0x18/0x13c [cfg80211]
[  153.394866]  #3:  (&rdev->mtx){+.+.+.}, at: [<bf0199e0>] cfg80211_conn_work+0x28/0x13c [cfg80211]
[  153.404296]  #4:  (&rdev->devlist_mtx){+.+.+.}, at: [<bf0199ec>] cfg80211_conn_work+0x34/0x13c [cfg80]
[  153.414459]  #5:  (&wdev->mtx){+.+.+.}, at: [<bf019a34>] cfg80211_conn_work+0x7c/0x13c [cfg80211]
[  153.423889]  #6:  (&ifmgd->mtx){+.+.+.}, at: [<bf073620>] ieee80211_mgd_auth+0xc4/0x3b0 [mac80211]
[  153.433532]  #7:  (rcu_read_lock){.+.+.+}, at: [<bf059f4c>] ieee80211_xmit+0x0/0x150 [mac80211]
[  153.438140]  #8:  (rcu_read_lock){.+.+.+}, at: [<bf059e7c>] ieee80211_tx+0x24/0xf4 [mac80211]
[  153.451995] Modules linked in: arc4 wl12xx_sdio wl12xx mac80211 cfg80211
[  153.451995] [<c001a330>] (unwind_backtrace+0x0/0xf0) from [<c0430c38>] (__schedule+0x730/0x7b4)
[  153.468231] [<c0430c38>] (__schedule+0x730/0x7b4) from [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8)
[  153.477661] [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8) from [<c04303c0>] (wait_for_common+0xac/0x150)
[  153.487457] [<c04303c0>] (wait_for_common+0xac/0x150) from [<c033bd24>] (mmc_wait_for_req_done+0x1c/0)
[  153.497528] [<c033bd24>] (mmc_wait_for_req_done+0x1c/0x74) from [<c03448e0>] (mmc_io_rw_extended+0x15)
[  153.507934] [<c03448e0>] (mmc_io_rw_extended+0x15c/0x1f8) from [<c0345a78>] (sdio_io_rw_ext_helper+0x)
[  153.518554] [<c0345a78>] (sdio_io_rw_ext_helper+0x154/0x1d4) from [<c0345bdc>] (sdio_memcpy_fromio+0x)
[  153.528991] [<c0345bdc>] (sdio_memcpy_fromio+0x18/0x20) from [<bf0f2214>] (wl12xx_sdio_raw_read+0x50/)
[  153.540405] [<bf0f2214>] (wl12xx_sdio_raw_read+0x50/0xa4 [wl12xx_sdio]) from [<bf0c7244>] (wl1271_cmd)
[  153.552703] [<bf0c7244>] (wl1271_cmd_send+0x1b8/0x3b4 [wl12xx]) from [<bf0c98f4>] (wl12xx_start_dev+0)
[  153.564117] [<bf0c98f4>] (wl12xx_start_dev+0x90/0x144 [wl12xx]) from [<bf0cab2c>] (wl12xx_tx_get_hlid)
[  153.564208] [<bf0cab2c>] (wl12xx_tx_get_hlid+0xc8/0xcc [wl12xx]) from [<bf0c36c4>] (wl1271_op_tx+0x44)
[  153.564208] [<bf0c36c4>] (wl1271_op_tx+0x44/0x150 [wl12xx]) from [<bf059ce8>] (__ieee80211_tx.isra.4+)
[  153.598846] [<bf059ce8>] (__ieee80211_tx.isra.4+0x150/0x2c0 [mac80211]) from [<bf059f18>] (ieee80211_)
[  153.611175] [<bf059f18>] (ieee80211_tx+0xc0/0xf4 [mac80211]) from [<bf05a008>] (ieee80211_xmit+0xbc/0)
[  153.622314] [<bf05a008>] (ieee80211_xmit+0xbc/0x150 [mac80211]) from [<bf05b2a8>] (ieee80211_tx_skb_t)
[  153.634429] [<bf05b2a8>] (ieee80211_tx_skb_tid+0x3c/0x48 [mac80211]) from [<bf06f998>] (ieee80211_pro)
[  153.647216] [<bf06f998>] (ieee80211_probe_auth+0x128/0x2f8 [mac80211]) from [<bf073774>] (ieee80211_m)
[  153.660034] [<bf073774>] (ieee80211_mgd_auth+0x218/0x3b0 [mac80211]) from [<bf016e94>] (__cfg80211_ml)
[  153.672851] [<bf016e94>] (__cfg80211_mlme_auth+0xec/0x160 [cfg80211]) from [<bf018e1c>] (cfg80211_con)
[  153.685546] [<bf018e1c>] (cfg80211_conn_do_work+0x14c/0x218 [cfg80211]) from [<bf019a78>] (cfg80211_c)
[  153.698272] [<bf019a78>] (cfg80211_conn_work+0xc0/0x13c [cfg80211]) from [<c0057da0>] (process_one_wo)
[  153.709350] [<c0057da0>] (process_one_work+0x188/0x508) from [<c00584d0>] (worker_thread+0x170/0x370)
[  153.709350] [<c00584d0>] (worker_thread+0x170/0x370) from [<c005d080>] (kthread+0x84/0x90)
[  153.727722] [<c005d080>] (kthread+0x84/0x90) from [<c0014130>] (kernel_thread_exit+0x0/0x8)
[  153.739257] BUG: scheduling while atomic: kworker/0:1/425/0x00000200
[  153.746093] 9 locks held by kworker/0:1/425:
[  153.750579]  #0:  (events){.+.+.+}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  153.758514]  #1:  ((&rdev->conn_work)){+.+.+.}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  153.763031]  #2:  (rtnl_mutex){+.+.+.}, at: [<bf0199d0>] cfg80211_conn_work+0x18/0x13c [cfg80211]
[  153.776977]  #3:  (&rdev->mtx){+.+.+.}, at: [<bf0199e0>] cfg80211_conn_work+0x28/0x13c [cfg80211]
[  153.786407]  #4:  (&rdev->devlist_mtx){+.+.+.}, at: [<bf0199ec>] cfg80211_conn_work+0x34/0x13c [cfg80]
[  153.796569]  #5:  (&wdev->mtx){+.+.+.}, at: [<bf019a34>] cfg80211_conn_work+0x7c/0x13c [cfg80211]
[  153.805999]  #6:  (&ifmgd->mtx){+.+.+.}, at: [<bf073620>] ieee80211_mgd_auth+0xc4/0x3b0 [mac80211]
[  153.815643]  #7:  (rcu_read_lock){.+.+.+}, at: [<bf059f4c>] ieee80211_xmit+0x0/0x150 [mac80211]
[  153.815643]  #8:  (rcu_read_lock){.+.+.+}, at: [<bf059e7c>] ieee80211_tx+0x24/0xf4 [mac80211]
[  153.824951] Modules linked in: arc4 wl12xx_sdio wl12xx mac80211 cfg80211
[  153.840454] [<c001a330>] (unwind_backtrace+0x0/0xf0) from [<c0430c38>] (__schedule+0x730/0x7b4)
[  153.840454] [<c0430c38>] (__schedule+0x730/0x7b4) from [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8)
[  153.860046] [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8) from [<c04303c0>] (wait_for_common+0xac/0x150)
[  153.869842] [<c04303c0>] (wait_for_common+0xac/0x150) from [<c033bd24>] (mmc_wait_for_req_done+0x1c/0)
[  153.879913] [<c033bd24>] (mmc_wait_for_req_done+0x1c/0x74) from [<c03448e0>] (mmc_io_rw_extended+0x15)
[  153.890350] [<c03448e0>] (mmc_io_rw_extended+0x15c/0x1f8) from [<c0345a78>] (sdio_io_rw_ext_helper+0x)
[  153.900939] [<c0345a78>] (sdio_io_rw_ext_helper+0x154/0x1d4) from [<c0345bdc>] (sdio_memcpy_fromio+0x)
[  153.911346] [<c0345bdc>] (sdio_memcpy_fromio+0x18/0x20) from [<bf0f2214>] (wl12xx_sdio_raw_read+0x50/)
[  153.911346] [<bf0f2214>] (wl12xx_sdio_raw_read+0x50/0xa4 [wl12xx_sdio]) from [<bf0c7244>] (wl1271_cmd)
[  153.935058] [<bf0c7244>] (wl1271_cmd_send+0x1b8/0x3b4 [wl12xx]) from [<bf0c98f4>] (wl12xx_start_dev+0)
[  153.946472] [<bf0c98f4>] (wl12xx_start_dev+0x90/0x144 [wl12xx]) from [<bf0cab2c>] (wl12xx_tx_get_hlid)
[  153.958038] [<bf0cab2c>] (wl12xx_tx_get_hlid+0xc8/0xcc [wl12xx]) from [<bf0c36c4>] (wl1271_op_tx+0x44)
[  153.969421] [<bf0c36c4>] (wl1271_op_tx+0x44/0x150 [wl12xx]) from [<bf059ce8>] (__ieee80211_tx.isra.4+)
[  153.969421] [<bf059ce8>] (__ieee80211_tx.isra.4+0x150/0x2c0 [mac80211]) from [<bf059f18>] (ieee80211_)
[  153.993286] [<bf059f18>] (ieee80211_tx+0xc0/0xf4 [mac80211]) from [<bf05a008>] (ieee80211_xmit+0xbc/0)
[  154.004669] [<bf05a008>] (ieee80211_xmit+0xbc/0x150 [mac80211]) from [<bf05b2a8>] (ieee80211_tx_skb_t)
[  154.016815] [<bf05b2a8>] (ieee80211_tx_skb_tid+0x3c/0x48 [mac80211]) from [<bf06f998>] (ieee80211_pro)
[  154.029602] [<bf06f998>] (ieee80211_probe_auth+0x128/0x2f8 [mac80211]) from [<bf073774>] (ieee80211_m)
[  154.042663] [<bf073774>] (ieee80211_mgd_auth+0x218/0x3b0 [mac80211]) from [<bf016e94>] (__cfg80211_ml)
[  154.055084] [<bf016e94>] (__cfg80211_mlme_auth+0xec/0x160 [cfg80211]) from [<bf018e1c>] (cfg80211_con)
[  154.068054] [<bf018e1c>] (cfg80211_conn_do_work+0x14c/0x218 [cfg80211]) from [<bf019a78>] (cfg80211_c)
[  154.080627] [<bf019a78>] (cfg80211_conn_work+0xc0/0x13c [cfg80211]) from [<c0057da0>] (process_one_wo)
[  154.091705] [<c0057da0>] (process_one_work+0x188/0x508) from [<c00584d0>] (worker_thread+0x170/0x370)
[  154.091705] [<c00584d0>] (worker_thread+0x170/0x370) from [<c005d080>] (kthread+0x84/0x90)
[  154.110076] [<c005d080>] (kthread+0x84/0x90) from [<c0014130>] (kernel_thread_exit+0x0/0x8)
[  154.118865] BUG: scheduling while atomic: kworker/0:1/425/0x00000200
[  154.118865] 9 locks held by kworker/0:1/425:
[  154.118865]  #0:  (events){.+.+.+}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  154.134094]  #1:  ((&rdev->conn_work)){+.+.+.}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  154.147613]  #2:  (rtnl_mutex){+.+.+.}, at: [<bf0199d0>] cfg80211_conn_work+0x18/0x13c [cfg80211]
[  154.157073]  #3:  (&rdev->mtx){+.+.+.}, at: [<bf0199e0>] cfg80211_conn_work+0x28/0x13c [cfg80211]
[  154.160858]  #4:  (&rdev->devlist_mtx){+.+.+.}, at: [<bf0199ec>] cfg80211_conn_work+0x34/0x13c [cfg80]
[  154.176666]  #5:  (&wdev->mtx){+.+.+.}, at: [<bf019a34>] cfg80211_conn_work+0x7c/0x13c [cfg80211]
[  154.186096]  #6:  (&ifmgd->mtx){+.+.+.}, at: [<bf073620>] ieee80211_mgd_auth+0xc4/0x3b0 [mac80211]
[  154.186096]  #7:  (rcu_read_lock){.+.+.+}, at: [<bf059f4c>] ieee80211_xmit+0x0/0x150 [mac80211]
[  154.205047]  #8:  (rcu_read_lock){.+.+.+}, at: [<bf059e7c>] ieee80211_tx+0x24/0xf4 [mac80211]
[  154.208282] Modules linked in: arc4 wl12xx_sdio wl12xx mac80211 cfg80211
[  154.220245] [<c001a330>] (unwind_backtrace+0x0/0xf0) from [<c0430c38>] (__schedule+0x730/0x7b4)
[  154.230438] [<c0430c38>] (__schedule+0x730/0x7b4) from [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8)
[  154.239868] [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8) from [<c04303c0>] (wait_for_common+0xac/0x150)
[  154.239868] [<c04303c0>] (wait_for_common+0xac/0x150) from [<c033bd24>] (mmc_wait_for_req_done+0x1c/0)
[  154.259704] [<c033bd24>] (mmc_wait_for_req_done+0x1c/0x74) from [<c03448e0>] (mmc_io_rw_extended+0x15)
[  154.270141] [<c03448e0>] (mmc_io_rw_extended+0x15c/0x1f8) from [<c0345a78>] (sdio_io_rw_ext_helper+0x)
[  154.280761] [<c0345a78>] (sdio_io_rw_ext_helper+0x154/0x1d4) from [<c0345bdc>] (sdio_memcpy_fromio+0x)
[  154.291168] [<c0345bdc>] (sdio_memcpy_fromio+0x18/0x20) from [<bf0f2214>] (wl12xx_sdio_raw_read+0x50/)
[  154.302581] [<bf0f2214>] (wl12xx_sdio_raw_read+0x50/0xa4 [wl12xx_sdio]) from [<bf0c7244>] (wl1271_cmd)
[  154.314880] [<bf0c7244>] (wl1271_cmd_send+0x1b8/0x3b4 [wl12xx]) from [<bf0c98f4>] (wl12xx_start_dev+0)
[  154.326354] [<bf0c98f4>] (wl12xx_start_dev+0x90/0x144 [wl12xx]) from [<bf0cab2c>] (wl12xx_tx_get_hlid)
[  154.337860] [<bf0cab2c>] (wl12xx_tx_get_hlid+0xc8/0xcc [wl12xx]) from [<bf0c36c4>] (wl1271_op_tx+0x44)
[  154.349060] [<bf0c36c4>] (wl1271_op_tx+0x44/0x150 [wl12xx]) from [<bf059ce8>] (__ieee80211_tx.isra.4+)
[  154.361236] [<bf059ce8>] (__ieee80211_tx.isra.4+0x150/0x2c0 [mac80211]) from [<bf059f18>] (ieee80211_)
[  154.373107] [<bf059f18>] (ieee80211_tx+0xc0/0xf4 [mac80211]) from [<bf05a008>] (ieee80211_xmit+0xbc/0)
[  154.384490] [<bf05a008>] (ieee80211_xmit+0xbc/0x150 [mac80211]) from [<bf05b2a8>] (ieee80211_tx_skb_t)
[  154.396636] [<bf05b2a8>] (ieee80211_tx_skb_tid+0x3c/0x48 [mac80211]) from [<bf06f998>] (ieee80211_pro)
[  154.396911] [<bf06f998>] (ieee80211_probe_auth+0x128/0x2f8 [mac80211]) from [<bf073774>] (ieee80211_m)
[  154.422210] [<bf073774>] (ieee80211_mgd_auth+0x218/0x3b0 [mac80211]) from [<bf016e94>] (__cfg80211_ml)
[  154.435028] [<bf016e94>] (__cfg80211_mlme_auth+0xec/0x160 [cfg80211]) from [<bf018e1c>] (cfg80211_con)
[  154.435028] [<bf018e1c>] (cfg80211_conn_do_work+0x14c/0x218 [cfg80211]) from [<bf019a78>] (cfg80211_c)
[  154.460357] [<bf019a78>] (cfg80211_conn_work+0xc0/0x13c [cfg80211]) from [<c0057da0>] (process_one_wo)
[  154.471466] [<c0057da0>] (process_one_work+0x188/0x508) from [<c00584d0>] (worker_thread+0x170/0x370)
[  154.481201] [<c00584d0>] (worker_thread+0x170/0x370) from [<c005d080>] (kthread+0x84/0x90)
[  154.489868] [<c005d080>] (kthread+0x84/0x90) from [<c0014130>] (kernel_thread_exit+0x0/0x8)
[  154.500427] BUG: scheduling while atomic: kworker/0:1/425/0x00000200
[  154.507354] 9 locks held by kworker/0:1/425:
[  154.507354]  #0:  (events){.+.+.+}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  154.515258]  #1:  ((&rdev->conn_work)){+.+.+.}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  154.519775]  #2:  (rtnl_mutex){+.+.+.}, at: [<bf0199d0>] cfg80211_conn_work+0x18/0x13c [cfg80211]
[  154.530609]  #3:  (&rdev->mtx){+.+.+.}, at: [<bf0199e0>] cfg80211_conn_work+0x28/0x13c [cfg80211]
[  154.547668]  #4:  (&rdev->devlist_mtx){+.+.+.}, at: [<bf0199ec>] cfg80211_conn_work+0x34/0x13c [cfg80]
[  154.547668]  #5:  (&wdev->mtx){+.+.+.}, at: [<bf019a34>] cfg80211_conn_work+0x7c/0x13c [cfg80211]
[  154.567260]  #6:  (&ifmgd->mtx){+.+.+.}, at: [<bf073620>] ieee80211_mgd_auth+0xc4/0x3b0 [mac80211]
[  154.576904]  #7:  (rcu_read_lock){.+.+.+}, at: [<bf059f4c>] ieee80211_xmit+0x0/0x150 [mac80211]
[  154.576904]  #8:  (rcu_read_lock){.+.+.+}, at: [<bf059e7c>] ieee80211_tx+0x24/0xf4 [mac80211]
[  154.590240] Modules linked in: arc4 wl12xx_sdio wl12xx mac80211 cfg80211
[  154.602416] [<c001a330>] (unwind_backtrace+0x0/0xf0) from [<c0430c38>] (__schedule+0x730/0x7b4)
[  154.611572] [<c0430c38>] (__schedule+0x730/0x7b4) from [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8)
[  154.621002] [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8) from [<c04303c0>] (wait_for_common+0xac/0x150)
[  154.630798] [<c04303c0>] (wait_for_common+0xac/0x150) from [<c033bd24>] (mmc_wait_for_req_done+0x1c/0)
[  154.640869] [<c033bd24>] (mmc_wait_for_req_done+0x1c/0x74) from [<c03448e0>] (mmc_io_rw_extended+0x15)
[  154.651275] [<c03448e0>] (mmc_io_rw_extended+0x15c/0x1f8) from [<c0345a78>] (sdio_io_rw_ext_helper+0x)
[  154.661895] [<c0345a78>] (sdio_io_rw_ext_helper+0x154/0x1d4) from [<c0345bdc>] (sdio_memcpy_fromio+0x)
[  154.661895] [<c0345bdc>] (sdio_memcpy_fromio+0x18/0x20) from [<bf0f2214>] (wl12xx_sdio_raw_read+0x50/)
[  154.683715] [<bf0f2214>] (wl12xx_sdio_raw_read+0x50/0xa4 [wl12xx_sdio]) from [<bf0c7244>] (wl1271_cmd)
[  154.696014] [<bf0c7244>] (wl1271_cmd_send+0x1b8/0x3b4 [wl12xx]) from [<bf0c98f4>] (wl12xx_start_dev+0)
[  154.696014] [<bf0c98f4>] (wl12xx_start_dev+0x90/0x144 [wl12xx]) from [<bf0cab2c>] (wl12xx_tx_get_hlid)
[  154.718994] [<bf0cab2c>] (wl12xx_tx_get_hlid+0xc8/0xcc [wl12xx]) from [<bf0c36c4>] (wl1271_op_tx+0x44)
[  154.718994] [<bf0c36c4>] (wl1271_op_tx+0x44/0x150 [wl12xx]) from [<bf059ce8>] (__ieee80211_tx.isra.4+)
[  154.742156] [<bf059ce8>] (__ieee80211_tx.isra.4+0x150/0x2c0 [mac80211]) from [<bf059f18>] (ieee80211_)
[  154.754486] [<bf059f18>] (ieee80211_tx+0xc0/0xf4 [mac80211]) from [<bf05a008>] (ieee80211_xmit+0xbc/0)
[  154.765624] [<bf05a008>] (ieee80211_xmit+0xbc/0x150 [mac80211]) from [<bf05b2a8>] (ieee80211_tx_skb_t)
[  154.777740] [<bf05b2a8>] (ieee80211_tx_skb_tid+0x3c/0x48 [mac80211]) from [<bf06f998>] (ieee80211_pro)
[  154.790527] [<bf06f998>] (ieee80211_probe_auth+0x128/0x2f8 [mac80211]) from [<bf073774>] (ieee80211_m)
[  154.803588] [<bf073774>] (ieee80211_mgd_auth+0x218/0x3b0 [mac80211]) from [<bf016e94>] (__cfg80211_ml)
[  154.816162] [<bf016e94>] (__cfg80211_mlme_auth+0xec/0x160 [cfg80211]) from [<bf018e1c>] (cfg80211_con)
[  154.816162] [<bf018e1c>] (cfg80211_conn_do_work+0x14c/0x218 [cfg80211]) from [<bf019a78>] (cfg80211_c)
[  154.841583] [<bf019a78>] (cfg80211_conn_work+0xc0/0x13c [cfg80211]) from [<c0057da0>] (process_one_wo)
[  154.852630] [<c0057da0>] (process_one_work+0x188/0x508) from [<c00584d0>] (worker_thread+0x170/0x370)
[  154.862335] [<c00584d0>] (worker_thread+0x170/0x370) from [<c005d080>] (kthread+0x84/0x90)
[  154.871032] [<c005d080>] (kthread+0x84/0x90) from [<c0014130>] (kernel_thread_exit+0x0/0x8)
[  154.882446] wl12xx: ERROR command complete timeout
[  154.887664] ------------[ cut here ]------------
[  154.892547] WARNING: at drivers/net/wireless/wl12xx/cmd.c:108 wl1271_cmd_send+0x348/0x3b4 [wl12xx]()
[  154.892547] Modules linked in: arc4 wl12xx_sdio wl12xx mac80211 cfg80211
[  154.909118] [<c001a330>] (unwind_backtrace+0x0/0xf0) from [<c003df94>] (warn_slowpath_common+0x4c/0x6)
[  154.919189] [<c003df94>] (warn_slowpath_common+0x4c/0x64) from [<c003dfc8>] (warn_slowpath_null+0x1c/)
[  154.929412] [<c003dfc8>] (warn_slowpath_null+0x1c/0x24) from [<bf0c73d4>] (wl1271_cmd_send+0x348/0x3b)
[  154.940093] [<bf0c73d4>] (wl1271_cmd_send+0x348/0x3b4 [wl12xx]) from [<bf0c98f4>] (wl12xx_start_dev+0)
[  154.951568] [<bf0c98f4>] (wl12xx_start_dev+0x90/0x144 [wl12xx]) from [<bf0cab2c>] (wl12xx_tx_get_hlid)
[  154.951660] [<bf0cab2c>] (wl12xx_tx_get_hlid+0xc8/0xcc [wl12xx]) from [<bf0c36c4>] (wl1271_op_tx+0x44)
[  154.974517] [<bf0c36c4>] (wl1271_op_tx+0x44/0x150 [wl12xx]) from [<bf059ce8>] (__ieee80211_tx.isra.4+)
[  154.986297] [<bf059ce8>] (__ieee80211_tx.isra.4+0x150/0x2c0 [mac80211]) from [<bf059f18>] (ieee80211_)
[  154.998413] [<bf059f18>] (ieee80211_tx+0xc0/0xf4 [mac80211]) from [<bf05a008>] (ieee80211_xmit+0xbc/0)
[  155.009826] [<bf05a008>] (ieee80211_xmit+0xbc/0x150 [mac80211]) from [<bf05b2a8>] (ieee80211_tx_skb_t)
[  155.021942] [<bf05b2a8>] (ieee80211_tx_skb_tid+0x3c/0x48 [mac80211]) from [<bf06f998>] (ieee80211_pro)
[  155.021942] [<bf06f998>] (ieee80211_probe_auth+0x128/0x2f8 [mac80211]) from [<bf073774>] (ieee80211_m)
[  155.047790] [<bf073774>] (ieee80211_mgd_auth+0x218/0x3b0 [mac80211]) from [<bf016e94>] (__cfg80211_ml)
[  155.060211] [<bf016e94>] (__cfg80211_mlme_auth+0xec/0x160 [cfg80211]) from [<bf018e1c>] (cfg80211_con)
[  155.073181] [<bf018e1c>] (cfg80211_conn_do_work+0x14c/0x218 [cfg80211]) from [<bf019a78>] (cfg80211_c)
[  155.085754] [<bf019a78>] (cfg80211_conn_work+0xc0/0x13c [cfg80211]) from [<c0057da0>] (process_one_wo)
[  155.096832] [<c0057da0>] (process_one_work+0x188/0x508) from [<c00584d0>] (worker_thread+0x170/0x370)
[  155.096832] [<c00584d0>] (worker_thread+0x170/0x370) from [<c005d080>] (kthread+0x84/0x90)
[  155.096832] [<c005d080>] (kthread+0x84/0x90) from [<c0014130>] (kernel_thread_exit+0x0/0x8)
[  155.096832] ---[ end trace a79e679c7e091116 ]---
[  155.123992] wl12xx: ERROR failed to initiate cmd role enable
[  155.137847] wl12xx: Reading FW panic log
[  155.143920] wl12xx: Hardware recovery in progress. FW ver: Rev 6.3.0.0.77 pc: 0x0
[  155.152343] wl12xx: down
[  155.158050] ieee80211 phy0: Hardware restart was requested
[  155.636657] wl12xx: firmware booted (Rev 6.3.0.0.77)
[  155.766845] BUG: scheduling while atomic: kworker/u:2/546/0x00000100
[  155.774536] 3 locks held by kworker/u:2/546:
[  155.774536]  #0:  (wiphy_name(local->hw.wiphy)){++++.+}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  155.788909]  #1:  ((&sdata->work)){+.+...}, at: [<c0057d1c>] process_one_work+0x104/0x508
[  155.792236]  #2:  (&ifmgd->mtx){+.+.+.}, at: [<bf07249c>] ieee80211_sta_work+0x24/0xcb0 [mac80211]
[  155.807220] Modules linked in: arc4 wl12xx_sdio wl12xx mac80211 cfg80211
[  155.814331] 
[  155.814331] Pid: 616, comm:       irq/213-wl12xx
[  155.820770] CPU: 0    Tainted: G        W     (3.3.0-rc3-wl #4)
[  155.826995] PC is at _raw_spin_unlock_irq+0x28/0x2c
[  155.832122] LR is at mark_held_locks+0xa0/0x114
[  155.832122] pc : [<c0431d8c>]    lr : [<c00898e4>]    psr: 20000113
[  155.832122] sp : ebd4fc48  ip : 000031f5  fp : ebd4fcfc
[  155.848937] r10: ebd4e000  r9 : 00000000  r8 : 000a3e9b
[  155.854461] r7 : ee534ac0  r6 : ee7b6000  r5 : c1210380  r4 : c1210380
[  155.854461] r3 : 00000001  r2 : 00000000  r1 : ee5bef20  r0 : 00000001
[  155.868164] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[  155.868164] Control: 10c53c7d  Table: ada9004a  DAC: 00000017
[  155.881896] [<c001a330>] (unwind_backtrace+0x0/0xf0) from [<c0430c38>] (__schedule+0x730/0x7b4)
[  155.891052] [<c0430c38>] (__schedule+0x730/0x7b4) from [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8)
[  155.900482] [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8) from [<c04303c0>] (wait_for_common+0xac/0x150)
[  155.900482] [<c04303c0>] (wait_for_common+0xac/0x150) from [<c033bd24>] (mmc_wait_for_req_done+0x1c/0)
[  155.920318] [<c033bd24>] (mmc_wait_for_req_done+0x1c/0x74) from [<c03448e0>] (mmc_io_rw_extended+0x15)
[  155.930755] [<c03448e0>] (mmc_io_rw_extended+0x15c/0x1f8) from [<c0345a78>] (sdio_io_rw_ext_helper+0x)
[  155.941345] [<c0345a78>] (sdio_io_rw_ext_helper+0x154/0x1d4) from [<c0345b64>] (sdio_memcpy_toio+0x20)
[  155.951599] [<c0345b64>] (sdio_memcpy_toio+0x20/0x28) from [<bf0f2170>] (wl12xx_sdio_raw_write+0x50/0)
[  155.951599] [<bf0f2170>] (wl12xx_sdio_raw_write+0x50/0xa4 [wl12xx_sdio]) from [<bf0c710c>] (wl1271_cm)
[  155.975189] [<bf0c710c>] (wl1271_cmd_send+0x80/0x3b4 [wl12xx]) from [<bf0c98f4>] (wl12xx_start_dev+0x)
[  155.986663] [<bf0c98f4>] (wl12xx_start_dev+0x90/0x144 [wl12xx]) from [<bf0cab2c>] (wl12xx_tx_get_hlid)
[  155.986663] [<bf0cab2c>] (wl12xx_tx_get_hlid+0xc8/0xcc [wl12xx]) from [<bf0c36c4>] (wl1271_op_tx+0x44)
[  156.009368] [<bf0c36c4>] (wl1271_op_tx+0x44/0x150 [wl12xx]) from [<bf059ce8>] (__ieee80211_tx.isra.4+)
[  156.021545] [<bf059ce8>] (__ieee80211_tx.isra.4+0x150/0x2c0 [mac80211]) from [<bf05b17c>] (ieee80211_)
[  156.034484] [<bf05b17c>] (ieee80211_tx_pending+0x17c/0x26c [mac80211]) from [<c0044328>] (tasklet_act)
[  156.045562] [<c0044328>] (tasklet_action+0x80/0x18c) from [<c0044aa0>] (__do_softirq+0xc8/0x224)
[  156.045562] [<c0044aa0>] (__do_softirq+0xc8/0x224) from [<c0045094>] (irq_exit+0x94/0x9c)
[  156.063385] [<c0045094>] (irq_exit+0x94/0x9c) from [<c0013edc>] (handle_IRQ+0x50/0xac)
[  156.071716] [<c0013edc>] (handle_IRQ+0x50/0xac) from [<c0008484>] (gic_handle_irq+0x24/0xa8)
[  156.080596] [<c0008484>] (gic_handle_irq+0x24/0xa8) from [<c0432064>] (__irq_svc+0x44/0x60)
[  156.089385] Exception stack(0xebd4fc00 to 0xebd4fc48)
[  156.089385] fc00: 00000001 ee5bef20 00000000 00000001 c1210380 c1210380 ee7b6000 ee534ac0
[  156.103271] fc20: 000a3e9b 00000000 ebd4e000 ebd4fcfc 000031f5 ebd4fc48 c00898e4 c0431d8c
[  156.111877] fc40: 20000113 ffffffff
[  156.115570] [<c0432064>] (__irq_svc+0x44/0x60) from [<c0431d8c>] (_raw_spin_unlock_irq+0x28/0x2c)
[  156.124877] [<c0431d8c>] (_raw_spin_unlock_irq+0x28/0x2c) from [<c04307ec>] (__schedule+0x2e4/0x7b4)
[  156.134490] [<c04307ec>] (__schedule+0x2e4/0x7b4) from [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8)
[  156.134490] [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8) from [<c04303c0>] (wait_for_common+0xac/0x150)
[  156.153686] [<c04303c0>] (wait_for_common+0xac/0x150) from [<c033bd24>] (mmc_wait_for_req_done+0x1c/0)
[  156.163757] [<c033bd24>] (mmc_wait_for_req_done+0x1c/0x74) from [<c03448e0>] (mmc_io_rw_extended+0x15)
[  156.163757] [<c03448e0>] (mmc_io_rw_extended+0x15c/0x1f8) from [<c0345a78>] (sdio_io_rw_ext_helper+0x)
[  156.184783] [<c0345a78>] (sdio_io_rw_ext_helper+0x154/0x1d4) from [<c0345bdc>] (sdio_memcpy_fromio+0x)
[  156.195220] [<c0345bdc>] (sdio_memcpy_fromio+0x18/0x20) from [<bf0f2214>] (wl12xx_sdio_raw_read+0x50/)
[  156.195220] [<bf0f2214>] (wl12xx_sdio_raw_read+0x50/0xa4 [wl12xx_sdio]) from [<bf0c3808>] (wl12xx_fw_)
[  156.218811] [<bf0c3808>] (wl12xx_fw_status+0x38/0x288 [wl12xx]) from [<bf0c6260>] (wl1271_irq+0x8c/0x)
[  156.229797] [<bf0c6260>] (wl1271_irq+0x8c/0x238 [wl12xx]) from [<c0098820>] (irq_thread+0x148/0x208)
[  156.239410] [<c0098820>] (irq_thread+0x148/0x208) from [<c005d080>] (kthread+0x84/0x90)
[  156.247833] [<c005d080>] (kthread+0x84/0x90) from [<c0014130>] (kernel_thread_exit+0x0/0x8)
[  156.256622] Unable to handle kernel NULL pointer dereference at virtual address 0000002c
[  156.256622] pgd = c0004000
[  156.265136] [0000002c] *pgd=00000000
[  156.271759] Internal error: Oops: 17 [#1] SMP
[  156.271759] Modules linked in: arc4 wl12xx_sdio wl12xx mac80211 cfg80211
[  156.276336] CPU: 0    Tainted: G        W     (3.3.0-rc3-wl #4)
[  156.289611] PC is at __schedule+0x5d8/0x7b4
[  156.289611] LR is at mark_held_locks+0xa0/0x114
[  156.289611] pc : [<c0430ae0>]    lr : [<c00898e4>]    psr: 60000113
[  156.289611] sp : ebd4f760  ip : 000031f6  fp : ebd4f80c
[  156.298767] r10: ebd4e000  r9 : 00000000  r8 : 00000000
[  156.298767] r7 : ee5beac0  r6 : 00000000  r5 : c1210380  r4 : ee534ac0
[  156.316284] r3 : 0000002c  r2 : 00000000  r1 : ee5bef38  r0 : 00000001
[  156.316284] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[  156.316284] Control: 10c53c7d  Table: ada9004a  DAC: 00000017
[  156.343658] Process irq/213-wl12xx (pid: 616, stack limit = 0xebd4e2f8)
[  156.343658] Stack: (0xebd4f760 to 0xebd50000)
[  156.355163] f760: c069ce00 c00874f4 ee5beac0 c06bd2b0 18683e3f 00000000 c042e7e4 c0631380
[  156.355163] f780: 446d7106 00000024 c0631380 c0631380 00000000 00000000 c062f418 c0631380
[  156.355163] f7a0: 00000002 00000080 c0aeb4e8 ebd4e000 0001c15e 00000000 00000000 00000001
[  156.355163] f7c0: 00000000 ee5bef38 0000000f c00898e4 80000113 c00203fc ada84984 ebd4e000
[  156.380920] f7e0: c0431d50 ee5beac0 00000001 c04303c0 ebd4f8f0 7fffffff ebd4e000 00000000
[  156.380920] f800: 00000000 00000002 ebd4f8c4 c042e7e4 c0aeb4e8 00000001 ee5beac0 00000000
[  156.380920] f820: 00000002 c077b5e0 00000003 ee5bef38 0000000f c00898e4 60000193 00000000
[  156.380920] f840: 00000001 ebd4e000 c0431d88 ee5beac0 00000001 00000000 00000000 00000002
[  156.380920] f860: ebd4f8c4 ebd4f8f4 ebd4f8f0 7fffffff ebd4e000 00000000 00000000 00000002
[  156.380920] f880: ebd4f8c4 c04303c0 ebd4f894 00000001 ee5beac0 c006c8fc ebd4f914 ebd4f914
[  156.432403] f8a0: edb20800 edb20800 ebd4f8e0 ebd4f8f0 00000000 00000001 a40f6844 000f6800
[  156.432403] f8c0: ebd4f950 c033bd24 00000000 edb26800 00000100 00000044 00000044 c03448e0
[  156.432403] f8e0: 00000000 ebd4f920 ebd4f950 00000000 00000001 00000000 dead4ead ffffffff
[  156.432403] f900: ffffffff c0c093f4 c07929c0 00000000 c0543070 ebd4f898 ebd4f898 c033bd00
[  156.432403] f920: 00000035 a40f6844 00001000 00000000 00000000 00000000 000001b5 00000000
[  156.432403] f940: 00000000 00000000 ebd4f950 ebd4f8e0 3b9aca00 00000000 00000044 00000001
[  156.492462] f960: 00000000 00000100 00000044 00000000 ebd4f8e0 00000001 ebd4f980 00000000
[  156.492462] f980: c11c6082 00000940 00000044 ada84940 ee5beac0 00000044 00000044 edb27c00
[  156.492462] f9a0: eda84940 00000001 00000000 000007b4 00000001 c0345a78 00000001 eda84940
[  156.492462] f9c0: 00000000 00000044 ee5beac0 00000000 00000002 000007b4 ebd65c08 eda84940
[  156.492462] f9e0: 00000044 00000000 00000003 ee700520 eda84940 c0345b64 eda84940 00000044
[  156.492462] fa00: 00000001 bf0f2170 60000113 00000044 ecc30c38 ee701660 eda84940 ee701660
[  156.543945] fa20: 00000000 bf0c710c 00000000 c00f27e4 ee700608 ebd4e000 00000000 ecc30cc4
[  156.543945] fa40: eda84940 ee701660 00000000 00000000 00000003 ee700520 ecc30c38 bf0c98f4
[  156.543945] fa60: 00000000 c00898e4 00000000 ecc30cc4 ee7f2854 ecc30cc4 ebd4fb10 bf0cab2c
[  156.543945] fa80: bf0d6d38 ee701660 eda50140 bf0c36c4 ecc30c38 c0089a00 000006f8 ebd4fb10
[  156.543945] faa0: ebd4fb10 ee700520 ebd4fb10 00000000 00000000 ee7005f8 ecc30c38 bf059ce8
[  156.543945] fac0: 00000000 00000001 ecc30c38 ee700c18 ee7005f8 00000000 ebd4fb10 ee700520
[  156.543945] fae0: eda50140 00000000 80000113 bf05b17c 00000001 00000000 bf05b000 00000000
[  156.595428] fb00: ee5beac0 ee7005e8 000006f8 ee700d04 ebd4fb10 ebd4fb10 00000000 c00898e4
[  156.595428] fb20: c06b4828 c06b4828 c0631980 ebd4e000 c00442f8 ee5beac0 00000001 00000006
[  156.595428] fb40: c062f458 ee700cc8 00000000 ebd4e000 ee700ccc 00000000 c062f458 c0649108
[  156.595428] fb60: c06b9e48 c0044328 c00442a8 00000001 c0634098 ebd4e000 0000002c 00000006
[  156.595428] fb80: 00000000 ebd4e000 00000100 c0044aa0 0000002c 00000000 00000000 0000000a
[  156.595428] fba0: c06310e0 ebd4e000 c06310e0 ebd4e000 0000002c 00000000 00000000 ebd4e000
[  156.646911] fbc0: ebd4fcfc c0045094 c0649108 c0013edc 00000000 fa240100 c0647cf0 ebd4fc00
[  156.646911] fbe0: c0647cf0 c0008484 c0431d8c 20000113 ffffffff ebd4fc34 000a3e9b c0432064
[  156.646911] fc00: 00000001 ee5bef20 00000000 00000001 c1210380 c1210380 ee7b6000 ee534ac0
[  156.646911] fc20: 000a3e9b 00000000 ebd4e000 ebd4fcfc 000031f5 ebd4fc48 c00898e4 c0431d8c
[  156.646911] fc40: 20000113 ffffffff ee5beac0 c04307ec c069ce00 c00874f4 ee5beac0 c06bd2b0
[  156.646911] fc60: 0f14cc3d 00000000 c042e7e4 c0631380 446d7106 00000024 c0631380 c0631380
[  156.698394] fc80: 000a3e9b 00000000 c062f418 c0631380 00000000 c0020500 c0aeb4e8 ebd4e000
[  156.698394] fca0: 0046415e 00000000 0000015e 00000478 00000000 ee5bef20 00000233 c00898e4
[  156.698394] fcc0: adaa9f14 fa242000 00000000 ebd4e000 c0431d50 ee5beac0 00000001 c04303c0
[  156.698394] fce0: ebd4fde0 7fffffff ebd4e000 00000000 00000000 00000002 ebd4fdb4 c042e7e4
[  156.698394] fd00: c0aeb4e8 00000000 ee5beac0 00000004 00000006 c077b5e0 00000006 ee5bef20
[  156.698394] fd20: 00000233 c00898e4 60000193 00000000 00000001 ebd4e000 c0431d88 ee5beac0
[  156.749877] fd40: 00000001 00000000 00000000 00000002 ebd4fdb4 ebd4fde4 ebd4fde0 7fffffff
[  156.749877] fd60: ebd4e000 00000000 00000000 00000002 ebd4fdb4 c04303c0 ebd4fd84 00000001
[  156.749877] fd80: ee5beac0 c006c8fc ebd4fe04 ebd4fe04 edb20800 edb20800 ebd4fdd0 ebd4fde0
[  156.749877] fda0: 00000000 00000001 27df8054 03df8000 ebd4fe40 c033bd24 00000000 edb26800
[  156.749877] fdc0: 00000200 00000054 00000054 c03448e0 00000000 ebd4fe10 ebd4fe40 00000000
[  156.749877] fde0: 00000001 00000000 dead4ead ffffffff ffffffff c0c093f4 c07929c0 00000000
[  156.801361] fe00: c0543070 ebd4fd88 ebd4fd88 c033bd00 00000035 27df8054 00001000 00000000
[  156.801361] fe20: 00000000 00000000 000001b5 00000000 00000000 00000000 ebd4fe40 ebd4fdd0
[  156.801361] fe40: 3b9aca00 00000000 00000054 00000001 00000000 00000200 00000054 00000000
[  156.801361] fe60: ebd4fdd0 00000001 ebd4fe70 00000000 c11c6522 00000ec0 00000054 adaa9ec0
[  156.801361] fe80: ebd4ff2c 00000054 00000054 edb27c00 edaa9ec0 00000001 00000000 0001efc0
[  156.801361] fea0: 00000000 c0345a78 00000001 edaa9ec0 00000000 00000054 00000002 00000000
[  156.861419] fec0: c004ba70 0001efc0 ebd65c08 edaa9ec0 00000054 00000100 ee7016a4 00000000
[  156.861419] fee0: ee70183c c0345bdc edaa9ec0 00000054 ffffffff bf0f2214 00000000 00000000
[  156.861419] ff00: bf0db4c8 ee701660 edaa9ec0 00000000 00000063 bf0c3808 00000000 ffffffff
[  156.861419] ff20: bf0dec78 00000000 00000000 bf0db4c8 ebd4ff04 ee701660 ebd4e000 ee701680
[  156.861419] ff40: ee7016ec 00000100 ee7016a4 00000000 ee70183c bf0c6260 bf0c61d4 c063e180
[  156.861419] ff60: ebd4e000 ee480660 ee480640 c063e204 c0648b6c c063e1d4 00000000 c0098820
[  156.912902] ff80: 00000000 c0089a44 ecc23c68 ecc23c40 ee480640 c00986d8 00000013 00000000
[  156.912902] ffa0: 00000000 00000000 00000000 c005d080 00000000 00000000 ee480640 00000000
[  156.912902] ffc0: 00000000 dead4ead ffffffff ffffffff c06cecb8 00000000 00000000 c0543070
[  156.912902] ffe0: ebd4ffe0 ebd4ffe0 ecc23c40 c005cffc c0014130 c0014130 00000000 00000000
[  156.912902] [<c0430ae0>] (__schedule+0x5d8/0x7b4) from [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8)
[  156.956634] [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8) from [<c04303c0>] (wait_for_common+0xac/0x150)
[  156.956634] [<c04303c0>] (wait_for_common+0xac/0x150) from [<c033bd24>] (mmc_wait_for_req_done+0x1c/0)
[  156.956634] [<c033bd24>] (mmc_wait_for_req_done+0x1c/0x74) from [<c03448e0>] (mmc_io_rw_extended+0x15)
[  156.986846] [<c03448e0>] (mmc_io_rw_extended+0x15c/0x1f8) from [<c0345a78>] (sdio_io_rw_ext_helper+0x)
[  156.997436] [<c0345a78>] (sdio_io_rw_ext_helper+0x154/0x1d4) from [<c0345b64>] (sdio_memcpy_toio+0x20)
[  156.997436] [<c0345b64>] (sdio_memcpy_toio+0x20/0x28) from [<bf0f2170>] (wl12xx_sdio_raw_write+0x50/0)
[  156.997436] [<bf0f2170>] (wl12xx_sdio_raw_write+0x50/0xa4 [wl12xx_sdio]) from [<bf0c710c>] (wl1271_cm)
[  157.031219] [<bf0c710c>] (wl1271_cmd_send+0x80/0x3b4 [wl12xx]) from [<bf0c98f4>] (wl12xx_start_dev+0x)
[  157.031219] [<bf0c98f4>] (wl12xx_start_dev+0x90/0x144 [wl12xx]) from [<bf0cab2c>] (wl12xx_tx_get_hlid)
[  157.031219] [<bf0cab2c>] (wl12xx_tx_get_hlid+0xc8/0xcc [wl12xx]) from [<bf0c36c4>] (wl1271_op_tx+0x44)
[  157.065429] [<bf0c36c4>] (wl1271_op_tx+0x44/0x150 [wl12xx]) from [<bf059ce8>] (__ieee80211_tx.isra.4+)
[  157.065429] [<bf059ce8>] (__ieee80211_tx.isra.4+0x150/0x2c0 [mac80211]) from [<bf05b17c>] (ieee80211_)
[  157.065429] [<bf05b17c>] (ieee80211_tx_pending+0x17c/0x26c [mac80211]) from [<c0044328>] (tasklet_act)
[  157.065429] [<c0044328>] (tasklet_action+0x80/0x18c) from [<c0044aa0>] (__do_softirq+0xc8/0x224)
[  157.065429] [<c0044aa0>] (__do_softirq+0xc8/0x224) from [<c0045094>] (irq_exit+0x94/0x9c)
[  157.065429] [<c0045094>] (irq_exit+0x94/0x9c) from [<c0013edc>] (handle_IRQ+0x50/0xac)
[  157.119171] [<c0013edc>] (handle_IRQ+0x50/0xac) from [<c0008484>] (gic_handle_irq+0x24/0xa8)
[  157.119171] [<c0008484>] (gic_handle_irq+0x24/0xa8) from [<c0432064>] (__irq_svc+0x44/0x60)
[  157.119171] Exception stack(0xebd4fc00 to 0xebd4fc48)
[  157.150390] fc00: 00000001 ee5bef20 00000000 00000001 c1210380 c1210380 ee7b6000 ee534ac0
[  157.150390] fc20: 000a3e9b 00000000 ebd4e000 ebd4fcfc 000031f5 ebd4fc48 c00898e4 c0431d8c
[  157.150390] fc40: 20000113 ffffffff
[  157.150390] [<c0432064>] (__irq_svc+0x44/0x60) from [<c0431d8c>] (_raw_spin_unlock_irq+0x28/0x2c)
[  157.150390] [<c0431d8c>] (_raw_spin_unlock_irq+0x28/0x2c) from [<c04307ec>] (__schedule+0x2e4/0x7b4)
[  157.180541] [<c04307ec>] (__schedule+0x2e4/0x7b4) from [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8)
[  157.180541] [<c042e7e4>] (schedule_timeout+0x1c4/0x2d8) from [<c04303c0>] (wait_for_common+0xac/0x150)
[  157.180541] [<c04303c0>] (wait_for_common+0xac/0x150) from [<c033bd24>] (mmc_wait_for_req_done+0x1c/0)
[  157.180541] [<c033bd24>] (mmc_wait_for_req_done+0x1c/0x74) from [<c03448e0>] (mmc_io_rw_extended+0x15)
[  157.180541] [<c03448e0>] (mmc_io_rw_extended+0x15c/0x1f8) from [<c0345a78>] (sdio_io_rw_ext_helper+0x)
[  157.180541] [<c0345a78>] (sdio_io_rw_ext_helper+0x154/0x1d4) from [<c0345bdc>] (sdio_memcpy_fromio+0x)
[  157.180541] [<c0345bdc>] (sdio_memcpy_fromio+0x18/0x20) from [<bf0f2214>] (wl12xx_sdio_raw_read+0x50/)
[  157.180541] [<bf0f2214>] (wl12xx_sdio_raw_read+0x50/0xa4 [wl12xx_sdio]) from [<bf0c3808>] (wl12xx_fw_)
[  157.274383] [<bf0c3808>] (wl12xx_fw_status+0x38/0x288 [wl12xx]) from [<bf0c6260>] (wl1271_irq+0x8c/0x)
[  157.274383] [<bf0c6260>] (wl1271_irq+0x8c/0x238 [wl12xx]) from [<c0098820>] (irq_thread+0x148/0x208)
[  157.274383] [<c0098820>] (irq_thread+0x148/0x208) from [<c005d080>] (kthread+0x84/0x90)
[  157.294860] [<c005d080>] (kthread+0x84/0x90) from [<c0014130>] (kernel_thread_exit+0x0/0x8)
[  157.294860] Code: e2846f9b eafffeba e58791c0 e289302c (e1932f9f) 
[  157.318450] ---[ end trace a79e679c7e091117 ]---
[  157.318450] Kernel panic - not syncing: Fatal exception in interrupt
[  157.329986] CPU1: stopping
[  157.329986] [<c001a330>] (unwind_backtrace+0x0/0xf0) from [<c0018604>] (handle_IPI+0x168/0x194)
[  157.338867] [<c0018604>] (handle_IPI+0x168/0x194) from [<c00084e4>] (gic_handle_irq+0x84/0xa8)
[  157.347076] [<c00084e4>] (gic_handle_irq+0x84/0xa8) from [<c0432064>] (__irq_svc+0x44/0x60)
[  157.357330] Exception stack(0xee475f88 to 0xee475fd0)
[  157.365051] 5f80:                   c00292fc 00000000 00000000 c00292e0 ee474000 c06bb088
[  157.373626] 5fa0: c043c480 00000000 c064cb98 ee474000 c064cd50 00000000 00be7000 ee475fd0
[  157.374542] 5fc0: c00292fc c0029300 60000113 ffffffff
[  157.387145] [<c0432064>] (__irq_svc+0x44/0x60) from [<c0029300>] (omap_default_idle+0x20/0x24)
[  157.396545] [<c0029300>] (omap_default_idle+0x20/0x24) from [<c00143f8>] (cpu_idle+0xcc/0x114)
[  157.405517] [<c00143f8>] (cpu_idle+0xcc/0x114) from [<80426434>] (0x80426434)

Thomas
