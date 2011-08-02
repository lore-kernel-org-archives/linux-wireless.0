Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:36758 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755456Ab1HBVke convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 17:40:34 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Tue, 2 Aug 2011 14:38:36 -0700
Subject: RE: [PATCH] mwifiex: remove redundant variable scan_table_idx
Message-ID: <477F20668A386D41ADCC57781B1F704307FFCC682F@SC-VEXCH1.marvell.com> (sfid-20110802_234039_079342_363E3DDF)
References: <1311305158-15534-1-git-send-email-bzhao@marvell.com>
 <1311305158-15534-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1311305158-15534-2-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> -----Original Message-----
> From: Bing Zhao [mailto:bzhao@marvell.com]
> Sent: Thursday, July 21, 2011 8:26 PM
> To: linux-wireless@vger.kernel.org
> Cc: John W. Linville; Amitkumar Karwar; Kiran Divekar; Yogesh Powar; Frank Huang; Bing Zhao
> Subject: [PATCH] mwifiex: remove redundant variable scan_table_idx
> 
> mwifiex_get_bss_info() routine updates variable 'info->scan_table_idx'
> but it is never used.

Could you please take this patch if it looks OK?

Thanks,
Bing

> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/ioctl.h     |    1 -
>  drivers/net/wireless/mwifiex/sta_ioctl.c |   12 ------------
>  2 files changed, 0 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
> index bd9e074..e0b68e7 100644
> --- a/drivers/net/wireless/mwifiex/ioctl.h
> +++ b/drivers/net/wireless/mwifiex/ioctl.h
> @@ -134,7 +134,6 @@ struct mwifiex_ver_ext {
>  struct mwifiex_bss_info {
>  	u32 bss_mode;
>  	struct mwifiex_802_11_ssid ssid;
> -	u32 scan_table_idx;
>  	u32 bss_chan;
>  	u32 region_code;
>  	u32 media_connected;
> diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
> index 10ef9e9..fd764b3 100644
> --- a/drivers/net/wireless/mwifiex/sta_ioctl.c
> +++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
> @@ -376,7 +376,6 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
>  {
>  	struct mwifiex_adapter *adapter = priv->adapter;
>  	struct mwifiex_bssdescriptor *bss_desc;
> -	s32 tbl_idx;
> 
>  	if (!info)
>  		return -1;
> @@ -394,17 +393,6 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
> 
>  	info->region_code = adapter->region_code;
> 
> -	/* Scan table index if connected */
> -	info->scan_table_idx = 0;
> -	if (priv->media_connected) {
> -		tbl_idx =
> -			mwifiex_find_ssid_in_list(priv, &bss_desc->ssid,
> -						  bss_desc->mac_address,
> -						  priv->bss_mode);
> -		if (tbl_idx >= 0)
> -			info->scan_table_idx = tbl_idx;
> -	}
> -
>  	info->media_connected = priv->media_connected;
> 
>  	info->max_power_level = priv->max_tx_power_level;
> --
> 1.7.0.2

