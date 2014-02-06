Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:33487 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaBFUfY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 15:35:24 -0500
Received: by mail-ob0-f182.google.com with SMTP id wm4so2890600obc.13
        for <linux-wireless@vger.kernel.org>; Thu, 06 Feb 2014 12:35:23 -0800 (PST)
Message-ID: <52F3F208.20606@lwfinger.net> (sfid-20140206_213528_269438_FA8641AC)
Date: Thu, 06 Feb 2014 14:35:20 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: andrea merello <andrea.merello@gmail.com>, linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/4] Add error check for pci_map_single return value in
 rtl8180 TX path
References: <1391636287-17712-1-git-send-email-andrea.merello@gmail.com> <1391636287-17712-4-git-send-email-andrea.merello@gmail.com>
In-Reply-To: <1391636287-17712-4-git-send-email-andrea.merello@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/05/2014 03:38 PM, andrea merello wrote:
> From: "andrea.merello" <andrea.merello@gmail.com>
>
> Orignal code will not detect a DMA mapping failure, causing the HW
> to attempt a DMA from an invalid address.
>
> This patch add the error check and eventually simply drops the TX
> packet if we can't map it for DMA.
>
> Signed-off-by: andrea.merello <andrea.merello@gmail.com>
> Signed-off-by: andrea merello <andrea.merello@gmail.com>

This code is standard for recovery from an error in pci_map_single().

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

> ---
>   drivers/net/wireless/rtl818x/rtl8180/dev.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
> index 1c6ac25..9645ed2 100644
> --- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
> @@ -276,6 +276,13 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
>   	mapping = pci_map_single(priv->pdev, skb->data,
>   				 skb->len, PCI_DMA_TODEVICE);
>
> +	if (pci_dma_mapping_error(priv->pdev, mapping)) {
> +		kfree_skb(skb);
> +		dev_err(&priv->pdev->dev, "TX DMA mapping error\n");
> +		return;
> +
> +	}
> +
>   	tx_flags = RTL818X_TX_DESC_FLAG_OWN | RTL818X_TX_DESC_FLAG_FS |
>   		   RTL818X_TX_DESC_FLAG_LS |
>   		   (ieee80211_get_tx_rate(dev, info)->hw_value << 24) |
>

