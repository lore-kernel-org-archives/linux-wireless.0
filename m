Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:33515 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756791Ab2DXULT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 16:11:19 -0400
From: Bing Zhao <bzhao@marvell.com>
To: WarheadsSE <max@warheads.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Tue, 24 Apr 2012 13:11:09 -0700
Subject: RE: [PATCH] mwifiex: add support for SD8786 sdio
Message-ID: <477F20668A386D41ADCC57781B1F7043083A3CC282@SC-VEXCH1.marvell.com> (sfid-20120424_221127_151288_50598296)
References: <1335297441-11072-1-git-send-email-max@warheads.net>
In-Reply-To: <1335297441-11072-1-git-send-email-max@warheads.net>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jason,

Thanks for the patch.

> 	modified:   drivers/net/wireless/mwifiex/Kconfig
> 	- notate additional chipset
> 	modified:   drivers/net/wireless/mwifiex/sdio.c
> 	- add definition of id (0x9116)
> 	- add to switch for firmware load
> 	- add MODULE_FIRMWARE
> 	modified:   drivers/net/wireless/mwifiex/sdio.h
> 	- add definition of default firmware name
> 
> Signed-off-by: Jason Plum <max@warheads.net>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/Kconfig |    4 ++--
>  drivers/net/wireless/mwifiex/sdio.c  |    7 +++++++
>  drivers/net/wireless/mwifiex/sdio.h  |    1 +
>  3 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/Kconfig b/drivers/net/wireless/mwifiex/Kconfig
> index 2a078ce..48c4c32 100644
> --- a/drivers/net/wireless/mwifiex/Kconfig
> +++ b/drivers/net/wireless/mwifiex/Kconfig
> @@ -10,12 +10,12 @@ config MWIFIEX
>  	  mwifiex.
> 
>  config MWIFIEX_SDIO
> -	tristate "Marvell WiFi-Ex Driver for SD8787/SD8797"
> +	tristate "Marvell WiFi-Ex Driver for SD8786/SD8787/SD8797"
>  	depends on MWIFIEX && MMC
>  	select FW_LOADER
>  	---help---
>  	  This adds support for wireless adapters based on Marvell
> -	  8787/8797 chipsets with SDIO interface.
> +	  8786/8787/8797 chipsets with SDIO interface.
> 
>  	  If you choose to build it as a module, it will be called
>  	  mwifiex_sdio.
> diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
> index f8012e2..74981ab 100644
> --- a/drivers/net/wireless/mwifiex/sdio.c
> +++ b/drivers/net/wireless/mwifiex/sdio.c
> @@ -250,6 +250,8 @@ static int mwifiex_sdio_resume(struct device *dev)
>  	return 0;
>  }
> 
> +/* Device ID for SD8786 */
> +#define SDIO_DEVICE_ID_MARVELL_8786   (0x9116)
>  /* Device ID for SD8787 */
>  #define SDIO_DEVICE_ID_MARVELL_8787   (0x9119)
>  /* Device ID for SD8797 */
> @@ -257,6 +259,7 @@ static int mwifiex_sdio_resume(struct device *dev)
> 
>  /* WLAN IDs */
>  static const struct sdio_device_id mwifiex_ids[] = {
> +	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8786)},
>  	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8787)},
>  	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8797)},
>  	{},
> @@ -1596,6 +1599,9 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
>  	adapter->dev = &func->dev;
> 
>  	switch (func->device) {
> +	case SDIO_DEVICE_ID_MARVELL_8786:
> +		strcpy(adapter->fw_name, SD8786_DEFAULT_FW_NAME);
> +		break;
>  	case SDIO_DEVICE_ID_MARVELL_8797:
>  		strcpy(adapter->fw_name, SD8797_DEFAULT_FW_NAME);
>  		break;
> @@ -1804,5 +1810,6 @@ MODULE_AUTHOR("Marvell International Ltd.");
>  MODULE_DESCRIPTION("Marvell WiFi-Ex SDIO Driver version " SDIO_VERSION);
>  MODULE_VERSION(SDIO_VERSION);
>  MODULE_LICENSE("GPL v2");
> +MODULE_FIRMWARE(SD8786_DEFAULT_FW_NAME);
>  MODULE_FIRMWARE(SD8787_DEFAULT_FW_NAME);
>  MODULE_FIRMWARE(SD8797_DEFAULT_FW_NAME);
> diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
> index a3fb322..572d7dd 100644
> --- a/drivers/net/wireless/mwifiex/sdio.h
> +++ b/drivers/net/wireless/mwifiex/sdio.h
> @@ -28,6 +28,7 @@
> 
>  #include "main.h"
> 
> +#define SD8786_DEFAULT_FW_NAME "mrvl/sd8786_uapsta.bin"
>  #define SD8787_DEFAULT_FW_NAME "mrvl/sd8787_uapsta.bin"
>  #define SD8797_DEFAULT_FW_NAME "mrvl/sd8797_uapsta.bin"
> 
> --
> 1.7.9.4

