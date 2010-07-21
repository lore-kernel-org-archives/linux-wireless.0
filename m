Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48996 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458Ab0GUFIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 01:08:43 -0400
Received: by fxm14 with SMTP id 14so3258020fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jul 2010 22:08:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1279572443-14361-1-git-send-email-linville@tuxdriver.com>
References: <AANLkTiknLRzt2bdhcin5WRzwPXSWqEs8dIUe5imlN0I9@mail.gmail.com>
	<1279572443-14361-1-git-send-email-linville@tuxdriver.com>
Date: Wed, 21 Jul 2010 08:08:41 +0300
Message-ID: <AANLkTino_4FKtMWZU7_lKGzPUXNOtfrmlw_rmmr836eA@mail.gmail.com>
Subject: Re: [PATCH] rtl8180: improve signal reporting for rtl8185 hardware
From: Pauli Nieminen <suokkos@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 19, 2010 at 11:47 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> The existing code seemed to be somewhat based on the datasheet, but
> varied substantially from the vendor-provided driver.  This mirrors the
> handling of the rtl8185 case from that driver, but still neglects the
> specifics for the rtl8180 hardware.  Those details are a bit muddled...
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/rtl818x/rtl8180_dev.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
> index 4270502..90046dc 100644
> --- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
> @@ -103,6 +103,7 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
>  {
>        struct rtl8180_priv *priv = dev->priv;
>        unsigned int count = 32;
> +       u8 signal;
>
>        while (count--) {
>                struct rtl8180_rx_desc *entry = &priv->rx_ring[priv->rx_idx];
> @@ -130,10 +131,14 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
>                        skb_put(skb, flags & 0xFFF);
>
>                        rx_status.antenna = (flags2 >> 15) & 1;
> -                       /* TODO: improve signal/rssi reporting */
> -                       rx_status.signal = (flags2 >> 8) & 0x7F;
> -                       /* XXX: is this correct? */
>                        rx_status.rate_idx = (flags >> 20) & 0xF;
> +                       /* TODO: improve signal/rssi reporting for !rtl8185 */
> +                       signal = (flags2 >> 17) & 0x7F;
> +                       if (rx_status.rate_idx > 3)
> +                               signal = clamp_t(u8, signal, 25, 90);
> +                       else
> +                               signal = clamp_t(u8, signal, 30, 95);
> +                       rx_status.signal = signal;
>                        rx_status.freq = dev->conf.channel->center_freq;
>                        rx_status.band = dev->conf.channel->band;
>                        rx_status.mactime = le64_to_cpu(entry->tsft);
> --
> 1.7.1.1
>
>

I tested this version of patch. Patch didn't apply cleanly for some
reason even tough when I mnauly typed it diff looks same.

The patch lets me use wifi but signal value is not yet correct. When I
have  closed AP only 50 cm away from my laptop.

 sudo iwlist wlan0 scan | grep Signal
                    Quality=46/100  Signal level=46/100
                    Quality=46/100  Signal level=46/100
                    Quality=46/100  Signal level=46/100
                    Quality=46/100  Signal level=46/100
                    Quality=46/100  Signal level=46/100
                    Quality=46/100  Signal level=46/100
                    Quality=46/100  Signal level=46/100
                    Quality=46/100  Signal level=46/100
                    Quality=46/100  Signal level=46/100
                    Quality=46/100  Signal level=46/100
                    Quality=46/100  Signal level=46/100
                    Quality=46/100  Signal level=46/100
                    Quality=46/100  Signal level=46/100
                    Quality=46/100  Signal level=46/100
                    Quality=46/100  Signal level=46/100
                    Quality=46/100  Signal level=46/100
