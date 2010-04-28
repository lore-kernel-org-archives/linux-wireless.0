Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:2327 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754409Ab0D1WEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 18:04:14 -0400
Message-ID: <4BD8B0DB.1010902@gmail.com>
Date: Thu, 29 Apr 2010 00:04:11 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: cabtobma@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ivdoorn@gmail.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] rt2x00: remove now unused noise field from struct rxdone_entry_desc
References: <1272488452-21288-1-git-send-email-cabtobma>
In-Reply-To: <1272488452-21288-1-git-send-email-cabtobma>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/28/10 23:00, cabtobma@tuxdriver.com wrote:
> From: John W. Linville <linville@tuxdriver.com>
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c   |    4 ----
>  drivers/net/wireless/rt2x00/rt2800usb.c   |    4 ----
>  drivers/net/wireless/rt2x00/rt2x00queue.h |    2 --
>  3 files changed, 0 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 0e52f17..89281d7 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -895,10 +895,6 @@ static void rt2800pci_fill_rxdone(struct queue_entry *entry,
>  	    (rt2x00_get_field32(rxwi2, RXWI_W2_RSSI0) +
>  	     rt2x00_get_field32(rxwi2, RXWI_W2_RSSI1)) / 2;
>  
> -	rxdesc->noise =
> -	    (rt2x00_get_field32(rxwi3, RXWI_W3_SNR0) +
> -	     rt2x00_get_field32(rxwi3, RXWI_W3_SNR1)) / 2;
> -
>  	rxdesc->size = rt2x00_get_field32(rxwi0, RXWI_W0_MPDU_TOTAL_BYTE_COUNT);
>  
>  	/*
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index a716156..6f2a945 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -645,10 +645,6 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
>  	    (rt2x00_get_field32(rxwi2, RXWI_W2_RSSI0) +
>  	     rt2x00_get_field32(rxwi2, RXWI_W2_RSSI1)) / 2;
>  
> -	rxdesc->noise =
> -	    (rt2x00_get_field32(rxwi3, RXWI_W3_SNR0) +
> -	     rt2x00_get_field32(rxwi3, RXWI_W3_SNR1)) / 2;
> -
>  	rxdesc->size = rt2x00_get_field32(rxwi0, RXWI_W0_MPDU_TOTAL_BYTE_COUNT);
>  
>  	/*
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
> index c1e482b..f519aba 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
> @@ -183,7 +183,6 @@ enum rxdone_entry_desc_flags {
>   * @timestamp: RX Timestamp
>   * @signal: Signal of the received frame.
>   * @rssi: RSSI of the received frame.
> - * @noise: Measured noise during frame reception.
>   * @size: Data size of the received frame.
>   * @flags: MAC80211 receive flags (See &enum mac80211_rx_flags).
>   * @dev_flags: Ralink receive flags (See &enum rxdone_entry_desc_flags).
> @@ -197,7 +196,6 @@ struct rxdone_entry_desc {
>  	u64 timestamp;
>  	int signal;
>  	int rssi;
> -	int noise;
>  	int size;
>  	int flags;
>  	int dev_flags;

