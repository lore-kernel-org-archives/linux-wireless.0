Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26604C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 06:15:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E919C2084D
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 06:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbfBKGPZ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 01:15:25 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:57486 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbfBKGPZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 01:15:25 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1B6F3uV023373, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1B6F3uV023373
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 11 Feb 2019 14:15:03 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0399.000; Mon, 11 Feb 2019 14:15:03 +0800
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
Thread-Index: AQHUuFCwL7VQDfSYhE2MAb8drhRitKXWBJ0AgAQpsQA=
Date:   Mon, 11 Feb 2019 06:15:02 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17A2B24@RTITMBSVM04.realtek.com.tw>
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
 <1548820940-15237-4-git-send-email-yhchuang@realtek.com>
 <20190208222855.GA31454@google.com>
In-Reply-To: <20190208222855.GA31454@google.com>
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



> -----Original Message-----
> From: Brian Norris [mailto:briannorris@chromium.org]
> 
> Hi,
> 
> One more comment for now, below:
> 
> On Wed, Jan 30, 2019 at 12:02:10PM +0800, yhchuang@realtek.com wrote:
> > From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> >
> > hci files for Realtek 802.11ac wireless network chips
> >
> > For now there is only PCI bus supported by rtwlan, in the future it
> > will also have USB/SDIO
> >
> > Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> > ---
> >  drivers/net/wireless/realtek/rtw88/hci.h |  211 ++++++
> >  drivers/net/wireless/realtek/rtw88/pci.c | 1210
> ++++++++++++++++++++++++++++++
> >  drivers/net/wireless/realtek/rtw88/pci.h |  229 ++++++
> >  3 files changed, 1650 insertions(+)
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/hci.h
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/pci.c
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/pci.h
> 
> ...
> 
> > diff --git a/drivers/net/wireless/realtek/rtw88/pci.c
> b/drivers/net/wireless/realtek/rtw88/pci.c
> > new file mode 100644
> > index 0000000..ef3c9bb
> > --- /dev/null
> > +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> > @@ -0,0 +1,1210 @@
> 
> > +static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
> > +			   u8 hw_queue)
> > +{
> > +	struct rtw_chip_info *chip = rtwdev->chip;
> > +	struct rtw_pci_rx_ring *ring;
> > +	struct rtw_rx_pkt_stat pkt_stat;
> > +	struct ieee80211_rx_status rx_status;
> > +	struct sk_buff *skb, *new;
> > +	u32 cur_wp, cur_rp, tmp;
> > +	u32 count;
> > +	u32 pkt_offset;
> > +	u32 pkt_desc_sz = chip->rx_pkt_desc_sz;
> > +	u32 buf_desc_sz = chip->rx_buf_desc_sz;
> > +	u8 *rx_desc;
> > +	dma_addr_t dma;
> > +
> > +	ring = &rtwpci->rx_rings[RTW_RX_QUEUE_MPDU];
> > +
> > +	tmp = rtw_read32(rtwdev, RTK_PCI_RXBD_IDX_MPDUQ);
> > +	cur_wp = tmp >> 16;
> > +	cur_wp &= 0xfff;
> > +	if (cur_wp >= ring->r.wp)
> > +		count = cur_wp - ring->r.wp;
> > +	else
> > +		count = ring->r.len - (ring->r.wp - cur_wp);
> > +
> > +	cur_rp = ring->r.rp;
> > +	while (count--) {
> > +		rtw_pci_dma_check(rtwdev, ring, cur_rp);
> > +		skb = ring->buf[cur_rp];
> > +		dma = *((dma_addr_t *)skb->cb);
> > +		pci_unmap_single(rtwpci->pdev, dma, RTK_PCI_RX_BUF_SIZE,
> > +				 PCI_DMA_FROMDEVICE);
> > +		rx_desc = skb->data;
> > +		chip->ops->query_rx_desc(rtwdev, rx_desc, &pkt_stat, &rx_status);
> > +
> > +		/* offset from rx_desc to payload */
> > +		pkt_offset = pkt_desc_sz + pkt_stat.drv_info_sz +
> > +			     pkt_stat.shift;
> > +
> > +		if (pkt_stat.is_c2h) {
> > +			/* keep rx_desc, halmac needs it */
> > +			skb_put(skb, pkt_stat.pkt_len + pkt_offset);
> > +
> > +			/* pass offset for further operation */
> > +			*((u32 *)skb->cb) = pkt_offset;
> > +			skb_queue_tail(&rtwdev->c2h_queue, skb);
> > +			ieee80211_queue_work(rtwdev->hw, &rtwdev->c2h_work);
> > +		} else {
> > +			/* remove rx_desc, maybe use skb_pull? */
> > +			skb_put(skb, pkt_stat.pkt_len);
> > +			skb_reserve(skb, pkt_offset);
> > +
> > +			/* alloc a smaller skb to mac80211 */
> > +			new = dev_alloc_skb(pkt_stat.pkt_len);
> > +			if (!new) {
> > +				new = skb;
> > +			} else {
> > +				skb_put_data(new, skb->data, skb->len);
> > +				dev_kfree_skb_any(skb);
> > +			}
> > +			/* TODO: merge into rx.c */
> > +			rtw_rx_stats(rtwdev, pkt_stat.vif, skb);
> > +			memcpy(new->cb, &rx_status, sizeof(rx_status));
> > +			ieee80211_rx_irqsafe(rtwdev->hw, new);
> > +		}
> > +
> > +		/* skb delivered to mac80211, alloc a new one in rx ring */
> > +		new = dev_alloc_skb(RTK_PCI_RX_BUF_SIZE);
> > +		if (WARN(!new, "rx routine starvation\n"))
> > +			return;
> > +
> > +		ring->buf[cur_rp] = new;
> > +		rtw_pci_reset_rx_desc(rtwdev, new, ring, cur_rp, buf_desc_sz);
> 
> You aren't handling failures from this function. It's not quite clear to
> me whether that will just leak the SKB, or if it will end in an
> unbalanced unmap later.

Unfortunately I think it will end up in an unbalanced unmap. But I have no idea
now about how to deal with the dma_map failure. Since the rx dma runs ring-based,
if the dma_map failed, seems the only way is to retry to dma_map again until it has
a mapped dma address. Otherwise the dma engine will dma contents of a packet to
an unknown dma address (previous skb in this case, also will corrupt the memory)
after it ran over a cycle and hit this desc.

Hence I think here we should put an err or WARN here to explicitly know there has
something went wrong. But I do not know how to deal with the dma failure :(
Need to re-construct them in my brain and consider the rx path.

Yan-Hsuan

