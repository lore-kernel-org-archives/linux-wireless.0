Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C516C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 22:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09D2A2075C
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 22:29:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="cJGRNmSY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfBHW3B (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 17:29:01 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46136 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbfBHW3A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 17:29:00 -0500
Received: by mail-pg1-f194.google.com with SMTP id w7so2164284pgp.13
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2019 14:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1cV0RsGNoq78xL7fnM5I0bdwGKP7qbDI2Xn+tY/8fWg=;
        b=cJGRNmSYIezeazLNNSaRlW+eETB8wc+znJoVO2haukeAKei8hlYKA4HcmtDD3ukR6J
         rBuYHaIhuO9Fk/yYKFjDKnkFbCzWYJCym0he4wWcsf/6fUqMasj0Xz2wITRIbLVLA16A
         PF20Z5DBA66md8hGb9Ydu7KRqIS51lDMxcpOg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1cV0RsGNoq78xL7fnM5I0bdwGKP7qbDI2Xn+tY/8fWg=;
        b=ilycmIplkuS9++RwylDkFsvEmzfdC/HP2VNoHjMw/hp59K/KCL65dJ4aWO1R0STW8k
         CZ6Zc04vIfQgy6PW168UBwcJpWoNgKSzUcloNfQ9dh0d8csyTgH8+cTLZ2ZF1lhC+5T7
         TTz3Fr5nJdViocQv6IzStJSQA5Eosh7bZnoFAJFPmrHjyyLACG4ONzKTChyyRAXOQCO7
         gN6y9EcUEmBZBd8RbCBJerVJgKiJCaagWTya+k57WW2sjiSaWeiST/bzCmeXC8q015kG
         78b7ZsbeY7xwz1YOHV14PEZx/ytoMT8jZqhs0ODE/A2Y698QmH/X5ULlmR9pp4WsJJsp
         FOng==
X-Gm-Message-State: AHQUAuZxf5dvhWlgWXBJYFyi/K/w69XzQgGSvi8YjBNFFwFLQrvOoFYc
        Pd8WkU399W6ZRGZCJo0EAnig6g==
X-Google-Smtp-Source: AHgI3IY1KnJorK2MtJLFbUv5c2GgKenbthKbZHQg/fSjvu6Pu4DYUsGN7feJkKQt7nnoRp5KSx9+1g==
X-Received: by 2002:a62:8a57:: with SMTP id y84mr24416857pfd.197.1549664939763;
        Fri, 08 Feb 2019 14:28:59 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id i5sm4937060pfg.34.2019.02.08.14.28.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Feb 2019 14:28:58 -0800 (PST)
Date:   Fri, 8 Feb 2019 14:28:56 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, johannes@sipsolutions.net,
        Larry.Finger@lwfinger.net, pkshih@realtek.com, tehuang@realtek.com,
        sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 03/13] rtw88: hci files
Message-ID: <20190208222855.GA31454@google.com>
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

Hi,

One more comment for now, below:

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

...

> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
> new file mode 100644
> index 0000000..ef3c9bb
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -0,0 +1,1210 @@

> +static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
> +			   u8 hw_queue)
> +{
> +	struct rtw_chip_info *chip = rtwdev->chip;
> +	struct rtw_pci_rx_ring *ring;
> +	struct rtw_rx_pkt_stat pkt_stat;
> +	struct ieee80211_rx_status rx_status;
> +	struct sk_buff *skb, *new;
> +	u32 cur_wp, cur_rp, tmp;
> +	u32 count;
> +	u32 pkt_offset;
> +	u32 pkt_desc_sz = chip->rx_pkt_desc_sz;
> +	u32 buf_desc_sz = chip->rx_buf_desc_sz;
> +	u8 *rx_desc;
> +	dma_addr_t dma;
> +
> +	ring = &rtwpci->rx_rings[RTW_RX_QUEUE_MPDU];
> +
> +	tmp = rtw_read32(rtwdev, RTK_PCI_RXBD_IDX_MPDUQ);
> +	cur_wp = tmp >> 16;
> +	cur_wp &= 0xfff;
> +	if (cur_wp >= ring->r.wp)
> +		count = cur_wp - ring->r.wp;
> +	else
> +		count = ring->r.len - (ring->r.wp - cur_wp);
> +
> +	cur_rp = ring->r.rp;
> +	while (count--) {
> +		rtw_pci_dma_check(rtwdev, ring, cur_rp);
> +		skb = ring->buf[cur_rp];
> +		dma = *((dma_addr_t *)skb->cb);
> +		pci_unmap_single(rtwpci->pdev, dma, RTK_PCI_RX_BUF_SIZE,
> +				 PCI_DMA_FROMDEVICE);
> +		rx_desc = skb->data;
> +		chip->ops->query_rx_desc(rtwdev, rx_desc, &pkt_stat, &rx_status);
> +
> +		/* offset from rx_desc to payload */
> +		pkt_offset = pkt_desc_sz + pkt_stat.drv_info_sz +
> +			     pkt_stat.shift;
> +
> +		if (pkt_stat.is_c2h) {
> +			/* keep rx_desc, halmac needs it */
> +			skb_put(skb, pkt_stat.pkt_len + pkt_offset);
> +
> +			/* pass offset for further operation */
> +			*((u32 *)skb->cb) = pkt_offset;
> +			skb_queue_tail(&rtwdev->c2h_queue, skb);
> +			ieee80211_queue_work(rtwdev->hw, &rtwdev->c2h_work);
> +		} else {
> +			/* remove rx_desc, maybe use skb_pull? */
> +			skb_put(skb, pkt_stat.pkt_len);
> +			skb_reserve(skb, pkt_offset);
> +
> +			/* alloc a smaller skb to mac80211 */
> +			new = dev_alloc_skb(pkt_stat.pkt_len);
> +			if (!new) {
> +				new = skb;
> +			} else {
> +				skb_put_data(new, skb->data, skb->len);
> +				dev_kfree_skb_any(skb);
> +			}
> +			/* TODO: merge into rx.c */
> +			rtw_rx_stats(rtwdev, pkt_stat.vif, skb);
> +			memcpy(new->cb, &rx_status, sizeof(rx_status));
> +			ieee80211_rx_irqsafe(rtwdev->hw, new);
> +		}
> +
> +		/* skb delivered to mac80211, alloc a new one in rx ring */
> +		new = dev_alloc_skb(RTK_PCI_RX_BUF_SIZE);
> +		if (WARN(!new, "rx routine starvation\n"))
> +			return;
> +
> +		ring->buf[cur_rp] = new;
> +		rtw_pci_reset_rx_desc(rtwdev, new, ring, cur_rp, buf_desc_sz);

You aren't handling failures from this function. It's not quite clear to
me whether that will just leak the SKB, or if it will end in an
unbalanced unmap later.

Brian

> +
> +		/* host read next element in ring */
> +		if (++cur_rp >= ring->r.len)
> +			cur_rp = 0;
> +	}
> +
> +	ring->r.rp = cur_rp;
> +	ring->r.wp = cur_wp;
> +	rtw_write16(rtwdev, RTK_PCI_RXBD_IDX_MPDUQ, ring->r.rp);
> +}
 
