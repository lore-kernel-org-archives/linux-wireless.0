Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49640C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 06:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0478F20863
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 06:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbfBLGT1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 01:19:27 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:45860 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfBLGT1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 01:19:27 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1C6IveY028226, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1C6IveY028226
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 12 Feb 2019 14:18:57 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Tue, 12 Feb
 2019 14:18:57 +0800
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
Thread-Index: AQHUuFCwL7VQDfSYhE2MAb8drhRitKXJdAKAgBDPKrA=
Date:   Tue, 12 Feb 2019 06:18:56 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17A3A5E@RTITMBSVM04.realtek.com.tw>
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
 <1548820940-15237-4-git-send-email-yhchuang@realtek.com>
 <20190131223609.GA191502@google.com>
In-Reply-To: <20190131223609.GA191502@google.com>
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
> Hi,
> 
> A few scattered comments:
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
> >
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
> ...
> 
> > +static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,
> > +				struct rtw_pci_rx_ring *rx_ring,
> > +				u8 desc_size, u32 len)
> > +{
> > +	struct pci_dev *pdev = to_pci_dev(rtwdev->dev);
> > +	struct sk_buff *skb = NULL;
> > +	dma_addr_t dma;
> > +	u8 *head;
> > +	int ring_sz = desc_size * len;
> > +	int buf_sz = RTK_PCI_RX_BUF_SIZE;
> > +	int i, allocated;
> > +	int ret = 0;
> > +
> > +	head = pci_zalloc_consistent(pdev, ring_sz, &dma);
> > +	if (!head) {
> > +		rtw_err(rtwdev, "failed to allocate rx ring\n");
> > +		return -ENOMEM;
> > +	}
> > +	rx_ring->r.head = head;
> > +
> > +	for (i = 0; i < len; i++) {
> > +		skb = dev_alloc_skb(buf_sz);
> > +		if (!skb) {
> > +			allocated = i;
> > +			ret = -ENOMEM;
> > +			goto err_out;
> > +		}
> > +
> > +		memset(skb->data, 0, buf_sz);
> > +		rx_ring->buf[i] = skb;
> > +		ret = rtw_pci_reset_rx_desc(rtwdev, skb, rx_ring, i, desc_size);
> > +		if (ret) {
> > +			allocated = i;
> > +			goto err_out;
> > +		}
> > +	}
> > +
> > +	rx_ring->r.dma = dma;
> > +	rx_ring->r.len = len;
> > +	rx_ring->r.desc_size = desc_size;
> > +	rx_ring->r.wp = 0;
> > +	rx_ring->r.rp = 0;
> > +
> > +	return 0;
> > +
> > +err_out:
> > +	dev_kfree_skb_any(skb);
> 
> Maybe I'm misreading but...shouldn't this line not be here? You properly
> iterate over the allocated SKBs below, and this looks like you're just
> going to be double-freeing (or, negative ref-counting).

Yeah, I think I should move this line above after reset_rx_desc failed.

> 
> > +	for (i = 0; i < allocated; i++) {
> > +		skb = rx_ring->buf[i];
> > +		if (!skb)
> > +			continue;
> > +		dma = *((dma_addr_t *)skb->cb);
> > +		pci_unmap_single(pdev, dma, buf_sz, PCI_DMA_FROMDEVICE);
> > +		dev_kfree_skb_any(skb);
> > +		rx_ring->buf[i] = NULL;
> > +	}
> > +	pci_free_consistent(pdev, ring_sz, head, dma);
> > +
> > +	rtw_err(rtwdev, "failed to init rx buffer\n");
> > +
> > +	return ret;
> > +}
> > +
> 
> ...
> 
> > +static void rtw_pci_dma_check(struct rtw_dev *rtwdev,
> > +			      struct rtw_pci_rx_ring *rx_ring,
> > +			      u32 idx)
> > +{
> > +	struct rtw_chip_info *chip = rtwdev->chip;
> > +	struct rtw_pci_rx_buffer_desc *buf_desc;
> > +	u32 desc_sz = chip->rx_buf_desc_sz;
> > +	u16 total_pkt_size;
> > +	int i;
> > +
> > +	buf_desc = (struct rtw_pci_rx_buffer_desc *)(rx_ring->r.head +
> > +						     idx * desc_sz);
> > +	for (i = 0; i < 20; i++) {
> > +		total_pkt_size = le16_to_cpu(buf_desc->total_pkt_size);
> > +		if (total_pkt_size)
> > +			return;
> > +	}
> 
> 
> Umm, what are you trying to do here? This is a non-sensical loop. I
> *imagine* you're trying to do some kind of timeout loop here, but since
> there's nothing telling the compiler that this is anything but normal
> memory, this loop gets flattened by the compiler into a single check of
> ->total_pkt_size (I checked; my compiler gets rid of the loop).
> 
> So, at a minimum, you should just remove the loop. But I'm not sure if
> this "check" function has any value at all...
> 
> > +
> > +	if (i >= 20)
> > +		rtw_warn(rtwdev, "pci bus timeout, drop packet\n");
> 
> ...BTW, I'm seeing this get triggered quite a bit.

It's quite strange though... triggered on my laptop as well.
I am looking for the reason that cause it. I found that 8822BE does not
trigger this. And it's like even if I added a volatile before it to hint the
compiler not to optimize, it still happens. Now trying to figure out why
the bus continues to timeout.

After this problem is resolved I'll either remove the loop or add proper
hint for the compiler to check the value. But it seems to take many days
to debug, so I think for this patch set I can just remain it here.

> 
> Do you have some kind of memory mapping/ordering issue or something? I
> wouldn't think you should expect to just drop packets on the floor so
> often like this.
> 

Looks like the cause is that the DMA might not have done when the interrupt
arrived. Need to do more test to figure it out.

> > +}
> > +
> ...
> 
> > +
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
> > +
> > +		/* host read next element in ring */
> > +		if (++cur_rp >= ring->r.len)
> > +			cur_rp = 0;
> > +	}
> > +
> > +	ring->r.rp = cur_rp;
> > +	ring->r.wp = cur_wp;
> > +	rtw_write16(rtwdev, RTK_PCI_RXBD_IDX_MPDUQ, ring->r.rp);
> > +}
> > +

...

> 
> > +static void rtw_pci_parse_configuration(struct rtw_dev *rtwdev,
> > +					struct pci_dev *pdev)
> > +{
> > +	u16 link_control;
> > +	u8 config;
> > +
> 
> In general, this function still uses several magic numbers. It would be
> nice to use macro constants, or at least include a few more comments.
> 
> > +	/* Disable Clk Request */
> > +	pci_write_config_byte(pdev, 0x81, 0);
> 
> 	pcie_capability_clear_word(pdev, PCI_EXP_LNKCTL,
> 				   PCI_EXP_LNKCTL_CLKREQ_EN);
> 
> Or even better, just:
> 
> 	pci_disable_link_state(pdev, PCIE_LINK_STATE_CLKPM);
> 
> > +	/* leave D3 mode */
> > +	pci_write_config_byte(pdev, 0x44, 0);
> 
> This looks like you're trying to do pci_set_power_state(dev, PCI_D0).
> But that's already part of pci_enable_device(), no?
> 
> > +	pci_write_config_byte(pdev, 0x04, 0x06);
> 
> Use the PCI_COMMAND constant?
> 
> And, it looks like maybe you're really trying to do a read-modify-write?
> But anyway, we have PCI_COMMAND_{IO,MEMORY,MASTER} constants for
> this.
> 
> > +	pci_write_config_byte(pdev, 0x04, 0x07);
> 
> Same here.
> 
> Also, what exactly is the purpose here? You're disabling IO and the
> re-enabling it? Is that a hardware quirk, or something else?
> 
> > +
> > +	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &link_control);
> 
> What are you reading this for? You never use it. Remove?
> 
> > +
> > +	pci_read_config_byte(pdev, 0x98, &config);
> > +	config |= BIT(4);
> > +	pci_write_config_byte(pdev, 0x98, config);
> 
> The above 3 can just be:
> 
> 	pcie_capability_set_word(pdev, PCI_EXP_DEVCTL2,
> 				 PCI_EXP_DEVCTL2_COMP_TMOUT_DIS);
> 
> > +
> > +	pci_write_config_byte(pdev, 0x70f, 0x17);
> 
> I couldn't figure out if this was any standard register. Add comments
> and/or a macro definition?
> 
> > +}
> > +


After some testing, this function I think can be removed.
(rtw_pci_parse_configuration)


> > +
> > +static const struct pci_device_id rtw_pci_id_table[] = {
> > +#ifdef CONFIG_RTW88_8822BE
> > +	{ RTK_PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0xB822,
> rtw8822b_hw_spec) },
> > +#endif
> > +#ifdef CONFIG_RTW88_8822CE
> > +	{ RTK_PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0xC822,
> rtw8822c_hw_spec) },
> > +#endif
> > +	{},
> > +};
> > +
> > +static struct pci_driver rtw_pci_driver = {
> > +	.name = "rtw_pci",
> > +	.id_table = rtw_pci_id_table,
> > +	.probe = rtw_pci_probe,
> > +	.remove = rtw_pci_remove,
> > +};
> > +
> > +struct rtw_hci_ops rtw_pci_ops = {
> 
> This struct is local to this unit. Please move it up above where it's
> used and make it static.
> 
> > +	.tx = rtw_pci_tx,
> > +	.setup = rtw_pci_setup,
> > +	.start = rtw_pci_start,
> > +	.stop = rtw_pci_stop,
> > +
> > +	.read8 = rtw_pci_read8,
> > +	.read16 = rtw_pci_read16,
> > +	.read32 = rtw_pci_read32,
> > +	.write8 = rtw_pci_write8,
> > +	.write16 = rtw_pci_write16,
> > +	.write32 = rtw_pci_write32,
> > +	.write_data_rsvd_page = rtw_pci_write_data_rsvd_page,
> > +	.write_data_h2c = rtw_pci_write_data_h2c,
> > +};
> > +
> > +MODULE_DEVICE_TABLE(pci, rtw_pci_id_table);
> 
> Normally, the MODULE_DEVICE_TABLE() is best kept closer to
> rtw_pci_id_table (immediately following its definition). Move it up?
> 
> > +
> > +module_pci_driver(rtw_pci_driver);
> 
> Same here -- once the other things move out of the way, keep this close
> to rtw_pci_driver?

OK, that's reasonable.

> 
> > +
> > +MODULE_AUTHOR("Realtek Corporation");
> > +MODULE_DESCRIPTION("Realtek 802.11ac wireless PCI driver");
> > +MODULE_LICENSE("GPL");
> ...
> 


Yan-Hsuan
