Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:50330 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbZCRM1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 08:27:04 -0400
Received: by ewy9 with SMTP id 9so19958ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2009 05:26:59 -0700 (PDT)
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
Message-Id: <39909ECD-1C54-4FF2-A029-E99B037DB93A@icix.org> (sfid-20090318_132710_931311_B3C6EA80)
From: Antonio Marques <froz@icix.org>
To: Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <200903181102.21380.IvDoorn@gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: rt2x00 mesh support
Date: Wed, 18 Mar 2009 12:26:54 +0000
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org> <200903180001.07723.IvDoorn@gmail.com> <1237331062.5100.9.camel@johannes.local> <200903181102.21380.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mar 18, 2009, at 10:02 , Ivo van Doorn wrote:
> On Wednesday 18 March 2009, Johannes Berg wrote:
>> On Wed, 2009-03-18 at 00:01 +0100, Ivo van Doorn wrote:
>>
>>>>> This command means that mac80211 uses the start() callback  
>>>>> function. This triggers rt2x00 to initialize
>>>>> the registers which resets the beacon generation.
>>>>
>>>> Strange, that doesn't seem right. If you look at net/mac80211/ 
>>>> iface.c,
>>>> you'll see it call ->start(), then ->add_interface(), and later
>>>> ieee80211_start_mesh(), which calls _if_config() and sets
>>>> beacon/beacon_enabled.
>>>
>>> ok, I gone through the rt2x00 code a couple of times now to see  
>>> how this bug can be triggered by rt2x00,
>>> But the only other scenario I could find, is when the open()  
>>> callback for the netdevice structure doesn't end
>>> with a call to the config() callback function. But as far as I see  
>>> it that is happening correctly.
>>
>> Maybe log (+dump_stack()) all the relevant calls from mac80211 to the
>> driver? That might give us a better idea of what's going on. Also,
>> Antonio, make sure you're using the very latest code. I for one need
>> sleep now :)
>
> Antonio, could you please use attached patch to add additional  
> debugging to rt2x00.
> This will do a dump_stack for all important functions  
> (add_interface, remove_interface, config() and config_interface())
>
> It doesn't matter if this patch is on top of the previous patch or  
> not.
>
> Thanks,
>
> Ivo
> <debug.diff>

Ok, I have updated to the very latest code (still the same behaviour  
though) and
applied the new patch.  The rather lengthy list of backtraces is  
attached.

Antonio Marques

After interface creation and before running 'iwlist mesh scan':

[ 2486.171848] phy3 -> rt73usb_validate_eeprom: EEPROM recovery - NIC:  
0xffef
[ 2486.171851] phy3 -> rt73usb_validate_eeprom: EEPROM recovery - Led:  
0xe000
[ 2486.171854] phy3 -> rt73usb_validate_eeprom: EEPROM recovery - RSSI  
OFFSET A: 0x0000
[ 2486.172220] phy3 -> rt2x00_set_chip: Info - Chipset detected - rt:  
1300, rf: 0002, rev: 0002573a.
[ 2486.172232] cfg80211: Enabling active scanning on frequency: 2472  
MHz (Ch 13) on phy3
[ 2486.172234] cfg80211: Enabling beaconing on frequency: 2472 MHz (Ch  
13) on phy3
[ 2486.174042] phy3: Selected rate control algorithm 'minstrel'
[ 2486.174726] Registered led device: rt73usb-phy3::radio
[ 2486.174739] Registered led device: rt73usb-phy3::assoc
[ 2486.174752] Registered led device: rt73usb-phy3::quality
[ 2486.175422] usbcore: registered new interface driver rt73usb
[ 2495.307749] phy3 -> rt2x00lib_request_firmware: Info - Loading  
firmware file 'rt73.bin'.
[ 2495.307755] rt73usb 1-5:1.0: firmware: requesting rt73.bin
[ 2495.312370] phy3 -> rt2x00lib_request_firmware: Info - Firmware  
detected - version: 1.7.
[ 2495.333900] phy3 -> rt2x00mac_add_interface: Error - ===>
[ 2495.398572] Pid: 5061, comm: ifconfig Not tainted 2.6.29-rc8-wl #1
[ 2495.398574] Call Trace:
[ 2495.398583]  [<c038ae85>] ? printk+0x18/0x1b
[ 2495.398592]  [<fa513388>] rt2x00mac_add_interface+0x58/0x200  
[rt2x00lib]
[ 2495.398624]  [<f7f82f87>] ieee80211_open+0x2c7/0x8e0 [mac80211]
[ 2495.398631]  [<c030eb62>] dev_open+0x82/0xf0
[ 2495.398634]  [<c038d9b1>] ? _spin_unlock_bh+0x11/0x20
[ 2495.398637]  [<c030e479>] dev_change_flags+0x139/0x1d0
[ 2495.398641]  [<c0353b02>] devinet_ioctl+0x542/0x600
[ 2495.398644]  [<c011c29f>] ? do_page_fault+0x2ef/0x800
[ 2495.398647]  [<c0354dca>] inet_ioctl+0x9a/0xc0
[ 2495.398651]  [<c02ffee3>] sock_ioctl+0x63/0x260
[ 2495.398653]  [<c02ffe80>] ? sock_ioctl+0x0/0x260
[ 2495.398658]  [<c01b9358>] vfs_ioctl+0x28/0x90
[ 2495.398660]  [<c01b9872>] do_vfs_ioctl+0x72/0x5b0
[ 2495.398664]  [<c01c13f0>] ? alloc_fd+0xe0/0x100
[ 2495.398666]  [<c038d7a8>] ? _spin_lock+0x8/0x10
[ 2495.398670]  [<c01aad27>] ? do_sys_open+0xd7/0x100
[ 2495.398673]  [<c01aad27>] ? do_sys_open+0xd7/0x100
[ 2495.398676]  [<c01adfaf>] ? fput+0x1f/0x30
[ 2495.398679]  [<c01b9e13>] sys_ioctl+0x63/0x70
[ 2495.398682]  [<c010366f>] sysenter_do_call+0x12/0x33
[ 2495.400364] phy3 -> rt73usb_config_intf: Error - TXRX_CSR9 WRITE:  
0x000d0000, READ: 0x000d0000
[ 2495.503881] phy3 -> rt2x00mac_add_interface: Error - <===
[ 2495.568516] phy3 -> rt2x00mac_config_interface: Error - ===>
[ 2495.636217] Pid: 5061, comm: ifconfig Not tainted 2.6.29-rc8-wl #1
[ 2495.636219] Call Trace:
[ 2495.636222]  [<c038ae85>] ? printk+0x18/0x1b
[ 2495.636228]  [<fa513579>] rt2x00mac_config_interface+0x49/0x130  
[rt2x00lib]
[ 2495.636241]  [<fa513530>] ? rt2x00mac_config_interface+0x0/0x130  
[rt2x00lib]
[ 2495.636252]  [<f7f76a39>] ieee80211_if_config+0xd9/0x1f0 [mac80211]
[ 2495.636268]  [<f7f9398a>] ieee80211_start_mesh+0x2a/0x30 [mac80211]
[ 2495.636279]  [<f7f83489>] ieee80211_open+0x7c9/0x8e0 [mac80211]
[ 2495.636284]  [<c030eb62>] dev_open+0x82/0xf0
[ 2495.636286]  [<c038d9b1>] ? _spin_unlock_bh+0x11/0x20
[ 2495.636290]  [<c030e479>] dev_change_flags+0x139/0x1d0
[ 2495.636292]  [<c0353b02>] devinet_ioctl+0x542/0x600
[ 2495.636295]  [<c011c29f>] ? do_page_fault+0x2ef/0x800
[ 2495.636298]  [<c0354dca>] inet_ioctl+0x9a/0xc0
[ 2495.636301]  [<c02ffee3>] sock_ioctl+0x63/0x260
[ 2495.636304]  [<c02ffe80>] ? sock_ioctl+0x0/0x260
[ 2495.636307]  [<c01b9358>] vfs_ioctl+0x28/0x90
[ 2495.636310]  [<c01b9872>] do_vfs_ioctl+0x72/0x5b0
[ 2495.636312]  [<c01c13f0>] ? alloc_fd+0xe0/0x100
[ 2495.636315]  [<c038d7a8>] ? _spin_lock+0x8/0x10
[ 2495.636318]  [<c01aad27>] ? do_sys_open+0xd7/0x100
[ 2495.636320]  [<c01aad27>] ? do_sys_open+0xd7/0x100
[ 2495.636323]  [<c01adfaf>] ? fput+0x1f/0x30
[ 2495.636326]  [<c01b9e13>] sys_ioctl+0x63/0x70
[ 2495.636329]  [<c010366f>] sysenter_do_call+0x12/0x33
[ 2495.638657] phy3 -> rt73usb_config_intf: Error - TXRX_CSR9 WRITE:  
0x000d0000, READ: 0x000d0000
[ 2495.742550] phy3 -> rt73usb_write_beacon: Error - TXRX_CSR9 WRITE:  
0x00040000, READ: 0x00040000
[ 2495.848942] phy3 -> rt73usb_kick_tx_queue: Error - TXRX_CSR9 WRITE:  
0x001d0000, READ: 0x001d0000
[ 2495.954156] phy3 -> rt2x00mac_config_interface: Error - <===
[ 2496.021865] Pid: 5061, comm: ifconfig Not tainted 2.6.29-rc8-wl #1
[ 2496.021867] Call Trace:
[ 2496.021870]  [<c038ae85>] ? printk+0x18/0x1b
[ 2496.021876]  [<fa51362d>] rt2x00mac_config_interface+0xfd/0x130  
[rt2x00lib]
[ 2496.021889]  [<fa513530>] ? rt2x00mac_config_interface+0x0/0x130  
[rt2x00lib]
[ 2496.021900]  [<f7f76a39>] ieee80211_if_config+0xd9/0x1f0 [mac80211]
[ 2496.021914]  [<f7f9398a>] ieee80211_start_mesh+0x2a/0x30 [mac80211]
[ 2496.021925]  [<f7f83489>] ieee80211_open+0x7c9/0x8e0 [mac80211]
[ 2496.021931]  [<c030eb62>] dev_open+0x82/0xf0
[ 2496.021933]  [<c038d9b1>] ? _spin_unlock_bh+0x11/0x20
[ 2496.021937]  [<c030e479>] dev_change_flags+0x139/0x1d0
[ 2496.021940]  [<c0353b02>] devinet_ioctl+0x542/0x600
[ 2496.021943]  [<c011c29f>] ? do_page_fault+0x2ef/0x800
[ 2496.021946]  [<c0354dca>] inet_ioctl+0x9a/0xc0
[ 2496.021948]  [<c02ffee3>] sock_ioctl+0x63/0x260
[ 2496.021951]  [<c02ffe80>] ? sock_ioctl+0x0/0x260
[ 2496.021954]  [<c01b9358>] vfs_ioctl+0x28/0x90
[ 2496.021957]  [<c01b9872>] do_vfs_ioctl+0x72/0x5b0
[ 2496.021960]  [<c01c13f0>] ? alloc_fd+0xe0/0x100
[ 2496.021962]  [<c038d7a8>] ? _spin_lock+0x8/0x10
[ 2496.021965]  [<c01aad27>] ? do_sys_open+0xd7/0x100
[ 2496.021968]  [<c01aad27>] ? do_sys_open+0xd7/0x100
[ 2496.021971]  [<c01adfaf>] ? fput+0x1f/0x30
[ 2496.021974]  [<c01b9e13>] sys_ioctl+0x63/0x70
[ 2496.021976]  [<c010366f>] sysenter_do_call+0x12/0x33
[ 2496.022818] phy3 -> rt2x00mac_config: Error - ===>
[ 2496.080208] Pid: 5061, comm: ifconfig Not tainted 2.6.29-rc8-wl #1
[ 2496.080209] Call Trace:
[ 2496.080213]  [<c038ae85>] ? printk+0x18/0x1b
[ 2496.080219]  [<fa5136a6>] rt2x00mac_config+0x46/0xf0 [rt2x00lib]
[ 2496.080235]  [<f7f76ee2>] ieee80211_hw_config+0xb2/0xc0 [mac80211]
[ 2496.080246]  [<f7f8330f>] ieee80211_open+0x64f/0x8e0 [mac80211]
[ 2496.080252]  [<c030eb62>] dev_open+0x82/0xf0
[ 2496.080255]  [<c038d9b1>] ? _spin_unlock_bh+0x11/0x20
[ 2496.080258]  [<c030e479>] dev_change_flags+0x139/0x1d0
[ 2496.080261]  [<c0353b02>] devinet_ioctl+0x542/0x600
[ 2496.080263]  [<c011c29f>] ? do_page_fault+0x2ef/0x800
[ 2496.080267]  [<c0354dca>] inet_ioctl+0x9a/0xc0
[ 2496.080269]  [<c02ffee3>] sock_ioctl+0x63/0x260
[ 2496.080272]  [<c02ffe80>] ? sock_ioctl+0x0/0x260
[ 2496.080275]  [<c01b9358>] vfs_ioctl+0x28/0x90
[ 2496.080278]  [<c01b9872>] do_vfs_ioctl+0x72/0x5b0
[ 2496.080280]  [<c01c13f0>] ? alloc_fd+0xe0/0x100
[ 2496.080283]  [<c038d7a8>] ? _spin_lock+0x8/0x10
[ 2496.080286]  [<c01aad27>] ? do_sys_open+0xd7/0x100
[ 2496.080289]  [<c01aad27>] ? do_sys_open+0xd7/0x100
[ 2496.080291]  [<c01adfaf>] ? fput+0x1f/0x30
[ 2496.080294]  [<c01b9e13>] sys_ioctl+0x63/0x70
[ 2496.080297]  [<c010366f>] sysenter_do_call+0x12/0x33
[ 2496.085232] phy3 -> rt73usb_init_registers: Error - TXRX_CSR9  
WRITE: 0x00000000, READ: 0x00000000
[ 2496.223630] phy3 -> rt73usb_config_duration: Error - TXRX_CSR9  
WRITE: 0x00000640, READ: 0x00000640
[ 2496.342899] phy3 -> rt2x00mac_config: Error - <===
[ 2496.400228] phy3 -> rt2x00mac_conf_tx: Info - Configured TX queue 0  
- CWmin: 5, CWmax: 10, Aifs: 2, TXop: 0.
[ 2496.402285] phy3 -> rt2x00mac_conf_tx: Info - Configured TX queue 1  
- CWmin: 5, CWmax: 10, Aifs: 2, TXop: 0.
[ 2496.404285] phy3 -> rt2x00mac_conf_tx: Info - Configured TX queue 2  
- CWmin: 5, CWmax: 10, Aifs: 2, TXop: 0.
[ 2496.406280] phy3 -> rt2x00mac_conf_tx: Info - Configured TX queue 3  
- CWmin: 5, CWmax: 10, Aifs: 2, TXop: 0.
[ 2496.409318] phy3 -> rt2x00mac_config: Error - ===>
[ 2496.466744] Pid: 5066, comm: iwconfig Not tainted 2.6.29-rc8-wl #1
[ 2496.466746] Call Trace:
[ 2496.466755]  [<c038ae85>] ? printk+0x18/0x1b
[ 2496.466765]  [<fa5136a6>] rt2x00mac_config+0x46/0xf0 [rt2x00lib]
[ 2496.466789]  [<f7f76ee2>] ieee80211_hw_config+0xb2/0xc0 [mac80211]
[ 2496.466819]  [<f7f8e874>] ieee80211_set_freq+0x84/0x90 [mac80211]
[ 2496.466829]  [<f7f77c5e>] ieee80211_ioctl_siwfreq+0x8e/0x130  
[mac80211]
[ 2496.466834]  [<c037660b>] ioctl_standard_call+0x5b/0x380
[ 2496.466838]  [<c030f67d>] ? __dev_get_by_name+0x7d/0xa0
[ 2496.466842]  [<c030f67d>] ? __dev_get_by_name+0x7d/0xa0
[ 2496.466844]  [<c037624f>] wext_handle_ioctl+0x14f/0x230
[ 2496.466854]  [<f7f77bd0>] ? ieee80211_ioctl_siwfreq+0x0/0x130  
[mac80211]
[ 2496.466858]  [<c03101eb>] dev_ioctl+0x46b/0x530
[ 2496.466861]  [<c011c29f>] ? do_page_fault+0x2ef/0x800
[ 2496.466864]  [<c023cdfa>] ? smack_sk_alloc_security+0x2a/0x70
[ 2496.466868]  [<c02ffe80>] ? sock_ioctl+0x0/0x260
[ 2496.466871]  [<c02fff6d>] sock_ioctl+0xed/0x260
[ 2496.466874]  [<c038d7a8>] ? _spin_lock+0x8/0x10
[ 2496.466876]  [<c02ffe80>] ? sock_ioctl+0x0/0x260
[ 2496.466881]  [<c01b9358>] vfs_ioctl+0x28/0x90
[ 2496.466884]  [<c01b9872>] do_vfs_ioctl+0x72/0x5b0
[ 2496.466886]  [<c038d7a8>] ? _spin_lock+0x8/0x10
[ 2496.466890]  [<c01aaaa4>] ? fd_install+0x44/0x60
[ 2496.466893]  [<c0300843>] ? sock_map_fd+0x43/0x70
[ 2496.466896]  [<c010ad05>] ? init_fpu+0x165/0x1a0
[ 2496.466899]  [<c01049c0>] ? do_device_not_available+0x0/0x60
[ 2496.466902]  [<c010ad05>] ? init_fpu+0x165/0x1a0
[ 2496.466905]  [<c01b9e13>] sys_ioctl+0x63/0x70
[ 2496.466907]  [<c010366f>] sysenter_do_call+0x12/0x33
[ 2496.477792] phy3 -> rt2x00mac_config: Error - <===

After running 'iwlist mesh scan':

[ 2590.349147] phy3 -> rt2x00mac_config_interface: Error - ===>
[ 2590.416899] Pid: 5069, comm: iwlist Not tainted 2.6.29-rc8-wl #1
[ 2590.416902] Call Trace:
[ 2590.416911]  [<c038ae85>] ? printk+0x18/0x1b
[ 2590.416923]  [<fa513579>] rt2x00mac_config_interface+0x49/0x130  
[rt2x00lib]
[ 2590.416941]  [<fa513530>] ? rt2x00mac_config_interface+0x0/0x130  
[rt2x00lib]
[ 2590.416958]  [<f7f76a39>] ieee80211_if_config+0xd9/0x1f0 [mac80211]
[ 2590.416972]  [<f7f7b484>] ieee80211_start_scan+0x204/0x270 [mac80211]
[ 2590.416982]  [<f7f7b55f>] ieee80211_request_scan+0x6f/0xb0 [mac80211]
[ 2590.416993]  [<f7f84d28>] ieee80211_scan+0x38/0x50 [mac80211]
[ 2590.417004]  [<f7c831bf>] cfg80211_wext_siwscan+0x17f/0x200  
[cfg80211]
[ 2590.417009]  [<c0376749>] ioctl_standard_call+0x199/0x380
[ 2590.417014]  [<c030f67d>] ? __dev_get_by_name+0x7d/0xa0
[ 2590.417017]  [<c030f67d>] ? __dev_get_by_name+0x7d/0xa0
[ 2590.417020]  [<c037624f>] wext_handle_ioctl+0x14f/0x230
[ 2590.417027]  [<f7c83040>] ? cfg80211_wext_siwscan+0x0/0x200  
[cfg80211]
[ 2590.417030]  [<c03101eb>] dev_ioctl+0x46b/0x530
[ 2590.417034]  [<c011c29f>] ? do_page_fault+0x2ef/0x800
[ 2590.417037]  [<c023cdfa>] ? smack_sk_alloc_security+0x2a/0x70
[ 2590.417041]  [<c02ffe80>] ? sock_ioctl+0x0/0x260
[ 2590.417044]  [<c02fff6d>] sock_ioctl+0xed/0x260
[ 2590.417047]  [<c038d7a8>] ? _spin_lock+0x8/0x10
[ 2590.417050]  [<c02ffe80>] ? sock_ioctl+0x0/0x260
[ 2590.417054]  [<c01b9358>] vfs_ioctl+0x28/0x90
[ 2590.417057]  [<c01b9872>] do_vfs_ioctl+0x72/0x5b0
[ 2590.417059]  [<c038d7a8>] ? _spin_lock+0x8/0x10
[ 2590.417063]  [<c01aaaa4>] ? fd_install+0x44/0x60
[ 2590.417066]  [<c0300843>] ? sock_map_fd+0x43/0x70
[ 2590.417069]  [<c0301084>] ? sys_socket+0x54/0x70
[ 2590.417072]  [<c0302135>] ? sys_socketcall+0x265/0x270
[ 2590.417075]  [<c01b9e13>] sys_ioctl+0x63/0x70
[ 2590.417078]  [<c010366f>] sysenter_do_call+0x12/0x33
[ 2590.419861] phy3 -> rt73usb_config_intf: Error - TXRX_CSR9 WRITE:  
0x000d0640, READ: 0x000d0640
[ 2590.523014] phy3 -> rt2x00mac_config_interface: Error - <===
[ 2590.590777] Pid: 5069, comm: iwlist Not tainted 2.6.29-rc8-wl #1
[ 2590.590779] Call Trace:
[ 2590.590782]  [<c038ae85>] ? printk+0x18/0x1b
[ 2590.590789]  [<fa51362d>] rt2x00mac_config_interface+0xfd/0x130  
[rt2x00lib]
[ 2590.590803]  [<fa513530>] ? rt2x00mac_config_interface+0x0/0x130  
[rt2x00lib]
[ 2590.590814]  [<f7f76a39>] ieee80211_if_config+0xd9/0x1f0 [mac80211]
[ 2590.590826]  [<f7f7b484>] ieee80211_start_scan+0x204/0x270 [mac80211]
[ 2590.590837]  [<f7f7b55f>] ieee80211_request_scan+0x6f/0xb0 [mac80211]
[ 2590.590848]  [<f7f84d28>] ieee80211_scan+0x38/0x50 [mac80211]
[ 2590.590857]  [<f7c831bf>] cfg80211_wext_siwscan+0x17f/0x200  
[cfg80211]
[ 2590.590860]  [<c0376749>] ioctl_standard_call+0x199/0x380
[ 2590.590864]  [<c030f67d>] ? __dev_get_by_name+0x7d/0xa0
[ 2590.590867]  [<c030f67d>] ? __dev_get_by_name+0x7d/0xa0
[ 2590.590870]  [<c037624f>] wext_handle_ioctl+0x14f/0x230
[ 2590.590876]  [<f7c83040>] ? cfg80211_wext_siwscan+0x0/0x200  
[cfg80211]
[ 2590.590880]  [<c03101eb>] dev_ioctl+0x46b/0x530
[ 2590.590883]  [<c011c29f>] ? do_page_fault+0x2ef/0x800
[ 2590.590886]  [<c023cdfa>] ? smack_sk_alloc_security+0x2a/0x70
[ 2590.590889]  [<c02ffe80>] ? sock_ioctl+0x0/0x260
[ 2590.590891]  [<c02fff6d>] sock_ioctl+0xed/0x260
[ 2590.590894]  [<c038d7a8>] ? _spin_lock+0x8/0x10
[ 2590.590897]  [<c02ffe80>] ? sock_ioctl+0x0/0x260
[ 2590.590900]  [<c01b9358>] vfs_ioctl+0x28/0x90
[ 2590.590903]  [<c01b9872>] do_vfs_ioctl+0x72/0x5b0
[ 2590.590905]  [<c038d7a8>] ? _spin_lock+0x8/0x10
[ 2590.590908]  [<c01aaaa4>] ? fd_install+0x44/0x60
[ 2590.590911]  [<c0300843>] ? sock_map_fd+0x43/0x70
[ 2590.590914]  [<c0301084>] ? sys_socket+0x54/0x70
[ 2590.590917]  [<c0302135>] ? sys_socketcall+0x265/0x270
[ 2590.590920]  [<c01b9e13>] sys_ioctl+0x63/0x70
[ 2590.590922]  [<c010366f>] sysenter_do_call+0x12/0x33
[ 2590.616015] phy3 -> rt2x00mac_config: Error - ===>
[ 2590.673353] Pid: 5028, comm: phy3 Not tainted 2.6.29-rc8-wl #1
[ 2590.673354] Call Trace:
[ 2590.673358]  [<c038ae85>] ? printk+0x18/0x1b
[ 2590.673364]  [<fa5136a6>] rt2x00mac_config+0x46/0xf0 [rt2x00lib]
[ 2590.673383]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2590.673392]  [<f7f76ee2>] ieee80211_hw_config+0xb2/0xc0 [mac80211]
[ 2590.673403]  [<f7f7ba19>] ieee80211_scan_work+0x79/0x190 [mac80211]
[ 2590.673413]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2590.673417]  [<c014458d>] run_workqueue+0x8d/0x150
[ 2590.673421]  [<c014855a>] ? prepare_to_wait+0x3a/0x70
[ 2590.673423]  [<c01446d8>] worker_thread+0x88/0xf0
[ 2590.673426]  [<c0148300>] ? autoremove_wake_function+0x0/0x50
[ 2590.673429]  [<c0144650>] ? worker_thread+0x0/0xf0
[ 2590.673432]  [<c0147f7c>] kthread+0x3c/0x70
[ 2590.673435]  [<c0147f40>] ? kthread+0x0/0x70
[ 2590.673438]  [<c0103f27>] kernel_thread_helper+0x7/0x10
[ 2590.683658] phy3 -> rt2x00mac_config: Error - <===
[ 2590.796012] phy3 -> rt2x00mac_config: Error - ===>
[ 2590.853381] Pid: 5028, comm: phy3 Not tainted 2.6.29-rc8-wl #1
[ 2590.853382] Call Trace:
[ 2590.853386]  [<c038ae85>] ? printk+0x18/0x1b
[ 2590.853392]  [<fa5136a6>] rt2x00mac_config+0x46/0xf0 [rt2x00lib]
[ 2590.853411]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2590.853421]  [<f7f76ee2>] ieee80211_hw_config+0xb2/0xc0 [mac80211]
[ 2590.853431]  [<f7f7ba19>] ieee80211_scan_work+0x79/0x190 [mac80211]
[ 2590.853441]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2590.853444]  [<c014458d>] run_workqueue+0x8d/0x150
[ 2590.853448]  [<c014855a>] ? prepare_to_wait+0x3a/0x70
[ 2590.853450]  [<c01446d8>] worker_thread+0x88/0xf0
[ 2590.853453]  [<c0148300>] ? autoremove_wake_function+0x0/0x50
[ 2590.853456]  [<c0144650>] ? worker_thread+0x0/0xf0
[ 2590.853459]  [<c0147f7c>] kthread+0x3c/0x70
[ 2590.853461]  [<c0147f40>] ? kthread+0x0/0x70
[ 2590.853464]  [<c0103f27>] kernel_thread_helper+0x7/0x10
[ 2590.863813] phy3 -> rt2x00mac_config: Error - <===
[ 2590.976011] phy3 -> rt2x00mac_config: Error - ===>
[ 2591.033409] Pid: 5028, comm: phy3 Not tainted 2.6.29-rc8-wl #1
[ 2591.033411] Call Trace:
[ 2591.033415]  [<c038ae85>] ? printk+0x18/0x1b
[ 2591.033421]  [<fa5136a6>] rt2x00mac_config+0x46/0xf0 [rt2x00lib]
[ 2591.033448]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2591.033458]  [<f7f76ee2>] ieee80211_hw_config+0xb2/0xc0 [mac80211]
[ 2591.033468]  [<f7f7ba19>] ieee80211_scan_work+0x79/0x190 [mac80211]
[ 2591.033479]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2591.033482]  [<c014458d>] run_workqueue+0x8d/0x150
[ 2591.033486]  [<c014855a>] ? prepare_to_wait+0x3a/0x70
[ 2591.033488]  [<c01446d8>] worker_thread+0x88/0xf0
[ 2591.033491]  [<c0148300>] ? autoremove_wake_function+0x0/0x50
[ 2591.033494]  [<c0144650>] ? worker_thread+0x0/0xf0
[ 2591.033497]  [<c0147f7c>] kthread+0x3c/0x70
[ 2591.033500]  [<c0147f40>] ? kthread+0x0/0x70
[ 2591.033503]  [<c0103f27>] kernel_thread_helper+0x7/0x10
[ 2591.043842] phy3 -> rt2x00mac_config: Error - <===
[ 2591.156012] phy3 -> rt2x00mac_config: Error - ===>
[ 2591.213336] Pid: 5028, comm: phy3 Not tainted 2.6.29-rc8-wl #1
[ 2591.213338] Call Trace:
[ 2591.213341]  [<c038ae85>] ? printk+0x18/0x1b
[ 2591.213347]  [<fa5136a6>] rt2x00mac_config+0x46/0xf0 [rt2x00lib]
[ 2591.213366]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2591.213376]  [<f7f76ee2>] ieee80211_hw_config+0xb2/0xc0 [mac80211]
[ 2591.213386]  [<f7f7ba19>] ieee80211_scan_work+0x79/0x190 [mac80211]
[ 2591.213397]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2591.213400]  [<c014458d>] run_workqueue+0x8d/0x150
[ 2591.213403]  [<c014855a>] ? prepare_to_wait+0x3a/0x70
[ 2591.213406]  [<c01446d8>] worker_thread+0x88/0xf0
[ 2591.213409]  [<c0148300>] ? autoremove_wake_function+0x0/0x50
[ 2591.213412]  [<c0144650>] ? worker_thread+0x0/0xf0
[ 2591.213415]  [<c0147f7c>] kthread+0x3c/0x70
[ 2591.213417]  [<c0147f40>] ? kthread+0x0/0x70
[ 2591.213420]  [<c0103f27>] kernel_thread_helper+0x7/0x10
[ 2591.223748] phy3 -> rt2x00mac_config: Error - <===
[ 2591.336011] phy3 -> rt2x00mac_config: Error - ===>
[ 2591.393365] Pid: 5028, comm: phy3 Not tainted 2.6.29-rc8-wl #1
[ 2591.393366] Call Trace:
[ 2591.393369]  [<c038ae85>] ? printk+0x18/0x1b
[ 2591.393376]  [<fa5136a6>] rt2x00mac_config+0x46/0xf0 [rt2x00lib]
[ 2591.393394]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2591.393403]  [<f7f76ee2>] ieee80211_hw_config+0xb2/0xc0 [mac80211]
[ 2591.393414]  [<f7f7ba19>] ieee80211_scan_work+0x79/0x190 [mac80211]
[ 2591.393424]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2591.393427]  [<c014458d>] run_workqueue+0x8d/0x150
[ 2591.393430]  [<c014855a>] ? prepare_to_wait+0x3a/0x70
[ 2591.393433]  [<c01446d8>] worker_thread+0x88/0xf0
[ 2591.393436]  [<c0148300>] ? autoremove_wake_function+0x0/0x50
[ 2591.393439]  [<c0144650>] ? worker_thread+0x0/0xf0
[ 2591.393442]  [<c0147f7c>] kthread+0x3c/0x70
[ 2591.393444]  [<c0147f40>] ? kthread+0x0/0x70
[ 2591.393447]  [<c0103f27>] kernel_thread_helper+0x7/0x10
[ 2591.403653] phy3 -> rt2x00mac_config: Error - <===
[ 2591.516012] phy3 -> rt2x00mac_config: Error - ===>
[ 2591.573395] Pid: 5028, comm: phy3 Not tainted 2.6.29-rc8-wl #1
[ 2591.573397] Call Trace:
[ 2591.573400]  [<c038ae85>] ? printk+0x18/0x1b
[ 2591.573406]  [<fa5136a6>] rt2x00mac_config+0x46/0xf0 [rt2x00lib]
[ 2591.573424]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2591.573434]  [<f7f76ee2>] ieee80211_hw_config+0xb2/0xc0 [mac80211]
[ 2591.573445]  [<f7f7ba19>] ieee80211_scan_work+0x79/0x190 [mac80211]
[ 2591.573455]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2591.573458]  [<c014458d>] run_workqueue+0x8d/0x150
[ 2591.573462]  [<c014855a>] ? prepare_to_wait+0x3a/0x70
[ 2591.573464]  [<c01446d8>] worker_thread+0x88/0xf0
[ 2591.573468]  [<c0148300>] ? autoremove_wake_function+0x0/0x50
[ 2591.573470]  [<c0144650>] ? worker_thread+0x0/0xf0
[ 2591.573473]  [<c0147f7c>] kthread+0x3c/0x70
[ 2591.573476]  [<c0147f40>] ? kthread+0x0/0x70
[ 2591.573479]  [<c0103f27>] kernel_thread_helper+0x7/0x10
[ 2591.583808] phy3 -> rt2x00mac_config: Error - <===
[ 2591.696012] phy3 -> rt2x00mac_config: Error - ===>
[ 2591.753322] Pid: 5028, comm: phy3 Not tainted 2.6.29-rc8-wl #1
[ 2591.753324] Call Trace:
[ 2591.753327]  [<c038ae85>] ? printk+0x18/0x1b
[ 2591.753333]  [<fa5136a6>] rt2x00mac_config+0x46/0xf0 [rt2x00lib]
[ 2591.753351]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2591.753361]  [<f7f76ee2>] ieee80211_hw_config+0xb2/0xc0 [mac80211]
[ 2591.753371]  [<f7f7ba19>] ieee80211_scan_work+0x79/0x190 [mac80211]
[ 2591.753381]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2591.753384]  [<c014458d>] run_workqueue+0x8d/0x150
[ 2591.753388]  [<c014855a>] ? prepare_to_wait+0x3a/0x70
[ 2591.753390]  [<c01446d8>] worker_thread+0x88/0xf0
[ 2591.753393]  [<c0148300>] ? autoremove_wake_function+0x0/0x50
[ 2591.753396]  [<c0144650>] ? worker_thread+0x0/0xf0
[ 2591.753398]  [<c0147f7c>] kthread+0x3c/0x70
[ 2591.753401]  [<c0147f40>] ? kthread+0x0/0x70
[ 2591.753404]  [<c0103f27>] kernel_thread_helper+0x7/0x10
[ 2591.763711] phy3 -> rt2x00mac_config: Error - <===
[ 2591.876011] phy3 -> rt2x00mac_config: Error - ===>
[ 2591.933351] Pid: 5028, comm: phy3 Not tainted 2.6.29-rc8-wl #1
[ 2591.933353] Call Trace:
[ 2591.933356]  [<c038ae85>] ? printk+0x18/0x1b
[ 2591.933362]  [<fa5136a6>] rt2x00mac_config+0x46/0xf0 [rt2x00lib]
[ 2591.933380]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2591.933390]  [<f7f76ee2>] ieee80211_hw_config+0xb2/0xc0 [mac80211]
[ 2591.933401]  [<f7f7ba19>] ieee80211_scan_work+0x79/0x190 [mac80211]
[ 2591.933411]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2591.933414]  [<c014458d>] run_workqueue+0x8d/0x150
[ 2591.933417]  [<c014855a>] ? prepare_to_wait+0x3a/0x70
[ 2591.933420]  [<c01446d8>] worker_thread+0x88/0xf0
[ 2591.933423]  [<c0148300>] ? autoremove_wake_function+0x0/0x50
[ 2591.933426]  [<c0144650>] ? worker_thread+0x0/0xf0
[ 2591.933429]  [<c0147f7c>] kthread+0x3c/0x70
[ 2591.933432]  [<c0147f40>] ? kthread+0x0/0x70
[ 2591.933434]  [<c0103f27>] kernel_thread_helper+0x7/0x10
[ 2591.943741] phy3 -> rt2x00mac_config: Error - <===
[ 2592.056011] phy3 -> rt2x00mac_config: Error - ===>
[ 2592.113388] Pid: 5028, comm: phy3 Not tainted 2.6.29-rc8-wl #1
[ 2592.113389] Call Trace:
[ 2592.113392]  [<c038ae85>] ? printk+0x18/0x1b
[ 2592.113399]  [<fa5136a6>] rt2x00mac_config+0x46/0xf0 [rt2x00lib]
[ 2592.113417]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2592.113427]  [<f7f76ee2>] ieee80211_hw_config+0xb2/0xc0 [mac80211]
[ 2592.113437]  [<f7f7ba19>] ieee80211_scan_work+0x79/0x190 [mac80211]
[ 2592.113447]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2592.113450]  [<c014458d>] run_workqueue+0x8d/0x150
[ 2592.113454]  [<c014855a>] ? prepare_to_wait+0x3a/0x70
[ 2592.113456]  [<c01446d8>] worker_thread+0x88/0xf0
[ 2592.113460]  [<c0148300>] ? autoremove_wake_function+0x0/0x50
[ 2592.113462]  [<c0144650>] ? worker_thread+0x0/0xf0
[ 2592.113465]  [<c0147f7c>] kthread+0x3c/0x70
[ 2592.113468]  [<c0147f40>] ? kthread+0x0/0x70
[ 2592.113471]  [<c0103f27>] kernel_thread_helper+0x7/0x10
[ 2592.123771] phy3 -> rt2x00mac_config: Error - <===
[ 2592.236011] phy3 -> rt2x00mac_config: Error - ===>
[ 2592.293307] Pid: 5028, comm: phy3 Not tainted 2.6.29-rc8-wl #1
[ 2592.293308] Call Trace:
[ 2592.293312]  [<c038ae85>] ? printk+0x18/0x1b
[ 2592.293318]  [<fa5136a6>] rt2x00mac_config+0x46/0xf0 [rt2x00lib]
[ 2592.293336]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2592.293346]  [<f7f76ee2>] ieee80211_hw_config+0xb2/0xc0 [mac80211]
[ 2592.293356]  [<f7f7ba19>] ieee80211_scan_work+0x79/0x190 [mac80211]
[ 2592.293367]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2592.293370]  [<c014458d>] run_workqueue+0x8d/0x150
[ 2592.293373]  [<c014855a>] ? prepare_to_wait+0x3a/0x70
[ 2592.293376]  [<c01446d8>] worker_thread+0x88/0xf0
[ 2592.293379]  [<c0148300>] ? autoremove_wake_function+0x0/0x50
[ 2592.293382]  [<c0144650>] ? worker_thread+0x0/0xf0
[ 2592.293385]  [<c0147f7c>] kthread+0x3c/0x70
[ 2592.293387]  [<c0147f40>] ? kthread+0x0/0x70
[ 2592.293390]  [<c0103f27>] kernel_thread_helper+0x7/0x10
[ 2592.303677] phy3 -> rt2x00mac_config: Error - <===
[ 2592.416011] phy3 -> rt2x00mac_config: Error - ===>
[ 2592.473336] Pid: 5028, comm: phy3 Not tainted 2.6.29-rc8-wl #1
[ 2592.473337] Call Trace:
[ 2592.473341]  [<c038ae85>] ? printk+0x18/0x1b
[ 2592.473347]  [<fa5136a6>] rt2x00mac_config+0x46/0xf0 [rt2x00lib]
[ 2592.473365]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2592.473374]  [<f7f76ee2>] ieee80211_hw_config+0xb2/0xc0 [mac80211]
[ 2592.473385]  [<f7f7ba19>] ieee80211_scan_work+0x79/0x190 [mac80211]
[ 2592.473395]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2592.473398]  [<c014458d>] run_workqueue+0x8d/0x150
[ 2592.473402]  [<c014855a>] ? prepare_to_wait+0x3a/0x70
[ 2592.473404]  [<c01446d8>] worker_thread+0x88/0xf0
[ 2592.473408]  [<c0148300>] ? autoremove_wake_function+0x0/0x50
[ 2592.473410]  [<c0144650>] ? worker_thread+0x0/0xf0
[ 2592.473413]  [<c0147f7c>] kthread+0x3c/0x70
[ 2592.473416]  [<c0147f40>] ? kthread+0x0/0x70
[ 2592.473419]  [<c0103f27>] kernel_thread_helper+0x7/0x10
[ 2592.483707] phy3 -> rt2x00mac_config: Error - <===
[ 2592.596011] phy3 -> rt2x00mac_config: Error - ===>
[ 2592.653367] Pid: 5028, comm: phy3 Not tainted 2.6.29-rc8-wl #1
[ 2592.653369] Call Trace:
[ 2592.653372]  [<c038ae85>] ? printk+0x18/0x1b
[ 2592.653378]  [<fa5136a6>] rt2x00mac_config+0x46/0xf0 [rt2x00lib]
[ 2592.653397]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2592.653406]  [<f7f76ee2>] ieee80211_hw_config+0xb2/0xc0 [mac80211]
[ 2592.653417]  [<f7f7ba19>] ieee80211_scan_work+0x79/0x190 [mac80211]
[ 2592.653427]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2592.653430]  [<c014458d>] run_workqueue+0x8d/0x150
[ 2592.653433]  [<c014855a>] ? prepare_to_wait+0x3a/0x70
[ 2592.653436]  [<c01446d8>] worker_thread+0x88/0xf0
[ 2592.653439]  [<c0148300>] ? autoremove_wake_function+0x0/0x50
[ 2592.653442]  [<c0144650>] ? worker_thread+0x0/0xf0
[ 2592.653445]  [<c0147f7c>] kthread+0x3c/0x70
[ 2592.653448]  [<c0147f40>] ? kthread+0x0/0x70
[ 2592.653450]  [<c0103f27>] kernel_thread_helper+0x7/0x10
[ 2592.663736] phy3 -> rt2x00mac_config: Error - <===
[ 2592.948010] phy3 -> rt2x00mac_config: Error - ===>
[ 2593.005414] Pid: 5028, comm: phy3 Not tainted 2.6.29-rc8-wl #1
[ 2593.005416] Call Trace:
[ 2593.005419]  [<c038ae85>] ? printk+0x18/0x1b
[ 2593.005425]  [<fa5136a6>] rt2x00mac_config+0x46/0xf0 [rt2x00lib]
[ 2593.005448]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2593.005458]  [<f7f76ee2>] ieee80211_hw_config+0xb2/0xc0 [mac80211]
[ 2593.005468]  [<f7f7ba19>] ieee80211_scan_work+0x79/0x190 [mac80211]
[ 2593.005478]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2593.005481]  [<c014458d>] run_workqueue+0x8d/0x150
[ 2593.005484]  [<c014855a>] ? prepare_to_wait+0x3a/0x70
[ 2593.005487]  [<c01446d8>] worker_thread+0x88/0xf0
[ 2593.005490]  [<c0148300>] ? autoremove_wake_function+0x0/0x50
[ 2593.005493]  [<c0144650>] ? worker_thread+0x0/0xf0
[ 2593.005496]  [<c0147f7c>] kthread+0x3c/0x70
[ 2593.005498]  [<c0147f40>] ? kthread+0x0/0x70
[ 2593.005501]  [<c0103f27>] kernel_thread_helper+0x7/0x10
[ 2593.015795] phy3 -> rt2x00mac_config: Error - <===
[ 2593.128011] phy3 -> rt2x00mac_config: Error - ===>
[ 2593.185344] Pid: 5028, comm: phy3 Not tainted 2.6.29-rc8-wl #1
[ 2593.185346] Call Trace:
[ 2593.185349]  [<c038ae85>] ? printk+0x18/0x1b
[ 2593.185355]  [<fa5136a6>] rt2x00mac_config+0x46/0xf0 [rt2x00lib]
[ 2593.185374]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2593.185383]  [<f7f76ee2>] ieee80211_hw_config+0xb2/0xc0 [mac80211]
[ 2593.185393]  [<f7f7ba19>] ieee80211_scan_work+0x79/0x190 [mac80211]
[ 2593.185404]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2593.185407]  [<c014458d>] run_workqueue+0x8d/0x150
[ 2593.185410]  [<c014855a>] ? prepare_to_wait+0x3a/0x70
[ 2593.185413]  [<c01446d8>] worker_thread+0x88/0xf0
[ 2593.185416]  [<c0148300>] ? autoremove_wake_function+0x0/0x50
[ 2593.185419]  [<c0144650>] ? worker_thread+0x0/0xf0
[ 2593.185421]  [<c0147f7c>] kthread+0x3c/0x70
[ 2593.185424]  [<c0147f40>] ? kthread+0x0/0x70
[ 2593.185427]  [<c0103f27>] kernel_thread_helper+0x7/0x10
[ 2593.195699] phy3 -> rt2x00mac_config: Error - <===
[ 2593.480022] phy3 -> rt2x00mac_config: Error - ===>
[ 2593.537396] Pid: 5028, comm: phy3 Not tainted 2.6.29-rc8-wl #1
[ 2593.537397] Call Trace:
[ 2593.537402]  [<c038ae85>] ? printk+0x18/0x1b
[ 2593.537408]  [<fa5136a6>] rt2x00mac_config+0x46/0xf0 [rt2x00lib]
[ 2593.537428]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2593.537438]  [<f7f76ee2>] ieee80211_hw_config+0xb2/0xc0 [mac80211]
[ 2593.537449]  [<f7f7b6b7>] ieee80211_scan_completed+0xb7/0x3a0  
[mac80211]
[ 2593.537452]  [<c038b3ce>] ? schedule+0x3de/0xa20
[ 2593.537462]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2593.537473]  [<f7f7baf9>] ieee80211_scan_work+0x159/0x190 [mac80211]
[ 2593.537483]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2593.537486]  [<c014458d>] run_workqueue+0x8d/0x150
[ 2593.537490]  [<c014855a>] ? prepare_to_wait+0x3a/0x70
[ 2593.537492]  [<c01446d8>] worker_thread+0x88/0xf0
[ 2593.537495]  [<c0148300>] ? autoremove_wake_function+0x0/0x50
[ 2593.537498]  [<c0144650>] ? worker_thread+0x0/0xf0
[ 2593.537501]  [<c0147f7c>] kthread+0x3c/0x70
[ 2593.537504]  [<c0147f40>] ? kthread+0x0/0x70
[ 2593.537506]  [<c0103f27>] kernel_thread_helper+0x7/0x10
[ 2593.547882] phy3 -> rt2x00mac_config: Error - <===
[ 2593.606302] phy3 -> rt2x00mac_config_interface: Error - ===>
[ 2593.674076] Pid: 5028, comm: phy3 Not tainted 2.6.29-rc8-wl #1
[ 2593.674078] Call Trace:
[ 2593.674085]  [<c038ae85>] ? printk+0x18/0x1b
[ 2593.674094]  [<fa513579>] rt2x00mac_config_interface+0x49/0x130  
[rt2x00lib]
[ 2593.674111]  [<fa513530>] ? rt2x00mac_config_interface+0x0/0x130  
[rt2x00lib]
[ 2593.674126]  [<f7f76a39>] ieee80211_if_config+0xd9/0x1f0 [mac80211]
[ 2593.674139]  [<f7f7b90c>] ieee80211_scan_completed+0x30c/0x3a0  
[mac80211]
[ 2593.674150]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2593.674160]  [<f7f7baf9>] ieee80211_scan_work+0x159/0x190 [mac80211]
[ 2593.674171]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2593.674175]  [<c014458d>] run_workqueue+0x8d/0x150
[ 2593.674179]  [<c014855a>] ? prepare_to_wait+0x3a/0x70
[ 2593.674182]  [<c01446d8>] worker_thread+0x88/0xf0
[ 2593.674185]  [<c0148300>] ? autoremove_wake_function+0x0/0x50
[ 2593.674188]  [<c0144650>] ? worker_thread+0x0/0xf0
[ 2593.674190]  [<c0147f7c>] kthread+0x3c/0x70
[ 2593.674193]  [<c0147f40>] ? kthread+0x0/0x70
[ 2593.674196]  [<c0103f27>] kernel_thread_helper+0x7/0x10
[ 2593.675901] phy3 -> rt73usb_config_intf: Error - TXRX_CSR9 WRITE:  
0x000d0640, READ: 0x000d0640
[ 2593.779792] phy3 -> rt73usb_write_beacon: Error - TXRX_CSR9 WRITE:  
0x00040640, READ: 0x00040640
[ 2593.886185] phy3 -> rt73usb_kick_tx_queue: Error - TXRX_CSR9 WRITE:  
0x001d0640, READ: 0x001d0640
[ 2593.991374] phy3 -> rt2x00mac_config_interface: Error - <===
[ 2594.059083] Pid: 5028, comm: phy3 Not tainted 2.6.29-rc8-wl #1
[ 2594.059085] Call Trace:
[ 2594.059088]  [<c038ae85>] ? printk+0x18/0x1b
[ 2594.059094]  [<fa51362d>] rt2x00mac_config_interface+0xfd/0x130  
[rt2x00lib]
[ 2594.059107]  [<fa513530>] ? rt2x00mac_config_interface+0x0/0x130  
[rt2x00lib]
[ 2594.059118]  [<f7f76a39>] ieee80211_if_config+0xd9/0x1f0 [mac80211]
[ 2594.059131]  [<f7f7b90c>] ieee80211_scan_completed+0x30c/0x3a0  
[mac80211]
[ 2594.059141]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2594.059152]  [<f7f7baf9>] ieee80211_scan_work+0x159/0x190 [mac80211]
[ 2594.059162]  [<f7f7b9a0>] ? ieee80211_scan_work+0x0/0x190 [mac80211]
[ 2594.059165]  [<c014458d>] run_workqueue+0x8d/0x150
[ 2594.059169]  [<c014855a>] ? prepare_to_wait+0x3a/0x70
[ 2594.059171]  [<c01446d8>] worker_thread+0x88/0xf0
[ 2594.059174]  [<c0148300>] ? autoremove_wake_function+0x0/0x50
[ 2594.059177]  [<c0144650>] ? worker_thread+0x0/0xf0
[ 2594.059180]  [<c0147f7c>] kthread+0x3c/0x70
[ 2594.059182]  [<c0147f40>] ? kthread+0x0/0x70
[ 2594.059185]  [<c0103f27>] kernel_thread_helper+0x7/0x10

