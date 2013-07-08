Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lmv.inov.pt ([146.193.64.2]:56353 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab3GHWsK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 18:48:10 -0400
Message-ID: <51DB4195.8090103@inov.pt> (sfid-20130709_004818_046728_C2513C6D)
Date: Mon, 08 Jul 2013 23:47:49 +0100
From: =?ISO-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>
MIME-Version: 1.0
To: Arik Nemtsov <arik@wizery.com>
CC: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Subject: Re: wl127x: Unable to associate with a WPA2-PSK AP
References: <51DB0ACC.7050800@inov.pt> <CA+XVXfcakDiN1pPqGDQAN=VR8p_C1LUWGt_nX-rGXDLsBkk+Dw@mail.gmail.com>
In-Reply-To: <CA+XVXfcakDiN1pPqGDQAN=VR8p_C1LUWGt_nX-rGXDLsBkk+Dw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arik,

Yep, that patch solved the kernel warning, but the association with  the AP is 
still lost after 3 warnings;

wlcore: Beacon loss detected. roles:0xff

To use the driver in the Luca's tree I need to do some work to adapt my platform 
to the latest kernel version, what I would like to avoid  for now.
Is there any set of patches to put  the driver in vanilla kernel 3.9 in a more 
stable condition?

Best regards,
Jose Gonçalves

On 08-07-2013 20:08, Arik Nemtsov wrote:
> Hey,
>
> About the second issue - seems the following patch is missing from your tree:
> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/105449
>
> So the warning is bogus. It will happen if you're working on a single
> processor (UP) system.
>
> To get the latest driver, you can use Luca's tree, which already
> contains this patch:
> git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git
>
> Arik
>
>
> On Mon, Jul 8, 2013 at 9:54 PM, José Miguel Gonçalves
> <jose.goncalves@inov.pt> wrote:
>> Hi,
>>
>> After solving some initial platform issues, I'm now blocked in two more
>> issues using the wl127x driver with kernel 3.9.9 in a S3C2416 hardware based
>> platform.
>>
>> The first one is that the command "iw wlan0 scan" does not scan all
>> frequencies. I've seen a patch submitted to fix an issue in the driver for
>> the 5 GHz band
>> (http://permalink.gmane.org/gmane.linux.kernel.wireless.general/107771) but
>> this is not my issue, because I can not see also several APs in the 2.4GHz
>> band after a scan.
>>
>> The second issue is when I try to associate with an AP using WPA2-PSK with
>> wpa_supplicant (only able to reach this point by setting "scan_freq" in
>> wpa_supplicat.conf file to the frequency used by the AP, because of the
>> inability to perform of a complete scan) I get an error in the driver, as
>> shown in the log bellow:
>>
>>
>> [root ~]$ wpa_supplicant -i wlan0 -c /etc/wpa_supplicant.conf
>> Successfully initialized wpa_supplicant
>> [   33.915000] wlcore: firmware booted (Rev 6.3.10.0.133)
>> [   34.280000] cfg80211: Calling CRDA for country: PT
>> [   34.290000] cfg80211: Regulatory domain changed to country: PT
>> [   34.290000] cfg80211:   (start_freq - end_freq @ bandwidth),
>> (max_antenna_gain, max_eirp)
>> [   34.305000] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A,
>> 2000 mBm)
>> [   34.320000] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A,
>> 2000 mBm)
>> [   34.320000] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A,
>> 2000 mBm)
>> [   34.330000] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A,
>> 2700 mBm)
>> [   34.340000] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz),
>> (N/A, 4000 mBm)
>> wlan0: SME: Trying to authenticate with 88:43:e1:57:79:c0 (SSID='[
>> 34.585000] wlan0: authenticate with 88:43:e1:57:79:c0
>> A. Guidance' freq=2452 MHz)
>> [   34.595000] ------------[ cut here ]------------
>> [   34.595000] WARNING: at drivers/net/wireless/ti/wlcore/tx.c:1307
>> wlcore_is_queue_stopped_by_reason_locked+0x98/0xb4 [wlcore]()
>> [   34.595000] Modules linked in: arc4 wl12xx wlcore mac80211 wlcore_sdio
>> lm70
>> [   34.595000] Backtrace:
>> [   34.595000] [<c000b92c>] (dump_backtrace+0x0/0x10c) from [<c02ed4a4>]
>> (dump_stack+0x18/0x1c)
>> [   34.595000]  r6:bf05ddd8 r5:00000009 r4:00000000 r3:00000000
>> [   34.595000] [<c02ed48c>] (dump_stack+0x0/0x1c) from [<c0019ecc>]
>> (warn_slowpath_common+0x54/0x70)
>> [   34.595000] [<c0019e78>] (warn_slowpath_common+0x0/0x70) from
>> [<c0019f0c>] (warn_slowpath_null+0x24/0x2c)
>> [   34.595000]  r8:c39e2acc r7:00000000 r6:c305b160 r5:bf06ca36 r4:00000002
>> r3:00000009
>> [   34.595000] [<c0019ee8>] (warn_slowpath_null+0x0/0x2c) from [<bf05ddd8>]
>> (wlcore_is_queue_stopped_by_reason_locked+0x98/0xb4 [wlcore])
>> [   34.595000] [<bf05dd40>]
>> (wlcore_is_queue_stopped_by_reason_locked+0x0/0xb4 [wlcore]) from
>> [<bf05de38>] (wlcore_is_queue_stopped_by_reason+0x44/0x7c [wlcore])
>> [   34.595000]  r6:00000000 r5:c305b160 r4:80000013
>> [   34.595000] [<bf05ddf4>] (wlcore_is_queue_stopped_by_reason+0x0/0x7c
>> [wlcore]) from [<bf05deb4>] (wl1271_handle_tx_low_watermark+0x44/0x94
>> [wlcore])
>> [   34.595000]  r8:c305b160 r7:c39e2acc r6:00000000 r5:c39e2acc r4:00000000
>> r3:00000000
>> [   34.595000] [<bf05de70>] (wl1271_handle_tx_low_watermark+0x0/0x94
>> [wlcore]) from [<bf05e050>] (wl1271_tx_reset_link_queues+0x14c/0x174
>> [wlcore])
>> [   34.595000] [<bf05df04>] (wl1271_tx_reset_link_queues+0x0/0x174 [wlcore])
>> from [<bf05970c>] (wl12xx_free_link+0xec/0x150 [wlcore])
>> [   34.595000] [<bf059620>] (wl12xx_free_link+0x0/0x150 [wlcore]) from
>> [<bf059b50>] (wl12xx_cmd_role_stop_sta+0x98/0x100 [wlcore])
>> [   34.595000]  r7:c305b160 r6:00000000 r5:c39e2acc r4:c3a89ac0
>> [   34.595000] [<bf059ab8>] (wl12xx_cmd_role_stop_sta+0x0/0x100 [wlcore])
>> from [<bf0546d8>] (wl1271_bss_info_changed_sta+0x840/0x9a4 [wlcore])
>> [   34.595000]  r7:c39e2acc r6:c305b160 r5:c39e2a10 r4:000000e0
>> [   34.595000] [<bf053e98>] (wl1271_bss_info_changed_sta+0x0/0x9a4 [wlcore])
>> from [<bf054a0c>] (wl1271_op_bss_info_changed+0x1d0/0x46c [wlcore])
>> [   34.595000] [<bf05483c>] (wl1271_op_bss_info_changed+0x0/0x46c [wlcore])
>> from [<bf009538>] (ieee80211_bss_info_change_notify+0x6c/0x10c [mac80211])
>> [   34.595000] [<bf0094cc>] (ieee80211_bss_info_change_notify+0x0/0x10c
>> [mac80211]) from [<bf02bf1c>] (ieee80211_prep_connection+0x2dc/0x76c
>> [mac80211])
>> [   34.595000]  r7:00000fff r6:c39cfe48 r5:c305b8e4 r4:c39e2440
>> [   34.595000] [<bf02bc40>] (ieee80211_prep_connection+0x0/0x76c [mac80211])
>> from [<bf030d70>] (ieee80211_mgd_auth+0x228/0x29c [mac80211])
>> [   34.595000] [<bf030b48>] (ieee80211_mgd_auth+0x0/0x29c [mac80211]) from
>> [<bf01afd4>] (ieee80211_auth+0x18/0x1c [mac80211])
>> [   34.595000] [<bf01afbc>] (ieee80211_auth+0x0/0x1c [mac80211]) from
>> [<c02e40a8>] (__cfg80211_mlme_auth+0x170/0x188)
>> [   34.595000] [<c02e3f38>] (__cfg80211_mlme_auth+0x0/0x188) from
>> [<c02e4154>] (cfg80211_mlme_auth+0x94/0xb8)
>> [   34.595000] [<c02e40c0>] (cfg80211_mlme_auth+0x0/0xb8) from [<c02dffbc>]
>> (nl80211_authenticate+0x258/0x27c)
>> [   34.595000] [<c02dfd64>] (nl80211_authenticate+0x0/0x27c) from
>> [<c0260044>] (genl_rcv_msg+0x23c/0x274)
>> [   34.595000] [<c025fe08>] (genl_rcv_msg+0x0/0x274) from [<c025f458>]
>> (netlink_rcv_skb+0xb4/0xc8)
>> [   34.595000] [<c025f3a4>] (netlink_rcv_skb+0x0/0xc8) from [<c025fdfc>]
>> (genl_rcv+0x20/0x2c)
>> [   34.595000]  r6:00000048 r5:c3a5b400 r4:c38c4bc0 r3:c025fddc
>> [   34.595000] [<c025fddc>] (genl_rcv+0x0/0x2c) from [<c025ee40>]
>> (netlink_unicast+0x1b0/0x214)
>> [   34.595000]  r4:c38c5e00 r3:c025fddc
>> [   34.595000] [<c025ec90>] (netlink_unicast+0x0/0x214) from [<c025f230>]
>> (netlink_sendmsg+0x2e0/0x358)
>> [   34.595000] [<c025ef50>] (netlink_sendmsg+0x0/0x358) from [<c0230944>]
>> (sock_sendmsg+0x88/0xa8)
>> [   34.595000] [<c02308bc>] (sock_sendmsg+0x0/0xa8) from [<c0230d64>]
>> (___sys_sendmsg+0x2c8/0x2e0)
>> [   34.595000] [<c0230a9c>] (___sys_sendmsg+0x0/0x2e0) from [<c0232920>]
>> (__sys_sendmsg+0x44/0x70)
>> [   34.595000] [<c02328dc>] (__sys_sendmsg+0x0/0x70) from [<c023295c>]
>> (sys_sendmsg+0x10/0x14)
>> [   34.595000]  r6:be94fa8c r5:017940a0 r4:00000000
>> [   34.595000] [<c023294c>] (sys_sendmsg+0x0/0x14) from [<c0009400>]
>> (ret_fast_syscall+0x0/0x2c)
>> [   34.595000] ---[ end trace a2c5f3d5ef286154 ]---
>> [   34.605000] wlan0: send auth to 88:43:e1:57:79:c0 (try 1/3)
>> [   34.605000] ------------[ cut here ]------------
>> [   34.605000] WARNING: at drivers/net/wireless/ti/wlcore/tx.c:1316
>> wlcore_is_queue_stopped_locked+0x74/0x8c [wlcore]()
>> [   34.605000] Modules linked in: arc4 wl12xx wlcore mac80211 wlcore_sdio
>> lm70
>> [   34.605000] Backtrace:
>> [   34.605000] [<c000b92c>] (dump_backtrace+0x0/0x10c) from [<c02ed4a4>]
>> (dump_stack+0x18/0x1c)
>> [   34.605000]  r6:bf05f240 r5:00000009 r4:00000000 r3:00000000
>> [   34.605000] [<c02ed48c>] (dump_stack+0x0/0x1c) from [<c0019ecc>]
>> (warn_slowpath_common+0x54/0x70)
>> [   34.605000] [<c0019e78>] (warn_slowpath_common+0x0/0x70) from
>> [<c0019f0c>] (warn_slowpath_null+0x24/0x2c)
>> [   34.605000]  r8:40000013 r7:c305b160 r6:c305b160 r5:bf06ca36 r4:00000000
>> r3:00000009
>> [   34.605000] [<c0019ee8>] (warn_slowpath_null+0x0/0x2c) from [<bf05f240>]
>> (wlcore_is_queue_stopped_locked+0x74/0x8c [wlcore])
>> [   34.605000] [<bf05f1cc>] (wlcore_is_queue_stopped_locked+0x0/0x8c
>> [wlcore]) from [<bf05225c>] (wl1271_op_tx+0x104/0x290 [wlcore])
>> [   34.605000]  r6:c39e2a10 r5:00000001 r4:c38c4a40 r3:00000003
>> [   34.605000] [<bf052158>] (wl1271_op_tx+0x0/0x290 [wlcore]) from
>> [<bf023e64>] (__ieee80211_tx+0x134/0x384 [mac80211])
>> [   34.605000] [<bf023d30>] (__ieee80211_tx+0x0/0x384 [mac80211]) from
>> [<bf024174>] (ieee80211_tx+0xc0/0xe8 [mac80211])
>> [   34.605000] [<bf0240b4>] (ieee80211_tx+0x0/0xe8 [mac80211]) from
>> [<bf02474c>] (ieee80211_xmit+0x80/0x94 [mac80211])
>> [   34.605000] [<bf0246cc>] (ieee80211_xmit+0x0/0x94 [mac80211]) from
>> [<bf025698>] (__ieee80211_tx_skb_tid_band+0x58/0x64 [mac80211])
>> [   34.605000]  r8:00000000 r7:00000001 r6:00000000 r5:c39e2440 r4:c38c4a40
>> r3:c3ae8000
>> [   34.605000] [<bf025640>] (__ieee80211_tx_skb_tid_band+0x0/0x64
>> [mac80211]) from [<bf0286c4>] (ieee80211_send_auth+0x158/0x1e0 [mac80211])
>> [   34.605000]  r6:c39e2440 r5:c38c4a40 r4:c3ac8b94 r3:00000000
>> [   34.605000] [<bf02856c>] (ieee80211_send_auth+0x0/0x1e0 [mac80211]) from
>> [<bf02c550>] (ieee80211_probe_auth+0x174/0x2c8 [mac80211])
>> [   34.605000] [<bf02c3dc>] (ieee80211_probe_auth+0x0/0x2c8 [mac80211]) from
>> [<bf030d80>] (ieee80211_mgd_auth+0x238/0x29c [mac80211])
>> [   34.605000]  r8:c39e2798 r7:00000000 r6:c39e2440 r5:c3a72c20 r4:c3ae9af8
>> [   34.605000] [<bf030b48>] (ieee80211_mgd_auth+0x0/0x29c [mac80211]) from
>> [<bf01afd4>] (ieee80211_auth+0x18/0x1c [mac80211])
>> [   34.605000] [<bf01afbc>] (ieee80211_auth+0x0/0x1c [mac80211]) from
>> [<c02e40a8>] (__cfg80211_mlme_auth+0x170/0x188)
>> [   34.605000] [<c02e3f38>] (__cfg80211_mlme_auth+0x0/0x188) from
>> [<c02e4154>] (cfg80211_mlme_auth+0x94/0xb8)
>> [   34.605000] [<c02e40c0>] (cfg80211_mlme_auth+0x0/0xb8) from [<c02dffbc>]
>> (nl80211_authenticate+0x258/0x27c)
>> [   34.605000] [<c02dfd64>] (nl80211_authenticate+0x0/0x27c) from
>> [<c0260044>] (genl_rcv_msg+0x23c/0x274)
>> [   34.605000] [<c025fe08>] (genl_rcv_msg+0x0/0x274) from [<c025f458>]
>> (netlink_rcv_skb+0xb4/0xc8)
>> [   34.605000] [<c025f3a4>] (netlink_rcv_skb+0x0/0xc8) from [<c025fdfc>]
>> (genl_rcv+0x20/0x2c)
>> [   34.605000]  r6:00000048 r5:c3a5b400 r4:c38c4bc0 r3:c025fddc
>> [   34.605000] [<c025fddc>] (genl_rcv+0x0/0x2c) from [<c025ee40>]
>> (netlink_unicast+0x1b0/0x214)
>> [   34.605000]  r4:c38c5e00 r3:c025fddc
>> [   34.605000] [<c025ec90>] (netlink_unicast+0x0/0x214) from [<c025f230>]
>> (netlink_sendmsg+0x2e0/0x358)
>> [   34.605000] [<c025ef50>] (netlink_sendmsg+0x0/0x358) from [<c0230944>]
>> (sock_sendmsg+0x88/0xa8)
>> [   34.605000] [<c02308bc>] (sock_sendmsg+0x0/0xa8) from [<c0230d64>]
>> (___sys_sendmsg+0x2c8/0x2e0)
>> [   34.605000] [<c0230a9c>] (___sys_sendmsg+0x0/0x2e0) from [<c0232920>]
>> (__sys_sendmsg+0x44/0x70)
>> [   34.605000] [<c02328dc>] (__sys_sendmsg+0x0/0x70) from [<c023295c>]
>> (sys_sendmsg+0x10/0x14)
>> [   34.605000]  r6:be94fa8c r5:017940a0 r4:00000000
>> [   34.605000] [<c023294c>] (sys_sendmsg+0x0/0x14) from [<c0009400>]
>> (ret_fast_syscall+0x0/0x2c)
>> [   34.605000] ---[ end trace a2c5f3d5ef286155 ]---
>> [   34.625000] wlan0: send auth to 88:43:e1:57:79:c0 (try 2/3)
>> [   34.640000] wlan0: send auth to 88:43:e1:57:79:c0 (try 3/3)
>> [   34.650000] wlan0: authentication with 88:43:e1:57:79:c0 timed out
>> wlan0: SME: Trying to authenticate with 88:43:e1:57:79:c0 (SSID='[
>> 34.875000] wlan0: authenticate with 88:43:e1:57:79:c0
>> A. Guidance' freq=2452 MHz)
>> [   34.915000] wlan0: send auth to 88:43:e1:57:79:c0 (try 1/3)
>> [   34.920000] wlan0: authenticated
>> wlan0: Trying to associate with 88:43:e1:57:79:c0 (SSID='A. Guidance'
>> freq=2452 MHz)
>> [   34.995000] wlan0: associate with 88:43:e1:57:79:c0 (try 1/3)
>> [   35.015000] wlan0: associate with 88:43:e1:57:79:c0 (try 2/3)
>> [   35.035000] wlan0: associate with 88:43:e1:57:79:c0 (try 3/3)
>> [   35.060000] wlan0: association with 88:43:e1:57:79:c0 timed out
>> wlan0: SME: Trying to authenticate with 88:43:e1:57:79:c0 (SSID='[
>> 35.620000] wlan0: authenticate with 88:43:e1:57:79:c0
>> A. Guidance' freq=2452 MHz)
>> [   35.660000] wlan0: send auth to 88:43:e1:57:79:c0 (try 1/3)
>> [   35.665000] wlan0: authenticated
>> wlan0: Trying to associate with 88:43:e1:57:79:c0 (SSID='A. Guidance'
>> freq=2452 MHz)
>> [   35.740000] wlan0: associate with 88:43:e1:57:79:c0 (try 1/3)
>> [   35.745000] wlan0: RX AssocResp from 88:43:e1:57:79:c0 (capab=0x431
>> status=0 aid=2)
>> [   35.765000] wlan0: associated
>> [   35.770000] cfg80211: Calling CRDA for country: PT
>> [   35.780000] cfg80211: Regulatory domain changed to country: PT
>> [   35.780000] cfg80211:   (start_freq - end_freq @ bandwidth),
>> (max_antenna_gain, max_eirp)
>> [   35.790000] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A,
>> 2000 mBm)
>> [   35.790000] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A,
>> 2000 mBm)
>> [   35.800000] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A,
>> 2000 mBm)
>> [   35.800000] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A,
>> 2700 mBm)
>> [   35.810000] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz),
>> (N/A, 4000 mBm)
>> wlan0: Associated with 88:43:e1:57:79:c0
>> [   37.585000] wlcore: Beacon loss detected. roles:0xff
>> [   39.250000] wlcore: Beacon loss detected. roles:0xff
>> [   40.935000] wlcore: Beacon loss detected. roles:0xff
>> [   42.400000] wlcore: Connection loss work (role_id: 0).
>> [   42.400000] wlan0: Connection to AP 88:43:e1:57:79:c0 lost
>> [   42.475000] cfg80211: Calling CRDA to update world regulatory domain
>> [   42.485000] cfg80211: World regulatory domain updated:
>> [   42.485000] cfg80211:   (start_freq - end_freq @ bandwidth),
>> (max_antenna_gain, max_eirp)
>> [   42.500000] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300
>> mBi, 2000 mBm)
>> [   42.500000] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300
>> mBi, 2000 mBm)
>> [   42.515000] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300
>> mBi, 2000 mBm)
>> [   42.515000] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300
>> mBi, 2000 mBm)
>> [   42.525000] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300
>> mBi, 2000 mBm)
>> [   42.525000] cfg80211: Calling CRDA for country: PT
>> [   42.540000] cfg80211: Regulatory domain changed to country: PT
>> [   42.540000] cfg80211:   (start_freq - end_freq @ bandwidth),
>> (max_antenna_gain, max_eirp)
>> [   42.550000] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A,
>> 2000 mBm)
>> [   42.550000] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A,
>> 2000 mBm)
>> [   42.560000] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A,
>> 2000 mBm)
>> [   42.560000] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A,
>> 2700 mBm)
>> wlan0: CTRL-EVENT-DISCONNECTED bssid=88:43:e1:57:79:c0 reason=4 l[
>> 42.575000] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A,
>> 4000 mBm)
>> ocally_generated=1
>> wlan0: WPA: 4-Way Handshake failed - pre-shared key may be incorrect
>> wlan0: CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="A. Guidance" auth_failures=1
>> duration=10
>>
>>
>> Any ideas in what could be wrong?
>>
>> Best regards,
>> José Gonçalves
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
____________________________________________________________

José Miguel P. Gonçalves   * email:  jose.goncalves@inov.pt
                            *
INOV                       * Tel.(Phone):  +351 213 100 474
Av. Duque de Ávila, 23     *
1000-138 Lisboa            *
PORTUGAL                   * WWW:        http://www.inov.pt
____________________________________________________________

