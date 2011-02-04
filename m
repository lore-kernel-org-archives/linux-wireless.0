Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab1BDJ5x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 04:57:53 -0500
Date: Fri, 4 Feb 2011 10:57:35 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Wolfgang Kufner <wolfgang.kufner@gmail.com>
Subject: Re: Missing skb_pad() return value checks in rt2x00 driver
Message-ID: <20110204095734.GC2222@redhat.com>
References: <20110131214515.GC6368@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110131214515.GC6368@thinkpad-t410>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 31, 2011 at 03:45:16PM -0600, Seth Forshee wrote:
> Commit 739fd94 ("rt2x00: Pad beacon to multiple of 32 bits")
> added calls to skb_pad() without checking the return value,
> which could cause problems if any of those calls does happen
> to fail. Add checks to prevent this from happening and move
> the padding to the tops of the relevant functions so we can
> bail out before writing to any registers.

Make sense for me.

Ivo, Gertjan? 

> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>

>  drivers/net/wireless/rt2x00/rt2800lib.c |   13 +++++++++++--
>  drivers/net/wireless/rt2x00/rt61pci.c   |   13 +++++++++++--
>  drivers/net/wireless/rt2x00/rt73usb.c   |   13 +++++++++++--
>  3 files changed, 33 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index f8ba01c..79d17da 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -776,6 +776,17 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
>  	u32 reg;
>  
>  	/*
> +	 * Pad out the beacon to a 32-bit boundary
> +	 */
> +	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
> +	if (padding_len && skb_pad(entry->skb, padding_len)) {
> +		dev_err(rt2x00dev->dev, "Failure padding beacon, aborting\n");
> +		/* skb freed by skb_pad() on failure */
> +		entry->skb = NULL;
> +		return;
> +	}
> +
> +	/*
>  	 * Disable beaconing while we are reloading the beacon data,
>  	 * otherwise we might be sending out invalid data.
>  	 */
> @@ -809,8 +820,6 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
>  	/*
>  	 * Write entire beacon with TXWI and padding to register.
>  	 */
> -	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
> -	skb_pad(entry->skb, padding_len);
>  	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
>  	rt2800_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
>  				   entry->skb->len + padding_len);
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index 8de44dd..83ac31e 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -1965,6 +1965,17 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
>  	u32 reg;
>  
>  	/*
> +	 * Pad out the beacon to a 32-bit boundary
> +	 */
> +	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
> +	if (padding_len && skb_pad(entry->skb, padding_len)) {
> +		dev_err(rt2x00dev->dev, "Failure padding beacon, aborting\n");
> +		/* skb freed by skb_pad() on failure */
> +		entry->skb = NULL;
> +		return;
> +	}
> +
> +	/*
>  	 * Disable beaconing while we are reloading the beacon data,
>  	 * otherwise we might be sending out invalid data.
>  	 */
> @@ -1985,8 +1996,6 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
>  	/*
>  	 * Write entire beacon with descriptor and padding to register.
>  	 */
> -	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
> -	skb_pad(entry->skb, padding_len);
>  	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
>  	rt2x00pci_register_multiwrite(rt2x00dev, beacon_base,
>  				      entry_priv->desc, TXINFO_SIZE);
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
> index 029be3c..5b15609 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -1550,6 +1550,17 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
>  	u32 reg;
>  
>  	/*
> +	 * Pad out the beacon to a 32-bit boundary
> +	 */
> +	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
> +	if (padding_len && skb_pad(entry->skb, padding_len)) {
> +		dev_err(rt2x00dev->dev, "Failure padding beacon, aborting\n");
> +		/* skb freed by skb_pad() on failure */
> +		entry->skb = NULL;
> +		return;
> +	}
> +
> +	/*
>  	 * Disable beaconing while we are reloading the beacon data,
>  	 * otherwise we might be sending out invalid data.
>  	 */
> @@ -1576,8 +1587,6 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
>  	/*
>  	 * Write entire beacon with descriptor and padding to register.
>  	 */
> -	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
> -	skb_pad(entry->skb, padding_len);
>  	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
>  	rt2x00usb_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
>  				      entry->skb->len + padding_len);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
