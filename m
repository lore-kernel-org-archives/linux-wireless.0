Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E031C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 12:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE7662064A
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 12:07:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE7662064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbeJETFx convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 15:05:53 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:33823 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727666AbeJETFw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 15:05:52 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w95C77Te026995, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w95C77Te026995
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 5 Oct 2018 20:07:07 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0399.000; Fri, 5 Oct 2018 20:07:07 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC v2 03/12] rtw88: hci files
Thread-Topic: [RFC v2 03/12] rtw88: hci files
Thread-Index: AQHUW+J700o5WDjqi0mvFShMBfsKOqUQOzqA
Date:   Fri, 5 Oct 2018 12:07:06 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D172A54A@RTITMBSVM01.realtek.com.tw>
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
 <1538553748-26364-4-git-send-email-yhchuang@realtek.com>
 <20181004130212.GC16819@redhat.com>
In-Reply-To: <20181004130212.GC16819@redhat.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



> -----Original Message-----
> From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
> Sent: Thursday, October 04, 2018 9:02 PM
> To: Tony Chuang
> Cc: kvalo@codeaurora.org; Larry.Finger@lwfinger.net; Pkshih; Andy Huang;
> linux-wireless@vger.kernel.org
> Subject: Re: [RFC v2 03/12] rtw88: hci files
> 
> On Wed, Oct 03, 2018 at 04:02:19PM +0800, yhchuang@realtek.com wrote:
> > +static inline u32
> > +rtw_read_rf(struct rtw_dev *rtwdev, enum rtw_rf_path rf_path,
> > +	    u32 addr, u32 mask)
> > +{
> > +	unsigned long flags;
> > +	u32 val;
> > +
> > +	spin_lock_irqsave(&rtwdev->rf_lock, flags);
> > +	val = rtwdev->chip->ops->read_rf(rtwdev, rf_path, addr, mask);
> > +	spin_unlock_irqrestore(&rtwdev->rf_lock, flags);
> 
> What for is rtwdev->rf_lock lock ? Is possible to call
> rtw_read_rf() or rtw_write_rf() in some simultanious way ?


It totally could call them concurrently.
The opportunity is low now, but we will add bt coexistence and some
RF calibration code.
We should protect the RF register read/write.


> 
> > +static int rtw_pci_reset_rx_desc(struct rtw_dev *rtwdev, struct sk_buff
> *skb,
> > +				 struct rtw_pci_rx_ring *rx_ring,
> > +				 u32 idx, u32 desc_sz)
> > +{
> > +	struct pci_dev *pdev = to_pci_dev(rtwdev->dev);
> > +	struct rtw_pci_rx_buffer_desc *buf_desc;
> > +	int buf_sz = RTK_PCI_RX_BUF_SIZE;
> > +	dma_addr_t dma;
> > +
> > +	if (!skb)
> > +		return -EINVAL;
> Too late, see below.
> 
> > +
> > +	dma = pci_map_single(pdev, skb->data, buf_sz, PCI_DMA_FROMDEVICE);
> > +	if (pci_dma_mapping_error(pdev, dma))
> > +		return -EBUSY;
> > +
> > +	*((dma_addr_t *)skb->cb) = dma;
> > +	buf_desc = (struct rtw_pci_rx_buffer_desc *)(rx_ring->r.head +
> > +						     idx * desc_sz);
> > +	memset(buf_desc, 0, sizeof(*buf_desc));
> > +	buf_desc->buf_size = cpu_to_le16(8216);
> 
> Why the difference between RTK_PCI_RX_BUF_SIZE = 9100 and this 8216 ?

It is a bit strange, I need to do some test on it.
But looks like 8216 is the RX desc size 24 + 8K AMSDU,
and 9100 is just a number bigger than it. If the DMA engine
runs OK with buf_size = 8192 and with exactly the same size
of dma region we allocated, I will fix it.

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
> > +		memset(skb->data, 0, buf_sz);
> No error check. Also I think you should use different version to
> allow specify GPF_KERNEL flag, this is not atomic context.

OK, that will be better.

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
> > +
> > +	if (i >= 20)
> > +		rtw_warn(rtwdev, "pci bus timeout, drop packet\n");
> This is not right, most likely you need to use
> dma_sync_single_for_cpu() .

Not really understand how dma_sync_single_for_cpu() works.
Can you show me if possible?

> 
> > +static int rtw_pci_tx(struct rtw_dev *rtwdev,
> > +		      struct rtw_tx_pkt_info *pkt_info,
> > +		      struct sk_buff *skb)
> > +{
> > +	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> > +	struct rtw_pci_tx_ring *ring;
> > +	u8 queue = rtw_hw_queue_mapping(skb);
> > +	int ret;
> > +
> > +	ret = rtw_pci_xmit(rtwdev, pkt_info, skb, queue);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ring = &rtwpci->tx_rings[queue];
> > +	if (avail_desc(ring->r.wp, ring->r.rp, ring->r.len) < 2) {
> > +		ieee80211_stop_queue(rtwdev->hw, skb_get_queue_mapping(skb));
> > +		ring->queue_stopped = true;
> I think here is race condition with below code that wakes queue...

Yes, should protect them with locks, will fix it.

> 
> > +		if (ring->queue_stopped &&
> > +		    avail_desc(ring->r.wp, ring->r.rp, ring->r.len) > 4) {
> > +			q_map = skb_get_queue_mapping(skb);
> > +			ieee80211_wake_queue(hw, q_map);
> > +			ring->queue_stopped = false;
> 
> ... here. This should be somehow synchronized.
> > +		}
> > +
> > +		info = IEEE80211_SKB_CB(skb);
> > +		ieee80211_tx_info_clear_status(info);
> > +		info->flags |= IEEE80211_TX_STAT_ACK;
> > +		ieee80211_tx_status_irqsafe(hw, skb);
> 
> Always report ACK ?

The ACK report is for mac80211 stack, it looks abnormal at the first glance.
But we can only do this for every data frame because there is no ack report
unless the driver ask the firmware to give one.
Ask for every data frame is resource consuming.

But further we will implement a tx report system for some specific frames.
Such as mgmt. frames, or pm related frames or null data frame.
And they will not be added in the first commit.

> > +
> > +static irqreturn_t rtw_pci_interrupt_handler(int irq, void *dev)
> > +{
> > +	struct rtw_dev *rtwdev = dev;
> > +	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> > +	u32 irq_status[4];
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&rtwpci->irq_lock, flags);
> 
> flags not needed, interrupts are disabled in IRQ.

Should be removed

> 
> > +	rtw_pci_disable_interrupt(rtwdev, rtwpci);
> 
> This seems to be not needed as well.
> 

I think this is needed, because firmware may be interrupted as well.
But this is worth testing, or should avoid tx interrupt and use some kind
of polling mechanisms. Reduce the CPU loading and take advantage of
SW tx queue. That is quite much code to add. Needs more time to investigate,
but will not be included in this RFC.

> > +static void rtw_pci_init_aspm(struct rtw_dev *rtwdev)
> > +{
> > +}
> Something is missing ;-)

Should remove them.

> > +struct rtw_hci_ops rtw_pci_ops = {
> <snip>
> > +	.check_avail_desc = rtw_pci_check_avail_desc,
> Not used ?


Should remove them.


> 
> Thanks
> Stanislaw
> 
> 
> ------Please consider the environment before printing this e-mail.
