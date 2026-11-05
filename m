Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.77.101.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793866206;
	b=L81b+QyndXdm5hiJddKqrWk7KdvceZz954GD0Y9eohuAGW5A6vz6WyIvsKx32zm6GUo8
	 SHPXfVzTTIMH3wN86zcpXn6CGChFY8/5UApJ/PWvGBSvdXOWQmnE+tIU0eCFF1os+Sg5u
	 kNoP0R4TSWud3COjdggtWb/feKK1Jv677pjLv6kTrFTOVPMbROOKbjGE36E7w6A03GeWi
	 QuKYw2LzFsjdDwZdA22MaPxaVjZ/+QS2hmSZh5r4uI58uuNYGKgwcMGiYRBta8tK48lg7
	 isCOhZtDmhpgs1dodoM46sW9xOnB7YSfWWNNRiJh4tYVTYsBYxJmQKDTKg45Mn31LSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793866206;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-WP-MailID:X-WP-AV:X-WP-SPAM;
	bh=pPzxmMDpWSDaV8W3s4FdAc/v8tpRCB4PYKmWU6fSemM=;
	b=KEmSYKCM+TaLYTnUgSfdOAhZOYz/hqUC71XyA4u/8oibkabidqSJ9HIprrZTyPAKzZAn
	 ixADes6rzrvFG0QHeU85WiecVWIEaT64lTsBf2BOJOhX6xnjWZoxEZAp+55QO1KFYgeyx
	 2ztndGX+eLS15ocnccX0/nkh4qf7lptFQt8BGssvojBbJlsEV9i6cnDe4u2LwPiNzolg0
	 Heks9k6nz++SnjKdIMJAO7hHk1sNkWiK53i/nlkhS8LQzlJDMTjUdnLCuR93tadPnyRBw
	 uOiy0B7kG/XgogON5AKhiMMpuRBBUCo+wipIfyaSt2QEt+ZmPzCGMp4SFKkeVZE5sSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wp.pl;
	spf=pass smtp.mailfrom=wp.pl;
	dkim=pass header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=kFjLGTSs;
	arc=none smtp.remote-ip=212.77.101.12
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF061606A332
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 08:10:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF061606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=kFjLGTSs
Received: (wp-smtpd smtp.wp.pl 13302 invoked from network); 5 Nov 2026 09:10:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1793866200; bh=pPzxmMDpWSDaV8W3s4FdAc/v8tpRCB4PYKmWU6fSemM=;
          h=From:To:Cc:Subject;
          b=kFjLGTSs+ry8DE4tZu5U5w4yCGsSGddgD2NnNmfWle+0UJcbKGgSUaNrKbghsFFWt
           I0VPdUHwWaE8W4VrayoIe5Mx0kSTAd7MQNEk4GiG5PDh3iBNYpk9LQg25VRKr3W+y7
           bNbzSZ08iWfZX7PKU+m9xmFE7vj6rUb6yG03CJgVRStSsBHDnOYg0h+zZ7MBw1msIr
           zwW4sLhNr2wsVuDcYjv9z/Ki4vWrucbyjETLXyZT1c4039JsEbrJg7CG/bvKruWvLB
           ffIAd/UEwEffVIyvhkHX9nn8n9SWHMIdf9x5KJlN1nWG2lBGMOPKufDE4/O4bgKFdM
           lRZp/Bjbwl4Ow==
Received: from localhost (77-236-11-168.static.play.pl [77.236.11.168])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <hjf3108@gmail.com>; 5 Nov 2026 09:10:00 +0100
Date: Thu, 5 Nov 2026 09:10:00 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Ho Jie Feng <hjf3108@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-next v2 6/7] wifi: rt2800usb: enable RX bulk
 aggregation
Message-ID: <20261105081000.GF64923@wp.pl>
References: <20261031165117.2868671-1-hjf3108@gmail.com>
 <20261031165117.2868671-7-hjf3108@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261031165117.2868671-7-hjf3108@gmail.com>
X-WP-MailID: c842c11c0585a80f5c1764f88a790da2
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [IXME]                               

On Sun, Nov 01, 2026 at 12:51:13AM +0800, Ho Jie Feng wrote:
> Enable RX bulk aggregation on high speed USB, to receive more
> frames per URB.
> 
> RX buffers are now 24KB, so reduce it to 16 buffers instead of 128,
> so that they take 512 KB in total instead of 4 MB.
> 
> Test results:
>    before after
> TX 30.5   30.5
> RX 67.8   80.9
> 
> This code references the mt7601u driver.
> 
> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> ---
>  .../net/wireless/ralink/rt2x00/rt2800usb.c    | 32 +++++--
>  .../net/wireless/ralink/rt2x00/rt2800usb.h    |  6 ++
>  drivers/net/wireless/ralink/rt2x00/rt2x00.h   |  3 +-
>  .../net/wireless/ralink/rt2x00/rt2x00dev.c    | 84 +++++++++++++------
>  .../net/wireless/ralink/rt2x00/rt2x00mmio.c   |  2 +-
>  .../net/wireless/ralink/rt2x00/rt2x00usb.c    |  5 +-
>  6 files changed, 100 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
> index 387c07e2251b7..2e4277b1e5d1b 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
> @@ -301,15 +301,15 @@ static int rt2800usb_enable_radio(struct rt2x00_dev *rt2x00dev)
>  		return -EIO;
>  
>  	rt2x00_set_field32(&reg, USB_DMA_CFG_PHY_CLEAR, 0);
> -	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_EN, 0);
> +	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_EN,
> +			   rt2x00dev->rx->usb_maxpacket == 512);

Any idea why this condition ? We can not have aggregation on slower
or faster USB?

>  	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_TIMEOUT, 128);
>  	/*
>  	 * Total room for RX frames in kilobytes, PBF might still exceed
>  	 * this limit so reduce the number to prevent errors.
>  	 */
>  	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_LIMIT,
> -			   ((rt2x00dev->rx->limit * DATA_FRAME_SIZE)
> -			    / 1024) - 3);
> +			   (rt2x00dev->rx->data_size / 1024) - 4);
>  	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_EN, 1);
>  	rt2x00_set_field32(&reg, USB_DMA_CFG_TX_BULK_EN, 1);
>  	rt2x00usb_register_write(rt2x00dev, USB_DMA_CFG, reg);
> @@ -478,6 +478,27 @@ static void rt2800usb_work_txdone(struct work_struct *work)
>  /*
>   * RX control handlers
>   */
> +static unsigned int rt2800usb_get_rx_seg_len(void *data, unsigned int len)
> +{
> +	unsigned int min_seg_len = RXINFO_DESC_SIZE + RXWI_DESC_SIZE_4WORDS +
> +				   RXD_DESC_SIZE;
> +	unsigned int rx_pkt_len;
> +	u32 word;
> +
> +	if (len < min_seg_len)
> +		return 0;
> +
> +	word = rt2x00_desc_read(data, 0);
> +	rx_pkt_len = rt2x00_get_field32(word, RXINFO_W0_USB_DMA_RX_PKT_LEN);
> +
> +	if (!rx_pkt_len ||
> +	    RXINFO_DESC_SIZE + rx_pkt_len + RXD_DESC_SIZE > len ||
> +	    rx_pkt_len & 0x3)

This is indication of we do something wrong, similar when len < min_seg_len.
Maybe wrap those with WARN_ON_ONCE() ? 

>
> +
> +	return RXINFO_DESC_SIZE + rx_pkt_len + RXD_DESC_SIZE;
> +}
> +
>  static void rt2800usb_fill_rxdone(struct queue_entry *entry,
>  				  struct rxdone_entry_desc *rxdesc)
>  {
> @@ -706,6 +727,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
>  	.clear_beacon		= rt2800_clear_beacon,
>  	.get_tx_data_len	= rt2800usb_get_tx_data_len,
>  	.fill_rxdone		= rt2800usb_fill_rxdone,
> +	.get_rx_seg_len		= rt2800usb_get_rx_seg_len,
>  	.config_shared_key	= rt2800_config_shared_key,
>  	.config_pairwise_key	= rt2800_config_pairwise_key,
>  	.config_filter		= rt2800_config_filter,
> @@ -725,8 +747,8 @@ static void rt2800usb_queue_init(struct data_queue *queue)
>  
>  	switch (queue->qid) {
>  	case QID_RX:
> -		queue->limit = 128;
> -		queue->data_size = AGGREGATION_SIZE;
> +		queue->limit = 16;
> +		queue->data_size = MAX_RXBULK_SIZE;

Since we enable aggregation conditionally, this probably should also be
conditional. But the issue is that we do not have 
rt2x00dev->rx->usb_maxpacket value available yet.

We could just enable aggregation unconditionally,
but I'm not sure it will work with some older chips like RT2870?

So perhaps better would be set a capability flag during probe for
chips that know to work with the aggregation and use it here and 
when configuring USB_DMA register? Or base on usb_maxpacket
but check it during probe?

Regards
Stanislaw


