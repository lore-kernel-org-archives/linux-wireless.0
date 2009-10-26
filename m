Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:42509 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbZJZQOf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 12:14:35 -0400
Received: by ewy4 with SMTP id 4so3753845ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 09:14:39 -0700 (PDT)
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH 2/4] ath9k_hw: distinguish single-chip solutions on initial probe print
References: <1256567941-26859-1-git-send-email-lrodriguez@atheros.com>
	<1256567941-26859-3-git-send-email-lrodriguez@atheros.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 26 Oct 2009 18:14:37 +0200
In-Reply-To: <1256567941-26859-3-git-send-email-lrodriguez@atheros.com> (Luis R. Rodriguez's message of "Mon\, 26 Oct 2009 10\:38\:59 -0400")
Message-ID: <87hbtmgmj6.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <lrodriguez@atheros.com> writes:

> Devices with external radios have revisions which we can count on.
> On single chip solutions these EEPROM values for these radio revision
> also exist but are not meaningful as the radios are embedded onto the
> same chip. Each single-chip device evolves together as one device.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/ahb.c |   11 ++++-------
>  drivers/net/wireless/ath/ath9k/hw.c  |   27 +++++++++++++++++++++++----
>  drivers/net/wireless/ath/ath9k/hw.h  |    3 +--
>  drivers/net/wireless/ath/ath9k/pci.c |   11 ++++-------
>  4 files changed, 32 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
> index 41422c4..925818c 100644
> --- a/drivers/net/wireless/ath/ath9k/ahb.c
> +++ b/drivers/net/wireless/ath/ath9k/ahb.c
> @@ -69,6 +69,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
>  	int irq;
>  	int ret = 0;
>  	struct ath_hw *ah;
> +	char hw_name[1024];

This is a bit too large to allocate from stack IMHO.


[...]

> --- a/drivers/net/wireless/ath/ath9k/pci.c
> +++ b/drivers/net/wireless/ath/ath9k/pci.c
> @@ -114,6 +114,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	u32 val;
>  	int ret = 0;
>  	struct ath_hw *ah;
> +	char hw_name[1024];

Ditto.

-- 
Kalle Valo
