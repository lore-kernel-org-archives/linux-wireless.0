Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33414 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750932AbeETKsA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 May 2018 06:48:00 -0400
Subject: Re: [RFC v2 17/18] mt76: add usb support to mt76 layer
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
References: <20180520081522.10163-18-lorenzo.bianconi@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <89bfbabd-d4a3-07d0-d0af-7fc86c9ac406@nbd.name> (sfid-20180520_124804_387515_C7B6CFF7)
Date: Sun, 20 May 2018 12:47:58 +0200
MIME-Version: 1.0
In-Reply-To: <20180520081522.10163-18-lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-20 10:15, Lorenzo Bianconi wrote:
> This will be used by drivers for MT76x2u based devices
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/Makefile |   3 +-
>  drivers/net/wireless/mediatek/mt76/dma.h    |   5 +
>  drivers/net/wireless/mediatek/mt76/mt76.h   | 115 +++++-
>  drivers/net/wireless/mediatek/mt76/usb.c    | 610 ++++++++++++++++++++++++++++
>  4 files changed, 731 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/net/wireless/mediatek/mt76/usb.c
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
> index e1bc229e4aad..4f7f6021d79c 100644
> --- a/drivers/net/wireless/mediatek/mt76/Makefile
> +++ b/drivers/net/wireless/mediatek/mt76/Makefile
> @@ -3,7 +3,8 @@ obj-$(CONFIG_MT76x2_COMMON) += mt76x2-common.o
>  obj-$(CONFIG_MT76x2E) += mt76x2e.o
>  
>  mt76-y := \
> -	mmio.o util.o trace.o dma.o mac80211.o debugfs.o eeprom.o tx.o agg-rx.o
> +	mmio.o util.o trace.o dma.o mac80211.o debugfs.o eeprom.o \
> +	tx.o agg-rx.o usb.o
Please don't make the mt76 core module depend on USB.

- Felix
