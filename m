Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35285 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbbEBQsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2015 12:48:40 -0400
Received: by obcux3 with SMTP id ux3so82675825obc.2
        for <linux-wireless@vger.kernel.org>; Sat, 02 May 2015 09:48:39 -0700 (PDT)
Message-ID: <5544FFE5.5090706@lwfinger.net> (sfid-20150502_184843_871297_2E733B3A)
Date: Sat, 02 May 2015 11:48:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TmVyaWp1cyBCYWxpxatuYXM=?=
	<nerijus@users.sourceforge.net>, linux-wireless@vger.kernel.org
Subject: Re: b43 AP does not work
References: <loom.20150502T183011-57@post.gmane.org>
In-Reply-To: <loom.20150502T183011-57@post.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/02/2015 11:32 AM, Nerijus Baliūnas wrote:
> Hello,
>
> lspci:
> 02:00.0 Network controller [0280]: Broadcom Corporation BCM4311 802.11a/b/g
> [14e4:4312] (rev 02)
>
> AP worked on F21. On F22 kernels 4.0.0 and 4.0.1 it does not.
>
> # hostapd -dB /etc/hostapd/hostapd.conf
> random: Trying to read entropy from /dev/random
> Configuration file: /etc/hostapd/hostapd.conf
> ctrl_interface_group=10 (from group name 'wheel')
> rfkill: initial event: idx=0 type=2 op=0 soft=1 hard=0
> rfkill: initial event: idx=1 type=1 op=0 soft=0 hard=0
> nl80211: Supported cipher 00-0f-ac:1
> nl80211: Supported cipher 00-0f-ac:5
> nl80211: Supported cipher 00-0f-ac:2
> nl80211: Supported cipher 00-0f-ac:4
> nl80211: Supported cipher 00-0f-ac:10
> nl80211: Supported cipher 00-0f-ac:8
> nl80211: Supported cipher 00-0f-ac:9
> nl80211: Using driver-based off-channel TX
> nl80211: interface wlan0 in phy phy0
> nl80211: Set mode ifindex 3 iftype 3 (AP)
> nl80211: Failed to set interface 3 to mode 3: -16 (Device or resource busy)
> nl80211: Try mode change after setting interface down
> nl80211: Set mode ifindex 3 iftype 3 (AP)
> nl80211: Mode change succeeded while interface is down
> nl80211: Setup AP(wlan0) - device_ap_sme=0 use_monitor=0
> nl80211: Subscribe to mgmt frames with AP handle 0x86c16f0
> nl80211: Register frame type=0xb0 (WLAN_FC_STYPE_AUTH) nl_handle=0x86c16f0
> match=
> nl80211: Register frame type=0x0 (WLAN_FC_STYPE_ASSOC_REQ)
> nl_handle=0x86c16f0 match=
> nl80211: Register frame type=0x20 (WLAN_FC_STYPE_REASSOC_REQ)
> nl_handle=0x86c16f0 match=
> nl80211: Register frame type=0xa0 (WLAN_FC_STYPE_DISASSOC)
> nl_handle=0x86c16f0 match=
> nl80211: Register frame type=0xc0 (WLAN_FC_STYPE_DEAUTH) nl_handle=0x86c16f0
> match=
> nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x86c16f0
> match=
> nl80211: Register frame command failed (type=208): ret=-114 (Operation
> already in progress)
> nl80211: Register frame match - hexdump(len=0): [NULL]
> nl80211: Could not configure driver mode
> nl80211: Remove monitor interface: refcount=0
> nl80211: Remove beacon (ifindex=3)
> netlink: Operstate: ifindex=3 linkmode=0 (kernel-control), operstate=6
> (IF_OPER_UP)
> nl80211: Set mode ifindex 3 iftype 2 (STATION)
> nl80211: Failed to set interface 3 to mode 2: -16 (Device or resource busy)
> nl80211: Try mode change after setting interface down
> nl80211: Set mode ifindex 3 iftype 2 (STATION)
> nl80211: Mode change succeeded while interface is down
> nl80211: Teardown AP(wlan0) - device_ap_sme=0 use_monitor=0
> nl80211 driver initialization failed.
> hostapd_interface_deinit_free(0x86bf2a0)
> hostapd_interface_deinit_free: num_bss=1 conf->num_bss=1
> hostapd_interface_deinit(0x86bf2a0)
> hostapd_bss_deinit: deinit bss wlan0
> hostapd_cleanup(hapd=0x86c0cd0 (wlan0))
> hostapd_free_hapd_data: Interface wlan0 wasn't started
> hostapd_interface_deinit_free: driver=(nil) drv_priv=(nil) -> hapd_deinit
> hostapd_interface_free(0x86bf2a0)
> hostapd_interface_free: free hapd 0x86c0cd0
> hostapd_cleanup_iface(0x86bf2a0)
> hostapd_cleanup_iface_partial(0x86bf2a0)
> hostapd_cleanup_iface: free iface=0x86bf2a0

A resource busy error from nl80211 usually means that NetworkManager is 
controlling the interface. Are you using NM? If so, have you tried setting up an 
AP using the "access point" mode of the NM applet. That is a lot easier than 
using hostapd, and has the additional advantage of being able to use wireless 
cards for both the WAN and LAN sides of the AP.

Larry


