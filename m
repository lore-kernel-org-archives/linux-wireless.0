Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:45014 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757122Ab2CATpm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 14:45:42 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Thu, 1 Mar 2012 11:45:32 -0800
Subject: RE: [patch] mwifiex: endian bug in mwifiex_drv_change_adhoc_chan()
Message-ID: <477F20668A386D41ADCC57781B1F70430836762FFC@SC-VEXCH1.marvell.com> (sfid-20120301_204548_425575_1AC482D4)
References: <20120301072230.GC7152@elgon.mountain>
In-Reply-To: <20120301072230.GC7152@elgon.mountain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Thanks for your patch.
It looks correct.


Hi John,

There is a conflict between this patch and a patch I submitted previously.

mwifiex: remove unnecessary struct mwifiex_802_11_ssid

If you are going to take my patch series (except for the one 6/6, NACKed by Johannes), either Dan or myself can rebase this patch.

I have ACKed Dan's patch under the s-o-b line below, in case you want to merge his patch first.

Thanks,
Bing

> Subject: [patch] mwifiex: endian bug in mwifiex_drv_change_adhoc_chan()
> 
> In mwifiex_drv_change_adhoc_chan() we pass channel to
> mwifiex_bss_ioctl_ibss_channel() which sets the high 16 bits.  This
> works on little endian systems but not on big endian ones.  I've changed
> mwifiex_drv_change_adhoc_chan() to use a 16 bit variable.  This matches
> the other functions in the file.
> 
> I considered changing mwifiex_change_adhoc_chan() as well but it turns
> out that the function isn't implemented so I just removed the
> definition.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

> 
> diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
> index 52810b1..60a6919 100644
> --- a/drivers/net/wireless/mwifiex/main.h
> +++ b/drivers/net/wireless/mwifiex/main.h
> @@ -909,10 +909,9 @@ int mwifiex_request_scan(struct mwifiex_private *priv,
>  			 struct mwifiex_802_11_ssid *req_ssid);
>  int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
>  				struct mwifiex_user_scan_cfg *scan_req);
> -int mwifiex_change_adhoc_chan(struct mwifiex_private *priv, int channel);
>  int mwifiex_set_radio(struct mwifiex_private *priv, u8 option);
> 
> -int mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel);
> +int mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, u16 channel);
> 
>  int mwifiex_set_encode(struct mwifiex_private *priv, const u8 *key,
>  		       int key_len, u8 key_index, int disable);
> diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
> index b0fbf5d..652d299 100644
> --- a/drivers/net/wireless/mwifiex/sta_ioctl.c
> +++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
> @@ -599,7 +599,7 @@ static int mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *priv,
>   *          - Start/Join the IBSS
>   */
>  int
> -mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
> +mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, u16 channel)
>  {
>  	int ret;
>  	struct mwifiex_bss_info bss_info;
> @@ -636,7 +636,7 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
>  	ret = mwifiex_deauthenticate(priv, ssid_bssid.bssid);
> 
>  	ret = mwifiex_bss_ioctl_ibss_channel(priv, HostCmd_ACT_GEN_SET,
> -					     (u16 *) &channel);
> +					     &channel);
> 
>  	/* Do specific SSID scanning */
>  	if (mwifiex_request_scan(priv, &bss_info.ssid)) {
