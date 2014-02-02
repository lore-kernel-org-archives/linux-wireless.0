Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:65494 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaBBVOJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Feb 2014 16:14:09 -0500
Received: by mail-we0-f180.google.com with SMTP id u57so1444890wes.25
        for <linux-wireless@vger.kernel.org>; Sun, 02 Feb 2014 13:14:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJwzM1kzbvy7UnjJerJ8EmUxvp5GYPeKS-9988SgxfoQrv-Zjw@mail.gmail.com>
References: <CAAUTuq_bgXcfKquXR+ATumO7xkyTE_WLUvUOMZ7bPYCP0_XnuQ@mail.gmail.com>
 <CAJwzM1kzbvy7UnjJerJ8EmUxvp5GYPeKS-9988SgxfoQrv-Zjw@mail.gmail.com>
From: Andrew Wiley <wiley.andrew.j@gmail.com>
Date: Sun, 2 Feb 2014 15:13:48 -0600
Message-ID: <CAAUTuq_LnUCTBaHndBiLDk0ge+055YJJMY4Ni+bV7PrYq_KSHA@mail.gmail.com> (sfid-20140202_221414_984795_855B85DA)
Subject: Re: mwifiex and SD8787: TX queue timeout in AP mode
To: Avinash Patil <avinashapatil@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Avinash,

Here's one such log: http://www.cs.utexas.edu/users/wiley/mwifiexlog_1.txt

This was run with the WPA2 options uncommented in hostapd.conf. Pings
through the AP were successful for about 10 seconds after my test
machine joined the network. It looks like they started timing out at
about 150s in the kernel log, but `dmesg -w` seems to print messages
lazily, so it might be a bit later than that.

Let me know if there's something else I should try to capture.

Thanks,
Andrew

On Sun, Feb 2, 2014 at 1:45 AM, Avinash Patil <avinashapatil@gmail.com> wrote:
> Hi Andrew,
>
> It looks like AP_STA_DEAUTH command is timed out.
>
> Can you please enable dynamic debug and collect logs with attached change?
>
> 1. CONFIG_DYNAMIC_DEBUG=y in kernel .config and rebuild the kernel
> 2. Load the driver.
> 3. echo "module mwifiex +p" > /sys/kernel/debug/dynamic_debug/control
> 4. echo "module mwifiex_sdio +p" > /sys/kernel/debug/dynamic_debug/control
> 5. save the logs from dmesg after the test.
>
> Thanks,
> Avinash.
>
>
> On Sun, Feb 2, 2014 at 12:11 PM, Andrew Wiley <wiley.andrew.j@gmail.com> wrote:
>> Hello linux-wireless,
>>
>> I'm observing a consistent TX queue timeout with a SD8787 on a Marvell
>> Kirkwood-based Dreamplug running the mwifiex driver.
>>
>> In particular, with this hostapd config:
>> ====
>> interface=uap0
>> bridge=br0
>> driver=nl80211
>> logger_stdout=-1
>> logger_stdout_level=2
>> ssid=My Clever SSID
>> country_code=US
>> ieee80211d=1
>>
>> hw_mode=g
>> channel=4
>> auth_algs=3
>> max_num_sta=255
>>
>> #wpa=2
>> #wpa_passphrase=EvenClevererPassphrase
>> #wpa_key_mgmt=WPA-PSK
>> #wpa_pairwise=TKIP
>> #rsn_pairwise=CCMP
>> ====
>>
>> I see a hang within about an hour. If I uncomment the encryption
>> settings, the hang generally occurs a few seconds after my testing
>> laptop gets on the network (long enough for ~2 pings to return).
>> I did have one instance where, with encryption enabled, the network
>> stayed up for an hour or so, but I haven't managed to replicate it.
>>
>> The timeout consistently looks like this in the kernel log:
>> ====
>> [  922.826726] ------------[ cut here ]------------
>> [  922.831395] WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:264
>> dev_watchdog+0x2d0/0x2f0()
>> [  922.839897] NETDEV WATCHDOG: uap0 (mwifiex_sdio): transmit queue 1 timed out
>> [  922.846986] Modules linked in: iptable_raw ipt_MASQUERADE xt_nat
>> bridge iptable_nat nf_nat_ipv4 nf_nat stp llc iptable_mangle xt_policy
>> xt_tcpudp nf_conntrack_ipv6 nf_conntrack_ipv4 nf_defrag_ipv6
>> nf_defrag_ipv4 xt_conntrack nf_conntrack iptable_filter
>> ip6table_filter ip6_tables ip_tables x_tables hid_generic mwifiex_sdio
>> snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi mwifiex
>> snd_seq_device cfg80211 snd_pcm snd_page_alloc usbhid snd_timer snd
>> hid soundcore rfkill mv_cesa usbip_host(C) usbip_core(C) ipv6 autofs4
>> [  922.893323] CPU: 0 PID: 0 Comm: swapper Tainted: G         C
>> 3.13.0-2-ARCH #1
>> [  922.900698] [<c000ee04>] (unwind_backtrace+0x0/0xe8) from
>> [<c000c354>] (show_stack+0x10/0x14)
>> [  922.909285] [<c000c354>] (show_stack+0x10/0x14) from [<c001a780>]
>> (warn_slowpath_common+0x70/0x90)
>> [  922.918307] [<c001a780>] (warn_slowpath_common+0x70/0x90) from
>> [<c001a7d0>] (warn_slowpath_fmt+0x30/0x40)
>> [  922.927949] [<c001a7d0>] (warn_slowpath_fmt+0x30/0x40) from
>> [<c04aa51c>] (dev_watchdog+0x2d0/0x2f0)
>> [  922.937059] [<c04aa51c>] (dev_watchdog+0x2d0/0x2f0) from
>> [<c00258f8>] (call_timer_fn+0x30/0x170)
>> [  922.945903] [<c00258f8>] (call_timer_fn+0x30/0x170) from
>> [<c0025eb4>] (run_timer_softirq+0x1f8/0x368)
>> [  922.955187] [<c0025eb4>] (run_timer_softirq+0x1f8/0x368) from
>> [<c001ec00>] (__do_softirq+0xdc/0x304)
>> [  922.964384] [<c001ec00>] (__do_softirq+0xdc/0x304) from
>> [<c001f1a4>] (irq_exit+0xb0/0xf8)
>> [  922.972615] [<c001f1a4>] (irq_exit+0xb0/0xf8) from [<c0009c80>]
>> (handle_IRQ+0x34/0x84)
>> [  922.980585] [<c0009c80>] (handle_IRQ+0x34/0x84) from [<c052ef54>]
>> (__irq_svc+0x34/0x98)
>> [  922.988647] [<c052ef54>] (__irq_svc+0x34/0x98) from [<c043a638>]
>> (cpuidle_enter_state+0x5c/0xe8)
>> [  922.997494] [<c043a638>] (cpuidle_enter_state+0x5c/0xe8) from
>> [<c043a76c>] (cpuidle_idle_call+0xa8/0x248)
>> [  923.007120] [<c043a76c>] (cpuidle_idle_call+0xa8/0x248) from
>> [<c0009df8>] (arch_cpu_idle+0x8/0x44)
>> [  923.016128] [<c0009df8>] (arch_cpu_idle+0x8/0x44) from [<c0052aa0>]
>> (cpu_startup_entry+0xe8/0x218)
>> [  923.025152] [<c0052aa0>] (cpu_startup_entry+0xe8/0x218) from
>> [<c06fca1c>] (start_kernel+0x308/0x368)
>> [  923.034338] ---[ end trace 1f99f5bb6d86ce00 ]---
>> [  923.038991] mwifiex_sdio mmc0:0001:1: 61622 : Tx timeout(#1),
>> bss_type-num = 1-0
>> [  932.826851] mwifiex_sdio mmc0:0001:1: 62601 : Tx timeout(#2),
>> bss_type-num = 1-0
>> [  942.826950] mwifiex_sdio mmc0:0001:1: 63601 : Tx timeout(#3),
>> bss_type-num = 1-0
>> [  952.827043] mwifiex_sdio mmc0:0001:1: 64601 : Tx timeout(#4),
>> bss_type-num = 1-0
>> [  962.827135] mwifiex_sdio mmc0:0001:1: 65601 : Tx timeout(#5),
>> bss_type-num = 1-0
>> [  972.827204] mwifiex_sdio mmc0:0001:1: 66601 : Tx timeout(#6),
>> bss_type-num = 1-0
>> [  982.827274] mwifiex_sdio mmc0:0001:1: 67601 : Tx timeout(#7),
>> bss_type-num = 1-0
>> [  982.834710] mwifiex_sdio mmc0:0001:1: tx_timeout_cnt exceeds
>> threshold. Triggering card reset!
>> [  982.847311] mwifiex_sdio: Resetting card...
>> [  982.858835] mwifiex_sdio mmc0:0001:1: rx_pending=0, tx_pending=134,
>> cmd_pending=0
>> [  982.890370] br0: port 3(uap0) entered disabled state
>> [  982.927420] mwifiex_sdio mmc0:0001:1: PREP_CMD: card is removed
>> [  982.933379] ieee80211 phy0: Failed to delete mgmt IEs!
>> [  982.944768] mwifiex_sdio mmc0:0001:1: PREP_CMD: card is removed
>> [  982.954303] ieee80211 phy0: Failed to stop the BSS
>> [  982.965174] br0: port 3(uap0) entered disabled state
>> [  982.997332] device uap0 left promiscuous mode
>> [  983.002107] br0: port 3(uap0) entered disabled state
>> [  983.047777] mmc0: card 0001 removed
>> [  983.162307] mmc0: new high speed SDIO card at address 0001
>> [  994.467374] mwifiex_sdio mmc0:0001:1: FW failed to be active in time
>> <span class="sew7w4eq1wq2zww"><br></span>====
>>
>>
>> Firstly, I'm guessing there's more debug information to be had - is
>> there a flag I should be turning on to get some more useful output?
>> Would the hostapd debug output help?
>>
>> Secondly, I've never seen the card come back up after the driver
>> resets it. Does this normally work?
>>
>> Thirdly, if I try to kill hostapd after pings from my test machine
>> stop working but before the watchdog triggers, I get a kernel log that
>> looks like this:
>> ====
>> [  415.625875] mwifiex_sdio mmc0:0001:1: cmd_wait_q terminated: -512
>> [  417.554508] mwifiex_sdio mmc0:0001:1: cmd_wait_q terminated: -512
>> [  417.637845] mwifiex_sdio mmc0:0001:1: cmd_wait_q terminated: -512
>> [  420.831554] mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func:
>> Timeout cmd id (1391322753.261340) = 0xb5, act = 0x85c4
>> [  420.842426] mwifiex_sdio mmc0:0001:1: num_data_h2c_failure = 0
>> [  420.848289] mwifiex_sdio mmc0:0001:1: num_cmd_h2c_failure = 0
>> [  420.854075] mwifiex_sdio mmc0:0001:1: num_cmd_timeout = 1
>> [  420.859503] mwifiex_sdio mmc0:0001:1: num_tx_timeout = 0
>> [  420.864851] mwifiex_sdio mmc0:0001:1: last_cmd_index = 4
>> [  420.870184] mwifiex_sdio mmc0:0001:1: last_cmd_id: 28 00 5e 00 5e
>> 00 5e 00 b5 00
>> [  420.877626] mwifiex_sdio mmc0:0001:1: last_cmd_act: 93 00 01 00 01
>> 00 01 00 c4 85
>> [  420.885151] mwifiex_sdio mmc0:0001:1: last_cmd_resp_index = 3
>> [  420.890920] mwifiex_sdio mmc0:0001:1: last_cmd_resp_id: 28 80 5e 80
>> 5e 80 5e 80 b1 80
>> [  420.898798] mwifiex_sdio mmc0:0001:1: last_event_index = 3
>> [  420.904316] mwifiex_sdio mmc0:0001:1: last_event: 00 00 2e 00 44 00
>> 2d 00 00 00
>> [  420.911668] mwifiex_sdio mmc0:0001:1: data_sent=1 cmd_sent=1
>> [  420.917351] mwifiex_sdio mmc0:0001:1: ps_mode=1 ps_state=0
>> [  420.922875] mwifiex_sdio mmc0:0001:1: cmd timeout
>> [  420.930569] mwifiex_sdio: Resetting card...
>> [  420.950267] mwifiex_sdio mmc0:0001:1: rx_pending=0, tx_pending=3,
>> cmd_pending=0
>> [  420.997056] br0: port 3(uap0) entered disabled state
>> [  421.021696] mwifiex_sdio mmc0:0001:1: PREP_CMD: card is removed
>> [  421.027655] ieee80211 phy0: Failed to delete mgmt IEs!
>> [  421.037288] mwifiex_sdio mmc0:0001:1: PREP_CMD: card is removed
>> [  421.047313] ieee80211 phy0: Failed to stop the BSS
>> [  421.056754] br0: port 3(uap0) entered disabled state
>> [  421.091582] device uap0 left promiscuous mode
>> [  421.096165] br0: port 3(uap0) entered disabled state
>> [  421.143900] mmc0: card 0001 removed
>> [  421.236334] mmc0: new high speed SDIO card at address 0001
>> [  432.541163] mwifiex_sdio mmc0:0001:1: FW failed to be active in time
>> ====
>>
>> So it looks like the entire card is hanging, rather than just a queue
>> getting stuck?
>>
>> Some environment info:
>>
>> kernel is 3.13.0 with mwifiex and mwifiex_sdio built as modules
>> hostapd is v2.0
>> Dreamplug is a variant of the Guruplug, and my distro (Arch Linux ARM)
>> patches it into the Guruplug boardfile
>> (Dreamplug has a DTS in mainline, but not a boardfile. This is a
>> non-DTB kernel - the DTB kernel seems to have trouble with SDIO
>> interrupt handling)
>>
>> Thanks,
>> Andrew
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
