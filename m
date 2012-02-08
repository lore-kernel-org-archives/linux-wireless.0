Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from exchange.solarflare.com ([216.237.3.220]:7303 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750813Ab2BHVpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 16:45:18 -0500
Message-ID: <1328737514.2627.14.camel@bwh-desktop> (sfid-20120208_224540_036009_FAF59717)
Subject: Re: [PATCH] rtlwifi: rtl8192se firmware load can overflow target
 buffer
From: Ben Hutchings <bhutchings@solarflare.com>
To: Tim Gardner <tim.gardner@canonical.com>
CC: <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Date: Wed, 8 Feb 2012 21:45:14 +0000
In-Reply-To: <1328735291-33220-1-git-send-email-tim.gardner@canonical.com>
References: <1328735291-33220-1-git-send-email-tim.gardner@canonical.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-02-08 at 14:08 -0700, Tim Gardner wrote:
> The firmware file size check does not use the
> correct limit.
> 
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Chaoming Li <chaoming_li@realsil.com.cn>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/net/wireless/rtlwifi/rtl8192se/fw.h |    3 ++-
>  drivers/net/wireless/rtlwifi/rtl8192se/sw.c |    2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/fw.h b/drivers/net/wireless/rtlwifi/rtl8192se/fw.h
> index babe85d..5c377fc 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192se/fw.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8192se/fw.h
> @@ -30,6 +30,7 @@
>  #define __REALTEK_FIRMWARE92S_H__
>  
>  #define RTL8190_MAX_FIRMWARE_CODE_SIZE		64000
> +#define RTL8190_MAX_RAW_FIRMWARE_CODE_SIZE	164000
>  #define RTL8190_CPU_START_OFFSET		0x80
>  /* Firmware Local buffer size. 64k */
>  #define	MAX_FIRMWARE_CODE_SIZE			0xFF00
> @@ -217,7 +218,7 @@ struct rt_firmware {
>  	u8 fw_emem[RTL8190_MAX_FIRMWARE_CODE_SIZE];
>  	u32 fw_imem_len;
>  	u32 fw_emem_len;
> -	u8 sz_fw_tmpbuffer[164000];
> +	u8 sz_fw_tmpbuffer[RTL8190_MAX_RAW_FIRMWARE_CODE_SIZE];
>  	u32 sz_fw_tmpbufferlen;
>  	u16 cmdpacket_fragthresold;
>  };
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
> index ca38dd9..155da0a 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
> @@ -105,7 +105,7 @@ static void rtl92se_fw_cb(const struct firmware *firmware, void *context)
>  		rtlpriv->max_fw_size = 0;
>  		return;
>  	}
> -	if (firmware->size > rtlpriv->max_fw_size) {
> +	if (firmware->size >= RTL8190_MAX_RAW_FIRMWARE_CODE_SIZE) {

This appears to reject a firmware blob which is exactly the maximum
size, which looks wrong.  Also doesn't this make the max_fw_size field
redundant?

Ben.

>  		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
>  			 "Firmware is too big!\n");
>  		release_firmware(firmware);

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

