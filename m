Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50424 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbbEBQkH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2015 12:40:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1YoaSR-0006iP-Go
	for linux-wireless@vger.kernel.org; Sat, 02 May 2015 18:40:03 +0200
Received: from md-188-69-194-165.omni.lt ([188.69.194.165])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 02 May 2015 18:40:03 +0200
Received: from nerijus by md-188-69-194-165.omni.lt with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 02 May 2015 18:40:03 +0200
To: linux-wireless@vger.kernel.org
From: Nerijus =?utf-8?b?QmFsacWrbmFz?= <nerijus@users.sourceforge.net>
Subject: b43 AP does not work
Date: Sat, 2 May 2015 16:32:09 +0000 (UTC)
Message-ID: <loom.20150502T183011-57@post.gmane.org> (sfid-20150502_184010_475480_8E80B250)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

lspci:
02:00.0 Network controller [0280]: Broadcom Corporation BCM4311 802.11a/b/g
[14e4:4312] (rev 02)

AP worked on F21. On F22 kernels 4.0.0 and 4.0.1 it does not.

# hostapd -dB /etc/hostapd/hostapd.conf
random: Trying to read entropy from /dev/random
Configuration file: /etc/hostapd/hostapd.conf
ctrl_interface_group=10 (from group name 'wheel')
rfkill: initial event: idx=0 type=2 op=0 soft=1 hard=0
rfkill: initial event: idx=1 type=1 op=0 soft=0 hard=0
nl80211: Supported cipher 00-0f-ac:1
nl80211: Supported cipher 00-0f-ac:5
nl80211: Supported cipher 00-0f-ac:2
nl80211: Supported cipher 00-0f-ac:4
nl80211: Supported cipher 00-0f-ac:10
nl80211: Supported cipher 00-0f-ac:8
nl80211: Supported cipher 00-0f-ac:9
nl80211: Using driver-based off-channel TX
nl80211: interface wlan0 in phy phy0
nl80211: Set mode ifindex 3 iftype 3 (AP)
nl80211: Failed to set interface 3 to mode 3: -16 (Device or resource busy)
nl80211: Try mode change after setting interface down
nl80211: Set mode ifindex 3 iftype 3 (AP)
nl80211: Mode change succeeded while interface is down
nl80211: Setup AP(wlan0) - device_ap_sme=0 use_monitor=0
nl80211: Subscribe to mgmt frames with AP handle 0x86c16f0
nl80211: Register frame type=0xb0 (WLAN_FC_STYPE_AUTH) nl_handle=0x86c16f0
match=
nl80211: Register frame type=0x0 (WLAN_FC_STYPE_ASSOC_REQ)
nl_handle=0x86c16f0 match=
nl80211: Register frame type=0x20 (WLAN_FC_STYPE_REASSOC_REQ)
nl_handle=0x86c16f0 match=
nl80211: Register frame type=0xa0 (WLAN_FC_STYPE_DISASSOC)
nl_handle=0x86c16f0 match=
nl80211: Register frame type=0xc0 (WLAN_FC_STYPE_DEAUTH) nl_handle=0x86c16f0
match=
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x86c16f0
match=
nl80211: Register frame command failed (type=208): ret=-114 (Operation
already in progress)
nl80211: Register frame match - hexdump(len=0): [NULL]
nl80211: Could not configure driver mode
nl80211: Remove monitor interface: refcount=0
nl80211: Remove beacon (ifindex=3)
netlink: Operstate: ifindex=3 linkmode=0 (kernel-control), operstate=6
(IF_OPER_UP)
nl80211: Set mode ifindex 3 iftype 2 (STATION)
nl80211: Failed to set interface 3 to mode 2: -16 (Device or resource busy)
nl80211: Try mode change after setting interface down
nl80211: Set mode ifindex 3 iftype 2 (STATION)
nl80211: Mode change succeeded while interface is down
nl80211: Teardown AP(wlan0) - device_ap_sme=0 use_monitor=0
nl80211 driver initialization failed.
hostapd_interface_deinit_free(0x86bf2a0)
hostapd_interface_deinit_free: num_bss=1 conf->num_bss=1
hostapd_interface_deinit(0x86bf2a0)
hostapd_bss_deinit: deinit bss wlan0
hostapd_cleanup(hapd=0x86c0cd0 (wlan0))
hostapd_free_hapd_data: Interface wlan0 wasn't started
hostapd_interface_deinit_free: driver=(nil) drv_priv=(nil) -> hapd_deinit
hostapd_interface_free(0x86bf2a0)
hostapd_interface_free: free hapd 0x86c0cd0
hostapd_cleanup_iface(0x86bf2a0)
hostapd_cleanup_iface_partial(0x86bf2a0)
hostapd_cleanup_iface: free iface=0x86bf2a0

Regards,
Nerijus

