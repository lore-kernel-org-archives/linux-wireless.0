Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38962 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751438AbcK1Swp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 13:52:45 -0500
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 77A7440B2CD
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2016 10:52:44 -0800 (PST)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Deadlock in hacked 4.9.0-rc6+ kernel.
Message-ID: <f685b46e-cad9-2f03-0c59-9e9631ab0500@candelatech.com> (sfid-20161128_195250_333321_DC0AE99B)
Date: Mon, 28 Nov 2016 10:52:44 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I ported forward my patch set to the 4.9 kernel, and I am seeing lockups fairly
often.  As always, could be something I added locally, but in case someone sees
similar, then maybe I can reproduce it quicker and help track this down since my
test config uses many virtual stations and virtual APs.

And, if someone knows the magic trick to make dmesg output from lockdep
not be so split up, please let me know.


[81871.799595] ath10k_pci 0000:05:00.0: boot warm reset complete
[81873.983645] sta559: Failed to send nullfunc to AP 04:f0:21:0f:3c:3c after 1000ms, disconnecting
[81873.991198] ath10k_pci 0000:05:00.0: mac ampdu vdev_id 49 sta 04:f0:21:0f:3c:3c tid 6 action 1
[82195.484265] INFO: task mission-control:1506 blocked for more than 180 seconds.
[82195.490228]       Tainted: G        W       4.9.0-rc6+ #9
[82195.494367] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[82195.500922] mission-control D    0  1506      1 0x00000000
[82195.505152]  ffff8801f1c3a300 0000000000002629 ffff880214de2640 ffff8801f2f38000
[82195.511330]  ffff88021e3198d8 ffffc90003867c80 ffffffff819322eb 0000000000000006
[82195.518230]  ffff8801f2f38828 0000000003867c78 ffff88021e3198d8 0000000000000000
[82195.525121] Call Trace:
[82195.526300]  [<ffffffff819322eb>] ? __schedule+0x2fb/0xb30
[82195.530862]  [<ffffffff81932b58>] schedule+0x38/0x90
[82195.534552]  [<ffffffff81932f20>] schedule_preempt_disabled+0x10/0x20
[82195.540073]  [<ffffffff81934b15>] mutex_lock_nested+0x175/0x3f0
[82195.544723]  [<ffffffff81842df6>] ? rtnetlink_rcv+0x16/0x30
[82195.549424]  [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82195.553555]  [<ffffffff8186c76d>] netlink_unicast+0x1cd/0x2e0
[82195.558414]  [<ffffffff8186c6e9>] ? netlink_unicast+0x149/0x2e0
[82195.563062]  [<ffffffff8186cb62>] netlink_sendmsg+0x2e2/0x390
[82195.567889]  [<ffffffff812dcb98>] ? __fget+0x108/0x1f0
[82195.571755]  [<ffffffff8180ca73>] sock_sendmsg+0x33/0x40
[82195.575791]  [<ffffffff8180d041>] SYSC_sendto+0x101/0x190
[82195.580258]  [<ffffffff813ea076>] ? security_file_permission+0x96/0xb0
[82195.585521]  [<ffffffff812ba7e9>] ? rw_verify_area+0x49/0xb0
[82195.589909]  [<ffffffff811771d9>] ? trace_hardirqs_on_caller+0x129/0x1b0
[82195.595364]  [<ffffffff8100301a>] ? trace_hardirqs_on_thunk+0x1a/0x1c
[82195.600538]  [<ffffffff8180dee9>] SyS_sendto+0x9/0x10
[82195.604319]  [<ffffffff81939f45>] entry_SYSCALL_64_fastpath+0x23/0xc6
[82195.609502]
Showing all locks held in the system:
[82195.613134] 2 locks held by khungtaskd/37:
[82195.615958]  #0:
[82195.616408]  (
[82195.616802] rcu_read_lock
[82195.617946] ){......}
[82195.618983] , at:
[82195.619522] [<ffffffff811ebd5c>] watchdog+0x9c/0x600
[82195.623219]  #1:
[82195.623666]  (
[82195.624060] tasklist_lock
[82195.625208] ){.+.+..}
[82195.626213] , at:
[82195.626748] [<ffffffff8117576d>] debug_show_all_locks+0x3d/0x1a0
[82195.631513] 2 locks held by agetty/1149:
[82195.634160]  #0:
[82195.634610]  (
[82195.635001] &tty->ldisc_sem
[82195.636320] ){++++.+}
[82195.637323] , at:
[82195.637859] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82195.642077]  #1:
[82195.642528]  (
[82195.642922] &ldata->atomic_read_lock
[82195.645027] ){+.+...}
[82195.646030] , at:
[82195.646569] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82195.650442] 1 lock held by mission-control/1506:
[82195.653800]  #0:
[82195.654249]  (
[82195.654645] rtnl_mutex
[82195.655527] ){+.+.+.}
[82195.656534] , at:
[82195.657068] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82195.661113] 2 locks held by bash/1691:
[82195.663586]  #0:
[82195.664033]  (
[82195.664433] &tty->ldisc_sem
[82195.665750] ){++++.+}
[82195.666754] , at:
[82195.667294] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82195.671509]  #1:
[82195.671954]  (
[82195.672349] &ldata->atomic_read_lock
[82195.674447] ){+.+...}
[82195.675451] , at:
[82195.675987] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82195.679857] 1 lock held by evolution-calen/1768:
[82195.683200]  #0:
[82195.683649]  (
[82195.684040] rtnl_mutex
[82195.684925] ){+.+.+.}
[82195.685930] , at:
[82195.686467] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82195.690514] 2 locks held by hostapd/4100:
[82195.693249]  #0:
[82195.693694]  (
[82195.694090] cb_lock
[82195.694711] ){++++++}
[82195.695741] , at:
[82195.696279] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82195.699888]  #1:
[82195.700338]  (
[82195.700731] genl_mutex
[82195.701616] ){+.+.+.}
[82195.702619] , at:
[82195.703155] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82195.707113] 2 locks held by hostapd/4392:
[82195.709847]  #0:
[82195.710301]  (
[82195.710695] cb_lock
[82195.711317] ){++++++}
[82195.712324] , at:
[82195.712857] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82195.716467]  #1:
[82195.716911]  (
[82195.717306] genl_mutex
[82195.718186] ){+.+.+.}
[82195.719193] , at:
[82195.719727] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82195.723682] 3 locks held by wpa_supplicant/4574:
[82195.727028]  #0:
[82195.727480]  (
[82195.727871] cb_lock
[82195.728494] ){++++++}
[82195.729501] , at:
[82195.730034] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82195.733644]  #1:
[82195.734089]  (
[82195.734489] genl_mutex
[82195.735371] ){+.+.+.}
[82195.736377] , at:
[82195.736910] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82195.740867]  #2:
[82195.741316]  (
[82195.741712] rtnl_mutex
[82195.742595] ){+.+.+.}
[82195.743601] , at:
[82195.744135] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82195.747833] 2 locks held by hostapd/4733:
[82195.750566]  #0:
[82195.751014]  (
[82195.751409] cb_lock
[82195.752029] ){++++++}
[82195.753033] , at:
[82195.753570] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82195.757177]  #1:
[82195.757625]  (
[82195.758018] genl_mutex
[82195.758902] ){+.+.+.}
[82195.759905] , at:
[82195.760444] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82195.764400] 2 locks held by bash/5322:
[82195.766874]  #0:
[82195.767325]  (
[82195.767718] &tty->ldisc_sem
[82195.769036] ){++++.+}
[82195.770040] , at:
[82195.770580] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82195.774795]  #1:
[82195.775246]  (
[82195.775640] &ldata->atomic_read_lock
[82195.777738] ){+.+...}
[82195.778744] , at:
[82195.779283] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82195.783152] 2 locks held by bash/24789:
[82195.786358]  #0:
[82195.786802]  (
[82195.787198] &tty->ldisc_sem
[82195.788515] ){++++.+}
[82195.789519] , at:
[82195.790052] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82195.794271]  #1:
[82195.794718]  (
[82195.795109] &ldata->atomic_read_lock
[82195.797207] ){+.+...}
[82195.798212] , at:
[82195.798749] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82195.802624] 5 locks held by kworker/u8:1/1965:
[82195.805792]  #0:
[82195.806240]  (
[82195.806632] "%s"wiphy_name(local->hw.wiphy)
[82195.809338] ){++++.+}
[82195.810339] , at:
[82195.810877] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82195.815353]  #1:
[82195.815800]  (
[82195.816196] (&sdata->work)
[82195.817425] ){+.+.+.}
[82195.818430] , at:
[82195.818964] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82195.823443]  #2:
[82195.823890]  (
[82195.824290] &wdev->mtx
[82195.825170] ){+.+.+.}
[82195.826175] , at:
[82195.826753] [<ffffffffa0e65557>] ieee80211_sta_work+0x47/0x1b50 [mac80211]
[82195.832359]  #3:
[82195.832809]  (
[82195.833203] &local->sta_mtx
[82195.834519] ){+.+.+.}
[82195.835525] , at:
[82195.836072] [<ffffffffa0dffae6>] __sta_info_flush+0x86/0x190 [mac80211]
[82195.841418]  #4:
[82195.841863]  (
[82195.842258] &ar->conf_mutex
[82195.843578] ){+.+.+.}
[82195.844582] , at:
[82195.845129] [<ffffffffa12a3165>] ath10k_sta_state+0x205/0xbd0 [ath10k_core]
[82195.850823] 3 locks held by kworker/u8:3/2064:
[82195.853995]  #0:
[82195.854443]  (
[82195.854834] "%s""ath10k_wq"
[82195.856150] ){.+.+.+}
[82195.857151] , at:
[82195.857689] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82195.862166]  #1:
[82195.862614]  (
[82195.863008] (&(&ar->debug.nop_dwork)->work)
[82195.865714] ){+.+...}
[82195.866721] , at:
[82195.867264] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82195.871738]  #2:
[82195.872182]  (
[82195.872577] &ar->conf_mutex
[82195.873896] ){+.+.+.}
[82195.874899] , at:
[82195.875445] [<ffffffffa12acbb4>] ath10k_debug_nop_dwork+0x24/0x80 [ath10k_core]
[82195.881482] 4 locks held by kworker/0:2/2149:
[82195.884563]  #0:
[82195.885011]  (
[82195.885409] "events_freezable"
[82195.886986] ){.+.+..}
[82195.887990] , at:
[82195.888530] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82195.893006]  #1:
[82195.893455]  (
[82195.893846] (&local->restart_work)
[82195.895772] ){+.+...}
[82195.896773] , at:
[82195.897314] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82195.901790]  #2:
[82195.902242]  (
[82195.902633] rtnl_mutex
[82195.903517] ){+.+.+.}
[82195.904523] , at:
[82195.905057] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82195.908753]  #3:
[82195.909198]  (
[82195.909593] &ar->conf_mutex
[82195.910911] ){+.+.+.}
[82195.911915] , at:
[82195.912457] [<ffffffffa12a8686>] ath10k_start+0x26/0x5d0 [ath10k_core]
[82195.917716] 3 locks held by kworker/3:3/2153:
[82195.920797]  #0:
[82195.921251]  (
[82195.921645] "events"
[82195.922353] ){.+.+.+}
[82195.923354] , at:
[82195.923890] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82195.928366]  #1:
[82195.928813]  (
[82195.929204] (linkwatch_work).work
[82195.931043] ){+.+.+.}
[82195.932047] , at:
[82195.932584] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82195.937062]  #2:
[82195.937511]  (
[82195.937902] rtnl_mutex
[82195.938785] ){+.+.+.}
[82195.939791] , at:
[82195.940328] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82195.944024] 3 locks held by kworker/2:2/2984:
[82195.947106]  #0:
[82195.947555]  (
[82195.947946] "%s"("ipv6_addrconf")
[82195.949785] ){.+.+..}
[82195.950789] , at:
[82195.951326] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82195.955803]  #1:
[82195.956257]  (
[82195.956651] (addr_chk_work).work
[82195.958402] ){+.+...}
[82195.959406] , at:
[82195.959941] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82195.964419]  #2:
[82195.964867]  (
[82195.965267] rtnl_mutex
[82195.966146] ){+.+.+.}
[82195.967151] , at:
[82195.967688] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82195.971388] 1 lock held by ip/3840:
[82195.973602]  #0:
[82195.974049]  (
[82195.974447] rtnl_mutex
[82195.975331] ){+.+.+.}
[82195.976332] , at:
[82195.976867] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82195.980910] 1 lock held by ip/3843:
[82195.983121]  #0:
[82195.983572]  (
[82195.983963] rtnl_mutex
[82195.984847] ){+.+.+.}
[82195.985848] , at:
[82195.986385] [<ffffffff8186959e>] netlink_dump+0x1e/0x290
[82195.990430] 1 lock held by ip/3845:
[82195.992641]  #0:
[82195.993088]  (
[82195.993483] rtnl_mutex
[82195.994366] ){+.+.+.}
[82195.995368] , at:
[82195.995903] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30

[82196.000163] =============================================

[82196.004502] INFO: task evolution-calen:1768 blocked for more than 180 seconds.
[82196.010457]       Tainted: G        W       4.9.0-rc6+ #9
[82196.014591] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[82196.021147] evolution-calen D    0  1768      1 0x00000000
[82196.025724]  ffff8801ed8b1e00 000000000000f900 ffff880214de0000 ffff8801ef582640
[82196.031902]  ffff88021e2998d8 ffffc90003c5bc80 ffffffff819322eb 0000000000000006
[82196.038078]  ffff8801ef582e68 0000000003c5bc78 ffff88021e2998d8 0000000000000000
[82196.044255] Call Trace:
[82196.045430]  [<ffffffff819322eb>] ? __schedule+0x2fb/0xb30
[82196.049645]  [<ffffffff81932b58>] schedule+0x38/0x90
[82196.053337]  [<ffffffff81932f20>] schedule_preempt_disabled+0x10/0x20
[82196.058860]  [<ffffffff81934b15>] mutex_lock_nested+0x175/0x3f0
[82196.063507]  [<ffffffff81842df6>] ? rtnetlink_rcv+0x16/0x30
[82196.067811]  [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82196.071936]  [<ffffffff8186c76d>] netlink_unicast+0x1cd/0x2e0
[82196.076409]  [<ffffffff8186c6e9>] ? netlink_unicast+0x149/0x2e0
[82196.081054]  [<ffffffff8186cb62>] netlink_sendmsg+0x2e2/0x390
[82196.085526]  [<ffffffff812dcb98>] ? __fget+0x108/0x1f0
[82196.089746]  [<ffffffff8180ca73>] sock_sendmsg+0x33/0x40
[82196.093785]  [<ffffffff8180d041>] SYSC_sendto+0x101/0x190
[82196.097909]  [<ffffffff813ea076>] ? security_file_permission+0x96/0xb0
[82196.103166]  [<ffffffff812ba7e9>] ? rw_verify_area+0x49/0xb0
[82196.107553]  [<ffffffff811771d9>] ? trace_hardirqs_on_caller+0x129/0x1b0
[82196.112985]  [<ffffffff8100301a>] ? trace_hardirqs_on_thunk+0x1a/0x1c
[82196.118162]  [<ffffffff8180dee9>] SyS_sendto+0x9/0x10
[82196.122314]  [<ffffffff81939f45>] entry_SYSCALL_64_fastpath+0x23/0xc6
[82196.127481]
Showing all locks held in the system:
[82196.131118] 2 locks held by khungtaskd/37:
[82196.133939]  #0:
[82196.134391]  (
[82196.134785] rcu_read_lock
[82196.135930] ){......}
[82196.136935] , at:
[82196.137478] [<ffffffff811ebd5c>] watchdog+0x9c/0x600
[82196.141176]  #1:
[82196.141628]  (
[82196.142022] tasklist_lock
[82196.143166] ){.+.+..}
[82196.144172] , at:
[82196.144710] [<ffffffff8117576d>] debug_show_all_locks+0x3d/0x1a0
[82196.149456] 2 locks held by agetty/1149:
[82196.152104]  #0:
[82196.152555]  (
[82196.152951] &tty->ldisc_sem
[82196.154268] ){++++.+}
[82196.155273] , at:
[82196.155807] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82196.160025]  #1:
[82196.160477]  (
[82196.160871] &ldata->atomic_read_lock
[82196.162970] ){+.+...}
[82196.163975] , at:
[82196.164513] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82196.168388] 1 lock held by mission-control/1506:
[82196.171732]  #0:
[82196.172177]  (
[82196.172575] rtnl_mutex
[82196.173459] ){+.+.+.}
[82196.174463] , at:
[82196.174999] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82196.179044] 2 locks held by bash/1691:
[82196.181517]  #0:
[82196.181964]  (
[82196.182361] &tty->ldisc_sem
[82196.183677] ){++++.+}
[82196.184681] , at:
[82196.185217] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82196.189434]  #1:
[82196.189881]  (
[82196.190306] &ldata->atomic_read_lock
[82196.192407] ){+.+...}
[82196.193409] , at:
[82196.193942] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82196.197820] 1 lock held by evolution-calen/1768:
[82196.201163]  #0:
[82196.201612]  (
[82196.202008] rtnl_mutex
[82196.202889] ){+.+.+.}
[82196.203890] , at:
[82196.204428] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82196.208476] 2 locks held by hostapd/4100:
[82196.211211]  #0:
[82196.211661]  (
[82196.212054] cb_lock
[82196.212678] ){++++++}
[82196.213681] , at:
[82196.214214] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82196.217824]  #1:
[82196.218276]  (
[82196.218667] genl_mutex
[82196.219551] ){+.+.+.}
[82196.220578] , at:
[82196.221112] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82196.225075] 2 locks held by hostapd/4392:
[82196.227814]  #0:
[82196.228270]  (
[82196.228664] cb_lock
[82196.229289] ){++++++}
[82196.230297] , at:
[82196.230833] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82196.234443]  #1:
[82196.234891]  (
[82196.235291] genl_mutex
[82196.236171] ){+.+.+.}
[82196.237176] , at:
[82196.237711] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82196.241666] 3 locks held by wpa_supplicant/4574:
[82196.245011]  #0:
[82196.245463]  (
[82196.245854] cb_lock
[82196.246479] ){++++++}
[82196.247483] , at:
[82196.248016] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82196.251627]  #1:
[82196.252072]  (
[82196.252471] genl_mutex
[82196.253360] ){+.+.+.}
[82196.254365] , at:
[82196.254899] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82196.258856]  #2:
[82196.259308]  (
[82196.259704] rtnl_mutex
[82196.260588] ){+.+.+.}
[82196.261592] , at:
[82196.262125] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82196.265826] 2 locks held by hostapd/4733:
[82196.268561]  #0:
[82196.269006]  (
[82196.269405] cb_lock
[82196.270024] ){++++++}
[82196.271032] , at:
[82196.271572] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82196.275181]  #1:
[82196.275630]  (
[82196.276021] genl_mutex
[82196.276905] ){+.+.+.}
[82196.277908] , at:
[82196.278445] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82196.282403] 2 locks held by bash/5322:
[82196.284879]  #0:
[82196.285328]  (
[82196.285719] &tty->ldisc_sem
[82196.287038] ){++++.+}
[82196.288042] , at:
[82196.288580] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82196.292798]  #1:
[82196.293245]  (
[82196.293641] &ldata->atomic_read_lock
[82196.295741] ){+.+...}
[82196.296743] , at:
[82196.297283] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82196.301151] 2 locks held by bash/24789:
[82196.303712]  #0:
[82196.304156]  (
[82196.304552] &tty->ldisc_sem
[82196.305869] ){++++.+}
[82196.306875] , at:
[82196.307413] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82196.311631]  #1:
[82196.312078]  (
[82196.313123] &ldata->atomic_read_lock
[82196.315221] ){+.+...}
[82196.316227] , at:
[82196.316765] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82196.320638] 5 locks held by kworker/u8:1/1965:
[82196.323806]  #0:
[82196.324250]  (
[82196.324651] "%s"wiphy_name(local->hw.wiphy)
[82196.327365] ){++++.+}
[82196.328367] , at:
[82196.328902] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82196.333378]  #1:
[82196.333822]  (
[82196.334219] (&sdata->work)
[82196.335449] ){+.+.+.}
[82196.336453] , at:
[82196.336986] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82196.341464]  #2:
[82196.341913]  (
[82196.342312] &wdev->mtx
[82196.343191] ){+.+.+.}
[82196.344196] , at:
[82196.344784] [<ffffffffa0e65557>] ieee80211_sta_work+0x47/0x1b50 [mac80211]
[82196.350397]  #3:
[82196.350844]  (
[82196.351238] &local->sta_mtx
[82196.352558] ){+.+.+.}
[82196.353560] , at:
[82196.354107] [<ffffffffa0dffae6>] __sta_info_flush+0x86/0x190 [mac80211]
[82196.359455]  #4:
[82196.359900]  (
[82196.360300] &ar->conf_mutex
[82196.361617] ){+.+.+.}
[82196.362621] , at:
[82196.363162] [<ffffffffa12a3165>] ath10k_sta_state+0x205/0xbd0 [ath10k_core]
[82196.368860] 3 locks held by kworker/u8:3/2064:
[82196.372030]  #0:
[82196.372479]  (
[82196.372873] "%s""ath10k_wq"
[82196.374192] ){.+.+.+}
[82196.375196] , at:
[82196.375734] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82196.380221]  #1:
[82196.380674]  (
[82196.381068] (&(&ar->debug.nop_dwork)->work)
[82196.383774] ){+.+...}
[82196.384778] , at:
[82196.385316] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82196.389793]  #2:
[82196.390240]  (
[82196.390635] &ar->conf_mutex
[82196.391954] ){+.+.+.}
[82196.392959] , at:
[82196.393510] [<ffffffffa12acbb4>] ath10k_debug_nop_dwork+0x24/0x80 [ath10k_core]
[82196.399551] 4 locks held by kworker/0:2/2149:
[82196.402635]  #0:
[82196.403080]  (
[82196.403480] "events_freezable"
[82196.405057] ){.+.+..}
[82196.406062] , at:
[82196.406601] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82196.411079]  #1:
[82196.411531]  (
[82196.411925] (&local->restart_work)
[82196.413853] ){+.+...}
[82196.414858] , at:
[82196.415397] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82196.419874]  #2:
[82196.420327]  (
[82196.420720] rtnl_mutex
[82196.421606] ){+.+.+.}
[82196.422611] , at:
[82196.423145] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82196.426841]  #3:
[82196.427290]  (
[82196.427686] &ar->conf_mutex
[82196.429008] ){+.+.+.}
[82196.430012] , at:
[82196.430555] [<ffffffffa12a8686>] ath10k_start+0x26/0x5d0 [ath10k_core]
[82196.435814] 3 locks held by kworker/3:3/2153:
[82196.438895]  #0:
[82196.439345]  (
[82196.439741] "events"
[82196.440449] ){.+.+.+}
[82196.441455] , at:
[82196.441989] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82196.446468]  #1:
[82196.446916]  (
[82196.447315] (linkwatch_work).work
[82196.449154] ){+.+.+.}
[82196.450156] , at:
[82196.450694] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82196.455171]  #2:
[82196.455626]  (
[82196.456020] rtnl_mutex
[82196.456903] ){+.+.+.}
[82196.457908] , at:
[82196.458446] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82196.462143] 3 locks held by kworker/2:2/2984:
[82196.465225]  #0:
[82196.465676]  (
[82196.466069] "%s"("ipv6_addrconf")
[82196.467909] ){.+.+..}
[82196.468916] , at:
[82196.469454] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82196.473931]  #1:
[82196.474385]  (
[82196.474778] (addr_chk_work).work
[82196.476529] ){+.+...}
[82196.477534] , at:
[82196.478067] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82196.482547]  #2:
[82196.482994]  (
[82196.483392] rtnl_mutex
[82196.484272] ){+.+.+.}
[82196.485279] , at:
[82196.485820] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82196.489517] 1 lock held by ip/3840:
[82196.491731]  #0:
[82196.492175]  (
[82196.492574] rtnl_mutex
[82196.493458] ){+.+.+.}
[82196.494463] , at:
[82196.494996] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82196.499043] 1 lock held by ip/3843:
[82196.501257]  #0:
[82196.501708]  (
[82196.502105] rtnl_mutex
[82196.502987] ){+.+.+.}
[82196.503991] , at:
[82196.504530] [<ffffffff8186959e>] netlink_dump+0x1e/0x290
[82196.508573] 1 lock held by ip/3845:
[82196.510794]  #0:
[82196.511242]  (
[82196.511641] rtnl_mutex
[82196.512525] ){+.+.+.}
[82196.513530] , at:
[82196.514064] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30

[82196.518327] =============================================

[82196.522664] INFO: task hostapd:4100 blocked for more than 180 seconds.
[82196.527934]       Tainted: G        W       4.9.0-rc6+ #9
[82196.532058] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[82196.538618] hostapd         D    0  4100      1 0x00000000
[82196.542867]  ffff8802114d6900 0000000000004d8e ffffffff81e11580 ffff880211e04c80
[82196.549068]  ffff88021e2198d8 ffffc900099ffb40 ffffffff819322eb 0000000000000006
[82196.555252]  ffff880211e054a8 00000000099ffb38 ffff88021e2198d8 0000000000000000
[82196.561441] Call Trace:
[82196.562618]  [<ffffffff819322eb>] ? __schedule+0x2fb/0xb30
[82196.566831]  [<ffffffff81932b58>] schedule+0x38/0x90
[82196.570522]  [<ffffffff81932f20>] schedule_preempt_disabled+0x10/0x20
[82196.575710]  [<ffffffff81934b15>] mutex_lock_nested+0x175/0x3f0
[82196.580356]  [<ffffffff8186d8d4>] ? genl_rcv_msg+0xa4/0xb0
[82196.584574]  [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82196.588613]  [<ffffffff8186d830>] ? genl_family_rcv_msg+0x370/0x370
[82196.593636]  [<ffffffff8186cddf>] netlink_rcv_skb+0x9f/0xc0
[82196.597937]  [<ffffffff8186d4a3>] genl_rcv+0x23/0x40
[82196.601629]  [<ffffffff8186c76d>] netlink_unicast+0x1cd/0x2e0
[82196.606099]  [<ffffffff8186c6e9>] ? netlink_unicast+0x149/0x2e0
[82196.610746]  [<ffffffff8186cb62>] netlink_sendmsg+0x2e2/0x390
[82196.615237]  [<ffffffff8180ca73>] sock_sendmsg+0x33/0x40
[82196.619298]  [<ffffffff8180d55b>] ___sys_sendmsg+0x2db/0x2f0
[82196.623685]  [<ffffffff81172eba>] ? up_write+0x1a/0x40
[82196.627556]  [<ffffffff81357048>] ? ext4_file_write_iter+0x88/0x340
[82196.632565]  [<ffffffff81195c0d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[82196.637908]  [<ffffffff8180e170>] __sys_sendmsg+0x40/0x70
[82196.642034]  [<ffffffff8180e1ad>] SyS_sendmsg+0xd/0x20
[82196.645900]  [<ffffffff81939f45>] entry_SYSCALL_64_fastpath+0x23/0xc6
[82196.651066]
Showing all locks held in the system:
[82196.654718] 2 locks held by khungtaskd/37:
[82196.657540]  #0:
[82196.657985]  (
[82196.658385] rcu_read_lock
[82196.659530] ){......}
[82196.660534] , at:
[82196.661069] [<ffffffff811ebd5c>] watchdog+0x9c/0x600
[82196.664770]  #1:
[82196.665219]  (
[82196.665617] tasklist_lock
[82196.666760] ){.+.+..}
[82196.667766] , at:
[82196.668306] [<ffffffff8117576d>] debug_show_all_locks+0x3d/0x1a0
[82196.673057] 2 locks held by agetty/1149:
[82196.675706]  #0:
[82196.676168]  (
[82196.676586] &tty->ldisc_sem
[82196.677905] ){++++.+}
[82196.678911] , at:
[82196.679450] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82196.683669]  #1:
[82196.684114]  (
[82196.684511] &ldata->atomic_read_lock
[82196.686613] ){+.+...}
[82196.687616] , at:
[82196.688150] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82196.692028] 1 lock held by mission-control/1506:
[82196.695369]  #0:
[82196.695814]  (
[82196.696211] rtnl_mutex
[82196.697092] ){+.+.+.}
[82196.698093] , at:
[82196.698633] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82196.702680] 2 locks held by bash/1691:
[82196.705156]  #0:
[82196.705607]  (
[82196.706003] &tty->ldisc_sem
[82196.707326] ){++++.+}
[82196.708330] , at:
[82196.708864] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82196.713106]  #1:
[82196.713576]  (
[82196.713970] &ldata->atomic_read_lock
[82196.716070] ){+.+...}
[82196.717074] , at:
[82196.717612] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82196.721500] 1 lock held by evolution-calen/1768:
[82196.724845]  #0:
[82196.725293]  (
[82196.725692] rtnl_mutex
[82196.726576] ){+.+.+.}
[82196.727580] , at:
[82196.728117] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82196.732162] 2 locks held by hostapd/4100:
[82196.734897]  #0:
[82196.735347]  (
[82196.735742] cb_lock
[82196.736364] ){++++++}
[82196.737364] , at:
[82196.737900] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82196.741517]  #1:
[82196.741964]  (
[82196.742363] genl_mutex
[82196.743243] ){+.+.+.}
[82196.744248] , at:
[82196.744785] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82196.748743] 2 locks held by hostapd/4392:
[82196.751478]  #0:
[82196.751925]  (
[82196.752330] cb_lock
[82196.752947] ){++++++}
[82196.753960] , at:
[82196.754499] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82196.758107]  #1:
[82196.758559]  (
[82196.758950] genl_mutex
[82196.759833] ){+.+.+.}
[82196.760839] , at:
[82196.761376] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82196.765335] 3 locks held by wpa_supplicant/4574:
[82196.768678]  #0:
[82196.769123]  (
[82196.769518] cb_lock
[82196.770137] ){++++++}
[82196.771139] , at:
[82196.771676] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82196.775285]  #1:
[82196.775736]  (
[82196.776133] genl_mutex
[82196.777026] ){+.+.+.}
[82196.778027] , at:
[82196.778573] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82196.782527]  #2:
[82196.782972]  (
[82196.783367] rtnl_mutex
[82196.784247] ){+.+.+.}
[82196.785254] , at:
[82196.785793] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82196.789491] 2 locks held by hostapd/4733:
[82196.792224]  #0:
[82196.792673]  (
[82196.793067] cb_lock
[82196.793687] ){++++++}
[82196.794688] , at:
[82196.795224] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82196.798834]  #1:
[82196.799278]  (
[82196.799679] genl_mutex
[82196.800560] ){+.+.+.}
[82196.801560] , at:
[82196.802096] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82196.806053] 2 locks held by bash/5322:
[82196.808524]  #0:
[82196.808971]  (
[82196.809365] &tty->ldisc_sem
[82196.810684] ){++++.+}
[82196.811687] , at:
[82196.812224] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82196.816440]  #1:
[82196.816888]  (
[82196.817278] &ldata->atomic_read_lock
[82196.819377] ){+.+...}
[82196.820380] , at:
[82196.820917] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82196.824787] 2 locks held by bash/24789:
[82196.827352]  #0:
[82196.827800]  (
[82196.828196] &tty->ldisc_sem
[82196.829512] ){++++.+}
[82196.830516] , at:
[82196.831050] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82196.835268]  #1:
[82196.835719]  (
[82196.836112] &ldata->atomic_read_lock
[82196.838209] ){+.+...}
[82196.839214] , at:
[82196.839751] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82196.844271] 5 locks held by kworker/u8:1/1965:
[82196.847439]  #0:
[82196.847884]  (
[82196.848280] "%s"wiphy_name(local->hw.wiphy)
[82196.850986] ){++++.+}
[82196.851987] , at:
[82196.852525] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82196.857004]  #1:
[82196.857456]  (
[82196.857852] (&sdata->work)
[82196.859082] ){+.+.+.}
[82196.860086] , at:
[82196.860624] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82196.865102]  #2:
[82196.865554]  (
[82196.865945] &wdev->mtx
[82196.866829] ){+.+.+.}
[82196.867833] , at:
[82196.868406] [<ffffffffa0e65557>] ieee80211_sta_work+0x47/0x1b50 [mac80211]
[82196.874011]  #3:
[82196.874463]  (
[82196.874854] &local->sta_mtx
[82196.876172] ){+.+.+.}
[82196.877176] , at:
[82196.877728] [<ffffffffa0dffae6>] __sta_info_flush+0x86/0x190 [mac80211]
[82196.883073]  #4:
[82196.883524]  (
[82196.883915] &ar->conf_mutex
[82196.885234] ){+.+.+.}
[82196.886237] , at:
[82196.886785] [<ffffffffa12a3165>] ath10k_sta_state+0x205/0xbd0 [ath10k_core]
[82196.892478] 3 locks held by kworker/u8:3/2064:
[82196.895645]  #0:
[82196.896092]  (
[82196.896490] "%s""ath10k_wq"
[82196.897807] ){.+.+.+}
[82196.898811] , at:
[82196.899351] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82196.903827]  #1:
[82196.904272]  (
[82196.904667] (&(&ar->debug.nop_dwork)->work)
[82196.907377] ){+.+...}
[82196.908379] , at:
[82196.908916] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82196.913391]  #2:
[82196.913835]  (
[82196.914231] &ar->conf_mutex
[82196.915548] ){+.+.+.}
[82196.916552] , at:
[82196.917093] [<ffffffffa12acbb4>] ath10k_debug_nop_dwork+0x24/0x80 [ath10k_core]
[82196.923133] 4 locks held by kworker/0:2/2149:
[82196.926216]  #0:
[82196.926666]  (
[82196.927057] "events_freezable"
[82196.928635] ){.+.+..}
[82196.929639] , at:
[82196.930172] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82196.934651]  #1:
[82196.935098]  (
[82196.935498] (&local->restart_work)
[82196.937423] ){+.+...}
[82196.938427] , at:
[82196.938960] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82196.943457]  #2:
[82196.943904]  (
[82196.944297] rtnl_mutex
[82196.945182] ){+.+.+.}
[82196.946188] , at:
[82196.946726] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82196.950419]  #3:
[82196.950866]  (
[82196.951257] &ar->conf_mutex
[82196.952575] ){+.+.+.}
[82196.953580] , at:
[82196.954118] [<ffffffffa12a8686>] ath10k_start+0x26/0x5d0 [ath10k_core]
[82196.959380] 3 locks held by kworker/3:3/2153:
[82196.962463]  #0:
[82196.962908]  (
[82196.963299] "events"
[82196.964010] ){.+.+.+}
[82196.965014] , at:
[82196.965554] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82196.970029]  #1:
[82196.970478]  (
[82196.970872] (linkwatch_work).work
[82196.972713] ){+.+.+.}
[82196.973716] , at:
[82196.974250] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82196.978727]  #2:
[82196.979172]  (
[82196.979569] rtnl_mutex
[82196.980456] ){+.+.+.}
[82196.981459] , at:
[82196.981993] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82196.985692] 3 locks held by kworker/2:2/2984:
[82196.988776]  #0:
[82196.989221]  (
[82196.989618] "%s"("ipv6_addrconf")
[82196.991457] ){.+.+..}
[82196.992460] , at:
[82196.992996] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82196.997474]  #1:
[82196.997921]  (
[82196.998318] (addr_chk_work).work
[82197.000069] ){+.+...}
[82197.001073] , at:
[82197.001610] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82197.006086]  #2:
[82197.006535]  (
[82197.006926] rtnl_mutex
[82197.007811] ){+.+.+.}
[82197.008814] , at:
[82197.009355] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82197.013051] 1 lock held by ip/3840:
[82197.015265]  #0:
[82197.015716]  (
[82197.016110] rtnl_mutex
[82197.016997] ){+.+.+.}
[82197.018000] , at:
[82197.018540] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82197.022583] 1 lock held by ip/3843:
[82197.024794]  #0:
[82197.025241]  (
[82197.025636] rtnl_mutex
[82197.026519] ){+.+.+.}
[82197.027521] , at:
[82197.028057] [<ffffffff8186959e>] netlink_dump+0x1e/0x290
[82197.032098] 1 lock held by ip/3845:
[82197.034322]  #0:
[82197.034772]  (
[82197.035165] rtnl_mutex
[82197.036049] ){+.+.+.}
[82197.037050] , at:
[82197.037587] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30

[82197.041839] =============================================

[82197.046175] INFO: task hostapd:4392 blocked for more than 180 seconds.
[82197.051436]       Tainted: G        W       4.9.0-rc6+ #9
[82197.055562] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[82197.062118] hostapd         D    0  4392      1 0x00000000
[82197.066349]  ffff8802114d2800 0000000000000249 ffff880214de0000 ffff8801ed8f8000
[82197.072535]  ffff88021e2998d8 ffffc90009e6bb40 ffffffff819322eb 0000000000000006
[82197.078711]  ffff8801ed8f8828 0000000009e6bb38 ffff88021e2998d8 0000000000000000
[82197.084886] Call Trace:
[82197.086083]  [<ffffffff819322eb>] ? __schedule+0x2fb/0xb30
[82197.090669]  [<ffffffff81932b58>] schedule+0x38/0x90
[82197.094362]  [<ffffffff81932f20>] schedule_preempt_disabled+0x10/0x20
[82197.099528]  [<ffffffff81934b15>] mutex_lock_nested+0x175/0x3f0
[82197.104173]  [<ffffffff8186d8d4>] ? genl_rcv_msg+0xa4/0xb0
[82197.108390]  [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82197.112429]  [<ffffffff8186d830>] ? genl_family_rcv_msg+0x370/0x370
[82197.117424]  [<ffffffff8186cddf>] netlink_rcv_skb+0x9f/0xc0
[82197.121722]  [<ffffffff8186d4a3>] genl_rcv+0x23/0x40
[82197.125412]  [<ffffffff8186c76d>] netlink_unicast+0x1cd/0x2e0
[82197.129887]  [<ffffffff8186c6e9>] ? netlink_unicast+0x149/0x2e0
[82197.134535]  [<ffffffff8186cb62>] netlink_sendmsg+0x2e2/0x390
[82197.139378]  [<ffffffff8180ca73>] sock_sendmsg+0x33/0x40
[82197.143418]  [<ffffffff8180d55b>] ___sys_sendmsg+0x2db/0x2f0
[82197.147805]  [<ffffffff81172eba>] ? up_write+0x1a/0x40
[82197.151679]  [<ffffffff81357048>] ? ext4_file_write_iter+0x88/0x340
[82197.156677]  [<ffffffff81195c0d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[82197.162018]  [<ffffffff8180e170>] __sys_sendmsg+0x40/0x70
[82197.166147]  [<ffffffff8180e1ad>] SyS_sendmsg+0xd/0x20
[82197.170011]  [<ffffffff81939f45>] entry_SYSCALL_64_fastpath+0x23/0xc6
[82197.175176]
Showing all locks held in the system:
[82197.178808] 2 locks held by khungtaskd/37:
[82197.181630]  #0:
[82197.182078]  (
[82197.182473] rcu_read_lock
[82197.183618] ){......}
[82197.184622] , at:
[82197.185159] [<ffffffff811ebd5c>] watchdog+0x9c/0x600
[82197.188863]  #1:
[82197.189311]  (
[82197.189711] tasklist_lock
[82197.190855] ){.+.+..}
[82197.191859] , at:
[82197.192397] [<ffffffff8117576d>] debug_show_all_locks+0x3d/0x1a0
[82197.197144] 2 locks held by agetty/1149:
[82197.199793]  #0:
[82197.200240]  (
[82197.200638] &tty->ldisc_sem
[82197.201957] ){++++.+}
[82197.202961] , at:
[82197.203499] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82197.207717]  #1:
[82197.208164]  (
[82197.208560] &ldata->atomic_read_lock
[82197.210659] ){+.+...}
[82197.211661] , at:
[82197.212195] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82197.216074] 1 lock held by mission-control/1506:
[82197.219419]  #0:
[82197.219863]  (
[82197.220254] rtnl_mutex
[82197.221139] ){+.+.+.}
[82197.222143] , at:
[82197.222683] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82197.226726] 2 locks held by bash/1691:
[82197.229202]  #0:
[82197.229651]  (
[82197.230043] &tty->ldisc_sem
[82197.231363] ){++++.+}
[82197.232368] , at:
[82197.232905] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82197.237130]  #1:
[82197.237579]  (
[82197.237974] &ldata->atomic_read_lock
[82197.240073] ){+.+...}
[82197.241077] , at:
[82197.241615] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82197.245485] 1 lock held by evolution-calen/1768:
[82197.248828]  #0:
[82197.249273]  (
[82197.249668] rtnl_mutex
[82197.250552] ){+.+.+.}
[82197.251557] , at:
[82197.252090] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82197.256139] 2 locks held by hostapd/4100:
[82197.258872]  #0:
[82197.259317]  (
[82197.259713] cb_lock
[82197.260333] ){++++++}
[82197.261338] , at:
[82197.261875] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82197.265486]  #1:
[82197.265934]  (
[82197.266334] genl_mutex
[82197.267221] ){+.+.+.}
[82197.268228] , at:
[82197.268766] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82197.272723] 2 locks held by hostapd/4392:
[82197.275459]  #0:
[82197.275907]  (
[82197.276308] cb_lock
[82197.276933] ){++++++}
[82197.277937] , at:
[82197.278477] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82197.282085]  #1:
[82197.282535]  (
[82197.282926] genl_mutex
[82197.283809] ){+.+.+.}
[82197.284816] , at:
[82197.285349] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82197.289315] 3 locks held by wpa_supplicant/4574:
[82197.292662]  #0:
[82197.293109]  (
[82197.293507] cb_lock
[82197.294127] ){++++++}
[82197.295134] , at:
[82197.295675] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82197.299283]  #1:
[82197.299733]  (
[82197.300124] genl_mutex
[82197.301014] ){+.+.+.}
[82197.302019] , at:
[82197.302557] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82197.306511]  #2:
[82197.306958]  (
[82197.307359] rtnl_mutex
[82197.308240] ){+.+.+.}
[82197.309248] , at:
[82197.309788] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82197.313486] 2 locks held by hostapd/4733:
[82197.316221]  #0:
[82197.316672]  (
[82197.317068] cb_lock
[82197.317690] ){++++++}
[82197.318692] , at:
[82197.319225] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82197.322835]  #1:
[82197.323280]  (
[82197.323676] genl_mutex
[82197.324559] ){+.+.+.}
[82197.325566] , at:
[82197.326099] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82197.330059] 2 locks held by bash/5322:
[82197.332533]  #0:
[82197.332978]  (
[82197.333379] &tty->ldisc_sem
[82197.334698] ){++++.+}
[82197.335699] , at:
[82197.336235] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82197.340455]  #1:
[82197.340903]  (
[82197.341294] &ldata->atomic_read_lock
[82197.343393] ){+.+...}
[82197.344398] , at:
[82197.344932] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82197.348804] 2 locks held by bash/24789:
[82197.351369]  #0:
[82197.351815]  (
[82197.352211] &tty->ldisc_sem
[82197.353529] ){++++.+}
[82197.354531] , at:
[82197.355065] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82197.359283]  #1:
[82197.359737]  (
[82197.360130] &ldata->atomic_read_lock
[82197.362230] ){+.+...}
[82197.363234] , at:
[82197.363772] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82197.367651] 5 locks held by kworker/u8:1/1965:
[82197.370825]  #0:
[82197.371272]  (
[82197.372317] "%s"wiphy_name(local->hw.wiphy)
[82197.375026] ){++++.+}
[82197.376030] , at:
[82197.376567] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82197.381045]  #1:
[82197.381497]  (
[82197.381888] (&sdata->work)
[82197.383119] ){+.+.+.}
[82197.384124] , at:
[82197.384662] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82197.389139]  #2:
[82197.389588]  (
[82197.389982] &wdev->mtx
[82197.390866] ){+.+.+.}
[82197.391872] , at:
[82197.392435] [<ffffffffa0e65557>] ieee80211_sta_work+0x47/0x1b50 [mac80211]
[82197.398042]  #3:
[82197.398492]  (
[82197.398887] &local->sta_mtx
[82197.400205] ){+.+.+.}
[82197.401209] , at:
[82197.401760] [<ffffffffa0dffae6>] __sta_info_flush+0x86/0x190 [mac80211]
[82197.407107]  #4:
[82197.407557]  (
[82197.407953] &ar->conf_mutex
[82197.409270] ){+.+.+.}
[82197.410274] , at:
[82197.410818] [<ffffffffa12a3165>] ath10k_sta_state+0x205/0xbd0 [ath10k_core]
[82197.416513] 3 locks held by kworker/u8:3/2064:
[82197.419684]  #0:
[82197.420132]  (
[82197.420533] "%s""ath10k_wq"
[82197.421854] ){.+.+.+}
[82197.422859] , at:
[82197.423397] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82197.427874]  #1:
[82197.428321]  (
[82197.428717] (&(&ar->debug.nop_dwork)->work)
[82197.431423] ){+.+...}
[82197.432425] , at:
[82197.432961] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82197.437439]  #2:
[82197.437884]  (
[82197.438275] &ar->conf_mutex
[82197.439595] ){+.+.+.}
[82197.440598] , at:
[82197.441137] [<ffffffffa12acbb4>] ath10k_debug_nop_dwork+0x24/0x80 [ath10k_core]
[82197.447178] 4 locks held by kworker/0:2/2149:
[82197.450265]  #0:
[82197.450717]  (
[82197.451111] "events_freezable"
[82197.452690] ){.+.+..}
[82197.453694] , at:
[82197.454228] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82197.458707]  #1:
[82197.459152]  (
[82197.459548] (&local->restart_work)
[82197.461474] ){+.+...}
[82197.462478] , at:
[82197.463012] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82197.467488]  #2:
[82197.467936]  (
[82197.468330] rtnl_mutex
[82197.469215] ){+.+.+.}
[82197.470220] , at:
[82197.470758] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82197.474454]  #3:
[82197.474899]  (
[82197.475290] &ar->conf_mutex
[82197.476607] ){+.+.+.}
[82197.477612] , at:
[82197.478152] [<ffffffffa12a8686>] ath10k_start+0x26/0x5d0 [ath10k_core]
[82197.483413] 3 locks held by kworker/3:3/2153:
[82197.486497]  #0:
[82197.486945]  (
[82197.487336] "events"
[82197.488048] ){.+.+.+}
[82197.489052] , at:
[82197.489590] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82197.494068]  #1:
[82197.494521]  (
[82197.494917] (linkwatch_work).work
[82197.496766] ){+.+.+.}
[82197.497771] , at:
[82197.498305] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82197.502782]  #2:
[82197.503230]  (
[82197.503626] rtnl_mutex
[82197.504510] ){+.+.+.}
[82197.505515] , at:
[82197.506048] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82197.509746] 3 locks held by kworker/2:2/2984:
[82197.512830]  #0:
[82197.513275]  (
[82197.513673] "%s"("ipv6_addrconf")
[82197.515513] ){.+.+..}
[82197.516517] , at:
[82197.517051] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82197.521531]  #1:
[82197.521976]  (
[82197.522372] (addr_chk_work).work
[82197.524128] ){+.+...}
[82197.525141] , at:
[82197.525683] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82197.530160]  #2:
[82197.530612]  (
[82197.531005] rtnl_mutex
[82197.531889] ){+.+.+.}
[82197.532893] , at:
[82197.533429] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82197.537128] 1 lock held by ip/3840:
[82197.539344]  #0:
[82197.539794]  (
[82197.540190] rtnl_mutex
[82197.541072] ){+.+.+.}
[82197.542078] , at:
[82197.542616] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82197.546660] 1 lock held by ip/3843:
[82197.548874]  #0:
[82197.549322]  (
[82197.549718] rtnl_mutex
[82197.550602] ){+.+.+.}
[82197.551609] , at:
[82197.552147] [<ffffffff8186959e>] netlink_dump+0x1e/0x290
[82197.556190] 1 lock held by ip/3845:
[82197.558411]  #0:
[82197.558859]  (
[82197.559249] rtnl_mutex
[82197.560134] ){+.+.+.}
[82197.561140] , at:
[82197.561679] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30

[82197.565933] =============================================

[82197.570269] INFO: task wpa_supplicant:4574 blocked for more than 180 seconds.
[82197.576194]       Tainted: G        W       4.9.0-rc6+ #9
[82197.580317] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[82197.586875] wpa_supplicant  D    0  4574      1 0x00000000
[82197.591104]  ffff8801ed8b1400 000000000000edfb ffff880214de0000 ffff88020f462640
[82197.597301]  ffff88021e2998d8 ffffc9000a397a70 ffffffff819322eb 0000000000000006
[82197.603500]  ffff88020f462e68 000000000a397a68 ffff88021e2998d8 0000000000000000
[82197.609677] Call Trace:
[82197.610851]  [<ffffffff819322eb>] ? __schedule+0x2fb/0xb30
[82197.615062]  [<ffffffff81932b58>] schedule+0x38/0x90
[82197.618753]  [<ffffffff81932f20>] schedule_preempt_disabled+0x10/0x20
[82197.623922]  [<ffffffff81934b15>] mutex_lock_nested+0x175/0x3f0
[82197.628568]  [<ffffffff81841882>] ? rtnl_lock+0x12/0x20
[82197.632525]  [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82197.636334]  [<ffffffffa06d5f22>] nl80211_pre_doit+0xd2/0x1b0 [cfg80211]
[82197.641780]  [<ffffffff8186d63c>] genl_family_rcv_msg+0x17c/0x370
[82197.646600]  [<ffffffff8117726d>] ? trace_hardirqs_on+0xd/0x10
[82197.651156]  [<ffffffff8186d8a8>] genl_rcv_msg+0x78/0xb0
[82197.655194]  [<ffffffff8186d830>] ? genl_family_rcv_msg+0x370/0x370
[82197.660189]  [<ffffffff8186cddf>] netlink_rcv_skb+0x9f/0xc0
[82197.664486]  [<ffffffff8186d4a3>] genl_rcv+0x23/0x40
[82197.668176]  [<ffffffff8186c76d>] netlink_unicast+0x1cd/0x2e0
[82197.672662]  [<ffffffff8186c6e9>] ? netlink_unicast+0x149/0x2e0
[82197.677311]  [<ffffffff8186cb62>] netlink_sendmsg+0x2e2/0x390
[82197.681786]  [<ffffffff8180ca73>] sock_sendmsg+0x33/0x40
[82197.685827]  [<ffffffff8180d55b>] ___sys_sendmsg+0x2db/0x2f0
[82197.690216]  [<ffffffff81195c0d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[82197.695557]  [<ffffffff812685ae>] ? __might_fault+0x3e/0x90
[82197.699876]  [<ffffffff812685ae>] ? __might_fault+0x3e/0x90
[82197.704175]  [<ffffffff81904e87>] ? unix_ioctl+0x77/0x80
[82197.708215]  [<ffffffff8180a480>] ? sock_do_ioctl+0x20/0x50
[82197.712517]  [<ffffffff8180ab38>] ? sock_ioctl+0x208/0x2d0
[82197.716728]  [<ffffffff8180e170>] __sys_sendmsg+0x40/0x70
[82197.720853]  [<ffffffff8180e1ad>] SyS_sendmsg+0xd/0x20
[82197.724720]  [<ffffffff81939f45>] entry_SYSCALL_64_fastpath+0x23/0xc6
[82197.729888]
Showing all locks held in the system:
[82197.733521] 2 locks held by khungtaskd/37:
[82197.736345]  #0:
[82197.736795]  (
[82197.737190] rcu_read_lock
[82197.738334] ){......}
[82197.739337] , at:
[82197.739878] [<ffffffff811ebd5c>] watchdog+0x9c/0x600
[82197.743605]  #1:
[82197.744052]  (
[82197.744453] tasklist_lock
[82197.745599] ){.+.+..}
[82197.746606] , at:
[82197.747140] [<ffffffff8117576d>] debug_show_all_locks+0x3d/0x1a0
[82197.751888] 2 locks held by agetty/1149:
[82197.754533]  #0:
[82197.754981]  (
[82197.755372] &tty->ldisc_sem
[82197.756689] ){++++.+}
[82197.757692] , at:
[82197.758228] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82197.762450]  #1:
[82197.762898]  (
[82197.763294] &ldata->atomic_read_lock
[82197.765398] ){+.+...}
[82197.766403] , at:
[82197.766938] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82197.770835] 1 lock held by mission-control/1506:
[82197.774179]  #0:
[82197.774628]  (
[82197.775024] rtnl_mutex
[82197.775907] ){+.+.+.}
[82197.776914] , at:
[82197.777455] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82197.781511] 2 locks held by bash/1691:
[82197.783987]  #0:
[82197.784438]  (
[82197.784832] &tty->ldisc_sem
[82197.786151] ){++++.+}
[82197.787154] , at:
[82197.787692] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82197.791909]  #1:
[82197.792354]  (
[82197.792749] &ldata->atomic_read_lock
[82197.794849] ){+.+...}
[82197.795851] , at:
[82197.796387] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82197.800256] 1 lock held by evolution-calen/1768:
[82197.803603]  #0:
[82197.804051]  (
[82197.804448] rtnl_mutex
[82197.805330] ){+.+.+.}
[82197.806335] , at:
[82197.806872] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82197.810915] 2 locks held by hostapd/4100:
[82197.813650]  #0:
[82197.814096]  (
[82197.814492] cb_lock
[82197.815112] ){++++++}
[82197.816115] , at:
[82197.816651] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82197.820260]  #1:
[82197.820711]  (
[82197.821108] genl_mutex
[82197.821989] ){+.+.+.}
[82197.822989] , at:
[82197.823529] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82197.827485] 2 locks held by hostapd/4392:
[82197.830218]  #0:
[82197.830672]  (
[82197.831065] cb_lock
[82197.831687] ){++++++}
[82197.832687] , at:
[82197.833223] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82197.836833]  #1:
[82197.837278]  (
[82197.837675] genl_mutex
[82197.838561] ){+.+.+.}
[82197.839572] , at:
[82197.840108] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82197.844067] 3 locks held by wpa_supplicant/4574:
[82197.847410]  #0:
[82197.847859]  (
[82197.848250] cb_lock
[82197.848874] ){++++++}
[82197.849877] , at:
[82197.850417] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82197.854025]  #1:
[82197.854476]  (
[82197.854872] genl_mutex
[82197.855755] ){+.+.+.}
[82197.856758] , at:
[82197.857294] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82197.861249]  #2:
[82197.861698]  (
[82197.862092] rtnl_mutex
[82197.862977] ){+.+.+.}
[82197.863978] , at:
[82197.864515] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82197.868209] 2 locks held by hostapd/4733:
[82197.870943]  #0:
[82197.871387]  (
[82197.871783] cb_lock
[82197.872402] ){++++++}
[82197.873413] , at:
[82197.873947] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82197.877554]  #1:
[82197.878000]  (
[82197.878391] genl_mutex
[82197.879275] ){+.+.+.}
[82197.880281] , at:
[82197.880828] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82197.884784] 2 locks held by bash/5322:
[82197.887256]  #0:
[82197.887705]  (
[82197.888099] &tty->ldisc_sem
[82197.889417] ){++++.+}
[82197.890425] , at:
[82197.890960] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82197.895176]  #1:
[82197.895627]  (
[82197.896018] &ldata->atomic_read_lock
[82197.898117] ){+.+...}
[82197.899120] , at:
[82197.899658] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82197.903548] 2 locks held by bash/24789:
[82197.906113]  #0:
[82197.906564]  (
[82197.906957] &tty->ldisc_sem
[82197.908273] ){++++.+}
[82197.909276] , at:
[82197.909817] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82197.914676]  #1:
[82197.915123]  (
[82197.915518] &ldata->atomic_read_lock
[82197.917618] ){+.+...}
[82197.918621] , at:
[82197.919154] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82197.923029] 5 locks held by kworker/u8:1/1965:
[82197.926195]  #0:
[82197.926643]  (
[82197.927037] "%s"wiphy_name(local->hw.wiphy)
[82197.929742] ){++++.+}
[82197.930745] , at:
[82197.931279] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82197.935755]  #1:
[82197.936200]  (
[82197.936600] (&sdata->work)
[82197.937831] ){+.+.+.}
[82197.938834] , at:
[82197.939370] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82197.943864]  #2:
[82197.944311]  (
[82197.944706] &wdev->mtx
[82197.945590] ){+.+.+.}
[82197.946590] , at:
[82197.947160] [<ffffffffa0e65557>] ieee80211_sta_work+0x47/0x1b50 [mac80211]
[82197.952766]  #3:
[82197.953213]  (
[82197.953611] &local->sta_mtx
[82197.954929] ){+.+.+.}
[82197.955932] , at:
[82197.956485] [<ffffffffa0dffae6>] __sta_info_flush+0x86/0x190 [mac80211]
[82197.961829]  #4:
[82197.962276]  (
[82197.962671] &ar->conf_mutex
[82197.963989] ){+.+.+.}
[82197.964995] , at:
[82197.965541] [<ffffffffa12a3165>] ath10k_sta_state+0x205/0xbd0 [ath10k_core]
[82197.971233] 3 locks held by kworker/u8:3/2064:
[82197.974402]  #0:
[82197.974851]  (
[82197.975244] "%s""ath10k_wq"
[82197.976561] ){.+.+.+}
[82197.977565] , at:
[82197.978101] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82197.982578]  #1:
[82197.983025]  (
[82197.983424] (&(&ar->debug.nop_dwork)->work)
[82197.986131] ){+.+...}
[82197.987132] , at:
[82197.987670] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82197.992147]  #2:
[82197.992596]  (
[82197.992987] &ar->conf_mutex
[82197.994305] ){+.+.+.}
[82197.995308] , at:
[82197.995853] [<ffffffffa12acbb4>] ath10k_debug_nop_dwork+0x24/0x80 [ath10k_core]
[82198.001892] 4 locks held by kworker/0:2/2149:
[82198.004973]  #0:
[82198.005423]  (
[82198.005818] "events_freezable"
[82198.007396] ){.+.+..}
[82198.008400] , at:
[82198.008938] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82198.013414]  #1:
[82198.013863]  (
[82198.014255] (&local->restart_work)
[82198.016181] ){+.+...}
[82198.017184] , at:
[82198.017722] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82198.022202]  #2:
[82198.022649]  (
[82198.023042] rtnl_mutex
[82198.023924] ){+.+.+.}
[82198.024927] , at:
[82198.025463] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82198.029160]  #3:
[82198.029613]  (
[82198.030007] &ar->conf_mutex
[82198.031326] ){+.+.+.}
[82198.032332] , at:
[82198.032880] [<ffffffffa12a8686>] ath10k_start+0x26/0x5d0 [ath10k_core]
[82198.038139] 3 locks held by kworker/3:3/2153:
[82198.041222]  #0:
[82198.041676]  (
[82198.042070] "events"
[82198.042782] ){.+.+.+}
[82198.043786] , at:
[82198.044320] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82198.048800]  #1:
[82198.049246]  (
[82198.049646] (linkwatch_work).work
[82198.051490] ){+.+.+.}
[82198.052497] , at:
[82198.053031] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82198.057510]  #2:
[82198.057957]  (
[82198.058351] rtnl_mutex
[82198.059238] ){+.+.+.}
[82198.060245] , at:
[82198.060788] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82198.064488] 3 locks held by kworker/2:2/2984:
[82198.067571]  #0:
[82198.068016]  (
[82198.068413] "%s"("ipv6_addrconf")
[82198.070258] ){.+.+..}
[82198.071265] , at:
[82198.071808] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82198.076287]  #1:
[82198.076741]  (
[82198.077136] (addr_chk_work).work
[82198.078892] ){+.+...}
[82198.079899] , at:
[82198.080442] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82198.084919]  #2:
[82198.085367]  (
[82198.085766] rtnl_mutex
[82198.086651] ){+.+.+.}
[82198.087657] , at:
[82198.088193] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82198.091893] 1 lock held by ip/3840:
[82198.094110]  #0:
[82198.094562]  (
[82198.094958] rtnl_mutex
[82198.095847] ){+.+.+.}
[82198.096851] , at:
[82198.097385] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82198.101432] 1 lock held by ip/3843:
[82198.103651]  #0:
[82198.104100]  (
[82198.104499] rtnl_mutex
[82198.105380] ){+.+.+.}
[82198.106387] , at:
[82198.106930] [<ffffffff8186959e>] netlink_dump+0x1e/0x290
[82198.110974] 1 lock held by ip/3845:
[82198.113192]  #0:
[82198.113643]  (
[82198.114036] rtnl_mutex
[82198.114922] ){+.+.+.}
[82198.115928] , at:
[82198.116470] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30

[82198.120727] =============================================

[82198.125246] INFO: task hostapd:4733 blocked for more than 180 seconds.
[82198.130511]       Tainted: G        W       4.9.0-rc6+ #9
[82198.134637] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[82198.141190] hostapd         D    0  4733      1 0x00000000
[82198.145419]  ffff8802114d3700 000000000000d4bf ffff880214de0000 ffff8801f1ca8000
[82198.151603]  ffff88021e2998d8 ffffc9000a5ffb40 ffffffff819322eb 0000000000000006
[82198.157785]  ffff8801f1ca8828 000000000a5ffb38 ffff88021e2998d8 0000000000000000
[82198.163963] Call Trace:
[82198.165138]  [<ffffffff819322eb>] ? __schedule+0x2fb/0xb30
[82198.169348]  [<ffffffff81932b58>] schedule+0x38/0x90
[82198.173040]  [<ffffffff81932f20>] schedule_preempt_disabled+0x10/0x20
[82198.178581]  [<ffffffff81934b15>] mutex_lock_nested+0x175/0x3f0
[82198.183231]  [<ffffffff8186d8d4>] ? genl_rcv_msg+0xa4/0xb0
[82198.187459]  [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82198.191504]  [<ffffffff8186d830>] ? genl_family_rcv_msg+0x370/0x370
[82198.196509]  [<ffffffff8186cddf>] netlink_rcv_skb+0x9f/0xc0
[82198.200809]  [<ffffffff8186d4a3>] genl_rcv+0x23/0x40
[82198.204499]  [<ffffffff8186c76d>] netlink_unicast+0x1cd/0x2e0
[82198.208974]  [<ffffffff8186c6e9>] ? netlink_unicast+0x149/0x2e0
[82198.213624]  [<ffffffff8186cb62>] netlink_sendmsg+0x2e2/0x390
[82198.218099]  [<ffffffff8180ca73>] sock_sendmsg+0x33/0x40
[82198.222136]  [<ffffffff8180d55b>] ___sys_sendmsg+0x2db/0x2f0
[82198.226523]  [<ffffffff81172eba>] ? up_write+0x1a/0x40
[82198.230391]  [<ffffffff81357048>] ? ext4_file_write_iter+0x88/0x340
[82198.235387]  [<ffffffff81195c0d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[82198.241083]  [<ffffffff8180e170>] __sys_sendmsg+0x40/0x70
[82198.245211]  [<ffffffff8180e1ad>] SyS_sendmsg+0xd/0x20
[82198.249075]  [<ffffffff81939f45>] entry_SYSCALL_64_fastpath+0x23/0xc6
[82198.254241]
Showing all locks held in the system:
[82198.257876] 2 locks held by khungtaskd/37:
[82198.260698]  #0:
[82198.261143]  (
[82198.261544] rcu_read_lock
[82198.262692] ){......}
[82198.263696] , at:
[82198.264232] [<ffffffff811ebd5c>] watchdog+0x9c/0x600
[82198.267927]  #1:
[82198.268374]  (
[82198.268770] tasklist_lock
[82198.269914] ){.+.+..}
[82198.270919] , at:
[82198.271459] [<ffffffff8117576d>] debug_show_all_locks+0x3d/0x1a0
[82198.276203] 2 locks held by agetty/1149:
[82198.278852]  #0:
[82198.279299]  (
[82198.279700] &tty->ldisc_sem
[82198.281017] ){++++.+}
[82198.282020] , at:
[82198.282558] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82198.286775]  #1:
[82198.287219]  (
[82198.287618] &ldata->atomic_read_lock
[82198.289719] ){+.+...}
[82198.290723] , at:
[82198.291257] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82198.295134] 1 lock held by mission-control/1506:
[82198.298476]  #0:
[82198.298921]  (
[82198.299317] rtnl_mutex
[82198.300203] ){+.+.+.}
[82198.301209] , at:
[82198.301747] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82198.305792] 2 locks held by bash/1691:
[82198.308266]  #0:
[82198.308718]  (
[82198.309114] &tty->ldisc_sem
[82198.310435] ){++++.+}
[82198.311441] , at:
[82198.311983] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82198.316207]  #1:
[82198.316660]  (
[82198.317057] &ldata->atomic_read_lock
[82198.319153] ){+.+...}
[82198.320158] , at:
[82198.320696] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82198.324567] 1 lock held by evolution-calen/1768:
[82198.327911]  #0:
[82198.328356]  (
[82198.328752] rtnl_mutex
[82198.329635] ){+.+.+.}
[82198.330639] , at:
[82198.331172] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82198.335221] 2 locks held by hostapd/4100:
[82198.337954]  #0:
[82198.338399]  (
[82198.338813] cb_lock
[82198.339432] ){++++++}
[82198.340437] , at:
[82198.340975] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82198.344585]  #1:
[82198.345030]  (
[82198.345421] genl_mutex
[82198.346306] ){+.+.+.}
[82198.347310] , at:
[82198.347847] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82198.351804] 2 locks held by hostapd/4392:
[82198.354538]  #0:
[82198.354983]  (
[82198.355379] cb_lock
[82198.356001] ){++++++}
[82198.357002] , at:
[82198.357539] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82198.361149]  #1:
[82198.361599]  (
[82198.361991] genl_mutex
[82198.362875] ){+.+.+.}
[82198.363880] , at:
[82198.364414] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82198.368373] 3 locks held by wpa_supplicant/4574:
[82198.371714]  #0:
[82198.372161]  (
[82198.372560] cb_lock
[82198.373180] ){++++++}
[82198.374185] , at:
[82198.374723] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82198.378332]  #1:
[82198.378782]  (
[82198.379175] genl_mutex
[82198.380059] ){+.+.+.}
[82198.381066] , at:
[82198.381604] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82198.385560]  #2:
[82198.386005]  (
[82198.386401] rtnl_mutex
[82198.387283] ){+.+.+.}
[82198.388284] , at:
[82198.388821] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82198.392520] 2 locks held by hostapd/4733:
[82198.395258]  #0:
[82198.395708]  (
[82198.396101] cb_lock
[82198.396726] ){++++++}
[82198.397730] , at:
[82198.398266] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82198.401874]  #1:
[82198.402318]  (
[82198.402714] genl_mutex
[82198.403598] ){+.+.+.}
[82198.404602] , at:
[82198.405138] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82198.409094] 2 locks held by bash/5322:
[82198.411571]  #0:
[82198.412018]  (
[82198.412412] &tty->ldisc_sem
[82198.413729] ){++++.+}
[82198.414735] , at:
[82198.415269] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82198.419487]  #1:
[82198.419935]  (
[82198.420329] &ldata->atomic_read_lock
[82198.422428] ){+.+...}
[82198.423433] , at:
[82198.423970] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82198.427840] 2 locks held by bash/24789:
[82198.430403]  #0:
[82198.430855]  (
[82198.431248] &tty->ldisc_sem
[82198.432568] ){++++.+}
[82198.433570] , at:
[82198.434106] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82198.438322]  #1:
[82198.438776]  (
[82198.439169] &ldata->atomic_read_lock
[82198.441270] ){+.+...}
[82198.442919] , at:
[82198.443453] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82198.447342] 5 locks held by kworker/u8:1/1965:
[82198.450512]  #0:
[82198.450959]  (
[82198.451350] "%s"wiphy_name(local->hw.wiphy)
[82198.454057] ){++++.+}
[82198.455059] , at:
[82198.455598] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82198.460074]  #1:
[82198.460527]  (
[82198.460932] (&sdata->work)
[82198.462167] ){+.+.+.}
[82198.463172] , at:
[82198.463710] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82198.468186]  #2:
[82198.468635]  (
[82198.469029] &wdev->mtx
[82198.469913] ){+.+.+.}
[82198.470920] , at:
[82198.471487] [<ffffffffa0e65557>] ieee80211_sta_work+0x47/0x1b50 [mac80211]
[82198.477106]  #3:
[82198.477556]  (
[82198.477947] &local->sta_mtx
[82198.479266] ){+.+.+.}
[82198.480270] , at:
[82198.480821] [<ffffffffa0dffae6>] __sta_info_flush+0x86/0x190 [mac80211]
[82198.486165]  #4:
[82198.486617]  (
[82198.487008] &ar->conf_mutex
[82198.488327] ){+.+.+.}
[82198.489332] , at:
[82198.489877] [<ffffffffa12a3165>] ath10k_sta_state+0x205/0xbd0 [ath10k_core]
[82198.495570] 3 locks held by kworker/u8:3/2064:
[82198.498739]  #0:
[82198.499184]  (
[82198.499585] "%s""ath10k_wq"
[82198.500904] ){.+.+.+}
[82198.501911] , at:
[82198.502444] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82198.506921]  #1:
[82198.507370]  (
[82198.507771] (&(&ar->debug.nop_dwork)->work)
[82198.510480] ){+.+...}
[82198.511487] , at:
[82198.512021] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82198.516500]  #2:
[82198.516945]  (
[82198.517336] &ar->conf_mutex
[82198.518655] ){+.+.+.}
[82198.519659] , at:
[82198.520201] [<ffffffffa12acbb4>] ath10k_debug_nop_dwork+0x24/0x80 [ath10k_core]
[82198.526242] 4 locks held by kworker/0:2/2149:
[82198.529326]  #0:
[82198.529776]  (
[82198.530167] "events_freezable"
[82198.531746] ){.+.+..}
[82198.532748] , at:
[82198.533284] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82198.537762]  #1:
[82198.538209]  (
[82198.538608] (&local->restart_work)
[82198.540537] ){+.+...}
[82198.541543] , at:
[82198.542077] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82198.546554]  #2:
[82198.547001]  (
[82198.547395] rtnl_mutex
[82198.548280] ){+.+.+.}
[82198.549284] , at:
[82198.549824] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82198.553519]  #3:
[82198.553964]  (
[82198.554355] &ar->conf_mutex
[82198.555674] ){+.+.+.}
[82198.556677] , at:
[82198.557216] [<ffffffffa12a8686>] ath10k_start+0x26/0x5d0 [ath10k_core]
[82198.562479] 3 locks held by kworker/3:3/2153:
[82198.565563]  #0:
[82198.566011]  (
[82198.566407] "events"
[82198.567122] ){.+.+.+}
[82198.568126] , at:
[82198.568666] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82198.573148]  #1:
[82198.573598]  (
[82198.573989] (linkwatch_work).work
[82198.575827] ){+.+.+.}
[82198.576831] , at:
[82198.577365] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82198.581846]  #2:
[82198.582291]  (
[82198.582690] rtnl_mutex
[82198.583574] ){+.+.+.}
[82198.584578] , at:
[82198.585114] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82198.588810] 3 locks held by kworker/2:2/2984:
[82198.591894]  #0:
[82198.592339]  (
[82198.592740] "%s"("ipv6_addrconf")
[82198.594582] ){.+.+..}
[82198.595586] , at:
[82198.596120] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82198.600603]  #1:
[82198.601049]  (
[82198.601445] (addr_chk_work).work
[82198.603198] ){+.+...}
[82198.604203] , at:
[82198.604744] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82198.609219]  #2:
[82198.609671]  (
[82198.610062] rtnl_mutex
[82198.610947] ){+.+.+.}
[82198.611951] , at:
[82198.612491] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82198.616188] 1 lock held by ip/3840:
[82198.618404]  #0:
[82198.618853]  (
[82198.619244] rtnl_mutex
[82198.620128] ){+.+.+.}
[82198.621135] , at:
[82198.621672] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82198.625726] 1 lock held by ip/3843:
[82198.627941]  #0:
[82198.628386]  (
[82198.628782] rtnl_mutex
[82198.629665] ){+.+.+.}
[82198.630672] , at:
[82198.631207] [<ffffffff8186959e>] netlink_dump+0x1e/0x290
[82198.635251] 1 lock held by ip/3845:
[82198.637470]  #0:
[82198.637920]  (
[82198.638311] rtnl_mutex
[82198.639195] ){+.+.+.}
[82198.640200] , at:
[82198.640737] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30

[82198.644997] =============================================

[82198.649338] INFO: task kworker/u8:1:1965 blocked for more than 180 seconds.
[82198.655030]       Tainted: G        W       4.9.0-rc6+ #9
[82198.659158] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[82198.665739] kworker/u8:1    D    0  1965      2 0x00000000
[82198.669993] Workqueue: phy0 ieee80211_iface_work [mac80211]
[82198.674305]  ffff8802114d6900 000000000000abfd ffffffff81e11580 ffff8801f1c0a640
[82198.680525]  ffff88021e2198d8 ffffc9000e6a3990 ffffffff819322eb 0000000000000006
[82198.686705]  ffff8801f1c0ae68 000000000e6a3988 ffff88021e2198d8 0000000000000000
[82198.692880] Call Trace:
[82198.694054]  [<ffffffff819322eb>] ? __schedule+0x2fb/0xb30
[82198.698266]  [<ffffffff81932b58>] schedule+0x38/0x90
[82198.701974]  [<ffffffff81932f20>] schedule_preempt_disabled+0x10/0x20
[82198.707140]  [<ffffffff81934b15>] mutex_lock_nested+0x175/0x3f0
[82198.711796]  [<ffffffffa12a3165>] ? ath10k_sta_state+0x205/0xbd0 [ath10k_core]
[82198.717750]  [<ffffffffa12a3165>] ath10k_sta_state+0x205/0xbd0 [ath10k_core]
[82198.723545]  [<ffffffffa0df5d7f>] drv_sta_state+0xaf/0xa30 [mac80211]
[82198.728742]  [<ffffffffa0dfe7d0>] sta_info_move_state+0x2a0/0x3c0 [mac80211]
[82198.734529]  [<ffffffffa0dff6ab>] __sta_info_destroy_part2+0x7b/0x230 [mac80211]
[82198.740663]  [<ffffffffa0dffb5b>] __sta_info_flush+0xfb/0x190 [mac80211]
[82198.746110]  [<ffffffffa0e61096>] ieee80211_set_disassoc+0xc6/0x430 [mac80211]
[82198.752087]  [<ffffffffa0e61433>] ieee80211_sta_connection_lost+0x33/0x70 [mac80211]
[82198.758592]  [<ffffffffa0e65c69>] ieee80211_sta_work+0x759/0x1b50 [mac80211]
[82198.764368]  [<ffffffff8117707f>] ? mark_held_locks+0x6f/0xa0
[82198.768858]  [<ffffffff8193981e>] ? _raw_spin_unlock_irqrestore+0x4e/0x70
[82198.774372]  [<ffffffff8117726d>] ? trace_hardirqs_on+0xd/0x10
[82198.778947]  [<ffffffffa0e143d3>] ieee80211_iface_work+0x373/0x410 [mac80211]
[82198.784810]  [<ffffffff8113a804>] ? process_one_work+0x164/0x740
[82198.789545]  [<ffffffff8113a883>] process_one_work+0x1e3/0x740
[82198.794103]  [<ffffffff8113a804>] ? process_one_work+0x164/0x740
[82198.798835]  [<ffffffff8113ae26>] worker_thread+0x46/0x4f0
[82198.803066]  [<ffffffff8113ade0>] ? process_one_work+0x740/0x740
[82198.807800]  [<ffffffff8114166a>] kthread+0xfa/0x110
[82198.811493]  [<ffffffff81141570>] ? kthread_park+0x60/0x60
[82198.815712]  [<ffffffff8193a1ea>] ret_from_fork+0x2a/0x40
[82198.819837]
Showing all locks held in the system:
[82198.823469] 2 locks held by khungtaskd/37:
[82198.826309]  #0:
[82198.826762]  (
[82198.827157] rcu_read_lock
[82198.828301] ){......}
[82198.829305] , at:
[82198.829844] [<ffffffff811ebd5c>] watchdog+0x9c/0x600
[82198.833539]  #1:
[82198.833984]  (
[82198.834375] tasklist_lock
[82198.835519] ){.+.+..}
[82198.836526] , at:
[82198.837060] [<ffffffff8117576d>] debug_show_all_locks+0x3d/0x1a0
[82198.841813] 2 locks held by agetty/1149:
[82198.844464]  #0:
[82198.844915]  (
[82198.845309] &tty->ldisc_sem
[82198.846627] ){++++.+}
[82198.847631] , at:
[82198.848164] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82198.852381]  #1:
[82198.852832]  (
[82198.853225] &ldata->atomic_read_lock
[82198.855325] ){+.+...}
[82198.856328] , at:
[82198.856867] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82198.860743] 1 lock held by mission-control/1506:
[82198.864086]  #0:
[82198.864537]  (
[82198.864929] rtnl_mutex
[82198.865813] ){+.+.+.}
[82198.866817] , at:
[82198.867353] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82198.871407] 2 locks held by bash/1691:
[82198.873879]  #0:
[82198.874327]  (
[82198.874722] &tty->ldisc_sem
[82198.876041] ){++++.+}
[82198.877043] , at:
[82198.877583] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82198.881799]  #1:
[82198.882244]  (
[82198.882644] &ldata->atomic_read_lock
[82198.884743] ){+.+...}
[82198.885746] , at:
[82198.886280] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82198.890149] 1 lock held by evolution-calen/1768:
[82198.893488]  #0:
[82198.893937]  (
[82198.894331] rtnl_mutex
[82198.895214] ){+.+.+.}
[82198.896218] , at:
[82198.896757] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82198.900800] 2 locks held by hostapd/4100:
[82198.903538]  #0:
[82198.903985]  (
[82198.904386] cb_lock
[82198.905010] ){++++++}
[82198.906017] , at:
[82198.906554] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82198.910163]  #1:
[82198.910612]  (
[82198.911006] genl_mutex
[82198.911887] ){+.+.+.}
[82198.912888] , at:
[82198.913423] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82198.917382] 2 locks held by hostapd/4392:
[82198.920116]  #0:
[82198.920565]  (
[82198.920958] cb_lock
[82198.921579] ){++++++}
[82198.922580] , at:
[82198.923116] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82198.926727]  #1:
[82198.927175]  (
[82198.927570] genl_mutex
[82198.928450] ){+.+.+.}
[82198.929456] , at:
[82198.929991] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82198.933949] 3 locks held by wpa_supplicant/4574:
[82198.937289]  #0:
[82198.937740]  (
[82198.938134] cb_lock
[82198.938757] ){++++++}
[82198.939759] , at:
[82198.940292] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82198.943903]  #1:
[82198.944351]  (
[82198.944745] genl_mutex
[82198.945631] ){+.+.+.}
[82198.946635] , at:
[82198.947170] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82198.951126]  #2:
[82198.951575]  (
[82198.951965] rtnl_mutex
[82198.952849] ){+.+.+.}
[82198.953850] , at:
[82198.954386] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82198.958082] 2 locks held by hostapd/4733:
[82198.960818]  #0:
[82198.961265]  (
[82198.961664] cb_lock
[82198.962284] ){++++++}
[82198.963288] , at:
[82198.963826] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82198.967437]  #1:
[82198.967886]  (
[82198.968280] genl_mutex
[82198.969163] ){+.+.+.}
[82198.970164] , at:
[82198.970704] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82198.974662] 2 locks held by bash/5322:
[82198.977138]  #0:
[82198.977587]  (
[82198.977978] &tty->ldisc_sem
[82198.979295] ){++++.+}
[82198.980299] , at:
[82198.980839] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82198.985056]  #1:
[82198.985500]  (
[82198.985900] &ldata->atomic_read_lock
[82198.987997] ){+.+...}
[82198.989002] , at:
[82198.989541] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82198.993409] 2 locks held by bash/24789:
[82198.995969]  #0:
[82198.996416]  (
[82198.997455] &tty->ldisc_sem
[82198.998773] ){++++.+}
[82198.999777] , at:
[82199.000313] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82199.004534]  #1:
[82199.004983]  (
[82199.005377] &ldata->atomic_read_lock
[82199.007476] ){+.+...}
[82199.008480] , at:
[82199.009018] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82199.012891] 5 locks held by kworker/u8:1/1965:
[82199.016057]  #0:
[82199.016504]  (
[82199.016905] "%s"wiphy_name(local->hw.wiphy)
[82199.019615] ){++++.+}
[82199.020621] , at:
[82199.021155] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82199.025633]  #1:
[82199.026080]  (
[82199.026471] (&sdata->work)
[82199.027702] ){+.+.+.}
[82199.028706] , at:
[82199.029242] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82199.033719]  #2:
[82199.034167]  (
[82199.034564] &wdev->mtx
[82199.035444] ){+.+.+.}
[82199.036446] , at:
[82199.037006] [<ffffffffa0e65557>] ieee80211_sta_work+0x47/0x1b50 [mac80211]
[82199.042610]  #3:
[82199.043059]  (
[82199.043455] &local->sta_mtx
[82199.044775] ){+.+.+.}
[82199.045779] , at:
[82199.046328] [<ffffffffa0dffae6>] __sta_info_flush+0x86/0x190 [mac80211]
[82199.051671]  #4:
[82199.052119]  (
[82199.052520] &ar->conf_mutex
[82199.053839] ){+.+.+.}
[82199.054845] , at:
[82199.055384] [<ffffffffa12a3165>] ath10k_sta_state+0x205/0xbd0 [ath10k_core]
[82199.061077] 3 locks held by kworker/u8:3/2064:
[82199.064243]  #0:
[82199.064692]  (
[82199.065086] "%s""ath10k_wq"
[82199.066402] ){.+.+.+}
[82199.067406] , at:
[82199.067944] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82199.072422]  #1:
[82199.072871]  (
[82199.073265] (&(&ar->debug.nop_dwork)->work)
[82199.075972] ){+.+...}
[82199.076973] , at:
[82199.077510] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82199.081989]  #2:
[82199.082434]  (
[82199.082832] &ar->conf_mutex
[82199.084150] ){+.+.+.}
[82199.085154] , at:
[82199.085698] [<ffffffffa12acbb4>] ath10k_debug_nop_dwork+0x24/0x80 [ath10k_core]
[82199.091736] 4 locks held by kworker/0:2/2149:
[82199.094817]  #0:
[82199.095265]  (
[82199.095663] "events_freezable"
[82199.097240] ){.+.+..}
[82199.098247] , at:
[82199.098784] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82199.103261]  #1:
[82199.103710]  (
[82199.104101] (&local->restart_work)
[82199.106027] ){+.+...}
[82199.107029] , at:
[82199.107567] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82199.112044]  #2:
[82199.112489]  (
[82199.112884] rtnl_mutex
[82199.113768] ){+.+.+.}
[82199.114771] , at:
[82199.115307] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82199.119002]  #3:
[82199.119449]  (
[82199.119848] &ar->conf_mutex
[82199.121166] ){+.+.+.}
[82199.122169] , at:
[82199.122711] [<ffffffffa12a8686>] ath10k_start+0x26/0x5d0 [ath10k_core]
[82199.127968] 3 locks held by kworker/3:3/2153:
[82199.131048]  #0:
[82199.131496]  (
[82199.131894] "events"
[82199.132607] ){.+.+.+}
[82199.133609] , at:
[82199.134143] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82199.138623]  #1:
[82199.139070]  (
[82199.139463] (linkwatch_work).work
[82199.141302] ){+.+.+.}
[82199.142306] , at:
[82199.142844] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82199.147321]  #2:
[82199.147770]  (
[82199.148161] rtnl_mutex
[82199.149044] ){+.+.+.}
[82199.150048] , at:
[82199.150587] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82199.154284] 3 locks held by kworker/2:2/2984:
[82199.157363]  #0:
[82199.157815]  (
[82199.158210] "%s"("ipv6_addrconf")
[82199.160049] ){.+.+..}
[82199.161052] , at:
[82199.161590] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82199.166067]  #1:
[82199.166511]  (
[82199.166909] (addr_chk_work).work
[82199.168663] ){+.+...}
[82199.169666] , at:
[82199.170201] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82199.174678]  #2:
[82199.175126]  (
[82199.175527] rtnl_mutex
[82199.176410] ){+.+.+.}
[82199.177415] , at:
[82199.177952] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82199.181649] 1 lock held by ip/3840:
[82199.183860]  #0:
[82199.184307]  (
[82199.184702] rtnl_mutex
[82199.185586] ){+.+.+.}
[82199.186587] , at:
[82199.187120] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82199.191166] 1 lock held by ip/3843:
[82199.193381]  #0:
[82199.193832]  (
[82199.194228] rtnl_mutex
[82199.195110] ){+.+.+.}
[82199.196111] , at:
[82199.196650] [<ffffffff8186959e>] netlink_dump+0x1e/0x290
[82199.200692] 1 lock held by ip/3845:
[82199.202905]  #0:
[82199.203353]  (
[82199.203750] rtnl_mutex
[82199.204637] ){+.+.+.}
[82199.205642] , at:
[82199.206175] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30

[82199.210434] =============================================

[82199.214770] INFO: task kworker/u8:3:2064 blocked for more than 180 seconds.
[82199.220464]       Tainted: G        W       4.9.0-rc6+ #9
[82199.224590] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[82199.231148] kworker/u8:3    D    0  2064      2 0x00000000
[82199.235388] Workqueue: ath10k_wq ath10k_debug_nop_dwork [ath10k_core]
[82199.240577]  ffff880210f72d00 000000000000402d ffff880214de4c80 ffff880210c3cc80
[82199.246767]  ffff88021e3998d8 ffffc9000e7d3cd0 ffffffff819322eb 0000000000000006
[82199.252950]  ffff880210c3d4a8 000000000e7d3cc8 ffff88021e3998d8 0000000000000000
[82199.259135] Call Trace:
[82199.260313]  [<ffffffff819322eb>] ? __schedule+0x2fb/0xb30
[82199.264540]  [<ffffffff81932b58>] schedule+0x38/0x90
[82199.268232]  [<ffffffff81932f20>] schedule_preempt_disabled+0x10/0x20
[82199.273408]  [<ffffffff81934b15>] mutex_lock_nested+0x175/0x3f0
[82199.278444]  [<ffffffffa12acbb4>] ? ath10k_debug_nop_dwork+0x24/0x80 [ath10k_core]
[82199.284757]  [<ffffffffa12acbb4>] ath10k_debug_nop_dwork+0x24/0x80 [ath10k_core]
[82199.290889]  [<ffffffff8113a883>] process_one_work+0x1e3/0x740
[82199.295457]  [<ffffffff8113a804>] ? process_one_work+0x164/0x740
[82199.300197]  [<ffffffff8113ae26>] worker_thread+0x46/0x4f0
[82199.304418]  [<ffffffff8113ade0>] ? process_one_work+0x740/0x740
[82199.309157]  [<ffffffff8114166a>] kthread+0xfa/0x110
[82199.312851]  [<ffffffff81141570>] ? kthread_park+0x60/0x60
[82199.317071]  [<ffffffff8193a1ea>] ret_from_fork+0x2a/0x40
[82199.321203]
Showing all locks held in the system:
[82199.324841] 2 locks held by khungtaskd/37:
[82199.327667]  #0:
[82199.328116]  (
[82199.328510] rcu_read_lock
[82199.329657] ){......}
[82199.330665] , at:
[82199.331203] [<ffffffff811ebd5c>] watchdog+0x9c/0x600
[82199.334900]  #1:
[82199.335346]  (
[82199.335748] tasklist_lock
[82199.336898] ){.+.+..}
[82199.337905] , at:
[82199.338443] [<ffffffff8117576d>] debug_show_all_locks+0x3d/0x1a0
[82199.343193] 2 locks held by agetty/1149:
[82199.345845]  #0:
[82199.346293]  (
[82199.346692] &tty->ldisc_sem
[82199.348018] ){++++.+}
[82199.349023] , at:
[82199.349564] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82199.353782]  #1:
[82199.354230]  (
[82199.354628] &ldata->atomic_read_lock
[82199.356734] ){+.+...}
[82199.357743] , at:
[82199.358280] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82199.362162] 1 lock held by mission-control/1506:
[82199.365510]  #0:
[82199.365963]  (
[82199.366356] rtnl_mutex
[82199.367241] ){+.+.+.}
[82199.368246] , at:
[82199.368784] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82199.372829] 2 locks held by bash/1691:
[82199.375305]  #0:
[82199.375762]  (
[82199.376158] &tty->ldisc_sem
[82199.377477] ){++++.+}
[82199.378485] , at:
[82199.379026] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82199.383249]  #1:
[82199.383701]  (
[82199.384096] &ldata->atomic_read_lock
[82199.386198] ){+.+...}
[82199.387205] , at:
[82199.387746] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82199.391616] 1 lock held by evolution-calen/1768:
[82199.394963]  #0:
[82199.395411]  (
[82199.395812] rtnl_mutex
[82199.396700] ){+.+.+.}
[82199.397708] , at:
[82199.398244] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82199.402292] 2 locks held by hostapd/4100:
[82199.405033]  #0:
[82199.405480]  (
[82199.405890] cb_lock
[82199.406511] ){++++++}
[82199.407521] , at:
[82199.408062] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82199.411675]  #1:
[82199.412122]  (
[82199.412518] genl_mutex
[82199.413402] ){+.+.+.}
[82199.414409] , at:
[82199.414950] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82199.418910] 2 locks held by hostapd/4392:
[82199.421649]  #0:
[82199.422097]  (
[82199.422493] cb_lock
[82199.423117] ){++++++}
[82199.424121] , at:
[82199.424660] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82199.428269]  #1:
[82199.428719]  (
[82199.429112] genl_mutex
[82199.429997] ){+.+.+.}
[82199.431003] , at:
[82199.431537] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82199.435501] 3 locks held by wpa_supplicant/4574:
[82199.438843]  #0:
[82199.439290]  (
[82199.439704] cb_lock
[82199.440324] ){++++++}
[82199.441332] , at:
[82199.441872] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82199.445480]  #1:
[82199.445930]  (
[82199.446326] genl_mutex
[82199.447207] ){+.+.+.}
[82199.448209] , at:
[82199.448746] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82199.452705]  #2:
[82199.453152]  (
[82199.453543] rtnl_mutex
[82199.454428] ){+.+.+.}
[82199.455432] , at:
[82199.455970] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82199.459667] 2 locks held by hostapd/4733:
[82199.462401]  #0:
[82199.462850]  (
[82199.463241] cb_lock
[82199.463866] ){++++++}
[82199.464870] , at:
[82199.465404] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82199.469020]  #1:
[82199.469467]  (
[82199.469863] genl_mutex
[82199.470747] ){+.+.+.}
[82199.471752] , at:
[82199.472285] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82199.476244] 2 locks held by bash/5322:
[82199.478718]  #0:
[82199.479166]  (
[82199.479568] &tty->ldisc_sem
[82199.480892] ){++++.+}
[82199.481896] , at:
[82199.482430] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82199.486649]  #1:
[82199.487096]  (
[82199.487490] &ldata->atomic_read_lock
[82199.489589] ){+.+...}
[82199.490593] , at:
[82199.491126] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82199.494998] 2 locks held by bash/24789:
[82199.497563]  #0:
[82199.498010]  (
[82199.498406] &tty->ldisc_sem
[82199.499723] ){++++.+}
[82199.500728] , at:
[82199.501261] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82199.505479]  #1:
[82199.505931]  (
[82199.506322] &ldata->atomic_read_lock
[82199.508421] ){+.+...}
[82199.509425] , at:
[82199.509962] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82199.513836] 5 locks held by kworker/u8:1/1965:
[82199.517005]  #0:
[82199.517453]  (
[82199.517848] "%s"wiphy_name(local->hw.wiphy)
[82199.520563] ){++++.+}
[82199.522214] , at:
[82199.522759] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82199.527237]  #1:
[82199.527691]  (
[82199.528085] (&sdata->work)
[82199.529321] ){+.+.+.}
[82199.530323] , at:
[82199.530862] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82199.535345]  #2:
[82199.535797]  (
[82199.536191] &wdev->mtx
[82199.537075] ){+.+.+.}
[82199.538079] , at:
[82199.538651] [<ffffffffa0e65557>] ieee80211_sta_work+0x47/0x1b50 [mac80211]
[82199.544262]  #3:
[82199.544715]  (
[82199.545109] &local->sta_mtx
[82199.546426] ){+.+.+.}
[82199.547430] , at:
[82199.547990] [<ffffffffa0dffae6>] __sta_info_flush+0x86/0x190 [mac80211]
[82199.553338]  #4:
[82199.553788]  (
[82199.554182] &ar->conf_mutex
[82199.555503] ){+.+.+.}
[82199.556504] , at:
[82199.557049] [<ffffffffa12a3165>] ath10k_sta_state+0x205/0xbd0 [ath10k_core]
[82199.562743] 3 locks held by kworker/u8:3/2064:
[82199.565913]  #0:
[82199.566358]  (
[82199.566754] "%s""ath10k_wq"
[82199.568072] ){.+.+.+}
[82199.569076] , at:
[82199.569614] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82199.574091]  #1:
[82199.574538]  (
[82199.574934] (&(&ar->debug.nop_dwork)->work)
[82199.577641] ){+.+...}
[82199.578643] , at:
[82199.579179] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82199.583655]  #2:
[82199.584103]  (
[82199.584499] &ar->conf_mutex
[82199.585816] ){+.+.+.}
[82199.586821] , at:
[82199.587360] [<ffffffffa12acbb4>] ath10k_debug_nop_dwork+0x24/0x80 [ath10k_core]
[82199.593402] 4 locks held by kworker/0:2/2149:
[82199.596483]  #0:
[82199.596933]  (
[82199.597324] "events_freezable"
[82199.598903] ){.+.+..}
[82199.599907] , at:
[82199.600441] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82199.604919]  #1:
[82199.605367]  (
[82199.605765] (&local->restart_work)
[82199.607690] ){+.+...}
[82199.608694] , at:
[82199.609228] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82199.613706]  #2:
[82199.614153]  (
[82199.614544] rtnl_mutex
[82199.615429] ){+.+.+.}
[82199.616433] , at:
[82199.616970] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82199.620668]  #3:
[82199.621112]  (
[82199.621503] &ar->conf_mutex
[82199.622828] ){+.+.+.}
[82199.623830] , at:
[82199.624369] [<ffffffffa12a8686>] ath10k_start+0x26/0x5d0 [ath10k_core]
[82199.629628] 3 locks held by kworker/3:3/2153:
[82199.632709]  #0:
[82199.633154]  (
[82199.633545] "events"
[82199.634257] ){.+.+.+}
[82199.635261] , at:
[82199.635799] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82199.640276]  #1:
[82199.640726]  (
[82199.641119] (linkwatch_work).work
[82199.642958] ){+.+.+.}
[82199.643962] , at:
[82199.644506] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82199.648993]  #2:
[82199.649438]  (
[82199.649834] rtnl_mutex
[82199.650718] ){+.+.+.}
[82199.651722] , at:
[82199.652256] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82199.655955] 3 locks held by kworker/2:2/2984:
[82199.659038]  #0:
[82199.659483]  (
[82199.659879] "%s"("ipv6_addrconf")
[82199.661721] ){.+.+..}
[82199.662733] , at:
[82199.663270] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82199.667746]  #1:
[82199.668194]  (
[82199.668596] (addr_chk_work).work
[82199.670349] ){+.+...}
[82199.671353] , at:
[82199.671891] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82199.676368]  #2:
[82199.676821]  (
[82199.677214] rtnl_mutex
[82199.678100] ){+.+.+.}
[82199.679104] , at:
[82199.679642] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82199.683342] 1 lock held by ip/3840:
[82199.685557]  #0:
[82199.686006]  (
[82199.686397] rtnl_mutex
[82199.687281] ){+.+.+.}
[82199.688287] , at:
[82199.688825] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82199.692869] 1 lock held by ip/3843:
[82199.695084]  #0:
[82199.695531]  (
[82199.695932] rtnl_mutex
[82199.696819] ){+.+.+.}
[82199.697826] , at:
[82199.698363] [<ffffffff8186959e>] netlink_dump+0x1e/0x290
[82199.702407] 1 lock held by ip/3845:
[82199.704621]  #0:
[82199.705069]  (
[82199.705464] rtnl_mutex
[82199.706349] ){+.+.+.}
[82199.707352] , at:
[82199.707890] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30

[82199.712145] =============================================

[82199.716482] INFO: task kworker/3:3:2153 blocked for more than 180 seconds.
[82199.722089]       Tainted: G        W       4.9.0-rc6+ #9
[82199.726232] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[82199.732798] kworker/3:3     D    0  2153      2 0x00000000
[82199.737044] Workqueue: events linkwatch_event
[82199.740140]  ffff8802114d6900 000000000000728c ffff880213dacc80 ffff8801d9490000
[82199.746317]  ffff88021e3998d8 ffffc9000e8f3cd0 ffffffff819322eb 0000000000000006
[82199.752515]  ffff880213dacc80 000000000e8f3cc8 ffff88021e3998d8 0000000000000000
[82199.758699] Call Trace:
[82199.759894]  [<ffffffff819322eb>] ? __schedule+0x2fb/0xb30
[82199.764108]  [<ffffffff81932b58>] schedule+0x38/0x90
[82199.767798]  [<ffffffff81932f20>] schedule_preempt_disabled+0x10/0x20
[82199.772967]  [<ffffffff81934b15>] mutex_lock_nested+0x175/0x3f0
[82199.777618]  [<ffffffff81841882>] ? rtnl_lock+0x12/0x20
[82199.781570]  [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82199.785368]  [<ffffffff81849309>] linkwatch_event+0x9/0x30
[82199.789602]  [<ffffffff8113a883>] process_one_work+0x1e3/0x740
[82199.794179]  [<ffffffff8113a804>] ? process_one_work+0x164/0x740
[82199.798953]  [<ffffffff8113ae26>] worker_thread+0x46/0x4f0
[82199.803164]  [<ffffffff8113ade0>] ? process_one_work+0x740/0x740
[82199.807915]  [<ffffffff8113ade0>] ? process_one_work+0x740/0x740
[82199.812650]  [<ffffffff8114166a>] kthread+0xfa/0x110
[82199.816340]  [<ffffffff81141570>] ? kthread_park+0x60/0x60
[82199.820554]  [<ffffffff8193a1ea>] ret_from_fork+0x2a/0x40
[82199.824679]
Showing all locks held in the system:
[82199.828330] 2 locks held by khungtaskd/37:
[82199.831152]  #0:
[82199.831602]  (
[82199.831993] rcu_read_lock
[82199.833136] ){......}
[82199.834138] , at:
[82199.834677] [<ffffffff811ebd5c>] watchdog+0x9c/0x600
[82199.838374]  #1:
[82199.838825]  (
[82199.839216] tasklist_lock
[82199.840360] ){.+.+..}
[82199.841361] , at:
[82199.841900] [<ffffffff8117576d>] debug_show_all_locks+0x3d/0x1a0
[82199.846648] 2 locks held by agetty/1149:
[82199.849296]  #0:
[82199.849746]  (
[82199.850142] &tty->ldisc_sem
[82199.851467] ){++++.+}
[82199.852472] , at:
[82199.853010] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82199.857225]  #1:
[82199.857674]  (
[82199.858068] &ldata->atomic_read_lock
[82199.860166] ){+.+...}
[82199.861167] , at:
[82199.861707] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82199.865581] 1 lock held by mission-control/1506:
[82199.868920]  #0:
[82199.869368]  (
[82199.869765] rtnl_mutex
[82199.870648] ){+.+.+.}
[82199.871649] , at:
[82199.872185] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82199.876230] 2 locks held by bash/1691:
[82199.878706]  #0:
[82199.879151]  (
[82199.879547] &tty->ldisc_sem
[82199.880864] ){++++.+}
[82199.881867] , at:
[82199.882403] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82199.886619]  #1:
[82199.887064]  (
[82199.887460] &ldata->atomic_read_lock
[82199.889557] ){+.+...}
[82199.890560] , at:
[82199.891098] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82199.894974] 1 lock held by evolution-calen/1768:
[82199.898317]  #0:
[82199.898765]  (
[82199.899159] rtnl_mutex
[82199.900040] ){+.+.+.}
[82199.901042] , at:
[82199.901578] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82199.905627] 2 locks held by hostapd/4100:
[82199.908361]  #0:
[82199.908810]  (
[82199.909203] cb_lock
[82199.909825] ){++++++}
[82199.910825] , at:
[82199.911361] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82199.914971]  #1:
[82199.915419]  (
[82199.915814] genl_mutex
[82199.916697] ){+.+.+.}
[82199.917698] , at:
[82199.918234] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82199.922192] 2 locks held by hostapd/4392:
[82199.924927]  #0:
[82199.925374]  (
[82199.925772] cb_lock
[82199.926393] ){++++++}
[82199.927398] , at:
[82199.927935] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82199.931544]  #1:
[82199.931994]  (
[82199.932385] genl_mutex
[82199.933268] ){+.+.+.}
[82199.934269] , at:
[82199.934806] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82199.938760] 3 locks held by wpa_supplicant/4574:
[82199.942100]  #0:
[82199.942547]  (
[82199.942944] cb_lock
[82199.943563] ){++++++}
[82199.944567] , at:
[82199.945104] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82199.948711]  #1:
[82199.949158]  (
[82199.949549] genl_mutex
[82199.950433] ){+.+.+.}
[82199.951437] , at:
[82199.951977] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82199.955932]  #2:
[82199.956379]  (
[82199.956781] rtnl_mutex
[82199.957664] ){+.+.+.}
[82199.958670] , at:
[82199.959204] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82199.962903] 2 locks held by hostapd/4733:
[82199.965639]  #0:
[82199.966084]  (
[82199.966480] cb_lock
[82199.967101] ){++++++}
[82199.968103] , at:
[82199.968640] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82199.972246]  #1:
[82199.972695]  (
[82199.973088] genl_mutex
[82199.973970] ){+.+.+.}
[82199.974970] , at:
[82199.975506] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82199.979463] 2 locks held by bash/5322:
[82199.981939]  #0:
[82199.982396]  (
[82199.982803] &tty->ldisc_sem
[82199.984120] ){++++.+}
[82199.985123] , at:
[82199.985664] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82199.989879]  #1:
[82199.990325]  (
[82199.990723] &ldata->atomic_read_lock
[82199.992822] ){+.+...}
[82199.993825] , at:
[82199.994359] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82199.998233] 2 locks held by bash/24789:
[82200.000791]  #0:
[82200.001239]  (
[82200.001634] &tty->ldisc_sem
[82200.002963] ){++++.+}
[82200.003964] , at:
[82200.004500] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82200.008719]  #1:
[82200.009164]  (
[82200.009555] &ldata->atomic_read_lock
[82200.011653] ){+.+...}
[82200.012656] , at:
[82200.013193] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82200.017065] 5 locks held by kworker/u8:1/1965:
[82200.020233]  #0:
[82200.020682]  (
[82200.021073] "%s"wiphy_name(local->hw.wiphy)
[82200.023779] ){++++.+}
[82200.024780] , at:
[82200.025317] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82200.029794]  #1:
[82200.030241]  (
[82200.030642] (&sdata->work)
[82200.031873] ){+.+.+.}
[82200.032877] , at:
[82200.033411] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82200.037888]  #2:
[82200.038335]  (
[82200.038730] &wdev->mtx
[82200.039615] ){+.+.+.}
[82200.041265] , at:
[82200.041831] [<ffffffffa0e65557>] ieee80211_sta_work+0x47/0x1b50 [mac80211]
[82200.047435]  #3:
[82200.047887]  (
[82200.048281] &local->sta_mtx
[82200.049601] ){+.+.+.}
[82200.050605] , at:
[82200.051157] [<ffffffffa0dffae6>] __sta_info_flush+0x86/0x190 [mac80211]
[82200.056501]  #4:
[82200.056950]  (
[82200.057343] &ar->conf_mutex
[82200.058660] ){+.+.+.}
[82200.059664] , at:
[82200.060203] [<ffffffffa12a3165>] ath10k_sta_state+0x205/0xbd0 [ath10k_core]
[82200.065897] 3 locks held by kworker/u8:3/2064:
[82200.069064]  #0:
[82200.069508]  (
[82200.069904] "%s""ath10k_wq"
[82200.071222] ){.+.+.+}
[82200.072225] , at:
[82200.072765] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82200.077239]  #1:
[82200.077691]  (
[82200.078084] (&(&ar->debug.nop_dwork)->work)
[82200.080792] ){+.+...}
[82200.081793] , at:
[82200.082329] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82200.086806]  #2:
[82200.087253]  (
[82200.087648] &ar->conf_mutex
[82200.088966] ){+.+.+.}
[82200.089969] , at:
[82200.090510] [<ffffffffa12acbb4>] ath10k_debug_nop_dwork+0x24/0x80 [ath10k_core]
[82200.096551] 4 locks held by kworker/0:2/2149:
[82200.099644]  #0:
[82200.100089]  (
[82200.100485] "events_freezable"
[82200.102067] ){.+.+..}
[82200.103070] , at:
[82200.103604] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82200.108095]  #1:
[82200.108542]  (
[82200.108937] (&local->restart_work)
[82200.110863] ){+.+...}
[82200.111867] , at:
[82200.112401] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82200.116882]  #2:
[82200.117331]  (
[82200.117729] rtnl_mutex
[82200.118615] ){+.+.+.}
[82200.119619] , at:
[82200.120154] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82200.123850]  #3:
[82200.124297]  (
[82200.124691] &ar->conf_mutex
[82200.126010] ){+.+.+.}
[82200.127015] , at:
[82200.127553] [<ffffffffa12a8686>] ath10k_start+0x26/0x5d0 [ath10k_core]
[82200.132814] 3 locks held by kworker/3:3/2153:
[82200.135894]  #0:
[82200.136339]  (
[82200.136734] "events"
[82200.137441] ){.+.+.+}
[82200.138446] , at:
[82200.138984] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82200.143461]  #1:
[82200.143911]  (
[82200.144304] (linkwatch_work).work
[82200.146143] ){+.+.+.}
[82200.147146] , at:
[82200.147686] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82200.152162]  #2:
[82200.152606]  (
[82200.153008] rtnl_mutex
[82200.153896] ){+.+.+.}
[82200.154899] , at:
[82200.155435] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82200.159131] 3 locks held by kworker/2:2/2984:
[82200.162214]  #0:
[82200.162665]  (
[82200.163061] "%s"("ipv6_addrconf")
[82200.164903] ){.+.+..}
[82200.165907] , at:
[82200.166441] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82200.170916]  #1:
[82200.171361]  (
[82200.171761] (addr_chk_work).work
[82200.173511] ){+.+...}
[82200.174515] , at:
[82200.175053] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82200.179529]  #2:
[82200.179980]  (
[82200.180374] rtnl_mutex
[82200.181257] ){+.+.+.}
[82200.182260] , at:
[82200.182797] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82200.186496] 1 lock held by ip/3840:
[82200.188709]  #0:
[82200.189156]  (
[82200.189547] rtnl_mutex
[82200.190431] ){+.+.+.}
[82200.191432] , at:
[82200.191969] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82200.196010] 1 lock held by ip/3843:
[82200.198223]  #0:
[82200.198671]  (
[82200.199065] rtnl_mutex
[82200.199946] ){+.+.+.}
[82200.200947] , at:
[82200.201492] [<ffffffff8186959e>] netlink_dump+0x1e/0x290
[82200.205536] 1 lock held by ip/3845:
[82200.207751]  #0:
[82200.208203]  (
[82200.208599] rtnl_mutex
[82200.209480] ){+.+.+.}
[82200.210481] , at:
[82200.211018] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30

[82200.215271] =============================================

[82200.219605] INFO: task kworker/2:2:2984 blocked for more than 180 seconds.
[82200.225215]       Tainted: G        W       4.9.0-rc6+ #9
[82200.229343] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[82200.235900] kworker/2:2     D    0  2984      2 0x00000000
[82200.240157] Workqueue: ipv6_addrconf addrconf_verify_work [ipv6]
[82200.244902]  ffff880210f75500 00000000000023ac ffff880214de2640 ffff880203aacc80
[82200.251081]  ffff88021e3198d8 ffffc9000f3c3cd0 ffffffff819322eb 0000000000000006
[82200.257259]  ffff880203aad4a8 000000000f3c3cc8 ffff88021e3198d8 0000000000000000
[82200.263451] Call Trace:
[82200.264630]  [<ffffffff819322eb>] ? __schedule+0x2fb/0xb30
[82200.268840]  [<ffffffff81932b58>] schedule+0x38/0x90
[82200.272532]  [<ffffffff81932f20>] schedule_preempt_disabled+0x10/0x20
[82200.278056]  [<ffffffff81934b15>] mutex_lock_nested+0x175/0x3f0
[82200.282711]  [<ffffffff81841882>] ? rtnl_lock+0x12/0x20
[82200.286664]  [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82200.290452]  [<ffffffffa0014539>] addrconf_verify_work+0x9/0x20 [ipv6]
[82200.295706]  [<ffffffff8113a883>] process_one_work+0x1e3/0x740
[82200.300269]  [<ffffffff8113a804>] ? process_one_work+0x164/0x740
[82200.305004]  [<ffffffff8113ae26>] worker_thread+0x46/0x4f0
[82200.309218]  [<ffffffff8113ade0>] ? process_one_work+0x740/0x740
[82200.313952]  [<ffffffff8113ade0>] ? process_one_work+0x740/0x740
[82200.318688]  [<ffffffff8114166a>] kthread+0xfa/0x110
[82200.322378]  [<ffffffff81141570>] ? kthread_park+0x60/0x60
[82200.326591]  [<ffffffff8193a1ea>] ret_from_fork+0x2a/0x40
[82200.330715]
Showing all locks held in the system:
[82200.334348] 2 locks held by khungtaskd/37:
[82200.337171]  #0:
[82200.337619]  (
[82200.338026] rcu_read_lock
[82200.339172] ){......}
[82200.340173] , at:
[82200.340717] [<ffffffff811ebd5c>] watchdog+0x9c/0x600
[82200.344414]  #1:
[82200.344864]  (
[82200.345257] tasklist_lock
[82200.346401] ){.+.+..}
[82200.347408] , at:
[82200.347946] [<ffffffff8117576d>] debug_show_all_locks+0x3d/0x1a0
[82200.352691] 2 locks held by agetty/1149:
[82200.355340]  #0:
[82200.355792]  (
[82200.356186] &tty->ldisc_sem
[82200.357505] ){++++.+}
[82200.358509] , at:
[82200.359047] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82200.363265]  #1:
[82200.363718]  (
[82200.364112] &ldata->atomic_read_lock
[82200.366212] ){+.+...}
[82200.367220] , at:
[82200.367757] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82200.371649] 1 lock held by mission-control/1506:
[82200.374991]  #0:
[82200.375439]  (
[82200.375838] rtnl_mutex
[82200.376722] ){+.+.+.}
[82200.377726] , at:
[82200.378260] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82200.382305] 2 locks held by bash/1691:
[82200.384781]  #0:
[82200.385226]  (
[82200.385616] &tty->ldisc_sem
[82200.386936] ){++++.+}
[82200.387941] , at:
[82200.388474] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82200.392692]  #1:
[82200.393140]  (
[82200.393536] &ldata->atomic_read_lock
[82200.395636] ){+.+...}
[82200.396642] , at:
[82200.397175] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82200.401049] 1 lock held by evolution-calen/1768:
[82200.404391]  #0:
[82200.404843]  (
[82200.405239] rtnl_mutex
[82200.406123] ){+.+.+.}
[82200.407129] , at:
[82200.407668] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82200.411719] 2 locks held by hostapd/4100:
[82200.414457]  #0:
[82200.414909]  (
[82200.415305] cb_lock
[82200.415927] ){++++++}
[82200.416928] , at:
[82200.417462] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82200.421072]  #1:
[82200.421516]  (
[82200.421912] genl_mutex
[82200.422797] ){+.+.+.}
[82200.423801] , at:
[82200.424334] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82200.428293] 2 locks held by hostapd/4392:
[82200.431028]  #0:
[82200.431476]  (
[82200.431876] cb_lock
[82200.432498] ){++++++}
[82200.433504] , at:
[82200.434042] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82200.437651]  #1:
[82200.438095]  (
[82200.438487] genl_mutex
[82200.439371] ){+.+.+.}
[82200.440375] , at:
[82200.440915] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82200.444876] 3 locks held by wpa_supplicant/4574:
[82200.448221]  #0:
[82200.448670]  (
[82200.449063] cb_lock
[82200.449688] ){++++++}
[82200.450694] , at:
[82200.451226] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82200.454837]  #1:
[82200.455282]  (
[82200.455688] genl_mutex
[82200.456570] ){+.+.+.}
[82200.457575] , at:
[82200.458113] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82200.462069]  #2:
[82200.462514]  (
[82200.462909] rtnl_mutex
[82200.463806] ){+.+.+.}
[82200.464812] , at:
[82200.465345] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82200.469045] 2 locks held by hostapd/4733:
[82200.471785]  #0:
[82200.472232]  (
[82200.472623] cb_lock
[82200.473248] ){++++++}
[82200.474253] , at:
[82200.474792] [<ffffffff8186d494>] genl_rcv+0x14/0x40
[82200.478399]  #1:
[82200.478851]  (
[82200.479244] genl_mutex
[82200.480128] ){+.+.+.}
[82200.481135] , at:
[82200.481672] [<ffffffff8186d8d4>] genl_rcv_msg+0xa4/0xb0
[82200.485629] 2 locks held by bash/5322:
[82200.488100]  #0:
[82200.488547]  (
[82200.488943] &tty->ldisc_sem
[82200.490260] ){++++.+}
[82200.491265] , at:
[82200.491802] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82200.496019]  #1:
[82200.496464]  (
[82200.496860] &ldata->atomic_read_lock
[82200.498958] ){+.+...}
[82200.499963] , at:
[82200.500496] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82200.504367] 2 locks held by bash/24789:
[82200.506929]  #0:
[82200.507376]  (
[82200.507775] &tty->ldisc_sem
[82200.509094] ){++++.+}
[82200.510098] , at:
[82200.510632] [<ffffffff81938afd>] ldsem_down_read+0x2d/0x40
[82200.514856]  #1:
[82200.515302]  (
[82200.515701] &ldata->atomic_read_lock
[82200.517800] ){+.+...}
[82200.518804] , at:
[82200.519337] [<ffffffff815af1a9>] n_tty_read+0xa9/0x910
[82200.523229] 5 locks held by kworker/u8:1/1965:
[82200.526402]  #0:
[82200.526854]  (
[82200.527248] "%s"wiphy_name(local->hw.wiphy)
[82200.529957] ){++++.+}
[82200.530961] , at:
[82200.531496] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82200.535975]  #1:
[82200.536420]  (
[82200.536819] (&sdata->work)
[82200.538051] ){+.+.+.}
[82200.539055] , at:
[82200.539590] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82200.544079]  #2:
[82200.544526]  (
[82200.544947] &wdev->mtx
[82200.545835] ){+.+.+.}
[82200.546843] , at:
[82200.547406] [<ffffffffa0e65557>] ieee80211_sta_work+0x47/0x1b50 [mac80211]
[82200.553015]  #3:
[82200.553464]  (
[82200.553863] &local->sta_mtx
[82200.555182] ){+.+.+.}
[82200.556186] , at:
[82200.556745] [<ffffffffa0dffae6>] __sta_info_flush+0x86/0x190 [mac80211]
[82200.562092]  #4:
[82200.562537]  (
[82200.562933] &ar->conf_mutex
[82200.564249] ){+.+.+.}
[82200.565900] , at:
[82200.566441] [<ffffffffa12a3165>] ath10k_sta_state+0x205/0xbd0 [ath10k_core]
[82200.572139] 3 locks held by kworker/u8:3/2064:
[82200.575309]  #0:
[82200.575758]  (
[82200.576154] "%s""ath10k_wq"
[82200.577471] ){.+.+.+}
[82200.578474] , at:
[82200.579023] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82200.583500]  #1:
[82200.583952]  (
[82200.584342] (&(&ar->debug.nop_dwork)->work)
[82200.587049] ){+.+...}
[82200.588050] , at:
[82200.588587] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82200.593063]  #2:
[82200.593511]  (
[82200.593907] &ar->conf_mutex
[82200.595223] ){+.+.+.}
[82200.596228] , at:
[82200.596772] [<ffffffffa12acbb4>] ath10k_debug_nop_dwork+0x24/0x80 [ath10k_core]
[82200.602813] 4 locks held by kworker/0:2/2149:
[82200.605898]  #0:
[82200.606346]  (
[82200.606742] "events_freezable"
[82200.608318] ){.+.+..}
[82200.609325] , at:
[82200.609863] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82200.614339]  #1:
[82200.614791]  (
[82200.615188] (&local->restart_work)
[82200.617118] ){+.+...}
[82200.618120] , at:
[82200.618661] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82200.623138]  #2:
[82200.623583]  (
[82200.623978] rtnl_mutex
[82200.624862] ){+.+.+.}
[82200.625866] , at:
[82200.626402] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82200.630098]  #3:
[82200.630543]  (
[82200.630938] &ar->conf_mutex
[82200.632255] ){+.+.+.}
[82200.633261] , at:
[82200.633804] [<ffffffffa12a8686>] ath10k_start+0x26/0x5d0 [ath10k_core]
[82200.639063] 3 locks held by kworker/3:3/2153:
[82200.642147]  #0:
[82200.642594]  (
[82200.642993] "events"
[82200.643709] ){.+.+.+}
[82200.644725] , at:
[82200.645261] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82200.649741]  #1:
[82200.650189]  (
[82200.650580] (linkwatch_work).work
[82200.652421] ){+.+.+.}
[82200.653423] , at:
[82200.653961] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82200.658440]  #2:
[82200.658890]  (
[82200.659281] rtnl_mutex
[82200.660166] ){+.+.+.}
[82200.661170] , at:
[82200.661707] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82200.665405] 3 locks held by kworker/2:2/2984:
[82200.668486]  #0:
[82200.668934]  (
[82200.669327] "%s"("ipv6_addrconf")
[82200.671166] ){.+.+..}
[82200.672174] , at:
[82200.672712] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82200.677187]  #1:
[82200.677632]  (
[82200.678033] (addr_chk_work).work
[82200.679787] ){+.+...}
[82200.680791] , at:
[82200.681324] [<ffffffff8113a804>] process_one_work+0x164/0x740
[82200.685804]  #2:
[82200.686251]  (
[82200.686647] rtnl_mutex
[82200.687529] ){+.+.+.}
[82200.688533] , at:
[82200.689073] [<ffffffff81841882>] rtnl_lock+0x12/0x20
[82200.692771] 1 lock held by ip/3840:
[82200.694985]  #0:
[82200.695433]  (
[82200.695834] rtnl_mutex
[82200.696720] ){+.+.+.}
[82200.697725] , at:
[82200.698258] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30
[82200.702304] 1 lock held by ip/3843:
[82200.704518]  #0:
[82200.704970]  (
[82200.705366] rtnl_mutex
[82200.706248] ){+.+.+.}
[82200.707251] , at:
[82200.707790] [<ffffffff8186959e>] netlink_dump+0x1e/0x290
[82200.711830] 1 lock held by ip/3845:
[82200.714044]  #0:
[82200.714489]  (
[82200.714885] rtnl_mutex
[82200.715769] ){+.+.+.}
[82200.716773] , at:
[82200.717307] [<ffffffff81842df6>] rtnetlink_rcv+0x16/0x30

[82200.721567] =============================================


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
