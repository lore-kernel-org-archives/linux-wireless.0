Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:39252 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbZIGWap convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2009 18:30:45 -0400
Received: by iwn42 with SMTP id 42so1045848iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2009 15:30:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090907124548.GA5351@hash.localnet>
References: <20090907124548.GA5351@hash.localnet>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 7 Sep 2009 15:22:15 -0700
Message-ID: <43e72e890909071522i461ca821m703f6e2eeb2d0385@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH/RFC] ath5k: clear rx queue on reset
To: Bob Copeland <me@bobcopeland.com>,
	Matt Smith <Matt.Smith@atheros.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc'ing Matt just for his information.

Note: this e-mail is on a public mailing list.

On Mon, Sep 7, 2009 at 5:45 AM, Bob Copeland<me@bobcopeland.com> wrote:
>
> When changing channels or otherwise resetting the card, dump
> any queued rx buffers so that we don't use the wrong channel
> information when reporting the packets.  This should fix the
> remaining instances of this warning:
>
> WARNING: at /build/buildd-linux-2.6_2.6.30-1-i386-06t6n0/linux-2.6-2.6.30/debian/build/source_i386_none/drivers/net/wireless/ath5k/base.c:1096 ath5k_hw_to_driver_rix+0x52/0x58 [ath5k]()
> Hardware name: MacBook1,1
> invalid hw_rix: 1b
> Modules linked in: i915 drm i2c_algo_bit binfmt_misc uvcvideo videodev v4l1_compat btusb rfcomm l2cap bluetooth ppdev parport_pc lp parport acpi_cpufreq cpufreq_powersave cpufreq_conservative cpufreq_userspace cpufreq_stats ext4 jbd2 crc16 ext2 fuse arc4 ecb ath5k mac80211 cfg80211 firewire_sbp2 loop joydev applesmc led_class input_polldev snd_hda_codec_idt isight_firmware pcspkr i2c_i801 i2c_core rng_core appletouch evdev iTCO_wdt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device tpm_infineon tpm tpm_bios video output battery processor ac button snd soundcore snd_page_alloc intel_agp agpgart ext3 jbd mbcache usbhid dm_mirror dm_region_hash dm_log dm_snapshot dm_mod sd_mod crc_t10dif ide_cd_mod cdrom ata_piix ata_generic libata scsi_mod firewire_ohci firewire_core crc_itu_t ehci_hcd uhci_hcd ide_pci_generic piix ide_core sky2 usbcore thermal fan thermal_sys hid_apple hid
> Pid: 5218, comm: euphoria Tainted: G        W  2.6.30-1-686 #1
> Call Trace:
>  [<c0126ff8>] ? warn_slowpath_common+0x5e/0x8a
>  [<c0127056>] ? warn_slowpath_fmt+0x26/0x2a
>  [<f86c139b>] ? ath5k_hw_to_driver_rix+0x52/0x58 [ath5k]
>  [<f86c1899>] ? ath5k_tasklet_rx+0x2b7/0x42e [ath5k]
>  [<c012e618>] ? __mod_timer+0xc9/0xd3
>  [<c012abcf>] ? tasklet_action+0x63/0xa8
>  [<c012b0d7>] ? __do_softirq+0x8e/0x135
>  [<c012b1ac>] ? do_softirq+0x2e/0x38
>  [<c012b28f>] ? irq_exit+0x26/0x53
>  [<c01105c6>] ? smp_apic_timer_interrupt+0x6c/0x76
>  [<c0103966>] ? apic_timer_interrupt+0x2a/0x30
>  [<c01100d8>] ? lapic_suspend+0x47/0x15c
>  [<f8ab68df>] ? drm_clflush_pages+0x3b/0x68 [drm]
>  [<f8b0ad19>] ? i915_gem_execbuffer+0x6cf/0xbdd [i915]
>  [<f8b08b88>] ? i915_gem_busy_ioctl+0x73/0x7a [i915]
>  [<f8ab7667>] ? drm_ioctl+0x1ca/0x24b [drm]
>  [<f8b0a64a>] ? i915_gem_execbuffer+0x0/0xbdd [i915]
>  [<c011cc82>] ? update_curr+0x58/0x178
>  [<c0138b88>] ? hrtimer_forward+0x10c/0x124
>  [<c013d424>] ? getnstimeofday+0x4d/0xca
>  [<c0197064>] ? vfs_ioctl+0x49/0x5f
>  [<c01974be>] ? do_vfs_ioctl+0x444/0x47f
>  [<c01052e6>] ? timer_interrupt+0x32/0x38
>  [<c015a9e5>] ? handle_IRQ_event+0x4e/0x101
>  [<c015bbdf>] ? handle_edge_irq+0xc6/0xe6
>  [<c019753a>] ? sys_ioctl+0x41/0x58
>  [<c0103014>] ? sysenter_do_call+0x12/0x28
> ---[ end trace 56450801255ccacd ]---
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>
> Luis, what do you think of this for the time being?
>
> I also tried just calling the tasklet so that we don't lose this
> information.  This makes the locking a bit more complicated since
> reset can run in process or softirq context and I didn't quite get
> it working right, though it would be a worthy avenue to persue.

I wonder if we can just use process context for our bottom halves. Of
course that's another topic though, but good to know using the rx
tasklet was tried and that using it requires some more work.

> This seems to work ok though -- it artificially dropped about 50
> packets while running iperf in parallel with continual scans for
> 10 minutes, but I still got decent iperf numbers.

I'd really rather we try to keep the frames instead of dropping them
and since the number of frames on the wrong channel are scarce it
seems better to drop just those frames instead of all pending frames
for now. If we get to actually process all pending frames prior to a
reset / channel change we then eventually won't loose the other stray
frames. The solution I'd like to see is to avoid those stray frames in
the first place.

I'm expecting to review avoiding dropping stale frames a little more
next week at work with Matt, will let you know how that goes.

  Luis

>  drivers/net/wireless/ath/ath5k/base.c |   53 ++++++++++++++++++++------------
>  1 files changed, 33 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 9c6ab53..1f62325 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -548,6 +548,8 @@ ath5k_pci_probe(struct pci_dev *pdev,
>
>        sc->iobase = mem; /* So we can unmap it on detach */
>        sc->common.cachelsz = csz << 2; /* convert to bytes */
> +       sc->rxbufsize = roundup(IEEE80211_MAX_LEN, sc->common.cachelsz);
> +
>        sc->opmode = NL80211_IFTYPE_STATION;
>        sc->bintval = 1000;
>        mutex_init(&sc->lock);
> @@ -1221,6 +1223,32 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
>        return 0;
>  }
>
> +/*
> + * Clear out any unprocessed RX buffers and reset the buffers to
> + * their initial state.
> + */
> +static int
> +ath5k_rxbuf_init(struct ath5k_softc *sc)
> +{
> +       int ret;
> +       struct ath5k_buf *bf;
> +
> +       spin_lock_bh(&sc->rxbuflock);
> +       sc->rxlink = NULL;
> +       list_for_each_entry(bf, &sc->rxbuf, list) {
> +               ret = ath5k_rxbuf_setup(sc, bf);
> +               if (ret)
> +                       goto err;
> +       }
> +       bf = list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
> +       ath5k_hw_set_rxdp(sc->ah, bf->daddr);
> +       ret = 0;
> +err:
> +       spin_unlock_bh(&sc->rxbuflock);
> +       return ret;
> +}
> +
> +
>  static int
>  ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
>                  struct ath5k_txq *txq)
> @@ -1606,32 +1634,17 @@ static int
>  ath5k_rx_start(struct ath5k_softc *sc)
>  {
>        struct ath5k_hw *ah = sc->ah;
> -       struct ath5k_buf *bf;
>        int ret;
>
> -       sc->rxbufsize = roundup(IEEE80211_MAX_LEN, sc->common.cachelsz);
> -
> -       ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "cachelsz %u rxbufsize %u\n",
> -               sc->common.cachelsz, sc->rxbufsize);
> -
> -       spin_lock_bh(&sc->rxbuflock);
> -       sc->rxlink = NULL;
> -       list_for_each_entry(bf, &sc->rxbuf, list) {
> -               ret = ath5k_rxbuf_setup(sc, bf);
> -               if (ret != 0) {
> -                       spin_unlock_bh(&sc->rxbuflock);
> -                       goto err;
> -               }
> -       }
> -       bf = list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
> -       ath5k_hw_set_rxdp(ah, bf->daddr);
> -       spin_unlock_bh(&sc->rxbuflock);
> +       ret = ath5k_rxbuf_init(sc);
> +       if (ret)
> +               goto err;
>
>        ath5k_hw_start_rx_dma(ah);      /* enable recv descriptors */
>        ath5k_mode_setup(sc);           /* set filters, etc. */
>        ath5k_hw_start_rx_pcu(ah);      /* re-enable PCU/DMA engine */
>
> -       return 0;
> +       ret = 0;
>  err:
>        return ret;
>  }
> @@ -1650,7 +1663,7 @@ ath5k_rx_stop(struct ath5k_softc *sc)
>
>        ath5k_debug_printrxbuffs(sc, ah);
>
> -       sc->rxlink = NULL;              /* just in case */
> +       ath5k_rxbuf_init(sc);           /* clear rx buffers */
>  }
>
>  static unsigned int
> --
> 1.6.2.5
>
> --
> Bob Copeland %% www.bobcopeland.com
>
> _______________________________________________
> ath5k-devel mailing list
> ath5k-devel@lists.ath5k.org
> https://lists.ath5k.org/mailman/listinfo/ath5k-devel
>
