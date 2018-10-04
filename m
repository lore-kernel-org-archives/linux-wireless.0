Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 191BEC64EBC
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 13:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAE4C2084D
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 13:02:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CAE4C2084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbeJDTz2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 15:55:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44478 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727256AbeJDTz1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 15:55:27 -0400
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6AAB630DF71D;
        Thu,  4 Oct 2018 13:02:16 +0000 (UTC)
Received: from localhost (unknown [10.43.2.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8190E308BDAB;
        Thu,  4 Oct 2018 13:02:15 +0000 (UTC)
Date:   Thu, 4 Oct 2018 15:02:13 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        pkshih@realtek.com, tehuang@realtek.com,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC v2 03/12] rtw88: hci files
Message-ID: <20181004130212.GC16819@redhat.com>
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
 <1538553748-26364-4-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538553748-26364-4-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.24
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 04 Oct 2018 13:02:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 03, 2018 at 04:02:19PM +0800, yhchuang@realtek.com wrote:
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

What for is rtwdev->rf_lock lock ? Is possible to call
rtw_read_rf() or rtw_write_rf() in some simultanious way ?

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
Too late, see below.

> +
> +	dma = pci_map_single(pdev, skb->data, buf_sz, PCI_DMA_FROMDEVICE);
> +	if (pci_dma_mapping_error(pdev, dma))
> +		return -EBUSY;
> +
> +	*((dma_addr_t *)skb->cb) = dma;
> +	buf_desc = (struct rtw_pci_rx_buffer_desc *)(rx_ring->r.head +
> +						     idx * desc_sz);
> +	memset(buf_desc, 0, sizeof(*buf_desc));
> +	buf_desc->buf_size = cpu_to_le16(8216);

Why the difference between RTK_PCI_RX_BUF_SIZE = 9100 and this 8216 ? 

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
> +		memset(skb->data, 0, buf_sz);
No error check. Also I think you should use different version to 
allow specify GPF_KERNEL flag, this is not atomic context.

> +static void rtw_pci_dma_check(struct rtw_dev *rtwdev,
> +			      struct rtw_pci_rx_ring *rx_ring,
> +			      u32 idx)
> +{
> +	struct rtw_chip_info *chip = rtwdev->chip;
> +	struct rtw_pci_rx_buffer_desc *buf_desc;
> +	u32 desc_sz = chip->rx_buf_desc_sz;
> +	u16 total_pkt_size;
> +	int i;
> +
> +	buf_desc = (struct rtw_pci_rx_buffer_desc *)(rx_ring->r.head +
> +						     idx * desc_sz);
> +	for (i = 0; i < 20; i++) {
> +		total_pkt_size = le16_to_cpu(buf_desc->total_pkt_size);
> +		if (total_pkt_size)
> +			return;
> +	}
> +
> +	if (i >= 20)
> +		rtw_warn(rtwdev, "pci bus timeout, drop packet\n");
This is not right, most likely you need to use
dma_sync_single_for_cpu() .

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
I think here is race condition with below code that wakes queue...

> +		if (ring->queue_stopped &&
> +		    avail_desc(ring->r.wp, ring->r.rp, ring->r.len) > 4) {
> +			q_map = skb_get_queue_mapping(skb);
> +			ieee80211_wake_queue(hw, q_map);
> +			ring->queue_stopped = false;

... here. This should be somehow synchronized.
> +		}
> +
> +		info = IEEE80211_SKB_CB(skb);
> +		ieee80211_tx_info_clear_status(info);
> +		info->flags |= IEEE80211_TX_STAT_ACK;
> +		ieee80211_tx_status_irqsafe(hw, skb);

Always report ACK ?
> +
> +static irqreturn_t rtw_pci_interrupt_handler(int irq, void *dev)
> +{
> +	struct rtw_dev *rtwdev = dev;
> +	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
> +	u32 irq_status[4];
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&rtwpci->irq_lock, flags);

flags not needed, interrupts are disabled in IRQ.

> +	rtw_pci_disable_interrupt(rtwdev, rtwpci);

This seems to be not needed as well.

> +static void rtw_pci_init_aspm(struct rtw_dev *rtwdev)
> +{
> +}
Something is missing ;-)

> +static void rtw_dbi_write8(struct rtw_dev *rtwdev, u16 addr, u8 data)
> +{
> +	u16 write_addr;
> +	u16 remainder = addr & 0x3;
> +	u8 flag;
> +	u8 cnt = 20;
> +
> +	write_addr = ((addr & 0x0ffc) | (BIT(0) << (remainder + 12)));
> +	rtw_write8(rtwdev, REG_DBI_WDATA_V1 + remainder, data);
> +	rtw_write16(rtwdev, REG_DBI_FLAG_V1, write_addr);
> +	rtw_write8(rtwdev, REG_DBI_FLAG_V1 + 2, 0x01);
> +
> +	flag = rtw_read8(rtwdev, REG_DBI_FLAG_V1 + 2);
> +	while (flag && (cnt != 0)) {
> +		udelay(10);
> +		flag = rtw_read8(rtwdev, REG_DBI_FLAG_V1 + 2);
> +		cnt--;
> +	}
> +
> +	WARN(flag, "DBI write fail");
We always print WARN, there is other return point in this function.

> +static void rtw_mdio_write(struct rtw_dev *rtwdev, u8 addr, u16 data, bool g1)
<snip>
> +	WARN(wflag, "MDIO write fail");
The same.

> +struct rtw_hci_ops rtw_pci_ops = {
<snip>
> +	.check_avail_desc = rtw_pci_check_avail_desc,
Not used ?

Thanks
Stanislaw
 
