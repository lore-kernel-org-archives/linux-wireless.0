Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f172.google.com ([209.85.212.172]:61565 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbZHLRNl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 13:13:41 -0400
Received: by vws2 with SMTP id 2so150573vws.4
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 10:13:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250096221-11000-4-git-send-email-lrodriguez@atheros.com>
References: <1250096221-11000-1-git-send-email-lrodriguez@atheros.com>
	 <1250096221-11000-4-git-send-email-lrodriguez@atheros.com>
Date: Wed, 12 Aug 2009 13:13:41 -0400
Message-ID: <b6c5339f0908121013v4316cfdbsf4e274217555dbe9@mail.gmail.com>
Subject: Re: [PATCH 3/3] ath5k: use bit shift operators for cache line size
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 12, 2009 at 12:57 PM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
> This matches ath9k, providing consistency when reading both drivers.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 63c2b57..2b3cf39 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -471,7 +471,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
>                 * DMA to work so force a reasonable value here if it
>                 * comes up zero.
>                 */
> -               csz = L1_CACHE_BYTES / sizeof(u32);
> +               csz = L1_CACHE_BYTES >> 2;
>                pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, csz);

I'm not sure it's better, although the whole thing seems bogus to
me.  Is there really a modern machine where PCI cache line size should
only be four bytes?

-- 
Bob Copeland %% www.bobcopeland.com
