Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:36680 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754024AbcI3HXF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 03:23:05 -0400
Received: by mail-qk0-f172.google.com with SMTP id z190so99295133qkc.3
        for <linux-wireless@vger.kernel.org>; Fri, 30 Sep 2016 00:23:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57ED2982.4020002@candelatech.com>
References: <CAHdg3xa-mJpxZiDHC0NbaZT1PwnhnCbs2zjZiQbKdSCpHepcSw@mail.gmail.com>
 <57ED2982.4020002@candelatech.com>
From: Matteo Grandi <iu5bdp@gmail.com>
Date: Fri, 30 Sep 2016 09:23:04 +0200
Message-ID: <CAHdg3xa8g3hGhC2SdrnYNAwVtGT+kSuQGOm+WO4PO6Wa_V3p3Q@mail.gmail.com> (sfid-20160930_092309_811662_0291DE01)
Subject: Re: ath10k stuck on 6Mbps and spam syslog
To: Ben Greear <greearb@candelatech.com>
Cc: LinuxWireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Ben,
Thank you for your reply.
The fact that stock ath10k firmware does not report tx-rate explains
why the station dump shows 6Mbps but the iperf test reach 14.6 (even
if it is really under the expected data rate...).
About the syslog spam, this is the code of the function that seems to
cause the error (I put a comment at line 2621 side). (The warning
start to spam as soon as I assign the channel "iw dev <if_name> set
channel <ch_number>)

/**
 * ieee80211_calculate_rx_timestamp - calculate timestamp in frame
 * @local: mac80211 hw info struct
 * @status: RX status
 * @mpdu_len: total MPDU length (including FCS)
 * @mpdu_offset: offset into MPDU to calculate timestamp at
 *
 * This function calculates the RX timestamp at the given MPDU offset, taking
 * into account what the RX timestamp was. An offset of 0 will just normalize
 * the timestamp to TSF at beginning of MPDU reception.
 */
u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
    struct ieee80211_rx_status *status,
    unsigned int mpdu_len,
    unsigned int mpdu_offset)
{
u64 ts = status->mactime;
struct rate_info ri;
u16 rate;

if (WARN_ON(!ieee80211_have_rx_timestamp(status)))    //this is the
line 2621 reported in the warning
return 0;

memset(&ri, 0, sizeof(ri));

/* Fill cfg80211 rate info */
if (status->flag & RX_FLAG_HT) {
ri.mcs = status->rate_idx;
ri.flags |= RATE_INFO_FLAGS_MCS;
if (status->flag & RX_FLAG_40MHZ)
ri.bw = RATE_INFO_BW_40;
else
ri.bw = RATE_INFO_BW_20;
if (status->flag & RX_FLAG_SHORT_GI)
ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
} else if (status->flag & RX_FLAG_VHT) {
ri.flags |= RATE_INFO_FLAGS_VHT_MCS;
ri.mcs = status->rate_idx;
ri.nss = status->vht_nss;
if (status->flag & RX_FLAG_40MHZ)
ri.bw = RATE_INFO_BW_40;
else if (status->vht_flag & RX_VHT_FLAG_80MHZ)
ri.bw = RATE_INFO_BW_80;
else if (status->vht_flag & RX_VHT_FLAG_160MHZ)
ri.bw = RATE_INFO_BW_160;
else
ri.bw = RATE_INFO_BW_20;
if (status->flag & RX_FLAG_SHORT_GI)
ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
} else {
struct ieee80211_supported_band *sband;
int shift = 0;
int bitrate;

if (status->flag & RX_FLAG_10MHZ) {
shift = 1;
ri.bw = RATE_INFO_BW_10;
} else if (status->flag & RX_FLAG_5MHZ) {
shift = 2;
ri.bw = RATE_INFO_BW_5;
} else {
ri.bw = RATE_INFO_BW_20;
}

sband = local->hw.wiphy->bands[status->band];
bitrate = sband->bitrates[status->rate_idx].bitrate;
ri.legacy = DIV_ROUND_UP(bitrate, (1 << shift));
}

rate = cfg80211_calculate_bitrate(&ri);
if (WARN_ONCE(!rate,
     "Invalid bitrate: flags=0x%x, idx=%d, vht_nss=%d\n",
     status->flag, status->rate_idx, status->vht_nss))
return 0;

/* rewind from end of MPDU */
if (status->flag & RX_FLAG_MACTIME_END)
ts -= mpdu_len * 8 * 10 / rate;

ts += mpdu_offset * 8 * 10 / rate;
/* [SESAME] I2CAT. dbg*/
//printk(KERN_DEBUG "calculate_rx_timestamp: ts = %lu;\t rate =
%lu;\tmpdu_offset = %lu;\tmpdu_len = %lu\n",
// (long unsigned int) ts, (long unsigned int) rate, (long unsigned
int) mpdu_offset, (long unsigned int) mpdu_len );

return ts;
}

Thank you so much!

All the best

Matteo


2016-09-29 16:47 GMT+02:00 Ben Greear <greearb@candelatech.com>:
> stock ath10k firmware does not report tx-rate so the kernel always sees
> 6Mbps.
>
> I don't know about the splat..maybe post the function
> that is causing that?
>
> /home/matteo/linux-imx6/backports4.4.2-i2CAT/net/mac80211/util.c:2621
>
> Thanks,
> Ben
>
>
> On 09/29/2016 06:39 AM, Matteo Grandi wrote:
>>
>> Hello all,
>>
>> I'm struggling with a problem related on ath10k drivers:
>> I'm using a Compex WLE600V5-27 (802.11ac) miniPCIe card for some HT
>> tests needed for my thesis.
>> I'm using ath10k drivers for this card, and backports-4.4.2, in
>> particular the firmware-5.bin_10.2.4.70.54 because it seem to be the
>> more recent.
>> I've connected in mesh mode the WLE600V5 card with an 802.11n card
>> (using ath9k drivers) but looking at the station dump, the tx bitrate
>> is stuck on 6.0 Mbit/s for the ath10k. The ath9k one works well and
>> watch -n1 iw <interfacename> station dump
>> let me see changes of the tx rate and MCS on the ath9k during iperf
>> tests, but the ath10k stucks on 6.0 Mbit/s.
>>
>> Then something misterious (for me) happen while the channel
>> assignment: the syslog is spammed by this message:
>>
>> [17554.919459] ------------[ cut here ]------------
>> [17554.919839] WARNING: CPU: 0 PID: 0 at
>> /home/matteo/linux-imx6/backports4.4.2-i2CAT/net/mac80211/util.c:2621
>> ieee80211_calculate_rx_timestamp+0x204/0x278 [mac80211]()
>> [17554.919855] Modules linked in: arc4 sky2 ath10k_pci(O)
>> ath10k_core(O) ath(O) mac80211(O) cfg80211(O) compat(O)
>> [17554.919926] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W  O
>> 3.14.48-g408ccb9 #4
>> [17554.919990] [<80015050>] (unwind_backtrace) from [<80011330>]
>> (show_stack+0x10/0x14)
>> [17554.920038] [<80011330>] (show_stack) from [<806537dc>]
>> (dump_stack+0x80/0x90)
>> [17554.920074] [<806537dc>] (dump_stack) from [<8002c578>]
>> (warn_slowpath_common+0x6c/0x88)
>> [17554.920103] [<8002c578>] (warn_slowpath_common) from [<8002c630>]
>> (warn_slowpath_null+0x1c/0x24)
>> [17554.920377] [<8002c630>] (warn_slowpath_null) from [<7f089c74>]
>> (ieee80211_calculate_rx_timestamp+0x204/0x278 [mac80211])
>> [17554.920826] [<7f089c74>] (ieee80211_calculate_rx_timestamp
>> [mac80211]) from [<7f07d724>] (ieee80211_rx_napi+0xcc/0x8d4
>> [mac80211])
>> [17554.921259] [<7f07d724>] (ieee80211_rx_napi [mac80211]) from
>> [<7f117fd0>] (ath10k_wmi_event_mgmt_rx+0x1f4/0x35c [ath10k_core])
>> [17554.921540] [<7f117fd0>] (ath10k_wmi_event_mgmt_rx [ath10k_core])
>> from [<7f10d844>] (ath10k_htc_rx_completion_handler+0x1cc/0x464
>> [ath10k_core])
>> [17554.921706] [<7f10d844>] (ath10k_htc_rx_completion_handler
>> [ath10k_core]) from [<7f157b4c>] (ath10k_pci_process_rx_cb+0x1ac/0x1fc
>> [ath10k_pci])
>> [17554.921773] [<7f157b4c>] (ath10k_pci_process_rx_cb [ath10k_pci])
>> from [<7f15b3ac>] (ath10k_ce_per_engine_service+0x5c/0x94
>> [ath10k_pci])
>> [17554.921835] [<7f15b3ac>] (ath10k_ce_per_engine_service
>> [ath10k_pci]) from [<7f15b464>]
>> (ath10k_ce_per_engine_service_any+0x80/0x88 [ath10k_pci])
>> [17554.921892] [<7f15b464>] (ath10k_ce_per_engine_service_any
>> [ath10k_pci]) from [<7f15a6d8>] (ath10k_pci_tasklet+0x24/0x5c
>> [ath10k_pci])
>> [17554.921946] [<7f15a6d8>] (ath10k_pci_tasklet [ath10k_pci]) from
>> [<800304c8>] (tasklet_action+0x80/0x110)
>> [17554.921979] [<800304c8>] (tasklet_action) from [<800306b8>]
>> (__do_softirq+0x10c/0x248)
>> [17554.922009] [<800306b8>] (__do_softirq) from [<80030a6c>]
>> (irq_exit+0xac/0xf4)
>> [17554.922042] [<80030a6c>] (irq_exit) from [<8000e904>]
>> (handle_IRQ+0x44/0x90)
>> [17554.922072] [<8000e904>] (handle_IRQ) from [<800084f8>]
>> (gic_handle_irq+0x2c/0x5c)
>> [17554.922105] [<800084f8>] (gic_handle_irq) from [<80011e00>]
>> (__irq_svc+0x40/0x50)
>> [17554.922122] Exception stack(0x80917f18 to 0x80917f60)
>> [17554.922141] 7f00:
>>      80917f60 000d3334
>> [17554.922166] 7f20: 5221e106 00000ff7 4d693c44 00000ff7 a7705010
>> 80924060 00000001 a7705014
>> [17554.922190] 7f40: 8096243d 80916000 00000017 80917f60 a6aaaaab
>> 80492940 60000013 ffffffff
>> [17554.922224] [<80011e00>] (__irq_svc) from [<80492940>]
>> (cpuidle_enter_state+0x50/0xe0)
>> [17554.922252] [<80492940>] (cpuidle_enter_state) from [<80492ac8>]
>> (cpuidle_idle_call+0xf8/0x148)
>> [17554.922281] [<80492ac8>] (cpuidle_idle_call) from [<8000ec48>]
>> (arch_cpu_idle+0x8/0x44)
>> [17554.922322] [<8000ec48>] (arch_cpu_idle) from [<80066648>]
>> (cpu_startup_entry+0xfc/0x140)
>> [17554.922362] [<80066648>] (cpu_startup_entry) from [<808c5b08>]
>> (start_kernel+0x360/0x36c)
>> [17554.922379] ---[ end trace 87d4775146813aed ]---
>> [17555.943454] ------------[ cut here ]------------
>>
>> that repeat continuously...
>> Forcing legacy bitrates doesn't change the situation.
>>
>> I made some measurements using iperf, please find it in attachment.
>>
>> Other info:
>>
>> root@Yazi:~# modinfo ath10k_pci
>> filename:
>>
>> /lib/modules/3.14.48-g408ccb9/kernel/drivers/net/wireless/ath/ath10k/ath10k_pci.ko
>> firmware:       ath10k/QCA9377/hw1.0/board.bin
>> firmware:       ath10k/QCA9377/hw1.0/firmware-5.bin
>> firmware:       ath10k/QCA6174/hw3.0/board-2.bin
>> firmware:       ath10k/QCA6174/hw3.0/board.bin
>> firmware:       ath10k/QCA6174/hw3.0/firmware-5.bin
>> firmware:       ath10k/QCA6174/hw3.0/firmware-4.bin
>> firmware:       ath10k/QCA6174/hw2.1/board-2.bin
>> firmware:       ath10k/QCA6174/hw2.1/board.bin
>> firmware:       ath10k/QCA6174/hw2.1/firmware-5.bin
>> firmware:       ath10k/QCA6174/hw2.1/firmware-4.bin
>> firmware:       ath10k/QCA988X/hw2.0/board-2.bin
>> firmware:       ath10k/QCA988X/hw2.0/board.bin
>> firmware:       ath10k/QCA988X/hw2.0/firmware-5.bin
>> firmware:       ath10k/QCA988X/hw2.0/firmware-4.bin
>> firmware:       ath10k/QCA988X/hw2.0/firmware-3.bin
>> firmware:       ath10k/QCA988X/hw2.0/firmware-2.bin
>> firmware:       ath10k/QCA988X/hw2.0/firmware.bin
>> license:        Dual BSD/GPL
>> description:    Driver support for Atheros QCA988X PCIe devices
>> author:         Qualcomm Atheros
>> version:        backported from Linux (v4.4.2-0-g1cb8570) using
>> backports v4.4.2-1-0-gbec4037
>> srcversion:     EBB3D4E36DE49B7EC8057D0
>> alias:          pci:v0000168Cd00000042sv*sd*bc*sc*i*
>> alias:          pci:v0000168Cd00000040sv*sd*bc*sc*i*
>> alias:          pci:v0000168Cd0000003Esv*sd*bc*sc*i*
>> alias:          pci:v0000168Cd00000041sv*sd*bc*sc*i*
>> alias:          pci:v0000168Cd0000003Csv*sd*bc*sc*i*
>> depends:        ath10k_core,compat
>> vermagic:       3.14.48-g408ccb9 SMP mod_unload modversions ARMv7 p2v8
>> parm:           irq_mode:0: auto, 1: legacy, 2: msi (default: 0) (uint)
>> parm:           reset_mode:0: auto, 1: warm only (default: 0) (uint)
>>
>> I don't know if it's only a problem of iw station dump that can't show
>> the tx rate, but the spammed syslog honestly warn me...
>>
>> How shall I check what's wrong and see the HT work?
>>
>> Thanks a lot!
>>
>> Matteo
>>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
