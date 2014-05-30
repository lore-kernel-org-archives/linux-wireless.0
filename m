Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34483 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754324AbaE3VS0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 17:18:26 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Chin-Ran Lo <crlo@marvell.com>,
	Aaron Durbin <adurbin@chromium.org>
Date: Fri, 30 May 2014 14:18:18 -0700
Subject: RE: [PATCH 1/2] mwifiex: fix PCIe tx_info overlap
Message-ID: <477F20668A386D41ADCC57781B1F70430F7104819A@SC-VEXCH1.marvell.com> (sfid-20140530_231830_260290_190ADC2C)
References: <1401477189-24531-1-git-send-email-bzhao@marvell.com>
In-Reply-To: <1401477189-24531-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Chin-Ran Lo <crlo@marvell.com>
> 
> On PCIe Tx data path, network interface specific parameters
> bss_num and bss_type are saved at "skb->cb + sizeof(dma_addr_t)"
> (returned by MWIFIEX_SKB_TXCB). Later mwifiex_map_pci_memory()
> called from mwifiex_pcie_send_data() will memcpy
> sizeof(struct mwifiex_dma_mapping) bytes to save PCIe DMA
> address and length information at beginning of skb->cb.
> This accidently overwrites bss_num and bss_type saved in skb->cb
> previously because bss_num/bss_type and mwifiex_dma_mapping data
> overlap. Fix it by having MWIFIEX_SKB_TXCB return the correct
> offset for bss_num and bss_type.
> 
> Cc: Aaron Durbin <adurbin@chromium.org>
> Signed-off-by: Chin-Ran Lo <crlo@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>

Hi John,

Please ignore this patch.
As Aaron pointed out offline, it needs more work on RX path as well.

Thanks,
Bing

