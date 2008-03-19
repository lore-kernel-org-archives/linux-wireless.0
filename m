Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758179AbYCSTnm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:43:42 -0400
Subject: Re: [PATCH] libertas: store rssi as an int
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803181515.15584.hs4233@mail.mn-solutions.de>
References: <200803181515.15584.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 19 Mar 2008 10:51:07 -0400
Message-Id: <1205938267.26119.33.camel@localhost.localdomain> (sfid-20080319_194549_362090_FA6392DB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-03-18 at 15:15 +0100, Holger Schurig wrote:
> Don't store an long value in bss_descriptor, but
> just an int.

RSSI as defined in 802.11 as a positive 8-bit value; the libertas
firmware also reports the RSSI in scan results as a u8.  So I'd suggest
a u8 instead of an int; an int isn't the right thing to do here.

Dan


> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> 
> ---
> 
> This actually reduces the code size veeeeery slightly.
> 
> $ size libertas_old.ko libertas.ko
>    text    data     bss     dec     hex filename
>  116040    3724       8  119772   1d3dc libertas_old.ko
>  116035    3724       8  119767   1d3d7 libertas.ko
> 
> Index: wireless-testing/drivers/net/wireless/libertas/scan.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/scan.h	
> 2008-03-18 14:00:34.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/scan.h	
> 2008-03-18 14:01:22.000000000 +0100
> @@ -34,14 +34,9 @@ struct bss_descriptor {
>  	u8 ssid_len;
>  
>  	u16 capability;
> -
> -	/* receive signal strength in dBm */
> -	long rssi;
> -
> +	int rssi;
>  	u32 channel;
> -
>  	u16 beaconperiod;
> -
>  	u32 atimwindow;
>  
>  	/* IW_MODE_AUTO, IW_MODE_ADHOC, IW_MODE_INFRA */
> Index: wireless-testing/drivers/net/wireless/libertas/scan.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/scan.c	
> 2008-03-18 14:00:34.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/scan.c	
> 2008-03-18 14:01:22.000000000 +0100
> @@ -602,7 +602,7 @@ static int lbs_scan_networks(struct lbs_
>  	lbs_deb_scan("scan table:\n");
>  	list_for_each_entry(iter, &priv->network_list, list)
>  		lbs_deb_scan("%02d: BSSID %s, RSSI %d, SSID '%s'\n",
> -			     i++, print_mac(mac, iter->bssid), (int)iter->rssi,
> +			     i++, print_mac(mac, iter->bssid), iter->rssi,
>  			     escape_essid(iter->ssid, iter->ssid_len));
>  	mutex_unlock(&priv->lock);
>  #endif
> @@ -948,7 +948,7 @@ struct bss_descriptor *lbs_find_ssid_in_
>  					     uint8_t *bssid, uint8_t mode,
>  					     int channel)
>  {
> -	uint8_t bestrssi = 0;
> +	int bestrssi = 0;
>  	struct bss_descriptor * iter_bss = NULL;
>  	struct bss_descriptor * found_bss = NULL;
>  	struct bss_descriptor * tmp_oldest = NULL;
> Index: wireless-testing/drivers/net/wireless/libertas/debugfs.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/debugfs.c	
> 2008-03-18 14:00:34.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/debugfs.c	
> 2008-03-18 14:01:22.000000000 +0100
> @@ -78,7 +78,7 @@ static ssize_t lbs_getscantable(struct f
>  		u16 spectrum_mgmt = (iter_bss->capability & 
> WLAN_CAPABILITY_SPECTRUM_MGMT);
>  
>  		pos += snprintf(buf+pos, len-pos,
> -			"%02u| %03d | %04ld | %s |",
> +			"%02u| %03d | %04d | %s |",
>  			numscansdone, iter_bss->channel, iter_bss->rssi,
>  			print_mac(mac, iter_bss->bssid));
>  		pos += snprintf(buf+pos, len-pos, " %04x-", 
> iter_bss->capability);

