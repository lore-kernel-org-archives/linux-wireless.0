Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4502 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab1ELLgF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 07:36:05 -0400
Received: from mail-sj1-12.sj.broadcom.com (mail-sj1-12.sj.broadcom.com
 [10.17.16.106]) by mail-irva-13.broadcom.com (Postfix) with ESMTP id
 1560974D03 for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011
 04:35:55 -0700 (PDT)
Received: from [192.168.1.108] (unknown [10.176.68.21]) by
 mail-sj1-12.sj.broadcom.com (Postfix) with ESMTP id 226CD20501 for
 <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 04:35:53 -0700 (PDT)
Message-ID: <4DCBC619.8080104@broadcom.com> (sfid-20110512_133611_801301_E86E001D)
Date: Thu, 12 May 2011 13:35:53 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: NULL pointer dereference in nl80211
References: <1303383725-1440-1-git-send-email-rvossen@broadcom.com>
 <1303383725-1440-4-git-send-email-rvossen@broadcom.com>
In-Reply-To: <1303383725-1440-4-git-send-email-rvossen@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This problem started to occur on my system after upgrading to Ubuntu 
11.04. It occurs when rm'modding the brcm80211 driver module. I should 
notice that I am running Greg's 2.6.39-rc4 kernel. The exception happens 
in function set_regdom().

Has anybody else seen this problem ?

Bye, Roland.

log, trace and stack dump:
-------------------------------

[   90.735546] brcmutil: module is from the staging directory, the 
quality is unknown, you have been warned.
[   90.830723] brcmsmac: module is from the staging directory, the 
quality is unknown, you have been warned.
[   90.845333] brcmsmac 0000:03:00.0: bus 3 slot 0 func 0 irq 11
[   90.851105] brcmsmac 0000:03:00.0: PCI INT A -> GSI 17 (level, low) 
-> IRQ 17
[   90.858238] brcmsmac 0000:03:00.0: setting latency timer to 64
[   90.935793] Found chip type AI (0x13814313)
[   90.949258] Applying 4313 WARs
[   90.966100] ieee80211 phy0: Selected rate control algorithm 
'minstrel_ht'
[   91.001012] udev[1345]: renamed network interface wlan0 to wlan4
[   91.067720] ieee80211 phy0: wl_ops_bss_info_changed: BSS idle: true 
(implement)
[   91.075174] ieee80211 phy0: device now idle
[   91.079913] ieee80211 phy0: wl_ops_config: change monitor mode: false 
(implement)
[   91.079916] ieee80211 phy0: wl_ops_config: change power-save mode: 
false (implement)
[   91.080597] ieee80211 phy0: wl_ops_bss_info_changed: qos enabled: 
false (implement)
[   91.154910] ieee80211 phy0: wl_ops_bss_info_changed: BSS idle: false 
(implement)
[   91.154916] ieee80211 phy0: device no longer idle - scanning
[   92.107626] ieee80211 phy0: wl_ops_bss_info_changed: BSS idle: true 
(implement)
[   92.114950] ieee80211 phy0: device now idle
[   92.191021] ieee80211 phy0: wl_ops_bss_info_changed: BSS idle: false 
(implement)
[   92.198413] ieee80211 phy0: device no longer idle - scanning
[   93.164734] ieee80211 phy0: wl_ops_bss_info_changed: BSS idle: true 
(implement)
[   93.172039] ieee80211 phy0: device now idle
[   93.179579] ieee80211 phy0: wl_ops_bss_info_changed: BSS idle: false 
(implement)
[   93.186971] ieee80211 phy0: device no longer idle - working
[   93.192550] wlan4: authenticate with c0:c1:c0:04:b8:2c (try 1)
[   93.397683] wlan4: authenticate with c0:c1:c0:04:b8:2c (try 2)
[   93.603163] wlan4: authenticate with c0:c1:c0:04:b8:2c (try 3)
[   93.758010] wlan4: authenticated
[   93.761902] wlan4: associate with c0:c1:c0:04:b8:2c (try 1)
[   93.966536] wlan4: associate with c0:c1:c0:04:b8:2c (try 2)
[   94.171179] wlan4: associate with c0:c1:c0:04:b8:2c (try 3)
[   94.375826] wlan4: association with c0:c1:c0:04:b8:2c timed out
[   94.386789] ieee80211 phy0: wl_ops_bss_info_changed: BSS idle: true 
(implement)
[   94.394099] ieee80211 phy0: device now idle
[  103.165247] ieee80211 phy0: wl_ops_bss_info_changed: BSS idle: false 
(implement)
[  103.172675] ieee80211 phy0: device no longer idle - scanning
[  104.218641] ieee80211 phy0: wl_ops_bss_info_changed: BSS idle: true 
(implement)
[  104.225971] ieee80211 phy0: device now idle
[  104.230424] ieee80211 phy0: wl_ops_bss_info_changed: BSS idle: false 
(implement)
[  104.237817] ieee80211 phy0: device no longer idle - working
[  104.243400] wlan4: authenticate with c0:c1:c0:04:b8:2c (try 1)
[  104.300906] wlan4: authenticated
[  104.304414] wlan4: associate with c0:c1:c0:04:b8:2c (try 1)
[  104.344740] wlan4: RX AssocResp from c0:c1:c0:04:b8:2c (capab=0x411 
status=0 aid=1)
[  104.352623] wlan4: associated
[  104.355853] ieee80211 phy0: Allocated STA c0:c1:c0:04:b8:2c
[  104.362329] ieee80211 phy0: Inserted STA c0:c1:c0:04:b8:2c
[  104.367819] ieee80211 phy0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 
cWmax=1023 txop=0 uapsd=0
[  104.376489] ieee80211 phy0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 
cWmax=1023 txop=0 uapsd=0
[  104.385136] ieee80211 phy0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 
cWmax=15 txop=94 uapsd=0
[  104.393601] ieee80211 phy0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 
cWmax=7 txop=47 uapsd=0
[  104.401989] ieee80211 phy0: wl_ops_bss_info_changed: qos enabled: 
true (implement)
[  104.409590] ieee80211 phy0: brcmsmac: wl_ops_bss_info_changed: 
associated
[  104.416393] ieee80211 phy0: wl_ops_bss_info_changed: arp filtering: 
enabled true, count 0 (implement)
[  108.785059] ieee80211 phy0: wl_ops_bss_info_changed: arp filtering: 
enabled true, count 1 (implement)
[  179.585789] wlan4: detected beacon loss from AP - sending probe request
[  180.045423] wlan4: cancelling probereq poll due to a received beacon
[  250.805617] iperf used greatest stack depth: 5232 bytes left
[  255.221665] ieee80211 phy0: wl_ops_bss_info_changed: qos enabled: 
false (implement)
[  255.229891] ieee80211 phy0: brcmsmac: wl_ops_bss_info_changed: 
disassociated
[  255.236987] ieee80211 phy0: wl_ops_bss_info_changed: arp filtering: 
enabled false, count 1 (implement)
[  255.246360] wlan4: deauthenticating from c0:c1:c0:04:b8:2c by local 
choice (reason=3)
[  255.275259] ieee80211 phy0: Removed STA c0:c1:c0:04:b8:2c
[  255.281668] ieee80211 phy0: Destroyed STA c0:c1:c0:04:b8:2c
[  255.287388] ieee80211 phy0: device now idle
[  255.490889] cfg80211: Calling CRDA for country: US
[  255.555509] brcmsmac 0000:03:00.0: PCI INT A disabled
[  255.578965] BUG: unable to handle kernel NULL pointer dereference at 
00000080
[  255.586100] IP: [<c131e2cf>] set_regdom+0x1a0/0x4d8
[  255.590980] *pde = 00000000
[  255.593863] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[  255.598412] last sysfs file: /sys/devices/platform/regulatory.0/uevent
[  255.604922] Dumping ftrace buffer:
[  255.608313] ---------------------------------
[  255.612679] NetworkM-1675    0.... 75145284us : drv_start: phy0
[  255.618593] NetworkM-1675    0d... 75145355us : wake_queue: phy0 
queue:0, reason:0
[  255.626149] NetworkM-1675    0d... 75145357us : wake_queue: phy0 
queue:1, reason:0
[  255.633706] NetworkM-1675    0d... 75145358us : wake_queue: phy0 
queue:2, reason:0
[  255.641264] NetworkM-1675    0d... 75145358us : wake_queue: phy0 
queue:3, reason:0
[  255.648822] NetworkM-1675    0.... 75145467us : drv_return_int: phy0 - 0
[  255.655516] NetworkM-1675    0.... 75145470us : drv_add_interface: 
phy0 vif:wlan4(2) addr:90:4c:e5:65:10:31
[  255.665235] NetworkM-1675    0.N.. 75196639us : drv_return_int: phy0 - 0
[  255.671929] NetworkM-1675    0.... 75196658us : drv_bss_info_changed: 
phy0 vif:wlan4(2) changed:0xe
[  255.680956] NetworkM-1675    0.... 75196665us : drv_return_void: phy0
[  255.687389] NetworkM-1675    0.... 75196868us : drv_bss_info_changed: 
phy0 vif:wlan4(2) changed:0x4000
[  255.696908] NetworkM-1675    0.N.. 75204322us : drv_return_void: phy0
[  255.703342] NetworkM-1675    0.... 75209036us : drv_flush: phy0 drop:0
[  255.709858] NetworkM-1675    0.... 75209055us : drv_return_void: phy0
[  255.716293] NetworkM-1675    0.... 75209057us : drv_config: phy0 
ch:0xffffffff freq:2412
[  255.724368] NetworkM-1675    0.... 75209216us : drv_return_int: phy0 - 0
[  255.731059] NetworkM-1675    0.... 75209218us : drv_conf_tx: phy0 
queue:0
[  255.737835] NetworkM-1675    0.... 75209367us : drv_return_int: phy0 - 0
[  255.744526] NetworkM-1675    0.... 75209368us : drv_conf_tx: phy0 
queue:1
[  255.751304] NetworkM-1675    0.... 75209490us : drv_return_int: phy0 - 0
[  255.757995] NetworkM-1675    0.... 75209491us : drv_conf_tx: phy0 
queue:2
[  255.764772] NetworkM-1675    0.... 75209622us : drv_return_int: phy0 - 0
[  255.771464] NetworkM-1675    0.... 75209622us : drv_conf_tx: phy0 
queue:3
[  255.778238] NetworkM-1675    0.... 75209746us : drv_return_int: phy0 - 0
[  255.784932] NetworkM-1675    0.... 75209747us : drv_bss_info_changed: 
phy0 vif:wlan4(2) changed:0x2000
[  255.794217] NetworkM-1675    0.... 75209751us : drv_return_void: phy0
[  255.800650] kworker/-860     0..s. 75209985us : 
drv_prepare_multicast: phy0 prepare mc (0)
[  255.808899] kworker/-860     0..s. 75209986us : drv_return_u64: phy0 - 0
[  255.815592] kworker/-860     0.... 75209987us : drv_configure_filter: 
phy0 changed:0x0 total:0x80000000
[  255.824966] kworker/-860     0.... 75209988us : drv_return_void: phy0
[  255.831399] kworker/-860     0..s. 75210230us : 
drv_prepare_multicast: phy0 prepare mc (0)
[  255.839645] kworker/-860     0..s. 75210230us : drv_return_u64: phy0 - 0
[  255.846339] kworker/-860     0.... 75210231us : drv_configure_filter: 
phy0 changed:0x0 total:0x80000000
[  255.855714] kworker/-860     0.... 75210231us : drv_return_void: phy0
[  255.862148] kworker/-860     1..s. 75210624us : 
drv_prepare_multicast: phy0 prepare mc (1)
[  255.870398] kworker/-860     1..s. 75210627us : drv_return_u64: phy0 - 0
[  255.877091] kworker/-860     1.... 75210628us : drv_configure_filter: 
phy0 changed:0x0 total:0x80000000
[  255.886466] kworker/-860     1.... 75210628us : drv_return_void: phy0
[  255.892902]    <...>-1842    2.... 75284053us : drv_bss_info_changed: 
phy0 vif:wlan4(2) changed:0x4000
[  255.902191]    <...>-1842    2.... 75284066us : drv_return_void: phy0
[  255.908622]    <...>-1842    2.... 75284071us : drv_config: phy0 
ch:0x100 freq:2412
[  255.916267]    <...>-1842    2.... 75284076us : drv_return_int: phy0 - 0
[  255.922956]    <...>-1842    2.... 75284076us : drv_sw_scan_start: phy0
[  255.929561]    <...>-1842    2.... 75284078us : drv_return_void: phy0
[  255.935993]    <...>-1842    2..s. 75284091us : 
drv_prepare_multicast: phy0 prepare mc (1)
[  255.944241]    <...>-1842    2..s. 75284091us : drv_return_u64: phy0 - 0
[  255.950933]    <...>-1842    2.... 75284092us : drv_configure_filter: 
phy0 changed:0x10 total:0x80000010
[  255.960391]    <...>-1842    2.... 75284095us : drv_return_void: phy0
[  255.966822] kworker/-860     0.... 75373317us : drv_flush: phy0 drop:0
[  255.973340] kworker/-860     0.... 75373325us : drv_return_void: phy0
[  255.979814] kworker/-860     0.... 75373326us : drv_config: phy0 
ch:0x40 freq:2417
[  255.987370] kworker/-860     0.... 75375038us : drv_return_int: phy0 - 0
[  255.994061] kworker/-860     0.... 75434180us : drv_config: phy0 
ch:0x40 freq:2422
[  256.001618] kworker/-860     0.... 75435894us : drv_return_int: phy0 - 0
[  256.008310] kworker/-860     0.... 75495064us : drv_config: phy0 
ch:0x40 freq:2427
[  256.015866] kworker/-860     0.N.. 75496779us : drv_return_int: phy0 - 0
[  256.022559] kworker/-860     3.... 75556044us : drv_config: phy0 
ch:0x40 freq:2432
[  256.030115] kworker/-860     3.... 75558245us : drv_return_int: phy0 - 0
[  256.036805] kworker/-860     3.... 75617960us : drv_config: phy0 
ch:0x40 freq:2437
[  256.044362] kworker/-860     3.... 75619505us : drv_return_int: phy0 - 0
[  256.051054] kworker/-860     3.... 75678867us : drv_config: phy0 
ch:0x40 freq:2442
[  256.058611] kworker/-860     3.... 75680578us : drv_return_int: phy0 - 0
[  256.065302] kworker/-860     3.... 75739733us : drv_config: phy0 
ch:0x40 freq:2447
[  256.072860] kworker/-860     3.... 75741286us : drv_return_int: phy0 - 0
[  256.079553] kworker/-860     3.... 75800603us : drv_config: phy0 
ch:0x40 freq:2452
[  256.087110] kworker/-860     3.... 75802313us : drv_return_int: phy0 - 0
[  256.093802] kworker/-860     3.... 75861513us : drv_config: phy0 
ch:0x40 freq:2457
[  256.101357] kworker/-860     3.... 75863057us : drv_return_int: phy0 - 0
[  256.108048] kworker/-860     3.... 75922400us : drv_config: phy0 
ch:0x40 freq:2462
[  256.115604] kworker/-860     3.... 75924098us : drv_return_int: phy0 - 0
[  256.122295] kworker/-860     3.... 75983320us : drv_config: phy0 
ch:0x40 freq:2467
[  256.129849] kworker/-860     3.... 75985071us : drv_return_int: phy0 - 0
[  256.136541] kworker/-860     3.... 76109111us : drv_config: phy0 
ch:0x40 freq:2472
[  256.144099] kworker/-860     3.... 76110811us : drv_return_int: phy0 - 0
[  256.150792] kworker/-860     3.... 76234902us : drv_config: phy0 
ch:0x40 freq:2484
[  256.158348] kworker/-860     3.... 76234909us : drv_return_int: phy0 
- -5
[  256.165127] kworker/-860     3.... 76234999us : drv_config: phy0 
ch:0x40 freq:2412
[  256.172685] kworker/-860     3.... 76236707us : drv_return_int: phy0 - 0
[  256.179375] kworker/-860     3..s. 76236714us : 
drv_prepare_multicast: phy0 prepare mc (1)
[  256.187623] kworker/-860     3..s. 76236715us : drv_return_u64: phy0 - 0
[  256.194315] kworker/-860     3.... 76236716us : drv_configure_filter: 
phy0 changed:0x10 total:0x80000000
[  256.203773] kworker/-860     3.... 76236718us : drv_return_void: phy0
[  256.210204] kworker/-860     3.... 76236719us : drv_sw_scan_complete: 
phy0
[  256.217067] kworker/-860     3.... 76236721us : drv_return_void: phy0
[  256.223500] kworker/-860     3.... 76236772us : drv_bss_info_changed: 
phy0 vif:wlan4(2) changed:0x4000
[  256.232785] kworker/-860     3.... 76244097us : drv_return_void: phy0
[  256.239215] kworker/-860     3.... 76248353us : drv_flush: phy0 drop:0
[  256.245733] kworker/-860     3.... 76248376us : drv_return_void: phy0
[  256.252166] kworker/-860     3.... 76248378us : drv_config: phy0 
ch:0x100 freq:2412
[  256.259808] kworker/-860     3.... 76248379us : drv_return_int: phy0 - 0
[  256.266500]    <...>-1842    0.... 76320164us : drv_bss_info_changed: 
phy0 vif:wlan4(2) changed:0x4000
[  256.275787]    <...>-1842    0.N.. 76327559us : drv_return_void: phy0
[  256.282217]    <...>-1842    2.... 76333227us : drv_config: phy0 
ch:0x100 freq:2412
[  256.289858]    <...>-1842    2.... 76333231us : drv_return_int: phy0 - 0
[  256.296549]    <...>-1842    2.... 76333231us : drv_sw_scan_start: phy0
[  256.303152]    <...>-1842    2.... 76333233us : drv_return_void: phy0
[  256.309581]    <...>-1842    2..s. 76333236us : 
drv_prepare_multicast: phy0 prepare mc (1)
[  256.317829]    <...>-1842    2..s. 76333237us : drv_return_u64: phy0 - 0
[  256.324522]    <...>-1842    2.... 76333238us : drv_configure_filter: 
phy0 changed:0x10 total:0x80000010
[  256.333983]    <...>-1842    2.... 76333240us : drv_return_void: phy0
[  256.340415] kworker/-860     0.... 76422489us : drv_flush: phy0 drop:0
[  256.346933] kworker/-860     0.... 76428450us : drv_return_void: phy0
[  256.353366] kworker/-860     0.... 76428453us : drv_config: phy0 
ch:0x40 freq:2417
[  256.360921] kworker/-860     0.... 76430688us : drv_return_int: phy0 - 0
[  256.367614] kworker/-860     2.... 76490351us : drv_config: phy0 
ch:0x40 freq:2422
[  256.375170] kworker/-860     2.... 76491898us : drv_return_int: phy0 - 0
[  256.381862] kworker/-860     2.... 76551328us : drv_config: phy0 
ch:0x40 freq:2427
[  256.389418] kworker/-860     2.... 76553042us : drv_return_int: phy0 - 0
[  256.396110] kworker/-860     2.... 76612181us : drv_config: phy0 
ch:0x40 freq:2432
[  256.403670] kworker/-860     2.... 76614257us : drv_return_int: phy0 - 0
[  256.410362] kworker/-860     2.... 76674113us : drv_config: phy0 
ch:0x40 freq:2437
[  256.417917] kworker/-860     2.... 76675660us : drv_return_int: phy0 - 0
[  256.424607] kworker/-860     2.... 76735025us : drv_config: phy0 
ch:0x40 freq:2442
[  256.432163] kworker/-860     2.... 76736567us : drv_return_int: phy0 - 0
[  256.438854] kworker/-860     0.... 76795948us : drv_config: phy0 
ch:0x40 freq:2447
[  256.446411] kworker/-860     0.... 76797592us : drv_return_int: phy0 - 0
[  256.453103] kworker/-860     0.... 76856716us : drv_config: phy0 
ch:0x40 freq:2452
[  256.460662] kworker/-860     0.... 76858438us : drv_return_int: phy0 - 0
[  256.467354] kworker/-860     0.... 76917712us : drv_config: phy0 
ch:0x40 freq:2457
[  256.474904] kworker/-860     0.... 76919421us : drv_return_int: phy0 - 0
[  256.481595] kworker/-860     0.... 76978579us : drv_config: phy0 
ch:0x40 freq:2462
[  256.489151] kworker/-860     0.... 76980122us : drv_return_int: phy0 - 0
[  256.495833] kworker/-860     0.... 77039499us : drv_config: phy0 
ch:0x40 freq:2467
[  256.503379] kworker/-860     0.... 77041276us : drv_return_int: phy0 - 0
[  256.510058] kworker/-860     0.... 77166305us : drv_config: phy0 
ch:0x40 freq:2472
[  256.517603] kworker/-860     0.N.. 77168062us : drv_return_int: phy0 - 0
[  256.524294] kworker/-860     0.... 77292064us : drv_config: phy0 
ch:0x40 freq:2484
[  256.531842] kworker/-860     0.... 77292072us : drv_return_int: phy0 
- -5
[  256.538607] kworker/-860     0.... 77292081us : drv_config: phy0 
ch:0x40 freq:2412
[  256.546154] kworker/-860     0.N.. 77293808us : drv_return_int: phy0 - 0
[  256.552835] kworker/-860     0.Ns. 77293812us : 
drv_prepare_multicast: phy0 prepare mc (1)
[  256.561074] kworker/-860     0.Ns. 77293813us : drv_return_u64: phy0 - 0
[  256.567755] kworker/-860     0.... 77293843us : drv_configure_filter: 
phy0 changed:0x10 total:0x80000000
[  256.577214] kworker/-860     0.... 77293847us : drv_return_void: phy0
[  256.583636] kworker/-860     0.... 77293848us : drv_sw_scan_complete: 
phy0
[  256.590489] kworker/-860     0.... 77293851us : drv_return_void: phy0
[  256.596919] kworker/-860     0.... 77293878us : drv_bss_info_changed: 
phy0 vif:wlan4(2) changed:0x4000
[  256.606197] kworker/-860     0.... 77301188us : drv_return_void: phy0
[  256.612617] kworker/-860     0.... 77305381us : drv_flush: phy0 drop:0
[  256.619124] kworker/-860     0.... 77305383us : drv_return_void: phy0
[  256.625544] kworker/-860     0.... 77305385us : drv_config: phy0 
ch:0x100 freq:2412
[  256.633176] kworker/-860     0.... 77305386us : drv_return_int: phy0 - 0
[  256.639857]    <...>-1842    2.... 77305392us : drv_config: phy0 
ch:0x40 freq:2437
[  256.647402]    <...>-1842    2.N.. 77307987us : drv_return_int: phy0 - 0
[  256.654082] kworker/-860     0.... 77308724us : drv_bss_info_changed: 
phy0 vif:wlan4(2) changed:0x4000
[  256.663357] kworker/-860     0.N.. 77316118us : drv_return_void: phy0
[  256.669777] kworker/-860     0.... 77321696us : drv_config: phy0 
ch:0x100 freq:2437
[  256.677408] kworker/-860     0.... 77321699us : drv_return_int: phy0 - 0
[  256.684100] kworker/-860     0.... 78515932us : drv_bss_info_changed: 
phy0 vif:wlan4(2) changed:0x4000
[  256.693514] kworker/-860     0.N.. 78523249us : drv_return_void: phy0
[  256.699935] kworker/-860     0.... 78527444us : drv_flush: phy0 drop:0
[  256.706451] kworker/-860     3.... 78975167us : drv_return_void: phy0
[  256.712874] kworker/-860     3.... 78975171us : drv_config: phy0 
ch:0x100 freq:2437
[  256.720505] kworker/-860     3.... 78975174us : drv_return_int: phy0 - 0
[  256.727187]    <...>-1842    1.... 87294388us : drv_bss_info_changed: 
phy0 vif:wlan4(2) changed:0x4000
[  256.736466]    <...>-1842    1.N.. 87301820us : drv_return_void: phy0
[  256.742897]    <...>-1842    3.... 87307519us : drv_config: phy0 
ch:0x100 freq:2437
[  256.750531]    <...>-1842    3.... 87307525us : drv_return_int: phy0 - 0
[  256.757226]    <...>-1842    3.... 87307527us : drv_sw_scan_start: phy0
[  256.763823]    <...>-1842    3.... 87307531us : drv_return_void: phy0
[  256.770244]    <...>-1842    3..s. 87307537us : 
drv_prepare_multicast: phy0 prepare mc (1)
[  256.778493]    <...>-1842    3..s. 87307538us : drv_return_u64: phy0 - 0
[  256.785404]    <...>-1842    3.... 87307540us : drv_configure_filter: 
phy0 changed:0x10 total:0x80000010
[  256.794863]    <...>-1842    3.... 87307544us : drv_return_void: phy0
[  256.801295] kworker/-860     0.... 87336730us : drv_flush: phy0 drop:0
[  256.807812] kworker/-860     0.... 87336734us : drv_return_void: phy0
[  256.814244] kworker/-860     0.... 87336735us : drv_config: phy0 
ch:0x40 freq:2412
[  256.821802] kworker/-860     0.... 87338447us : drv_return_int: phy0 - 0
[  256.828492] kworker/-860     0.... 87397620us : drv_config: phy0 
ch:0x40 freq:2417
[  256.836050] kworker/-860     0.... 87399349us : drv_return_int: phy0 - 0
[  256.842740] kworker/-860     0.... 87458454us : drv_config: phy0 
ch:0x40 freq:2422
[  256.850328] kworker/-860     0.... 87460170us : drv_return_int: phy0 - 0
[  256.857019] kworker/-860     0.... 87519401us : drv_config: phy0 
ch:0x40 freq:2427
[  256.864576] kworker/-860     0.... 87520944us : drv_return_int: phy0 - 0
[  256.871268] kworker/-860     2.... 87580253us : drv_config: phy0 
ch:0x40 freq:2432
[  256.878824] kworker/-860     2.... 87581812us : drv_return_int: phy0 - 0
[  256.885515] kworker/-860     2.... 87641200us : drv_config: phy0 
ch:0x40 freq:2437
[  256.893071] kworker/-860     2.... 87642991us : drv_return_int: phy0 - 0
[  256.899762] kworker/-860     2.... 87702091us : drv_flush: phy0 drop:0
[  256.906280] kworker/-860     2.... 87786894us : drv_return_void: phy0
[  256.912712] kworker/-860     2.... 87786898us : drv_config: phy0 
ch:0x40 freq:2442
[  256.920269] kworker/-860     2.... 87788958us : drv_return_int: phy0 - 0
[  256.926959] kworker/-860     2.... 87848840us : drv_config: phy0 
ch:0x40 freq:2447
[  256.934514] kworker/-860     2.... 87850382us : drv_return_int: phy0 - 0
[  256.941205] kworker/-860     0.... 87909749us : drv_config: phy0 
ch:0x40 freq:2452
[  256.948762] kworker/-860     0.... 87911461us : drv_return_int: phy0 - 0
[  256.955454] kworker/-860     0.... 87970631us : drv_config: phy0 
ch:0x40 freq:2457
[  256.963011] kworker/-860     0.... 87972172us : drv_return_int: phy0 - 0
[  256.969702] kworker/-860     0.... 88031516us : drv_config: phy0 
ch:0x40 freq:2462
[  256.977260] kworker/-860     0.... 88033225us : drv_return_int: phy0 - 0
[  256.983952] kworker/-860     0.... 88092419us : drv_config: phy0 
ch:0x40 freq:2467
[  256.991509] kworker/-860     0.... 88094197us : drv_return_int: phy0 - 0
[  256.998200] kworker/-860     0.... 88218228us : drv_config: phy0 
ch:0x40 freq:2472
[  257.005758] kworker/-860     0.... 88221361us : drv_return_int: phy0 - 0
[  257.012450] kworker/-860     0.... 88346004us : drv_config: phy0 
ch:0x40 freq:2484
[  257.020006] kworker/-860     0.... 88346011us : drv_return_int: phy0 
- -5
[  257.026785] kworker/-860     0.... 88346020us : drv_config: phy0 
ch:0x40 freq:2437
[  257.034343] kworker/-860     0.... 88347743us : drv_return_int: phy0 - 0
[  257.041035] kworker/-860     0..s. 88347747us : 
drv_prepare_multicast: phy0 prepare mc (1)
[  257.049283] kworker/-860     0..s. 88347748us : drv_return_u64: phy0 - 0
[  257.055975] kworker/-860     0.... 88347750us : drv_configure_filter: 
phy0 changed:0x10 total:0x80000000
[  257.065436] kworker/-860     0.... 88347753us : drv_return_void: phy0
[  257.071866] kworker/-860     0.... 88347754us : drv_sw_scan_complete: 
phy0
[  257.078731] kworker/-860     0.... 88347756us : drv_return_void: phy0
[  257.085164] kworker/-860     0.... 88347785us : drv_bss_info_changed: 
phy0 vif:wlan4(2) changed:0x4000
[  257.094451] kworker/-860     0.N.. 88355118us : drv_return_void: phy0
[  257.100881] kworker/-860     0.... 88359345us : drv_flush: phy0 drop:0
[  257.107400] kworker/-860     0.... 88359349us : drv_return_void: phy0
[  257.113864] kworker/-860     0.... 88359355us : drv_config: phy0 
ch:0x100 freq:2437
[  257.121509] kworker/-860     0.... 88359357us : drv_return_int: phy0 - 0
[  257.128202] kworker/-860     0.... 88359574us : drv_bss_info_changed: 
phy0 vif:wlan4(2) changed:0x4000
[  257.137490] kworker/-860     0.N.. 88366966us : drv_return_void: phy0
[  257.143922] kworker/-860     0.... 88372547us : drv_config: phy0 
ch:0x100 freq:2437
[  257.151565] kworker/-860     0.... 88372550us : drv_return_int: phy0 - 0
[  257.158258] kworker/-860     0.... 88490860us : drv_sta_add: phy0 
vif:wlan4(2) sta:c0:c1:c0:04:b8:2c
[  257.167371] kworker/-860     0.... 88490864us : drv_return_int: phy0 - 0
[  257.174063] kworker/-860     0.... 88505489us : drv_conf_tx: phy0 
queue:2
[  257.180839] kworker/-860     0.... 88505638us : drv_return_int: phy0 - 0
[  257.187531] kworker/-860     0.... 88514161us : drv_conf_tx: phy0 
queue:3
[  257.194308] kworker/-860     0.... 88514285us : drv_return_int: phy0 - 0
[  257.201000] kworker/-860     0.... 88522622us : drv_conf_tx: phy0 
queue:1
[  257.207778] kworker/-860     0.... 88522750us : drv_return_int: phy0 - 0
[  257.214470] kworker/-860     0.... 88531013us : drv_conf_tx: phy0 
queue:0
[  257.221249] kworker/-860     0.... 88531137us : drv_return_int: phy0 - 0
[  257.227942] kworker/-860     0.... 88531138us : drv_bss_info_changed: 
phy0 vif:wlan4(2) changed:0x2000
[  257.237229] kworker/-860     0.N.. 88538700us : drv_return_void: phy0
[  257.243662] kworker/-860     0.... 88538727us : drv_config: phy0 
ch:0x42 freq:2437
[  257.251219] kworker/-860     0.... 88538734us : drv_return_int: phy0 - 0
[  257.257911] kworker/-860     0.... 88538740us : drv_bss_info_changed: 
phy0 vif:wlan4(2) changed:0x10fd
[  257.267199] kworker/-860     0.N.. 88554742us : drv_return_void: phy0
[  257.273633] kworker/-860     2.... 89390255us : drv_ampdu_action: 
phy0 vif:wlan4(2) sta:c0:c1:c0:04:b8:2c action:0 tid:0 buf:0
[  257.284998] kworker/-860     2.... 89390261us : drv_return_int: phy0 - 0
[  257.291690]   <idle>-0       0.Ns. 89775570us : 
api_start_tx_ba_session:  sta:c0:c1:c0:04:b8:2c tid:0
[  257.300891] kworker/-860     0d... 89775804us : stop_queue: phy0 
queue:2, reason:3
[  257.308448] kworker/-860     0.... 89782450us : drv_ampdu_action: 
phy0 vif:wlan4(2) sta:c0:c1:c0:04:b8:2c action:2 tid:0 buf:0
[  257.319811] kworker/-860     0.... 89782598us : drv_return_int: phy0 - 0
[  257.326503] kworker/-860     0d... 89782601us : wake_queue: phy0 
queue:2, reason:3
[  257.334064] kworker/-860     0.... 89782724us : api_start_tx_ba_cb: 
vif:wlan4(2) ra:c0:c1:c0:04:b8:2c tid:0
[  257.343874] kworker/-860     0.... 89959921us : drv_ampdu_action: 
phy0 vif:wlan4(2) sta:c0:c1:c0:04:b8:2c action:4 tid:0 buf:64
[  257.355324] kworker/-860     0.... 89959924us : drv_return_int: phy0 - 0
[  257.362018] kworker/-860     0d.s. 89959947us : stop_queue: phy0 
queue:2, reason:3
[  257.369576] kworker/-860     0d.s. 89959950us : wake_queue: phy0 
queue:2, reason:3
[  257.377132] NetworkM-1675    1.... 92914201us : drv_bss_info_changed: 
phy0 vif:wlan4(2) changed:0x1000
[  257.386420] NetworkM-1675    1.N.. 92923416us : drv_return_void: phy0
[  257.392853] kworker/-860     0..s. 92923606us : 
drv_prepare_multicast: phy0 prepare mc (2)
[  257.401104] kworker/-860     0..s. 92923607us : drv_return_u64: phy0 - 0
[  257.407793] kworker/-860     0.... 92923608us : drv_configure_filter: 
phy0 changed:0x0 total:0x80000000
[  257.417167] kworker/-860     0.... 92923609us : drv_return_void: phy0
[  257.423599]    <...>-1842    0.... 95130258us : drv_sw_scan_start: phy0
[  257.430203]    <...>-1842    0.... 95130265us : drv_return_void: phy0
[  257.436632]    <...>-1842    0..s. 95130749us : 
drv_prepare_multicast: phy0 prepare mc (2)
[  257.444880]    <...>-1842    0..s. 95130752us : drv_return_u64: phy0 - 0
[  257.451572]    <...>-1842    0.... 95130754us : drv_configure_filter: 
phy0 changed:0x10 total:0x80000010
[  257.461034]    <...>-1842    0.... 95130757us : drv_return_void: phy0
[  257.467464] kworker/-860     0.... 95160176us : drv_flush: phy0 drop:0
[  257.473982] kworker/-860     0.... 95160181us : drv_return_void: phy0
[  257.480414] kworker/-860     0.... 95160182us : drv_config: phy0 
ch:0x40 freq:2412
[  257.487971] kworker/-860     0.... 95161902us : drv_return_int: phy0 - 0
[  257.494662] kworker/-860     0.... 95221132us : drv_config: phy0 
ch:0x40 freq:2417
[  257.502220] kworker/-860     0.... 95222786us : drv_return_int: phy0 - 0
[  257.508910] kworker/-860     0.... 95282037us : drv_config: phy0 
ch:0x40 freq:2422
[  257.516467] kworker/-860     0.... 95283750us : drv_return_int: phy0 - 0
[  257.523160] kworker/-860     0.... 95342914us : drv_config: phy0 
ch:0x40 freq:2427
[  257.530720] kworker/-860     0.... 95344458us : drv_return_int: phy0 - 0
[  257.537411] kworker/-860     0.... 95403835us : drv_config: phy0 
ch:0x40 freq:2432
[  257.544966] kworker/-860     0.... 95405381us : drv_return_int: phy0 - 0
[  257.551658] kworker/-860     0.... 95464707us : drv_config: phy0 
ch:0x42 freq:2437
[  257.559215] kworker/-860     0.... 95466347us : drv_return_int: phy0 - 0
[  257.565905] kworker/-860     2.... 95526607us : drv_flush: phy0 drop:0
[  257.572424] kworker/-860     2.... 95792152us : drv_return_void: phy0
[  257.578856] kworker/-860     2.... 95792155us : drv_config: phy0 
ch:0x40 freq:2442
[  257.586414] kworker/-860     2.... 95793873us : drv_return_int: phy0 - 0
[  257.593104] kworker/-860     2.... 95853036us : drv_config: phy0 
ch:0x42 freq:2437
[  257.600661] kworker/-860     2.... 95856210us : drv_return_int: phy0 - 0
[  257.607351] kworker/-860     0.... 96058305us : drv_flush: phy0 drop:0
[  257.613871] kworker/-860     3.... 96126549us : drv_return_void: phy0
[  257.620302] kworker/-860     3.... 96126554us : drv_config: phy0 
ch:0x40 freq:2447
[  257.627859] kworker/-860     3.... 96128280us : drv_return_int: phy0 - 0
[  257.634551] kworker/-860     3.... 96187397us : drv_config: phy0 
ch:0x42 freq:2437
[  257.642106] kworker/-860     3.... 96189103us : drv_return_int: phy0 - 0
[  257.648799] kworker/-860     3.... 96388065us : drv_flush: phy0 drop:0
[  257.655314] kworker/-860     3.... 96440052us : drv_return_void: phy0
[  257.661746] kworker/-860     3.... 96440055us : drv_config: phy0 
ch:0x40 freq:2452
[  257.669303] kworker/-860     3.... 96443997us : drv_return_int: phy0 - 0
[  257.675994] kworker/-860     3.... 96503917us : drv_config: phy0 
ch:0x42 freq:2437
[  257.683755] kworker/-860     3.... 96505635us : drv_return_int: phy0 - 0
[  257.690446] kworker/-860     3.... 96704561us : drv_flush: phy0 drop:0
[  257.696963] kworker/-860     1.... 96726528us : drv_return_void: phy0
[  257.703397] kworker/-860     1.... 96726531us : drv_config: phy0 
ch:0x40 freq:2457
[  257.710952] kworker/-860     1.... 96728251us : drv_return_int: phy0 - 0
[  257.717644] kworker/-860     1.... 96787432us : drv_config: phy0 
ch:0x42 freq:2437
[  257.725201] kworker/-860     1.... 96789150us : drv_return_int: phy0 - 0
[  257.731892] kworker/-860     2.... 96988033us : drv_flush: phy0 drop:0
[  257.738410] kworker/-860     1.... 97037989us : drv_return_void: phy0
[  257.744841] kworker/-860     1.... 97037992us : drv_config: phy0 
ch:0x40 freq:2462
[  257.752396] kworker/-860     1.... 97039720us : drv_return_int: phy0 - 0
[  257.759087] kworker/-860     1.... 97098914us : drv_config: phy0 
ch:0x42 freq:2437
[  257.766641] kworker/-860     1.... 97102537us : drv_return_int: phy0 - 0
[  257.773331] kworker/-860     0.... 97301598us : drv_flush: phy0 drop:0
[  257.779849] kworker/-860     2.... 97429419us : drv_return_void: phy0
[  257.786281] kworker/-860     2.... 97429423us : drv_config: phy0 
ch:0x40 freq:2467
[  257.793837] kworker/-860     2.... 97431181us : drv_return_int: phy0 - 0
[  257.800529] kworker/-860     2.... 97555095us : drv_config: phy0 
ch:0x42 freq:2437
[  257.808084] kworker/-860     2.... 97556824us : drv_return_int: phy0 - 0
[  257.814775] kworker/-860     0.... 97755729us : drv_flush: phy0 drop:0
[  257.821293] kworker/-860     0.... 97792052us : drv_return_void: phy0
[  257.827725] kworker/-860     0.... 97792055us : drv_config: phy0 
ch:0x40 freq:2472
[  257.835280] kworker/-860     0.... 97793889us : drv_return_int: phy0 - 0
[  257.841972] kworker/-860     0.... 97918473us : drv_config: phy0 
ch:0x42 freq:2437
[  257.849530] kworker/-860     0.... 97920179us : drv_return_int: phy0 - 0
[  257.856220] kworker/-860     0.... 98119128us : drv_flush: phy0 drop:0
[  257.862738] kworker/-860     2.... 98164005us : drv_return_void: phy0
[  257.869171] kworker/-860     2.... 98164008us : drv_config: phy0 
ch:0x40 freq:2484
[  257.876728] kworker/-860     2.... 98164015us : drv_return_int: phy0 
- -5
[  257.883508] kworker/-860     2.... 98164024us : drv_config: phy0 
ch:0x42 freq:2437
[  257.891064] kworker/-860     2.... 98164030us : drv_return_int: phy0 - 0
[  257.897754] kworker/-860     2..s. 98164033us : 
drv_prepare_multicast: phy0 prepare mc (2)
[  257.906004] kworker/-860     2..s. 98164034us : drv_return_u64: phy0 - 0
[  257.912694] kworker/-860     2.... 98164036us : drv_configure_filter: 
phy0 changed:0x10 total:0x80000000
[  257.922156] kworker/-860     2.... 98164040us : drv_return_void: phy0
[  257.928589] kworker/-860     2.... 98164041us : drv_sw_scan_complete: 
phy0
[  257.935451] kworker/-860     2.... 98164044us : drv_return_void: phy0
[  257.941886]    <...>-1842    3.... 135062945us : drv_sw_scan_start: phy0
[  257.948577]    <...>-1842    3.... 135062953us : drv_return_void: phy0
[  257.955093]    <...>-1842    3..s. 135062991us : 
drv_prepare_multicast: phy0 prepare mc (2)
[  257.963428]    <...>-1842    3..s. 135062993us : drv_return_u64: phy0 
- 0
[  257.970206]    <...>-1842    3.... 135062995us : 
drv_configure_filter: phy0 changed:0x10 total:0x80000010
[  257.979751]    <...>-1842    3.... 135062999us : drv_return_void: phy0
[  257.986270] kworker/-860     3.... 135092999us : drv_flush: phy0 drop:0
[  257.992876] kworker/-860     0.... 135111045us : drv_return_void: phy0
[  257.999394] kworker/-860     0.... 135111047us : drv_config: phy0 
ch:0x40 freq:2412
[  258.007036] kworker/-860     0.... 135112763us : drv_return_int: phy0 
- 0
[  258.013815] kworker/-860     0.... 135171871us : drv_config: phy0 
ch:0x42 freq:2437
[  258.021457] kworker/-860     0.... 135173591us : drv_return_int: phy0 
- 0
[  258.028278] kworker/-860     1.... 135375705us : drv_flush: phy0 drop:0
[  258.034883] kworker/-860     1.... 135387599us : drv_return_void: phy0
[  258.041400] kworker/-860     1.... 135387601us : drv_config: phy0 
ch:0x40 freq:2417
[  258.049043] kworker/-860     1.... 135389317us : drv_return_int: phy0 
- 0
[  258.055822] kworker/-860     1.... 135448404us : drv_config: phy0 
ch:0x42 freq:2437
[  258.063466] kworker/-860     1.N.. 135450474us : drv_return_int: phy0 
- 0
[  258.070243] kworker/-860     2.... 135650094us : drv_flush: phy0 drop:0
[  258.076848] kworker/-860     0.... 135688022us : drv_return_void: phy0
[  258.083367] kworker/-860     0.... 135688025us : drv_config: phy0 
ch:0x40 freq:2422
[  258.091010] kworker/-860     0.... 135689741us : drv_return_int: phy0 
- 0
[  258.097788] kworker/-860     0.... 135748923us : drv_config: phy0 
ch:0x42 freq:2437
[  258.105430] kworker/-860     0.N.. 135750649us : drv_return_int: phy0 
- 0
[  258.112206] kworker/-860     0.... 135949605us : drv_flush: phy0 drop:0
[  258.118809] kworker/-860     0.... 135993492us : drv_return_void: phy0
[  258.125328] kworker/-860     0.... 135993494us : drv_config: phy0 
ch:0x40 freq:2427
[  258.132972] kworker/-860     0.... 135995194us : drv_return_int: phy0 
- 0
[  258.139749] kworker/-860     0.... 136054422us : drv_config: phy0 
ch:0x42 freq:2437
[  258.147390] kworker/-860     0.... 136055967us : drv_return_int: phy0 
- 0
[  258.154169] kworker/-860     2.... 136256385us : drv_flush: phy0 drop:0
[  258.160773] kworker/-860     2.... 136269983us : drv_return_void: phy0
[  258.167293] kworker/-860     2.... 136269986us : drv_config: phy0 
ch:0x40 freq:2432
[  258.174935] kworker/-860     2.... 136271707us : drv_return_int: phy0 
- 0
[  258.181713] kworker/-860     0.... 136330933us : drv_config: phy0 
ch:0x42 freq:2437
[  258.189356] kworker/-860     0.... 136333264us : drv_return_int: phy0 
- 0
[  258.196134] kworker/-860     1.... 136594503us : drv_flush: phy0 drop:0
[  258.202739] kworker/-860     0.... 136625405us : drv_return_void: phy0
[  258.209256] kworker/-860     0.... 136625408us : drv_config: phy0 
ch:0x40 freq:2442
[  258.216902] kworker/-860     0.... 136630209us : drv_return_int: phy0 
- 0
[  258.223681] kworker/-860     0.... 136689329us : drv_config: phy0 
ch:0x42 freq:2437
[  258.231324] kworker/-860     0.... 136690877us : drv_return_int: phy0 
- 0
[  258.238103] kworker/-860     0.... 136889894us : drv_flush: phy0 drop:0
[  258.244705] kworker/-860     0.... 136906688us : drv_return_void: phy0
[  258.251225] kworker/-860     0.... 136906691us : drv_config: phy0 
ch:0x40 freq:2447
[  258.258869] kworker/-860     0.... 136908484us : drv_return_int: phy0 
- 0
[  258.265645] kworker/-860     0.... 136967841us : drv_config: phy0 
ch:0x42 freq:2437
[  258.273288] kworker/-860     0.... 136969563us : drv_return_int: phy0 
- 0
[  258.280065] kworker/-860     0.... 137168478us : drv_flush: phy0 drop:0
[  258.286667] kworker/-860     0.... 137222345us : drv_return_void: phy0
[  258.293187] kworker/-860     0.... 137222348us : drv_config: phy0 
ch:0x40 freq:2452
[  258.300831] kworker/-860     0.... 137224495us : drv_return_int: phy0 
- 0
[  258.307610] kworker/-860     0.... 137284310us : drv_config: phy0 
ch:0x42 freq:2437
[  258.315254] kworker/-860     0.... 137286030us : drv_return_int: phy0 
- 0
[  258.322031] kworker/-860     0.... 137484895us : drv_flush: phy0 drop:0
[  258.328635] kworker/-860     0.... 137492843us : drv_return_void: phy0
[  258.335152] kworker/-860     0.... 137492845us : drv_config: phy0 
ch:0x40 freq:2457
[  258.342793] kworker/-860     0.... 137496583us : drv_return_int: phy0 
- 0
[  258.349571] kworker/-860     0.... 137555798us : drv_config: phy0 
ch:0x42 freq:2437
[  258.357214] kworker/-860     0.N.. 137557612us : drv_return_int: phy0 
- 0
[  258.363992] kworker/-860     0.... 137758410us : drv_flush: phy0 drop:0
[  258.370595] kworker/-860     0.... 137777666us : drv_return_void: phy0
[  258.377115] kworker/-860     0.... 137777669us : drv_config: phy0 
ch:0x40 freq:2462
[  258.384757] kworker/-860     0.... 137779425us : drv_return_int: phy0 
- 0
[  258.391535] kworker/-860     0.... 137839251us : drv_config: phy0 
ch:0x42 freq:2437
[  258.399177] kworker/-860     0.... 137841195us : drv_return_int: phy0 
- 0
[  258.405956] kworker/-860     0.... 138039924us : drv_flush: phy0 drop:0
[  258.412563] kworker/-860     0.... 138099920us : drv_return_void: phy0
[  258.419085] kworker/-860     0.... 138099923us : drv_config: phy0 
ch:0x40 freq:2467
[  258.426729] kworker/-860     0.... 138101644us : drv_return_int: phy0 
- 0
[  258.433505] kworker/-860     0.... 138225680us : drv_config: phy0 
ch:0x42 freq:2437
[  258.441146] kworker/-860     0.... 138227396us : drv_return_int: phy0 
- 0
[  258.447925] kworker/-860     0.... 138426771us : drv_flush: phy0 drop:0
[  258.454528] kworker/-860     0.... 138448425us : drv_return_void: phy0
[  258.461046] kworker/-860     0.... 138448427us : drv_config: phy0 
ch:0x40 freq:2472
[  258.468688] kworker/-860     0.... 138450224us : drv_return_int: phy0 
- 0
[  258.475506] kworker/-860     0.... 138575091us : drv_config: phy0 
ch:0x42 freq:2437
[  258.483149] kworker/-860     0.... 138576805us : drv_return_int: phy0 
- 0
[  258.489926] kworker/-860     0.... 138775968us : drv_flush: phy0 drop:0
[  258.496530] kworker/-860     0.... 138824838us : drv_return_void: phy0
[  258.503046] kworker/-860     0.... 138824841us : drv_config: phy0 
ch:0x40 freq:2484
[  258.510689] kworker/-860     0.... 138824847us : drv_return_int: phy0 
- -5
[  258.517553] kworker/-860     0.... 138824856us : drv_config: phy0 
ch:0x42 freq:2437
[  258.525196] kworker/-860     0.... 138824863us : drv_return_int: phy0 
- 0
[  258.531974] kworker/-860     0..s. 138824865us : 
drv_prepare_multicast: phy0 prepare mc (2)
[  258.540310] kworker/-860     0..s. 138824867us : drv_return_u64: phy0 
- 0
[  258.547092] kworker/-860     0.... 138824868us : 
drv_configure_filter: phy0 changed:0x10 total:0x80000000
[  258.556639] kworker/-860     0.... 138824872us : drv_return_void: phy0
[  258.563156] kworker/-860     0.... 138824873us : 
drv_sw_scan_complete: phy0
[  258.570105] kworker/-860     0.... 138824876us : drv_return_void: phy0
[  258.576624]    <...>-1842    1.... 194956987us : drv_sw_scan_start: phy0
[  258.583334]    <...>-1842    1.... 194956992us : drv_return_void: phy0
[  258.589856]    <...>-1842    1..s. 194957005us : 
drv_prepare_multicast: phy0 prepare mc (2)
[  258.598189]    <...>-1842    1..s. 194957006us : drv_return_u64: phy0 
- 0
[  258.604968]    <...>-1842    1.... 194957006us : 
drv_configure_filter: phy0 changed:0x10 total:0x80000010
[  258.614515]    <...>-1842    1.... 194957008us : drv_return_void: phy0
[  258.621034] kworker/-860     3.... 194989869us : drv_flush: phy0 drop:0
[  258.627638] kworker/-860     3.... 195021695us : drv_return_void: phy0
[  258.634156] kworker/-860     3.... 195021697us : drv_config: phy0 
ch:0x40 freq:2412
[  258.641798] kworker/-860     3.... 195023421us : drv_return_int: phy0 
- 0
[  258.648575] kworker/-860     3.... 195082623us : drv_config: phy0 
ch:0x42 freq:2437
[  258.656221] kworker/-860     3.... 195084344us : drv_return_int: phy0 
- 0
[  258.662997] kworker/-860     0.... 195283325us : drv_flush: phy0 drop:0
[  258.669603] kworker/-860     0.... 195297669us : drv_return_void: phy0
[  258.676290] kworker/-860     0.... 195297672us : drv_config: phy0 
ch:0x40 freq:2417
[  258.683933] kworker/-860     0.... 195299433us : drv_return_int: phy0 
- 0
[  258.690711] kworker/-860     0.... 195359176us : drv_config: phy0 
ch:0x42 freq:2437
[  258.698354] kworker/-860     0.... 195360894us : drv_return_int: phy0 
- 0
[  258.705133] kworker/-860     0.... 195574346us : drv_flush: phy0 drop:0
[  258.711739] kworker/-860     0.... 195584855us : drv_return_void: phy0
[  258.718258] kworker/-860     0.... 195584858us : drv_config: phy0 
ch:0x40 freq:2422
[  258.725899] kworker/-860     0.... 195586575us : drv_return_int: phy0 
- 0
[  258.732677] kworker/-860     0.... 195645666us : drv_config: phy0 
ch:0x42 freq:2437
[  258.740321] kworker/-860     0.... 195647392us : drv_return_int: phy0 
- 0
[  258.747100] kworker/-860     1.... 195856299us : drv_flush: phy0 drop:0
[  258.753705] kworker/-860     3.... 195872254us : drv_return_void: phy0
[  258.760224] kworker/-860     3.... 195872256us : drv_config: phy0 
ch:0x40 freq:2427
[  258.767868] kworker/-860     3.... 195873958us : drv_return_int: phy0 
- 0
[  258.774644] kworker/-860     3.... 195933195us : drv_config: phy0 
ch:0x42 freq:2437
[  258.782288] kworker/-860     3.... 195934902us : drv_return_int: phy0 
- 0
[  258.789067] kworker/-860     3.... 196133807us : drv_flush: phy0 drop:0
[  258.795670] kworker/-860     0.... 196156832us : drv_return_void: phy0
[  258.802187] kworker/-860     0.... 196156835us : drv_config: phy0 
ch:0x40 freq:2432
[  258.809828] kworker/-860     0.... 196158673us : drv_return_int: phy0 
- 0
[  258.816604] kworker/-860     0.... 196218695us : drv_config: phy0 
ch:0x42 freq:2437
[  258.824245] kworker/-860     0.... 196220241us : drv_return_int: phy0 
- 0
[  258.831023] kworker/-860     0.... 196499373us : drv_flush: phy0 drop:0
[  258.837627] kworker/-860     2.... 196529132us : drv_return_void: phy0
[  258.844143] kworker/-860     2.... 196529135us : drv_config: phy0 
ch:0x40 freq:2442
[  258.851786] kworker/-860     2.... 196530841us : drv_return_int: phy0 
- 0
[  258.858563] kworker/-860     2.... 196590096us : drv_config: phy0 
ch:0x42 freq:2437
[  258.866203] kworker/-860     2.... 196591984us : drv_return_int: phy0 
- 0
[  258.872982] kworker/-860     0.... 196791987us : drv_flush: phy0 drop:0
[  258.879585] kworker/-860     0.... 196803538us : drv_return_void: phy0
[  258.886101] kworker/-860     0.... 196803540us : drv_config: phy0 
ch:0x40 freq:2447
[  258.893749] kworker/-860     0.N.. 196805284us : drv_return_int: phy0 
- 0
[  258.900525] kworker/-860     0.... 196864576us : drv_config: phy0 
ch:0x42 freq:2437
[  258.908169] kworker/-860     0.... 196866298us : drv_return_int: phy0 
- 0
[  258.914946] kworker/-860     0.... 197065214us : drv_flush: phy0 drop:0
[  258.921550] kworker/-860     0.... 197095145us : drv_return_void: phy0
[  258.928070] kworker/-860     0.... 197095147us : drv_config: phy0 
ch:0x40 freq:2452
[  258.935714] kworker/-860     0.... 197096859us : drv_return_int: phy0 
- 0
[  258.942490] kworker/-860     0.... 197156045us : drv_config: phy0 
ch:0x42 freq:2437
[  258.950132] kworker/-860     0.... 197159659us : drv_return_int: phy0 
- 0
[  258.956910] kworker/-860     0.... 197358654us : drv_flush: phy0 drop:0
[  258.963514] kworker/-860     0.... 197367932us : drv_return_void: phy0
[  258.970032] kworker/-860     0.... 197367935us : drv_config: phy0 
ch:0x40 freq:2457
[  258.977673] kworker/-860     0.... 197369725us : drv_return_int: phy0 
- 0
[  258.984449] kworker/-860     0.... 197429607us : drv_config: phy0 
ch:0x42 freq:2437
[  258.992090] kworker/-860     0.... 197431330us : drv_return_int: phy0 
- 0
[  258.998865] kworker/-860     3.... 197633555us : drv_flush: phy0 drop:0
[  259.005467] kworker/-860     3.... 197667104us : drv_return_void: phy0
[  259.011984] kworker/-860     3.... 197667107us : drv_config: phy0 
ch:0x40 freq:2462
[  259.019628] kworker/-860     3.... 197669548us : drv_return_int: phy0 
- 0
[  259.026404] kworker/-860     3.... 197729020us : drv_config: phy0 
ch:0x42 freq:2437
[  259.034045] kworker/-860     3.... 197730726us : drv_return_int: phy0 
- 0
[  259.040822] kworker/-860     0.... 197930408us : drv_flush: phy0 drop:0
[  259.047426] kworker/-860     0.... 197992542us : drv_return_void: phy0
[  259.053942] kworker/-860     0.... 197992545us : drv_config: phy0 
ch:0x40 freq:2467
[  259.061584] kworker/-860     0.... 197994349us : drv_return_int: phy0 
- 0
[  259.068359] kworker/-860     0.... 198118402us : drv_config: phy0 
ch:0x42 freq:2437
[  259.076001] kworker/-860     0.... 198120121us : drv_return_int: phy0 
- 0
[  259.082778] kworker/-860     0.... 198321646us : drv_flush: phy0 drop:0
[  259.089381] kworker/-860     0.... 198333716us : drv_return_void: phy0
[  259.095898] kworker/-860     0.... 198333717us : drv_config: phy0 
ch:0x40 freq:2472
[  259.103540] kworker/-860     0.... 198335583us : drv_return_int: phy0 
- 0
[  259.110315] kworker/-860     0.... 198459830us : drv_config: phy0 
ch:0x42 freq:2437
[  259.117955] kworker/-860     0.... 198461549us : drv_return_int: phy0 
- 0
[  259.124731] kworker/-860     0.... 198662839us : drv_flush: phy0 drop:0
[  259.131340] kworker/-860     0.... 198734728us : drv_return_void: phy0
[  259.137857] kworker/-860     0.... 198734730us : drv_config: phy0 
ch:0x40 freq:2484
[  259.145500] kworker/-860     0.... 198734736us : drv_return_int: phy0 
- -5
[  259.152364] kworker/-860     0.... 198734746us : drv_config: phy0 
ch:0x42 freq:2437
[  259.160004] kworker/-860     0.... 198734752us : drv_return_int: phy0 
- 0
[  259.166781] kworker/-860     0..s. 198734755us : 
drv_prepare_multicast: phy0 prepare mc (2)
[  259.175113] kworker/-860     0..s. 198734756us : drv_return_u64: phy0 
- 0
[  259.181890] kworker/-860     0.... 198734758us : 
drv_configure_filter: phy0 changed:0x10 total:0x80000000
[  259.191433] kworker/-860     0.... 198734762us : drv_return_void: phy0
[  259.197949] kworker/-860     0.... 198734763us : 
drv_sw_scan_complete: phy0
[  259.204896] kworker/-860     0.... 198734766us : drv_return_void: phy0
[  259.211418]    rmmod-2770    2.... 239349910us : drv_ampdu_action: 
phy0 vif:wlan4(2) sta:c0:c1:c0:04:b8:2c action:3 tid:0 buf:0
[  259.222867]    rmmod-2770    2.... 239350087us : drv_return_int: phy0 
- 0
[  259.229646]    rmmod-2770    2.... 239350094us : drv_ampdu_action: 
phy0 vif:wlan4(2) sta:c0:c1:c0:04:b8:2c action:1 tid:0 buf:0
[  259.241096]    rmmod-2770    2.... 239350095us : drv_return_int: phy0 
- 0
[  259.247873] kworker/-860     0.... 239350110us : api_stop_tx_ba_cb: 
vif:wlan4(2) ra:c0:c1:c0:04:b8:2c tid:0
[  259.257677]    rmmod-2770    2.... 239350445us : drv_conf_tx: phy0 
queue:0
[  259.264540]    rmmod-2770    2.... 239350545us : drv_return_int: phy0 
- 0
[  259.271316]    rmmod-2770    2.... 239350546us : drv_conf_tx: phy0 
queue:1
[  259.278179] kworker/-860     0d.s. 239350566us : stop_queue: phy0 
queue:2, reason:3
[  259.285821] kworker/-860     0d.s. 239350570us : wake_queue: phy0 
queue:2, reason:3
[  259.293461]    rmmod-2770    2.... 239350636us : drv_return_int: phy0 
- 0
[  259.300236]    rmmod-2770    2.... 239350637us : drv_conf_tx: phy0 
queue:2
[  259.307100]    rmmod-2770    2.... 239350723us : drv_return_int: phy0 
- 0
[  259.313877]    rmmod-2770    2.... 239350723us : drv_conf_tx: phy0 
queue:3
[  259.320741]    rmmod-2770    2.... 239350808us : drv_return_int: phy0 
- 0
[  259.327519]    rmmod-2770    2.... 239350810us : 
drv_bss_info_changed: phy0 vif:wlan4(2) changed:0x2000
[  259.336892]    rmmod-2770    2.N.. 239358853us : drv_return_void: phy0
[  259.343411]    rmmod-2770    2.... 239359036us : drv_config: phy0 
ch:0x40 freq:2437
[  259.351053]    rmmod-2770    2.... 239359041us : drv_return_int: phy0 
- 0
[  259.357829]    rmmod-2770    2.... 239359041us : 
drv_bss_info_changed: phy0 vif:wlan4(2) changed:0x109f
[  259.367201]    rmmod-2770    2.N.. 239375423us : drv_return_void: phy0
[  259.373719]    rmmod-2770    2.... 239396636us : drv_sta_remove: phy0 
vif:wlan4(2) sta:c0:c1:c0:04:b8:2c
[  259.383176]    rmmod-2770    2.... 239396638us : drv_return_void: phy0
[  259.389694]    rmmod-2770    2.... 239420750us : drv_flush: phy0 drop:0
[  259.396299]    rmmod-2770    2.... 239619856us : drv_return_void: phy0
[  259.402815]    rmmod-2770    2.... 239619860us : drv_config: phy0 
ch:0x100 freq:2437
[  259.410545]    rmmod-2770    2.... 239619871us : drv_return_int: phy0 
- 0
[  259.417322]    rmmod-2770    0..s. 239628899us : 
drv_prepare_multicast: phy0 prepare mc (0)
[  259.425655]    rmmod-2770    0..s. 239628902us : drv_return_u64: phy0 
- 0
[  259.432431]    rmmod-2770    0.... 239628904us : 
drv_configure_filter: phy0 changed:0x0 total:0x80000000
[  259.441888]    rmmod-2770    0.... 239628906us : drv_return_void: phy0
[  259.448406]    rmmod-2770    0.... 239638851us : 
drv_remove_interface: phy0 vif:wlan4(2) addr:90:4c:e5:65:10:31
[  259.458471]    rmmod-2770    0.N.. 239642500us : drv_return_void: phy0
[  259.464984]    rmmod-2770    0.... 239642762us : drv_stop: phy0
[  259.470894]    rmmod-2770    0d... 239642773us : stop_queue: phy0 
queue:0, reason:0
[  259.478535]    rmmod-2770    0d... 239642774us : stop_queue: phy0 
queue:1, reason:0
[  259.486176]    rmmod-2770    0d... 239642776us : stop_queue: phy0 
queue:2, reason:0
[  259.493818]    rmmod-2770    0d... 239642777us : stop_queue: phy0 
queue:3, reason:0
[  259.501458]    rmmod-2770    0.... 239642780us : drv_return_void: phy0
[  259.507964] ---------------------------------
[  259.512308] Modules linked in: brcmutil(C) fuse drm_kms_helper drm 
snd_hda_codec_hdmi i2c_algo_bit dell_wmi snd_hda_codec_idt snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss sdhci_pci ehci_hcd 
sdhci firewire_ohci firewire_core snd_pcm mmc_core crc_itu_t usbcore 
snd_page_alloc wmi video [last unloaded: brcmsmac]
[  259.541531]
[  259.543021] Pid: 2774, comm: crda Tainted: G         C 
2.6.39-rc4-kgdb-110510+ #85 Dell Inc. Latitude E6410/07XJP9
[  259.553468] EIP: 0060:[<c131e2cf>] EFLAGS: 00010246 CPU: 2
[  259.558941] EIP is at set_regdom+0x1a0/0x4d8
[  259.563200] EAX: 00000000 EBX: f25a93b0 ECX: 00000246 EDX: 00000000
[  259.569446] ESI: ffffff8e EDI: 000186a0 EBP: f22bdc58 ESP: f22bdc18
[  259.575694]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  259.581077] Process crda (pid: 2774, ti=f22bc000 task=f0893600 
task.ti=f22bc000)
[  259.588448] Stack:
[  259.590453]  f4402240 00000000 f22bdc50 ee282b30 f25a9428 00000008 
00000006 f22bdc50
[  259.598284]  c11a9c57 00000006 f22bdc6c f25a9428 f25a93b0 f25a9440 
f25a93b0 ee282b38
[  259.606117]  f22bdc94 c132537e 00000000 00000006 00000006 00000000 
ee282b08 ee282b10
[  259.613950] Call Trace:
[  259.616398]  [<c11a9c57>] ? nla_parse+0x3f/0x98
[  259.620920]  [<c132537e>] nl80211_set_reg+0x18b/0x1d5
[  259.625961]  [<c12c7f15>] genl_rcv_msg+0x1ad/0x1ce
[  259.630741]  [<c12c7d68>] ? genl_rcv+0x22/0x22
[  259.635174]  [<c12c794c>] netlink_rcv_skb+0x32/0x73
[  259.640040]  [<c12c7d61>] genl_rcv+0x1b/0x22
[  259.644300]  [<c12c7534>] netlink_unicast+0xc0/0x114
[  259.649253]  [<c12c77b4>] netlink_sendmsg+0x22c/0x244
[  259.654296]  [<c12a2387>] __sock_sendmsg+0x51/0x5a
[  259.659074]  [<c12a29bc>] sock_sendmsg+0x91/0xa9
[  259.663682]  [<c10ac9ba>] ? might_fault+0x47/0x85
[  259.668544]  [<c12aa2b8>] ? copy_from_user+0x8/0xa
[  259.673323]  [<c12aa5d0>] ? verify_iovec+0x3e/0x76
[  259.678101]  [<c12a3c0e>] sys_sendmsg+0x13e/0x18c
[  259.682795]  [<c1006887>] ? native_sched_clock+0x49/0x4f
[  259.688097]  [<c104b56a>] ? sched_clock_cpu+0x3f/0x125
[  259.693223]  [<c1057020>] ? __lock_acquire+0x565/0xc02
[  259.698348]  [<c104b56a>] ? sched_clock_cpu+0x3f/0x125
[  259.703475]  [<c1054bba>] ? trace_hardirqs_off+0xb/0xd
[  259.708599]  [<c104b67d>] ? local_clock+0x2d/0x4e
[  259.713292]  [<c1054dc4>] ? lock_release_holdtime+0x30/0xb5
[  259.718850]  [<c1057776>] ? lock_release_non_nested+0xb9/0x20c
[  259.724666]  [<c10ac9ba>] ? might_fault+0x47/0x85
[  259.729357]  [<c10ac9ba>] ? might_fault+0x47/0x85
[  259.734054]  [<c12a3fe0>] sys_socketcall+0x161/0x19f
[  259.739008]  [<c11a0a70>] ? trace_hardirqs_on_thunk+0xc/0x10
[  259.744656]  [<c1370e4c>] sysenter_do_call+0x12/0x32
[  259.749603] Code: ff 76 08 68 42 ca 4e c1 e8 09 b8 04 00 83 c4 14 47 
83 c6 18 3b 3b 72 bc e9 9c 01 00 00 83 78 04 02 75 29 8b 45 c4 be 8e ff 
ff ff
[  259.763206]  b8 80 00 00 00 00 0f 85 86 01 00 00 83 e8 80 89 da e8 71 ee
[  259.770454] EIP: [<c131e2cf>] set_regdom+0x1a0/0x4d8 SS:ESP 
0068:f22bdc18
[  259.777264] CR2: 0000000000000080
[  259.780790] ---[ end trace 5eefd53f32deebc2 ]---
[  259.785415] Kernel panic - not syncing: Fatal exception
[  259.790643] Pid: 2774, comm: crda Tainted: G      D  C 
2.6.39-rc4-kgdb-110510+ #85
[  259.798291] Call Trace:
[  259.800743]  [<c1369ac9>] ? printk+0xf/0x16
[  259.804919]  [<c13699ba>] panic+0x50/0x150
[  259.809035]  [<c136cd1f>] oops_end+0x8b/0x9a
[  259.813308]  [<c101da74>] no_context+0x10e/0x118
[  259.817921]  [<c101db72>] __bad_area_nosemaphore+0xf4/0xfc
[  259.823403]  [<c101dbbf>] bad_area+0x35/0x3b
[  259.827675]  [<c136e4cb>] do_page_fault+0x1c2/0x304
[  259.832553]  [<c1057d5e>] ? mark_held_locks+0x41/0x5d
[  259.837606]  [<c136abd2>] ? __mutex_lock_common+0x2ad/0x2c1
[  259.843178]  [<c1057e78>] ? trace_hardirqs_on_caller+0xfe/0x11f
[  259.849147]  [<c1054b57>] ? trace_hardirqs_off_caller+0x2e/0x86
[  259.855065]  [<c136e309>] ? notify_page_fault+0x3b/0x3b
[  259.860289]  [<c136c4c7>] error_code+0x5f/0x64
[  259.864732]  [<c136e309>] ? notify_page_fault+0x3b/0x3b
[  259.869953]  [<c131e2cf>] ? set_regdom+0x1a0/0x4d8
[  259.874745]  [<c11a9c57>] ? nla_parse+0x3f/0x98
[  259.879276]  [<c132537e>] nl80211_set_reg+0x18b/0x1d5
[  259.884322]  [<c12c7f15>] genl_rcv_msg+0x1ad/0x1ce
[  259.889101]  [<c12c7d68>] ? genl_rcv+0x22/0x22
[  259.893542]  [<c12c794c>] netlink_rcv_skb+0x32/0x73
[  259.898419]  [<c12c7d61>] genl_rcv+0x1b/0x22
[  259.902683]  [<c12c7534>] netlink_unicast+0xc0/0x114
[  259.907643]  [<c12c77b4>] netlink_sendmsg+0x22c/0x244
[  259.912690]  [<c12a2387>] __sock_sendmsg+0x51/0x5a
[  259.917474]  [<c12a29bc>] sock_sendmsg+0x91/0xa9
[  259.922087]  [<c10ac9ba>] ? might_fault+0x47/0x85
[  259.926782]  [<c12aa2b8>] ? copy_from_user+0x8/0xa
[  259.931561]  [<c12aa5d0>] ? verify_iovec+0x3e/0x76
[  259.936343]  [<c12a3c0e>] sys_sendmsg+0x13e/0x18c
[  259.941041]  [<c1006887>] ? native_sched_clock+0x49/0x4f
[  259.946346]  [<c104b56a>] ? sched_clock_cpu+0x3f/0x125
[  259.951476]  [<c1057020>] ? __lock_acquire+0x565/0xc02
[  259.956602]  [<c104b56a>] ? sched_clock_cpu+0x3f/0x125
[  259.961730]  [<c1054bba>] ? trace_hardirqs_off+0xb/0xd
[  259.966856]  [<c104b67d>] ? local_clock+0x2d/0x4e
[  259.971549]  [<c1054dc4>] ? lock_release_holdtime+0x30/0xb5
[  259.977111]  [<c1057776>] ? lock_release_non_nested+0xb9/0x20c
[  259.982932]  [<c10ac9ba>] ? might_fault+0x47/0x85
[  259.987627]  [<c10ac9ba>] ? might_fault+0x47/0x85
[  259.992323]  [<c12a3fe0>] sys_socketcall+0x161/0x19f
[  259.997279]  [<c11a0a70>] ? trace_hardirqs_on_thunk+0xc/0x10
[  260.002928]  [<c1370e4c>] sysenter_do_call+0x12/0x32

