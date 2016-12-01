Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36924 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752151AbcLAGvC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 01:51:02 -0500
Date: Thu, 1 Dec 2016 12:20:48 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix Tx DMA alloc failure during continuous wifi
 down/up
Message-ID: <20161201065048.GA11953@atheros-ThinkPad-T61> (sfid-20161201_075107_275568_B30C8E4D)
References: <1480499414-19543-1-git-send-email-mohammed@qca.qualcomm.com>
 <CAJ-VmokhmPy7Bb++wRb2h5H-_g3Vu2jqLqeoh9kiP0tGdC1_vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ-VmokhmPy7Bb++wRb2h5H-_g3Vu2jqLqeoh9kiP0tGdC1_vA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Adrian,

On Wed, Nov 30, 2016 at 10:27:25AM -0800, Adrian Chadd wrote:
> Heh, I had to do something like this for freebsd too for my ath10k
> port. So thanks. :)

[shafi] thanks :):)

> 
> Suggestion - take a look at where tasklets, completions, locks, etc
> are all re-allocated multiple times, once upon initial VAP bringup. I
> had to also undo this in FreeBSD, as we don't allow re-init of tasks,
> completions, callouts and locks without first freeing/zero'ing them
> appropriately. :)
> 
>
[shafi] sure, I just added some basic debug prints

In ath10k_htt_tx_start and init tx_lock and pending_tx
In ath10k_htt_tx_start and tx mem allocated set to true

In ath10k_htt_tx_start and init tx_lock and pending_tx (initialized second time)
In ath10k_htt_tx_start and tx mem is already allocated
In ath10k_htt_tx_destroy and tx mem allocated set to false

But I see 'ath10k_htt_tx_stop' is called when the interface is brought down
and in that scenario we need to do 'idr_init(&htt->pending_tx) ' ?
while doing a tx_lock might be a duplicate. Also if i understand correctly
the existing ath10k already calls tx buffer allocation twice via

4   2145  core.c <<ath10k_core_probe_fw>>
   ret = ath10k_core_start(ar, ATH10K_FIRMWARE_MODE_NORMAL,

5   4471  mac.c <<ath10k_start>>
   ret = ath10k_core_start(ar,
   ATH10K_FIRMWARE_MODE_NORMAL,

Also there is a suggestion to enhance this patch using DMA API's
(thanks Michal) and we will work on this once this goes fine
without any issues

regards,
shafi

> 
> 
> 
> On 30 November 2016 at 01:50, Mohammed Shafi Shajakhan
> <mohammed@qti.qualcomm.com> wrote:
> > From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> >
> > With maximum number of vap's configured in a two radio supported
> > systems of ~256 Mb RAM, doing a continuous wifi down/up and
> > intermittent traffic streaming from the connected stations results
> > in failure to allocate contiguous memory for tx buffers. This results
> > in the disappearance of all VAP's and a manual reboot is needed as
> > this is not a crash (or) OOM(for OOM killer to be invoked). To address
> > this allocate contiguous memory for tx buffers one time and re-use them
> > until the modules are unloaded but this results in a slight increase in
> > memory footprint of ath10k when the wifi is down, but the modules are
> > still loaded. Also as of now we use a separate bool 'tx_mem_allocated'
> > to keep track of the one time memory allocation, as we cannot come up
> > with something like 'ath10k_tx_{register,unregister}' before
> > 'ath10k_probe_fw' is called as 'ath10k_htt_tx_alloc_cont_frag_desc'
> > memory allocation is dependent on the hw_param 'continuous_frag_desc'
> >
> > a) memory footprint of ath10k without the change
> >
> > lsmod | grep ath10k
> > ath10k_core           414498  1 ath10k_pci
> > ath10k_pci             38236  0
> >
> > b) memory footprint of ath10k with the change
> >
> > ath10k_core           414980  1 ath10k_pci
> > ath10k_pci             38236  0
> >
> > Memory Failure Call trace:
> >
> > hostapd: page allocation failure: order:6, mode:0xd0
> >  [<c021f150>] (__dma_alloc_buffer.isra.23) from
> > [<c021f23c>] (__alloc_remap_buffer.isra.26+0x14/0xb8)
> > [<c021f23c>] (__alloc_remap_buffer.isra.26) from
> > [<c021f664>] (__dma_alloc+0x224/0x2b8)
> > [<c021f664>] (__dma_alloc) from [<c021f810>]
> > (arm_dma_alloc+0x84/0x90)
> > [<c021f810>] (arm_dma_alloc) from [<bf954764>]
> > (ath10k_htt_tx_alloc+0xe0/0x2e4 [ath10k_core])
> > [<bf954764>] (ath10k_htt_tx_alloc [ath10k_core]) from
> > [<bf94e6ac>] (ath10k_core_start+0x538/0xcf8 [ath10k_core])
> > [<bf94e6ac>] (ath10k_core_start [ath10k_core]) from
> > [<bf947eec>] (ath10k_start+0xbc/0x56c [ath10k_core])
> > [<bf947eec>] (ath10k_start [ath10k_core]) from
> > [<bf8a7a04>] (drv_start+0x40/0x5c [mac80211])
> > [<bf8a7a04>] (drv_start [mac80211]) from [<bf8b7cf8>]
> > (ieee80211_do_open+0x170/0x82c [mac80211])
> > [<bf8b7cf8>] (ieee80211_do_open [mac80211]) from
> > [<c056afc8>] (__dev_open+0xa0/0xf4)
> > [21053.491752] Normal: 641*4kB (UEMR) 505*8kB (UEMR) 330*16kB (UEMR)
> > 126*32kB (UEMR) 762*64kB (UEMR) 237*128kB (UEMR) 1*256kB (M) 0*512kB
> > 0*1024kB 0*2048kB 0*4096kB = 95276kB
> >
> > Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath10k/core.c   |  5 +--
> >  drivers/net/wireless/ath/ath10k/htt.h    |  6 +++-
> >  drivers/net/wireless/ath/ath10k/htt_tx.c | 54 +++++++++++++++++++++++++-------
> >  3 files changed, 51 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> > index 5bc6847..f7ea4de 100644
> > --- a/drivers/net/wireless/ath/ath10k/core.c
> > +++ b/drivers/net/wireless/ath/ath10k/core.c
> > @@ -1857,7 +1857,7 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
> >                 goto err_wmi_detach;
> >         }
> >
> > -       status = ath10k_htt_tx_alloc(&ar->htt);
> > +       status = ath10k_htt_tx_start(&ar->htt);
> >         if (status) {
> >                 ath10k_err(ar, "failed to alloc htt tx: %d\n", status);
> >                 goto err_wmi_detach;
> > @@ -2052,7 +2052,7 @@ void ath10k_core_stop(struct ath10k *ar)
> >                 ath10k_wait_for_suspend(ar, WMI_PDEV_SUSPEND_AND_DISABLE_INTR);
> >
> >         ath10k_hif_stop(ar);
> > -       ath10k_htt_tx_free(&ar->htt);
> > +       ath10k_htt_tx_stop(&ar->htt);
> >         ath10k_htt_rx_free(&ar->htt);
> >         ath10k_wmi_detach(ar);
> >  }
> > @@ -2385,6 +2385,7 @@ void ath10k_core_destroy(struct ath10k *ar)
> >         destroy_workqueue(ar->workqueue_aux);
> >
> >         ath10k_debug_destroy(ar);
> > +       ath10k_htt_tx_destroy(&ar->htt);
> >         ath10k_wmi_free_host_mem(ar);
> >         ath10k_mac_destroy(ar);
> >  }
> > diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
> > index 0d2ed09..96bf7bf 100644
> > --- a/drivers/net/wireless/ath/ath10k/htt.h
> > +++ b/drivers/net/wireless/ath/ath10k/htt.h
> > @@ -1692,6 +1692,8 @@ struct ath10k_htt {
> >                 enum htt_tx_mode_switch_mode mode;
> >                 enum htt_q_depth_type type;
> >         } tx_q_state;
> > +
> > +       bool tx_mem_allocated;
> >  };
> >
> >  #define RX_HTT_HDR_STATUS_LEN 64
> > @@ -1754,7 +1756,9 @@ struct htt_rx_desc {
> >  int ath10k_htt_init(struct ath10k *ar);
> >  int ath10k_htt_setup(struct ath10k_htt *htt);
> >
> > -int ath10k_htt_tx_alloc(struct ath10k_htt *htt);
> > +int ath10k_htt_tx_start(struct ath10k_htt *htt);
> > +void ath10k_htt_tx_stop(struct ath10k_htt *htt);
> > +void ath10k_htt_tx_destroy(struct ath10k_htt *htt);
> >  void ath10k_htt_tx_free(struct ath10k_htt *htt);
> >
> >  int ath10k_htt_rx_alloc(struct ath10k_htt *htt);
> > diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
> > index ccbc8c03..27e49db 100644
> > --- a/drivers/net/wireless/ath/ath10k/htt_tx.c
> > +++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
> > @@ -350,21 +350,15 @@ static int ath10k_htt_tx_alloc_txdone_fifo(struct ath10k_htt *htt)
> >         return ret;
> >  }
> >
> > -int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
> > +static int ath10k_htt_tx_alloc_buf(struct ath10k_htt *htt)
> >  {
> >         struct ath10k *ar = htt->ar;
> >         int ret;
> >
> > -       ath10k_dbg(ar, ATH10K_DBG_BOOT, "htt tx max num pending tx %d\n",
> > -                  htt->max_num_pending_tx);
> > -
> > -       spin_lock_init(&htt->tx_lock);
> > -       idr_init(&htt->pending_tx);
> > -
> >         ret = ath10k_htt_tx_alloc_cont_txbuf(htt);
> >         if (ret) {
> >                 ath10k_err(ar, "failed to alloc cont tx buffer: %d\n", ret);
> > -               goto free_idr_pending_tx;
> > +               return ret;
> >         }
> >
> >         ret = ath10k_htt_tx_alloc_cont_frag_desc(htt);
> > @@ -396,6 +390,31 @@ int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
> >  free_txbuf:
> >         ath10k_htt_tx_free_cont_txbuf(htt);
> >
> > +       return ret;
> > +}
> > +
> > +int ath10k_htt_tx_start(struct ath10k_htt *htt)
> > +{
> > +       struct ath10k *ar = htt->ar;
> > +       int ret;
> > +
> > +       ath10k_dbg(ar, ATH10K_DBG_BOOT, "htt tx max num pending tx %d\n",
> > +                  htt->max_num_pending_tx);
> > +
> > +       spin_lock_init(&htt->tx_lock);
> > +       idr_init(&htt->pending_tx);
> > +
> > +       if (htt->tx_mem_allocated)
> > +               return 0;
> > +
> > +       ret = ath10k_htt_tx_alloc_buf(htt);
> > +       if (ret)
> > +               goto free_idr_pending_tx;
> > +
> > +       htt->tx_mem_allocated = true;
> > +
> > +       return 0;
> > +
> >  free_idr_pending_tx:
> >         idr_destroy(&htt->pending_tx);
> >
> > @@ -418,15 +437,28 @@ static int ath10k_htt_tx_clean_up_pending(int msdu_id, void *skb, void *ctx)
> >         return 0;
> >  }
> >
> > -void ath10k_htt_tx_free(struct ath10k_htt *htt)
> > +void ath10k_htt_tx_destroy(struct ath10k_htt *htt)
> >  {
> > -       idr_for_each(&htt->pending_tx, ath10k_htt_tx_clean_up_pending, htt->ar);
> > -       idr_destroy(&htt->pending_tx);
> > +       if (!htt->tx_mem_allocated)
> > +               return;
> >
> >         ath10k_htt_tx_free_cont_txbuf(htt);
> >         ath10k_htt_tx_free_txq(htt);
> >         ath10k_htt_tx_free_cont_frag_desc(htt);
> >         ath10k_htt_tx_free_txdone_fifo(htt);
> > +       htt->tx_mem_allocated = false;
> > +}
> > +
> > +void ath10k_htt_tx_stop(struct ath10k_htt *htt)
> > +{
> > +       idr_for_each(&htt->pending_tx, ath10k_htt_tx_clean_up_pending, htt->ar);
> > +       idr_destroy(&htt->pending_tx);
> > +}
> > +
> > +void ath10k_htt_tx_free(struct ath10k_htt *htt)
> > +{
> > +       ath10k_htt_tx_stop(htt);
> > +       ath10k_htt_tx_destroy(htt);
> >  }
> >
> >  void ath10k_htt_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb)
> > --
> > 1.9.1
> >
> >
> > _______________________________________________
> > ath10k mailing list
> > ath10k@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/ath10k
