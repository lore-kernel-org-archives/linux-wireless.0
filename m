Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60308 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab2K1KIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 05:08:16 -0500
Received: by mail-vc0-f174.google.com with SMTP id m18so9961310vcm.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 02:08:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354094932-15703-1-git-send-email-helmut.schaa@googlemail.com>
References: <1354031236-8191-1-git-send-email-helmut.schaa@googlemail.com>
	<1354094932-15703-1-git-send-email-helmut.schaa@googlemail.com>
Date: Wed, 28 Nov 2012 11:08:15 +0100
Message-ID: <CAOZOX0W6PbrsbvsYWaTS7XP3=c4DTYLR2c8ODFr0ndKuTx9P-A@mail.gmail.com> (sfid-20121128_110820_059963_2681D20B)
Subject: Re: [PATCHv2] rt2x00: Use addr_mask to disallow invalid MAC addresses
 in mutli-bssid mode
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Reported-by: Petr Stetiar <ynezz@true.cz>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 69097d1..f9d9754 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1182,6 +1182,13 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
>         rt2x00dev->hw->vif_data_size = sizeof(struct rt2x00_intf);
>
>         /*
> +        * rt2x00 devices can only use the last n bits of the MAC address
> +        * for virtual interfaces.
> +        */
> +       rt2x00dev->hw->wiphy->addr_mask[ETH_ALEN - 1] =
> +               (rt2x00dev->ops->max_ap_intf - 1);
> +
> +       /*
>          * Determine which operating modes are supported, all modes
>          * which require beaconing, depend on the availability of
>          * beacon entries.
> --
> 1.7.7
>
