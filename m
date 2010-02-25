Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:57272 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932999Ab0BYRXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 12:23:40 -0500
Message-ID: <4B86B21A.1040906@gmail.com>
Date: Thu, 25 Feb 2010 18:23:38 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: prahal@yahoo.com, rt2x00 Users List <users@rt2x00.serialmonkey.com>
CC: John Linville <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [rt2x00-users] [PATCH 2/2] rt2x00 : fix txdone implementation
References: <4B868099.9000405@yahoo.com>
In-Reply-To: <4B868099.9000405@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/10 14:52, Alban Browaeys wrote:
> Properly move to the headroom position in dma mapped skb. The hw extra
> headroom is now taken into account.
> 
> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c
> b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 46b06af..fbeff5c 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -966,7 +966,7 @@ static void rt2800pci_txdone(struct rt2x00_dev
> *rt2x00dev)
>          /* Check if we got a match by looking at WCID/ACK/PID
>           * fields */
>          txwi = (__le32 *)(entry->skb->data -
> -                  rt2x00dev->hw->extra_tx_headroom);
> +                  rt2x00dev->ops->extra_tx_headroom);
>  
>          rt2x00_desc_read(txwi, 1, &word);
>          tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);

This seems to be fixing an issue with your first patch. Please fold this fix into the first
patch and submit a single "working" patch.

---
Gertjan.
