Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4737 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbYBTUdW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 15:33:22 -0500
Date: Wed, 20 Feb 2008 15:20:15 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rndis_wlan: fix sparse warnings
Message-ID: <20080220202015.GC3825@tuxdriver.com> (sfid-20080220_203328_200817_A2C1BF38)
References: <1203504466.17534.16.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1203504466.17534.16.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 20, 2008 at 11:47:45AM +0100, Johannes Berg wrote:
> It is obviously wrong to use an enum in a little endian struct,
> and those other enums should be declared differently.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  drivers/net/wireless/rndis_wlan.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> --- everything.orig/drivers/net/wireless/rndis_wlan.c	2008-02-20 11:43:22.000000000 +0100
> +++ everything/drivers/net/wireless/rndis_wlan.c	2008-02-20 11:45:35.000000000 +0100
> @@ -228,9 +228,9 @@ struct NDIS_WLAN_BSSID_EX {
>  	struct NDIS_802_11_SSID Ssid;
>  	__le32 Privacy;
>  	__le32 Rssi;
> -	enum NDIS_802_11_NETWORK_TYPE NetworkTypeInUse;
> +	__le32 NetworkTypeInUse;
>  	struct NDIS_802_11_CONFIGURATION Configuration;
> -	enum NDIS_802_11_NETWORK_INFRASTRUCTURE InfrastructureMode;
> +	__le32 InfrastructureMode;
>  	u8 SupportedRates[NDIS_802_11_LENGTH_RATES_EX];
>  	__le32 IELength;
>  	u8 IEs[0];

This suggests that the values in the enum need to be explicitly
defined, does it not?

-- 
John W. Linville
linville@tuxdriver.com
