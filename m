Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:39725 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbZHLQqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 12:46:11 -0400
Received: by yxe5 with SMTP id 5so188396yxe.33
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 09:46:12 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 12 Aug 2009 09:45:52 -0700
Message-ID: <43e72e890908120945l14f6590ev38f7083a1b1dae8@mail.gmail.com>
Subject: ath5k warning on bitrate
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Bob Copeland <me@bobcopeland.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have some patches on top of this for ath5k but I doubt they were the
culprit. The warning comes from the second check:

static inline int
ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix)
{
        int rix;

        /* return base rate on errors */
        if (WARN(hw_rix < 0 || hw_rix >= AR5K_MAX_RATES,
                        "hw_rix out of bounds: %x\n", hw_rix))
                return 0;

        rix = sc->rate_idx[sc->curband->band][hw_rix];
        if (WARN(rix < 0, "invalid hw_rix: %x\n", hw_rix))
                rix = 0;

        return rix;
}


[  402.717626] ath5k phy0: noise floor calibration timeout (2462MHz)
[ 1443.232473] ------------[ cut here ]------------
[ 1443.232473] WARNING: at drivers/net/wireless/ath/ath5k/base.c:1140
ath5k_tasklet_rx+0x562/0x670 [ath5k]()
[ 1443.232473] Hardware name: 7660A14
[ 1443.232473] invalid hw_rix: 1b
[ 1443.232473] Modules linked in: aes_generic binfmt_misc ppdev bridge
stp bnep kvm_intel kvm lp parport snd_hda_codec_analog joydev arc4 ecb
snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm ath5k
pcmcia snd_seq_dummy mac80211 ath snd_seq_oss snd_seq_midi_event
thinkpad_acpi yenta_socket psmouse cfg80211 rsrc_nonstatic pcspkr
snd_seq nvram serio_raw led_class pcmcia_core btusb snd_timer
snd_seq_device snd soundcore snd_page_alloc ohci1394 ieee1394 e1000e
fbcon tileblit font bitblit softcursor i915 drm i2c_algo_bit video
output intel_agp
[ 1443.232473] Pid: 0, comm: swapper Not tainted 2.6.31-rc5-wl #129
[ 1443.232473] Call Trace:
[ 1443.232473]  <IRQ>  [<ffffffff81057398>] warn_slowpath_common+0x78/0xb0
[ 1443.232473]  [<ffffffff8105742c>] warn_slowpath_fmt+0x3c/0x40
[ 1443.232473]  [<ffffffffa026be22>] ath5k_tasklet_rx+0x562/0x670 [ath5k]
[ 1443.232473]  [<ffffffff810313b9>] ? default_spin_lock_flags+0x9/0x10
[ 1443.232473]  [<ffffffff8105ca20>] tasklet_action+0xd0/0xe0
[ 1443.232473]  [<ffffffff8105dd4d>] __do_softirq+0xbd/0x200
[ 1443.232473]  [<ffffffff8101308c>] call_softirq+0x1c/0x30
[ 1443.232473]  [<ffffffff81014805>] do_softirq+0x55/0x90
[ 1443.232473]  [<ffffffff8105dab5>] irq_exit+0x85/0x90
[ 1443.232473]  [<ffffffff81013f80>] do_IRQ+0x70/0xe0
[ 1443.232473]  [<ffffffff810128d3>] ret_from_intr+0x0/0x11
[ 1443.232473]  <EOI>  [<ffffffff812c256a>] ? acpi_idle_enter_bm+0x28b/0x2bf
[ 1443.232473]  [<ffffffff812c2563>] ? acpi_idle_enter_bm+0x284/0x2bf
[ 1443.232473]  [<ffffffff813e088b>] ? cpuidle_idle_call+0x9b/0xf0
[ 1443.232473]  [<ffffffff81010e12>] ? cpu_idle+0xb2/0x100
[ 1443.232473]  [<ffffffff814e819b>] ? start_secondary+0x18e/0x193
[ 1443.232473] ---[ end trace 95c5af437c1ab783 ]---
