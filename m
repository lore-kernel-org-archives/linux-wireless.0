Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59751 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab2BUKaD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 05:30:03 -0500
Received: by vcge1 with SMTP id e1so4141039vcg.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2012 02:30:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20291.25159.164042.87230@gargle.gargle.HOWL>
References: <20291.25159.164042.87230@gargle.gargle.HOWL>
Date: Tue, 21 Feb 2012 16:00:02 +0530
Message-ID: <CAD2nsn2PE6yi1-bEO+SFdH7JuN3gq4nroP8KLbFda89XniNw2Q@mail.gmail.com> (sfid-20120221_113009_534830_C053E740)
Subject: Re: [RFC/WIP 02/22] ath9k: Cleanup MCI init/deinit routines
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith,

On Tue, Feb 21, 2012 at 2:52 PM, Sujith Manoharan
<c_manoha@qca.qualcomm.com> wrote:
> This patch simplifies the buffer allocation functions
> for MCI and removes unneeded memset calls. Also, a couple
> of unused variables are removed and a memory leak in DMA
> allocation is fixed.
>
> [ 1263.788267] WARNING: at /home/sujith/dev/wireless-testing/lib/dma-debug.c:875 check_unmap+0x173/0x7e0()
> [ 1263.788273] ath9k 0000:06:00.0: DMA-API: device driver frees DMA memory with different size
>               [device address=0x0000000071908000] [map size=512 bytes] [unmap size=256 bytes]
> [ 1263.788345] Pid: 774, comm: rmmod Tainted: G        W  O 3.3.0-rc3-wl #18
> [ 1263.788348] Call Trace:
> [ 1263.788355]  [<ffffffff8105110f>] warn_slowpath_common+0x7f/0xc0
> [ 1263.788359]  [<ffffffff81051206>] warn_slowpath_fmt+0x46/0x50
> [ 1263.788363]  [<ffffffff8125a713>] check_unmap+0x173/0x7e0
> [ 1263.788368]  [<ffffffff8123fc22>] ? prio_tree_left+0x32/0xc0
> [ 1263.788373]  [<ffffffff8125aded>] debug_dma_free_coherent+0x6d/0x80
> [ 1263.788381]  [<ffffffffa0701c3c>] ath_mci_cleanup+0x7c/0x110 [ath9k]
> [ 1263.788387]  [<ffffffffa06f4033>] ath9k_deinit_softc+0x113/0x120 [ath9k]
> [ 1263.788392]  [<ffffffffa06f55cc>] ath9k_deinit_device+0x5c/0x70 [ath9k]
> [ 1263.788397]  [<ffffffffa0704934>] ath_pci_remove+0x54/0xa0 [ath9k]
> [ 1263.788401]  [<ffffffff81267d06>] pci_device_remove+0x46/0x110
> [ 1263.788406]  [<ffffffff813102bc>] __device_release_driver+0x7c/0xe0
> [ 1263.788410]  [<ffffffff81310a00>] driver_detach+0xd0/0xe0
> [ 1263.788414]  [<ffffffff81310118>] bus_remove_driver+0x88/0xe0
> [ 1263.788418]  [<ffffffff813111c2>] driver_unregister+0x62/0xa0
> [ 1263.788421]  [<ffffffff812680c4>] pci_unregister_driver+0x44/0xc0
> [ 1263.788427]  [<ffffffffa0705015>] ath_pci_exit+0x15/0x20 [ath9k]
> [ 1263.788432]  [<ffffffffa070a92d>] ath9k_exit+0x15/0x31 [ath9k]
> [ 1263.788436]  [<ffffffff810b971c>] sys_delete_module+0x18c/0x270
> [ 1263.788441]  [<ffffffff81436edd>] ? retint_swapgs+0x13/0x1b
> [ 1263.788446]  [<ffffffff812483be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [ 1263.788450]  [<ffffffff814378e9>] system_call_fastpath+0x16/0x1b
> [ 1263.788453] ---[ end trace 3ab4d030ffde40d4 ]---
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_mci.c |    5 --
>  drivers/net/wireless/ath/ath9k/btcoex.h     |    1 -
>  drivers/net/wireless/ath/ath9k/mci.c        |   70 +++++++++------------------
>  drivers/net/wireless/ath/ath9k/mci.h        |    3 -
>  4 files changed, 23 insertions(+), 56 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> index 318aa8f..f910bae 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> @@ -976,7 +976,6 @@ void ar9003_mci_setup(struct ath_hw *ah, u32 gpm_addr, void *gpm_buf,
>                      u16 len, u32 sched_addr)
>  {
>        struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
> -       void *sched_buf = (void *)((char *) gpm_buf + (sched_addr - gpm_addr));
>
>        if (!ATH9K_HW_CAP_MCI)
>                return;
> @@ -985,7 +984,6 @@ void ar9003_mci_setup(struct ath_hw *ah, u32 gpm_addr, void *gpm_buf,
>        mci->gpm_buf = gpm_buf;
>        mci->gpm_len = len;
>        mci->sched_addr = sched_addr;
> -       mci->sched_buf = sched_buf;
>
>        ar9003_mci_reset(ah, true, true, true);
>  }
> @@ -993,14 +991,11 @@ EXPORT_SYMBOL(ar9003_mci_setup);
>
>  void ar9003_mci_cleanup(struct ath_hw *ah)
>  {
> -       struct ath_common *common = ath9k_hw_common(ah);
> -
>        if (!ATH9K_HW_CAP_MCI)
>                return;
>
>        /* Turn off MCI and Jupiter mode. */
>        REG_WRITE(ah, AR_BTCOEX_CTRL, 0x00);
> -       ath_dbg(common, MCI, "MCI ar9003_mci_cleanup\n");
>        ar9003_mci_disable_interrupt(ah);
>  }
>  EXPORT_SYMBOL(ar9003_mci_cleanup);
> diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
> index 278361c..0cb7ce9 100644
> --- a/drivers/net/wireless/ath/ath9k/btcoex.h
> +++ b/drivers/net/wireless/ath/ath9k/btcoex.h
> @@ -67,7 +67,6 @@ struct ath9k_hw_mci {
>        u32 wlan_cal_done;
>        u32 config;
>        u8 *gpm_buf;
> -       u8 *sched_buf;
>        bool ready;
>        bool update_2g5g;
>        bool is_2g;
> diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
> index 05c23ea..85a957a 100644
> --- a/drivers/net/wireless/ath/ath9k/mci.c
> +++ b/drivers/net/wireless/ath/ath9k/mci.c
> @@ -383,84 +383,60 @@ static void ath_mci_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
>        }
>  }
>
> -static int ath_mci_buf_alloc(struct ath_softc *sc, struct ath_mci_buf *buf)
> -{
> -       int error = 0;
> -
> -       buf->bf_addr = dma_alloc_coherent(sc->dev, buf->bf_len,
> -                                         &buf->bf_paddr, GFP_KERNEL);
> -
> -       if (buf->bf_addr == NULL) {
> -               error = -ENOMEM;
> -               goto fail;
> -       }
> -
> -       return 0;
> -
> -fail:
> -       memset(buf, 0, sizeof(*buf));
> -       return error;
> -}
> -
> -static void ath_mci_buf_free(struct ath_softc *sc, struct ath_mci_buf *buf)
> -{
> -       if (buf->bf_addr) {
> -               dma_free_coherent(sc->dev, buf->bf_len, buf->bf_addr,
> -                                                       buf->bf_paddr);
> -               memset(buf, 0, sizeof(*buf));
> -       }
> -}
> -
>  int ath_mci_setup(struct ath_softc *sc)
>  {
>        struct ath_common *common = ath9k_hw_common(sc->sc_ah);
>        struct ath_mci_coex *mci = &sc->mci_coex;
> -       int error = 0;
> +       struct ath_mci_buf *buf = &mci->sched_buf;
>
>        if (!ATH9K_HW_CAP_MCI)
>                return 0;
>
> -       mci->sched_buf.bf_len = ATH_MCI_SCHED_BUF_SIZE + ATH_MCI_GPM_BUF_SIZE;
> +       buf->bf_addr = dma_alloc_coherent(sc->dev,
> +                                 ATH_MCI_SCHED_BUF_SIZE + ATH_MCI_GPM_BUF_SIZE,
> +                                 &buf->bf_paddr, GFP_KERNEL);
>
> -       if (ath_mci_buf_alloc(sc, &mci->sched_buf)) {
> +       if (buf->bf_addr == NULL) {
>                ath_dbg(common, FATAL, "MCI buffer alloc failed\n");
> -               error = -ENOMEM;
> -               goto fail;
> +               return -ENOMEM;
>        }
>
> -       mci->sched_buf.bf_len = ATH_MCI_SCHED_BUF_SIZE;
> +       memset(buf->bf_addr, MCI_GPM_RSVD_PATTERN,
> +              ATH_MCI_SCHED_BUF_SIZE + ATH_MCI_GPM_BUF_SIZE);
>
> -       memset(mci->sched_buf.bf_addr, MCI_GPM_RSVD_PATTERN,
> -                                               mci->sched_buf.bf_len);
> +       mci->sched_buf.bf_len = ATH_MCI_SCHED_BUF_SIZE;
>
>        mci->gpm_buf.bf_len = ATH_MCI_GPM_BUF_SIZE;
> -       mci->gpm_buf.bf_addr = (u8 *)mci->sched_buf.bf_addr +
> -                                                       mci->sched_buf.bf_len;
> +       mci->gpm_buf.bf_addr = (u8 *)mci->sched_buf.bf_addr + mci->sched_buf.bf_len;
>        mci->gpm_buf.bf_paddr = mci->sched_buf.bf_paddr + mci->sched_buf.bf_len;
>
> -       /* initialize the buffer */
> -       memset(mci->gpm_buf.bf_addr, MCI_GPM_RSVD_PATTERN, mci->gpm_buf.bf_len);
> -
>        ar9003_mci_setup(sc->sc_ah, mci->gpm_buf.bf_paddr,
>                         mci->gpm_buf.bf_addr, (mci->gpm_buf.bf_len >> 4),
>                         mci->sched_buf.bf_paddr);
> -fail:
> -       return error;
> +
> +       ath_dbg(common, MCI, "MCI Initialized\n");
> +
> +       return 0;
>  }
>
>  void ath_mci_cleanup(struct ath_softc *sc)
>  {
> +       struct ath_common *common = ath9k_hw_common(sc->sc_ah);
>        struct ath_hw *ah = sc->sc_ah;
>        struct ath_mci_coex *mci = &sc->mci_coex;
> +       struct ath_mci_buf *buf = &mci->sched_buf;
>
>        if (!ATH9K_HW_CAP_MCI)
>                return;
>
> -       /*
> -        * both schedule and gpm buffers will be released
> -        */
> -       ath_mci_buf_free(sc, &mci->sched_buf);
> +       if (buf->bf_addr)
> +               dma_free_coherent(sc->dev,
> +                                 ATH_MCI_SCHED_BUF_SIZE + ATH_MCI_GPM_BUF_SIZE,
> +                                 buf->bf_addr, buf->bf_paddr);
> +
>        ar9003_mci_cleanup(ah);
> +
> +       ath_dbg(common, MCI, "MCI De-Initialized\n");
>  }
>
>  void ath_mci_intr(struct ath_softc *sc)
> diff --git a/drivers/net/wireless/ath/ath9k/mci.h b/drivers/net/wireless/ath/ath9k/mci.h
> index 29e3e51..b805bf2 100644
> --- a/drivers/net/wireless/ath/ath9k/mci.h
> +++ b/drivers/net/wireless/ath/ath9k/mci.h
> @@ -113,7 +113,6 @@ struct ath_mci_profile {
>        u8 num_bdr;
>  };
>
> -
>  struct ath_mci_buf {
>        void *bf_addr;          /* virtual addr of desc */
>        dma_addr_t bf_paddr;    /* physical addr of buffer */
> @@ -121,10 +120,8 @@ struct ath_mci_buf {
>  };
>
>  struct ath_mci_coex {
> -       atomic_t mci_cal_flag;
>        struct ath_mci_buf sched_buf;
>        struct ath_mci_buf gpm_buf;
> -       u32 bt_cal_start;
>  };
>
>  void ath_mci_flush_profile(struct ath_mci_profile *mci);
> --
> 1.7.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

thanks for fixing it, before this patch  mci->sched_buf.bf_len will be
ATH_MCI_SCHED_BUF_SIZE rather than ATH_MCI_SCHED_BUF_SIZE +
ATH_MCI_GPM_BUF_SIZE,  thats why the memory leak i think.

-- 
thanks,
shafi
