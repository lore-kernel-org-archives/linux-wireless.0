Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39214 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733234AbeHAJQg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 05:16:36 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v3 12/14] mt76: Kconfig and Makefile for mt76x0 driver
References: <1533040864-9026-1-git-send-email-sgruszka@redhat.com>
        <1533040864-9026-13-git-send-email-sgruszka@redhat.com>
Date: Wed, 01 Aug 2018 10:32:12 +0300
In-Reply-To: <1533040864-9026-13-git-send-email-sgruszka@redhat.com>
        (Stanislaw Gruszka's message of "Tue, 31 Jul 2018 14:41:02 +0200")
Message-ID: <8736vy1r0j.fsf@purkki.adurom.net> (sfid-20180801_093456_014756_ACF0DFDB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> Add Kconfig and Makefiles for mt76x0 driver. Now the driver
> can be build.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/Kconfig         | 7 +++++++
>  drivers/net/wireless/mediatek/mt76/Makefile        | 1 +
>  drivers/net/wireless/mediatek/mt76/mt76x0/Makefile | 7 +++++++
>  3 files changed, 15 insertions(+)
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
>
> diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
> index 69906c733a1c..850611ad347a 100644
> --- a/drivers/net/wireless/mediatek/mt76/Kconfig
> +++ b/drivers/net/wireless/mediatek/mt76/Kconfig
> @@ -9,6 +9,13 @@ config MT76x2_COMMON
>  	tristate
>  	depends on MT76_CORE
>  
> +config MT76x0U
> +	tristate "MediaTek MT76x0U (USB) support"
> +	depends on MAC80211
> +	depends on USB
> +	help
> +	  This adds support for MT7610U-based wireless USB dongles.

Does it make sense to add a Kconfig option for every mt76 device? I'm
worried that soon we have over a dozen of them. I can understand having
separate options to enable PCI or USB devices, but I don't see the
benefit for anything more finegrained than that.

-- 
Kalle Valo
