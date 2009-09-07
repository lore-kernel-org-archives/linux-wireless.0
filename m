Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:39662 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbZIGW2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2009 18:28:43 -0400
Received: by iwn42 with SMTP id 42so1045443iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2009 15:28:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890909071522i461ca821m703f6e2eeb2d0385@mail.gmail.com>
References: <20090907124548.GA5351@hash.localnet> <43e72e890909071522i461ca821m703f6e2eeb2d0385@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 7 Sep 2009 15:23:15 -0700
Message-ID: <43e72e890909071523q2994b123i15eb1b6991dc073a@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH/RFC] ath5k: clear rx queue on reset
To: Bob Copeland <me@bobcopeland.com>,
	Matt Smith <Matt.Smith@atheros.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 7, 2009 at 3:22 PM, Luis R. Rodriguez<lrodriguez@atheros.com> wrote:
> Cc'ing Matt just for his information.
>
> Note: this e-mail is on a public mailing list.
>
> On Mon, Sep 7, 2009 at 5:45 AM, Bob Copeland<me@bobcopeland.com> wrote:
>>
>> When changing channels or otherwise resetting the card, dump
>> any queued rx buffers so that we don't use the wrong channel
>> information when reporting the packets.  This should fix the
>> remaining instances of this warning:
>>
>> WARNING: at /build/buildd-linux-2.6_2.6.30-1-i386-06t6n0/linux-2.6-2.6.30/debian/build/source_i386_none/drivers/net/wireless/ath5k/base.c:1096 ath5k_hw_to_driver_rix+0x52/0x58 [ath5k]()
>> Hardware name: MacBook1,1
>> invalid hw_rix: 1b
>> Modules linked in: i915 drm i2c_algo_bit binfmt_misc uvcvideo videodev v4l1_compat btusb rfcomm l2cap bluetooth ppdev parport_pc lp parport acpi_cpufreq cpufreq_powersave cpufreq_conservative cpufreq_userspace cpufreq_stats ext4 jbd2 crc16 ext2 fuse arc4 ecb ath5k mac80211 cfg80211 firewire_sbp2 loop joydev applesmc led_class input_polldev snd_hda_codec_idt isight_firmware pcspkr i2c_i801 i2c_core rng_core appletouch evdev iTCO_wdt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device tpm_infineon tpm tpm_bios video output battery processor ac button snd soundcore snd_page_alloc intel_agp agpgart ext3 jbd mbcache usbhid dm_mirror dm_region_hash dm_log dm_snapshot dm_mod sd_mod crc_t10dif ide_cd_mod cdrom ata_piix ata_generic libata scsi_mod firewire_ohci firewire_core crc_itu_t ehci_hcd uhci_hcd ide_pci_generic piix ide_core sky2 usbcore thermal fan thermal_sys hid_apple hid
>> Pid: 5218, comm: euphoria Tainted: G        W  2.6.30-1-686 #1
>> Call Trace:
>>  [<c0126ff8>] ? warn_slowpath_common+0x5e/0x8a
>>  [<c0127056>] ? warn_slowpath_fmt+0x26/0x2a
>>  [<f86c139b>] ? ath5k_hw_to_driver_rix+0x52/0x58 [ath5k]
>>  [<f86c1899>] ? ath5k_tasklet_rx+0x2b7/0x42e [ath5k]
>>  [<c012e618>] ? __mod_timer+0xc9/0xd3
>>  [<c012abcf>] ? tasklet_action+0x63/0xa8
>>  [<c012b0d7>] ? __do_softirq+0x8e/0x135
>>  [<c012b1ac>] ? do_softirq+0x2e/0x38
>>  [<c012b28f>] ? irq_exit+0x26/0x53
>>  [<c01105c6>] ? smp_apic_timer_interrupt+0x6c/0x76
>>  [<c0103966>] ? apic_timer_interrupt+0x2a/0x30
>>  [<c01100d8>] ? lapic_suspend+0x47/0x15c
>>  [<f8ab68df>] ? drm_clflush_pages+0x3b/0x68 [drm]
>>  [<f8b0ad19>] ? i915_gem_execbuffer+0x6cf/0xbdd [i915]
>>  [<f8b08b88>] ? i915_gem_busy_ioctl+0x73/0x7a [i915]
>>  [<f8ab7667>] ? drm_ioctl+0x1ca/0x24b [drm]
>>  [<f8b0a64a>] ? i915_gem_execbuffer+0x0/0xbdd [i915]
>>  [<c011cc82>] ? update_curr+0x58/0x178
>>  [<c0138b88>] ? hrtimer_forward+0x10c/0x124
>>  [<c013d424>] ? getnstimeofday+0x4d/0xca
>>  [<c0197064>] ? vfs_ioctl+0x49/0x5f
>>  [<c01974be>] ? do_vfs_ioctl+0x444/0x47f
>>  [<c01052e6>] ? timer_interrupt+0x32/0x38
>>  [<c015a9e5>] ? handle_IRQ_event+0x4e/0x101
>>  [<c015bbdf>] ? handle_edge_irq+0xc6/0xe6
>>  [<c019753a>] ? sys_ioctl+0x41/0x58
>>  [<c0103014>] ? sysenter_do_call+0x12/0x28
>> ---[ end trace 56450801255ccacd ]---
>>
>> Signed-off-by: Bob Copeland <me@bobcopeland.com>
>> ---
>>
>> Luis, what do you think of this for the time being?
>>
>> I also tried just calling the tasklet so that we don't lose this
>> information.  This makes the locking a bit more complicated since
>> reset can run in process or softirq context and I didn't quite get
>> it working right, though it would be a worthy avenue to persue.
>
> I wonder if we can just use process context for our bottom halves. Of
> course that's another topic though, but good to know using the rx
> tasklet was tried and that using it requires some more work.
>
>> This seems to work ok though -- it artificially dropped about 50
>> packets while running iperf in parallel with continual scans for
>> 10 minutes, but I still got decent iperf numbers.
>
> I'd really rather we try to keep the frames instead of dropping them
> and since the number of frames on the wrong channel are scarce it
> seems better to drop just those frames instead of all pending frames
> for now.

That is without issuing a warning - as we are already handling it, are
aware of the issue and plan on resolving it somehow.

  Luis
