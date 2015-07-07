Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:32879 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbbGGV4Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 17:56:24 -0400
Received: by wiwl6 with SMTP id l6so327350100wiw.0
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jul 2015 14:56:23 -0700 (PDT)
Received: from linux-suse.hu (catv-178-48-68-209.catv.broadband.hu. [178.48.68.209])
        by mx.google.com with ESMTPSA id ny7sm54551950wic.11.2015.07.07.14.56.22
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Jul 2015 14:56:22 -0700 (PDT)
From: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Kernel BUG in rtl92s_phy_chk_fwcmd_iodone():<0-0> Set FW Cmd fail
Date: Tue, 07 Jul 2015 23:56:21 +0200
Message-ID: <4407990.FztixZGyze@linux-suse.hu> (sfid-20150707_235630_472270_1FFFB2C6)
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear list members,

I have an RTL8191SU 802.11n USB WLAN Adapter with rtl8192su driver. 
Unfortunately, I have to turn it off and on sometimes to make it work. I use 
NetworkManager with KDE 5 nm-applet in which I simply turn off the wireless 
capability then on again.

Once I did this, I got a kernel BUG. Here is the link for the full text: 
http://paste.opensuse.org/view/simple/25089935

Versions:
- Linux wireless kernel v4.1
- rtl8192su driver from https://github.com/chunkeey/rtl8192su [0f01e11226dcc]

Excerpt:

NetworkManager[1241]: <info> WiFi now enabled by radio killswitch
NetworkManager[1241]: <info> (wlp0s26f7u2) supports 4 scan SSIDs
NetworkManager[1241]: <info> (wlp0s26f7u2): supplicant interface state: 
starting -> ready
NetworkManager[1241]: <info> (wlp0s26f7u2): device state change: unavailable -
> disconnected (reason 'supplicant-available') [20 30 42]
NetworkManager[1241]: <info> (wlp0s26f7u2): supplicant interface state: ready 
-> disconnected
NetworkManager[1241]: <info> (wlp0s26f7u2) supports 4 scan SSIDs
kernel: rtl8192s_common:rtl92s_phy_chk_fwcmd_iodone():<0-0> Set FW Cmd fail!!
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 3 PID: 1105 at 
/home/aki/temp/rtl8192su/rtlwifi/rtl8192s/phy_common.c:1192 
rtl92s_phy_chk_fwcmd_iodone+0x65/0xb0 [rtl8192s_common]()
kernel: Modules linked in: ctr ccm af_packet arc4 rtl8192su(O) 
rtl8192s_common(O) rtl_usb(O) rtlwifi(O) mac80211 xt_pkttype cfg80211 
ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag
kernel:  serio_raw i2c_i801 lpc_ich mfd_core r8169 mii i7core_edac edac_core 
shpchp i5500_temp 8250_fintek tpm_infineon tpm_tis tpm acpi_cpufreq processor 
dm_mod sr_mod cdrom hid_log
kernel: CPU: 3 PID: 1105 Comm: wpa_supplicant Tainted: P          IO    4.1.0-
wl-1.g3ee3773-desktop #1
kernel: Hardware name: MSI MS-7522/MSI X58 Pro-E (MS-7522), BIOS V8.15 
03/19/2011
kernel:  ffffffffa05f8c70 ffff8800bab13908 ffffffff816d178e 0000000000000007
kernel:  0000000000000000 ffff8800bab13948 ffffffff8106b4fa ffff8800bab13968
kernel:  0000000000000000 ffff880195cf1440 0000000000000000 ffff880195cf06a0
kernel: Call Trace:
kernel:  [<ffffffff816d178e>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff8106b4fa>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff8106b5ea>] warn_slowpath_null+0x1a/0x20
kernel:  [<ffffffffa05ef875>] rtl92s_phy_chk_fwcmd_iodone+0x65/0xb0 
[rtl8192s_common]
kernel:  [<ffffffffa05f1c31>] _rtl92s_phy_set_fwcmd_io+0xe1/0x670 
[rtl8192s_common]
kernel:  [<ffffffffa05f2279>] rtl92s_phy_set_fw_cmd+0xb9/0x7b0 [rtl8192s_common]
kernel:  [<ffffffffa05f29aa>] rtl92s_phy_scan_operation_backup+0x3a/0x90 
[rtl8192s_common]
kernel:  [<ffffffffa061b8d9>] rtl_op_sw_scan_start+0xa9/0x170 [rtlwifi]
kernel:  [<ffffffffa053aece>] __ieee80211_start_scan+0x42e/0x720 [mac80211]
kernel:  [<ffffffff811d1455>] ? __kmalloc_node_track_caller+0x35/0x40
kernel:  [<ffffffffa053be20>] ieee80211_request_scan+0x30/0x50 [mac80211]
kernel:  [<ffffffffa054d1d8>] ieee80211_scan+0x68/0xc0 [mac80211]
kernel:  [<ffffffffa04c7e46>] nl80211_trigger_scan+0x626/0x6c0 [cfg80211]
kernel:  [<ffffffff816046ea>] genl_family_rcv_msg+0x19a/0x390
kernel:  [<ffffffff816048e0>] ? genl_family_rcv_msg+0x390/0x390
kernel:  [<ffffffff81604959>] genl_rcv_msg+0x79/0xc0
kernel:  [<ffffffff81603e29>] netlink_rcv_skb+0xb9/0xe0
kernel:  [<ffffffff8160453c>] genl_rcv+0x2c/0x40
kernel:  [<ffffffff81603598>] netlink_unicast+0x108/0x1a0
kernel:  [<ffffffff81603b35>] netlink_sendmsg+0x505/0x620
kernel:  [<ffffffff815b448d>] sock_sendmsg+0x3d/0x50
kernel:  [<ffffffff815b50bb>] ___sys_sendmsg+0x2bb/0x2d0
kernel:  [<ffffffff810100d2>] ? fpu_finit+0x22/0x40
kernel:  [<ffffffff810102e1>] ? init_fpu+0x51/0xb0
kernel:  [<ffffffff81011718>] ? __restore_xstate_sig+0x298/0x6c0
kernel:  [<ffffffff810040ef>] ? do_signal+0xaf/0x130
kernel:  [<ffffffff815b57e2>] __sys_sendmsg+0x42/0x80
kernel:  [<ffffffff815b5832>] SyS_sendmsg+0x12/0x20
kernel:  [<ffffffff816d7b32>] system_call_fastpath+0x16/0x75
kernel: ---[ end trace b0eab65ae6555186 ]---

Best regards,

Ákos
