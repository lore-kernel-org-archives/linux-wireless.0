Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62631 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbaJBDpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 23:45:19 -0400
Received: by mail-wi0-f176.google.com with SMTP id hi2so2602090wib.9
        for <linux-wireless@vger.kernel.org>; Wed, 01 Oct 2014 20:45:18 -0700 (PDT)
Message-ID: <542CCA4B.7030201@gmail.com> (sfid-20141002_054523_238519_78CA2AE4)
Date: Thu, 02 Oct 2014 05:45:15 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>,
	Joshua Roys <Joshua.Roys@gtri.gatech.edu>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Realtek WlanFAE <wlanfae@realtek.com>,
	lizhaoming <chaoming_li@realsil.com.cn>,
	Network Manager <networkmanager-list@gnome.org>
Subject: Re: RTL8188SU(rtl8192su) - unavailable
References: <54292675.4090607@gmail.com> <1412019981.5379.2.camel@dcbw.local>
In-Reply-To: <1412019981.5379.2.camel@dcbw.local>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29.09.2014 21:46, Dan Williams wrote:
> On Mon, 2014-09-29 at 11:29 +0200, poma wrote:
>> [platform/nm-platform.c:806] nm_platform_link_set_up(): link: setting up 'wlp0s4f1u1' (4)
>> [platform/nm-linux-platform.c:2356] link_change_flags(): link: change 4: flags set 'up' (1)
>> [platform/nm-linux-platform.c:2250] link_change(): Netlink error changing link 4:  <UP> mtu 0 (1) driver 'rtl8192su' udi '/sys/devices/pci0000:00/0000:00:04.1/usb2/2-1/2-1:1.0/net/wlp0s4f1u1': No such device
>> (wlp0s4f1u1): preparing device
> 
> This is likely the core problem, and it's also probably the cause of the
> wpa_supplicant failures too.  You can test this out without NM running
> by simply doing:
> 
> ifconfig wlp0s4f1u1 up
> 
> and see if it returns an error or not.  Does it?  Does anything show up
> in 'dmesg'?  If we can't get 'ifconfig up' working for the device,
> clearly NM won't work either...
> 
> Dan
> 

It's OK Dan, NM ain't problem.

WIP encore party

------------[ cut here ]------------
WARNING: CPU: 1 PID: 867 at /rtl8192su/rtlwifi/rtl8192s/phy_common.c:1313 rtl92s_phy_chk_fwcmd_iodone+0x61/0x70 [rtl8192s_common]()
Modules linked in: ... rtl8192su(OE) rtl8192s_common(OE) rtl_usb(OE) rtlwifi(OE) mac80211 cfg80211 ...
CPU: 1 PID: 867 Comm: wpa_supplicant Tainted: G           OE  3.17.0-0.rc7.git0.2.fc21.x86_64 #1
Call Trace:
 [<ffffffff8173c1f1>] dump_stack+0x45/0x56
 [<ffffffff81096e9d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff81096fca>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa05b3b71>] rtl92s_phy_chk_fwcmd_iodone+0x61/0x70 [rtl8192s_common]
 [<ffffffffa05b5871>] rtl92s_phy_set_fw_cmd+0x131/0x780 [rtl8192s_common]
 [<ffffffffa05b5efa>] rtl92s_phy_scan_operation_backup+0x3a/0x40 [rtl8192s_common]
 [<ffffffffa043054c>] rtl_op_sw_scan_start+0x8c/0xe0 [rtlwifi]
 [<ffffffffa051b63f>] __ieee80211_start_scan+0x34f/0x5d0 [mac80211]
 [<ffffffffa051c4a0>] ieee80211_request_scan+0x30/0x50 [mac80211]
 [<ffffffffa052b838>] ieee80211_scan+0x68/0xc0 [mac80211]
 [<ffffffffa04b7dab>] nl80211_trigger_scan+0x5bb/0x640 [cfg80211]
 [<ffffffff816604ac>] genl_family_rcv_msg+0x1bc/0x3e0
 [<ffffffff8161cc7b>] ? __alloc_skb+0x5b/0x200
 [<ffffffff816606d0>] ? genl_family_rcv_msg+0x3e0/0x3e0
 [<ffffffff81660749>] genl_rcv_msg+0x79/0xc0
 [<ffffffff8165fd59>] netlink_rcv_skb+0xa9/0xd0
 [<ffffffff816602d8>] genl_rcv+0x28/0x40
 [<ffffffff8165f37a>] netlink_unicast+0x12a/0x1a0
 [<ffffffff8165f741>] netlink_sendmsg+0x351/0x7b0
 [<ffffffff8130f9f2>] ? sock_has_perm+0x72/0x90
 [<ffffffff816132fe>] sock_sendmsg+0x9e/0xe0
 [<ffffffff81612fce>] ? move_addr_to_kernel.part.20+0x1e/0x70
 [<ffffffff81613ed1>] ? move_addr_to_kernel+0x21/0x30
 [<ffffffff81613768>] ___sys_sendmsg+0x3c8/0x3e0
 [<ffffffff810a5e86>] ? __set_current_blocked+0x36/0x60
 [<ffffffff8101f67e>] ? fpu_finit+0x1e/0x30
 [<ffffffff8101f8e1>] ? init_fpu+0x51/0xb0
 [<ffffffff81020b58>] ? __restore_xstate_sig+0x268/0x660
 [<ffffffff81013745>] ? do_signal+0x1a5/0x6f0
 [<ffffffff81614681>] __sys_sendmsg+0x51/0x90
 [<ffffffff816146d2>] SyS_sendmsg+0x12/0x20
 [<ffffffff81743369>] system_call_fastpath+0x16/0x1b
---[ end trace 561080c39bcc6e50 ]---
------------[ cut here ]------------
WARNING: CPU: 2 PID: 81 at /rtl8192su/rtlwifi/rtl8192s/phy_common.c:1313 rtl92s_phy_chk_fwcmd_iodone+0x61/0x70 [rtl8192s_common]()
CPU: 2 PID: 81 Comm: kworker/u8:6 Tainted: G        W  OE  3.17.0-0.rc7.git0.2.fc21.x86_64 #1
Workqueue: phy0 ieee80211_scan_work [mac80211]
Call Trace:
 [<ffffffff8173c1f1>] dump_stack+0x45/0x56
 [<ffffffff81096e9d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff81096fca>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa05b3b71>] rtl92s_phy_chk_fwcmd_iodone+0x61/0x70 [rtl8192s_common]
 [<ffffffffa05b5871>] rtl92s_phy_set_fw_cmd+0x131/0x780 [rtl8192s_common]
 [<ffffffffa05b5eeb>] rtl92s_phy_scan_operation_backup+0x2b/0x40 [rtl8192s_common]
 [<ffffffffa042fd9b>] rtl_op_sw_scan_complete+0x6b/0xa0 [rtlwifi]
 [<ffffffffa051b1ba>] __ieee80211_scan_completed+0x1ea/0x320 [mac80211]
 [<ffffffff81012691>] ? __switch_to+0x191/0x5f0
 [<ffffffffa051c06d>] ieee80211_scan_work+0xdd/0x4e0 [mac80211]
 [<ffffffff810af67d>] process_one_work+0x14d/0x400
 [<ffffffff810b000b>] worker_thread+0x6b/0x4a0
 [<ffffffff810affa0>] ? rescuer_thread+0x2a0/0x2a0
 [<ffffffff810b50ea>] kthread+0xea/0x100
 [<ffffffff810b5000>] ? kthread_create_on_node+0x1a0/0x1a0
 [<ffffffff817432bc>] ret_from_fork+0x7c/0xb0
 [<ffffffff810b5000>] ? kthread_create_on_node+0x1a0/0x1a0
---[ end trace 561080c39bcc6e51 ]---
------------[ cut here ]------------
WARNING: CPU: 2 PID: 867 at /rtl8192su/rtlwifi/rtl8192s/phy_common.c:1313 rtl92s_phy_chk_fwcmd_iodone+0x61/0x70 [rtl8192s_common]()
CPU: 2 PID: 867 Comm: wpa_supplicant Tainted: G        W  OE  3.17.0-0.rc7.git0.2.fc21.x86_64 #1
Call Trace:
 [<ffffffff8173c1f1>] dump_stack+0x45/0x56
 [<ffffffff81096e9d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff81096fca>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa05b3b71>] rtl92s_phy_chk_fwcmd_iodone+0x61/0x70 [rtl8192s_common]
 [<ffffffffa05b5871>] rtl92s_phy_set_fw_cmd+0x131/0x780 [rtl8192s_common]
 [<ffffffffa05b5efa>] rtl92s_phy_scan_operation_backup+0x3a/0x40 [rtl8192s_common]
 [<ffffffffa043054c>] rtl_op_sw_scan_start+0x8c/0xe0 [rtlwifi]
 [<ffffffffa051b63f>] __ieee80211_start_scan+0x34f/0x5d0 [mac80211]
 [<ffffffffa051c4a0>] ieee80211_request_scan+0x30/0x50 [mac80211]
 [<ffffffffa052b838>] ieee80211_scan+0x68/0xc0 [mac80211]
 [<ffffffffa04b7dab>] nl80211_trigger_scan+0x5bb/0x640 [cfg80211]
 [<ffffffff816604ac>] genl_family_rcv_msg+0x1bc/0x3e0
 [<ffffffff811eda4a>] ? kmem_cache_alloc+0x1ca/0x1f0
 [<ffffffff816606d0>] ? genl_family_rcv_msg+0x3e0/0x3e0
 [<ffffffff81660749>] genl_rcv_msg+0x79/0xc0
 [<ffffffff8165fd59>] netlink_rcv_skb+0xa9/0xd0
 [<ffffffff816602d8>] genl_rcv+0x28/0x40
 [<ffffffff8165f37a>] netlink_unicast+0x12a/0x1a0
 [<ffffffff8165f741>] netlink_sendmsg+0x351/0x7b0
 [<ffffffff8130f9f2>] ? sock_has_perm+0x72/0x90
 [<ffffffff816132fe>] sock_sendmsg+0x9e/0xe0
 [<ffffffff81612fce>] ? move_addr_to_kernel.part.20+0x1e/0x70
 [<ffffffff81613ed1>] ? move_addr_to_kernel+0x21/0x30
 [<ffffffff81613768>] ___sys_sendmsg+0x3c8/0x3e0
 [<ffffffff810a5e86>] ? __set_current_blocked+0x36/0x60
 [<ffffffff8101f67e>] ? fpu_finit+0x1e/0x30
 [<ffffffff8101f8e1>] ? init_fpu+0x51/0xb0
 [<ffffffff81020b58>] ? __restore_xstate_sig+0x268/0x660
 [<ffffffff81013745>] ? do_signal+0x1a5/0x6f0
 [<ffffffff81614681>] __sys_sendmsg+0x51/0x90
 [<ffffffff816146d2>] SyS_sendmsg+0x12/0x20
 [<ffffffff81743369>] system_call_fastpath+0x16/0x1b
---[ end trace 561080c39bcc6e52 ]---
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e53 ]---
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e54 ]---
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e55 ]---
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e56 ]---
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e57 ]---
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e58 ]---
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e59 ]---
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e5a ]---
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e5b ]---
wlp0s4f1u5: direct probe to ... (try 1/3)
                            ... (try 2/3)
                            ... (try 3/3)
wlp0s4f1u5: authentication with ... timed out
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e5c ]---
wlp0s4f1u5: authenticate with ...
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e5d ]---
wlp0s4f1u5: direct probe to ... (try 1/3)
... timed out
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e5e ]---
wlp0s4f1u5: authenticate with ...
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e5f ]---
wlp0s4f1u5: direct probe to ... (try 1/3)
wlp0s4f1u5: Connection to AP ... lost
... timed out
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e60 ]---
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e61 ]---
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e62 ]---
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e63 ]---
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e64 ]---
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e65 ]---
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e66 ]---
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e67 ]---
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e68 ]---
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e69 ]---
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e6a ]---
------------[ cut here ]------------
...
---[ end trace 561080c39bcc6e6b ]---
usbcore: deregistering interface driver rtl8192su



