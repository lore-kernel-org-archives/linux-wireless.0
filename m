Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:10411 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYECW3R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 18:29:17 -0400
Received: by nf-out-0910.google.com with SMTP id d3so879571nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 03 May 2008 15:29:13 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: multiqueue
Date: Sun, 4 May 2008 00:35:05 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805040035.05512.IvDoorn@gmail.com> (sfid-20080504_002848_961790_CE6EFE1C)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Below is a warning I get with your latest QOS patch series,
rt61pci registers 4 queues, but apparently the WARN_ON()
in ieee80211_wake_queue is being triggered.

void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
{
	struct ieee80211_local *local = hw_to_local(hw);

	if (netif_is_multiqueue(local->mdev)) {
		netif_wake_subqueue(local->mdev, queue);
	} else {
		WARN_ON(queue != 0);
		netif_wake_queue(local->mdev);
	}
}

CONFIG_MAC80211_QOS is enabled in the kernel configuration,
and debugfs shows that rt2x00 is serving frames over multiple
TX queues, so the multiqueue is working...

Ivo

May  4 00:27:20 localhost ------------[ cut here ]------------
May  4 00:27:20 localhost WARNING: at net/mac80211/util.c:334 ieee80211_wake_queue+0x51/0x5b [mac80211]()
May  4 00:27:20 localhost Modules linked in: snd_seq_midi snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_event snd_seq_midi_emul snd_seq snd_pcm_oss snd_mixer_oss snd_intel8x0 rt61pci rt2400pci rt2x00pci rt2x00lib snd_emu10k1 snd_rawmidi snd_ac97_codec mac80211 ac97_bus cfg80211 eeprom_93cx6 snd_pcm snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep snd scsi_wait_scan
May  4 00:27:20 localhost Pid: 0, comm: swapper Not tainted 2.6.25-wl-06940-gd91c42d #1
May  4 00:27:20 localhost
May  4 00:27:20 localhost Call Trace:
May  4 00:27:20 localhost <IRQ>  [<ffffffff802314d1>] warn_on_slowpath+0x51/0x63
May  4 00:27:20 localhost [<ffffffff804994eb>] skb_queue_tail+0x17/0x3f
May  4 00:27:20 localhost [<ffffffff8804f79c>] :mac80211:ieee80211_tx_status_irqsafe+0x10b/0x16b
May  4 00:27:20 localhost [<ffffffff880d4cc5>] :rt2x00lib:rt2x00lib_txdone+0xd5/0x10b
May  4 00:27:20 localhost [<ffffffff880d6867>] :rt2x00lib:rt2x00queue_index_inc+0x1a/0xa3
May  4 00:27:20 localhost [<ffffffff8806573a>] :mac80211:ieee80211_wake_queue+0x51/0x5b
May  4 00:27:20 localhost [<ffffffff880ef5b8>] :rt61pci:rt61pci_interrupt+0x2dd/0x340
May  4 00:27:20 localhost [<ffffffff80256164>] handle_IRQ_event+0x32/0x64
May  4 00:27:20 localhost [<ffffffff802577a6>] handle_fasteoi_irq+0x78/0xdd
May  4 00:27:20 localhost [<ffffffff8020e69d>] do_IRQ+0xa6/0x175
May  4 00:27:20 localhost [<ffffffff8020b691>] ret_from_intr+0x0/0xa
May  4 00:27:20 localhost [<ffffffff8020a21a>] default_idle+0x31/0x55
May  4 00:27:20 localhost [<ffffffff80236a98>] __do_softirq+0x51/0xd4
May  4 00:27:20 localhost [<ffffffff8020c30c>] call_softirq+0x1c/0x30
May  4 00:27:20 localhost [<ffffffff8020e417>] do_softirq+0x30/0x6b
May  4 00:27:20 localhost [<ffffffff8021bf26>] smp_apic_timer_interrupt+0x6e/0xa8
May  4 00:27:20 localhost [<ffffffff8020bdb6>] apic_timer_interrupt+0x66/0x70
May  4 00:27:20 localhost <EOI>  [<ffffffff8020a21a>] default_idle+0x31/0x55
May  4 00:27:20 localhost [<ffffffff8020a215>] default_idle+0x2c/0x55
May  4 00:27:20 localhost [<ffffffff8020a1e9>] default_idle+0x0/0x55
May  4 00:27:20 localhost [<ffffffff8020a286>] cpu_idle+0x48/0x8b
May  4 00:27:20 localhost
May  4 00:27:20 localhost ---[ end trace b92f992a457f49f1 ]---
