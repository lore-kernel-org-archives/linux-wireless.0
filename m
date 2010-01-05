Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62188 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754700Ab0AEWQm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 17:16:42 -0500
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>,
	"Zhu, Yi" <yi.zhu@intel.com>
CC: "Chatre, Reinette" <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
Date: Tue, 5 Jan 2010 14:16:16 -0800
Subject: RE: [ipw3945-devel] Panic in iwl3945 driver
Message-ID: <02B3067C068D0549A8CCFCB17D4D318B5D15133C@orsmsx502.amr.corp.intel.com>
References: <1259167780.4072.2.camel@maxim-laptop>
	<1259280022.3991.12.camel@maxim-laptop>
	<1259596551.4090.0.camel@maxim-laptop>	<1259617333.4653.91.camel@rc-desk>
	<1259620526.6559.34.camel@maxim-laptop>	<1259659724.12157.110.camel@debian>
	<1259732550.12157.130.camel@debian>	<1259774227.26287.2.camel@maxim-laptop>
	<1261413654.3556.6.camel@maxim-laptop>	<1261472251.12157.829.camel@debian>
 <1262710566.3272.3.camel@maxim-laptop>
In-Reply-To: <1262710566.3272.3.camel@maxim-laptop>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

uCode is receiving bad command from command queue ... See below (search "Bad").

-- Ben --

>-----Original Message-----
>From: Maxim Levitsky [mailto:maximlevitsky@gmail.com]
>Sent: Tuesday, January 05, 2010 11:56 AM
>To: Zhu, Yi
>Cc: Chatre, Reinette; linux-wireless; iwlwifi maling list
>Subject: Re: [ipw3945-devel] Panic in iwl3945 driver
>
>On Tue, 2009-12-22 at 16:57 +0800, Zhu Yi wrote:
>> On Tue, 2009-12-22 at 00:40 +0800, Maxim Levitsky wrote:
>> > On Wed, 2009-12-02 at 19:17 +0200, Maxim Levitsky wrote:
>> > > On Wed, 2009-12-02 at 13:42 +0800, Zhu Yi wrote:
>> > > > On Tue, 2009-12-01 at 17:28 +0800, Zhu Yi wrote:
>> > > > > On Tue, 2009-12-01 at 06:35 +0800, Maxim Levitsky wrote:
>> > > > > > 0x000000000001668e <iwl3945_rx_reply_tx+302>:
>lea    0x38(%r8),%rdi
>> > > > > > 0x0000000000016692 <iwl3945_rx_reply_tx+306>:
>lea    0x4f(%r8),%rax
>> > > > >
>> > > > > When this happened, from your previous post, r8 is
>0x0 and rdi is 0x38.
>> > > > > Since "info" is %rdi (see below), this means
>> > > > > txq->txb[txq->q.read_ptr].skb[0], aka. r8 is 0.
>> > > > >
>> > > > > >    rate_idx = iwl3945_hwrate_to_plcp_idx(tx_resp->rate);
>> > > > > >
>> > > > > > 0x0000000000016696 <iwl3945_rx_reply_tx+310>:
>movb   $0x0,0x9(%rdi)        <---------- RIP
>> > > > > > 0x000000000001669a <iwl3945_rx_reply_tx+314>:
>movb   $0x0,0xc(%rdi)
>> > > > > > 0x000000000001669e <iwl3945_rx_reply_tx+318>:
>movb   $0x0,0xf(%rdi)
>> > > > > > 0x00000000000166a2 <iwl3945_rx_reply_tx+322>:
>movb   $0x0,0x12(%rdi)
>> > > > > > 0x00000000000166a6 <iwl3945_rx_reply_tx+326>:
>movb   $0x0,0x15(%rdi)
>> > > > >
>> > > > > This equals to below code in
>ieee80211_tx_info_clear_status(). "info" is
>> > > > > %rdi, which is 0x38. That matches NULL pointer
>dereference at 0x41 in
>> > > > > your oops header.
>> > > > >
>> > > > >      for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
>> > > > >                 info->status.rates[i].count = 0;
>> > > > >
>> > > > > I guess there is a race for txq->q.read_ptr
>somewhere. Haven't checked
>> > > > > though.
>> > > >
>> > > > OK. 3945 updated write_ptr without regard to read_ptr
>on the Tx path.
>> > > > This messes up our TFD on high load. The patch should
>fix your problem.
>> > > >
>> > > > Signed-off-by: Zhu Yi <yi.zhu@intel.com>
>> > > >
>> > > > diff --git
>a/drivers/net/wireless/iwlwifi/iwl3945-base.c
>b/drivers/net/wireless/iwlwifi/iwl3945-base.c
>> > > > index 994db4a..b31b34c 100644
>> > > > --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
>> > > > +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
>> > > > @@ -548,6 +548,9 @@ static int iwl3945_tx_skb(struct
>iwl_priv *priv, struct sk_buff *skb)
>> > > >        txq = &priv->txq[txq_id];
>> > > >        q = &txq->q;
>> > > >
>> > > > +      if ((iwl_queue_space(q) < q->high_mark))
>> > > > +              goto drop;
>> > > > +
>> > > >        spin_lock_irqsave(&priv->lock, flags);
>> > > >
>> > > >        idx = get_cmd_index(q, q->write_ptr, 0);
>> > > >
>> > > >
>> > Few days ago, I had an idea to reply here that I am sure that this
>> > problem disappeared with this patch.
>> >
>> >
>> > Today I got same kernel panic _with_ the patch applied....
>>
>> Looks like (all of) the root causes are still not found yet.
>The symptom
>> is exactly the same as the previous one.
>>
>> One thing I found today is when txq read_ptr catches up to write_ptr
>> (read_ptr == write_ptr), iwl_queue_used() will _always_ return TRUE!
>> This will be a problem if the firmware sends us a wrong index
>> (sequence), then we will fail the check in this condition.
>I'm not sure
>> if firmware can really send us a wrong sequence. Can you
>please try this
>> patch? Apply it on top of the previous one. If you do see
>the "FIRMWARE
>> BUG" in dmesg, then I think we find the root cause.
>
>
>
>Finally exploded....
>
>
><3>[  330.761347] iwl3945 0000:06:00.0: Microcode SW error
>detected. Restarting 0x82000008.
><3>[  330.761403] iwl3945 0000:06:00.0: Start IWL Error Log Dump:
><3>[  330.761421] iwl3945 0000:06:00.0: Status: 0x000302E6, count: 1
><3>[  330.761438] iwl3945 0000:06:00.0: Desc       Time
>asrtPC  blink2 ilink1  nmiPC   Line
><3>[  330.761683] iwl3945 0000:06:00.0: SYSASSERT     (#5)
>1035963230 0x008B6 0x017B8 0x0031C 0x00000 65

"Bad Command" sysassert ... See below (search "obviously").

><3>[  330.761692]
><3>[  330.761837] iwl3945 0000:06:00.0: Start IWL Event Log
>Dump: display last 20 count
><3>[  330.761895] iwl3945 0000:06:00.0: 1035963151
>0x00000000     1106
><3>[  330.761931] iwl3945 0000:06:00.0: 1035963155
>0x00000000     1106
><3>[  330.761967] iwl3945 0000:06:00.0: 1035963160
>0x00000000     1106
><3>[  330.762003] iwl3945 0000:06:00.0: 1035963164
>0x00000000     1106
><3>[  330.762039] iwl3945 0000:06:00.0: 1035963168
>0x00000000     1106
><3>[  330.762075] iwl3945 0000:06:00.0: 1035963173
>0x00000000     1106
><3>[  330.762112] iwl3945 0000:06:00.0: 1035963177
>0x00000000     1106
><3>[  330.762148] iwl3945 0000:06:00.0: 1035963181
>0x00000000     1106
><3>[  330.762184] iwl3945 0000:06:00.0: 1035963185
>0x00000000     1106
><3>[  330.762220] iwl3945 0000:06:00.0: 1035963190
>0x00000001     1106
><3>[  330.762256] iwl3945 0000:06:00.0: 1035963190
>0x0000000f     1106
><3>[  330.762292] iwl3945 0000:06:00.0: 1035963192
>0x00000417     1105
><3>[  330.762329] iwl3945 0000:06:00.0: 1035963195
>0x000005a5     1115
><3>[  330.762365] iwl3945 0000:06:00.0: 1035963199
>0x00000001     0463
><3>[  330.762401] iwl3945 0000:06:00.0: 1035963200
>0x00000001     0462
><3>[  330.762437] iwl3945 0000:06:00.0: 1035963212
>0x000002b1     0603
><3>[  330.762474] iwl3945 0000:06:00.0: 1035963217
>0x04fb0077     0401
><3>[  330.762510] iwl3945 0000:06:00.0: 1035963222
>0x04dc0018     0401

Last good command 0x18, with (driver provided) header indicating sent via queue 4, queue index 0xdc

><3>[  330.762547] iwl3945 0000:06:00.0: 1035963229
>0x00000000     0401

This shows command "0" (non-existant/unsupported/bad command) with (driver provided) header indicating sent via queue "0", index "0"; obviously bad data in command queue.

-- Ben --

><3>[  330.762583] iwl3945 0000:06:00.0: 1035963232
>0x00000100     0125
><4>[  330.762623] FIRMWARE BUG: index 220 is given while
>read_ptr is 252
><0>[  330.762674] ------------[ cut here ]------------
><2>[  330.762689] kernel BUG at
>/home/maxim/software/kernel/linux-2.6/drivers/net/wireless/iwlw
>ifi/iwl-dev.h:717!
><0>[  330.762715] invalid opcode: 0000 [#1] PREEMPT SMP
><0>[  330.762735] last sysfs file:
>/sys/devices/platform/coretemp.1/temp1_input
><4>[  330.762755] CPU 0
><4>[  330.762765] Modules linked in: nvidia(P) af_packet nfsd
>exportfs nfs lockd nfs_acl auth_rpcgss sunrpc usb_storage
>usb_libusual cpufreq_powersave cpufreq_conservative
>snd_hda_codec_realtek cpufreq_userspace snd_hda_intel
>acpi_cpufreq uvcvideo iwl3945 snd_hda_codec coretemp videodev
>iwlcore v4l1_compat snd_hwdep joydev ohci1394
>v4l2_compat_ioctl32 tg3 snd_pcm sbp2 mac80211 uhci_hcd psmouse
>video snd_page_alloc ieee1394 libphy ehci_hcd output ac
>battery lirc_ene0100 serio_raw evdev cfg80211 rfkill usbcore
>fuse lzo lzo_decompress lzo_compress
><6>[  330.762987] Pid: 0, comm: swapper Tainted: P
>2.6.32-wl #243 Aspire 5720
><6>[  330.763011] RIP: 0010:[<ffffffffa01c3fe7>]
>[<ffffffffa01c3fe7>] iwl_tx_cmd_complete+0x397/0x3a0 [iwlcore]
><6>[  330.763057] RSP: 0018:ffff880002203d20  EFLAGS: 00010286
><6>[  330.763075] RAX: 0000000000000049 RBX: ffff88006fc09b40
>RCX: 0000000000000102
><6>[  330.763096] RDX: 0000000000000000 RSI: 0000000000000000
>RDI: 0000000000000001
><6>[  330.763118] RBP: ffff880002203d90 R08: 0000000000000002
>R09: 0000000000000000
><6>[  330.763139] R10: 0000000000000000 R11: 0000000000000001
>R12: 00000000000000fc
><6>[  330.763160] R13: 00000000000000dc R14: ffff88006fd6d460
>R15: ffff88006a2a1600
><6>[  330.763182] FS:  0000000000000000(0000)
>GS:ffff880002200000(0000) knlGS:0000000000000000
><6>[  330.763206] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
><6>[  330.763224] CR2: 00007f7ffbf95000 CR3: 0000000001001000
>CR4: 00000000000006f0
><6>[  330.763246] DR0: 0000000000000000 DR1: 0000000000000000
>DR2: 0000000000000000
><6>[  330.763267] DR3: 0000000000000000 DR6: 00000000ffff0ff0
>DR7: 0000000000000400
><4>[  330.763289] Process swapper (pid: 0, threadinfo
>ffffffff815ca000, task ffffffff815ceb60)
><0>[  330.763310] Stack:
><4>[  330.763318]  ffff88006a2a9690 0000000000000046
>ffff880002203d40 0000000000000046
><4>[  330.763346] <0> 0000000000000282 0000000000000282
>0000000000000282 ffff8800699eba00
><4>[  330.763375] <0> ffff880002203d70 ffff88006a2a1600
>ffff88006a2a2f10 ffff88006a673000
><0>[  330.763406] Call Trace:
><0>[  330.763416]  <IRQ>
><4>[  330.763436]  [<ffffffffa0230d13>]
>iwl3945_irq_tasklet+0x673/0x1740 [iwl3945]
><4>[  330.763469]  [<ffffffffa01b683e>] ?
>iwl_isr_legacy+0x3e/0x600 [iwlcore]
><4>[  330.763496]  [<ffffffff81053f56>] tasklet_action+0x106/0x110
><4>[  330.763516]  [<ffffffff81055674>] __do_softirq+0x114/0x2c0
><4>[  330.763536]  [<ffffffff8109eb38>] ? handle_edge_irq+0x78/0x160
><4>[  330.763558]  [<ffffffff8100d25c>] call_softirq+0x1c/0x30
><4>[  330.763577]  [<ffffffff8100f1fd>] do_softirq+0x7d/0xb0
><4>[  330.763595]  [<ffffffff81055125>] irq_exit+0x95/0xa0
><4>[  330.763615]  [<ffffffff8140bddc>] do_IRQ+0x7c/0xf0
><4>[  330.763634]  [<ffffffff8100ca13>] ret_from_intr+0x0/0xf
><0>[  330.763650]  <EOI>
><4>[  330.763664]  [<ffffffff812a1d5b>] ?
>acpi_idle_enter_bm+0x275/0x2aa
><4>[  330.763684]  [<ffffffff812a1d65>] ?
>acpi_idle_enter_bm+0x27f/0x2aa
><4>[  330.763705]  [<ffffffff812a1d5b>] ?
>acpi_idle_enter_bm+0x275/0x2aa
><4>[  330.763729]  [<ffffffff8133227f>] ? cpuidle_idle_call+0x9f/0x160
><4>[  330.763749]  [<ffffffff8100b1df>] ? cpu_idle+0xaf/0x110
><4>[  330.763769]  [<ffffffff813f534a>] ? rest_init+0x7a/0x80
><4>[  330.763789]  [<ffffffff81640d01>] ? start_kernel+0x3ac/0x3b8
><4>[  330.763808]  [<ffffffff81640315>] ?
>x86_64_start_reservations+0x125/0x129
><4>[  330.763831]  [<ffffffff816403fd>] ? x86_64_start_kernel+0xe4/0xeb
><0>[  330.763848] Code: c7 c6 48 86 1d a0 48 c7 c7 53 86 1d a0
>e8 a2 b3 07 e1 e9 68 fe ff ff 44 89 e2 44 89 ee 48 c7 c7 80 5a
>1d a0 31 c0 e8 c7 31 24 e1 <0f> 0b eb fe 0f 1f 44 00 00 55 48
>89 e5 41 57 41 56 41 55 41 54
><1>[  330.764008] RIP  [<ffffffffa01c3fe7>]
>iwl_tx_cmd_complete+0x397/0x3a0 [iwlcore]
><4>[  330.764042]  RSP <ffff880002203d20>
><4>[  330.764059] ---[ end trace e386a588d450d76f ]---
><0>[  330.764073] Kernel panic - not syncing: Fatal exception
>in interrupt
><4>[  330.764093] Pid: 0, comm: swapper Tainted: P      D
>2.6.32-wl #243
><4>[  330.764111] Call Trace:
><4>[  330.764120]  <IRQ>  [<ffffffff814070f1>] panic+0x82/0x13f
><4>[  330.764148]  [<ffffffff81010a52>] oops_end+0xe2/0xf0
><4>[  330.764166]  [<ffffffff81010c7b>] die+0x5b/0x90
><4>[  330.764183]  [<ffffffff8100db24>] do_trap+0xc4/0x170
><4>[  330.764201]  [<ffffffff8100e025>] do_invalid_op+0x95/0xb0
><4>[  330.764230]  [<ffffffffa01c3fe7>] ?
>iwl_tx_cmd_complete+0x397/0x3a0 [iwlcore]
><4>[  330.764254]  [<ffffffff8140a94d>] ?
>trace_hardirqs_off_thunk+0x3a/0x3c
><4>[  330.764276]  [<ffffffff8100cef5>] invalid_op+0x15/0x20
><4>[  330.764304]  [<ffffffffa01c3fe7>] ?
>iwl_tx_cmd_complete+0x397/0x3a0 [iwlcore]
><4>[  330.764333]  [<ffffffffa0230d13>]
>iwl3945_irq_tasklet+0x673/0x1740 [iwl3945]
><4>[  330.764364]  [<ffffffffa01b683e>] ?
>iwl_isr_legacy+0x3e/0x600 [iwlcore]
><4>[  330.764388]  [<ffffffff81053f56>] tasklet_action+0x106/0x110
><4>[  330.764408]  [<ffffffff81055674>] __do_softirq+0x114/0x2c0
><4>[  330.764427]  [<ffffffff8109eb38>] ? handle_edge_irq+0x78/0x160
><4>[  330.764447]  [<ffffffff8100d25c>] call_softirq+0x1c/0x30
><4>[  330.764465]  [<ffffffff8100f1fd>] do_softirq+0x7d/0xb0
><4>[  330.764483]  [<ffffffff81055125>] irq_exit+0x95/0xa0
><4>[  330.764500]  [<ffffffff8140bddc>] do_IRQ+0x7c/0xf0
><4>[  330.764519]  [<ffffffff8100ca13>] ret_from_intr+0x0/0xf
><4>[  330.764534]  <EOI>  [<ffffffff812a1d5b>] ?
>acpi_idle_enter_bm+0x275/0x2aa
><4>[  330.764562]  [<ffffffff812a1d65>] ?
>acpi_idle_enter_bm+0x27f/0x2aa
><4>[  330.764583]  [<ffffffff812a1d5b>] ?
>acpi_idle_enter_bm+0x275/0x2aa
><4>[  330.764605]  [<ffffffff8133227f>] ? cpuidle_idle_call+0x9f/0x160
><4>[  330.764625]  [<ffffffff8100b1df>] ? cpu_idle+0xaf/0x110
><4>[  330.764643]  [<ffffffff813f534a>] ? rest_init+0x7a/0x80
><4>[  330.764662]  [<ffffffff81640d01>] ? start_kernel+0x3ac/0x3b8
><4>[  330.764682]  [<ffffffff81640315>] ?
>x86_64_start_reservations+0x125/0x129
><4>[  330.764703]  [<ffffffff816403fd>] ? x86_64_start_kernel+0xe4/0xeb
>
>
>
>Note that these days I see the 'Microcode SW error detected'
>somewhat more often that I used to.
>
>
>This is the combined patch I used:
>
>
>diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h
>b/drivers/net/wireless/iwlwifi/iwl-dev.h
>index 2673e9a..8efc469 100644
>--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
>+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
>@@ -711,7 +711,13 @@ extern void iwl_txq_ctx_stop(struct
>iwl_priv *priv);
> extern int iwl_queue_space(const struct iwl_queue *q);
> static inline int iwl_queue_used(const struct iwl_queue *q, int i)
> {
>-       return q->write_ptr > q->read_ptr ?
>+       if (q->write_ptr == q->read_ptr) {
>+               printk("FIRMWARE BUG: index %d is given while
>read_ptr is %d\n",
>+                      i, q->read_ptr);
>+               BUG();
>+       }
>+
>+       return q->write_ptr >= q->read_ptr ?
>                (i >= q->read_ptr && i < q->write_ptr) :
>                !(i < q->read_ptr && i >= q->write_ptr);
> }
>diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c
>b/drivers/net/wireless/iwlwifi/iwl3945-base.c
>index 2a28a1f..a36de73 100644
>--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
>+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
>@@ -548,6 +548,9 @@ static int iwl3945_tx_skb(struct iwl_priv
>*priv, struct sk_buff *skb)
>        txq = &priv->txq[txq_id];
>        q = &txq->q;
>
>+       if ((iwl_queue_space(q) < q->high_mark))
>+               goto drop;
>+
>        spin_lock_irqsave(&priv->lock, flags);
>
>        idx = get_cmd_index(q, q->write_ptr, 0);
>
>
>Best regards,
>       Maxim Levitsky
>
>
>---------------------------------------------------------------
>---------------
>This SF.Net email is sponsored by the Verizon Developer Community
>Take advantage of Verizon's best-in-class app development support
>A streamlined, 14 day to market process makes app distribution
>fast and easy
>Join now and get one step closer to millions of Verizon customers
>http://p.sf.net/sfu/verizon-dev2dev
>_______________________________________________
>Ipw3945-devel mailing list
>Ipw3945-devel@lists.sourceforge.net
>https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>
