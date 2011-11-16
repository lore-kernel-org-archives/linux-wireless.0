Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62913 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab1KPXHJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 18:07:09 -0500
Received: by bke11 with SMTP id 11so1222273bke.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 15:07:08 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Michael =?iso-8859-1?q?B=FCsch?= <m@bues.ch>
Subject: Re: [PATCH] p54spi: Add missing spin_lock_init
Date: Thu, 17 Nov 2011 00:07:02 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <20111116234831.08f1f703@milhouse>
In-Reply-To: <20111116234831.08f1f703@milhouse>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201111170007.02388.chunkeey@googlemail.com> (sfid-20111117_000713_971248_290E3F11)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, November 16, 2011 11:48:31 PM Michael Büsch wrote:
> The tx_lock is not initialized properly. Add spin_lock_init().
> 
> Signed-off-by: Michael Buesch <m@bues.ch>

Cc: <stable@kernel.org>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>

> ---
> 
> 
> Index: compat-wireless-2011-11-04/drivers/net/wireless/p54/p54spi.c
> ===================================================================
> --- compat-wireless-2011-11-04.orig/drivers/net/wireless/p54/p54spi.c	2011-11-05 20:30:04.000000000 +0100
> +++ compat-wireless-2011-11-04/drivers/net/wireless/p54/p54spi.c	2011-11-16 22:12:03.648829886 +0100
> @@ -656,6 +656,7 @@ static int __devinit p54spi_probe(struct
>  	init_completion(&priv->fw_comp);
>  	INIT_LIST_HEAD(&priv->tx_pending);
>  	mutex_init(&priv->mutex);
> +	spin_lock_init(&priv->tx_lock);
>  	SET_IEEE80211_DEV(hw, &spi->dev);
>  	priv->common.open = p54spi_op_start;
>  	priv->common.stop = p54spi_op_stop;
