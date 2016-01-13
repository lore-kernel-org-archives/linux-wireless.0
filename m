Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f193.google.com ([209.85.213.193]:36863 "EHLO
	mail-ig0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbcAMPtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 10:49:49 -0500
Received: by mail-ig0-f193.google.com with SMTP id o2so18024768iga.3
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jan 2016 07:49:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1452697201-11206-2-git-send-email-elicooper@gmx.com>
References: <1452697201-11206-1-git-send-email-elicooper@gmx.com>
	<1452697201-11206-2-git-send-email-elicooper@gmx.com>
Date: Wed, 13 Jan 2016 16:49:48 +0100
Message-ID: <CAGXE3d_yFQzaZ4O4Ze5T=9-Vrx2QZAU+7go5K0_uUq=wudxivA@mail.gmail.com> (sfid-20160113_164953_023318_0CB274B9)
Subject: Re: [PATCH 1/1] rt2x00: fix monitor mode regression
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Eli Cooper <elicooper@gmx.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, eli.cooper@gmx.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 13, 2016 at 4:00 PM, Eli Cooper <elicooper@gmx.com> wrote:
> ---

Good catch.

Please add your Signed-off-by tag for PATCH submissions as described in
https://www.kernel.org/doc/Documentation/SubmittingPatches

Also please move the commit message into the actual patch instead of the
"cover-letter" for a single-patch series.

Otherwise looks good to me.

Thanks,
Helmut

>  drivers/net/wireless/ralink/rt2x00/rt2400pci.c    |  4 +++-
>  drivers/net/wireless/ralink/rt2x00/rt2500pci.c    |  4 +++-
>  drivers/net/wireless/ralink/rt2x00/rt2500usb.c    |  4 +++-
>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c    |  3 ++-
>  drivers/net/wireless/ralink/rt2x00/rt2x00.h       |  2 ++
>  drivers/net/wireless/ralink/rt2x00/rt2x00config.c | 10 ++++++++++
>  drivers/net/wireless/ralink/rt2x00/rt2x00dev.c    |  1 +
>  drivers/net/wireless/ralink/rt2x00/rt2x00mac.c    |  5 -----
>  drivers/net/wireless/ralink/rt2x00/rt61pci.c      |  4 +++-
>  drivers/net/wireless/ralink/rt2x00/rt73usb.c      |  4 +++-
>  10 files changed, 30 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
> index 9a3966c..578b8a4 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
> @@ -273,8 +273,10 @@ static void rt2400pci_config_filter(struct rt2x00_dev *rt2x00dev,
>                            !(filter_flags & FIF_PLCPFAIL));
>         rt2x00_set_field32(&reg, RXCSR0_DROP_CONTROL,
>                            !(filter_flags & FIF_CONTROL));
> -       rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME, 1);
> +       rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME,
> +                          !rt2x00dev->is_monitoring);
>         rt2x00_set_field32(&reg, RXCSR0_DROP_TODS,
> +                          !rt2x00dev->is_monitoring &&
>                            !rt2x00dev->intf_ap_count);
>         rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 1);
>         rt2x00mmio_register_write(rt2x00dev, RXCSR0, reg);
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
> index 1a6740b..9aec12e 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
> @@ -274,8 +274,10 @@ static void rt2500pci_config_filter(struct rt2x00_dev *rt2x00dev,
>                            !(filter_flags & FIF_PLCPFAIL));
>         rt2x00_set_field32(&reg, RXCSR0_DROP_CONTROL,
>                            !(filter_flags & FIF_CONTROL));
> -       rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME, 1);
> +       rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME,
> +                          !rt2x00dev->is_monitoring);
>         rt2x00_set_field32(&reg, RXCSR0_DROP_TODS,
> +                          !rt2x00dev->is_monitoring &&
>                            !rt2x00dev->intf_ap_count);
>         rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 1);
>         rt2x00_set_field32(&reg, RXCSR0_DROP_MCAST,
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> index d26018f..d66364e 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> @@ -437,8 +437,10 @@ static void rt2500usb_config_filter(struct rt2x00_dev *rt2x00dev,
>                            !(filter_flags & FIF_PLCPFAIL));
>         rt2x00_set_field16(&reg, TXRX_CSR2_DROP_CONTROL,
>                            !(filter_flags & FIF_CONTROL));
> -       rt2x00_set_field16(&reg, TXRX_CSR2_DROP_NOT_TO_ME, 1);
> +       rt2x00_set_field16(&reg, TXRX_CSR2_DROP_NOT_TO_ME,
> +                          !rt2x00dev->is_monitoring);
>         rt2x00_set_field16(&reg, TXRX_CSR2_DROP_TODS,
> +                          !rt2x00dev->is_monitoring &&
>                            !rt2x00dev->intf_ap_count);
>         rt2x00_set_field16(&reg, TXRX_CSR2_DROP_VERSION_ERROR, 1);
>         rt2x00_set_field16(&reg, TXRX_CSR2_DROP_MULTICAST,
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index 9733b31..ee8215a 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -1490,7 +1490,8 @@ void rt2800_config_filter(struct rt2x00_dev *rt2x00dev,
>                            !(filter_flags & FIF_FCSFAIL));
>         rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_PHY_ERROR,
>                            !(filter_flags & FIF_PLCPFAIL));
> -       rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_NOT_TO_ME, 1);
> +       rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_NOT_TO_ME,
> +                          !rt2x00dev->is_monitoring);
>         rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_NOT_MY_BSSD, 0);
>         rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_VER_ERROR, 1);
>         rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_MULTICAST,
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> index 3282ddb..a2e70ec 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> @@ -844,11 +844,13 @@ struct rt2x00_dev {
>          *  - Open sta interface count.
>          *  - Association count.
>          *  - Beaconing enabled count.
> +        *  - Whether the device is monitoring.
>          */
>         unsigned int intf_ap_count;
>         unsigned int intf_sta_count;
>         unsigned int intf_associated;
>         unsigned int intf_beaconing;
> +       bool is_monitoring;
>
>         /*
>          * Interface combinations
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00config.c b/drivers/net/wireless/ralink/rt2x00/rt2x00config.c
> index 7e8bb11..3b531f0 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00config.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00config.c
> @@ -244,6 +244,16 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
>             (ieee80211_flags & IEEE80211_CONF_CHANGE_PS))
>                 cancel_delayed_work_sync(&rt2x00dev->autowakeup_work);
>
> +       if (ieee80211_flags & IEEE80211_CONF_CHANGE_MONITOR) {
> +               if (conf->flags & IEEE80211_CONF_MONITOR) {
> +                       rt2x00_dbg(rt2x00dev, "Monitor mode is enabled\n");
> +                       rt2x00dev->is_monitoring = true;
> +               } else {
> +                       rt2x00_dbg(rt2x00dev, "Monitor mode is disabled\n");
> +                       rt2x00dev->is_monitoring = false;
> +               }
> +       }
> +
>
>         /*
>          * Start configuration.
>          */
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> index 5639ed8..e979dca 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> @@ -1204,6 +1204,7 @@ int rt2x00lib_start(struct rt2x00_dev *rt2x00dev)
>         rt2x00dev->intf_ap_count = 0;
>         rt2x00dev->intf_sta_count = 0;
>         rt2x00dev->intf_associated = 0;
> +       rt2x00dev->is_monitoring = false;
>
>         /* Enable the radio */
>         retval = rt2x00lib_enable_radio(rt2x00dev);
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
> index 3c26ee6..13da95a 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
> @@ -385,11 +385,6 @@ void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
>                         *total_flags |= FIF_PSPOLL;
>         }
>
> -       /*
> -        * Check if there is any work left for us.
> -        */
> -       if (rt2x00dev->packet_filter == *total_flags)
> -               return;
>         rt2x00dev->packet_filter = *total_flags;
>
>         rt2x00dev->ops->lib->config_filter(rt2x00dev, *total_flags);
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
> index c0e730e..b875a0f 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
> @@ -530,8 +530,10 @@ static void rt61pci_config_filter(struct rt2x00_dev *rt2x00dev,
>                            !(filter_flags & FIF_PLCPFAIL));
>         rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL,
>                            !(filter_flags & (FIF_CONTROL | FIF_PSPOLL)));
> -       rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME, 1);
> +       rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME,
> +                          !rt2x00dev->is_monitoring);
>         rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS,
> +                          !rt2x00dev->is_monitoring &&
>                            !rt2x00dev->intf_ap_count);
>         rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 1);
>         rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST,
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt73usb.c b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
> index 7081e13..6e8e620 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
> @@ -480,8 +480,10 @@ static void rt73usb_config_filter(struct rt2x00_dev *rt2x00dev,
>                            !(filter_flags & FIF_PLCPFAIL));
>         rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL,
>                            !(filter_flags & (FIF_CONTROL | FIF_PSPOLL)));
> -       rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME, 1);
> +       rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME,
> +                          !rt2x00dev->is_monitoring);
>         rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS,
> +                          !rt2x00dev->is_monitoring &&
>                            !rt2x00dev->intf_ap_count);
>         rt2x00_set_field32(&reg, TXRX_CSR0_DROP_VERSION_ERROR, 1);
>         rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST,
> --
> 2.7.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
