Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680AbbH3Sp5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Aug 2015 14:45:57 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: [PATCH 0/1] rtl8xxxu (mac80211) driver for rtl8188[cr]u/rtl8192cu/rtl8723au
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	<55E3341C.2010009@lwfinger.net>
Date: Sun, 30 Aug 2015 14:45:55 -0400
In-Reply-To: <55E3341C.2010009@lwfinger.net> (Larry Finger's message of "Sun,
	30 Aug 2015 11:49:32 -0500")
Message-ID: <wrfja8t88vj0.fsf@redhat.com> (sfid-20150830_204600_039980_3D424691)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> On 08/29/2015 04:18 PM, Jes.Sorensen@redhat.com wrote:
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> Hi,
>>
>> I finally found some time to work on rtl8xxxu again. Since the
>> previously version posted some months ago, I fixed up a number of
>> bugs. I also added support for a range of other Realtek based USB
>> devices. The driver now supports rtl8723au, rtl8188cu, rtl8188ru, and
>> rtl8192cu. It should work on rtl8191cu devices as well.
>>
>> Per default only devices I have actually tested will be enabled. If
>> you are interested in trying it out with other 8188cu/8188ru/819[12]cu
>> dongles, you need to enable CONFIG_RTL8XXXU_UNTESTED. Please report
>> test results back to me.
>>
>> Note if you enable this driver, it may clash with CONFIG_RTL8192U,
>> CONFIG_R8723AU, and CONFIG_RTL8192CU (rtlwifi). Please pay attention
>> to which module you load and/or use modprobe blacklists.
>>
>> This driver is still work in progress. I have used it as my primary
>> driver for the last six months, and I find it to be very stable. It
>> seems suitable for mainline inclusion at this point.
>
> Jes,
>
> The Edimax 7811 works on the new driver. The performance is a lot
> better than I said in my previous post. Measuring with netperf for 3
> second intervals, I get a maximum RX rate of 33.0 Mbps and a long-term
> average (750 samples) of 20.8 Mbps. For TX, the max is 34.5 Mbps and
> the average is 27.4.

Larry,

Just to be sure I got it right, you're saying the gain issue is not an
issue with this version of the code after all?

Is the 7811 a 1T1R or a 2T2R part?

> I am still getting one "scheduling while atomic" BUG splat as follows:
>
> BUG: sleeping function called from invalid context at kernel/locking/mutex.c:616
> in_atomic(): 0, irqs_disabled(): 0, pid: 19961, name: kworker/u16:0
> INFO: lockdep is turned off.
> CPU: 0 PID: 19961 Comm: kworker/u16:0 Tainted: G W O 4.2.0-rc7-wl+ #39
> Hardware name: TOSHIBA TECRA A50-A/TECRA A50-A, BIOS Version 4.20   04/17/2014
> Workqueue: phy9 ieee80211_iface_work [mac80211]
>  ffffffff81a3d470 ffff880102227508 ffffffff8174b6e1 0000000000000000
>  ffff880224e54b00 ffff880102227538 ffffffff81090117 ffff880102227578
>  ffffffff81a3d470 0000000000000268 0000000000000000 ffff880102227568
> Call Trace:
>  [<ffffffff8174b6e1>] dump_stack+0x4c/0x6e
>  [<ffffffff81090117>] ___might_sleep+0x147/0x1f0
>
>  [<ffffffff8109020d>] __might_sleep+0x4d/0x90
>  [<ffffffff81750d88>] mutex_lock_nested+0x38/0x3c0
>  [<ffffffff814d9a56>] ? __dev_printk+0x46/0x90
>  [<ffffffffa07a553f>] rtl8723a_h2c_cmd+0x4f/0x180 [rtl8xxxu]
>  [<ffffffffa07aa977>] rtl8xxxu_bss_info_changed+0x367/0x6b1 [rtl8xxxu]
>  [<ffffffffa07aa89f>] ? rtl8xxxu_bss_info_changed+0x28f/0x6b1 [rtl8xxxu]
>  [<ffffffffa055fd84>] ieee80211_bss_info_change_notify+0x104/0x4e0 [mac80211]
>  [<ffffffffa05f5626>] ieee80211_assoc_success+0x90c/0xa98 [mac80211]
>  [<ffffffff8116b8ad>] ? irq_work_queue+0x7d/0xa0
>  [<ffffffff810d26d9>] ? wake_up_klogd+0x39/0x50
>  [<ffffffff810d28d7>] ? console_unlock+0x1e7/0x510
>  [<ffffffff810d2def>] ? vprintk_emit+0x1ef/0x540
>  [<ffffffff810d3299>] ? vprintk_default+0x29/0x40
>  [<ffffffffa05d311b>] ieee80211_rx_mgmt_assoc_resp+0x15b/0x310 [mac80211]
>  [<ffffffffa05d48da>] ieee80211_sta_rx_queued_mgmt+0x19a/0x6d0 [mac80211]
>  [<ffffffff810b8915>] ? cpuacct_charge+0x5/0x1a0
>  [<ffffffff815e8a91>] ? skb_dequeue+0x21/0x70
>  [<ffffffff810bca4d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffffa05803b9>] ieee80211_iface_work+0x2d9/0x3e0 [mac80211]
>  [<ffffffff81082e7e>] ? process_one_work+0x14e/0x7d0
>  [<ffffffff81082f0f>] process_one_work+0x1df/0x7d0
>  [<ffffffff81082e7e>] ? process_one_work+0x14e/0x7d0
>  [<ffffffff8108361a>] worker_thread+0x11a/0x460
>  [<ffffffff817546bb>] ? _raw_spin_unlock_irqrestore+0x4b/0x60
>  [<ffffffff81083500>] ? process_one_work+0x7d0/0x7d0
>  [<ffffffff81089e9f>] kthread+0xef/0x110
>  [<ffffffff81089db0>] ? kthread_create_on_node+0x220/0x220
>  [<ffffffff8175530f>] ret_from_fork+0x3f/0x70
>  [<ffffffff81089db0>] ? kthread_create_on_node+0x220/0x220
> wlp0s20u6: associated
>
> This splat happened during the authentication/association phase. At
> present, the connection has been up for almost 12 hours without a
> single drop.

That one is interesting, I don't think I have seen this one ever, but
I'll look out for it. It seems to happen during h2c command
processing. I'll have a look.

The uptime sounds pretty awesome, thanks again for testing!

Jes
