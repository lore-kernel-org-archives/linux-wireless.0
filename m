Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hotel311.server4you.de ([85.25.146.15]:52029 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab2KTWfT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 17:35:19 -0500
Message-ID: <50AC05A5.3090706@monom.org> (sfid-20121120_233522_857895_C171997D)
Date: Tue, 20 Nov 2012 23:35:17 +0100
From: Daniel Wagner <wagi@monom.org>
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH v2 00/22] brcmsmac: Tx rework and expanded debug/trace
 support
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com> <50AA845C.2050809@monom.org> <50AB3182.5040505@monom.org> <20121120142822.GA26602@thinkpad-t410> <50ABC168.8080904@monom.org> <20121120205418.GB26602@thinkpad-t410>
In-Reply-To: <20121120205418.GB26602@thinkpad-t410>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20.11.2012 21:54, Seth Forshee wrote:
> On Tue, Nov 20, 2012 at 06:44:08PM +0100, Daniel Wagner wrote:
>> Hi Seth,
>>
>> On 20.11.2012 15:28, Seth Forshee wrote:
>>> On Tue, Nov 20, 2012 at 08:30:10AM +0100, Daniel Wagner wrote:
>>>> Hi Seth,
>>>>
>>>> On 19.11.2012 20:11, Daniel Wagner wrote:
>>>>> Works perfectly fine on my machine.
>>>>
>>>> Well, not really true. Though I am not sure if this what I am seeing
>>>> related to your changes. I see following log only when I am using my
>>>> home AP. The pattern is that when the connection stop working I see
>>>> something like this in the log:
>>>>
>>>> [ 8735.159091] wlan0: moving STA 1c:c6:3c:1f:50:68 to state 4
>>>> [ 8735.197298] wlan0: Rx A-MPDU request on tid 0 result 0
>>>> [ 8735.566368] wlan0: Open BA session requested for 1c:c6:3c:1f:50:68 tid 0
>>>> [ 8735.573701] wlan0: activated addBA response timer on tid 0
>>>> [ 8735.578826] wlan0: switched off addBA timer for tid 0
>>>> [ 8735.578834] wlan0: Aggregation is on for tid 0
>>>> [ 8749.687530] wlan0: tx session timer expired on tid 0
>>>> [ 8749.687558] wlan0: Tx BA session stop requested for 1c:c6:3c:1f:50:68 tid 0
>>>> [ 8749.700550] wlan0: Stopping Tx BA session for 1c:c6:3c:1f:50:68 tid 0
>>>>
>>>>
>>>> This is what I do: First establishing a connection, then after a while any
>>>> traffic seems stops for a period and sometimes it recovers from that point. If
>>>> not a disconnect/connect (using ConnMan) dance fixes the problem.
>>>
>>> The tx session timer expiring is a result of not having any aggregate
>>> transfers in a while. In my testing with iperf I see periods where the
>>> transfer seems to stall, but it always recovers. These are less frequent
>>> after my patches, but they still happen, and I haven't been able to work
>>> out the cause yet. I'm not sure whether these are related to what you're
>>> seeing or not.
>>>
>>> Luckily I've added a bunch of new debug code. Could you make sure you
>>> have MAC80211_MESSAGE_TRACING and BRCM_TRACING enabled in your config
>>> and collect a trace when this is happening by running:
>>>
>>>   trace-cmd record -e mac80211 -e mac80211_msg -e brcmsmac \
>>>          -e brcmsmac_tx -e brcmsmac_msg
>>>
>>> This going to collect a lot of data, and you should bump up the trace
>>> buffer size to avoid overruns. Once you've got a trace please compress
>>> trace.dat and put it along with your dmesg somewhere where I can get at
>>> them.
>>
>> I hope I got it right. Here are the requested logs:
>>
>> http://www.monom.org/misc/brcmsmac/traces/
> 
> Looks like you got it right. The period you traced doesn't seem to cover
> any of the block ack session timeouts, but I do see this:
> 
> [  225.269777] wlan0: release an RX reorder frame due to timeout on earlier frames
> [  243.869220] wlan0: unexpected AddBA Req from 1c:c6:3c:1f:50:68 on tid 0
> [  243.869233] wlan0: Rx BA session stop requested for 1c:c6:3c:1f:50:68 tid 0 recipient reason: 32
> [  243.869250] wlan0: Rx A-MPDU request on tid 0 result 0
> [  252.254013] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 13
> <snip repeated messages>
> [  259.798966] wlan0: release an RX reorder frame due to timeout on earlier frames
> <snip repeated messages>
> [  265.193640] wlan0: unexpected AddBA Req from 1c:c6:3c:1f:50:68 on tid 0
> [  265.193648] wlan0: Rx BA session stop requested for 1c:c6:3c:1f:50:68 tid 0 recipient reason: 32
> [  265.193663] wlan0: Rx A-MPDU request on tid 0 result 0
> 
> Does something in this time frame correspond to your loss in
> connectivity? The number of packets being sent and received varies some
> throughout the trace but generally stays pretty low. It never completely
> stops though.

I am currently not able to reproduce a complete loss of connectivity. 
I have updated from rc3 to rc6 but still using your v2 patchset. Don't
know if this makes a difference. Anyway, the above log was created 
with the laptop more away (working place) from the AP. The complete drop of
connectivity happens normally in the living room.

For the second attempt I started to log with the laptop placed at 
my working place and then moved later to the living room which is nearer
towards the AP. It seems to trigger the BA timeouts.
 
> Other than the messages above I don't notice any obvious problems. If
> you can pinpoint exactly what range of timestamps corresponds to your
> problems I can look a bit closer.

Maybe a have look at (this is in the living room)

6119.448028 first drop in througput but it revored
6169.045370 second drop in thoughput but it revored

> Is this a regression introduced by these patches, or was the connection
> with this AP also not working well without them?

I saw the same behavior before but didn't really look closely what 
is happening. So I would say this is not a regression. 

The new logs also includes also this: 

[ 5443.454178] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 1
[ 5444.185118] ------------[ cut here ]------------
[ 5444.185156] WARNING: at drivers/net/wireless/brcm80211/brcmsmac/main.c:7567 brcms_c_wait_for_tx_completion+0xab/0xc0 [brcmsmac]()
[ 5444.185160] Hardware name: MacBookAir5,2
[ 5444.185162] Modules linked in: tcp_lp lockd sunrpc rfcomm iptable_nat nf_nat_ipv4 nf_nat bnep ip6t_REJECT nf_conntrack_ipv4 nf_conntrack_ipv6 nf_defrag_ipv6 nf_defrag_ipv4 xt_state ip6table_filter nf_conntrack ip6_tables nls_utf8 hfsplus arc4 brcmsmac cordic brcmutil mac80211 cfg80211 iTCO_wdt iTCO_vendor_support joydev snd_hda_codec_hdmi snd_hda_codec_cirrus snd_hda_intel snd_hda_codec snd_hwdep applesmc snd_seq coretemp input_polldev crc32c_intel btusb bluetooth snd_seq_device ghash_clmulni_intel microcode snd_pcm rfkill bcm5974 i2c_i801 pcspkr lpc_ich snd_page_alloc snd_timer mfd_core snd bcma soundcore apple_bl binfmt_misc vhost_net tun macvtap macvlan kvm_intel kvm uinput i915 video i2c_algo_bit drm_kms_helper drm i2c_core
[ 5444.185258] Pid: 2425, comm: kworker/u:24 Not tainted 3.7.0-rc6+ #15
[ 5444.185261] Call Trace:
[ 5444.185276]  [<ffffffff8105cacf>] warn_slowpath_common+0x7f/0xc0
[ 5444.185283]  [<ffffffff8105cb2a>] warn_slowpath_null+0x1a/0x20
[ 5444.185305]  [<ffffffffa041b95b>] brcms_c_wait_for_tx_completion+0xab/0xc0 [brcmsmac]
[ 5444.185319]  [<ffffffffa040f68b>] brcms_ops_flush+0x3b/0x60 [brcmsmac]
[ 5444.185351]  [<ffffffffa038ec6d>] ieee80211_scan_work+0x34d/0x5e0 [mac80211]
[ 5444.185362]  [<ffffffff8101358e>] ? __switch_to+0x13e/0x4a0
[ 5444.185371]  [<ffffffff81100ba5>] ? tracing_is_on+0x15/0x30
[ 5444.185381]  [<ffffffff81078767>] process_one_work+0x147/0x480
[ 5444.185405]  [<ffffffffa038e920>] ? ieee80211_run_deferred_scan+0x90/0x90 [mac80211]
[ 5444.185414]  [<ffffffff8107ab2e>] worker_thread+0x15e/0x450
[ 5444.185422]  [<ffffffff8107a9d0>] ? flush_delayed_work+0x60/0x60
[ 5444.185430]  [<ffffffff8107fdd0>] kthread+0xc0/0xd0
[ 5444.185437]  [<ffffffff81010000>] ? ftrace_raw_event_xen_mmu_flush_tlb_others+0xa0/0xe0
[ 5444.185444]  [<ffffffff8107fd10>] ? kthread_create_on_node+0x120/0x120
[ 5444.185451]  [<ffffffff8161d6ec>] ret_from_fork+0x7c/0xb0
[ 5444.185457]  [<ffffffff8107fd10>] ? kthread_create_on_node+0x120/0x120
[ 5444.185462] ---[ end trace 2d063ce11cec7f11 ]---

cheers,
daniel

