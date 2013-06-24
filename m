Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:57298 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3FXRbS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 13:31:18 -0400
References: <1371899605-30513-1-git-send-email-juhosg@openwrt.org>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1371899605-30513-1-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <BD31CA3E-8045-489B-86C8-CD9DC2244746@gmail.com> (sfid-20130624_193122_325212_CE9D1CC6)
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Gabor Juhos <juhosg@openwrt.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: read 5GHz TX power values from the correct offset
Date: Mon, 24 Jun 2013 19:31:13 +0200
To: Gabor Juhos <juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sent from my iPad

On 22 jun. 2013, at 13:13, Gabor Juhos <juhosg@openwrt.org> wrote:

> The current code uses the same index value both
> for the channel information array and for the TX
> power table. The index starts from 14, however the
> index of the TX power table must start from zero.
> 
> Fix it, in order to get the correct TX power value
> for a given channel.
> 
> The changes in rt61pci.c and rt73usb.c are compile
> tested only.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Cc: stable@vger.kernel.org

Acked-by: Gertjan van Wingerde

Good catch. This can certainly explain why people were seeing bad results on the 5 GHz band.

> ---
> John,
> 
> If there is any chance for that, this should go
> into 3.10. However the code is wrong since a few
> years and nobody noticed that so far, so it is
> not a big problem if it will be applied only in
> 3.11.
> 
> -Gabor
> ---
> drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
> drivers/net/wireless/rt2x00/rt61pci.c   |    3 ++-
> drivers/net/wireless/rt2x00/rt73usb.c   |    3 ++-
> 3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 3aa30dd..4072242 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -6254,8 +6254,8 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>        default_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A2);
> 
>        for (i = 14; i < spec->num_channels; i++) {
> -            info[i].default_power1 = default_power1[i];
> -            info[i].default_power2 = default_power2[i];
> +            info[i].default_power1 = default_power1[i - 14];
> +            info[i].default_power2 = default_power2[i - 14];
>        }
>    }
> 
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index 53754bc6..54d3ddf 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -2825,7 +2825,8 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>        tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
>        for (i = 14; i < spec->num_channels; i++) {
>            info[i].max_power = MAX_TXPOWER;
> -            info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
> +            info[i].default_power1 =
> +                    TXPOWER_FROM_DEV(tx_power[i - 14]);
>        }
>    }
> 
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
> index 1616ed4..1d3880e 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -2167,7 +2167,8 @@ static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>        tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
>        for (i = 14; i < spec->num_channels; i++) {
>            info[i].max_power = MAX_TXPOWER;
> -            info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
> +            info[i].default_power1 =
> +                    TXPOWER_FROM_DEV(tx_power[i - 14]);
>        }
>    }
> 
> -- 
> 1.7.10
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
