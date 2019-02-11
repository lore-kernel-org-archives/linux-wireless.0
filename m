Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A45ADC169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 05:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 737FB20873
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 05:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfBKFsW convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 00:48:22 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:55491 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbfBKFsW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 00:48:22 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1B5m1qB014468, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1B5m1qB014468
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 11 Feb 2019 13:48:01 +0800
Received: from RTITEXH01.realtek.com.tw (172.21.6.62) by
 RTITCASV02.realtek.com.tw (172.21.6.19) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 11 Feb 2019 13:48:01 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITEXH01.realtek.com.tw ([::1]) with mapi id 14.03.0435.000; Mon, 11 Feb
 2019 13:48:00 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Brian Norris <briannorris@chromium.org>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v4 03/13] rtw88: hci files
Thread-Topic: [PATCH v4 03/13] rtw88: hci files
Thread-Index: AQHUuFCwL7VQDfSYhE2MAb8drhRitKXWQ6gAgAPlQqA=
Date:   Mon, 11 Feb 2019 05:48:00 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17A2AC2@RTITMBSVM04.realtek.com.tw>
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
 <1548820940-15237-4-git-send-email-yhchuang@realtek.com>
 <20190209021426.GA163159@google.com>
In-Reply-To: <20190209021426.GA163159@google.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.124]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> From: Brian Norris [mailto:briannorris@chromium.org]
> 
> FYI, I have some more review comments because I'm trying to see why your
> TX path doesn't work all that well. At least, it's not reporting things
> correctly. (I know there's one ACK reporting bug you fixed in a
> follow-up patch, but then, that patch is buggy too I think.)
> 
> > +static int rtw_pci_xmit(struct rtw_dev *rtwdev,
> > +			struct rtw_tx_pkt_info *pkt_info,
> > +			struct sk_buff *skb, u8 queue)
> > +{
> > +	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> > +	struct rtw_chip_info *chip = rtwdev->chip;
> > +	struct rtw_pci_tx_ring *ring;
> > +	struct rtw_pci_tx_data *tx_data;
> > +	dma_addr_t dma;
> > +	u32 tx_pkt_desc_sz = chip->tx_pkt_desc_sz;
> > +	u32 tx_buf_desc_sz = chip->tx_buf_desc_sz;
> > +	u32 size;
> > +	u32 psb_len;
> > +	u8 *pkt_desc;
> > +	struct rtw_pci_tx_buffer_desc *buf_desc;
> > +	u32 bd_idx;
> > +
> > +	ring = &rtwpci->tx_rings[queue];
> > +
> > +	size = skb->len;
> > +
> > +	if (queue == RTW_TX_QUEUE_BCN)
> > +		rtw_pci_release_rsvd_page(rtwpci, ring);
> > +	else if (!avail_desc(ring->r.wp, ring->r.rp, ring->r.len))
> > +		return -ENOSPC;
> > +
> > +	pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
> > +	memset(pkt_desc, 0, tx_pkt_desc_sz);
> > +	pkt_info->qsel = rtw_pci_get_tx_qsel(skb, queue);
> > +	rtw_tx_fill_tx_desc(pkt_info, skb);
> > +	dma = pci_map_single(rtwpci->pdev, skb->data, skb->len,
> > +			     PCI_DMA_TODEVICE);
> > +	if (pci_dma_mapping_error(rtwpci->pdev, dma))
> > +		return -EBUSY;
> > +
> > +	/* after this we got dma mapped, there is no way back */
> > +	buf_desc = get_tx_buffer_desc(ring, tx_buf_desc_sz);
> > +	memset(buf_desc, 0, tx_buf_desc_sz);
> > +	psb_len = (skb->len - 1) / 128 + 1;
> > +	if (queue == RTW_TX_QUEUE_BCN)
> > +		psb_len |= 1 << RTK_PCI_TXBD_OWN_OFFSET;
> > +
> > +	buf_desc[0].psb_len = cpu_to_le16(psb_len);
> > +	buf_desc[0].buf_size = cpu_to_le16(tx_pkt_desc_sz);
> > +	buf_desc[0].dma = cpu_to_le32(dma);
> > +	buf_desc[1].buf_size = cpu_to_le16(size);
> > +	buf_desc[1].dma = cpu_to_le32(dma + tx_pkt_desc_sz);
> > +
> > +	tx_data = rtw_pci_get_tx_data(skb);
> > +	tx_data->dma = dma;
> > +	skb_queue_tail(&ring->queue, skb);
> 
> IIUC, you have no locking for this queue. That seems like a bad idea. It
> then gets pulled off this queue in your ISR, again without a lock. So
> for example, if the only packet in your queue gets completed while you
> are trying to queue another one, you might corrupt the list.
> 

I think skb_queue_tail already has its own spinlock to protect the queue?
Cannot see why the list might be corrupted. Or I misunderstand you.

Yan-Hsuan
