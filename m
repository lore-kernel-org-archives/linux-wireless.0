Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43053 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbcFPLMd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 07:12:33 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "johnsgruber@gmail.com" <johnsgruber@gmail.com>
CC: Miaoqing Pan <miaoqing@codeaurora.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ATH9K warnings from commit b2d70d494
Date: Thu, 16 Jun 2016 11:12:27 +0000
Message-ID: <87ziqlpeue.fsf@qca.qualcomm.com> (sfid-20160616_131239_177144_18B32F42)
References: <CAPotdmQA6qwbUD9g7BLc_ad3VZ57y4FX_6UJ3ibMovC7Kaa4TA@mail.gmail.com>
In-Reply-To: <CAPotdmQA6qwbUD9g7BLc_ad3VZ57y4FX_6UJ3ibMovC7Kaa4TA@mail.gmail.com>
	(johnsgruber@gmail.com's message of "Wed, 15 Jun 2016 16:14:19 -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Adding linux-wireless)

johnsgruber@gmail.com writes:

> I'm getting many warning stack traces fom the above--at least two every 5
> seconds whether or not connected via wireless.
>
> Samples are below.
>
> On further investigation I see that for each of the pair gpio = 11, for
> the first ah->caps.num_gpio_pins = 10 and for the second BIT(gpio) = 0x800
> and ah->caps.gpio_mask = 0x3ff.
>
> I gather this is unexpected, but it seems like some limit on output is in order.
>
> If you can't reproduce this situation on your own systems please let me know
> if you would like me to gather more information for you on the basic problem,
> test, etc.

Kernel seems to be 4.7-rc3, but what chip? Maybe AR9462 or AR9565?

> Jun 15 07:55:13 gruber-ubuntu-acer kernel: [193389.532500] ---[ end
> trace c25c9fdececff7b3 ]---
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523554]
> ------------[ cut here ]------------
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523567] WARNING:
> CPU: 2 PID: 17657 at drivers/net/wireless/ath/ath9k/hw.c:2776
> ath9k_hw_gpio_get+0x1a9/0x1b0 [ath9k_hw]
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523568] Modules
> linked in: ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat
> nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
> nf_conntrack ipt_REJECT nf_reject_ipv4 xt_CHECKSUM iptable_mangle
> xt_tcpudp bridge stp llc ip6table_filter ip6_tables iptable_filter
> ip_tables ebtable_nat ebtables x_tables cmac bnep rfcomm binfmt_misc
> nls_iso8859_1 usblp arc4 ath9k snd_hda_codec_hdmi uvcvideo
> ath9k_common ath9k_hw i915 x86_pkg_temp_thermal intel_powerclamp
> coretemp kvm_intel snd_usb_audio snd_hda_codec_realtek
> videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 kvm ath
> videobuf2_core snd_hda_codec_generic videodev mac80211 snd_hda_intel
> snd_hda_codec snd_hda_core ath3k snd_usbmidi_lib joydev rtsx_usb btusb
> irqbypass btrtl crc32_pclmul snd_hwdep ghash_clmulni_intel btbcm
> snd_pcm btintel bluetooth drm_kms_helper cfg80211 aesni_intel
> snd_seq_midi snd_seq_midi_event aes_x86_64 drm lrw snd_rawmidi snd_seq
> glue_helper ablk_helper cryptd intel_cstate snd_seq_device intel_rapl
> snd_timer snd i2c_algo_bit fb_sys_fops syscopyarea mei_me mei
> sysfillrect sysimgblt soundcore serio_raw shpchp wmi lpc_ich
> parport_pc ppdev lp video mac_hid parport hid_generic usbhid hid
> psmouse r8169 mii fjes
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523613] CPU: 2 PID:
> 17657 Comm: kworker/u8:0 Tainted: G        W       4.7.0-rc3 #1
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523614] Hardware
> name: Acer Aspire TC-605/Aspire TC-605, BIOS P11-A2 11/08/2013
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523618] Workqueue:
> events_power_efficient rfkill_poll
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523620]
> 0000000000000000 ffff88003ed37d28 ffffffff813888ec 0000000000000000
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523621]
> 0000000000000000 ffff88003ed37d68 ffffffff81061311 00000ad800000082
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523623]
> ffff8800d28ec018 000000000000000b ffff8800d28f0720 0000000000000100
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523625] Call Trace:
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523629]
> [<ffffffff813888ec>] dump_stack+0x63/0x87
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523633]
> [<ffffffff81061311>] __warn+0xd1/0xf0
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523634]
> [<ffffffff810613fd>] warn_slowpath_null+0x1d/0x20
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523639]
> [<ffffffffa096ab19>] ath9k_hw_gpio_get+0x1a9/0x1b0 [ath9k_hw]
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523642]
> [<ffffffffa06293e4>] ath9k_rfkill_poll_state+0x34/0x60 [ath9k]
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523656]
> [<ffffffffa046bb53>] ieee80211_rfkill_poll+0x33/0x40 [mac80211]
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523665]
> [<ffffffffa02c45fa>] cfg80211_rfkill_poll+0x2a/0xc0 [cfg80211]
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523667]
> [<ffffffff817a4d24>] rfkill_poll+0x24/0x50
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523670]
> [<ffffffff81078aa3>] process_one_work+0x153/0x400
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523672]
> [<ffffffff8107926b>] worker_thread+0x12b/0x4b0
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523674]
> [<ffffffff81079140>] ? rescuer_thread+0x340/0x340
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523676]
> [<ffffffff8107e4d9>] kthread+0xc9/0xe0
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523678]
> [<ffffffff817ba23f>] ret_from_fork+0x1f/0x40
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523679]
> [<ffffffff8107e410>] ? kthread_park+0x60/0x60
> Jun 15 07:55:18 gruber-ubuntu-acer kernel: [193394.523681] ---[ end
> trace c25c9fdececff7b4 ]---

Does this patch help:

ath9k: fix GPIO mask for AR9462 and AR9565ath-current

https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=ath-current&id=e024111f6946f45cf1559a8c6fd48d2d0f696d07

-- 
Kalle Valo