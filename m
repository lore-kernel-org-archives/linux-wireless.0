Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:35116 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbbLOHk2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2015 02:40:28 -0500
Received: by mail-lf0-f54.google.com with SMTP id l133so339707lfd.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 23:40:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b11fd1b49b274142b85296c11c634635@SC-EXCH02.marvell.com>
References: <b11fd1b49b274142b85296c11c634635@SC-EXCH02.marvell.com>
Date: Tue, 15 Dec 2015 09:40:26 +0200
Message-ID: <CANUX_P0sXviP233aw1LhesMzz9mUA4-w9-ZSuADHjX9-_5CF5g@mail.gmail.com> (sfid-20151215_084032_314288_A8F7E5EE)
Subject: Re: [PATCH v7] Add new mac80211 driver mwlwifi.
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: David Lin <dlin@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I was interested in the checking the A-MSDU implementation only, so I
reviewed only that.

I am not sure I really followed your implementation though.
In iwlwifi I chose the LSO mechanism to implement A-MSDU. I understand that for
an AP it makes less sense since you don't really have locally generated traffic
and LSO won't work well with packets forwarded by the IP layer.
So you seem to have added a timeout mechanism inside the driver that accumulates
the packet for a certain period of time and send them all when the max number of
packets has been reached?
But I didn't see any timer there, so that if you start an A-MSDU and
then suddenly
stop receiving packets for transmission, the packet already in the
buffer will stay
stale?

A few more comments below.

On Thu, Nov 12, 2015 at 5:51 AM, David Lin <dlin@marvell.com> wrote:
> This patch provides the mwlwifi driver for Marvell 8863, 8864 and 8897
> chipsets.
> This driver was developed as part of the openwrt.org project to support
> Linksys WRT1900AC and is maintained on https://github.com/kaloz/mwlwifi.
>
> The mwlwifi driver differs from existing mwifiex driver:
> o mwlwifi is a "softmac driver" using the kernel? mac802.11 subsystem
> to provide full AP/Wireless Bridge functionality (routers).
> o mwifiex is a "fullmac driver" which provides a comprehensive set of
> client functions (laptops/embedded devices)
> o only mwlwifi supports Marvell AP chip 886X series
>

[snip]

> +
> +static int mwl_mac80211_ampdu_action(struct ieee80211_hw *hw,
> +                                    struct ieee80211_vif *vif,
> +                                    enum ieee80211_ampdu_mlme_action action,
> +                                    struct ieee80211_sta *sta,
> +                                    u16 tid, u16 *ssn, u8 buf_size, bool amsdu)
> +{
> +       int rc = 0;
> +       struct mwl_priv *priv = hw->priv;
> +       struct mwl_ampdu_stream *stream;
> +       u8 *addr = sta->addr, idx;
> +       struct mwl_sta *sta_info;
> +
> +       sta_info = mwl_dev_get_sta(sta);
> +
> +       spin_lock_bh(&priv->stream_lock);
> +
> +       stream = mwl_fwcmd_lookup_stream(hw, addr, tid);
> +
> +       switch (action) {
> +       case IEEE80211_AMPDU_RX_START:
> +       case IEEE80211_AMPDU_RX_STOP:
> +               break;
> +       case IEEE80211_AMPDU_TX_START:
> +               if (!sta_info->is_ampdu_allowed) {
> +                       wiphy_warn(hw->wiphy, "ampdu not allowed\n");
> +                       rc = -EPERM;
> +                       break;
> +               }
> +
> +               if (!stream) {
> +                       stream = mwl_fwcmd_add_stream(hw, sta, tid);
> +                       if (!stream) {
> +                               wiphy_warn(hw->wiphy, "no stream found\n");
> +                               rc = -EPERM;
> +                               break;
> +                       }
> +               }
> +
> +               spin_unlock_bh(&priv->stream_lock);
> +               rc = mwl_fwcmd_check_ba(hw, stream, vif);
> +               spin_lock_bh(&priv->stream_lock);
> +               if (rc) {
> +                       mwl_fwcmd_remove_stream(hw, stream);
> +                       wiphy_err(hw->wiphy,
> +                                 "ampdu start error code: %d\n", rc);
> +                       rc = -EPERM;
> +                       break;
> +               }
> +               stream->state = AMPDU_STREAM_IN_PROGRESS;
> +               *ssn = 0;
> +               ieee80211_start_tx_ba_cb_irqsafe(vif, addr, tid);

This is why you have the race you mention below. What you should really
be doing is to wait until the all the packets for that RA / TID are sent
from all the HW Tx queues (only one realistically), and only then call the
_cb. This will allow you to send the ADDBA req on the VO queue as it should
be according to spec.

[snip]

> +
> +void mwl_rx_recv(unsigned long data)
> +{

[snip]

> +
> +                       if (unlikely(ieee80211_is_action(wh->frame_control) &&
> +                                    mgmt->u.action.category ==
> +                                    WLAN_CATEGORY_BACK &&
> +                                    mgmt->u.action.u.addba_resp.action_code ==
> +                                    WLAN_ACTION_ADDBA_RESP)) {
> +                               capab = mgmt->u.action.u.addba_resp.capab;
> +                               if (le16_to_cpu(capab) & 1)
> +                                       mwl_rx_enable_sta_amsdu(priv, mgmt->sa);

err... no. mac80211 knows how to do that today. Johannes already
reported a similar issue somewhere else in your code.

> +                       }
> +               }
> +
> +               if (ieee80211_is_data_qos(wh->frame_control) &&
> +                   ieee80211_has_a4(wh->frame_control)) {
> +                       u8 *qc = ieee80211_get_qos_ctl(wh);
> +
> +                       if (*qc & IEEE80211_QOS_CTL_A_MSDU_PRESENT)
> +                               if (mwl_rx_process_mesh_amsdu(priv, prx_skb,
> +                                                             &status))

This sounds to be something you want to teach mac80211 about.

[snip]

> +
> +#define SYSADPT_AMSDU_FW_MAX_SIZE      3300
> +
> +#define SYSADPT_AMSDU_4K_MAX_SIZE      SYSADPT_AMSDU_FW_MAX_SIZE
> +
> +#define SYSADPT_AMSDU_8K_MAX_SIZE      SYSADPT_AMSDU_FW_MAX_SIZE

In case the FW will grow later?

> +
> +#define SYSADPT_AMSDU_ALLOW_SIZE       1600
> +
> +#define SYSADPT_AMSDU_FLUSH_TIME       500
> +
> +#define SYSADPT_AMSDU_PACKET_THRESHOLD 10
> +
> +#define SYSADPT_MAX_TID                8
> +
> +#endif /* _mwl_sysadpt_h_ */
> diff --git a/drivers/net/wireless/marvell/mwlwifi/tx.c b/drivers/net/wireless/marvell/mwlwifi/tx.c
> new file mode 100644
> index 0000000..68a994d
> --- /dev/null
> +++ b/drivers/net/wireless/marvell/mwlwifi/tx.c
> @@ -0,0 +1,1251 @@
> +/*
> + * Copyright (C) 2006-2015, Marvell International Ltd.
> + *
> + * This software file (the "File") is distributed by Marvell International
> + * Ltd. under the terms of the GNU General Public License Version 2, June 1991
> + * (the "License").  You may use, redistribute and/or modify this File in
> + * accordance with the terms and conditions of the License, a copy of which
> + * is available by writing to the Free Software Foundation, Inc.
> + *
> + * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
> + * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
> + * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
> + * this warranty disclaimer.
> + */
> +
> +/* Description:  This file implements transmit related functions. */
> +
> +#include <linux/etherdevice.h>
> +#include <linux/skbuff.h>
> +
> +#include "sysadpt.h"
> +#include "dev.h"
> +#include "fwcmd.h"
> +#include "tx.h"
> +
> +#define MAX_NUM_TX_RING_BYTES  (SYSADPT_MAX_NUM_TX_DESC * \
> +                               sizeof(struct mwl_tx_desc))
> +
> +#define MAX_NUM_TX_HNDL_BYTES   (SYSADPT_MAX_NUM_TX_DESC * \
> +                               sizeof(struct mwl_tx_hndl))
> +
> +#define EAGLE_TXD_XMITCTRL_USE_MC_RATE     0x8     /* Use multicast data rate */
> +
> +#define MWL_QOS_ACK_POLICY_MASK                   0x0060
> +#define MWL_QOS_ACK_POLICY_NORMAL          0x0000
> +#define MWL_QOS_ACK_POLICY_BLOCKACK        0x0060
> +
> +#define EXT_IV                             0x20
> +#define INCREASE_IV(iv16, iv32) \
> +{ \
> +       (iv16)++; \
> +       if ((iv16) == 0) \
> +               (iv32)++; \
> +}
> +
> +/* Transmit rate information constants */
> +#define TX_RATE_FORMAT_LEGACY         0
> +#define TX_RATE_FORMAT_11N            1
> +#define TX_RATE_FORMAT_11AC           2
> +
> +#define TX_RATE_BANDWIDTH_20          0
> +#define TX_RATE_BANDWIDTH_40          1
> +#define TX_RATE_BANDWIDTH_80          2
> +
> +#define TX_RATE_INFO_STD_GI           0
> +#define TX_RATE_INFO_SHORT_GI         1
> +
> +enum {
> +       IEEE_TYPE_MANAGEMENT = 0,
> +       IEEE_TYPE_CONTROL,
> +       IEEE_TYPE_DATA
> +};
> +
> +struct ccmp_hdr {
> +       __le16 iv16;
> +       u8 rsvd;
> +       u8 key_id;
> +       __le32 iv32;
> +} __packed;
> +
> +static int mwl_tx_ring_alloc(struct mwl_priv *priv)
> +{
> +       struct mwl_desc_data *desc;
> +       int num;
> +       u8 *mem;
> +
> +       desc = &priv->desc_data[0];
> +
> +       mem = dma_alloc_coherent(&priv->pdev->dev,
> +                                MAX_NUM_TX_RING_BYTES *
> +                                SYSADPT_NUM_OF_DESC_DATA,
> +                                &desc->pphys_tx_ring,
> +                                GFP_KERNEL);
> +
> +       if (!mem) {
> +               wiphy_err(priv->hw->wiphy, "cannot alloc mem\n");
> +               return -ENOMEM;
> +       }
> +
> +       for (num = 0; num < SYSADPT_NUM_OF_DESC_DATA; num++) {
> +               desc = &priv->desc_data[num];
> +
> +               desc->ptx_ring = (struct mwl_tx_desc *)
> +                       (mem + num * MAX_NUM_TX_RING_BYTES);
> +
> +               desc->pphys_tx_ring = (dma_addr_t)
> +                       ((u32)priv->desc_data[0].pphys_tx_ring +
> +                       num * MAX_NUM_TX_RING_BYTES);
> +
> +               memset(desc->ptx_ring, 0x00,
> +                      MAX_NUM_TX_RING_BYTES);
> +       }
> +
> +       mem = kmalloc(MAX_NUM_TX_HNDL_BYTES * SYSADPT_NUM_OF_DESC_DATA,
> +                     GFP_KERNEL);
> +
> +       if (!mem) {
> +               wiphy_err(priv->hw->wiphy, "cannot alloc mem\n");
> +               dma_free_coherent(&priv->pdev->dev,
> +                                 MAX_NUM_TX_RING_BYTES *
> +                                 SYSADPT_NUM_OF_DESC_DATA,
> +                                 priv->desc_data[0].ptx_ring,
> +                                 priv->desc_data[0].pphys_tx_ring);
> +               return -ENOMEM;
> +       }
> +
> +       for (num = 0; num < SYSADPT_NUM_OF_DESC_DATA; num++) {
> +               desc = &priv->desc_data[num];
> +
> +               desc->tx_hndl = (struct mwl_tx_hndl *)
> +                       (mem + num * MAX_NUM_TX_HNDL_BYTES);
> +
> +               memset(desc->tx_hndl, 0x00,
> +                      MAX_NUM_TX_HNDL_BYTES);
> +       }
> +
> +       return 0;
> +}
> +
> +static int mwl_tx_ring_init(struct mwl_priv *priv)
> +{
> +       int num, i;
> +       struct mwl_desc_data *desc;
> +
> +       for (num = 0; num < SYSADPT_NUM_OF_DESC_DATA; num++) {
> +               skb_queue_head_init(&priv->txq[num]);
> +               priv->fw_desc_cnt[num] = 0;
> +
> +               desc = &priv->desc_data[num];
> +
> +               if (desc->ptx_ring) {
> +                       for (i = 0; i < SYSADPT_MAX_NUM_TX_DESC; i++) {
> +                               desc->ptx_ring[i].status =
> +                                       cpu_to_le32(EAGLE_TXD_STATUS_IDLE);
> +                               desc->ptx_ring[i].pphys_next =
> +                                       cpu_to_le32((u32)desc->pphys_tx_ring +
> +                                       ((i + 1) * sizeof(struct mwl_tx_desc)));
> +                               desc->tx_hndl[i].pdesc =
> +                                       &desc->ptx_ring[i];
> +                               if (i < SYSADPT_MAX_NUM_TX_DESC - 1)
> +                                       desc->tx_hndl[i].pnext =
> +                                               &desc->tx_hndl[i + 1];
> +                       }
> +                       desc->ptx_ring[SYSADPT_MAX_NUM_TX_DESC - 1].pphys_next =
> +                               cpu_to_le32((u32)desc->pphys_tx_ring);
> +                       desc->tx_hndl[SYSADPT_MAX_NUM_TX_DESC - 1].pnext =
> +                               &desc->tx_hndl[0];
> +
> +                       desc->pstale_tx_hndl = &desc->tx_hndl[0];
> +                       desc->pnext_tx_hndl  = &desc->tx_hndl[0];
> +               } else {
> +                       wiphy_err(priv->hw->wiphy, "no valid TX mem\n");
> +                       return -ENOMEM;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +static void mwl_tx_ring_cleanup(struct mwl_priv *priv)
> +{
> +       int cleaned_tx_desc = 0;
> +       int num, i;
> +       struct mwl_desc_data *desc;
> +
> +       for (num = 0; num < SYSADPT_NUM_OF_DESC_DATA; num++) {
> +               skb_queue_purge(&priv->txq[num]);
> +               priv->fw_desc_cnt[num] = 0;
> +
> +               desc = &priv->desc_data[num];
> +
> +               if (desc->ptx_ring) {
> +                       for (i = 0; i < SYSADPT_MAX_NUM_TX_DESC; i++) {
> +                               if (!desc->tx_hndl[i].psk_buff)
> +                                       continue;
> +
> +                               wiphy_info(priv->hw->wiphy,
> +                                          "unmapped and free'd %i 0x%p 0x%x\n",
> +                                          i,
> +                                          desc->tx_hndl[i].psk_buff->data,
> +                                          le32_to_cpu(
> +                                          desc->ptx_ring[i].pkt_ptr));
> +                               pci_unmap_single(priv->pdev,
> +                                                le32_to_cpu(
> +                                                desc->ptx_ring[i].pkt_ptr),
> +                                                desc->tx_hndl[i].psk_buff->len,
> +                                                PCI_DMA_TODEVICE);
> +                               dev_kfree_skb_any(desc->tx_hndl[i].psk_buff);
> +                               desc->ptx_ring[i].status =
> +                                       cpu_to_le32(EAGLE_TXD_STATUS_IDLE);
> +                               desc->ptx_ring[i].pkt_ptr = 0;
> +                               desc->ptx_ring[i].pkt_len = 0;
> +                               desc->tx_hndl[i].psk_buff = NULL;
> +                               cleaned_tx_desc++;
> +                       }
> +               }
> +       }
> +
> +       wiphy_info(priv->hw->wiphy, "cleaned %i TX descr\n", cleaned_tx_desc);
> +}
> +
> +static void mwl_tx_ring_free(struct mwl_priv *priv)
> +{
> +       int num;
> +
> +       if (priv->desc_data[0].ptx_ring) {
> +               dma_free_coherent(&priv->pdev->dev,
> +                                 MAX_NUM_TX_RING_BYTES *
> +                                 SYSADPT_NUM_OF_DESC_DATA,
> +                                 priv->desc_data[0].ptx_ring,
> +                                 priv->desc_data[0].pphys_tx_ring);
> +       }
> +
> +       for (num = 0; num < SYSADPT_NUM_OF_DESC_DATA; num++) {
> +               if (priv->desc_data[num].ptx_ring)
> +                       priv->desc_data[num].ptx_ring = NULL;
> +               priv->desc_data[num].pstale_tx_hndl = NULL;
> +               priv->desc_data[num].pnext_tx_hndl = NULL;
> +       }
> +
> +       kfree(priv->desc_data[0].tx_hndl);
> +}
> +
> +static inline void mwl_tx_add_dma_header(struct mwl_priv *priv,
> +                                        struct sk_buff *skb,
> +                                        int head_pad,
> +                                        int tail_pad)
> +{
> +       struct ieee80211_hdr *wh;
> +       int hdrlen;
> +       int reqd_hdrlen;
> +       struct mwl_dma_data *tr;
> +
> +       /* Add a firmware DMA header; the firmware requires that we
> +        * present a 2-byte payload length followed by a 4-address
> +        * header (without QoS field), followed (optionally) by any
> +        * WEP/ExtIV header (but only filled in for CCMP).
> +        */
> +       wh = (struct ieee80211_hdr *)skb->data;
> +
> +       hdrlen = ieee80211_hdrlen(wh->frame_control);
> +
> +       reqd_hdrlen = sizeof(*tr) + head_pad;
> +
> +       if (hdrlen != reqd_hdrlen)
> +               skb_push(skb, reqd_hdrlen - hdrlen);
> +
> +       if (ieee80211_is_data_qos(wh->frame_control))
> +               hdrlen -= IEEE80211_QOS_CTL_LEN;
> +
> +       tr = (struct mwl_dma_data *)skb->data;
> +
> +       if (wh != &tr->wh)
> +               memmove(&tr->wh, wh, hdrlen);
> +
> +       if (hdrlen != sizeof(tr->wh))
> +               memset(((void *)&tr->wh) + hdrlen, 0, sizeof(tr->wh) - hdrlen);
> +
> +       /* Firmware length is the length of the fully formed "802.11
> +        * payload".  That is, everything except for the 802.11 header.
> +        * This includes all crypto material including the MIC.
> +        */
> +       tr->fwlen = cpu_to_le16(skb->len - sizeof(*tr) + tail_pad);
> +}
> +
> +static inline void mwl_tx_encapsulate_frame(struct mwl_priv *priv,
> +                                           struct sk_buff *skb,
> +                                           struct ieee80211_key_conf *k_conf,
> +                                           bool *ccmp)
> +{
> +       int head_pad = 0;
> +       int data_pad = 0;
> +
> +       /* Make sure the packet header is in the DMA header format (4-address
> +        * without QoS), and add head & tail padding when HW crypto is enabled.
> +        *
> +        * We have the following trailer padding requirements:
> +        * - WEP: 4 trailer bytes (ICV)
> +        * - TKIP: 12 trailer bytes (8 MIC + 4 ICV)
> +        * - CCMP: 8 trailer bytes (MIC)
> +        */
> +
> +       if (k_conf) {
> +               head_pad = k_conf->iv_len;
> +
> +               switch (k_conf->cipher) {
> +               case WLAN_CIPHER_SUITE_WEP40:
> +               case WLAN_CIPHER_SUITE_WEP104:
> +                       data_pad = 4;
> +                       break;
> +               case WLAN_CIPHER_SUITE_TKIP:
> +                       data_pad = 12;
> +                       break;
> +               case WLAN_CIPHER_SUITE_CCMP:
> +                       data_pad = 8;
> +                       *ccmp = true;
> +                       break;
> +               }
> +       }
> +
> +       mwl_tx_add_dma_header(priv, skb, head_pad, data_pad);
> +}
> +
> +static inline void mwl_tx_insert_ccmp_hdr(u8 *pccmp_hdr,
> +                                         u8 key_id, u16 iv16, u32 iv32)
> +{
> +       struct ccmp_hdr *ccmp_h = (struct ccmp_hdr *)pccmp_hdr;
> +
> +       ccmp_h->iv16 = cpu_to_le16(iv16);
> +       ccmp_h->rsvd = 0;
> +       ccmp_h->key_id = EXT_IV | (key_id << 6);
> +       ccmp_h->iv32 = cpu_to_le32(iv32);
> +}
> +
> +static inline int mwl_tx_tid_queue_mapping(u8 tid)
> +{
> +       switch (tid) {
> +       case 0:
> +       case 3:
> +               return IEEE80211_AC_BE;
> +       case 1:
> +       case 2:
> +               return IEEE80211_AC_BK;
> +       case 4:
> +       case 5:
> +               return IEEE80211_AC_VI;
> +       case 6:
> +       case 7:
> +               return IEEE80211_AC_VO;
> +       default:
> +               break;
> +       }
> +
> +       return -1;
> +}
> +
> +static inline void mwl_tx_count_packet(struct ieee80211_sta *sta, u8 tid)
> +{
> +       struct mwl_sta *sta_info;
> +       struct mwl_tx_info *tx_stats;
> +
> +       if (WARN_ON(tid >= SYSADPT_MAX_TID))
> +               return;
> +
> +       sta_info = mwl_dev_get_sta(sta);
> +
> +       tx_stats = &sta_info->tx_stats[tid];
> +
> +       if (tx_stats->start_time == 0)
> +               tx_stats->start_time = jiffies;
> +
> +       /* reset the packet count after each second elapses.  If the number of
> +        * packets ever exceeds the ampdu_min_traffic threshold, we will allow
> +        * an ampdu stream to be started.
> +        */
> +       if (jiffies - tx_stats->start_time > HZ) {
> +               tx_stats->pkts = 0;
> +               tx_stats->start_time = 0;
> +       } else {
> +               tx_stats->pkts++;
> +       }
> +}
> +
> +static inline bool mwl_tx_available(struct mwl_priv *priv, int desc_num)
> +{
> +       struct mwl_tx_hndl *tx_hndl;
> +
> +       tx_hndl = priv->desc_data[desc_num].pnext_tx_hndl;
> +
> +       if (!tx_hndl->pdesc)
> +               return false;
> +
> +       if (tx_hndl->pdesc->status != EAGLE_TXD_STATUS_IDLE) {
> +               /* Interrupt F/W anyway */
> +               if (tx_hndl->pdesc->status &
> +                   cpu_to_le32(EAGLE_TXD_STATUS_FW_OWNED))
> +                       writel(MACREG_H2ARIC_BIT_PPA_READY,
> +                              priv->iobase1 +
> +                              MACREG_REG_H2A_INTERRUPT_EVENTS);
> +               return false;
> +       }
> +
> +       return true;
> +}
> +
> +static inline void mwl_tx_skb(struct mwl_priv *priv, int desc_num,
> +                             struct sk_buff *tx_skb)
> +{
> +       struct ieee80211_tx_info *tx_info;
> +       struct mwl_tx_ctrl *tx_ctrl;
> +       struct mwl_tx_hndl *tx_hndl;
> +       struct mwl_tx_desc *tx_desc;
> +       struct ieee80211_sta *sta;
> +       struct ieee80211_vif *vif;
> +       struct mwl_vif *mwl_vif;
> +       struct ieee80211_key_conf *k_conf;
> +       bool ccmp = false;
> +       struct mwl_dma_data *dma_data;
> +       struct ieee80211_hdr *wh;
> +       dma_addr_t dma;
> +
> +       if (WARN_ON(!tx_skb))
> +               return;
> +
> +       tx_info = IEEE80211_SKB_CB(tx_skb);
> +       tx_ctrl = (struct mwl_tx_ctrl *)&tx_info->status;
> +       sta = (struct ieee80211_sta *)tx_ctrl->sta;
> +       vif = (struct ieee80211_vif *)tx_ctrl->vif;
> +       mwl_vif = mwl_dev_get_vif(vif);
> +       k_conf = (struct ieee80211_key_conf *)tx_ctrl->k_conf;
> +
> +       mwl_tx_encapsulate_frame(priv, tx_skb, k_conf, &ccmp);
> +
> +       dma_data = (struct mwl_dma_data *)tx_skb->data;
> +       wh = &dma_data->wh;
> +
> +       if (ieee80211_is_data(wh->frame_control)) {
> +               if (is_multicast_ether_addr(wh->addr1)) {
> +                       if (ccmp) {
> +                               mwl_tx_insert_ccmp_hdr(dma_data->data,
> +                                                      mwl_vif->keyidx,
> +                                                      mwl_vif->iv16,
> +                                                      mwl_vif->iv32);
> +                               INCREASE_IV(mwl_vif->iv16, mwl_vif->iv32);
> +                       }
> +               } else {
> +                       if (ccmp) {
> +                               if (vif->type == NL80211_IFTYPE_STATION) {
> +                                       mwl_tx_insert_ccmp_hdr(dma_data->data,
> +                                                              mwl_vif->keyidx,
> +                                                              mwl_vif->iv16,
> +                                                              mwl_vif->iv32);
> +                                       INCREASE_IV(mwl_vif->iv16,
> +                                                   mwl_vif->iv32);
> +                               } else {
> +                                       struct mwl_sta *sta_info;
> +
> +                                       sta_info = mwl_dev_get_sta(sta);
> +
> +                                       mwl_tx_insert_ccmp_hdr(dma_data->data,
> +                                                              0,
> +                                                              sta_info->iv16,
> +                                                              sta_info->iv32);
> +                                       INCREASE_IV(sta_info->iv16,
> +                                                   sta_info->iv32);
> +                               }
> +                       }
> +               }
> +       }
> +
> +       tx_hndl = priv->desc_data[desc_num].pnext_tx_hndl;
> +       tx_hndl->psk_buff = tx_skb;
> +       tx_desc = tx_hndl->pdesc;
> +       tx_desc->tx_priority = tx_ctrl->tx_priority;
> +       tx_desc->qos_ctrl = cpu_to_le16(tx_ctrl->qos_ctrl);
> +       tx_desc->pkt_len = cpu_to_le16(tx_skb->len);
> +       tx_desc->packet_info = 0;
> +       tx_desc->data_rate = 0;
> +       tx_desc->type = tx_ctrl->type;
> +       tx_desc->xmit_control = tx_ctrl->xmit_control;
> +       tx_desc->sap_pkt_info = 0;
> +       dma = pci_map_single(priv->pdev, tx_skb->data,
> +                            tx_skb->len, PCI_DMA_TODEVICE);
> +       if (pci_dma_mapping_error(priv->pdev, dma)) {
> +               dev_kfree_skb_any(tx_skb);
> +               wiphy_err(priv->hw->wiphy,
> +                         "failed to map pci memory!\n");
> +               return;
> +       }
> +       tx_desc->pkt_ptr = cpu_to_le32(dma);
> +       tx_desc->status = cpu_to_le32(EAGLE_TXD_STATUS_FW_OWNED);
> +       /* make sure all the memory transactions done by cpu were completed */
> +       wmb();  /*Data Memory Barrier*/
> +       writel(MACREG_H2ARIC_BIT_PPA_READY,
> +              priv->iobase1 + MACREG_REG_H2A_INTERRUPT_EVENTS);
> +       priv->desc_data[desc_num].pnext_tx_hndl = tx_hndl->pnext;
> +       priv->fw_desc_cnt[desc_num]++;
> +}
> +
> +static inline struct sk_buff *mwl_tx_do_amsdu(struct mwl_priv *priv,
> +                                             int desc_num,
> +                                             struct sk_buff *tx_skb,
> +                                             struct ieee80211_tx_info *tx_info)
> +{
> +       struct ieee80211_sta *sta;
> +       struct mwl_sta *sta_info;
> +       struct mwl_tx_ctrl *tx_ctrl = (struct mwl_tx_ctrl *)&tx_info->status;
> +       struct ieee80211_tx_info *amsdu_info;
> +       struct sk_buff_head *amsdu_pkts;
> +       struct mwl_amsdu_frag *amsdu;
> +       int amsdu_allow_size;
> +       struct ieee80211_hdr *wh;
> +       int wh_len;
> +       u16 len;
> +       u8 *data;
> +
> +       sta = (struct ieee80211_sta *)tx_ctrl->sta;
> +       sta_info = mwl_dev_get_sta(sta);
> +
> +       if (!sta_info->is_amsdu_allowed)
> +               return tx_skb;
> +
> +       wh = (struct ieee80211_hdr *)tx_skb->data;
> +       if (sta_info->is_mesh_node && is_multicast_ether_addr(wh->addr3))
> +               return tx_skb;
> +
> +       if (sta_info->amsdu_ctrl.cap == MWL_AMSDU_SIZE_4K)
> +               amsdu_allow_size = SYSADPT_AMSDU_4K_MAX_SIZE;
> +       else if (sta_info->amsdu_ctrl.cap == MWL_AMSDU_SIZE_8K)
> +               amsdu_allow_size = SYSADPT_AMSDU_8K_MAX_SIZE;
> +       else
> +               return tx_skb;
> +
> +       spin_lock_bh(&sta_info->amsdu_lock);
> +       amsdu = &sta_info->amsdu_ctrl.frag[desc_num];
> +
> +       if (tx_skb->len > SYSADPT_AMSDU_ALLOW_SIZE) {
> +               if (amsdu->num) {
> +                       mwl_tx_skb(priv, desc_num, amsdu->skb);
> +                       amsdu->num = 0;
> +                       amsdu->cur_pos = NULL;
> +
> +                       if (!mwl_tx_available(priv, desc_num)) {
> +                               skb_queue_head(&priv->txq[desc_num], tx_skb);
> +                               spin_unlock_bh(&sta_info->amsdu_lock);
> +                               return NULL;
> +                       }
> +               }
> +               spin_unlock_bh(&sta_info->amsdu_lock);
> +               return tx_skb;
> +       }
> +
> +       /* potential amsdu size, should add amsdu header 14 bytes +
> +        * maximum padding 3.
> +        */
> +       wh_len = ieee80211_hdrlen(wh->frame_control);
> +       len = tx_skb->len - wh_len + 17;
> +
> +       if (amsdu->num) {
> +               if ((amsdu->skb->len + len) > amsdu_allow_size) {
> +                       mwl_tx_skb(priv, desc_num, amsdu->skb);
> +                       amsdu->num = 0;
> +                       amsdu->cur_pos = NULL;
> +               }
> +       }
> +
> +       amsdu->jiffies = jiffies;
> +       len = tx_skb->len - wh_len;
> +
> +       if (amsdu->num == 0) {
> +               struct sk_buff *newskb;
> +
> +               amsdu_pkts = (struct sk_buff_head *)
> +                       kmalloc(sizeof(*amsdu_pkts), GFP_KERNEL);
> +               if (!amsdu_pkts) {
> +                       spin_unlock_bh(&sta_info->amsdu_lock);
> +                       return tx_skb;
> +               }
> +               newskb = dev_alloc_skb(amsdu_allow_size +
> +                                      SYSADPT_MIN_BYTES_HEADROOM);
> +               if (!newskb) {
> +                       spin_unlock_bh(&sta_info->amsdu_lock);
> +                       kfree(amsdu_pkts);
> +                       return tx_skb;
> +               }
> +
> +               data = newskb->data;
> +               memcpy(data, tx_skb->data, wh_len);
> +               if (sta_info->is_mesh_node) {
> +                       ether_addr_copy(data + wh_len, wh->addr3);
> +                       ether_addr_copy(data + wh_len + ETH_ALEN, wh->addr4);
> +               } else {
> +                       ether_addr_copy(data + wh_len,
> +                                       ieee80211_get_DA(wh));
> +                       ether_addr_copy(data + wh_len + ETH_ALEN,
> +                                       ieee80211_get_SA(wh));
> +               }
> +               *(u8 *)(data + wh_len + ETH_HLEN - 1) = len & 0xff;
> +               *(u8 *)(data + wh_len + ETH_HLEN - 2) = (len >> 8) & 0xff;

These bit oeprations are not needed. The pointer must be WORD aligned, right?
This is why you have padding after all, unless you have some weird DMA games?
You seem to be assuming this alignment anyway because you use
ether_addr_copy above.

> +
> +       /* Queue ADDBA request in the respective data queue.  While setting up
> +        * the ampdu stream, mac80211 queues further packets for that
> +        * particular ra/tid pair.  However, packets piled up in the hardware
> +        * for that ra/tid pair will still go out. ADDBA request and the
> +        * related data packets going out from different queues asynchronously
> +        * will cause a shift in the receiver window which might result in
> +        * ampdu packets getting dropped at the receiver after the stream has
> +        * been setup.
> +        */

Here is the race you are facing and that race can be avoided by the proper usage
of the _cb

> +       if (mgmtframe) {
> +               u16 capab;
> +
> +               if (unlikely(ieee80211_is_action(wh->frame_control) &&
> +                            mgmt->u.action.category == WLAN_CATEGORY_BACK &&
> +                            mgmt->u.action.u.addba_req.action_code ==
> +                            WLAN_ACTION_ADDBA_REQ)) {
> +                       capab = le16_to_cpu(mgmt->u.action.u.addba_req.capab);
> +                       tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
> +                       index = mwl_tx_tid_queue_mapping(tid);
> +                       capab |= 1;
> +                       mgmt->u.action.u.addba_req.capab = cpu_to_le16(capab);
> +               }
> +
> +               if (unlikely(ieee80211_is_action(wh->frame_control) &&
> +                            mgmt->u.action.category == WLAN_CATEGORY_BACK &&
> +                            mgmt->u.action.u.addba_resp.action_code ==
> +                            WLAN_ACTION_ADDBA_RESP)) {
> +                       capab = le16_to_cpu(mgmt->u.action.u.addba_resp.capab);
> +                       capab |= 1;
> +                       mgmt->u.action.u.addba_resp.capab = cpu_to_le16(capab);
> +               }
> +       }
> +
> +       index = SYSADPT_TX_WMM_QUEUES - index - 1;
> +       txpriority = index;
> +
> +       if (sta && sta->ht_cap.ht_supported && !eapol_frame &&
> +           ieee80211_is_data_qos(wh->frame_control)) {
> +               tid = qos & 0xf;
> +               mwl_tx_count_packet(sta, tid);
> +
> +               spin_lock_bh(&priv->stream_lock);
> +               stream = mwl_fwcmd_lookup_stream(hw, sta->addr, tid);
> +
> +               if (stream) {
> +                       if (stream->state == AMPDU_STREAM_ACTIVE) {
> +                               if (WARN_ON(!(qos &
> +                                           MWL_QOS_ACK_POLICY_BLOCKACK))) {
> +                                       spin_unlock_bh(&priv->stream_lock);
> +                                       dev_kfree_skb_any(skb);
> +                                       return;
> +                               }
> +
> +                               txpriority =
> +                                       (SYSADPT_TX_WMM_QUEUES + stream->idx) %
> +                                       SYSADPT_TOTAL_HW_QUEUES;
> +                       } else if (stream->state == AMPDU_STREAM_NEW) {
> +                               /* We get here if the driver sends us packets
> +                                * after we've initiated a stream, but before
> +                                * our ampdu_action routine has been called
> +                                * with IEEE80211_AMPDU_TX_START to get the SSN
> +                                * for the ADDBA request.  So this packet can
> +                                * go out with no risk of sequence number
> +                                * mismatch.  No special handling is required.
> +                                */
> +                       } else {
> +                               /* Drop packets that would go out after the
> +                                * ADDBA request was sent but before the ADDBA
> +                                * response is received.  If we don't do this,
> +                                * the recipient would probably receive it
> +                                * after the ADDBA request with SSN 0.  This
> +                                * will cause the recipient's BA receive window
> +                                * to shift, which would cause the subsequent
> +                                * packets in the BA stream to be discarded.
> +                                * mac80211 queues our packets for us in this
> +                                * case, so this is really just a safety check.
> +                                */

Well... I think you can really avoid that.
