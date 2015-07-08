Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:36715 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbbGHTGj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 15:06:39 -0400
Received: by lagc2 with SMTP id c2so228886197lag.3
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jul 2015 12:06:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1436081080-27305-12-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1436081080-27305-12-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Wed, 8 Jul 2015 22:06:37 +0300
Message-ID: <CANUX_P0OLXxf_kj2SaYOeeQmQ7XHOhjMWia76--CLq15pXKWRQ@mail.gmail.com> (sfid-20150708_210654_811218_D02DE1CA)
Subject: Re: [PATCH 11/13] wil6210: TSO implementation
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Vladimir Kondratiev <QCA_vkondrat@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wil6210@qca.qualcomm.com,
	Vladimir Shulman <QCA_shulmanv@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 5, 2015 at 10:24 AM, Vladimir Kondratiev
<QCA_vkondrat@qca.qualcomm.com> wrote:
>
> Driver report supported TSO (v4 & v6) and IP checksum offload
> in addition to previously supported features. In data path
> skbs are checked for non-zero gso_size, and when detected sent
> to additional function for processing TSO SKBs. Since HW does not
> fully support TSO, additional effort is required from the driver.
> Driver partitions the data into mss sized descriptors which are
> then DMAed to the HW.
>
> Signed-off-by: Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/wil6210/netdev.c |   5 +-
>  drivers/net/wireless/ath/wil6210/txrx.c   | 380 +++++++++++++++++++++++++++++-
>  drivers/net/wireless/ath/wil6210/txrx.h   |   8 +
>  3 files changed, 380 insertions(+), 13 deletions(-)
>
[snip]

> @@ -1113,6 +1129,334 @@ static int wil_tx_desc_offload_cksum_set(struct wil6210_priv *wil,
>         return 0;
>  }
>
> +/**
> + * Sets the descriptor @d up for csum. The corresponding
> + * @skb is used to obtain the protocol and headers length.
> + * Returns the protocol: 0 - not TCP, 1 - TCPv4, 2 - TCPv6.
> + * Note, if d==NULL, the function only returns the protocol result.
> + *
> + * It is very similar to previous wil_tx_desc_offload_setup_tso. This
> + * is "if unrolling" to optimize the critical path.
> + */
> +
> +static int wil_tx_desc_offload_setup(struct vring_tx_desc *d,
> +                                    struct sk_buff *skb){
> +       int protocol;
> +
> +       if (skb->ip_summed != CHECKSUM_PARTIAL)
> +               return 0;
> +
> +       d->dma.b11 = ETH_HLEN; /* MAC header length */
> +
> +       switch (skb->protocol) {
> +       case cpu_to_be16(ETH_P_IP):
> +               protocol = ip_hdr(skb)->protocol;
> +               d->dma.b11 |= BIT(DMA_CFG_DESC_TX_OFFLOAD_CFG_L3T_IPV4_POS);
> +               break;
> +       case cpu_to_be16(ETH_P_IPV6):
> +               protocol = ipv6_hdr(skb)->nexthdr;
> +               break;
> +       default:
> +               return -EINVAL;
> +       }

I'd suggest to change the name of the variable. I think that protocol
is typically IPv4 or IPv6.
Your call of course.
If you only want to know if it is TCP or UDP, you can check gso_type
as well. This will be more efficient I guess since the share_info will
be already in cache, but that's just a guess.

[snip]

> +
> +               while (len) {
> +                       wil_dbg_txrx(wil,
> +                                    "TSO: len %d, rem_data %d, descs_used %d\n",
> +                                    len, rem_data, descs_used);
> +
> +                       if (descs_used == avail)  {
> +                               wil_err(wil, "TSO: ring overflow\n");
> +                               goto dma_error;
> +                       }
> +
> +                       lenmss = min_t(int, rem_data, len);
> +                       i = (swhead + descs_used) % vring->size;
> +                       wil_dbg_txrx(wil, "TSO: lenmss %d, i %d\n", lenmss, i);
> +
> +                       if (!headlen) {
> +                               pa = skb_frag_dma_map(dev, frag,
> +                                                     frag->size - len, lenmss,
> +                                                     DMA_TO_DEVICE);
> +                               vring->ctx[i].mapped_as = wil_mapped_as_page;
> +                       } else {
> +                               pa = dma_map_single(dev,
> +                                                   skb->data +
> +                                                   skb_headlen(skb) - headlen,
> +                                                   lenmss,
> +                                                   DMA_TO_DEVICE);
> +                               vring->ctx[i].mapped_as = wil_mapped_as_single;
> +                               headlen -= lenmss;
> +                       }
> +
> +                       if (unlikely(dma_mapping_error(dev, pa)))
> +                               goto dma_error;
> +
> +                       _desc = &vring->va[i].tx;
> +
> +                       if (!_first_desc) {
> +                               _first_desc = _desc;
> +                               first_ctx = &vring->ctx[i];
> +                               d = first_desc;
> +                       } else {
> +                               d = &desc_mem;
> +                       }
> +
> +                       wil_tx_desc_map(d, pa, lenmss, vring_index);
> +                       wil_tx_desc_offload_setup_tso(d, skb, desc_tso_type);
> +
> +                       /* use tso_type_first only once */
> +                       desc_tso_type = wil_tso_type_mid;
> +
> +                       descs_used++;  /* desc used so far */
> +                       sg_desc_cnt++; /* desc used for this segment */
> +                       len -= lenmss;
> +                       rem_data -= lenmss;
> +
> +                       wil_dbg_txrx(wil,
> +                                    "TSO: len %d, rem_data %d, descs_used %d, sg_desc_cnt %d,\n",
> +                                    len, rem_data, descs_used, sg_desc_cnt);
> +
> +                       /* Close the segment if reached mss size or last frag*/
> +                       if (rem_data == 0 || (f == nr_frags - 1 && len == 0)) {
> +                               if (hdr_compensation_need) {
> +                                       /* first segment include hdr desc for
> +                                        * release
> +                                        */
> +                                       hdr_ctx->nr_frags = sg_desc_cnt;
> +                                       wil_tx_desc_set_nr_frags(first_desc,
> +                                                                sg_desc_cnt +
> +                                                                1);
> +                                       hdr_compensation_need = false;
> +                               } else {
> +                                       wil_tx_desc_set_nr_frags(first_desc,
> +                                                                sg_desc_cnt);
> +                               }
> +                               first_ctx->nr_frags = sg_desc_cnt - 1;
> +
> +                               wil_tx_last_desc(d);
> +
> +                               /* first descriptor may also be the last
> +                                * for this mss - make sure not to copy
> +                                * it twice
> +                                */
> +                               if (first_desc != d)
> +                                       *_first_desc = *first_desc;
> +
> +                               /*last descriptor will be copied at the end
> +                                * of this TS processing
> +                                */
> +                               if (f < nr_frags - 1 || len > 0)
> +                                       *_desc = *d;
> +
> +                               rem_data = mss;
> +                               _first_desc = NULL;
> +                               sg_desc_cnt = 0;
> +                       } else if (first_desc != d) /* update mid descriptor */
> +                                       *_desc = *d;
> +               }
> +       }

So your device is able to replicate and update the IP / TCP header?
I don't really follow what your device is able to do.
You seem to be cutting the frags so that their length sums up to mss.
Which hints that your device can't segment the buffer by itself. OTOH,
I don't see how you treat the IP / TCP header copy and modification.

> +
> +       /* first descriptor may also be the last.
> +        * in this case d pointer is invalid
> +        */
> +       if (_first_desc == _desc)
> +               d = first_desc;
> +
> +       /* Last data descriptor */
> +       wil_set_tx_desc_last_tso(d);
> +       *_desc = *d;
> +
> +       /* Fill the total number of descriptors in first desc (hdr)*/
> +       wil_tx_desc_set_nr_frags(hdr_desc, descs_used);
> +       *_hdr_desc = *hdr_desc;
> +
> +       /* hold reference to skb
> +        * to prevent skb release before accounting
> +        * in case of immediate "tx done"
> +        */
> +       vring->ctx[i].skb = skb_get(skb);
> +
> +       /* performance monitoring */
> +       used = wil_vring_used_tx(vring);
> +       if (wil_val_in_range(vring_idle_trsh,
> +                            used, used + descs_used)) {
> +               txdata->idle += get_cycles() - txdata->last_idle;
> +               wil_dbg_txrx(wil,  "Ring[%2d] not idle %d -> %d\n",
> +                            vring_index, used, used + descs_used);
> +       }
> +
> +       /* advance swhead */
> +       wil_dbg_txrx(wil, "TSO: Tx swhead %d -> %d\n", swhead, vring->swhead);
> +       wil_vring_advance_head(vring, descs_used);
> +
> +       /* make sure all writes to descriptors (shared memory) are done before
> +        * committing them to HW
> +        */
> +       wmb();
> +
> +       iowrite32(vring->swhead, wil->csr + HOSTADDR(vring->hwtail));
> +       return 0;
