Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:40171 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbZEOVpI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 17:45:08 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1M55DD-00052V-72
	for linux-wireless@vger.kernel.org; Fri, 15 May 2009 21:45:03 +0000
Received: from 142.46.206.190 ([142.46.206.190])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 15 May 2009 21:45:03 +0000
Received: from pzeldin by 142.46.206.190 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 15 May 2009 21:45:03 +0000
To: linux-wireless@vger.kernel.org
From: Pavel <pzeldin@gmail.com>
Subject: rt2500usb causes kernel bug
Date: Fri, 15 May 2009 21:42:10 +0000 (UTC)
Message-ID: <loom.20090515T212932-693@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Linksys Wireless-G USB network adapter
Kernel 2.6.29 PowerPC
lsmod:
Module                  Size  Used by    Not tainted                           
                                                                               
                                                                     
arc4                    1696  2                                                
                                                                               
                                                                     
rt2500usb              21348  0                                                
                                                                               
                                                                     
rt2x00usb               9768  1 rt2500usb                                      
                                                                               
                                                                     
rt2x00lib              28856  2 rt2500usb,rt2x00usb                            
                                                                               
                                                                     
mac80211              138558  2 rt2x00usb,rt2x00lib                            
                                                                               
                                                                     
cfg80211               40264  2 rt2x00lib,mac80211                             
                                                                               
                                                                     
rfkill                 10368  2 rt2x00lib         

Seems to work fine fo short packets, but longer packets kill kernel, for example
ping -s 6400 192.168.2.1

Results in:
[ 1101.692506] ------------[ cut here ]------------                            
                                                                               
                                                                     
[ 1101.697135] kernel BUG at mm/vmalloc.c:1058!                                
                                                                               
                                                                     
[ 1101.701397] Oops: Exception in kernel mode, sig: 5 [#1]                     
                                                                               
                                                                     
[ 1101.706600] PowerPC 44x Platform                                            
                                                                               
                                                                     
[ 1101.709814] Modules linked in: arc4 rt2500usb rt2x00usb rt2x00lib mac80211
cfg80211 rfkill vga2fifo                                                       
                                                                       
[ 1101.718975] NIP: c0068d7c LR: c0069664 CTR: 00000000                        
                                                                               
                                                                     
[ 1101.723927] REGS: d7005590 TRAP: 0700   Not tainted  (2.6.29)               
                                                                               
                                                                     
[ 1101.729651] MSR: 00021000 <ME,CE>  CR: 44002084  XER: 0000005f              
                                                                               
                                                                     
[ 1101.735546] TASK = d7df87c0[1591] 'ping' THREAD: d7004000                   
                                                                               
                                                                     
[ 1101.740753] GPR00: 00000200 d7005640 d7df87c0 00001000 00000001 e1000000
fdffe000 ffffffff                                                              
                                                                         
[ 1101.749220] GPR08: 000000d0 c0011024 c03c0000 d7004000 24002088 100e76a8
10090000 10090000                                                              
                                                                         
[ 1101.757687] GPR16: 10090000 00000000 c03d69f4 c0385340 c0017768 c03b91e0
d71dd650 ffffffff                                                              
                                                                         
[ 1101.766155] GPR24: fdffe000 e1000000 c0011024 00000001 000000d0 d7090000
c06be200 0000051f                                                              
                                                                         
[ 1101.774841] NIP [c0068d7c] __get_vm_area_node+0x34/0x184                    
                                                                               
                                                                     
[ 1101.780142] LR [c0069664] vmap+0x50/0x84                                    
                                                                               
                                                                     
[ 1101.784048] Call Trace:                                                     
                                                                               
                                                                     
[ 1101.786491] [d7005640] [24002088] 0x24002088 (unreliable)                   
                                                                               
                                                                     
[ 1101.791908] [d7005670] [c0069664] vmap+0x50/0x84                            
                                                                               
                                                                     
[ 1101.796545] [d7005690] [c0011024] __dma_alloc_coherent+0x1a4/0x22c          
                                                                               
                                                                     
[ 1101.802725] [d70056e0] [c000d0ac] dma_direct_alloc_coherent+0x28/0x70       
                                                                               
                                                                     
[ 1101.809162] [d7005700] [c006ac18] dma_pool_alloc+0xe0/0x22c                 
                                                                               
                                                                     
[ 1101.814740] [d7005760] [c01bd688] ehci_qtd_alloc+0x20/0xa8                  
                                                                               
                                                                     
[ 1101.820230] [d7005790] [c01bd740] qh_urb_transaction+0x30/0x3d4             
                                                                               
                                                                     
[ 1101.826150] [d70057d0] [c01c055c] ehci_urb_enqueue+0x60/0xfec               
                                                                               
                                                                     
[ 1101.831897] [d7005830] [c01aa368] usb_hcd_submit_urb+0x284/0xa9c            
                                                                               
                                                                     
[ 1101.837908] [d70058f0] [c01ab4fc] usb_submit_urb+0x164/0x358                
                                                                               
                                                                     
[ 1101.843580] [d7005910] [e20d9078] rt2x00usb_kick_tx_queue+0x174/0x33c
[rt2x00usb]                                                                    
                                                                            
[ 1101.851078] [d7005930] [e20df00c] rt2500usb_kick_tx_queue+0x20/0x148
[rt2500usb]                                                                    
                                                                             
[ 1101.858492] [d7005960] [e1f774b0] rt2x00queue_write_tx_descriptor+0x90/0xa4
[rt2x00lib]                                                                    
                                                                      
[ 1101.866495] [d7005980] [e1f78330] rt2x00queue_write_tx_frame+0x120/0x1e4
[rt2x00lib]                                                                    
                                                                         
[ 1101.874235] [d70059d0] [e1f769f8] rt2x00mac_tx+0x88/0x2d0 [rt2x00lib]       
                                                                               
                                                                     
[ 1101.880755] [d7005a00] [e20967d8] __ieee80211_tx+0x70/0x198 [mac80211]      
                                                                               
                                                                     
[ 1101.887306] [d7005a20] [e20977e0] ieee80211_master_start_xmit+0x2d4/0x488
[mac80211]                                                                     
                                                                        
[ 1101.895050] [d7005a90] [c022d540] dev_hard_start_xmit+0x234/0x2dc           
                                                                               
                                                                     
[ 1101.901153] [d7005ac0] [c023e150] __qdisc_run+0x1c8/0x250                   
                                                                               
                                                                     
[ 1101.906554] [d7005af0] [c0230644] dev_queue_xmit+0x290/0x4c0                
                                                                               
                                                                     
[ 1101.912231] [d7005b10] [e20971cc] ieee80211_subif_start_xmit+0x478/0x504
[mac80211]                                                                     
                                                                         
[ 1101.919883] [d7005b70] [c022d540] dev_hard_start_xmit+0x234/0x2dc           
                                                                               
                                                                     
[ 1101.925974] [d7005ba0] [c023e150] __qdisc_run+0x1c8/0x250                   
                                                                               
                                                                     
[ 1101.931374] [d7005bd0] [c0230644] dev_queue_xmit+0x290/0x4c0                
                                                                               
                                                                     
[ 1101.937040] [d7005bf0] [c024c234] ip_finish_output2+0xcc/0x244              
                                                                               
                                                                     
[ 1101.942874] [d7005c10] [c024ca00] ip_fragment+0x5cc/0x690                   
                                                                               
                                                                     
[ 1101.948274] [d7005c60] [c024ce3c] ip_local_out+0x34/0x48                    
                                                                               
                                                                     
[ 1101.953588] [d7005c70] [c024d100] ip_push_pending_frames+0x2b0/0x3cc        
                                                                               
                                                                     
[ 1101.959946] [d7005c90] [c0269154] raw_sendmsg+0x6b4/0x710                   
                                                                               
                                                                     
[ 1101.965347] [d7005d20] [c0271fa0] inet_sendmsg+0x4c/0x78                    
                                                                               
                                                                     
[ 1101.970662] [d7005d40] [c021e85c] sock_sendmsg+0xac/0xe4                    
                                                                               
                                                                     
[ 1101.975973] [d7005e30] [c021ebd4] sys_sendto+0xbc/0xf0                      
                                                                               
                                                                     
[ 1101.981114] [d7005f00] [c021f628] sys_socketcall+0x140/0x1f8                
                                                                               
                                                                     
[ 1101.986780] [d7005f40] [c000d7e0] ret_from_syscall+0x0/0x3c                 
                                                                               
                                                                     
[ 1101.992350] Instruction dump:                                               
                                                                               
                                                                     
[ 1101.995323] 7c0802a6 bee1000c 90010034 542b0024 800b000c 7c9b2378 5400012e
7cb92b78                                                                       
                                                                       
[ 1102.003167] 7cd83378 7cf73b78 7d1c4378 7d3a4b78 <0f000000> 70800001 3ba00001
41820018                                                                       
                                                                     
[ 1102.011191] Kernel panic - not syncing: Fatal exception in interrupt        
                                                                               
                                                                     
[ 1102.017520] Rebooting in 180 seconds..



