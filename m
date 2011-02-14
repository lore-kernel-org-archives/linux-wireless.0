Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38731 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab1BNQim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 11:38:42 -0500
Received: by qyk12 with SMTP id 12so4016024qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 08:38:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110214153948.GB3747@thinkpad-t410>
References: <20110131214515.GC6368@thinkpad-t410>
	<AANLkTikYS1EUdTc9mo2kvoR-S1Cv+WcKqkGaFDA8fR+0@mail.gmail.com>
	<AANLkTi=mRO99U5t3Z_gscuwix0X+brFhWtC=9nkytE+M@mail.gmail.com>
	<20110207041007.GA14242@thinkpad-t410>
	<20110207195301.GB2430@thinkpad-t410>
	<AANLkTikYJXzkjQKJbjpdS8m3XVjj+SpO8rjE6qhF4WY1@mail.gmail.com>
	<20110214153948.GB3747@thinkpad-t410>
Date: Mon, 14 Feb 2011 17:38:39 +0100
Message-ID: <AANLkTi=PSP3=XVqODGme355v8KmcT8bAOiKeoR7hYaHd@mail.gmail.com>
Subject: Re: Missing skb_pad() return value checks in rt2x00 driver
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Wolfgang Kufner <wolfgang.kufner@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> From 0de24c34fc6f59d1d557a3cb16adcc32414d4c46 Mon Sep 17 00:00:00 2001
> From: Seth Forshee <seth.forshee@canonical.com>
> Date: Mon, 14 Feb 2011 08:52:25 -0600
> Subject: [PATCH] rt2x00: Check for errors from skb_pad() calls
>
> Commit 739fd94 ("rt2x00: Pad beacon to multiple of 32 bits")
> added calls to skb_pad() without checking the return value,
> which could cause problems if any of those calls does happen
> to fail. Add checks to prevent this from happening.
>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |   12 ++++++++++--
>  drivers/net/wireless/rt2x00/rt61pci.c   |   12 ++++++++++--
>  drivers/net/wireless/rt2x00/rt73usb.c   |   12 ++++++++++--
>  3 files changed, 30 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index c9bf074..7a68a67 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -773,13 +773,14 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
>        struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
>        unsigned int beacon_base;
>        unsigned int padding_len;
> -       u32 reg;
> +       u32 orig_reg, reg;
>
>        /*
>         * Disable beaconing while we are reloading the beacon data,
>         * otherwise we might be sending out invalid data.
>         */
>        rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
> +       orig_reg = reg;
>        rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
>        rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
>
> @@ -810,7 +811,14 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
>         * Write entire beacon with TXWI and padding to register.
>         */
>        padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
> -       skb_pad(entry->skb, padding_len);
> +       if (padding_len && skb_pad(entry->skb, padding_len)) {
> +               ERROR(rt2x00dev, "Failure padding beacon, aborting\n");
> +               /* skb freed by skb_pad() on failure */
> +               entry->skb = NULL;
> +               rt2800_register_write(rt2x00dev, BCN_TIME_CFG, orig_reg);
> +               return;
> +       }
> +
>        beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
>        rt2800_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
>                                   entry->skb->len + padding_len);
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index dd2164d..927a4a3 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -1978,13 +1978,14 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
>        struct queue_entry_priv_pci *entry_priv = entry->priv_data;
>        unsigned int beacon_base;
>        unsigned int padding_len;
> -       u32 reg;
> +       u32 orig_reg, reg;
>
>        /*
>         * Disable beaconing while we are reloading the beacon data,
>         * otherwise we might be sending out invalid data.
>         */
>        rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
> +       orig_reg = reg;
>        rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
>        rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
>
> @@ -2002,7 +2003,14 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
>         * Write entire beacon with descriptor and padding to register.
>         */
>        padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
> -       skb_pad(entry->skb, padding_len);
> +       if (padding_len && skb_pad(entry->skb, padding_len)) {
> +               ERROR(rt2x00dev, "Failure padding beacon, aborting\n");
> +               /* skb freed by skb_pad() on failure */
> +               entry->skb = NULL;
> +               rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, orig_reg);
> +               return;
> +       }
> +
>        beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
>        rt2x00pci_register_multiwrite(rt2x00dev, beacon_base,
>                                      entry_priv->desc, TXINFO_SIZE);
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
> index 5ff72de..6e9981a 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -1533,13 +1533,14 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
>        struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
>        unsigned int beacon_base;
>        unsigned int padding_len;
> -       u32 reg;
> +       u32 orig_reg, reg;
>
>        /*
>         * Disable beaconing while we are reloading the beacon data,
>         * otherwise we might be sending out invalid data.
>         */
>        rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
> +       orig_reg = reg;
>        rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
>        rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
>
> @@ -1563,7 +1564,14 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
>         * Write entire beacon with descriptor and padding to register.
>         */
>        padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
> -       skb_pad(entry->skb, padding_len);
> +       if (padding_len && skb_pad(entry->skb, padding_len)) {
> +               ERROR(rt2x00dev, "Failure padding beacon, aborting\n");
> +               /* skb freed by skb_pad() on failure */
> +               entry->skb = NULL;
> +               rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, orig_reg);
> +               return;
> +       }
> +
>        beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
>        rt2x00usb_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
>                                      entry->skb->len + padding_len);
> --
> 1.7.1
>
>
