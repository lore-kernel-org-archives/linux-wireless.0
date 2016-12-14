Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0069.outbound.protection.outlook.com ([104.47.38.69]:10752
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751008AbcLNHpy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 02:45:54 -0500
From: Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>
To: Bjorn Helgaas <helgaas@kernel.org>
CC: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "Janusz.Dziedzic@tieto.com" <Janusz.Dziedzic@tieto.com>,
        "rmanohar@qti.qualcomm.com" <rmanohar@qti.qualcomm.com>,
        "ath9k-devel@qca.qualcomm.com" <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: ATH9 driver issues on ARM64
Date: Wed, 14 Dec 2016 05:09:02 +0000
Message-ID: <8520D5D51A55D047800579B094147198263AADCA@XAP-PVEXMBX02.xlnx.xilinx.com> (sfid-20161214_085258_786574_1CC596E8)
References: <8520D5D51A55D047800579B094147198263A7222@XAP-PVEXMBX02.xlnx.xilinx.com>
 <20161208145608.GA19822@bhelgaas-glaptop.roam.corp.google.com>
 <8520D5D51A55D047800579B094147198263A72F5@XAP-PVEXMBX02.xlnx.xilinx.com>
 <874m2emif9.fsf@purkki.adurom.net>
 <8b348550-d909-cd98-4c04-dcf37b41f1ee@mni.thm.de>
 <8520D5D51A55D047800579B094147198263A8EF9@XAP-PVEXMBX02.xlnx.xilinx.com>
 <20161212163114.GA32712@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20161212163114.GA32712@bhelgaas-glaptop.roam.corp.google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Sat, Dec 10, 2016 at 02:40:48PM +0000, Bharat Kumar Gogada wrote:
> > Hi,
> >
> > After taking some more lecroy traces, we see that after 2nd ASSERT from=
 EP
> on ARM64 we see continuous data movement of 32 dwords or 12 dwords and
> never sign of DEASSERT.
> > Comparatively on working traces (x86) after 2nd assert there are only B=
AR
> register reads and writes and then DEASSERT, for almost most of the inter=
rupts
> and we haven't seen 12 or 32 dwords data movement on this trace.
> >
> > I did not work on EP wifi/network drivers, any help why EP needs those =
many
> number of data at scan time ?
>=20
> The device doesn't know whether it's in an x86 or an arm64 system.  If it=
 works
> differently, it must be because the PCI core or the driver is programming=
 the
> device differently.
>=20
> You should be able to match up Memory transactions from the host in the t=
race
> with things the driver does.  For example, if you see an Assert_INTx mess=
age
> from the device, you should eventually see a Memory Read from the host to=
 get
> the ISR, i.e., some read done in the bowels of ath9k_hw_getisr().
>=20
> I don't know how the ath9k device works, but there must be some Memory Re=
ad
> or Write done by the driver that tells the device "we've handled this int=
errupt".
> The device should then send a Deassert_INTx; of course, if the device sti=
ll
> requires service, e.g., because it has received more packets, it might le=
ave the
> INTx asserted.
>=20
> I doubt you'd see exactly the same traces on x86 and arm64 because they a=
ren't
> seeing the same network packets and the driver is executing at different =
rates.
> But you should at least be able to identify interrupt assertion and the a=
ctions of
> the driver's interrupt service routine.


Thanks Bjorn.

As you mentioned we did try to debug in that path. After we start scan afte=
r 2nd ASSERT we see lots of 32 and 12 dword
data, and in function
void ath9k_hw_enable_interrupts(struct ath_hw *ah)=20
{
	...
	..
	REG_WRITE(ah, AR_IER, AR_IER_ENABLE);
						// EP driver hangs at this position after 2nd ASSERT
						// The following writes are not happening
        if (!AR_SREV_9100(ah)) {		=09
                REG_WRITE(ah, AR_INTR_ASYNC_ENABLE, async_mask);
                REG_WRITE(ah, AR_INTR_ASYNC_MASK, async_mask);

                REG_WRITE(ah, AR_INTR_SYNC_ENABLE, sync_default);
                REG_WRITE(ah, AR_INTR_SYNC_MASK, sync_default);
        }  =20
        ath_dbg(common, INTERRUPT, "AR_IMR 0x%x IER 0x%x\n",
                REG_READ(ah, AR_IMR), REG_READ(ah, AR_IER));
}
The above funtion is invoked from tasklet.
I tried several boots every it stops here. The condition (!AR_SREV_9100(ah)=
) is true as per before 1st ASSERT handling.

Regards,
Bharat

>=20
> > > Hello there,
> > >
> > > as this is a thread about ath9k and ARM64, i'm not sure if i should
> > > answer here or not, but i have similar "stalls" with ath9k on x86_64
> > > (starting with 4.9rc), stack trace is posted down below where the ori=
ginal
> ARM64 stall traces are.
> > >
> > > Greetings,
> > >
> > > Tobias
> > >
> > >
> > > On 08.12.2016 18:36, Kalle Valo wrote:
> > > > Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com> writes:
> > > >
> > > >>   > [+cc Kalle, ath9k list]
> > > > Thanks, but please also CC linux-wireless. Full thread below for
> > > > the folks there.
> > > >
> > > >>> On Thu, Dec 08, 2016 at 01:49:42PM +0000, Bharat Kumar Gogada
> wrote:
> > > >>>> Hi,
> > > >>>>
> > > >>>> Did anyone test Atheros ATH9
> > > >>>> driver(drivers/net/wireless/ath/ath9k/)
> > > >>>> on ARM64.  The end point is TP link wifi card with which
> > > >>>> supports only legacy interrupts.
> > > >>> If it works on other arches and the arm64 PCI enumeration works,
> > > >>> my first guess would be an INTx issue, e.g., maybe the driver is
> > > >>> waiting for an interrupt that never arrives.
> > > >> We are not sure for now.
> > > >>>> We are trying to test it on ARM64 with
> > > >>>> (drivers/pci/host/pcie-xilinx-nwl.c) as root port.
> > > >>>>
> > > >>>> EP is getting enumerated and able to link up.
> > > >>>>
> > > >>>> But when we start scan system gets hanged.
> > > >>> When you say the system hangs when you start a scan, I assume
> > > >>> you mean a wifi scan, not the PCI enumeration.  A problem with a
> > > >>> wifi scan might cause a *process* to hang, but it shouldn't hang
> > > >>> the entire system.
> > > >>>
> > > >> Yes wifi scan.
> > > >>>> When we took trace we see that after we start scan assert
> > > >>>> message is sent but there is no de assert from end point.
> > > >>> Are you talking about a trace from a PCIe analyzer?  Do you see
> > > >>> an Assert_INTx PCIe message on the link?
> > > >>>
> > > >> Yes lecroy trace, yes we do see Assert_INTx and Deassert_INTx
> > > >> happening
> > > when we do interface link up.
> > > >> When we have less debug prints in Atheros driver, and do wifi
> > > >> scan we see Assert_INTx but never Deassert_INTx,
> > > >>>> What might cause end point not sending de assert ?
> > > >>> If the endpoint doesn't send a Deassert_INTx message, I expect
> > > >>> that would mean the driver didn't service the interrupt and
> > > >>> remove the condition that caused the device to assert the
> > > >>> interrupt in the first place.
> > > >>>
> > > >>> If the driver didn't receive the interrupt, it couldn't service
> > > >>> it, of course.  You could add a printk in the ath9k interrupt
> > > >>> service routine to see if you ever get there.
> > > >>>
> > > >> The interrupt behavior is changing w.r.t amount of debug prints
> > > >> we add. (I kept many prints to aid debug)
> > > >> root@Xilinx-ZCU102-2016_3:~# iw dev
> > > wlan0 scan
> > > >> [   83.064675] ath9k: ath9k_iowrite32 ffffff800a400024
> > > >> [   83.069486] ath9k: ath9k_ioread32 ffffff800a400024
> > > >> [   83.074257] ath9k_hw_kill_interrupts	 793
> > > >> [   83.078260] ath9k: ath9k_iowrite32 ffffff800a400024
> > > >> [   83.083107] ath9k: ath9k_ioread32 ffffff800a400024
> > > >> [   83.087882] ath9k_hw_kill_interrupts	 793
> > > >> [   83.095450] ath9k_hw_enable_interrupts	 821
> > > >> [   83.099557] ath9k_hw_enable_interrupts	 825
> > > >> [   83.103721] ath9k_hw_enable_interrupts	 832
> > > >> [   83.107887] ath9k: ath9k_iowrite32 ffffff800a400024
> > > >> [   83.112748] AR_SREV_9100 0
> > > >> [   83.115438] ath9k_hw_enable_interrupts	 848
> > > >> [   83.119607] ath9k: ath9k_ioread32 ffffff800a400024
> > > >> [   83.124389] ath9k_hw_intrpend	 762
> > > >> [   83.127761] (AR_SREV_9340(ah) val 0
> > > >> [   83.131234] ath9k_hw_intrpend	 767
> > > >> [   83.134628] ath_isr	 603
> > > >> [   83.137134] ath9k: ath9k_iowrite32 ffffff800a400024
> > > >> [   83.141995] ath9k: ath9k_ioread32 ffffff800a400024
> > > >> [   83.146771] ath9k_hw_kill_interrupts	 793
> > > >> [   83.150864] ath9k_hw_enable_interrupts	 821
> > > >> [   83.154971] ath9k_hw_enable_interrupts	 825
> > > >> [   83.159135] ath9k_hw_enable_interrupts	 832
> > > >> [   83.163300] ath9k: ath9k_iowrite32 ffffff800a400024
> > > >> [   83.168161] AR_SREV_9100 0
> > > >> [   83.170852] ath9k_hw_enable_interrupts	 848
> > > >> [   83.170855] ath9k_hw_intrpend	 762
> > > >> [   83.178398] (AR_SREV_9340(ah) val 0
> > > >> [   83.181873] ath9k_hw_intrpend	 767
> > > >> [   83.185265] ath_isr	 603
> > > >> [   83.187773] ath9k: ath9k_iowrite32 ffffff800a400024
> > > >> [   83.192635] ath9k: ath9k_ioread32 ffffff800a400024
> > > >> [   83.197411] ath9k_hw_kill_interrupts	 793
> > > >> [   83.201414] ath9k: ath9k_ioread32 ffffff800a400024
> > > >> [   83.206258] ath9k_hw_enable_interrupts	 821
> > > >> [   83.210368] ath9k_hw_enable_interrupts	 825
> > > >> [   83.214531] ath9k_hw_enable_interrupts	 832
> > > >> [   83.218698] ath9k: ath9k_iowrite32 ffffff800a400024
> > > >> [   83.223558] AR_SREV_9100 0
> > > >> [   83.226243] ath9k_hw_enable_interrupts	 848
> > > >> [   83.226246] ath9k_hw_intrpend	 762
> > > >> [   83.233794] (AR_SREV_9340(ah) val 0
> > > >> [   83.237268] ath9k_hw_intrpend	 767
> > > >> [   83.240661] ath_isr	 603
> > > >> [   83.243169] ath9k: ath9k_iowrite32 ffffff800a400024
> > > >> [   83.248030] ath9k: ath9k_ioread32 ffffff800a400024
> > > >> [   83.252806] ath9k_hw_kill_interrupts	 793
> > > >> [   83.256811] ath9k: ath9k_ioread32 ffffff800a400024
> > > >> [   83.261651] ath9k_hw_enable_interrupts	 821
> > > >> [   83.265753] ath9k_hw_enable_interrupts	 825
> > > >> [   83.269919] ath9k_hw_enable_interrupts	 832
> > > >> [   83.274083] ath9k: ath9k_iowrite32 ffffff800a400024
> > > >> [   83.278945] AR_SREV_9100 0
> > > >> [   83.281630] ath9k_hw_enable_interrupts	 848
> > > >> [   83.281633] ath9k_hw_intrpend	 762
> > > >> [   83.281634] (AR_SREV_9340(ah) val 0
> > > >> [   83.281637] ath9k_hw_intrpend	 767
> > > >> [   83.281648] ath_isr	 603
> > > >> [   83.281649] ath9k: ath9k_iowrite32 ffffff800a400024
> > > >> [   83.281651] ath9k: ath9k_ioread32 ffffff800a400024
> > > >> [   83.281654] ath9k_hw_kill_interrupts	 793
> > > >> [   83.312192] ath9k: ath9k_ioread32 ffffff800a400024
> > > >> [   83.317030] ath9k_hw_enable_interrupts	 821
> > > >> [   83.321132] ath9k_hw_enable_interrupts	 825
> > > >> [   83.325297] ath9k_hw_enable_interrupts	 832
> > > >> [   83.329463] ath9k: ath9k_iowrite32 ffffff800a400024
> > > >> [   83.334324] AR_SREV_9100 0
> > > >> [   83.337014] ath9k_hw_enable_interrupts	 848
> > > >> ..
> > > >> ..
> > > >> This log continues until I turn off board without obtaining scanni=
ng result.
> > > >>
> > > >> In between I get following cpu stall outputs :
> > > >>    230.457179] INFO: rcu_sched self-detected stall on CPU
> > > >> [  230.457185] 	2-...: (31314 ticks this GP)
> > > idle=3D2d1/140000000000001/0 softirq=3D1400/1400 fqs=3D36713
> > > >> [  230.457189] 	 (t=3D36756 jiffies g=3D161 c=3D160 q=3D16169)
> > > >> [  230.457191] Task dump for CPU 2:
> > > >> [  230.457196] kworker/u8:4    R  running task        0  1342     =
 2
> 0x00000002
> > > >> [  230.457207] Workqueue: phy0 ieee80211_scan_work [  230.457208]
> > > >> Call trace:
> > > >> [  230.457214] [<ffffff8008089860>] dump_backtrace+0x0/0x198 [
> > > >> 230.457219] [<ffffff8008089a0c>] show_stack+0x14/0x20 [
> > > >> 230.457224] [<ffffff80080c0930>] sched_show_task+0x98/0xf8 [
> > > >> 230.457228] [<ffffff80080c2628>] dump_cpu_task+0x40/0x50 [
> > > >> 230.457233] [<ffffff80080e14a8>] rcu_dump_cpu_stacks+0xa0/0xf0 [
> > > >> 230.457239] [<ffffff80080e4cd8>] rcu_check_callbacks+0x468/0x748
> > > >> [  230.457243] [<ffffff80080e7cfc>]
> > > >> update_process_times+0x3c/0x68 [  230.457249]
> > > >> [<ffffff80080f6dfc>] tick_sched_handle.isra.5+0x3c/0x50
> > > >> [  230.457253] [<ffffff80080f6e54>] tick_sched_timer+0x44/0x90 [
> > > >> 230.457257] [<ffffff80080e86b0>] __hrtimer_run_queues+0xf0/0x178
> > > >> ** 10 printk messages dropped ** [  230.457302] f8c0:
> > > >> 0000000000000000 0000000005f5e0ff 000000000001379a
> > > 3866666666666620 [
> > > >> 230.457306] f8e0: ffffff800a1b4065 0000000000000006
> > > >> ffffff800a129000
> > > >> ffffffc87b8010a8 [  230.457310] f900: ffffff808a1b4057
> > > >> ffffff800a1c3000 ffffff800a1b3000 ffffff800a13b000 [  230.457314]
> > > >> f920: 0000000000000140 0000000000000006 ffffff800a1b3b10
> > > >> ffffff800a1c39e8 [  230.457318] f940: 000000000000002f
> > > >> ffffff800a1b8a98 ffffff800a1b3ae8 ffffffc87b07f990 [  230.457322]
> > > >> f960: ffffff80080d6230 ffffffc87b07f990 ffffff80080d6234
> > > >> 0000000060000145
> > > >> ** 1 printk messages dropped ** [  230.457329]
> > > >> [<ffffff8008085720>]
> > > >> el1_irq+0xa0/0x100
> > > >> ** 9 printk messages dropped ** [  230.457373]
> > > >> [<ffffff800885ad60>]
> > > >> ieee80211_hw_config+0x50/0x290 [  230.457377]
> > > >> [<ffffff8008863690>]
> > > >> ieee80211_scan_work+0x1f8/0x480 [  230.457383]
> > > >> [<ffffff80080b15d0>]
> > > >> process_one_work+0x120/0x378 [  230.457386] [<ffffff80080b1870>]
> > > >> worker_thread+0x48/0x4b0 [  230.457391] [<ffffff80080b7108>]
> > > >> kthread+0xd0/0xe8 [  230.457395] [<ffffff8008085dd0>]
> > > ret_from_fork+0x10/0x40
> > > >> [  230.480389] ath9k_hw_intrpend	 762
> > > >>
> > > >>
> > > >> [  545.487987] ath9k: ath9k_ioread32 ffffff800a400024 [
> > > >> 545.526189]
> > > >> INFO: rcu_sched self-detected stall on CPU
> > > >> [  545.526195] 	2-...: (97636 ticks this GP)
> > > idle=3D2d1/140000000000001/0 softirq=3D1400/1400 fqs=3D115374
> > > >> [  545.526199] 	 (t=3D115523 jiffies g=3D161 c=3D160 q=3D51066)
> > > >> [  545.526201] Task dump for CPU 2:
> > > >> [  545.526206] kworker/u8:4    R  running task        0  1342     =
 2
> 0x00000002
> > > >> ** 3 printk messages dropped ** [  545.526231]
> > > >> [<ffffff8008089a0c>]
> > > >> show_stack+0x14/0x20
> > > >> ** 9 printk messages dropped ** [  545.526280]
> > > >> [<ffffff80086a71e8>]
> > > >> arch_timer_handler_phys+0x30/0x40 [  545.526284]
> > > >> [<ffffff80080dbe18>]
> > > >> handle_percpu_devid_irq+0x78/0xa0 [  545.526291]
> > > >> [<ffffff80080d760c>]
> > > >> generic_handle_irq+0x24/0x38 [  545.526296] [<ffffff80080d7944>]
> > > >> __handle_domain_irq+0x5c/0xb8 [  545.526299] [<ffffff80080824bc>]
> > > >> gic_handle_irq+0x64/0xc0 [  545.526302] Exception
> > > >> stack(0xffffffc87b07f870
> > > to 0xffffffc87b07f990)
> > > >> [  545.526306] f860:                                   00000000000=
09732
> ffffff800a1eaaa8
> > > >> ** 8 printk messages dropped ** [  545.526341] f980:
> > > >> ffffff800a1c39e8
> > > >> 0000000000000036 [  545.526345] [<ffffff8008085720>]
> > > >> el1_irq+0xa0/0x100 [  545.526349] [<ffffff80080d6234>]
> > > >> console_unlock+0x384/0x5b0 [  545.526353] [<ffffff80080d673c>]
> > > >> vprintk_emit+0x2dc/0x4b0 [  545.526357] [<ffffff80080d6a50>]
> > > >> vprintk_default+0x38/0x40 [  545.526362] [<ffffff8008129704>]
> > > >> printk+0x58/0x60 [  545.526366] [<ffffff800859e3e4>]
> > > >> ath9k_iowrite32+0x9c/0xa8 [  545.526372] [<ffffff80085c7ca8>]
> > > >> ath9k_hw_kill_interrupts+0x28/0xf0
> > > >> [  545.526376] [<ffffff80085a18ec>] ath_reset+0x24/0x68
> > > >> ** 2 printk messages dropped ** [  545.526391]
> > > >> [<ffffff800885ad60>]
> > > ieee80211_hw_config+0x50/0x290
> > > >> ** 11 printk messages dropped ** [  545.532834]
> > > >> ath9k_hw_kill_interrupts
> > > 	 793
> > > >> [  545.532890] ath9k_hw_enable_interrupts	 821
> > >
> > > [   81.876902] INFO: rcu_preempt detected stalls on CPUs/tasks:
> > > [   81.876912]     Tasks blocked on level-0 rcu_node (CPUs 0-7): P0
> > > [   81.876932]     (detected by 4, t=3D60002 jiffies, g=3D1873, c=3D1=
872, q=3D4967)
> > > [   81.876936] swapper/4       R  running task        0     0      1
> > > 0x00000000
> > > [   81.876941]  0000000000000001 ffffffff810725f6 ffff88017edbc240
> > > ffffffff81a3dc40
> > > [   81.876945]  ffffffff81101e46 ffff88025ef173c0 ffffffff81a3dc40
> > > ffffffff81a3dc40
> > > [   81.876948]  00000000ffffffff ffffffff810a7333 ffff88017ecee698
> > > ffff88017edbc240
> > > [   81.876951] Call Trace:
> > > [   81.876970]  <IRQ>
> > > [   81.876979]  [<ffffffff810725f6>] ? sched_show_task+0xd6/0x140
> > > [   81.876983]  [<ffffffff81101e46>] ?
> > > rcu_print_detail_task_stall_rnp+0x40/0x61
> > > [   81.876989]  [<ffffffff810a7333>] ? rcu_check_callbacks+0x6b3/0x8c=
0
> > > [   81.876993]  [<ffffffff810b8350>] ? tick_sched_handle.isra.14+0x40=
/0x40
> > > [   81.876996]  [<ffffffff810aa4c3>] ? update_process_times+0x23/0x50
> > > [   81.876999]  [<ffffffff810b8383>] ? tick_sched_timer+0x33/0x60
> > > [   81.877002]  [<ffffffff810aaf09>] ? __hrtimer_run_queues+0xb9/0x15=
0
> > > [   81.877004]  [<ffffffff810ab198>] ? hrtimer_interrupt+0x98/0x1a0
> > > [   81.877008]  [<ffffffff81031b1e>] ?
> > > smp_trace_apic_timer_interrupt+0x5e/0x90
> > > [   81.877012]  [<ffffffff815b31bf>] ? apic_timer_interrupt+0x7f/0x90
> > > [   81.877013]  <EOI>
> > > [   81.877017]  [<ffffffff8147f28d>] ? cpuidle_enter_state+0x13d/0x1f=
0
> > > [   81.877019]  [<ffffffff8147f289>] ? cpuidle_enter_state+0x139/0x1f=
0
> > > [   81.877021]  [<ffffffff81088c19>] ? cpu_startup_entry+0x139/0x210
> > > [   81.877027]  [<ffffffff8102fc9e>] ? start_secondary+0x13e/0x170
> > > [   81.877029] swapper/4       R  running task        0     0      1
> > > 0x00000000
> > > [   81.877032]  0000000000000001 ffffffff810725f6 ffff88017edbc240
> > > ffffffff81a3dc40
> > > [   81.877035]  ffffffff81101e46 ffff88025ef173c0 ffffffff81a3dc40
> > > ffffffff81a3dc40
> > > [   81.877038]  00000000ffffffff ffffffff810a7368 ffff88017ecee698
> > > ffff88017edbc240
> > > [   81.877041] Call Trace:
> > > [   81.877045]  <IRQ>
> > > [   81.877049]  [<ffffffff810725f6>] ? sched_show_task+0xd6/0x140
> > > [   81.877051]  [<ffffffff81101e46>] ?
> > > rcu_print_detail_task_stall_rnp+0x40/0x61
> > > [   81.877055]  [<ffffffff810a7368>] ? rcu_check_callbacks+0x6e8/0x8c=
0
> > > [   81.877058]  [<ffffffff810b8350>] ? tick_sched_handle.isra.14+0x40=
/0x40
> > > [   81.877060]  [<ffffffff810aa4c3>] ? update_process_times+0x23/0x50
> > > [   81.877063]  [<ffffffff810b8383>] ? tick_sched_timer+0x33/0x60
> > > [   81.877065]  [<ffffffff810aaf09>] ? __hrtimer_run_queues+0xb9/0x15=
0
> > > [   81.877068]  [<ffffffff810ab198>] ? hrtimer_interrupt+0x98/0x1a0
> > > [   81.877070]  [<ffffffff81031b1e>] ?
> > > smp_trace_apic_timer_interrupt+0x5e/0x90
> > > [   81.877073]  [<ffffffff815b31bf>] ? apic_timer_interrupt+0x7f/0x90
> > > [   81.877074]  <EOI>
> > > [   81.877076]  [<ffffffff8147f28d>] ? cpuidle_enter_state+0x13d/0x1f=
0
> > > [   81.877078]  [<ffffffff8147f289>] ? cpuidle_enter_state+0x139/0x1f=
0
> > > [   81.877080]  [<ffffffff81088c19>] ? cpu_startup_entry+0x139/0x210
> > > [   81.877084]  [<ffffffff8102fc9e>] ? start_secondary+0x13e/0x170
> > > [   91.132787] INFO: rcu_preempt detected expedited stalls on
> > > CPUs/tasks: { P0 } 63785 jiffies s: 505 root: 0x0/T
> > > [   91.132796] blocking rcu_node structures:
> > >
> > > >>
> > > >>
> > > >> But if we have less debug prints it does not reach EP handler
> > > >> sometimes, due to following Condition in "kernel/irq/chip.c" in
> > > >> function handle_simple_irq
> > > >>
> > > >> if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data)))=
 {
> > > >>                  desc->istate |=3D IRQS_PENDING;
> > > >>                  goto out_unlock;
> > > >>          }
> > > >> Here irqd_irq_disabled is being set to 1.
> > > >>
> > > >> With lesser debug prints it stops after following prints:
> > > >> root@Xilinx-ZCU102-2016_3:~# iw dev wlan0 scan
> > > >> [   54.781045] ath9k_hw_kill_interrupts	 793
> > > >> [   54.785007] ath9k_hw_kill_interrupts	 793
> > > >> [   54.792535] ath9k_hw_enable_interrupts	 821
> > > >> [   54.796642] ath9k_hw_enable_interrupts	 825
> > > >> [   54.800807] ath9k_hw_enable_interrupts	 832
> > > >> [   54.804973] AR_SREV_9100 0
> > > >> [   54.807663] ath9k_hw_enable_interrupts	 848
> > > >> [   54.811843] ath9k_hw_intrpend	 762
> > > >> [   54.815211] (AR_SREV_9340(ah) val 0
> > > >> [   54.818684] ath9k_hw_intrpend	 767
> > > >> [   54.822078] ath_isr	 603
> > > >> [   54.824587] ath9k_hw_kill_interrupts	 793
> > > >> [   54.828601] ath9k_hw_enable_interrupts	 821
> > > >> [   54.832750] ath9k_hw_enable_interrupts	 825
> > > >> [   54.836916] ath9k_hw_enable_interrupts	 832
> > > >> [   54.841082] AR_SREV_9100 0
> > > >> [   54.843772] ath9k_hw_enable_interrupts	 848
> > > >> [   54.843775] ath9k_hw_intrpend	 762
> > > >> [   54.851319] (AR_SREV_9340(ah) val 0
> > > >> [   54.854793] ath9k_hw_intrpend	 767
> > > >> [   54.858185] ath_isr	 603
> > > >> [   54.860696] ath9k_hw_kill_interrupts	 793
> > > >> [   54.864776] ath9k_hw_enable_interrupts	 821
> > > >> [   54.867061] ath9k_hw_kill_interrupts	 793
> > > >> [   54.872870] ath9k_hw_enable_interrupts	 825
> > > >> [   54.877036] ath9k_hw_enable_interrupts	 832
> > > >> [   54.881202] AR_SREV_9100 0
> > > >> [   54.883892] ath9k_hw_enable_interrupts	 848
> > > >> [   75.963129] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > >> [   75.968602] 	0-...: (2 GPs behind) idle=3D9d5/140000000000001/0
> > > softirq=3D1103/1109 fqs=3D519
> > > >> [   75.976675] 	(detected by 2, t=3D5274 jiffies, g=3D64, c=3D63, =
q=3D11)
> > > >> [   75.982485] Task dump for CPU 0:
> > > >> [   75.985696] ksoftirqd/0     R  running task        0     3     =
 2 0x00000002
> > > >> [   75.992726] Call trace:
> > > >> [   75.995165] [<ffffff8008086b3c>] __switch_to+0xc4/0xd0
> > > >> [   76.000281] [<ffffffc87b830500>] 0xffffffc87b830500
> > > >> [  139.059027] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > >> [  139.064430] 	0-...: (2 GPs behind) idle=3D9d5/140000000000001/0
> > > softirq=3D1103/1109 fqs=3D2097
> > > >> [  139.072593] 	(detected by 2, t=3D21049 jiffies, g=3D64, c=3D63,=
 q=3D11)
> > > >> [  139.078489] Task dump for CPU 0:
> > > >> [  139.081700] ksoftirqd/0     R  running task        0     3     =
 2 0x00000002
> > > >> [  139.088731] Call trace:
> > > >> [  139.091165] [<ffffff8008086b3c>] __switch_to+0xc4/0xd0 [
> > > >> 139.096285] [<ffffffc87b830500>] 0xffffffc87b830500
> > > >>
> > > >>
> > > >>>> We are not seeing any issues on 32-bit ARM platform and X86
> > > >>>> platform.
> > > >>> Can you collect a dmesg log (or, if the system hang means you
> > > >>> can't collect that, a console log with "ignore_loglevel"), and "l=
spci -vv"
> > > >>> output as root?  That should have clues about whether the INTx
> > > >>> got routed correctly.  /proc/interrupts should also show whether
> > > >>> we're receiving interrupts from the device.
> > > >> Here is the lspci output:
> > > >> 00:00.0 PCI bridge: Xilinx Corporation Device d022 (prog-if 00
> > > >> [Normal
> > > decode])
> > > >> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> > > ParErr- Stepping- SERR- FastB2B- DisINTx-
> > > >> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
> > > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > > >> 	Latency: 0
> > > >> 	Interrupt: pin A routed to IRQ 224
> > > >> 	Bus: primary=3D00, secondary=3D01, subordinate=3D0c, sec-latency=
=3D0
> > > >> 	I/O behind bridge: 00000000-00000fff
> > > >> 	Memory behind bridge: e0000000-e00fffff
> > > >> 	Prefetchable memory behind bridge: 00000000fff00000-
> > > 00000000000fffff
> > > >> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
> > > <TAbort- <MAbort- <SERR- <PERR-
> > > >> 	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> > > >> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> > > >> 	Capabilities: [40] Power Management version 3
> > > >> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
> > > PME(D0+,D1+,D2+,D3hot+,D3cold-)
> > > >> 		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-
> > > >> 	Capabilities: [60] Express (v2) Root Port (Slot-), MSI 00
> > > >> 		DevCap:	MaxPayload 256 bytes, PhantFunc 0
> > > >> 			ExtTag- RBE+
> > > >> 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
> > > Unsupported-
> > > >> 			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> > > >> 			MaxPayload 128 bytes, MaxReadReq 512 bytes
> > > >> 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
> > > TransPend+
> > > >> 		LnkCap:	Port #0, Speed 5GT/s, Width x2, ASPM not supported,
> > > Exit Latency L0s unlimited, L1 unlimited
> > > >> 			ClockPM- Surprise- LLActRep- BwNot+ ASPMOptComp+
> > > >> 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk-
> > > >> 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> > > >> 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
> > > DLActive- BWMgmt- ABWMgmt-
> > > >> 		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
> > > CRSVisible+
> > > >> 		RootCap: CRSVisible+
> > > >> 		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> > > >> 		DevCap2: Completion Timeout: Range B, TimeoutDis+, LTR-,
> > > OBFF Not Supported ARIFwd-
> > > >> 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
> > > OBFF Disabled ARIFwd-
> > > >> 		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
> > > >> 			 Transmit Margin: Normal Operating Range,
> > > EnterModifiedCompliance- ComplianceSOS-
> > > >> 			 Compliance De-emphasis: -6dB
> > > >> 		LnkSta2: Current De-emphasis Level: -3.5dB,
> > > EqualizationComplete-, EqualizationPhase1-
> > > >> 			 EqualizationPhase2-, EqualizationPhase3-,
> > > LinkEqualizationRequest-
> > > >> 	Capabilities: [100 v1] Device Serial Number 00-00-00-00-00-00-00-=
00
> > > >> 	Capabilities: [10c v1] Virtual Channel
> > > >> 		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
> > > >> 		Arb:	Fixed- WRR32- WRR64- WRR128-
> > > >> 		Ctrl:	ArbSelect=3DFixed
> > > >> 		Status:	InProgress-
> > > >> 		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
> > > >> 			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128-
> > > WRR256-
> > > >> 			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3Dff
> > > >> 			Status:	NegoPending- InProgress-
> > > >> 	Capabilities: [128 v1] Vendor Specific Information: ID=3D1234
> > > >> Rev=3D1
> > > >> Len=3D018 <?>
> > > >>
> > > >> 01:00.0 Network controller: Qualcomm Atheros AR93xx Wireless
> > > >> Network
> > > Adapter (rev 01)
> > > >> 	Subsystem: Qualcomm Atheros Device 3112
> > > >> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> > > ParErr- Stepping- SERR- FastB2B- DisINTx-
> > > >> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
> > > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > > >> 	Latency: 0, Cache Line Size: 128 bytes
> > > >> 	Interrupt: pin A routed to IRQ 224
> > > >> 	Region 0: Memory at e0000000 (64-bit, non-prefetchable) [size=3D1=
28K]
> > > >> 	[virtual] Expansion ROM at e0020000 [disabled] [size=3D64K]
> > > >> 	Capabilities: [40] Power Management version 3
> > > >> 		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=3D375mA
> > > PME(D0+,D1+,D2-,D3hot+,D3cold-)
> > > >> 		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
> > > >> 	Capabilities: [50] MSI: Enable- Count=3D1/4 Maskable+ 64bit+
> > > >> 		Address: 0000000000000000  Data: 0000
> > > >> 		Masking: 00000000  Pending: 00000000
> > > >> 	Capabilities: [70] Express (v2) Endpoint, MSI 00
> > > >> 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency
> > > L0s <1us, L1 <8us
> > > >> 			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> > > SlotPowerLimit 0.000W
> > > >> 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
> > > Unsupported-
> > > >> 			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
> > > >> 			MaxPayload 128 bytes, MaxReadReq 512 bytes
> > > >> 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
> > > TransPend-
> > > >> 		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit
> > > Latency L0s <2us, L1 <64us
> > > >> 			ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
> > > >> 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk-
> > > >> 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> > > >> 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
> > > DLActive- BWMgmt- ABWMgmt-
> > > >> 		DevCap2: Completion Timeout: Not Supported, TimeoutDis+,
> > > LTR-, OBFF Not Supported
> > > >> 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
> > > OBFF Disabled
> > > >> 		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> > > SpeedDis-
> > > >> 			 Transmit Margin: Normal Operating Range,
> > > EnterModifiedCompliance- ComplianceSOS-
> > > >> 			 Compliance De-emphasis: -6dB
> > > >> 		LnkSta2: Current De-emphasis Level: -6dB,
> > > EqualizationComplete-, EqualizationPhase1-
> > > >> 			 EqualizationPhase2-, EqualizationPhase3-,
> > > LinkEqualizationRequest-
> > > >> 	Capabilities: [100 v1] Advanced Error Reporting
> > > >> 		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> > > RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> > > >> 		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> > > RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> > > >> 		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
> > > RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
> > > >> 		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> > > NonFatalErr-
> > > >> 		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> > > NonFatalErr+
> > > >> 		AERCap:	First Error Pointer: 00, GenCap- CGenEn-
> > > ChkCap- ChkEn-
> > > >> 	Capabilities: [140 v1] Virtual Channel
> > > >> 		Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
> > > >> 		Arb:	Fixed- WRR32- WRR64- WRR128-
> > > >> 		Ctrl:	ArbSelect=3DFixed
> > > >> 		Status:	InProgress-
> > > >> 		VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
> > > >> 			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128-
> > > WRR256-
> > > >> 			Ctrl:	Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3Dff
> > > >> 			Status:	NegoPending- InProgress-
> > > >> 	Capabilities: [300 v1] Device Serial Number 00-00-00-00-00-00-00-=
00
> > > >> 	Kernel driver in use: ath9k
> > > >>
> > > >> Here is the cat /proc/interrupts (after we do interface up):
> > > >>
> > > >> root@:~# ifconfig wlan0 up
> > > >> [ 1548.926601] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not
> > > >> ready root@Xilinx-ZCU102-2016_3:~# cat /proc/interrupts
> > > >>             CPU0       CPU1       CPU2       CPU3
> > > >>    1:          0          0          0          0     GICv2  29 Ed=
ge      arch_timer
> > > >>    2:      19873      20058      19089      17435     GICv2  30 Ed=
ge      arch_timer
> > > >>   12:          0          0          0          0     GICv2 156 Le=
vel     zynqmp-dma
> > > >>   13:          0          0          0          0     GICv2 157 Le=
vel     zynqmp-dma
> > > >>   14:          0          0          0          0     GICv2 158 Le=
vel     zynqmp-dma
> > > >>   15:          0          0          0          0     GICv2 159 Le=
vel     zynqmp-dma
> > > >>   16:          0          0          0          0     GICv2 160 Le=
vel     zynqmp-dma
> > > >>   17:          0          0          0          0     GICv2 161 Le=
vel     zynqmp-dma
> > > >>   18:          0          0          0          0     GICv2 162 Le=
vel     zynqmp-dma
> > > >>   19:          0          0          0          0     GICv2 163 Le=
vel     zynqmp-dma
> > > >>   20:          0          0          0          0     GICv2 164 Le=
vel     Mali_GP_MMU,
> > > Mali_GP, Mali_PP0_MMU, Mali_PP0, Mali_PP1_MMU, Mali_PP1
> > > >>   30:          0          0          0          0     GICv2  95 Le=
vel     eth0, eth0
> > > >> 206:        314          0          0          0     GICv2  49 Lev=
el     cdns-i2c
> > > >> 207:         40          0          0          0     GICv2  50 Lev=
el     cdns-i2c
> > > >> 209:          0          0          0          0     GICv2 150 Lev=
el     nwl_pcie:misc
> > > >> 214:         12          0          0          0     GICv2  47 Lev=
el     ff0f0000.spi
> > > >> 215:          0          0          0          0     GICv2  58 Lev=
el     ffa60000.rtc
> > > >> 216:          0          0          0          0     GICv2  59 Lev=
el     ffa60000.rtc
> > > >> 217:          0          0          0          0     GICv2 165 Lev=
el     ahci-
> > > ceva[fd0c0000.ahci]
> > > >> 218:         61          0          0          0     GICv2  81 Lev=
el     mmc0
> > > >> 219:          0          0          0          0     GICv2 187 Lev=
el     arm-smmu global
> fault
> > > >> 220:        471          0          0          0     GICv2  53 Lev=
el     xuartps
> > > >> 223:          0          0          0          0     GICv2 154 Lev=
el     fd4c0000.dma
> > > >> 224:          3          0          0          0     dummy   1 Edg=
e      ath9k
> > > >> 225:          0          0          0          0     GICv2  97 Lev=
el     xhci-hcd:usb1
> > > >>
> > > >> Regards,
> > > >> Bharat
> >
