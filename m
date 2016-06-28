Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:32908 "EHLO
	mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752236AbcF1PRT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2016 11:17:19 -0400
Received: by mail-qk0-f196.google.com with SMTP id n132so4069194qka.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2016 08:17:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57728EB2.2030706@candelatech.com>
References: <1466015073-8418-1-git-send-email-greearb@candelatech.com>
 <1467122419.2493.18.camel@sipsolutions.net> <57728EB2.2030706@candelatech.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 28 Jun 2016 20:46:53 +0530
Message-ID: <CABPxzYKoMNehnzRAAwNsHjK=HWc+EYD3QQbSXrYLxXA7B8HnFQ@mail.gmail.com> (sfid-20160628_171723_434606_86CE109E)
Subject: Re: [PATCH] mac80211: ensure info->control.vif is set for queued pkts.
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 28, 2016 at 8:20 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 06/28/2016 07:00 AM, Johannes Berg wrote:
>>
>> On Wed, 2016-06-15 at 11:24 -0700, greearb@candelatech.com wrote:
>>>
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> When driving ath10k with a modified pktgen, we see excessive amounts
>>> of these warnings:
>>>
>>> Jun  6 13:47:53 localhost kernel: WARNING: CPU: 1 PID: 1186 at
>>> /home/greearb/git/linux-4.4.dev.y/net/mac80211/tx.c:3
>>> 125 ieee80211_tx_pending+0x9d/0x19e [mac80211]()
>>> Jun  6 13:47:53 localhost kernel: Modules linked in:
>>> nf_conntrack_netlink nfnetlink nf_conntrack_ipv4 iptable_raw xt
>>> _CT nf_conntrack nf_defrag_ipv4 8021q garp mrp stp llc bnep bluetooth
>>> fuse macvlan wanlink(O) pktgen ip6table_filter
>>>   ip6_tables ebtable_nat ebtables snd_hda_codec_hdmi
>>> snd_hda_codec_realtek snd_hda_codec_generic ath10k_pci ath10k_co
>>> re snd_hda_intel snd_hda_codec coretemp hwmon intel_rapl iosf_mbi
>>> x86_pkg_temp_thermal intel_powerclamp kvm_intel sn
>>> d_hda_core ath iTCO_wdt iTCO_vendor_support mac80211 kvm cfg80211
>>> snd_hwdep e1000e snd_seq cdc_acm snd_seq_device sn
>>> d_pcm irqbypass serio_raw pcspkr ptp i2c_i801 pps_core snd_timer snd
>>> soundcore 8250_fintek shpchp fjes lpc_ich tpm_t
>>> is tpm uinput ipv6 i915 i2c_algo_bit drm_kms_helper drm i2c_core
>>> video [last unloaded: nfnetlink]
>>> Jun  6 13:47:53 localhost kernel: CPU: 1 PID: 1186 Comm: kpktgend_1
>>> Tainted: G        W  O    4.4.11+ #50
>>> Jun  6 13:47:53 localhost kernel: Hardware name: To be filled by
>>> O.E.M. To be filled by O.E.M./ChiefRiver, BIOS 4.6.
>>> 5 06/07/2013
>>> Jun  6 13:47:53 localhost kernel: 0000000000000000 ffff88021e243e68
>>> ffffffff81340d35 0000000000000000
>>> Jun  6 13:47:53 localhost kernel: 0000000000000009 ffff88021e243ea0
>>> ffffffff810e
>>> a46e ffffffffa0b1cb0e
>>> Jun  6 13:47:53 localhost kernel: ffff880213a41600 ffff880213a406e0
>>> ffff8800c8ac1700 ffff88021e243ed8
>>> Jun  6 13:47:53 localhost kernel: Call Trace:
>>> Jun  6 13:47:53 localhost kernel: <IRQ> [<ffffffff81340d35>]
>>> dump_stack+0x63/0x7f
>>> Jun  6 13:47:53 localhost kernel: [<ffffffff810ea46e>]
>>> warn_slowpath_common+0x94/0xad
>>> Jun  6 13:47:53 localhost kernel: [<ffffffffa0b1cb0e>] ?
>>> ieee80211_tx_pending+0x9d/0x19e [mac80211]
>>> Jun  6 13:47:53 localhost kernel: [<ffffffff810ea52b>]
>>> warn_slowpath_null+0x15/0x17
>>> Jun  6 13:47:53 localhost kernel: [<ffffffffa0b1cb0e>]
>>> ieee80211_tx_pending+0x9d/0x19e [mac80211]
>>> Jun  6 13:47:53 localhost kernel: [<ffffffff810edf42>]
>>> tasklet_action+0xae/0xbf
>>> Jun  6 13:47:53 localhost kernel: [<ffffffff810ed833>]
>>> __do_softirq+0x109/0x26d
>>> Jun  6 13:47:53 localhost kernel: [<ffffffff811370ec>] ?
>>> rcu_irq_exit+0x3d/0x40
>>> Jun  6 13:47:53 localhost kernel: [<ffffffff816a826c>]
>>> do_softirq_own_stack+0x1c/0x30
>>> Jun  6 13:47:53 localhost kernel: <EOI> [<ffffffff810ed9fc>]
>>> do_softirq+0x30/0x3b
>>> Jun  6 13:47:53 localhost kernel: [<ffffffff810eda70>]
>>> __local_bh_enable_ip+0x69/0x83
>>> Jun  6 13:47:53 localhost kernel: [<ffffffffa123bd24>]
>>> pktgen_thread_worker+0x1399/0x1f26 [pktgen]
>>> Jun  6 13:47:53 localhost kernel: [<ffffffff816a37a6>] ?
>>> __schedule+0x3c1/0x585
>>> Jun  6 13:47:53 localhost kernel: [<ffffffff8111b55e>] ?
>>> finish_wait+0x5d/0x5d
>>> Jun  6 13:47:53 localhost kernel: [<ffffffffa123a98b>] ?
>>> pktgen_rem_all_ifs+0x6a/0x6a [pktgen]
>>> Jun  6 13:47:53 localhost kernel: [<ffffffff81102428>]
>>> kthread+0xa0/0xa8
>>> Jun  6 13:47:53 localhost kernel: [<ffffffff81102388>] ?
>>> kthread_parkme+0x1f/0x1f
>>> Jun  6 13:47:53 localhost kernel: [<ffffffff816a68cf>]
>>> ret_from_fork+0x3f/0x70
>>> Jun  6 13:47:53 localhost kernel: [<ffffffff81102388>] ?
>>> kthread_parkme+0x1f/0x1f
>>> Jun  6 13:47:53 localhost kernel: ---[ end trace a5fa4429cf1b918b ]
>>> ---
>>> Jun  6 13:47:53 localhost kernel: ------------[ cut here ]-----------
>>> -
>>>
>>> I think the problem is that the logic that inserts the packet into
>>> the pending
>>> queue is not setting the vif in the skb info struct.  This patch
>>> appears to
>>> fix the problem.
>>>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>> ---
>>>
>>> Please review this well, looks like this code has been this way for a
>>> long time,
>>> and this was reproduced and tested on a kernel with a lot of wifi,
>>> pktgen, and ath10k
>>> patches.
>>
>>
>> I'm not convinced this patch is correct. control.vif is always set,
>> already since ieee80211_tx_prepare_skb(). It's *changed* to the looked-
>> up interface in case of monitor/VLAN within __ieee80211_tx()
>> and ieee80211_tx_frags(), but otherwise __ieee80211_tx() will leave it
>> completely identical:
>>
>> sdata = vif_to_sdata(info->control.vif);
>> [...]
>> switch (iftype) {
>> [...]
>> default:
>>         vif = &sdata->vif;
>> }
>>
>> so the control.vif assignment is a no-op in almost all cases.
>
>
> So, maybe a WARN_ON would be appropriate at the place frames are enqueued
> in the backlog queue?  Since this patch did fix my problem, maybe that
> WARN_ON
> would show the path that allow frames with bad control.vif to be inserted?
>
> I had also found another problem with pktgen using the headroom wrong, so
> possibly
> that would have also fixed my problem..I'm not sure which patch I put in
> first.
>
 A while ago i have observed this issue when running iperf/pktgen
(don't remember)
and throughput was around 350Mbps UDP Tx. I could not figure out
the cause, so I had the below WAR.

===
 net/mac80211/tx.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6d5791d..dfd0d98 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -766,6 +766,9 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
         * number, if we have no matching interface then we
         * neither assign one ourselves nor ask the driver to.
         */
+       if (info->control.vif == NULL)
+               return TX_DROP;
+
        if (unlikely(info->control.vif->type == NL80211_IFTYPE_MONITOR))
                return TX_CONTINUE;
