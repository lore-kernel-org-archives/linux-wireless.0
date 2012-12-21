Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.unitix.de ([176.9.2.175]:55434 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738Ab2LUU6p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2012 15:58:45 -0500
Received: from [192.168.1.64] (cable-81-173-164-199.netcologne.de [81.173.164.199])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.unitix.de (Postfix) with ESMTPSA id 3815A71F9
	for <linux-wireless@vger.kernel.org>; Fri, 21 Dec 2012 21:48:42 +0100 (CET)
Message-ID: <50D4CB2A.8070302@arndnet.de> (sfid-20121221_215849_645028_995EBD7F)
Date: Fri, 21 Dec 2012 21:48:42 +0100
From: Arnd Hannemann <arnd@arndnet.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath5k - WARNING: at include/net/mac80211.h:3630 rate_control_send_low
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

after reassociation (wpa_cli reassociate),
I occasionally hit the following warning with linux 3.4.22:

[956960.754717] ------------[ cut here ]------------
[956960.769044] WARNING: at include/net/mac80211.h:3630 rate_control_send_low+0xc1/0x1a1 [mac80211]()
[956960.795985] Modules linked in: act_police aes_generic ip6table_raw ip6t_REJECT ip6table_mangle nf_conntrack_ipv6 nf_conntrack_proto_udplite xt_sctp xt_DSCP xt_dscp xt_dccp xt_state ip6table_filter xt_TCPMSS ipt_ULOG ipt_MASQUERADE xt_LOG xt_time xt_connlimit xt_helper xt_realm xt_NFQUEUE xt_tcpmss xt_addrtype xt_pkttype iptable_raw xt_TPROXY nf_tproxy_core ip6_tables nf_defrag_ipv6 xt_hashlimit xt_comment xt_length xt_connmark xt_owner xt_recent xt_iprange xt_physdev xt_policy xt_multiport iptable_nat nf_nat xt_conntrack nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nfnetlink nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ohci_hcd ath5k ath9k ath9k_common ath9k_hw mac80211 ath scx200_acb cfg80211 ehci_hcd
[956961.021541] Pid: 2431, comm: wpa_supplicant Not tainted 3.4.22-ela1 #1
[956961.041473] Call Trace:
[956961.049194]  [<c1016e0a>] warn_slowpath_common+0x65/0x7a
[956961.065537]  [<d093a75f>] ? rate_control_send_low+0xc1/0x1a1 [mac80211]
[956961.085738]  [<c1016e2e>] warn_slowpath_null+0xf/0x13
[956961.101300]  [<d093a75f>] rate_control_send_low+0xc1/0x1a1 [mac80211]
[956961.121034]  [<d09540b0>] minstrel_ht_get_rate+0x25/0x295 [mac80211]
[956961.140492]  [<d093a4cf>] rate_control_get_rate+0x7e/0x24d [mac80211]
[956961.160173]  [<c116a17b>] ? mac_address_string+0x7e/0x86
[956961.176533]  [<d0942569>] invoke_tx_handlers+0x78f/0xf82 [mac80211]
[956961.195733]  [<d09436bd>] ieee80211_tx+0x50/0x77 [mac80211]
[956961.212854]  [<d09439f9>] ieee80211_xmit+0xae/0xb6 [mac80211]
[956961.230490]  [<d0943a47>] ieee80211_tx_skb_tid+0x46/0x50 [mac80211]
[956961.249685]  [<d09475c0>] ieee80211_send_deauth_disassoc+0xbb/0xc1 [mac80211]
[956961.271508]  [<d09476eb>] ieee80211_set_disassoc+0x125/0x275 [mac80211]
[956961.291776]  [<d09479a5>] ieee80211_mgd_deauth+0x92/0x102 [mac80211]
[956961.311242]  [<d093cb5b>] ieee80211_deauth+0x10/0x12 [mac80211]
[956961.329398]  [<d08c33a4>] __cfg80211_mlme_deauth+0x84/0x90 [cfg80211]
[956961.349122]  [<d08c5a31>] __cfg80211_disconnect+0xc3/0x125 [cfg80211]
[956961.368840]  [<d08c838c>] cfg80211_mgd_wext_siwessid+0xec/0x18d [cfg80211]
[956961.389861]  [<d08c7695>] cfg80211_wext_siwessid+0x31/0x3e [cfg80211]
[956961.409540]  [<c1295d1e>] ioctl_standard_call+0x1e6/0x27a
[956961.426079]  [<c1295e63>] wext_handle_ioctl+0xb1/0x132
[956961.441862]  [<d08c7664>] ? cfg80211_wext_giwessid+0x4a/0x4a [cfg80211]
[956961.462025]  [<c11e1013>] dev_ioctl+0x53f/0x57c
[956961.475976]  [<c1068654>] ? do_sync_write+0x93/0xce
[956961.490962]  [<c11d17b4>] ? kernel_sendmsg+0x37/0x37
[956961.506214]  [<c11d198c>] sock_ioctl+0x1d8/0x1e4
[956961.520405]  [<c11d17b4>] ? kernel_sendmsg+0x37/0x37
[956961.535639]  [<c1073610>] do_vfs_ioctl+0x424/0x463
[956961.550346]  [<c11d20da>] ? sys_send+0x18/0x1a
[956961.564049]  [<c11d303f>] ? sys_socketcall+0xc9/0x19c
[956961.579551]  [<c107367d>] sys_ioctl+0x2e/0x48
[956961.592986]  [<c129f4a5>] syscall_call+0x7/0xb
[956961.606681]  [<c1290000>] ? gss_unwrap_resp+0xcd/0x18c
[956961.622421] ---[ end trace b931fca15b42aa18 ]---


Best regards
Arnd
