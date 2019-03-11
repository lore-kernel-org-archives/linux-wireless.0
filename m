Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE0AAC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 12:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96DD2206BA
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 12:51:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfCKMu7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 08:50:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27867 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbfCKMu7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 08:50:59 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A34F030821E2;
        Mon, 11 Mar 2019 12:50:58 +0000 (UTC)
Received: from localhost (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 69DBE1001E6E;
        Mon, 11 Mar 2019 12:50:57 +0000 (UTC)
Date:   Mon, 11 Mar 2019 13:50:55 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, johannes@sipsolutions.net,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        Larry.Finger@lwfinger.net, pkshih@realtek.com, tehuang@realtek.com,
        briannorris@chromium.org
Subject: Re: [PATCH v7 03/14] rtw88: hci files
Message-ID: <20190311125054.GA5005@redhat.com>
References: <1552139302-20476-1-git-send-email-yhchuang@realtek.com>
 <1552139302-20476-4-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1552139302-20476-4-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 11 Mar 2019 12:50:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Mar 09, 2019 at 09:48:11PM +0800, yhchuang@realtek.com wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> hci files for Realtek 802.11ac wireless network chips
> 
> For now there is only PCI bus supported by rtwlan, in the future it
> will also have USB/SDIO
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> ---
>  drivers/net/wireless/realtek/rtw88/hci.h |  211 ++++++
>  drivers/net/wireless/realtek/rtw88/pci.c | 1211 ++++++++++++++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/pci.h |  237 ++++++
>  3 files changed, 1659 insertions(+)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/hci.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/pci.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/pci.h
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/hci.h b/drivers/net/wireless/realtek/rtw88/hci.h
> new file mode 100644
> index 0000000..91b15ef
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/hci.h
> @@ -0,0 +1,211 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2018  Realtek Corporation.
> + */
> +
> +#ifndef	__RTW_HCI_H__
> +#define __RTW_HCI_H__
> +
> +/* ops for PCI, USB and SDIO */
> +struct rtw_hci_ops {
> +	int (*tx)(struct rtw_dev *rtwdev,
> +		  struct rtw_tx_pkt_info *pkt_info,
> +		  struct sk_buff *skb);
> +	int (*setup)(struct rtw_dev *rtwdev);
> +	int (*start)(struct rtw_dev *rtwdev);
> +	void (*stop)(struct rtw_dev *rtwdev);
> +
> +	int (*write_data_rsvd_page)(struct rtw_dev *rtwdev, u8 *buf, u32 size);
> +	int (*write_data_h2c)(struct rtw_dev *rtwdev, u8 *buf, u32 size);
> +
> +	u8 (*read8)(struct rtw_dev *rtwdev, u32 addr);
> +	u16 (*read16)(struct rtw_dev *rtwdev, u32 addr);
> +	u32 (*read32)(struct rtw_dev *rtwdev, u32 addr);
> +	void (*write8)(struct rtw_dev *rtwdev, u32 addr, u8 val);
> +	void (*write16)(struct rtw_dev *rtwdev, u32 addr, u16 val);
> +	void (*write32)(struct rtw_dev *rtwdev, u32 addr, u32 val);
> +};
> +
> +static inline int rtw_hci_tx(struct rtw_dev *rtwdev,
> +			     struct rtw_tx_pkt_info *pkt_info,
> +			     struct sk_buff *skb)
> +{
> +	return rtwdev->hci.ops->tx(rtwdev, pkt_info, skb);
> +}
> +
> +static inline int rtw_hci_setup(struct rtw_dev *rtwdev)
> +{
> +	return rtwdev->hci.ops->setup(rtwdev);
> +}
> +
> +static inline int rtw_hci_start(struct rtw_dev *rtwdev)
> +{
> +	return rtwdev->hci.ops->start(rtwdev);
> +}
> +
> +static inline void rtw_hci_stop(struct rtw_dev *rtwdev)
> +{
> +	rtwdev->hci.ops->stop(rtwdev);
> +}
> +
> +static inline int
> +rtw_hci_write_data_rsvd_page(struct rtw_dev *rtwdev, u8 *buf, u32 size)
> +{
> +	return rtwdev->hci.ops->write_data_rsvd_page(rtwdev, buf, size);
> +}
> +
> +static inline int
> +rtw_hci_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
> +{
> +	return rtwdev->hci.ops->write_data_h2c(rtwdev, buf, size);
> +}
> +
> +static inline u8 rtw_read8(struct rtw_dev *rtwdev, u32 addr)
> +{
> +	return rtwdev->hci.ops->read8(rtwdev, addr);
> +}
> +
> +static inline u16 rtw_read16(struct rtw_dev *rtwdev, u32 addr)
> +{
> +	return rtwdev->hci.ops->read16(rtwdev, addr);
> +}
> +
> +static inline u32 rtw_read32(struct rtw_dev *rtwdev, u32 addr)
> +{
> +	return rtwdev->hci.ops->read32(rtwdev, addr);
> +}
> +
> +static inline void rtw_write8(struct rtw_dev *rtwdev, u32 addr, u8 val)
> +{
> +	rtwdev->hci.ops->write8(rtwdev, addr, val);
> +}
> +
> +static inline void rtw_write16(struct rtw_dev *rtwdev, u32 addr, u16 val)
> +{
> +	rtwdev->hci.ops->write16(rtwdev, addr, val);
> +}
> +
> +static inline void rtw_write32(struct rtw_dev *rtwdev, u32 addr, u32 val)
> +{
> +	rtwdev->hci.ops->write32(rtwdev, addr, val);
> +}
> +
> +static inline void rtw_write8_set(struct rtw_dev *rtwdev, u32 addr, u8 bit)
> +{
> +	u8 val;
> +
> +	val = rtw_read8(rtwdev, addr);
> +	rtw_write8(rtwdev, addr, val | bit);
> +}
> +
> +static inline void rtw_writ16_set(struct rtw_dev *rtwdev, u32 addr, u16 bit)
> +{
> +	u16 val;
> +
> +	val = rtw_read16(rtwdev, addr);
> +	rtw_write16(rtwdev, addr, val | bit);
> +}
> +
> +static inline void rtw_write32_set(struct rtw_dev *rtwdev, u32 addr, u32 bit)
> +{
> +	u32 val;
> +
> +	val = rtw_read32(rtwdev, addr);
> +	rtw_write32(rtwdev, addr, val | bit);
> +}
> +
> +static inline void rtw_write8_clr(struct rtw_dev *rtwdev, u32 addr, u8 bit)
> +{
> +	u8 val;
> +
> +	val = rtw_read8(rtwdev, addr);
> +	rtw_write8(rtwdev, addr, val & ~bit);
> +}
> +
> +static inline void rtw_write16_clr(struct rtw_dev *rtwdev, u32 addr, u16 bit)
> +{
> +	u16 val;
> +
> +	val = rtw_read16(rtwdev, addr);
> +	rtw_write16(rtwdev, addr, val & ~bit);
> +}
> +
> +static inline void rtw_write32_clr(struct rtw_dev *rtwdev, u32 addr, u32 bit)
> +{
> +	u32 val;
> +
> +	val = rtw_read32(rtwdev, addr);
> +	rtw_write32(rtwdev, addr, val & ~bit);
> +}
> +
> +static inline u32
> +rtw_read_rf(struct rtw_dev *rtwdev, enum rtw_rf_path rf_path,
> +	    u32 addr, u32 mask)
> +{
> +	unsigned long flags;
> +	u32 val;
> +
> +	spin_lock_irqsave(&rtwdev->rf_lock, flags);
> +	val = rtwdev->chip->ops->read_rf(rtwdev, rf_path, addr, mask);
> +	spin_unlock_irqrestore(&rtwdev->rf_lock, flags);
> +
> +	return val;
> +}
> +
> +static inline void
> +rtw_write_rf(struct rtw_dev *rtwdev, enum rtw_rf_path rf_path,
> +	     u32 addr, u32 mask, u32 data)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&rtwdev->rf_lock, flags);
> +	rtwdev->chip->ops->write_rf(rtwdev, rf_path, addr, mask, data);
> +	spin_unlock_irqrestore(&rtwdev->rf_lock, flags);
> +}
> +
> +static inline u32
> +rtw_read32_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask)
> +{
> +	u32 shift = __ffs(mask);
> +	u32 orig;
> +	u32 ret;
> +
> +	orig = rtw_read32(rtwdev, addr);
> +	ret = (orig & mask) >> shift;
> +
> +	return ret;
> +}
> +
> +static inline void
> +rtw_write32_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 data)
> +{
> +	u32 shift = __ffs(mask);
> +	u32 orig;
> +	u32 set;
> +
> +	WARN(addr & 0x3, "should be 4-byte aligned, addr = 0x%08x\n", addr);
> +
> +	orig = rtw_read32(rtwdev, addr);
> +	set = (orig & ~mask) | ((data << shift) & mask);
> +	rtw_write32(rtwdev, addr, set);
> +}
> +
> +static inline void
> +rtw_write8_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u8 data)
> +{
> +	u32 shift;
> +	u8 orig, set;
> +
> +	mask &= 0xff;
> +	shift = __ffs(mask);
> +
> +	orig = rtw_read8(rtwdev, addr);
> +	set = (orig & ~mask) | ((data << shift) & mask);
> +	rtw_write8(rtwdev, addr, set);
> +}
> +
> +static inline enum rtw_hci_type rtw_hci_type(struct rtw_dev *rtwdev)
> +{
> +	return rtwdev->hci.type;
> +}
> +
> +#endif
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
> new file mode 100644
> index 0000000..cf3bffb
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -0,0 +1,1211 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2018  Realtek Corporation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include "main.h"
> +#include "pci.h"
> +#include "tx.h"
> +#include "rx.h"
> +#include "debug.h"
> +
> +static u32 rtw_pci_tx_queue_idx_addr[] = {
> +	[RTW_TX_QUEUE_BK]	= RTK_PCI_TXBD_IDX_BKQ,
> +	[RTW_TX_QUEUE_BE]	= RTK_PCI_TXBD_IDX_BEQ,
> +	[RTW_TX_QUEUE_VI]	= RTK_PCI_TXBD_IDX_VIQ,
> +	[RTW_TX_QUEUE_VO]	= RTK_PCI_TXBD_IDX_VOQ,
> +	[RTW_TX_QUEUE_MGMT]	= RTK_PCI_TXBD_IDX_MGMTQ,
> +	[RTW_TX_QUEUE_HI0]	= RTK_PCI_TXBD_IDX_HI0Q,
> +	[RTW_TX_QUEUE_H2C]	= RTK_PCI_TXBD_IDX_H2CQ,
> +};
> +
> +static u8 rtw_pci_get_tx_qsel(struct sk_buff *skb, u8 queue)
> +{
> +	switch (queue) {
> +	case RTW_TX_QUEUE_BCN:
> +		return TX_DESC_QSEL_BEACON;
> +	case RTW_TX_QUEUE_H2C:
> +		return TX_DESC_QSEL_H2C;
> +	case RTW_TX_QUEUE_MGMT:
> +		return TX_DESC_QSEL_MGMT;
> +	case RTW_TX_QUEUE_HI0:
> +		return TX_DESC_QSEL_HIGH;
> +	default:
> +		return skb->priority;
> +	}
> +};
> +
> +static u8 rtw_pci_read8(struct rtw_dev *rtwdev, u32 addr)
> +{
> +	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> +
> +	return readb(rtwpci->mmap + addr);
> +}
> +
> +static u16 rtw_pci_read16(struct rtw_dev *rtwdev, u32 addr)
> +{
> +	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> +
> +	return readw(rtwpci->mmap + addr);
> +}
> +
> +static u32 rtw_pci_read32(struct rtw_dev *rtwdev, u32 addr)
> +{
> +	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> +
> +	return readl(rtwpci->mmap + addr);
> +}
> +
> +static void rtw_pci_write8(struct rtw_dev *rtwdev, u32 addr, u8 val)
> +{
> +	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> +
> +	writeb(val, rtwpci->mmap + addr);
> +}
> +
> +static void rtw_pci_write16(struct rtw_dev *rtwdev, u32 addr, u16 val)
> +{
> +	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> +
> +	writew(val, rtwpci->mmap + addr);
> +}
> +
> +static void rtw_pci_write32(struct rtw_dev *rtwdev, u32 addr, u32 val)
> +{
> +	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> +
> +	writel(val, rtwpci->mmap + addr);
> +}
> +
> +static inline void *rtw_pci_get_tx_desc(struct rtw_pci_tx_ring *tx_ring, u8 idx)
> +{
> +	int offset = tx_ring->r.desc_size * idx;
> +
> +	return tx_ring->r.head + offset;
> +}
> +
> +static void rtw_pci_free_tx_ring(struct rtw_dev *rtwdev,
> +				 struct rtw_pci_tx_ring *tx_ring)
> +{
> +	struct pci_dev *pdev = to_pci_dev(rtwdev->dev);
> +	struct rtw_pci_tx_data *tx_data;
> +	struct sk_buff *skb, *tmp;
> +	dma_addr_t dma;
> +	u8 *head = tx_ring->r.head;
> +	u32 len = tx_ring->r.len;
> +	int ring_sz = len * tx_ring->r.desc_size;
> +
> +	/* free every skb remained in tx list */
> +	skb_queue_walk_safe(&tx_ring->queue, skb, tmp) {
> +		__skb_unlink(skb, &tx_ring->queue);
> +		tx_data = rtw_pci_get_tx_data(skb);
> +		dma = tx_data->dma;
> +
> +		pci_unmap_single(pdev, dma, skb->len, PCI_DMA_TODEVICE);
> +		dev_kfree_skb_any(skb);
> +	}
> +
> +	/* free the ring itself */
> +	pci_free_consistent(pdev, ring_sz, head, tx_ring->r.dma);
> +	tx_ring->r.head = NULL;
> +}
> +
> +static void rtw_pci_free_rx_ring(struct rtw_dev *rtwdev,
> +				 struct rtw_pci_rx_ring *rx_ring)
> +{
> +	struct pci_dev *pdev = to_pci_dev(rtwdev->dev);
> +	struct sk_buff *skb;
> +	dma_addr_t dma;
> +	u8 *head = rx_ring->r.head;
> +	int buf_sz = RTK_PCI_RX_BUF_SIZE;
> +	int ring_sz = rx_ring->r.desc_size * rx_ring->r.len;
> +	int i;
> +
> +	for (i = 0; i < rx_ring->r.len; i++) {
> +		skb = rx_ring->buf[i];
> +		if (!skb)
> +			continue;
> +
> +		dma = *((dma_addr_t *)skb->cb);
> +		pci_unmap_single(pdev, dma, buf_sz, PCI_DMA_FROMDEVICE);
> +		dev_kfree_skb(skb);
> +		rx_ring->buf[i] = NULL;
> +	}
> +
> +	pci_free_consistent(pdev, ring_sz, head, rx_ring->r.dma);
> +}
> +
> +static void rtw_pci_free_trx_ring(struct rtw_dev *rtwdev)
> +{
> +	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> +	struct rtw_pci_tx_ring *tx_ring;
> +	struct rtw_pci_rx_ring *rx_ring;
> +	int i;
> +
> +	for (i = 0; i < RTK_MAX_TX_QUEUE_NUM; i++) {
> +		tx_ring = &rtwpci->tx_rings[i];
> +		rtw_pci_free_tx_ring(rtwdev, tx_ring);
> +	}
> +
> +	for (i = 0; i < RTK_MAX_RX_QUEUE_NUM; i++) {
> +		rx_ring = &rtwpci->rx_rings[i];
> +		rtw_pci_free_rx_ring(rtwdev, rx_ring);
> +	}
> +}
> +
> +static int rtw_pci_init_tx_ring(struct rtw_dev *rtwdev,
> +				struct rtw_pci_tx_ring *tx_ring,
> +				u8 desc_size, u32 len)
> +{
> +	struct pci_dev *pdev = to_pci_dev(rtwdev->dev);
> +	int ring_sz = desc_size * len;
> +	dma_addr_t dma;
> +	u8 *head;
> +
> +	head = pci_zalloc_consistent(pdev, ring_sz, &dma);
> +	if (!head) {
> +		rtw_err(rtwdev, "failed to allocate tx ring\n");
> +		return -ENOMEM;
> +	}
> +
> +	skb_queue_head_init(&tx_ring->queue);
> +	tx_ring->r.head = head;
> +	tx_ring->r.dma = dma;
> +	tx_ring->r.len = len;
> +	tx_ring->r.desc_size = desc_size;
> +	tx_ring->r.wp = 0;
> +	tx_ring->r.rp = 0;
> +
> +	return 0;
> +}
> +
> +static int rtw_pci_reset_rx_desc(struct rtw_dev *rtwdev, struct sk_buff *skb,
> +				 struct rtw_pci_rx_ring *rx_ring,
> +				 u32 idx, u32 desc_sz)
> +{
> +	struct pci_dev *pdev = to_pci_dev(rtwdev->dev);
> +	struct rtw_pci_rx_buffer_desc *buf_desc;
> +	int buf_sz = RTK_PCI_RX_BUF_SIZE;
> +	dma_addr_t dma;
> +
> +	if (!skb)
> +		return -EINVAL;
> +
> +	dma = pci_map_single(pdev, skb->data, buf_sz, PCI_DMA_FROMDEVICE);
> +	if (pci_dma_mapping_error(pdev, dma))
> +		return -EBUSY;
> +
> +	*((dma_addr_t *)skb->cb) = dma;
> +	buf_desc = (struct rtw_pci_rx_buffer_desc *)(rx_ring->r.head +
> +						     idx * desc_sz);
> +	memset(buf_desc, 0, sizeof(*buf_desc));
> +	buf_desc->buf_size = cpu_to_le16(RTK_PCI_RX_BUF_SIZE);
> +	buf_desc->dma = cpu_to_le32(dma);
> +
> +	return 0;
> +}
> +
> +static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,
> +				struct rtw_pci_rx_ring *rx_ring,
> +				u8 desc_size, u32 len)
> +{
> +	struct pci_dev *pdev = to_pci_dev(rtwdev->dev);
> +	struct sk_buff *skb = NULL;
> +	dma_addr_t dma;
> +	u8 *head;
> +	int ring_sz = desc_size * len;
> +	int buf_sz = RTK_PCI_RX_BUF_SIZE;
> +	int i, allocated;
> +	int ret = 0;
> +
> +	head = pci_zalloc_consistent(pdev, ring_sz, &dma);
> +	if (!head) {
> +		rtw_err(rtwdev, "failed to allocate rx ring\n");
> +		return -ENOMEM;
> +	}
> +	rx_ring->r.head = head;
> +
> +	for (i = 0; i < len; i++) {
> +		skb = dev_alloc_skb(buf_sz);
> +		if (!skb) {
> +			allocated = i;
> +			ret = -ENOMEM;
> +			goto err_out;
> +		}
> +
> +		memset(skb->data, 0, buf_sz);
> +		rx_ring->buf[i] = skb;
> +		ret = rtw_pci_reset_rx_desc(rtwdev, skb, rx_ring, i, desc_size);
> +		if (ret) {
> +			allocated = i;
> +			dev_kfree_skb_any(skb);
> +			goto err_out;
> +		}
> +	}
> +
> +	rx_ring->r.dma = dma;
> +	rx_ring->r.len = len;
> +	rx_ring->r.desc_size = desc_size;
> +	rx_ring->r.wp = 0;
> +	rx_ring->r.rp = 0;
> +
> +	return 0;
> +
> +err_out:
> +	for (i = 0; i < allocated; i++) {
> +		skb = rx_ring->buf[i];
> +		if (!skb)
> +			continue;
> +		dma = *((dma_addr_t *)skb->cb);
> +		pci_unmap_single(pdev, dma, buf_sz, PCI_DMA_FROMDEVICE);
> +		dev_kfree_skb_any(skb);
> +		rx_ring->buf[i] = NULL;
> +	}
> +	pci_free_consistent(pdev, ring_sz, head, dma);
> +
> +	rtw_err(rtwdev, "failed to init rx buffer\n");
> +
> +	return ret;
> +}
> +
> +static int rtw_pci_init_trx_ring(struct rtw_dev *rtwdev)
> +{
> +	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> +	struct rtw_pci_tx_ring *tx_ring;
> +	struct rtw_pci_rx_ring *rx_ring;
> +	struct rtw_chip_info *chip = rtwdev->chip;
> +	int i = 0, j = 0, tx_alloced = 0, rx_alloced = 0;
> +	int tx_desc_size, rx_desc_size;
> +	u32 len;
> +	int ret;
> +
> +	tx_desc_size = chip->tx_buf_desc_sz;
> +
> +	for (i = 0; i < RTK_MAX_TX_QUEUE_NUM; i++) {
> +		tx_ring = &rtwpci->tx_rings[i];
> +		len = max_num_of_tx_queue(i);
> +		ret = rtw_pci_init_tx_ring(rtwdev, tx_ring, tx_desc_size, len);
> +		if (ret)
> +			goto out;
> +	}
> +
> +	rx_desc_size = chip->rx_buf_desc_sz;
> +
> +	for (j = 0; j < RTK_MAX_RX_QUEUE_NUM; j++) {
> +		rx_ring = &rtwpci->rx_rings[j];
> +		ret = rtw_pci_init_rx_ring(rtwdev, rx_ring, rx_desc_size,
> +					   RTK_MAX_RX_DESC_NUM);
> +		if (ret)
> +			goto out;
> +	}
> +
> +	return 0;
> +
> +out:
> +	tx_alloced = i;
> +	for (i = 0; i < tx_alloced; i++) {
> +		tx_ring = &rtwpci->tx_rings[i];
> +		rtw_pci_free_tx_ring(rtwdev, tx_ring);
> +	}
> +
> +	rx_alloced = j;
> +	for (j = 0; j < rx_alloced; j++) {
> +		rx_ring = &rtwpci->rx_rings[j];
> +		rtw_pci_free_rx_ring(rtwdev, rx_ring);
> +	}
> +
> +	return ret;
> +}
> +
> +static void rtw_pci_deinit(struct rtw_dev *rtwdev)
> +{
> +	rtw_pci_free_trx_ring(rtwdev);
> +}
> +
> +static int rtw_pci_init(struct rtw_dev *rtwdev)
> +{
> +	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> +	int ret = 0;
> +
> +	rtwpci->irq_mask[0] = IMR_HIGHDOK |
> +			      IMR_MGNTDOK |
> +			      IMR_BKDOK |
> +			      IMR_BEDOK |
> +			      IMR_VIDOK |
> +			      IMR_VODOK |
> +			      IMR_ROK |
> +			      IMR_BCNDMAINT_E |
> +			      0;
> +	rtwpci->irq_mask[1] = IMR_TXFOVW |
> +			      0;
> +	rtwpci->irq_mask[3] = IMR_H2CDOK |
> +			      0;
> +	spin_lock_init(&rtwpci->irq_lock);
> +	ret = rtw_pci_init_trx_ring(rtwdev);
> +
> +	return ret;
> +}
> +
> +static void rtw_pci_reset_buf_desc(struct rtw_dev *rtwdev)
> +{
> +	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> +	u32 len;
> +	u8 tmp;
> +	dma_addr_t dma;
> +
> +	tmp = rtw_read8(rtwdev, RTK_PCI_CTRL + 3);
> +	rtw_write8(rtwdev, RTK_PCI_CTRL + 3, tmp | 0xf7);
> +
> +	dma = rtwpci->tx_rings[RTW_TX_QUEUE_BCN].r.dma;
> +	rtw_write32(rtwdev, RTK_PCI_TXBD_DESA_BCNQ, dma);
> +
> +	len = rtwpci->tx_rings[RTW_TX_QUEUE_H2C].r.len;
> +	dma = rtwpci->tx_rings[RTW_TX_QUEUE_H2C].r.dma;
> +	rtwpci->tx_rings[RTW_TX_QUEUE_H2C].r.rp = 0;
> +	rtwpci->tx_rings[RTW_TX_QUEUE_H2C].r.wp = 0;
> +	rtw_write16(rtwdev, RTK_PCI_TXBD_NUM_H2CQ, len);
> +	rtw_write32(rtwdev, RTK_PCI_TXBD_DESA_H2CQ, dma);
> +
> +	len = rtwpci->tx_rings[RTW_TX_QUEUE_BK].r.len;
> +	dma = rtwpci->tx_rings[RTW_TX_QUEUE_BK].r.dma;
> +	rtwpci->tx_rings[RTW_TX_QUEUE_BK].r.rp = 0;
> +	rtwpci->tx_rings[RTW_TX_QUEUE_BK].r.wp = 0;
> +	rtw_write16(rtwdev, RTK_PCI_TXBD_NUM_BKQ, len);
> +	rtw_write32(rtwdev, RTK_PCI_TXBD_DESA_BKQ, dma);
> +
> +	len = rtwpci->tx_rings[RTW_TX_QUEUE_BE].r.len;
> +	dma = rtwpci->tx_rings[RTW_TX_QUEUE_BE].r.dma;
> +	rtwpci->tx_rings[RTW_TX_QUEUE_BE].r.rp = 0;
> +	rtwpci->tx_rings[RTW_TX_QUEUE_BE].r.wp = 0;
> +	rtw_write16(rtwdev, RTK_PCI_TXBD_NUM_BEQ, len);
> +	rtw_write32(rtwdev, RTK_PCI_TXBD_DESA_BEQ, dma);
> +
> +	len = rtwpci->tx_rings[RTW_TX_QUEUE_VO].r.len;
> +	dma = rtwpci->tx_rings[RTW_TX_QUEUE_VO].r.dma;
> +	rtwpci->tx_rings[RTW_TX_QUEUE_VO].r.rp = 0;
> +	rtwpci->tx_rings[RTW_TX_QUEUE_VO].r.wp = 0;
> +	rtw_write16(rtwdev, RTK_PCI_TXBD_NUM_VOQ, len);
> +	rtw_write32(rtwdev, RTK_PCI_TXBD_DESA_VOQ, dma);
> +
> +	len = rtwpci->tx_rings[RTW_TX_QUEUE_VI].r.len;
> +	dma = rtwpci->tx_rings[RTW_TX_QUEUE_VI].r.dma;
> +	rtwpci->tx_rings[RTW_TX_QUEUE_VI].r.rp = 0;
> +	rtwpci->tx_rings[RTW_TX_QUEUE_VI].r.wp = 0;
> +	rtw_write16(rtwdev, RTK_PCI_TXBD_NUM_VIQ, len);
> +	rtw_write32(rtwdev, RTK_PCI_TXBD_DESA_VIQ, dma);
> +
> +	len = rtwpci->tx_rings[RTW_TX_QUEUE_MGMT].r.len;
> +	dma = rtwpci->tx_rings[RTW_TX_QUEUE_MGMT].r.dma;
> +	rtwpci->tx_rings[RTW_TX_QUEUE_MGMT].r.rp = 0;
> +	rtwpci->tx_rings[RTW_TX_QUEUE_MGMT].r.wp = 0;
> +	rtw_write16(rtwdev, RTK_PCI_TXBD_NUM_MGMTQ, len);
> +	rtw_write32(rtwdev, RTK_PCI_TXBD_DESA_MGMTQ, dma);
> +
> +	len = rtwpci->tx_rings[RTW_TX_QUEUE_HI0].r.len;
> +	dma = rtwpci->tx_rings[RTW_TX_QUEUE_HI0].r.dma;
> +	rtwpci->tx_rings[RTW_TX_QUEUE_HI0].r.rp = 0;
> +	rtwpci->tx_rings[RTW_TX_QUEUE_HI0].r.wp = 0;
> +	rtw_write16(rtwdev, RTK_PCI_TXBD_NUM_HI0Q, len);
> +	rtw_write32(rtwdev, RTK_PCI_TXBD_DESA_HI0Q, dma);
> +
> +	len = rtwpci->rx_rings[RTW_RX_QUEUE_MPDU].r.len;
> +	dma = rtwpci->rx_rings[RTW_RX_QUEUE_MPDU].r.dma;
> +	rtwpci->rx_rings[RTW_RX_QUEUE_MPDU].r.rp = 0;
> +	rtwpci->rx_rings[RTW_RX_QUEUE_MPDU].r.wp = 0;
> +	rtw_write16(rtwdev, RTK_PCI_RXBD_NUM_MPDUQ, len & 0xfff);
> +	rtw_write32(rtwdev, RTK_PCI_RXBD_DESA_MPDUQ, dma);
> +
> +	/* reset read/write point */
> +	rtw_write32(rtwdev, RTK_PCI_TXBD_RWPTR_CLR, 0xffffffff);
> +
> +	/* rest H2C Queue index */
> +	rtw_write32_set(rtwdev, RTK_PCI_TXBD_H2CQ_CSR, BIT_CLR_H2CQ_HOST_IDX);
> +	rtw_write32_set(rtwdev, RTK_PCI_TXBD_H2CQ_CSR, BIT_CLR_H2CQ_HW_IDX);
> +}
> +
> +static void rtw_pci_reset_trx_ring(struct rtw_dev *rtwdev)
> +{
> +	rtw_pci_reset_buf_desc(rtwdev);
> +}
> +
> +static void rtw_pci_enable_interrupt(struct rtw_dev *rtwdev,
> +				     struct rtw_pci *rtwpci)
> +{
> +	rtw_write32(rtwdev, RTK_PCI_HIMR0, rtwpci->irq_mask[0]);
> +	rtw_write32(rtwdev, RTK_PCI_HIMR1, rtwpci->irq_mask[1]);
> +	rtw_write32(rtwdev, RTK_PCI_HIMR3, rtwpci->irq_mask[3]);
> +	rtwpci->irq_enabled = true;
> +}
> +
> +static void rtw_pci_disable_interrupt(struct rtw_dev *rtwdev,
> +				      struct rtw_pci *rtwpci)
> +{
> +	rtw_write32(rtwdev, RTK_PCI_HIMR0, 0);
> +	rtw_write32(rtwdev, RTK_PCI_HIMR1, 0);
> +	rtw_write32(rtwdev, RTK_PCI_HIMR3, 0);
> +	rtwpci->irq_enabled = false;
> +}
> +
> +static int rtw_pci_setup(struct rtw_dev *rtwdev)
> +{
> +	rtw_pci_reset_trx_ring(rtwdev);
> +
> +	return 0;
> +}
> +
> +static void rtw_pci_dma_reset(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci)
> +{
> +	/* reset dma and rx tag */
> +	rtw_write32_set(rtwdev, RTK_PCI_CTRL,
> +			BIT_RST_TRXDMA_INTF | BIT_RX_TAG_EN);
> +	rtwpci->rx_tag = 0;
> +}
> +
> +static int rtw_pci_start(struct rtw_dev *rtwdev)
> +{
> +	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> +	unsigned long flags;
> +
> +	rtw_pci_dma_reset(rtwdev, rtwpci);
> +
> +	spin_lock_irqsave(&rtwpci->irq_lock, flags);
> +	rtw_pci_enable_interrupt(rtwdev, rtwpci);
> +	spin_unlock_irqrestore(&rtwpci->irq_lock, flags);
> +
> +	return 0;
> +}
> +
> +static void rtw_pci_stop(struct rtw_dev *rtwdev)
> +{
> +	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&rtwpci->irq_lock, flags);
> +	rtw_pci_disable_interrupt(rtwdev, rtwpci);
> +	spin_unlock_irqrestore(&rtwpci->irq_lock, flags);
> +}
> +
> +static u8 ac_to_hwq[] = {
> +	[0] = RTW_TX_QUEUE_VO,
> +	[1] = RTW_TX_QUEUE_VI,
> +	[2] = RTW_TX_QUEUE_BE,
> +	[3] = RTW_TX_QUEUE_BK,
> +};
> +
> +static u8 rtw_hw_queue_mapping(struct sk_buff *skb)
> +{
> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> +	__le16 fc = hdr->frame_control;
> +	u8 q_mapping = skb_get_queue_mapping(skb);
> +	u8 queue;
> +
> +	if (unlikely(ieee80211_is_beacon(fc)))
> +		queue = RTW_TX_QUEUE_BCN;
> +	else if (unlikely(ieee80211_is_mgmt(fc) || ieee80211_is_ctl(fc)))
> +		queue = RTW_TX_QUEUE_MGMT;
> +	else
> +		queue = ac_to_hwq[q_mapping];
> +
> +	return queue;
> +}
> +
> +static void rtw_pci_release_rsvd_page(struct rtw_pci *rtwpci,
> +				      struct rtw_pci_tx_ring *ring)
> +{
> +	struct sk_buff *prev = skb_dequeue(&ring->queue);
> +	struct rtw_pci_tx_data *tx_data;
> +	dma_addr_t dma;
> +
> +	if (!prev)
> +		return;
> +
> +	tx_data = rtw_pci_get_tx_data(prev);
> +	dma = tx_data->dma;
> +	pci_unmap_single(rtwpci->pdev, dma, prev->len,
> +			 PCI_DMA_TODEVICE);
> +	dev_kfree_skb_any(prev);
> +}
> +
> +static void rtw_pci_dma_check(struct rtw_dev *rtwdev,
> +			      struct rtw_pci_rx_ring *rx_ring,
> +			      u32 idx)
> +{
> +	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> +	struct rtw_chip_info *chip = rtwdev->chip;
> +	struct rtw_pci_rx_buffer_desc *buf_desc;
> +	u32 desc_sz = chip->rx_buf_desc_sz;
> +	u16 total_pkt_size;
> +
> +	buf_desc = (struct rtw_pci_rx_buffer_desc *)(rx_ring->r.head +
> +						     idx * desc_sz);
> +	total_pkt_size = le16_to_cpu(buf_desc->total_pkt_size);
> +
> +	/* rx tag mismatch, throw a warning */
> +	if (total_pkt_size != rtwpci->rx_tag)
> +		rtw_warn(rtwdev, "pci bus timeout, check dma status\n");
> +
> +	rtwpci->rx_tag = (rtwpci->rx_tag + 1) % RX_TAG_MAX;
> +}
> +
> +static int rtw_pci_xmit(struct rtw_dev *rtwdev,
> +			struct rtw_tx_pkt_info *pkt_info,
> +			struct sk_buff *skb, u8 queue)
> +{
> +	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> +	struct rtw_chip_info *chip = rtwdev->chip;
> +	struct rtw_pci_tx_ring *ring;
> +	struct rtw_pci_tx_data *tx_data;
> +	dma_addr_t dma;
> +	u32 tx_pkt_desc_sz = chip->tx_pkt_desc_sz;
> +	u32 tx_buf_desc_sz = chip->tx_buf_desc_sz;
> +	u32 size;
> +	u32 psb_len;
> +	u8 *pkt_desc;
> +	struct rtw_pci_tx_buffer_desc *buf_desc;
> +	u32 bd_idx;
> +
> +	ring = &rtwpci->tx_rings[queue];
> +
> +	size = skb->len;
> +
> +	if (queue == RTW_TX_QUEUE_BCN)
> +		rtw_pci_release_rsvd_page(rtwpci, ring);
> +	else if (!avail_desc(ring->r.wp, ring->r.rp, ring->r.len))
> +		return -ENOSPC;
> +
> +	pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
> +	memset(pkt_desc, 0, tx_pkt_desc_sz);
> +	pkt_info->qsel = rtw_pci_get_tx_qsel(skb, queue);
> +	rtw_tx_fill_tx_desc(pkt_info, skb);
> +	dma = pci_map_single(rtwpci->pdev, skb->data, skb->len,
> +			     PCI_DMA_TODEVICE);
> +	if (pci_dma_mapping_error(rtwpci->pdev, dma))
> +		return -EBUSY;
> +
> +	/* after this we got dma mapped, there is no way back */
> +	buf_desc = get_tx_buffer_desc(ring, tx_buf_desc_sz);
> +	memset(buf_desc, 0, tx_buf_desc_sz);
> +	psb_len = (skb->len - 1) / 128 + 1;
> +	if (queue == RTW_TX_QUEUE_BCN)
> +		psb_len |= 1 << RTK_PCI_TXBD_OWN_OFFSET;
> +
> +	buf_desc[0].psb_len = cpu_to_le16(psb_len);
> +	buf_desc[0].buf_size = cpu_to_le16(tx_pkt_desc_sz);
> +	buf_desc[0].dma = cpu_to_le32(dma);
> +	buf_desc[1].buf_size = cpu_to_le16(size);
> +	buf_desc[1].dma = cpu_to_le32(dma + tx_pkt_desc_sz);
> +
> +	tx_data = rtw_pci_get_tx_data(skb);
> +	tx_data->dma = dma;
> +	tx_data->sn = pkt_info->sn;
> +	skb_queue_tail(&ring->queue, skb);
> +
> +	/* kick off tx queue */
> +	if (queue != RTW_TX_QUEUE_BCN) {
> +		if (++ring->r.wp >= ring->r.len)
> +			ring->r.wp = 0;
> +		bd_idx = rtw_pci_tx_queue_idx_addr[queue];
> +		rtw_write16(rtwdev, bd_idx, ring->r.wp & 0xfff);
> +	} else {
> +		u32 reg_bcn_work;
> +
> +		reg_bcn_work = rtw_read8(rtwdev, RTK_PCI_TXBD_BCN_WORK);
> +		reg_bcn_work |= BIT_PCI_BCNQ_FLAG;
> +		rtw_write8(rtwdev, RTK_PCI_TXBD_BCN_WORK, reg_bcn_work);
> +	}
> +
> +	return 0;
> +}
> +
> +static int rtw_pci_write_data_rsvd_page(struct rtw_dev *rtwdev, u8 *buf,
> +					u32 size)
> +{
> +	struct sk_buff *skb;
> +	struct rtw_tx_pkt_info pkt_info;
> +	u32 tx_pkt_desc_sz;
> +	u32 length;
> +
> +	tx_pkt_desc_sz = rtwdev->chip->tx_pkt_desc_sz;
> +	length = size + tx_pkt_desc_sz;
> +	skb = dev_alloc_skb(length);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	skb_reserve(skb, tx_pkt_desc_sz);
> +	memcpy((u8 *)skb_put(skb, size), buf, size);
> +	memset(&pkt_info, 0, sizeof(pkt_info));
> +	pkt_info.tx_pkt_size = size;
> +	pkt_info.offset = tx_pkt_desc_sz;
> +
> +	return rtw_pci_xmit(rtwdev, &pkt_info, skb, RTW_TX_QUEUE_BCN);
> +}
> +
> +static int rtw_pci_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
> +{
> +	struct sk_buff *skb;
> +	struct rtw_tx_pkt_info pkt_info;
> +	u32 tx_pkt_desc_sz;
> +	u32 length;
> +
> +	tx_pkt_desc_sz = rtwdev->chip->tx_pkt_desc_sz;
> +	length = size + tx_pkt_desc_sz;
> +	skb = dev_alloc_skb(length);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	skb_reserve(skb, tx_pkt_desc_sz);
> +	memcpy((u8 *)skb_put(skb, size), buf, size);
> +	memset(&pkt_info, 0, sizeof(pkt_info));
> +	pkt_info.tx_pkt_size = size;
> +
> +	return rtw_pci_xmit(rtwdev, &pkt_info, skb, RTW_TX_QUEUE_H2C);
> +}
> +
> +static int rtw_pci_tx(struct rtw_dev *rtwdev,
> +		      struct rtw_tx_pkt_info *pkt_info,
> +		      struct sk_buff *skb)
> +{
> +	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> +	struct rtw_pci_tx_ring *ring;
> +	u8 queue = rtw_hw_queue_mapping(skb);
> +	int ret;
> +
> +	ret = rtw_pci_xmit(rtwdev, pkt_info, skb, queue);
> +	if (ret)
> +		return ret;
> +
> +	ring = &rtwpci->tx_rings[queue];
> +	if (avail_desc(ring->r.wp, ring->r.rp, ring->r.len) < 2) {
> +		ieee80211_stop_queue(rtwdev->hw, skb_get_queue_mapping(skb));
> +		ring->queue_stopped = true;
> +	}
<snip>
> +static void rtw_pci_tx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
> +			   u8 hw_queue)
> +{
<snip>
> +		if (ring->queue_stopped &&
> +		    avail_desc(ring->r.wp, ring->r.rp, ring->r.len) > 4) {
> +			q_map = skb_get_queue_mapping(skb);
> +			ieee80211_wake_queue(hw, q_map);
> +			ring->queue_stopped = false;

There is small race window between this and corresponding queue stop
code in rtw_pci_tx(). If interrupt came between:

	if (avail_desc(ring->r.wp, ring->r.rp, ring->r.len) < 2) {

and 

		ieee80211_stop_queue(rtwdev->hw, skb_get_queue_mapping(skb));
		ring->queue_stopped = true;

and we will process all frames (this can happen if except rtw88 interrupt,
interrupts of other devices will be processed and slow down return to
interrupted code), we will end up with stopped queue and no more interrupts
to wake queue. So I think we should take rtwpci->irq_locck around avail_desc
check in rtw_pci_tx(). 

Additionally thresholds of 2 and 4 looks a bit small.

Stanislaw
