Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2888 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515Ab2FZSU6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 14:20:58 -0400
Message-ID: <4FE9FD77.7050807@broadcom.com> (sfid-20120626_202104_576941_8A2EA98C)
Date: Tue, 26 Jun 2012 11:20:39 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>
cc: khilman@ti.com, tony@atomide.com, santosh.shilimkar@ti.com,
	b-cousson@ti.com, grant.likely@secretlab.ca,
	linux-omap@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Panda ES board hang when using GPIO as interrupt
References: <4FE8CF77.5080400@broadcom.com>
 <CAC83ZvL2ozQD1DYmtKeFa1PB1pZ1JmBUKFWmDWnbJOCDL3sKNg@mail.gmail.com>
In-Reply-To: <CAC83ZvL2ozQD1DYmtKeFa1PB1pZ1JmBUKFWmDWnbJOCDL3sKNg@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary=------------090301060502080703010307
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--------------090301060502080703010307
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit

On 06/26/2012 12:21 AM, DebBarma, Tarun Kanti wrote:
> On Tue, Jun 26, 2012 at 2:22 AM, Franky Lin <frankyl@broadcom.com> wrote:
>> Hi Kevin, Tarun,
>>
>> We are using the expansion connector A on Panda board to mount a SDIO WiFi
>> dongle on MMC2 with a level triggered interrupt signal connected to GPIO
>> 138. It's been working fine until 3.5 rc1. The board hang randomly within 5
>> mins during a network traffic test. After bisecting we found the culprit is
>> "[PATCH 8/8] gpio/omap: fix missing check in *_runtime_suspend()" [1].
>>
>> I noticed Kevin raised some similar cases on other platforms and also
>> provided two patches in the patch mail thread. But unfortunately those two
>> patches doesn't help in our case. I tested the driver with 3.5-rc3 mainline
>> kernel and the issue is still there. I can only "fix" the hang by either
>> reverting the commit or disabling CONFIG_PM_RUNTIME. Also, the hang only
>> happens on Panda ES board. Old Panda with 4430 works good.
>>
>> Any thoughts and suggestions?
> I just had a quick look at the code. Can you please check if the
> attached patch solves
> the issue? I just boot tested on Panda and Blaze.
> --
> Tarun
>

Thanks for the prompt reply.

Booting is fine even without the patch and revert. The wifi dongle 
generates interrupt whenever there is data packet available for host to 
read. So during a traffic test a significant numbers of interrupt will 
be triggered through the GPIO. So I assume it has something to do with 
the interrupt GPIO.

With the patch, the kernel still crashes. But the symptom is slightly 
different. Now it has a panic log every time. See attachment.

Regards,
Franky

--------------090301060502080703010307
Content-Type: text/plain;
 name=panic.log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=panic.log

[  636.143585] Internal error: Oops - undefined instruction: 0 [#1] SMP ARM                                                                                                         
[  636.150634] Modules linked in: brcmfmac brcmutil cfg80211                                                                                                                        
[  636.156311] CPU: 0    Not tainted  (3.5.0-rc4+ #3)                                                                                                                               
[  636.161346] PC is at __lock_acquire+0x65c/0x1d88                                                                                                                                 
[  636.166198] LR is at 0x60000093                                                                                                                                                  
[  636.169494] pc : [<c008e670>]    lr : [<60000093>]    psr: 20000093                                                                                                              
[  636.169494] sp : c06b1e18  ip : 9e370001  fp : c0724f70                                                                                                                          
[  636.181549] r10: c06b0000  r9 : 0000001e  r8 : c0b92998                                                                                                                          
[  636.187042] r7 : c06d2cc8  r6 : 00000000  r5 : c0746d64  r4 : c06d2868                                                                                                           
[  636.193908] r3 : 00003b0e  r2 : ec3b001d  r1 : 0001d870  r0 : 0000001d                                                                                                           
[  636.200744] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel                                                                                                 
[  636.208526] Control: 10c53c7d  Table: ae39c04a  DAC: 00000017                                                                                                                    
[  636.214569] Process swapper/0 (pid: 0, stack limit = 0xc06b02f8)                                                                                                                 
[  636.220855] Stack: (0xc06b1e18 to 0xc06b2000)                                                                                                                                    
[  636.225433] 1e00:                                                       c06d00f8 00000002                                                                                        
[  636.234039] 1e20: c0807968 00000001 00000000 00000002 0000001d 00000000 00000001 0001d870                                                                                        
[  636.242614] 1e40: c08070e8 00000001 00000000 00000002 00000002 00000000 00000000 c00903e4                                                                                        
[  636.251220] 1e60: 00000002 00000080 00000000 c0066838 00000000 00000000 60000093 00000000                                                                                        
[  636.259796] 1e80: 60000093 00000000 c06b4324 c06b0000 00000000 00000000 00000002 00000000                                                                                        
[  636.268402] 1ea0: 00000000 c00903e4 00000002 00000080 00000000 c00a3588 00000000 c14b0aa0                                                                                        
[  636.276977] 1ec0: 60000093 c06adaa0 00000094 c06b4314 00000002 c06b0000 0000002c 00000000                                                                                        
[  636.285583] 1ee0: 412fc09a c06d3f80 00000000 c04a2914 00000002 00000000 c00a3588 c0048328                                                                                        
[  636.294189] 1f00: 00000033 c06b42c0 c06b4314 c00a3588 c06d00f8 c06af318 c06b0000 c009ff98                                                                                        
[  636.302764] 1f20: 000001da c0014c78 fa24010c c06ced30 c06b1f58 fa240100 00000000 c000848c                                                                                        
[  636.311370] 1f40: c06d2868 c0014f70 20000013 ffffffff c06b1f8c c04a31e4 057b6e56 00000001                                                                                        
[  636.319946] 1f60: 00000000 c06d2868 c06b0000 c0744308 c04ae350 c06d3d50 00000000 412fc09a                                                                                        
[  636.328552] 1f80: c06d3f80 00000000 00000001 c06b1fa0 057b6e57 c0014f70 20000013 ffffffff                                                                                        
[  636.337127] 1fa0: c06d2868 c001519c c071b85c c06cfdf8 c0744240 c0691fdc c14ad080 8000406a                                                                                        
[  636.345733] 1fc0: 00000000 c06617ac ffffffff ffffffff c0661230 00000000 00000000 c0691fdc                                                                                        
[  636.354309] 1fe0: 00000000 10c53c7d c06ced08 c0691fac c06d3d44 80008044 00000000 00000000                                                                                        
[  636.362915] [<c008e670>] (__lock_acquire+0x65c/0x1d88) from [<c00903e4>] (lock_acquire+0x98/0x100)                                                                               
[  636.372344] [<c00903e4>] (lock_acquire+0x98/0x100) from [<c04a2914>] (_raw_spin_lock+0x2c/0x3c)                                                                                  
[  636.381500] [<c04a2914>] (_raw_spin_lock+0x2c/0x3c) from [<c00a3588>] (handle_fasteoi_irq+0x14/0x194)                                                                            
[  636.391174] [<c00a3588>] (handle_fasteoi_irq+0x14/0x194) from [<c009ff98>] (generic_handle_irq+0x30/0x48)                                                                        
[  636.401245] [<c009ff98>] (generic_handle_irq+0x30/0x48) from [<c0014c78>] (handle_IRQ+0x4c/0xac)                                                                                 
[  636.410491] [<c0014c78>] (handle_IRQ+0x4c/0xac) from [<c000848c>] (gic_handle_irq+0x28/0x5c)                                                                                     
[  636.419342] [<c000848c>] (gic_handle_irq+0x28/0x5c) from [<c04a31e4>] (__irq_svc+0x44/0x60)                                                                                      
[  636.428131] Exception stack(0xc06b1f58 to 0xc06b1fa0)                                                                                                                            
[  636.433441] 1f40:                                                       057b6e56 00000001                                                                                        
[  636.442016] 1f60: 00000000 c06d2868 c06b0000 c0744308 c04ae350 c06d3d50 00000000 412fc09a                                                                                        
[  636.450622] 1f80: c06d3f80 00000000 00000001 c06b1fa0 057b6e57 c0014f70 20000013 ffffffff                                                                                        
[  636.459228] [<c04a31e4>] (__irq_svc+0x44/0x60) from [<c0014f70>] (default_idle+0x20/0x44)                                                                                        
[  636.467803] [<c0014f70>] (default_idle+0x20/0x44) from [<c001519c>] (cpu_idle+0x9c/0x114)                                                                                        
[  636.476409] [<c001519c>] (cpu_idle+0x9c/0x114) from [<c06617ac>] (start_kernel+0x2b0/0x300)                                                                                      
[  636.485198] Code: e1a02928 e1a0c182 e089800c e58dc024 (e59f98b4)                                                                                                                 
[  636.491607] ---[ end trace 5e6c69cac2b687b2 ]---                                                                                                                                 
[  636.496459] Kernel panic - not syncing: Fatal exception in interrupt                                                                                                             
[  636.503112] CPU1: stopping                                                                                                                                                       
[  636.505981] [<c001b61c>] (unwind_backtrace+0x0/0xf0) from [<c0019728>] (handle_IPI+0x130/0x15c)                                                                                  
[  636.515136] [<c0019728>] (handle_IPI+0x130/0x15c) from [<c00084b8>] (gic_handle_irq+0x54/0x5c)                                                                                   
[  636.524169] [<c00084b8>] (gic_handle_irq+0x54/0x5c) from [<c04a31e4>] (__irq_svc+0x44/0x60)                                                                                      
[  636.532958] Exception stack(0xee069f88 to 0xee069fd0)                                                                                                                            
[  636.538269] 9f80:                   c0724f70 c0014f50 00000000 00000000 ee068000 c0744308                                                                                        
[  636.546844] 9fa0: c04ae350 c06d3d50 00000000 412fc09a c06d3f80 00000000 00000000 ee069fd0                                                                                        
[  636.555450] 9fc0: c0014f6c c0014f70 60000113 ffffffff                                                                                                                            
[  636.560760] [<c04a31e4>] (__irq_svc+0x44/0x60) from [<c0014f70>] (default_idle+0x20/0x44)                                                                                        
[  636.569366] [<c0014f70>] (default_idle+0x20/0x44) from [<c001519c>] (cpu_idle+0x9c/0x114)                                                                                        
[  636.577941] [<c001519c>] (cpu_idle+0x9c/0x114) from [<8049bdd4>] (0x8049bdd4)

--------------090301060502080703010307--

