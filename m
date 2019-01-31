Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A5DC169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 22:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0CAB20881
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 22:36:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BW3GtXqw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfAaWgU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 17:36:20 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43464 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbfAaWgU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 17:36:20 -0500
Received: by mail-pl1-f195.google.com with SMTP id gn14so2126420plb.10
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2019 14:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=neBP+RTQgqCRQmN10gwW9GlD1L3iT0i6AyDDTha3Rp8=;
        b=BW3GtXqwN1lJEJWA9w1bGOmpTh6NSIgfiMtqe+cpcujwX6RY2/tT9G3xQoGRtpSVuI
         5FUPQVJmjMm7F6ojE2MTRWRDXB/kKpGwIRuovH7MEq9HYFl2jQSbx02MDTT4tffffmIh
         KLLh5S81z0kTu5PYX5q8jM/93miB57z/vh4cs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=neBP+RTQgqCRQmN10gwW9GlD1L3iT0i6AyDDTha3Rp8=;
        b=Cf7ELctIzWy1hT5mEI5CoB2K7SMn1+0T1PO9asj6u1JzmO9zX205+D/YyHEAeSJxVH
         wpB5FC+mw+uu+TBWNzaRNPb9EFGo4zITBAespUv/h3sp98aOcGnllYU1WZwLC7lEJvVf
         c77SKHUjD1z8t7YCvxaIWRVNNDagxzYghKpolfT0mXd7Xb1ngWRo7Z+bkcowTxSbXfaV
         buIPzFb6CffWP14XN/TYdneNzYeRoEpRYhswesr4rYlbH/tbgLS8acJGTyLfg9MVL26U
         ryGZtVWMV8yml3jxgWNlmVvTjk9bwgkgwOaBYIB9k5D2HKDiyM5soaDSV6NOaVv/7hd8
         HUmA==
X-Gm-Message-State: AJcUukcct22f6y6mTF41ywlu4bD26VTHRqYkoRTs7JQrTvexhI0Py4dL
        q0UVD/J77CM9NYdzWDAAX7Y0cw==
X-Google-Smtp-Source: ALg8bN6rE4shFRlDYRsuv29uSA86CCsa3c16PvTwYONO6SrdpVd7Ql2iMVKtKTDrwu/aGE4MsYcWdg==
X-Received: by 2002:a17:902:b282:: with SMTP id u2mr37230835plr.89.1548974178915;
        Thu, 31 Jan 2019 14:36:18 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id l64sm7257170pge.73.2019.01.31.14.36.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 31 Jan 2019 14:36:17 -0800 (PST)
Date:   Thu, 31 Jan 2019 14:36:15 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, johannes@sipsolutions.net,
        Larry.Finger@lwfinger.net, pkshih@realtek.com, tehuang@realtek.com,
        sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 03/13] rtw88: hci files
Message-ID: <20190131223609.GA191502@google.com>
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

A few scattered comments:

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
...

> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
> new file mode 100644
> index 0000000..ef3c9bb
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -0,0 +1,1210 @@

...

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
> +	dev_kfree_skb_any(skb);

Maybe I'm misreading but...shouldn't this line not be here? You properly
iterate over the allocated SKBs below, and this looks like you're just
going to be double-freeing (or, negative ref-counting).

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

...

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


Umm, what are you trying to do here? This is a non-sensical loop. I
*imagine* you're trying to do some kind of timeout loop here, but since
there's nothing telling the compiler that this is anything but normal
memory, this loop gets flattened by the compiler into a single check of
->total_pkt_size (I checked; my compiler gets rid of the loop).

So, at a minimum, you should just remove the loop. But I'm not sure if
this "check" function has any value at all...

> +
> +	if (i >= 20)
> +		rtw_warn(rtwdev, "pci bus timeout, drop packet\n");

...BTW, I'm seeing this get triggered quite a bit.

Do you have some kind of memory mapping/ordering issue or something? I
wouldn't think you should expect to just drop packets on the floor so
often like this.

> +}
> +
...

> +
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
> +

...

> +static void rtw_pci_parse_configuration(struct rtw_dev *rtwdev,
> +					struct pci_dev *pdev)
> +{
> +	u16 link_control;
> +	u8 config;
> +

In general, this function still uses several magic numbers. It would be
nice to use macro constants, or at least include a few more comments.

> +	/* Disable Clk Request */
> +	pci_write_config_byte(pdev, 0x81, 0);

	pcie_capability_clear_word(pdev, PCI_EXP_LNKCTL,
				   PCI_EXP_LNKCTL_CLKREQ_EN);

Or even better, just:

	pci_disable_link_state(pdev, PCIE_LINK_STATE_CLKPM);

> +	/* leave D3 mode */
> +	pci_write_config_byte(pdev, 0x44, 0);

This looks like you're trying to do pci_set_power_state(dev, PCI_D0).
But that's already part of pci_enable_device(), no?

> +	pci_write_config_byte(pdev, 0x04, 0x06);

Use the PCI_COMMAND constant?

And, it looks like maybe you're really trying to do a read-modify-write?
But anyway, we have PCI_COMMAND_{IO,MEMORY,MASTER} constants for this.

> +	pci_write_config_byte(pdev, 0x04, 0x07);

Same here.

Also, what exactly is the purpose here? You're disabling IO and the
re-enabling it? Is that a hardware quirk, or something else?

> +
> +	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &link_control);

What are you reading this for? You never use it. Remove?

> +
> +	pci_read_config_byte(pdev, 0x98, &config);
> +	config |= BIT(4);
> +	pci_write_config_byte(pdev, 0x98, config);

The above 3 can just be:

	pcie_capability_set_word(pdev, PCI_EXP_DEVCTL2,
				 PCI_EXP_DEVCTL2_COMP_TMOUT_DIS);

> +
> +	pci_write_config_byte(pdev, 0x70f, 0x17);

I couldn't figure out if this was any standard register. Add comments
and/or a macro definition?

> +}
> +
> +static int rtw_pci_claim(struct rtw_dev *rtwdev, struct pci_dev *pdev)
> +{
> +	int ret;
> +
> +	ret = pci_enable_device(pdev);
> +	if (ret) {
> +		rtw_err(rtwdev, "failed to enable pci device\n");
> +		return ret;
> +	}
> +
> +	pci_set_master(pdev);
> +	pci_set_drvdata(pdev, rtwdev->hw);
> +	SET_IEEE80211_DEV(rtwdev->hw, &pdev->dev);
> +
> +	return 0;
> +}
> +
> +static void rtw_pci_declaim(struct rtw_dev *rtwdev, struct pci_dev *pdev)
> +{
> +	pci_clear_master(pdev);
> +	pci_disable_device(pdev);
> +}
> +
> +static int rtw_pci_setup_resource(struct rtw_dev *rtwdev, struct pci_dev *pdev)
> +{
> +	struct rtw_pci *rtwpci;
> +	int ret;
> +
> +	rtwpci = (struct rtw_pci *)rtwdev->priv;
> +	rtwpci->pdev = pdev;
> +
> +	/* after this driver can access to hw registers */
> +	ret = rtw_pci_io_mapping(rtwdev, pdev);
> +	if (ret) {
> +		rtw_err(rtwdev, "failed to request pci io region\n");
> +		goto err_out;
> +	}
> +
> +	ret = rtw_pci_init(rtwdev);
> +	if (ret) {
> +		rtw_err(rtwdev, "failed to allocate pci resources\n");
> +		goto err_io_unmap;
> +	}
> +
> +	rtw_pci_parse_configuration(rtwdev, pdev);
> +	rtw_pci_phy_cfg(rtwdev);
> +
> +	return 0;
> +
> +err_io_unmap:
> +	rtw_pci_io_unmapping(rtwdev, pdev);
> +
> +err_out:
> +	return ret;
> +}
> +
> +static void rtw_pci_destroy(struct rtw_dev *rtwdev, struct pci_dev *pdev)
> +{
> +	rtw_pci_deinit(rtwdev);
> +	rtw_pci_io_unmapping(rtwdev, pdev);
> +}
> +
> +static int rtw_pci_probe(struct pci_dev *pdev,
> +			 const struct pci_device_id *id)
> +{
> +	struct ieee80211_hw *hw;
> +	struct rtw_dev *rtwdev;
> +	int drv_data_size;
> +	int ret;
> +
> +	drv_data_size = sizeof(struct rtw_dev) + sizeof(struct rtw_pci);
> +	hw = ieee80211_alloc_hw(drv_data_size, &rtw_ops);
> +	if (!hw) {
> +		dev_err(&pdev->dev, "failed to allocate hw\n");
> +		return -ENOMEM;
> +	}
> +
> +	rtwdev = hw->priv;
> +	rtwdev->hw = hw;
> +	rtwdev->dev = &pdev->dev;
> +	rtwdev->chip = (struct rtw_chip_info *)id->driver_data;
> +	rtwdev->hci.ops = &rtw_pci_ops;
> +	rtwdev->hci.type = RTW_HCI_TYPE_PCIE;
> +
> +	ret = rtw_core_init(rtwdev);
> +	if (ret)
> +		goto err_release_hw;
> +
> +	rtw_dbg(rtwdev,
> +		"rtw88 pci probe: vendor=0x%4.04X device=0x%4.04X rev=%d\n",
> +		pdev->vendor, pdev->device, pdev->revision);
> +
> +	ret = rtw_pci_claim(rtwdev, pdev);
> +	if (ret) {
> +		rtw_err(rtwdev, "failed to claim pci device\n");
> +		goto err_deinit_core;
> +	}
> +
> +	ret = rtw_pci_setup_resource(rtwdev, pdev);
> +	if (ret) {
> +		rtw_err(rtwdev, "failed to setup pci resources\n");
> +		goto err_pci_declaim;
> +	}
> +
> +	ret = rtw_chip_info_setup(rtwdev);
> +	if (ret) {
> +		rtw_err(rtwdev, "failed to setup chip information\n");
> +		goto err_destroy_pci;
> +	}
> +
> +	ret = rtw_register_hw(rtwdev, hw);
> +	if (ret) {
> +		rtw_err(rtwdev, "failed to register hw\n");
> +		goto err_destroy_pci;
> +	}
> +
> +	ret = request_irq(pdev->irq, &rtw_pci_interrupt_handler,
> +			  IRQF_SHARED, KBUILD_MODNAME, rtwdev);
> +	if (ret) {
> +		ieee80211_unregister_hw(hw);
> +		goto err_destroy_pci;
> +	}
> +
> +	return 0;
> +
> +err_destroy_pci:
> +	rtw_pci_destroy(rtwdev, pdev);
> +
> +err_pci_declaim:
> +	rtw_pci_declaim(rtwdev, pdev);
> +
> +err_deinit_core:
> +	rtw_core_deinit(rtwdev);
> +
> +err_release_hw:
> +	ieee80211_free_hw(hw);
> +
> +	return ret;
> +}
> +
> +static void rtw_pci_remove(struct pci_dev *pdev)
> +{
> +	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
> +	struct rtw_dev *rtwdev;
> +	struct rtw_pci *rtwpci;
> +
> +	if (!hw)
> +		return;
> +
> +	rtwdev = hw->priv;
> +	rtwpci = (struct rtw_pci *)rtwdev->priv;
> +
> +	rtw_unregister_hw(rtwdev, hw);
> +	rtw_pci_disable_interrupt(rtwdev, rtwpci);
> +	rtw_pci_destroy(rtwdev, pdev);
> +	rtw_pci_declaim(rtwdev, pdev);
> +	free_irq(rtwpci->pdev->irq, rtwdev);
> +	rtw_core_deinit(rtwdev);
> +	ieee80211_free_hw(hw);
> +}
> +
> +static const struct pci_device_id rtw_pci_id_table[] = {
> +#ifdef CONFIG_RTW88_8822BE
> +	{ RTK_PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0xB822, rtw8822b_hw_spec) },
> +#endif
> +#ifdef CONFIG_RTW88_8822CE
> +	{ RTK_PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0xC822, rtw8822c_hw_spec) },
> +#endif
> +	{},
> +};
> +
> +static struct pci_driver rtw_pci_driver = {
> +	.name = "rtw_pci",
> +	.id_table = rtw_pci_id_table,
> +	.probe = rtw_pci_probe,
> +	.remove = rtw_pci_remove,
> +};
> +
> +struct rtw_hci_ops rtw_pci_ops = {

This struct is local to this unit. Please move it up above where it's
used and make it static.

> +	.tx = rtw_pci_tx,
> +	.setup = rtw_pci_setup,
> +	.start = rtw_pci_start,
> +	.stop = rtw_pci_stop,
> +
> +	.read8 = rtw_pci_read8,
> +	.read16 = rtw_pci_read16,
> +	.read32 = rtw_pci_read32,
> +	.write8 = rtw_pci_write8,
> +	.write16 = rtw_pci_write16,
> +	.write32 = rtw_pci_write32,
> +	.write_data_rsvd_page = rtw_pci_write_data_rsvd_page,
> +	.write_data_h2c = rtw_pci_write_data_h2c,
> +};
> +
> +MODULE_DEVICE_TABLE(pci, rtw_pci_id_table);

Normally, the MODULE_DEVICE_TABLE() is best kept closer to
rtw_pci_id_table (immediately following its definition). Move it up?

> +
> +module_pci_driver(rtw_pci_driver);

Same here -- once the other things move out of the way, keep this close
to rtw_pci_driver?

Brian

> +
> +MODULE_AUTHOR("Realtek Corporation");
> +MODULE_DESCRIPTION("Realtek 802.11ac wireless PCI driver");
> +MODULE_LICENSE("GPL");
...
