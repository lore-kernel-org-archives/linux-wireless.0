Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53883 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760166Ab2COOcO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 10:32:14 -0400
Date: Thu, 15 Mar 2012 10:25:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rndis_wlan: don't report station signal
Message-ID: <20120315142527.GC31717@tuxdriver.com> (sfid-20120315_153217_953906_B32F54FF)
References: <1331820805.3432.17.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1331820805.3432.17.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 15, 2012 at 03:13:25PM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The station signal value is supposed to be in dBm
> which the device can't give, so don't report it.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Won't this break functionality for users of this device?

> ---
>  drivers/net/wireless/rndis_wlan.c |    9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> --- a/drivers/net/wireless/rndis_wlan.c	2012-03-10 09:17:00.000000000 +0100
> +++ b/drivers/net/wireless/rndis_wlan.c	2012-03-15 15:11:52.000000000 +0100
> @@ -2505,7 +2505,7 @@ static int rndis_set_default_key(struct
>  static void rndis_fill_station_info(struct usbnet *usbdev,
>  						struct station_info *sinfo)
>  {
> -	__le32 linkspeed, rssi;
> +	__le32 linkspeed;
>  	int ret, len;
>  
>  	memset(sinfo, 0, sizeof(*sinfo));
> @@ -2516,13 +2516,6 @@ static void rndis_fill_station_info(stru
>  		sinfo->txrate.legacy = le32_to_cpu(linkspeed) / 1000;
>  		sinfo->filled |= STATION_INFO_TX_BITRATE;
>  	}
> -
> -	len = sizeof(rssi);
> -	ret = rndis_query_oid(usbdev, OID_802_11_RSSI, &rssi, &len);
> -	if (ret == 0) {
> -		sinfo->signal = level_to_qual(le32_to_cpu(rssi));
> -		sinfo->filled |= STATION_INFO_SIGNAL;
> -	}
>  }
>  
>  static int rndis_get_station(struct wiphy *wiphy, struct net_device *dev,
> 
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
