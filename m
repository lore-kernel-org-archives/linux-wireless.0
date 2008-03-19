Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940453AbYCSWTD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 18:19:03 -0400
Subject: Re: [PATCH, take 2] libertas: store rssi as an u32
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <200803191708.32595.hs4233@mail.mn-solutions.de>
References: <200803181515.15584.hs4233@mail.mn-solutions.de>
	 <200803191620.18554.hs4233@mail.mn-solutions.de>
	 <1205941183.4169.26.camel@localhost.localdomain>
	 <200803191708.32595.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 19 Mar 2008 18:17:58 -0400
Message-Id: <1205965078.18683.4.camel@localhost.localdomain> (sfid-20080319_221926_744103_9B856F41)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-19 at 17:08 +0100, Holger Schurig wrote:
> [PATCH] store rssi as an int
> 
> Don't store an (hardware base) u8 value in bss_descriptor, but just an
> unsigned int (RSSI is really unsigned). Compilers generate more efficent
> code for ints than for bytes.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: wireless-testing/drivers/net/wireless/libertas/scan.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/scan.h	2008-03-19 09:04:43.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/scan.h	2008-03-19 09:05:53.000000000 +0100
> @@ -34,14 +34,9 @@ struct bss_descriptor {
>  	u8 ssid_len;
>  
>  	u16 capability;
> -
> -	/* receive signal strength in dBm */
> -	long rssi;
> -
> +	u32 rssi;
>  	u32 channel;
> -
>  	u16 beaconperiod;
> -
>  	u32 atimwindow;
>  
>  	/* IW_MODE_AUTO, IW_MODE_ADHOC, IW_MODE_INFRA */
> Index: wireless-testing/drivers/net/wireless/libertas/scan.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/scan.c	2008-03-19 09:05:48.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/scan.c	2008-03-19 09:27:55.000000000 +0100
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
> +	u32 bestrssi = 0;
>  	struct bss_descriptor * iter_bss = NULL;
>  	struct bss_descriptor * found_bss = NULL;
>  	struct bss_descriptor * tmp_oldest = NULL;
> Index: wireless-testing/drivers/net/wireless/libertas/debugfs.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/debugfs.c	2008-03-19 09:04:43.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/debugfs.c	2008-03-19 09:05:53.000000000 +0100
> @@ -78,7 +78,7 @@ static ssize_t lbs_getscantable(struct f
>  		u16 spectrum_mgmt = (iter_bss->capability & WLAN_CAPABILITY_SPECTRUM_MGMT);
>  
>  		pos += snprintf(buf+pos, len-pos,
> -			"%02u| %03d | %04ld | %s |",
> +			"%02u| %03d | %04d | %s |",
>  			numscansdone, iter_bss->channel, iter_bss->rssi,
>  			print_mac(mac, iter_bss->bssid));
>  		pos += snprintf(buf+pos, len-pos, " %04x-", iter_bss->capability);

