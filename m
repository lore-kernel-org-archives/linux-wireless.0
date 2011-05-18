Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:4573 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019Ab1ERUxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 16:53:20 -0400
Message-ID: <4DD431BD.9060801@gmail.com> (sfid-20110518_225323_385446_A1B58D30)
Date: Wed, 18 May 2011 22:53:17 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Marc Dietrich <marvin24@gmx.de>
CC: users@rt2x00.serialmonkey.com, Ivo van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH 5/7] rt2x00: Move rt2800_txdone andrt2800_txdone_entry_check
 to rt2800usb.
References: <201105182022.20341.IvDoorn@gmail.com> <201105182023.25912.IvDoorn@gmail.com> <201105182025.50070.IvDoorn@gmail.com> <201105182238.49341.marvin24@gmx.de>
In-Reply-To: <201105182238.49341.marvin24@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/18/11 22:38, Marc Dietrich wrote:
> 
> Hi, 
> 
> I tested the patches and got this during boot on a rt3070 chip:
> 
> [   14.173458] ------------[ cut here ]------------
> [   14.173482] WARNING: at /home/marc/ac100/marvin24s-kernel/kernel/softirq.c:159 local_bh_enable_ip+0x4c/0xcc()
> [   14.173490] Modules linked in: binfmt_misc snd_soc_tegra_paz00 snd_soc_alc5632 snd_soc_tegra_i2s snd_soc_tegra_pcm 
> snd_soc_tegra_das rt2800usb snd_soc_core snd_pcm_oss rt2800lib rt2x00usb snd_mixer_oss rt2x00lib snd_pcm mac80211 
> snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq cfg80211 snd_timer snd_seq_device uvcvideo rfkill cdc_acm snd 
> cdc_wdm videodev snd_soc_tegra_utils soundcore snd_page_alloc g_cdc btrfs
> [   14.173567] Backtrace:
> [   14.173607] [<c0043708>] (unwind_backtrace+0x0/0xe0) from [<c00753f8>] (warn_slowpath_common+0x4c/0x64)
> [   14.173628] [<c00753f8>] (warn_slowpath_common+0x4c/0x64) from [<c0075428>] (warn_slowpath_null+0x18/0x1c)
> [   14.173646] [<c0075428>] (warn_slowpath_null+0x18/0x1c) from [<c007bc80>] (local_bh_enable_ip+0x4c/0xcc)
> [   14.173676] [<c007bc80>] (local_bh_enable_ip+0x4c/0xcc) from [<bf40b9b4>] (rt2x00usb_interrupt_rxdone+0x30/0x70 
> [rt2x00usb])
> [   14.173723] [<bf40b9b4>] (rt2x00usb_interrupt_rxdone+0x30/0x70 [rt2x00usb]) from [<c02d9150>] 
> (usb_hcd_giveback_urb+0x74/0xbc)
> [   14.173752] [<c02d9150>] (usb_hcd_giveback_urb+0x74/0xbc) from [<c02e75f8>] (ehci_urb_done+0x90/0x9c)
> [   14.173775] [<c02e75f8>] (ehci_urb_done+0x90/0x9c) from [<c02eb284>] (qh_completions+0xb4/0x3ec)
> [   14.173795] [<c02eb284>] (qh_completions+0xb4/0x3ec) from [<c02ec4b8>] (ehci_work+0xb4/0x97c)
> [   14.173814] [<c02ec4b8>] (ehci_work+0xb4/0x97c) from [<c02ed3d0>] (ehci_irq+0x21c/0x24c)
> [   14.173830] [<c02ed3d0>] (ehci_irq+0x21c/0x24c) from [<c02d8b34>] (usb_hcd_irq+0x34/0x6c)
> [   14.173865] [<c02d8b34>] (usb_hcd_irq+0x34/0x6c) from [<c00bb840>] (handle_IRQ_event+0x9c/0x1b4)
> [   14.173884] [<c00bb840>] (handle_IRQ_event+0x9c/0x1b4) from [<c00bd4fc>] (handle_level_irq+0xd0/0x154)
> [   14.173910] [<c00bd4fc>] (handle_level_irq+0xd0/0x154) from [<c0037080>] (asm_do_IRQ+0x80/0xb4)
> [   14.173943] [<c0037080>] (asm_do_IRQ+0x80/0xb4) from [<c040d84c>] (__irq_svc+0x4c/0xe0)
> [   14.173954] Exception stack(0xdb84be10 to 0xdb84be58)
> [   14.173964] be00:                                     db929800 db28dc60 00000000 dcc00000
> [   14.173979] be20: db28dc60 dcd20000 00000000 00000010 db929800 00000008 00000010 db28dc98
> [   14.173991] be40: 00000000 db84be58 c026c86c c026ef58 60000013 ffffffff
> [   14.174027] [<c040d84c>] (__irq_svc+0x4c/0xe0) from [<c026ef58>] (cfb_imageblit+0x54/0x43c)
> [   14.174047] [<c026ef58>] (cfb_imageblit+0x54/0x43c) from [<c026c86c>] (soft_cursor+0x1a0/0x1a8)
> [   14.174065] [<c026c86c>] (soft_cursor+0x1a0/0x1a8) from [<c026c254>] (bit_cursor+0x41c/0x42c)
> [   14.174083] [<c026c254>] (bit_cursor+0x41c/0x42c) from [<c0266d08>] (fb_flashcursor+0xfc/0x118)
> [   14.174114] [<c0266d08>] (fb_flashcursor+0xfc/0x118) from [<c008c9a0>] (process_one_work+0x274/0x43c)
> [   14.174136] [<c008c9a0>] (process_one_work+0x274/0x43c) from [<c008e698>] (worker_thread+0x1b8/0x2b4)
> [   14.174159] [<c008e698>] (worker_thread+0x1b8/0x2b4) from [<c0091d5c>] (kthread+0x7c/0x84)
> [   14.174190] [<c0091d5c>] (kthread+0x7c/0x84) from [<c003d470>] (kernel_thread_exit+0x0/0x8)
> [   14.174202] ---[ end trace 7b2804cb6c2b13fe ]---
> 
> Of course, this didn't happen before.
> 

Hmm, OK. This is not caused by the patch you responded to, but it is indeed introduced by an other patch.
I have no idea how this has escaped my testing, as I did test the patches on USB devices as well, but there
seems to be exactly 1 instance in which the queue index spin lock is still used in IRQ context, which escaped
my attention.
So, patch 6 of the series should not be applied right now.

---
Gertjan
