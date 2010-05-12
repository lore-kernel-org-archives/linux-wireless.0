Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:9402 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab0ELHGs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 03:06:48 -0400
Received: by fg-out-1718.google.com with SMTP id d23so371001fga.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 00:06:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273614705-25118-7-git-send-email-gwingerde@gmail.com>
References: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
	 <1273614705-25118-7-git-send-email-gwingerde@gmail.com>
Date: Wed, 12 May 2010 09:06:46 +0200
Message-ID: <AANLkTilYgBGsowRMhANjzNzv7IngLb0NZQR5QqSMDYc5@mail.gmail.com>
Subject: Re: [PATCH 6/9] rt2x00: Push beacon TX descriptor writing to drivers.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 11, 2010 at 11:51 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> Not all the devices require a TX descriptor to be written (i.e. rt2800
> device don't require them). Push down the creation of the TX descriptor
> to the device drivers so that they can decide for themselves whether
> a TX descriptor is to be created.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2400pci.c   |   16 ++++++++++------
>  drivers/net/wireless/rt2x00/rt2500pci.c   |   16 ++++++++++------
>  drivers/net/wireless/rt2x00/rt2500usb.c   |   11 +++++++++++
>  drivers/net/wireless/rt2x00/rt2800pci.c   |   17 +++++++++++++++++
>  drivers/net/wireless/rt2x00/rt2800usb.c   |   17 +++++++++++++++++
>  drivers/net/wireless/rt2x00/rt2x00debug.c |    1 +
>  drivers/net/wireless/rt2x00/rt2x00queue.c |   10 +---------
>  drivers/net/wireless/rt2x00/rt61pci.c     |   11 +++++++++++
>  drivers/net/wireless/rt2x00/rt73usb.c     |   11 +++++++++++
>  9 files changed, 89 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
> index def3fa4..741c531 100644
> --- a/drivers/net/wireless/rt2x00/rt2400pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2400pci.c
> @@ -33,6 +33,7 @@
>  #include <linux/eeprom_93cx6.h>
>
>  #include "rt2x00.h"
> +#include "rt2x00lib.h"
>  #include "rt2x00pci.h"
>  #include "rt2400pci.h"

rt2x00lib.h must not be used in the drivers. It is for the rt2x00lib
internal files only.

> @@ -1074,9 +1075,6 @@ static void rt2400pci_write_beacon(struct queue_entry *entry,
>                                   struct txentry_desc *txdesc)
>  {
>        struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
> -       struct queue_entry_priv_pci *entry_priv = entry->priv_data;
> -       struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
> -       u32 word;
>        u32 reg;
>
>        /*
> @@ -1089,9 +1087,15 @@ static void rt2400pci_write_beacon(struct queue_entry *entry,
>
>        rt2x00queue_map_txskb(rt2x00dev, entry->skb);
>
> -       rt2x00_desc_read(entry_priv->desc, 1, &word);
> -       rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, skbdesc->skb_dma);
> -       rt2x00_desc_write(entry_priv->desc, 1, word);
> +       /*
> +        * Write the TX descriptor for the beacon.
> +        */
> +       rt2400pci_write_tx_desc(rt2x00dev, entry->skb, txdesc);
> +
> +       /*
> +        * Dump beacon to userspace through debugfs.
> +        */
> +       rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);

The goal for rt2x00debug was that the logic must be inside rt2x00lib
as much as possible.
This can/should be moved into rt2x00lib where write_beacon() is being called.

Ivo
