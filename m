Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47838 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810AbcFINas convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 09:30:48 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Wei-Ning Huang <wnhuang@chromium.org>,
	Linux-Wireless <linux-wireless@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
	"djkurtz@chromium.org" <djkurtz@chromium.org>
Subject: RE: [PATCH v2] mwifiex: fix race condition when downloading firmware
Date: Thu, 9 Jun 2016 13:30:44 +0000
Message-ID: <e45dbcc3886e4accb4073a46baf8bb88@SC-EXCH04.marvell.com> (sfid-20160609_153129_757183_3E790782)
References: <1464352059-13923-1-git-send-email-wnhuang@chromium.org>
In-Reply-To: <1464352059-13923-1-git-send-email-wnhuang@chromium.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Wei-Ning Huang [mailto:wnhuang@chromium.org]
> Sent: Friday, May 27, 2016 5:58 PM
> To: Linux-Wireless
> Cc: LKML; Amitkumar Karwar; djkurtz@chromium.org; Wei-Ning Huang
> Subject: [PATCH v2] mwifiex: fix race condition when downloading
> firmware
> 
> The action 'check for winner' and 'download firmware' should be an
> atomic action. This is true for btmrvl driver but not mwmfiex, which
> cause firmware download to fail when the following scenario happens:
> 
> 1) mwifiex check winner status: true
> 2) btmrvl check winner status: true, and start downloading firmware
> 3) mwifiex tries to download firmware, but failed because btmrvl is
> already downloading.
> 
> This won't happen if 1) and 3) is an atomic action. This patch adds
> sdio_claim/release_host call around those two actions to make sure it's
> atomic.
> 
> Signed-off-by: Wei-Ning Huang <wnhuang@chromium.org>
> ---
>  drivers/net/wireless/marvell/mwifiex/init.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/init.c
> b/drivers/net/wireless/marvell/mwifiex/init.c
> index 78c532f..7703438 100644
> --- a/drivers/net/wireless/marvell/mwifiex/init.c
> +++ b/drivers/net/wireless/marvell/mwifiex/init.c
> @@ -24,6 +24,7 @@
>  #include "main.h"
>  #include "wmm.h"
>  #include "11n.h"
> +#include "sdio.h"
> 
>  /*
>   * This function adds a BSS priority table to the table list.
> @@ -737,16 +738,20 @@ mwifiex_shutdown_drv(struct mwifiex_adapter
> *adapter)  int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
>  		    struct mwifiex_fw_image *pmfw)
>  {
> +	struct sdio_mmc_card *card = adapter->card;
>  	int ret;
>  	u32 poll_num = 1;
> 
> +	if (adapter->iface_type == MWIFIEX_SDIO)
> +		sdio_claim_host(card->func);
> +
>  	if (adapter->if_ops.check_fw_status) {
>  		/* check if firmware is already running */
>  		ret = adapter->if_ops.check_fw_status(adapter, poll_num);
>  		if (!ret) {
>  			mwifiex_dbg(adapter, MSG,
>  				    "WLAN FW already running! Skip FW dnld\n");
> -			return 0;
> +			goto release_host;
>  		}
>  	}
> 
> @@ -759,7 +764,7 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
>  		if (ret) {
>  			mwifiex_dbg(adapter, MSG,
>  				    "WLAN read winner status failed!\n");
> -			return ret;
> +			goto release_host;
>  		}
> 
>  		if (!adapter->winner) {
> @@ -775,7 +780,7 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
>  		if (ret) {
>  			mwifiex_dbg(adapter, ERROR,
>  				    "prog_fw failed ret=%#x\n", ret);
> -			return ret;
> +			goto release_host;
>  		}
>  	}
> 
> @@ -785,6 +790,9 @@ poll_fw:
>  	if (ret)
>  		mwifiex_dbg(adapter, ERROR,
>  			    "FW failed to be active in time\n");
> +release_host:
> +	if (adapter->iface_type == MWIFIEX_SDIO)
> +		sdio_release_host(card->func);
> 
>  	return ret;
>  }
> --
> 2.1.2

Patch looks fine to me.

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Regards,
Amitkumar
