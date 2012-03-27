Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:3269 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755208Ab2C0SLJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 14:11:09 -0400
Message-ID: <4F7202BB.4000904@gmail.com> (sfid-20120327_201114_150091_6857A399)
Date: Tue, 27 Mar 2012 20:11:07 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Jakub Kicinski <kubakici@wp.pl>,
	Stanislaw Gruszka <sgruszka@redhat.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 2/4] rt2x00: move disabling of DMA before loading firmware
References: <1332859867-27921-1-git-send-email-kubakici@wp.pl> <1332859867-27921-3-git-send-email-kubakici@wp.pl>
In-Reply-To: <1332859867-27921-3-git-send-email-kubakici@wp.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jakub,

On 03/27/12 16:51, Jakub Kicinski wrote:
> Legacy driver disables DMA before not after loading firmware.
> 
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
> ---
> 2011_0406_RT5390_RT5392_Linux_STA_V2.5.0.3_DPO
> rtmp_init_inf.c:186
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |   17 ++++++++---------
>  1 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 4722030..c872ba6 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -411,6 +411,14 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
>  	}
>  
>  	/*
> +	 * Disable DMA, will be reenabled later when enabling the radio.
> +	 */
> +	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
> +	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
> +	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
> +	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
> +
> +	/*
>  	 * Write firmware to the device.
>  	 */
>  	rt2800_drv_write_firmware(rt2x00dev, data, len);
> @@ -431,15 +439,6 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
>  	}
>  
>  	/*
> -	 * Disable DMA, will be reenabled later when enabling
> -	 * the radio.
> -	 */
> -	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
> -	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
> -	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
> -	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
> -
> -	/*
>  	 * Initialize firmware.
>  	 */
>  	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);

This basically seems to be a revert of commit
4ed1dd2a7ec880b301beb61cbc1e08811ec340e4 in the wireless-testing tree.
That commit was submitted by Stanislaw, which basically does the reverse
of what you are doing here.

I leave it up to you and Stanislaw to decide on what the state is that
we need to be in.

---
Gertjan
