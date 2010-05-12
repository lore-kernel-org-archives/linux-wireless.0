Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54008 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab0ELG7I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 02:59:08 -0400
Received: by fxm4 with SMTP id 4so223290fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 23:59:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273614705-25118-3-git-send-email-gwingerde@gmail.com>
References: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
	 <1273614705-25118-3-git-send-email-gwingerde@gmail.com>
Date: Wed, 12 May 2010 08:59:07 +0200
Message-ID: <AANLkTikOV973PKZYkNyUoaFOXhSPOumhmHwQ7Ei8tvgv@mail.gmail.com>
Subject: Re: [PATCH 2/9] rt2x00: Fix beacon descriptor writing for rt61pci.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 11, 2010 at 11:51 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> The buffer address descriptor word is not part of the TXINFO structure
> needed for beacons. The current writing of that word for beacons is
> therefore an out-of-bounds write.
> Fix this by only writing the buffer address descriptor word for TX
> queues.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt61pci.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index 2436363..99c2981 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -1801,12 +1801,12 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
>        rt2x00_set_field32(&word, TXD_W5_WAITING_DMA_DONE_INT, 1);
>        rt2x00_desc_write(txd, 5, word);
>
> -       rt2x00_desc_read(txd, 6, &word);
> -       rt2x00_set_field32(&word, TXD_W6_BUFFER_PHYSICAL_ADDRESS,
> -                          skbdesc->skb_dma);
> -       rt2x00_desc_write(txd, 6, word);
> +       if (txdesc->queue != QID_BEACON) {
> +               rt2x00_desc_read(txd, 6, &word);
> +               rt2x00_set_field32(&word, TXD_W6_BUFFER_PHYSICAL_ADDRESS,
> +                                  skbdesc->skb_dma);
> +               rt2x00_desc_write(txd, 6, word);
>
> -       if (skbdesc->desc_len > TXINFO_SIZE) {
>                rt2x00_desc_read(txd, 11, &word);
>                rt2x00_set_field32(&word, TXD_W11_BUFFER_LENGTH0,
>                                   txdesc->length);

Shouldn't the check for TXINFO_SIZE be used rather than explicitly
checking for the QID?

Ivo
