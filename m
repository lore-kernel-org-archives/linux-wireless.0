Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43192 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752199AbZHBNXO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 09:23:14 -0400
Message-ID: <4A759341.1090006@gmx.de>
Date: Sun, 02 Aug 2009 15:23:13 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ar9170usb crashes during iwconfig for ad-hoc mode
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After
	ifconfig wlan1 down
	iwconfig wlan1 mode managed essid huhu
	ifconfig wlan1 up
	ifconfig wlan1 down
	iwconfig wlan1 mode ad-hoc essid huhu_a channel 1

ar9170 crashes (see below for the syslog).

It seems like ar9170_op_bss_info_changed() is called with ar->vif == NULL
(i.e. ((struct ar9170 *)hw->priv)->vif == NULL), while parameter vif != NULL and
changed & (BSS_CHANGED_BEACON | BSS_CHANGED_BEACON_ENABLED) is non-zero.
ar->vif is passed unchecked to ieee80211_beacon_get().

Is this something ar9170 is supposed to handle or a bug in cfg80211/mac80211?
Is a driver's *bss_info_changed proc called while the netdev is closed?

Regards,
Joerg

Aug  2 10:15:42 nc10 kernel: [ 7174.202095] BUG: unable to handle kernel NULL pointer dereference at (null)
Aug  2 10:15:42 nc10 kernel: [ 7174.202118] IP: [<f8ecf27f>] ieee80211_beacon_get+0x1f/0x2a0 [mac80211]
Aug  2 10:15:42 nc10 kernel: [ 7174.202183] *pde = 00000000
Aug  2 10:15:42 nc10 kernel: [ 7174.202194] Oops: 0000 [#1] SMP
Aug  2 10:15:42 nc10 kernel: [ 7174.202206] last sysfs file: /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:23/PNP0C09:00/PNP0C0A:00/power_supply/BAT1/charge_full
Aug  2 10:15:42 nc10 kernel: [ 7174.202573]
Aug  2 10:15:42 nc10 kernel: [ 7174.202586] Pid: 23223, comm: iwconfig Not tainted (2.6.30 #1) NC10

Aug  2 10:15:42 nc10 kernel: [ 7174.202599] EIP: 0060:[<f8ecf27f>] EFLAGS: 00010297 CPU: 1
Aug  2 10:15:42 nc10 kernel: [ 7174.202648] EIP is at ieee80211_beacon_get+0x1f/0x2a0 [mac80211]
Aug  2 10:15:42 nc10 kernel: [ 7174.202660] EAX: 00000000 EBX: f6d461c0 ECX: f66807cc EDX: fffffbb8
Aug  2 10:15:42 nc10 kernel: [ 7174.202672] ESI: f66807cc EDI: 00000200 EBP: f5fb1cf4 ESP: f5fb1cc0
Aug  2 10:15:42 nc10 kernel: [ 7174.202683]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Aug  2 10:15:42 nc10 kernel: [ 7174.202696] Process iwconfig (pid: 23223, ti=f5fb0000 task=d35918e0 task.ti=f5fb0000)
Aug  2 10:15:42 nc10 kernel: [ 7174.202706] Stack:
Aug  2 10:15:42 nc10 kernel: [ 7174.202713]  c04e53b8 00000000 c064aac0 f7424018 f77c9000 f7424018 f5fb1f00 fffffbb8
Aug  2 10:15:42 nc10 kernel: [ 7174.202739]  00000000 00000246 f6d46a20 f66807cc 00000200 f5fb1d2c fa03dde6 c01fcde6
Aug  2 10:15:42 nc10 kernel: [ 7174.202767]  00000178 00000174 f6d46a20 f5fb1d14 f5fb1d58 c0145ecc 00000000 f5fb1d2c
Aug  2 10:15:42 nc10 kernel: [ 7174.202797] Call Trace:
Aug  2 10:15:42 nc10 kernel: [ 7174.202807]  [<fa03dde6>] ? ar9170_update_beacon+0x16/0x430 [ar9170usb]
Aug  2 10:15:42 nc10 kernel: [ 7174.202836]  [<c01fcde6>] ? proc_alloc_inode+0x16/0x70
Aug  2 10:15:42 nc10 kernel: [ 7174.202857]  [<c0145ecc>] ? __cancel_work_timer+0x3c/0x160
Aug  2 10:15:42 nc10 kernel: [ 7174.202876]  [<fa03b205>] ? ar9170_op_bss_info_changed+0xb5/0x120 [ar9170usb]
Aug  2 10:15:42 nc10 kernel: [ 7174.202901]  [<fa03b150>] ? ar9170_op_bss_info_changed+0x0/0x120 [ar9170usb]
Aug  2 10:15:42 nc10 kernel: [ 7174.202926]  [<f8ebcf38>] ? ieee80211_bss_info_change_notify+0xf8/0x1c0 [mac80211]
Aug  2 10:15:42 nc10 kernel: [ 7174.202973]  [<f8ec1a99>] ? ieee80211_ibss_leave+0x79/0xc0 [mac80211]
Aug  2 10:15:42 nc10 kernel: [ 7174.203020]  [<f8ec9f7e>] ? ieee80211_leave_ibss+0xe/0x10 [mac80211]
Aug  2 10:15:42 nc10 kernel: [ 7174.203070]  [<f8c5a312>] ? __cfg80211_leave_ibss+0x52/0x80 [cfg80211]
Aug  2 10:15:42 nc10 kernel: [ 7174.203116]  [<f8c5a9d6>] ? cfg80211_ibss_wext_siwessid+0x76/0x120 [cfg80211]
Aug  2 10:15:42 nc10 kernel: [ 7174.203158]  [<f8c5cdb7>] ? cfg80211_wext_siwessid+0x57/0x70 [cfg80211]
Aug  2 10:15:42 nc10 kernel: [ 7174.203198]  [<c04b6ad9>] ? ioctl_standard_call+0x199/0x3a0
Aug  2 10:15:42 nc10 kernel: [ 7174.203218]  [<c03fe66d>] ? __dev_get_by_name+0x7d/0xa0
Aug  2 10:15:42 nc10 kernel: [ 7174.203237]  [<c04b65ef>] ? wext_handle_ioctl+0x14f/0x220
Aug  2 10:15:42 nc10 kernel: [ 7174.203253]  [<f8c5cd60>] ? cfg80211_wext_siwessid+0x0/0x70 [cfg80211]
Aug  2 10:15:42 nc10 kernel: [ 7174.203294]  [<c03ff1d0>] ? dev_ioctl+0x460/0x540
Aug  2 10:15:42 nc10 kernel: [ 7174.203312]  [<c03ee150>] ? sock_ioctl+0x0/0x260
Aug  2 10:15:42 nc10 kernel: [ 7174.203328]  [<c03ee23d>] ? sock_ioctl+0xed/0x260
Aug  2 10:15:42 nc10 kernel: [ 7174.203344]  [<c03ee150>] ? sock_ioctl+0x0/0x260
Aug  2 10:15:42 nc10 kernel: [ 7174.203358]  [<c01cc048>] ? vfs_ioctl+0x28/0x80
Aug  2 10:15:42 nc10 kernel: [ 7174.203376]  [<c01cc112>] ? do_vfs_ioctl+0x72/0x580
Aug  2 10:15:42 nc10 kernel: [ 7174.203392]  [<c01a7596>] ? unmap_region+0x106/0x130
Aug  2 10:15:42 nc10 kernel: [ 7174.203408]  [<c01a7606>] ? remove_vma+0x46/0x60
Aug  2 10:15:42 nc10 kernel: [ 7174.203423]  [<c01a7606>] ? remove_vma+0x46/0x60
Aug  2 10:15:42 nc10 kernel: [ 7174.203437]  [<c01a8483>] ? do_munmap+0x223/0x280
Aug  2 10:15:42 nc10 kernel: [ 7174.203453]  [<c01cc683>] ? sys_ioctl+0x63/0x70
Aug  2 10:15:42 nc10 kernel: [ 7174.203469]  [<c0102fc4>] ? sysenter_do_call+0x12/0x22
Aug  2 10:15:42 nc10 kernel: [ 7174.203487] Code: 7d e4 c6 45 eb fe e9 51 ff ff ff 90 55 89 e5 57 56 53 89 c3 83 ec 28 89 55 d0 8b 40 1c 81 ea 48 04 00 00 8b 00 89 55 e8 89 45 ec 
<8b> 82 48 04 00 00 83 f8 03 0f 84 2a 01 00 00 83 f8 01 0f 84 49
Aug  2 10:15:42 nc10 kernel: [ 7174.203631] EIP: [<f8ecf27f>] ieee80211_beacon_get+0x1f/0x2a0 [mac80211] SS:ESP 0068:f5fb1cc0
Aug  2 10:15:42 nc10 kernel: [ 7174.203687] CR2: 0000000000000000
Aug  2 10:15:42 nc10 kernel: [ 7174.203699] ---[ end trace 0732cb3688c4eefe ]---
