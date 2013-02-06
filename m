Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:50886 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab3BFNQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 08:16:20 -0500
Received: by mail-oa0-f49.google.com with SMTP id j6so1434755oag.22
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2013 05:16:20 -0800 (PST)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 6 Feb 2013 18:45:59 +0530
Message-ID: <CABPxzY+vJ29+8DuJSRJK9Vxa31XTT8BvEsuw3SE5+KGBJkGS3g@mail.gmail.com> (sfid-20130206_141625_233039_DAB5DB84)
Subject: Warning and DMA timeout in ath9k
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

While testing the AMSDU patch and trying to send a AMSDU with each
MSDU 2000 bytes and 3 MSDU's in AMSDU
observed that the DMA engine times out and causes the below warning.
This might be due to a large frame being
trasnferred.

Tried to check the maximum supported frame by ath9k, but couldnt get.
In the Rx side the max skb size is as below (2K=2304).
        common->rx_bufsize = IEEE80211_MAX_MPDU_LEN / 2 +
                             sc->sc_ah->caps.rx_status_len;

What is the maximum skb size we can transmit with ath9k PCIe?

Regards,
Chaitanya TK.

Log:


Feb  5 17:28:39 chaitanya-desktop kernel: [12465.510576]
ieee80211_if_parse_send_amsdu: 525 Allocaked SKB size of 8192 Bytes:
tailRoom: 16128 bytes and 0 HeadRoom
Feb  5 17:28:39 chaitanya-desktop kernel: [12465.510578]
ieee80211_if_parse_send_amsdu: 531 Creating the Header and Filling it:
VIF Type: 2
Feb  5 17:28:39 chaitanya-desktop kernel: [12465.510581]
ieee80211_if_parse_send_amsdu: 561 Creating the AMSDU Header and
Filling it
Feb  5 17:28:39 chaitanya-desktop kernel: [12465.510583]
ieee80211_if_parse_send_amsdu: 574 Creating the MSDU : 0 Header:
TailRoom: 16102
Feb  5 17:28:39 chaitanya-desktop kernel: [12465.510587]
ieee80211_if_parse_send_amsdu: 604 Appening the MSDU to the AMSDU=>
Main SKB
Feb  5 17:28:39 chaitanya-desktop kernel: [12465.510591]
ieee80211_if_parse_send_amsdu: 574 Creating the MSDU : 1 Header:
TailRoom: 14078
Feb  5 17:28:39 chaitanya-desktop kernel: [12465.510594]
ieee80211_if_parse_send_amsdu: 604 Appening the MSDU to the AMSDU=>
Main SKB
Feb  5 17:28:39 chaitanya-desktop kernel: [12465.510598]
ieee80211_if_parse_send_amsdu: 574 Creating the MSDU : 2 Header:
TailRoom: 12054
Feb  5 17:28:39 chaitanya-desktop kernel: [12465.510601]
ieee80211_if_parse_send_amsdu: 604 Appening the MSDU to the AMSDU=>
Main SKB
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716184] ath: phy0:
DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
DMADBG_7=0x000062c0
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716190] ath: phy0:
Could not stop RX, we could be confusing the DMA engine when we start
RX up
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716192] ------------[
cut here ]------------
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716202] WARNING: at
drivers/net/wireless/ath/ath9k/recv.c:497 ath_stoprecv+0xfa/0x110
[ath9k]()
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716204] Hardware name:
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716206] Modules
linked in: ath9k(O) mac80211(O) ath9k_common(O) ath9k_hw(O) ath(O)
cfg80211(O) arc4 i915 drm_kms_helper coretemp drm
snd_hda_codec_realtek snd_hda_intel snd_hda_codec hid_generic usbhid
kvm snd_hwdep snd_pcm lpc_ich snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd hid soundcore
snd_page_alloc i2c_algo_bit video serio_raw microcode binfmt_misc
r8169 [last unloaded: cfg80211]
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716249] Pid: 7973,
comm: kworker/u:2 Tainted: G           O 3.8.0-rc1+ #5
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716252] Call Trace:
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716261]  [<c1038b92>]
warn_slowpath_common+0x72/0xa0
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716269]  [<f846c9aa>]
? ath_stoprecv+0xfa/0x110 [ath9k]
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716276]  [<f846c9aa>]
? ath_stoprecv+0xfa/0x110 [ath9k]
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716281]  [<c1038be2>]
warn_slowpath_null+0x22/0x30
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716288]  [<f846c9aa>]
ath_stoprecv+0xfa/0x110 [ath9k]
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716295]  [<f8468bfa>]
ath_prepare_reset+0x5a/0xd0 [ath9k]
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716301]  [<f84692ca>]
ath_reset_internal+0x6a/0x1a0 [ath9k]
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716307]  [<c102d298>]
? default_spin_lock_flags+0x8/0x10
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716314]  [<c159473d>]
? _raw_spin_lock_irqsave+0x2d/0x40
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716320]  [<f84698a5>]
ath_reset+0x25/0xb0 [ath9k]
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716327]  [<f846b957>]
ath_reset_work+0x17/0x20 [ath9k]
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716333]  [<c1053c60>]
process_one_work+0x110/0x380
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716337]  [<c1594d00>]
? apic_timer_interrupt+0x34/0x3c
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716344]  [<f846b940>]
? ath9k_tasklet+0x160/0x160 [ath9k]
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716348]  [<c1054699>]
worker_thread+0x119/0x350
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716352]  [<c1054580>]
? manage_workers+0x260/0x260
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716356]  [<c1058e34>]
kthread+0x94/0xa0
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716362]  [<c1060000>]
? prepare_exec_creds+0x40/0x40
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716367]  [<c159b737>]
ret_from_kernel_thread+0x1b/0x28
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716371]  [<c1058da0>]
? flush_kthread_worker+0x90/0x90
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.716374] ---[ end
trace f9ddbedd51424709 ]---
Feb  5 17:28:40 chaitanya-desktop kernel: [12466.723551] ath: phy0:
Failed to stop TX DMA, queues=0x001!
Feb  5 17:28:41 chaitanya-desktop kernel: [12467.504819] ath: phy0:
DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
DMADBG_7=0x00026040
Feb  5 17:28:41 chaitanya-desktop kernel: [12467.504825] ath: phy0:
Could not stop RX, we could be confusing the DMA engine when we start
RX up
Feb  5 17:28:41 chaitanya-desktop kernel: [12467.511965] ath: phy0:
Failed to stop TX DMA, queues=0x001!
Feb  5 17:28:41 chaitanya-desktop kernel: [12467.514097] cfg80211: All
devices are disconnected, going to restore regulatory settings
Feb  5 17:28:41 chaitanya-desktop kernel: [12467.514100] cfg80211:
Restoring regulatory settings
Feb  5 17:28:41 chaitanya-desktop kernel: [12467.514102] cfg80211:
Kicking the queue
Feb  5 17:28:41 chaitanya-desktop kernel: [12467.514106] cfg80211:
Calling CRDA to update world regulatory domain
Feb  5 17:28:41 chaitanya-desktop kernel: [12467.517416] cfg80211:
Updating information on frequency 2412 MHz with regulatory rule:
Feb  5 17:28:41 chaitanya-desktop kernel: [12467.517419] cfg80211:
2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Feb  5 17:28:41 chaitanya-desktop kernel: [12467.517420] cfg80211:
Updating information on frequency 2417 MHz with regulatory rule:
