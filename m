Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42394 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab1GLEud (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 00:50:33 -0400
Message-ID: <4E1BD28C.2070704@openwrt.org> (sfid-20110712_065104_528692_F1423E9D)
Date: Tue, 12 Jul 2011 12:50:20 +0800
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
CC: netdev@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 04/46] net/wireless: p54: remove useless dma_sync_single_for_device(DMA_FROM_DEVICE)
References: <cover.1310339688.git.mirq-linux@rere.qmqm.pl> <86c8bde08b005ca7eb4806ea77aec1f3212d63fc.1310339688.git.mirq-linux@rere.qmqm.pl>
In-Reply-To: <86c8bde08b005ca7eb4806ea77aec1f3212d63fc.1310339688.git.mirq-linux@rere.qmqm.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-07-11 8:52 AM, Michał Mirosław wrote:
> Also constify pointers used in frame parsers to verify assumptions.
>
> Signed-off-by: Michał Mirosław<mirq-linux@rere.qmqm.pl>
> ---
>   drivers/net/wireless/p54/p54pci.c |    2 --
>   drivers/net/wireless/p54/txrx.c   |   22 +++++++++++-----------
>   2 files changed, 11 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
> index 1b75317..4491d33 100644
> --- a/drivers/net/wireless/p54/p54pci.c
> +++ b/drivers/net/wireless/p54/p54pci.c
> @@ -229,8 +229,6 @@ static void p54p_check_rx_ring(struct ieee80211_hw *dev, u32 *index,
>   			desc->host_addr = cpu_to_le32(0);
>   		} else {
>   			skb_trim(skb, 0);
> -			pci_dma_sync_single_for_device(priv->pdev, dma_addr,
> -				priv->common.rx_mtu + 32, PCI_DMA_FROMDEVICE);
>   			desc->len = cpu_to_le16(priv->common.rx_mtu + 32);
>   		}
>
This part does not look correct to me - same issue as your ath9k change, 
which I commented on earlier. I don't think this call to 
dma_sync_single_for_device is useless

- Felix

