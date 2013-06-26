Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from amx141.rev.netart.pl ([85.128.206.141]:60877 "EHLO
	amx141.rev.netart.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3FZGuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 02:50:08 -0400
From: =?iso-8859-2?Q?B=B3a=BFej_Szajrych?= <bs@macrix.pl>
To: <linux-wireless@vger.kernel.org>, <backports@vger.kernel.org>
Cc: <daw@macrix.pl>, <pg@macrix.de>
Subject: ADHOC issue with WL12xx driver 
Date: Wed, 26 Jun 2013 08:50:08 +0200
Message-ID: <007501ce7239$65e40df0$31ac29d0$@macrix.pl> (sfid-20130626_085013_278704_E64D448A)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0076_01CE724A.29736DA0"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multipart message in MIME format.

------=_NextPart_000_0076_01CE724A.29736DA0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable

Hi,

We are encountering serious AD-HOC problems:
.	Commands are run successfully
.	The network is theoretically created
.	It is not visible for other devices and the DMESG show that an error
occurs and the firmware reboots

More info:
.	The box running Linux is the VAR SOM OM44
.	The operation system we are using is Ubuntu 12.04 LTS on the
3.4.0-1490-omap4 kernel.=20
.	The processor is in the ARM architecture.
.	WiFi  card: Murata LBEH59XUHC.
.	WiFi driver: wl12xx, wlcore firmware wl127x-fw-5-sr.bin with Rev
6.3.10.0.135.
.	Network connection through the router is working. Network manager is
used to configure the connection.
.	Ad-hoc mode connection is not working - the network is not visible
to other computers.

Commands used to configure the network in adhoc mode are as follows =
(wlan0
is the WiFi interface name):

1.	Using iw:
.	ifconfig wlan0 down
.	iw wlan0 set type ibss
.	ifconfig wlan0 up
.	iw wlan0 ibss join ADHOC_TEST 2437

2.	Using iwconfig
.	ifconfig wlan0 down=20
.	iwconfig wlan0 mode ad-hoc
.	iwconfig wlan0 channel 6
.	iwconfig wlan0 essid ADHOC_TEST
.	ifconfig wlan0 up



Attached you will find the dmesg messages (dmesg.txt).
Using the latest backport of Compat Wireless backports-3.10-rc1-2 did =
not
help.
Testing with different WiFI dongles gave different results.
TP Link WN725N that uses the Realtek 8192cu driver and is based on the
RTL8188CUS-GR chipset is working correctly in AD-HOC mode.

Could you guide us in anyway in resolving this issue?=20

Pozdrawiam, Best Regards,

B=B3a=BFej Szajrych
Software Developer
+48 669 710 648

Macrix Polska Sp. Z o. o. Sp. K.
ul. Podlaska 15=20
PL 60-623 Poznan=20
tel.: +48 61 865 47 23=20
fax: +48 61 865 47 24


------=_NextPart_000_0076_01CE724A.29736DA0
Content-Type: text/plain;
	name="dmesg.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg.txt"

[ 5138.270751] ---[ end trace da227214a8249879 ]---=0A=
[ 5138.270782] wlcore: ERROR failed to initiate cmd role enable=0A=
[ 5138.278594] wlcore: WARNING cmd join failed -110=0A=
[ 5138.278625] wlcore: Reading FW panic log=0A=
[ 5138.278625] ------------[ cut here ]------------=0A=
[ 5138.278686] WARNING: at =
/home/variscite/Downloads/backports-3.10-rc1-2/drivers/net/wireless/ti/wl=
core/cmd.c:63 wlcore_cmd_send_failsafe+0x40/0x3a0 [wlcore]()=0A=
[ 5138.278686] Modules linked in: rtl8192c_common(O) rtlwifi(O) =
8192cu(O) omapdrm_pvr(O) wl12xx(O) wlcore(O) mac80211(O) cfg80211(O) =
joydev omapdce(C) rpmsg_omx bnep(O) omaprpc(C) rfcomm(O) omap_remoteproc =
rpmsg_resmgr_common ppdev remoteproc bluetooth(O) omap_rpmsg_resmgr =
rpmsg_resmgr virtio_rpmsg_bus lp virtio virtio_ring parport dm_multipath =
at24 wlcore_sdio(O) compat(O) hid_apple usbhid hid dm_mirror =
dm_region_hash dm_log btrfs zlib_deflate libcrc32c=0A=
[ 5138.278778] [<c001bc38>] (unwind_backtrace+0x0/0xec) from =
[<c05accd0>] (dump_stack+0x20/0x24)=0A=
[ 5138.278808] [<c05accd0>] (dump_stack+0x20/0x24) from [<c00458d4>] =
(warn_slowpath_common+0x5c/0x74)=0A=
[ 5138.278808] [<c00458d4>] (warn_slowpath_common+0x5c/0x74) from =
[<c0045918>] (warn_slowpath_null+0x2c/0x34)=0A=
[ 5138.278839] [<c0045918>] (warn_slowpath_null+0x2c/0x34) from =
[<bf40c304>] (wlcore_cmd_send_failsafe+0x40/0x3a0 [wlcore])=0A=
[ 5138.278900] [<bf40c304>] (wlcore_cmd_send_failsafe+0x40/0x3a0 =
[wlcore]) from [<bf40c690>] (wl1271_cmd_send+0x2c/0x38 [wlcore])=0A=
[ 5138.278930] [<bf40c690>] (wl1271_cmd_send+0x2c/0x38 [wlcore]) from =
[<bf40edf4>] (wl12xx_cmd_stop_fwlog+0x7c/0xb8 [wlcore])=0A=
[ 5138.278991] [<bf40edf4>] (wl12xx_cmd_stop_fwlog+0x7c/0xb8 [wlcore]) =
from [<bf409908>] (wl1271_recovery_work+0xcc/0x3ac [wlcore])=0A=
[ 5138.279022] [<bf409908>] (wl1271_recovery_work+0xcc/0x3ac [wlcore]) =
from [<c0061d0c>] (process_one_work+0x294/0x48c)=0A=
[ 5138.279022] [<c0061d0c>] (process_one_work+0x294/0x48c) from =
[<c0062214>] (worker_thread+0x144/0x240)=0A=
[ 5138.279052] [<c0062214>] (worker_thread+0x144/0x240) from =
[<c0067090>] (kthread+0x9c/0xa8)=0A=
[ 5138.279052] [<c0067090>] (kthread+0x9c/0xa8) from [<c00144a4>] =
(kernel_thread_exit+0x0/0x8)=0A=
[ 5138.279052] ---[ end trace da227214a824987a ]---=0A=
[ 5138.279083] ------------[ cut here ]------------=0A=
[ 5138.279083] WARNING: at =
/home/variscite/Downloads/backports-3.10-rc1-2/drivers/net/wireless/ti/wl=
core/main.c:790 wl12xx_queue_recovery_work+0x30/0x6c [wlcore]()=0A=
[ 5138.279113] Modules linked in: rtl8192c_common(O) rtlwifi(O) =
8192cu(O) omapdrm_pvr(O) wl12xx(O) wlcore(O) mac80211(O) cfg80211(O) =
joydev omapdce(C) rpmsg_omx bnep(O) omaprpc(C) rfcomm(O) omap_remoteproc =
rpmsg_resmgr_common ppdev remoteproc bluetooth(O) omap_rpmsg_resmgr =
rpmsg_resmgr virtio_rpmsg_bus lp virtio virtio_ring parport dm_multipath =
at24 wlcore_sdio(O) compat(O) hid_apple usbhid hid dm_mirror =
dm_region_hash dm_log btrfs zlib_deflate libcrc32c=0A=
[ 5138.279205] [<c001bc38>] (unwind_backtrace+0x0/0xec) from =
[<c05accd0>] (dump_stack+0x20/0x24)=0A=
[ 5138.279205] [<c05accd0>] (dump_stack+0x20/0x24) from [<c00458d4>] =
(warn_slowpath_common+0x5c/0x74)=0A=
[ 5138.279235] [<c00458d4>] (warn_slowpath_common+0x5c/0x74) from =
[<c0045918>] (warn_slowpath_null+0x2c/0x34)=0A=
[ 5138.279266] [<c0045918>] (warn_slowpath_null+0x2c/0x34) from =
[<bf4093f8>] (wl12xx_queue_recovery_work+0x30/0x6c [wlcore])=0A=
[ 5138.279296] [<bf4093f8>] (wl12xx_queue_recovery_work+0x30/0x6c =
[wlcore]) from [<bf40c644>] (wlcore_cmd_send_failsafe+0x380/0x3a0 =
[wlcore])=0A=
[ 5138.279357] [<bf40c644>] (wlcore_cmd_send_failsafe+0x380/0x3a0 =
[wlcore]) from [<bf40c690>] (wl1271_cmd_send+0x2c/0x38 [wlcore])=0A=
[ 5138.279388] [<bf40c690>] (wl1271_cmd_send+0x2c/0x38 [wlcore]) from =
[<bf40edf4>] (wl12xx_cmd_stop_fwlog+0x7c/0xb8 [wlcore])=0A=
[ 5138.279418] [<bf40edf4>] (wl12xx_cmd_stop_fwlog+0x7c/0xb8 [wlcore]) =
from [<bf409908>] (wl1271_recovery_work+0xcc/0x3ac [wlcore])=0A=
[ 5138.279449] [<bf409908>] (wl1271_recovery_work+0xcc/0x3ac [wlcore]) =
from [<c0061d0c>] (process_one_work+0x294/0x48c)=0A=
[ 5138.279479] [<c0061d0c>] (process_one_work+0x294/0x48c) from =
[<c0062214>] (worker_thread+0x144/0x240)=0A=
[ 5138.279479] [<c0062214>] (worker_thread+0x144/0x240) from =
[<c0067090>] (kthread+0x9c/0xa8)=0A=
[ 5138.279510] [<c0067090>] (kthread+0x9c/0xa8) from [<c00144a4>] =
(kernel_thread_exit+0x0/0x8)=0A=
[ 5138.279510] ---[ end trace da227214a824987b ]---=0A=
[ 5138.279510] wlcore: ERROR failed to send stop firmware logger command=0A=
[ 5138.289611] wlcore: Hardware recovery in progress. FW ver: Rev =
6.3.10.0.133=0A=
[ 5138.289916] wlcore: pc: 0x1b6d6, hint_sts: 0x00000000 count: 574=0A=
[ 5138.290161] wlcore: down=0A=
[ 5138.292236] ieee80211 phy0: Hardware restart was requested=0A=
[ 5138.876770] wlcore: firmware booted (Rev 6.3.10.0.133)=0A=
[ 5140.889648] wlcore: ERROR command complete timeout=0A=
[ 5140.894653] ------------[ cut here ]------------=0A=
[ 5140.894714] WARNING: at =
/home/variscite/Downloads/backports-3.10-rc1-2/drivers/net/wireless/ti/wl=
core/main.c:790 wl12xx_queue_recovery_work+0x30/0x6c [wlcore]()=0A=
[ 5140.894714] Modules linked in: rtl8192c_common(O) rtlwifi(O) =
8192cu(O) omapdrm_pvr(O) wl12xx(O) wlcore(O) mac80211(O) cfg80211(O) =
joydev omapdce(C) rpmsg_omx bnep(O) omaprpc(C) rfcomm(O) omap_remoteproc =
rpmsg_resmgr_common ppdev remoteproc bluetooth(O) omap_rpmsg_resmgr =
rpmsg_resmgr virtio_rpmsg_bus lp virtio virtio_ring parport dm_multipath =
at24 wlcore_sdio(O) compat(O) hid_apple usbhid hid dm_mirror =
dm_region_hash dm_log btrfs zlib_deflate libcrc32c=0A=
[ 5140.894836] [<c001bc38>] (unwind_backtrace+0x0/0xec) from =
[<c05accd0>] (dump_stack+0x20/0x24)=0A=
[ 5140.894866] [<c05accd0>] (dump_stack+0x20/0x24) from [<c00458d4>] =
(warn_slowpath_common+0x5c/0x74)=0A=
[ 5140.894866] [<c00458d4>] (warn_slowpath_common+0x5c/0x74) from =
[<c0045918>] (warn_slowpath_null+0x2c/0x34)=0A=
[ 5140.894897] [<c0045918>] (warn_slowpath_null+0x2c/0x34) from =
[<bf4093f8>] (wl12xx_queue_recovery_work+0x30/0x6c [wlcore])=0A=
[ 5140.894958] [<bf4093f8>] (wl12xx_queue_recovery_work+0x30/0x6c =
[wlcore]) from [<bf40c644>] (wlcore_cmd_send_failsafe+0x380/0x3a0 =
[wlcore])=0A=
[ 5140.894989] [<bf40c644>] (wlcore_cmd_send_failsafe+0x380/0x3a0 =
[wlcore]) from [<bf40c690>] (wl1271_cmd_send+0x2c/0x38 [wlcore])=0A=
[ 5140.895050] [<bf40c690>] (wl1271_cmd_send+0x2c/0x38 [wlcore]) from =
[<bf40d6a0>] (wl12xx_cmd_role_start_ibss+0x174/0x1c8 [wlcore])=0A=
[ 5140.895080] [<bf40d6a0>] (wl12xx_cmd_role_start_ibss+0x174/0x1c8 =
[wlcore]) from [<bf407e88>] (wl1271_op_bss_info_changed+0x834/0xcb4 =
[wlcore])=0A=
[ 5140.895202] [<bf407e88>] (wl1271_op_bss_info_changed+0x834/0xcb4 =
[wlcore]) from [<bf345be0>] =
(ieee80211_bss_info_change_notify+0x198/0x240 [mac80211])=0A=
[ 5140.895416] [<bf345be0>] =
(ieee80211_bss_info_change_notify+0x198/0x240 [mac80211]) from =
[<bf36db98>] (ieee80211_reconfig+0x1630/0x1e18 [mac80211])=0A=
[ 5140.895568] [<bf36db98>] (ieee80211_reconfig+0x1630/0x1e18 =
[mac80211]) from [<bf34518c>] (ieee80211_restart_work+0x80/0x94 =
[mac80211])=0A=
[ 5140.895660] [<bf34518c>] (ieee80211_restart_work+0x80/0x94 =
[mac80211]) from [<c0061d0c>] (process_one_work+0x294/0x48c)=0A=
[ 5140.895690] [<c0061d0c>] (process_one_work+0x294/0x48c) from =
[<c0062214>] (worker_thread+0x144/0x240)=0A=
[ 5140.895690] [<c0062214>] (worker_thread+0x144/0x240) from =
[<c0067090>] (kthread+0x9c/0xa8)=0A=
[ 5140.895721] [<c0067090>] (kthread+0x9c/0xa8) from [<c00144a4>] =
(kernel_thread_exit+0x0/0x8)=0A=
[ 5140.895721] ---[ end trace da227214a824987c ]---=0A=
[ 5140.895751] wlcore: ERROR failed to initiate cmd role enable=0A=
[ 5140.903717] wlcore: WARNING cmd join failed -110=0A=
[ 5140.903778] wlcore: Reading FW panic log
------=_NextPart_000_0076_01CE724A.29736DA0--

