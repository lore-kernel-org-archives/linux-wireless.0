Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CAC7C169C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 02:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DAA820869
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 02:18:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="oCz/kqh9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfBICOj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 21:14:39 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36513 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfBICOj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 21:14:39 -0500
Received: by mail-pg1-f195.google.com with SMTP id n2so2374046pgm.3
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2019 18:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5tOmQ+tHey24E4Y4iHV1MdLxwpm+TXTe0k3baV6SZLU=;
        b=oCz/kqh9dqKQ0onoeEh46awq+m9g/vPHZiJXT2qW77DEJfAQnZ74vAlFkfJbGEyxBs
         tS7soAj+RmEj3/Dlxy202qWlIe7na63cKKM96pEQIvDuj5v/5auNzxg/J+z4fXIGj7IS
         pYViqrOl3tpZW0JQ/NJhj83TKA47Tn1cmBUcc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5tOmQ+tHey24E4Y4iHV1MdLxwpm+TXTe0k3baV6SZLU=;
        b=UhUKmsITkX9u9FQIgb5BkI1wwWl51Vn8KjLLXIPyqWX17ce5ZYzvdN140bZsYh85bb
         FlcDwO3a2ZCvKgD2Bk/P9qlHPURQIy1m4M2VL+BL80N3PbJllhdz5tuEN/uav6kQRgEF
         HXCaRVdFlQKmQmxmwalifQvAxpl4AwihOEj7ZAxfieXWIGVUiTftbzJKCyLnUcXW1t5C
         lqcBFLiVabxirTTBp8VUKAUQBsx44XrxWqoBGGarYfmhhDLfHaXntVQ05hznY0TrVBWd
         r1vT8W9tor7+ieBCP4DgrZyL9HdYV2MNOa1+s1I7KaiCj+POQhlIQrqc+qy/c1fN7RuI
         jvWA==
X-Gm-Message-State: AHQUAubpT1mAynlG+pbkW3B2hd2hJOGtGvLYuRPob+kftG7dG3TY3uGh
        i5fwcycJOoUy25STjeDiVW+P18TRkbg=
X-Google-Smtp-Source: AHgI3IYxcuhOjwnz5E3JECVfP7zdlbJNIKZP/zalTUHupAQj8OL9ShVfnqlFhKxeMeJ+qKYEl6Bzgg==
X-Received: by 2002:a65:64d6:: with SMTP id t22mr23644460pgv.52.1549678477945;
        Fri, 08 Feb 2019 18:14:37 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id t5sm5834893pgo.70.2019.02.08.18.14.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Feb 2019 18:14:36 -0800 (PST)
Date:   Fri, 8 Feb 2019 18:14:34 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, johannes@sipsolutions.net,
        Larry.Finger@lwfinger.net, pkshih@realtek.com, tehuang@realtek.com,
        sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 03/13] rtw88: hci files
Message-ID: <20190209021426.GA163159@google.com>
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
 <1548820940-15237-4-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548820940-15237-4-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

FYI, I have some more review comments because I'm trying to see why your
TX path doesn't work all that well. At least, it's not reporting things
correctly. (I know there's one ACK reporting bug you fixed in a
follow-up patch, but then, that patch is buggy too I think.)

On Wed, Jan 30, 2019 at 12:02:10PM +0800, yhchuang@realtek.com wrote:
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
>  drivers/net/wireless/realtek/rtw88/pci.c | 1210 ++++++++++++++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/pci.h |  229 ++++++
>  3 files changed, 1650 insertions(+)
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

...

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
> +	skb_queue_tail(&ring->queue, skb);

IIUC, you have no locking for this queue. That seems like a bad idea. It
then gets pulled off this queue in your ISR, again without a lock. So
for example, if the only packet in your queue gets completed while you
are trying to queue another one, you might corrupt the list.

Brian

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
...
