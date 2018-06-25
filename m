Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51728 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755000AbeFYKEv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Jun 2018 06:04:51 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Douglas Anderson <dianders@chromium.org>
Subject: RE: [PATCH 2/2] mwifiex: restructure rx_reorder_tbl_lock usage
Date: Mon, 25 Jun 2018 10:04:47 +0000
Message-ID: <8150443a9e0a432f8753e7a706f9447e@SC-EXCH02.marvell.com> (sfid-20180625_120457_502288_A6982A9C)
References: <1529919775-21274-1-git-send-email-gbhat@marvell.com>
 <1529919775-21274-2-git-send-email-gbhat@marvell.com>
In-Reply-To: <1529919775-21274-2-git-send-email-gbhat@marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For reference, detailed discussion could be found in below thread:
https://patchwork.kernel.org/patch/10033789/

Regards,
Ganapathi
> -----Original Message-----
> From: Ganapathi Bhat [mailto:gbhat@marvell.com]
> Sent: Monday, June 25, 2018 3:13 PM
> To: linux-wireless@vger.kernel.org
> Cc: Brian Norris; Cathy Luo; Xinming Hu; Zhiyuan Yang; James Cao; Mangesh
> Malusare; Douglas Anderson; Ganapathi Bhat
> Subject: [PATCH 2/2] mwifiex: restructure rx_reorder_tbl_lock usage
>
> Driver must ensure that whenever it holds a pointer to the list
> entry mwifiex_rx_reorder_tbl, it must protect the same with
> rx_reorder_tbl_lock. At present there are many places where
> driver does not ensure this. To cover all cases, spinlocks in
> below funcions are moved out and made sure that the caller will
> hold the spinlock:
> mwifiex_11n_dispatch_pkt_until_start_win()
> mwifiex_11n_scan_and_dispatch()
> mwifiex_del_rx_reorder_entry()
> mwifiex_11n_get_rx_reorder_tbl()
> mwifiex_11n_find_last_seq_num()
>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/11n.c         |  5 +-
>  .../net/wireless/marvell/mwifiex/11n_rxreorder.c   | 80 ++++++++++---------
> ---
>  drivers/net/wireless/marvell/mwifiex/uap_txrx.c    |  3 +
>  3 files changed, 42 insertions(+), 46 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/11n.c
> b/drivers/net/wireless/marvell/mwifiex/11n.c
> index 5d75c97..e2addd8 100644
> --- a/drivers/net/wireless/marvell/mwifiex/11n.c
> +++ b/drivers/net/wireless/marvell/mwifiex/11n.c
> @@ -696,10 +696,11 @@ void mwifiex_11n_delba(struct mwifiex_private
> *priv, int tid)
>                               "Send delba to tid=%d, %pM\n",
>                               tid, rx_reor_tbl_ptr->ta);
>                       mwifiex_send_delba(priv, tid, rx_reor_tbl_ptr->ta,
> 0);
> -                     goto exit;
> +                     spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock,
> +                                            flags);
> +                     return;
>               }
>       }
> -exit:
>       spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
>  }
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
> b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
> index 5380fba..e0d0998 100644
> --- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
> +++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
> @@ -111,25 +111,21 @@ static int mwifiex_11n_dispatch_pkt(struct
> mwifiex_private *priv, void *payload)
>  {
>       int pkt_to_send, i;
>       void *rx_tmp_ptr;
> -     unsigned long flags;
>
>       pkt_to_send = (start_win > tbl->start_win) ?
>                     min((start_win - tbl->start_win), tbl->win_size) :
>                     tbl->win_size;
>
>       for (i = 0; i < pkt_to_send; ++i) {
> -             spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
>               rx_tmp_ptr = NULL;
>               if (tbl->rx_reorder_ptr[i]) {
>                       rx_tmp_ptr = tbl->rx_reorder_ptr[i];
>                       tbl->rx_reorder_ptr[i] = NULL;
>               }
> -             spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
>               if (rx_tmp_ptr)
>                       mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
>       }
>
> -     spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
>       /*
>        * We don't have a circular buffer, hence use rotation to simulate
>        * circular buffer
> @@ -140,7 +136,6 @@ static int mwifiex_11n_dispatch_pkt(struct
> mwifiex_private *priv, void *payload)
>       }
>
>       tbl->start_win = start_win;
> -     spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
>  }
>
>  /*
> @@ -160,7 +155,6 @@ static int mwifiex_11n_dispatch_pkt(struct
> mwifiex_private *priv, void *payload)
>       unsigned long flags;
>
>       for (i = 0; i < tbl->win_size; ++i) {
> -             spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
>               if (!tbl->rx_reorder_ptr[i]) {
>                       spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock,
>                                              flags);
> @@ -168,11 +162,9 @@ static int mwifiex_11n_dispatch_pkt(struct
> mwifiex_private *priv, void *payload)
>               }
>               rx_tmp_ptr = tbl->rx_reorder_ptr[i];
>               tbl->rx_reorder_ptr[i] = NULL;
> -             spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
>               mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
>       }
>
> -     spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
>       /*
>        * We don't have a circular buffer, hence use rotation to simulate
>        * circular buffer
> @@ -185,7 +177,6 @@ static int mwifiex_11n_dispatch_pkt(struct
> mwifiex_private *priv, void *payload)
>               }
>       }
>       tbl->start_win = (tbl->start_win + i) & (MAX_TID_VALUE - 1);
> -     spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
>  }
>
>  /*
> @@ -218,11 +209,7 @@ static int mwifiex_11n_dispatch_pkt(struct
> mwifiex_private *priv, void *payload)
>
>       del_timer_sync(&tbl->timer_context.timer);
>       tbl->timer_context.timer_is_set = false;
> -
> -     spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
>       list_del(&tbl->list);
> -     spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
> -
>       kfree(tbl->rx_reorder_ptr);
>       kfree(tbl);
>
> @@ -240,17 +227,10 @@ struct mwifiex_rx_reorder_tbl *
>  mwifiex_11n_get_rx_reorder_tbl(struct mwifiex_private *priv, int tid, u8
> *ta)
>  {
>       struct mwifiex_rx_reorder_tbl *tbl;
> -     unsigned long flags;
>
> -     spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
> -     list_for_each_entry(tbl, &priv->rx_reorder_tbl_ptr, list) {
> -             if (!memcmp(tbl->ta, ta, ETH_ALEN) && tbl->tid == tid) {
> -                     spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock,
> -                                            flags);
> +     list_for_each_entry(tbl, &priv->rx_reorder_tbl_ptr, list)
> +             if (!memcmp(tbl->ta, ta, ETH_ALEN) && tbl->tid == tid)
>                       return tbl;
> -             }
> -     }
> -     spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
>
>       return NULL;
>  }
> @@ -267,14 +247,9 @@ void mwifiex_11n_del_rx_reorder_tbl_by_ta(struct
> mwifiex_private *priv, u8 *ta)
>               return;
>
>       spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
> -     list_for_each_entry_safe(tbl, tmp, &priv->rx_reorder_tbl_ptr, list) {
> -             if (!memcmp(tbl->ta, ta, ETH_ALEN)) {
> -                     spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock,
> -                                            flags);
> +     list_for_each_entry_safe(tbl, tmp, &priv->rx_reorder_tbl_ptr, list)
> +             if (!memcmp(tbl->ta, ta, ETH_ALEN))
>                       mwifiex_del_rx_reorder_entry(priv, tbl);
> -                     spin_lock_irqsave(&priv->rx_reorder_tbl_lock,
> flags);
> -             }
> -     }
>       spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
>
>       return;
> @@ -288,19 +263,11 @@ void
> mwifiex_11n_del_rx_reorder_tbl_by_ta(struct mwifiex_private *priv, u8
> *ta)
>  mwifiex_11n_find_last_seq_num(struct reorder_tmr_cnxt *ctx)
>  {
>       struct mwifiex_rx_reorder_tbl *rx_reorder_tbl_ptr = ctx->ptr;
> -     struct mwifiex_private *priv = ctx->priv;
> -     unsigned long flags;
>       int i;
>
> -     spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
> -     for (i = rx_reorder_tbl_ptr->win_size - 1; i >= 0; --i) {
> -             if (rx_reorder_tbl_ptr->rx_reorder_ptr[i]) {
> -                     spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock,
> -                                            flags);
> +     for (i = rx_reorder_tbl_ptr->win_size - 1; i >= 0; --i)
> +             if (rx_reorder_tbl_ptr->rx_reorder_ptr[i])
>                       return i;
> -             }
> -     }
> -     spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
>
>       return -1;
>  }
> @@ -318,17 +285,22 @@ void
> mwifiex_11n_del_rx_reorder_tbl_by_ta(struct mwifiex_private *priv, u8
> *ta)
>       struct reorder_tmr_cnxt *ctx =
>               from_timer(ctx, t, timer);
>       int start_win, seq_num;
> +     unsigned long flags;
>
>       ctx->timer_is_set = false;
> +     spin_lock_irqsave(&ctx->priv->rx_reorder_tbl_lock, flags);
>       seq_num = mwifiex_11n_find_last_seq_num(ctx);
>
> -     if (seq_num < 0)
> +     if (seq_num < 0) {
> +             spin_unlock_irqrestore(&ctx->priv->rx_reorder_tbl_lock,
> flags);
>               return;
> +     }
>
>       mwifiex_dbg(ctx->priv->adapter, INFO, "info: flush data %d\n",
> seq_num);
>       start_win = (ctx->ptr->start_win + seq_num + 1) &
> (MAX_TID_VALUE - 1);
>       mwifiex_11n_dispatch_pkt_until_start_win(ctx->priv, ctx->ptr,
>                                                start_win);
> +     spin_unlock_irqrestore(&ctx->priv->rx_reorder_tbl_lock, flags);
>  }
>
>  /*
> @@ -355,11 +327,14 @@ void
> mwifiex_11n_del_rx_reorder_tbl_by_ta(struct mwifiex_private *priv, u8
> *ta)
>        * If we get a TID, ta pair which is already present dispatch all the
>        * the packets and move the window size until the ssn
>        */
> +     spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
>       tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid, ta);
>       if (tbl) {
>               mwifiex_11n_dispatch_pkt_until_start_win(priv, tbl,
> seq_num);
> +             spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
>               return;
>       }
> +     spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
>       /* if !tbl then create one */
>       new_node = kzalloc(sizeof(struct mwifiex_rx_reorder_tbl),
> GFP_KERNEL);
>       if (!new_node)
> @@ -570,16 +545,20 @@ int mwifiex_11n_rx_reorder_pkt(struct
> mwifiex_private *priv,
>       int prev_start_win, start_win, end_win, win_size;
>       u16 pkt_index;
>       bool init_window_shift = false;
> +     unsigned long flags;
>       int ret = 0;
>
> +     spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
>       tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid, ta);
>       if (!tbl) {
> +             spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
>               if (pkt_type != PKT_TYPE_BAR)
>                       mwifiex_11n_dispatch_pkt(priv, payload);
>               return ret;
>       }
>
>       if ((pkt_type == PKT_TYPE_AMSDU) && !tbl->amsdu) {
> +             spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
>               mwifiex_11n_dispatch_pkt(priv, payload);
>               return ret;
>       }
> @@ -666,6 +645,8 @@ int mwifiex_11n_rx_reorder_pkt(struct
> mwifiex_private *priv,
>       if (!tbl->timer_context.timer_is_set ||
>           prev_start_win != tbl->start_win)
>               mwifiex_11n_rxreorder_timer_restart(tbl);
> +
> +     spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
>       return ret;
>  }
>
> @@ -694,14 +675,18 @@ int mwifiex_11n_rx_reorder_pkt(struct
> mwifiex_private *priv,
>                   peer_mac, tid, initiator);
>
>       if (cleanup_rx_reorder_tbl) {
> +             spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
>               tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid,
>                                                                peer_mac);
>               if (!tbl) {
> +                     spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock,
> +                                            flags);
>                       mwifiex_dbg(priv->adapter, EVENT,
>                                   "event: TID, TA not found in table\n");
>                       return;
>               }
>               mwifiex_del_rx_reorder_entry(priv, tbl);
> +             spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
>       } else {
>               ptx_tbl = mwifiex_get_ba_tbl(priv, tid, peer_mac);
>               if (!ptx_tbl) {
> @@ -735,6 +720,7 @@ int mwifiex_ret_11n_addba_resp(struct
> mwifiex_private *priv,
>       int tid, win_size;
>       struct mwifiex_rx_reorder_tbl *tbl;
>       uint16_t block_ack_param_set;
> +     unsigned long flags;
>
>       block_ack_param_set = le16_to_cpu(add_ba_rsp-
> >block_ack_param_set);
>
> @@ -748,17 +734,20 @@ int mwifiex_ret_11n_addba_resp(struct
> mwifiex_private *priv,
>               mwifiex_dbg(priv->adapter, ERROR, "ADDBA RSP: failed
> %pM tid=%d)\n",
>                           add_ba_rsp->peer_mac_addr, tid);
>
> +             spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
>               tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid,
>                                                    add_ba_rsp-
> >peer_mac_addr);
>               if (tbl)
>                       mwifiex_del_rx_reorder_entry(priv, tbl);
>
> +             spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
>               return 0;
>       }
>
>       win_size = (block_ack_param_set &
> IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK)
>                   >> BLOCKACKPARAM_WINSIZE_POS;
>
> +     spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
>       tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid,
>                                            add_ba_rsp->peer_mac_addr);
>       if (tbl) {
> @@ -769,6 +758,7 @@ int mwifiex_ret_11n_addba_resp(struct
> mwifiex_private *priv,
>               else
>                       tbl->amsdu = false;
>       }
> +     spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
>
>       mwifiex_dbg(priv->adapter, CMD,
>                   "cmd: ADDBA RSP: %pM tid=%d ssn=%d win_size=%d\n",
> @@ -808,11 +798,8 @@ void mwifiex_11n_cleanup_reorder_tbl(struct
> mwifiex_private *priv)
>
>       spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
>       list_for_each_entry_safe(del_tbl_ptr, tmp_node,
> -                              &priv->rx_reorder_tbl_ptr, list) {
> -             spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
> +                              &priv->rx_reorder_tbl_ptr, list)
>               mwifiex_del_rx_reorder_entry(priv, del_tbl_ptr);
> -             spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
> -     }
>       INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
>       spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
>
> @@ -936,6 +923,7 @@ void mwifiex_11n_rxba_sync_event(struct
> mwifiex_private *priv,
>       int tlv_buf_left = len;
>       int ret;
>       u8 *tmp;
> +     unsigned long flags;
>
>       mwifiex_dbg_dump(priv->adapter, EVT_D, "RXBA_SYNC event:",
>                        event_buf, len);
> @@ -955,14 +943,18 @@ void mwifiex_11n_rxba_sync_event(struct
> mwifiex_private *priv,
>                           tlv_rxba->mac, tlv_rxba->tid, tlv_seq_num,
>                           tlv_bitmap_len);
>
> +             spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
>               rx_reor_tbl_ptr =
>                       mwifiex_11n_get_rx_reorder_tbl(priv, tlv_rxba->tid,
>                                                      tlv_rxba->mac);
>               if (!rx_reor_tbl_ptr) {
> +                     spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock,
> +                                            flags);
>                       mwifiex_dbg(priv->adapter, ERROR,
>                                   "Can not find rx_reorder_tbl!");
>                       return;
>               }
> +             spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
>
>               for (i = 0; i < tlv_bitmap_len; i++) {
>                       for (j = 0 ; j < 8; j++) {
> diff --git a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
> b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
> index 1e6a62c..99cfaee 100644
> --- a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
> +++ b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
> @@ -421,12 +421,15 @@ int mwifiex_process_uap_rx_packet(struct
> mwifiex_private *priv,
>               spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
>       }
>
> +     spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
>       if (!priv->ap_11n_enabled ||
>           (!mwifiex_11n_get_rx_reorder_tbl(priv, uap_rx_pd->priority, ta)
> &&
>           (le16_to_cpu(uap_rx_pd->rx_pkt_type) != PKT_TYPE_AMSDU))) {
>               ret = mwifiex_handle_uap_rx_forward(priv, skb);
> +             spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
>               return ret;
>       }
> +     spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
>
>       /* Reorder and send to kernel */
>       pkt_type = (u8)le16_to_cpu(uap_rx_pd->rx_pkt_type);
> --
> 1.9.1
