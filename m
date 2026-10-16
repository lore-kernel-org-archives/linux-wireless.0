Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6531419A4
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 12:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792153397; cv=none; b=fxsto17EeruUlgJ2Yyo4voh1ljlM9Oy4p7EOCyk/AL9erNQQopjpXFpMSaCLRIsozmTzFsrA8eyWdwDeTgRjz8HULXPlWdCWa9WI9G2owk9iRBghXUa6CpbEMU/yJJTJKColhsnKU/VkJQh7myXB/C9VLCMra5okjcCzFtngrkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792153397; c=relaxed/simple;
	bh=ltBDINOqkCYKfRNOKYp32QAr/6wBJHOQJSo9PQDklg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=knAk569uCM57vSKr7adDotfeZtGB8HagWSPbnrW9f1RNAelSA/ObJaGX74ouzl99cG8GAAQeRBn1wkU7YfgZQ4oa/bxAV+GqEFNxW9D1y/PI32uHOAU9HLeDdQDKQ+eQBnMIIMrY4LBSXiF3kTr7txZWHjKWIPj95Y0sYecS0/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=nnfNJX/s; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="nnfNJX/s"
Received: (wp-smtpd smtp.wp.pl 25324 invoked from network); 16 Oct 2026 14:23:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1792153386; bh=4bTkFT+F2hA2/znsJfPcE/M31DKOZlPTYzijVZ/YGCU=;
          h=From:To:Cc:Subject;
          b=nnfNJX/s03ZUdYA8IXtb8ij8HDNRK+1vVn/Aeeb0GaPi6APxoYbc/alR9XIraG1MK
           H+P5CzatMv5QyV3nPuRUYVT6NI8ZFYeGAJFlrFSpJyXmdaPq/hlSlY0liuGki//wNq
           dgXLYyx7YzScXL9pkVlG80YBb2VzlZttt4gKCWyDUYzFFvD9Ze2YyPJTW7uLqSL3J8
           Zo/9I2SAr+xsVNSzatt9UIqVyKhMoBMQXmlrY1mC9nikUWzYSZ9MGVEFIKvAcEn1E5
           JANp5+QnT7NPaVmZUr3QvnNGUgfnrb+IPWI4DfpYgeVd/RNxam819G+OlAD8n33CKM
           eKXRRarwjX3Kg==
Received: from localhost (77-236-6-58.static.play.pl [77.236.6.58])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <edumazet@kernel.org>; 16 Oct 2026 14:23:06 +0200
Date: Fri, 16 Oct 2026 14:23:06 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Eric Dumazet <edumazet@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH -next] wifi: rt2x00: use skb_put_padto() for beacon
 padding
Message-ID: <20261016122306.GA71823@wp.pl>
References: <20261016101602.2770015-1-edumazet@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016101602.2770015-1-edumazet@kernel.org>
X-WP-MailID: 1145b0cbfd87b40f0092c40874a853ec
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [8YPB]                               

On Fri, Oct 16, 2026 at 12:16:02PM +0200, Eric Dumazet wrote:
> rt2800_write_beacon(), rt61pci_write_beacon() and rt73usb_write_beacon()
> pad the beacon with skb_pad(), which does not change skb->len, and
> then have to add the padding length again when writing the beacon
> to the hardware.
> 
> Use skb_put_padto() instead, and remove the padding_len variables.
> 
> No functional change: the beacon skb is freed right after
> being written to the hardware.
> 
> Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

> ---
> Part of a medium term plan to get rid of skb_pad(), source of many mistakes.
> 
>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 8 +++-----
>  drivers/net/wireless/ralink/rt2x00/rt61pci.c   | 9 +++------
>  drivers/net/wireless/ralink/rt2x00/rt73usb.c   | 8 +++-----
>  3 files changed, 9 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index 2e2e382b624757ffcd826f37faebc36f38d04f11..4f7beca668bb032ef469e19e8919afd6316fe3eb 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -1414,7 +1414,6 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
>  	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
>  	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
>  	unsigned int beacon_base;
> -	unsigned int padding_len;
>  	u32 orig_reg, reg;
>  	const int txwi_desc_size = entry->queue->winfo_size;
>  
> @@ -1452,10 +1451,9 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
>  	/*
>  	 * Write entire beacon with TXWI and padding to register.
>  	 */
> -	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
> -	if (padding_len && skb_pad(entry->skb, padding_len)) {
> +	if (skb_put_padto(entry->skb, roundup(entry->skb->len, 4))) {
>  		rt2x00_err(rt2x00dev, "Failure padding beacon, aborting\n");
> -		/* skb freed by skb_pad() on failure */
> +		/* skb freed by skb_put_padto() on failure */
>  		entry->skb = NULL;
>  		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, orig_reg);
>  		return;
> @@ -1464,7 +1462,7 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
>  	beacon_base = rt2800_hw_beacon_base(rt2x00dev, entry->entry_idx);
>  
>  	rt2800_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
> -				   entry->skb->len + padding_len);
> +				   entry->skb->len);
>  	__set_bit(ENTRY_BCN_ENABLED, &entry->flags);
>  
>  	/*
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
> index d4783658b2c5dbb69ab6c715a23ac8814ef3afb0..974a6d85b37b600f9cac22055c7a0fe0e17e2d5f 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
> @@ -1875,7 +1875,6 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
>  	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
>  	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
>  	unsigned int beacon_base;
> -	unsigned int padding_len;
>  	u32 orig_reg, reg;
>  
>  	/*
> @@ -1900,10 +1899,9 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
>  	/*
>  	 * Write entire beacon with descriptor and padding to register.
>  	 */
> -	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
> -	if (padding_len && skb_pad(entry->skb, padding_len)) {
> +	if (skb_put_padto(entry->skb, roundup(entry->skb->len, 4))) {
>  		rt2x00_err(rt2x00dev, "Failure padding beacon, aborting\n");
> -		/* skb freed by skb_pad() on failure */
> +		/* skb freed by skb_put_padto() on failure */
>  		entry->skb = NULL;
>  		rt2x00mmio_register_write(rt2x00dev, TXRX_CSR9, orig_reg);
>  		return;
> @@ -1913,8 +1911,7 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
>  	rt2x00mmio_register_multiwrite(rt2x00dev, beacon_base,
>  				       entry_priv->desc, TXINFO_SIZE);
>  	rt2x00mmio_register_multiwrite(rt2x00dev, beacon_base + TXINFO_SIZE,
> -				       entry->skb->data,
> -				       entry->skb->len + padding_len);
> +				       entry->skb->data, entry->skb->len);
>  
>  	/*
>  	 * Enable beaconing again.
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt73usb.c b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
> index d6b7174d087a26c7a403b8b743d59f9fb5f9fb62..ee308bcf0bed00edea24278deb1770f035012998 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
> @@ -1523,7 +1523,6 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
>  {
>  	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
>  	unsigned int beacon_base;
> -	unsigned int padding_len;
>  	u32 orig_reg, reg;
>  
>  	/*
> @@ -1554,10 +1553,9 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
>  	/*
>  	 * Write entire beacon with descriptor and padding to register.
>  	 */
> -	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
> -	if (padding_len && skb_pad(entry->skb, padding_len)) {
> +	if (skb_put_padto(entry->skb, roundup(entry->skb->len, 4))) {
>  		rt2x00_err(rt2x00dev, "Failure padding beacon, aborting\n");
> -		/* skb freed by skb_pad() on failure */
> +		/* skb freed by skb_put_padto() on failure */
>  		entry->skb = NULL;
>  		rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, orig_reg);
>  		return;
> @@ -1565,7 +1563,7 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
>  
>  	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
>  	rt2x00usb_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
> -				      entry->skb->len + padding_len);
> +				      entry->skb->len);
>  
>  	/*
>  	 * Enable beaconing again.
> -- 
> 2.53.0
> 
