Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [66.209.47.173] ([66.209.47.173]:45725 "EHLO mythtv.ewol.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753982AbYG2Ky3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 06:54:29 -0400
Received: from [127.0.0.1] (localhost.localdomain [127.0.0.1])
	by mythtv.ewol.com (8.14.2/8.14.2) with ESMTP id m6TAsO8m007186
	for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 06:54:25 -0400
Message-ID: <488EF6E0.7050209@cortland.com> (sfid-20080729_125437_639538_96B3F8BB)
Date: Tue, 29 Jul 2008 06:54:24 -0400
From: Steve Brown <sbrown@cortland.com>
Reply-To: sbrown@cortland.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: oops in cfg80211 doing mesh mpath dump
Content-Type: multipart/mixed;
 boundary="------------060000000809090100050209"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060000000809090100050209
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I added line numbers to the recursion path. If more are needed, let me know.

This is current wireless-testing w/ a patch in start_mesh to start beacons.

Steve




--------------060000000809090100050209
Content-Type: text/plain;
 name="README-oops-mpath-dump.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="README-oops-mpath-dump.txt"

root@OpenWrt:/# iw dev wmaster0 interface add mesh type mp mesh_id 1234
root@OpenWrt:/# iwconfig mesh channel 11
root@OpenWrt:/# iwconfig mesh 192.168.10.26
root@OpenWrt:/# Mesh plink timer for 00:16:01:2e:0c:4c fired on state 1                                
Mesh plink for 00:16:01:2e:0c:4c (retry, timeout): 0 100                                               
Mesh plink timer for 00:16:01:2e:0c:4c fired on state 1                                                
Mesh plink for 00:16:01:2e:0c:4c (retry, timeout): 1 105                                               
Mesh plink timer for 00:16:01:2e:0c:4c fired on state 1                                                
Mesh plink for 00:16:01:2e:0c:4c (retry, timeout): 2 151                                               
Mesh plink timer for 00:16:01:2e:0c:4c fired on state 1                                                
Mesh plink (peer, state, llid, plid, event): 00:16:01:2e:0c:4c 5 6342 0 8                              
Mesh plink timer for 00:16:01:2e:0c:4c fired on state 5                                                
Mesh plink (peer, state, llid, plid, event): 00:16:01:2e:0c:4c 0 0 0 1                                 
Mesh plink (peer, state, llid, plid, event): 00:16:01:2e:0c:4c 2 42537 65000 4                         
Mesh plink with 00:16:01:2e:0c:4c ESTABLISHED                                                          
                                                                                                       
root@OpenWrt:/# iw dev mesh station dump                                                               
Station 00:16:01:2e:0c:4c (on mesh)                                                                    
        inactive time:  10 ms                                                                          
        rx bytes:       9024                                                                           
        tx bytes:       497                                                                            
        mesh llid:      42537                                                                          
        mesh plid:      65000                                                                          
        mesh plink:     ESTAB                                                                          
root@OpenWrt:/# iw dev mesh mpath dump
------------[ cut here ]------------
kernel BUG at net/mac80211/ieee80211_i.h:757!
invalid opcode: 0000 [#1] SMP 
Modules linked in: usb_storage via_rhine ehci_hcd ohci_hcd ne2k_pci 8390 leds_alix sd_mod nf_nat_tftp i

Pid: 925, comm: iw Not tainted (2.6.26-wl #1)
EIP: 0060:[<d08bcd00>] EFLAGS: 00010246 CPU: 0
EIP is at ieee80211_aes_ccm_decrypt+0x1b1/0x1099 [mac80211]
EAX: cfc68180 EBX: cfc54000 ECX: 00000000 EDX: cfc54000
ESI: cfc57c82 EDI: cff30860 EBP: cfc54500 ESP: cfc57c28
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process iw (pid: 925, ti=cfc56000 task=cfcb4440 task.ti=cfc56000)
Stack: d08cd7a0 cfc68000 d0885c35 cfc57c82 cfc57c7c cfc57c60 cfefa080 cfc68020
       00000001 00000003 00000000 00000000 00000000 00000000 cfefa080 cfc04bc0
       c021e0e2 00000000 000000d0 cfdb3600 00000f00 0000039d cfc7da00 c021ac4f
Call Trace:
 [<d0885c35>] nl80211_notify_dev_rename+0x426/0x14d0 [cfg80211] file net/wireless/nl80211.c, line 1315.
 [<c021e0e2>] __alloc_skb+0x53/0xfd 				file net/core/skbuff.c, line 199
 [<c021ac4f>] sock_rmalloc+0x23/0x58				file include/linux/skbuff.h, line 362
 [<c023223d>] netlink_dump+0x4a/0x16c				file net/netlink/af_netlink.c, line 1544
 [<c0233cda>] netlink_dump_start+0xf9/0x11c			file include/asm/atomic_32.h, line 124
 [<c023522f>] genl_rcv_msg+0xa9/0x15e				file net/netlink/genetlink.c, line 448
 [<d0885b55>] nl80211_notify_dev_rename+0x346/0x14d0 [cfg80211] file net/wireless/nl80211.c, line 1315.
 [<c017e6f7>] pid_revalidate+0x12/0xbf				
 [<c017e88e>] proc_pid_instantiate+0x6d/0x7d
 [<c0235186>] genl_rcv_msg+0x0/0x15e
 [<c0232f63>] netlink_rcv_skb+0x2d/0x72
 [<c02349b5>] genl_rcv+0x19/0x24
 [<c0232d87>] netlink_unicast+0x1a2/0x20b
 [<c023355a>] netlink_sendmsg+0x228/0x235
 [<c0218fc7>] sock_sendmsg+0xb8/0xd1
 [<c012afec>] autoremove_wake_function+0x0/0x2d
 [<c016315c>] d_rehash+0x1c/0x29
 [<c01807ef>] proc_lookup_de+0x91/0xa6
 [<c015bc96>] do_lookup+0x53/0x145
 [<c016348a>] dput+0x15/0xbb
 [<c021f202>] verify_iovec+0x3e/0x70
 [<c021916f>] sys_sendmsg+0x18f/0x1f2
 [<c0219a12>] sys_recvmsg+0x1b7/0x214
 [<c01b993a>] copy_to_user+0x27/0x31
 [<c022339a>] dev_ioctl+0x53f/0x582
 [<c027ca4d>] _spin_lock_bh+0x8/0x1e
 [<c021ab5d>] lock_sock_nested+0x84/0x8c
 [<c021ab5d>] lock_sock_nested+0x84/0x8c
 [<c027ca4d>] _spin_lock_bh+0x8/0x1e
 [<c0219fe2>] sys_socketcall+0x168/0x181
 [<c01556f3>] sys_close+0x67/0x9c
 [<c0103cf2>] syscall_call+0x7/0xb
 [<c0270000>] br_fdb_fillbuf+0xd0/0x10f
 =======================  
Code: 53 89 d3 8b 82 30 01 00 00 8b 74 24 0c 85 c0 75 04 0f 0b eb fe 8b 00 85 c0 75 04 0f 0b eb fe 05  
EIP: [<d08bcd00>] ieee80211_aes_ccm_decrypt+0x1b1/0x1099 [mac80211] SS:ESP 0068:cfc57c28
---[ end trace cb73109712059c2a ]--- 
Segmentation fault                                                                                     
root@OpenWrt:/# 



--------------060000000809090100050209--
