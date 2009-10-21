Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712AbZJUSQS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2009 14:16:18 -0400
Subject: Re: [PATCH] libertas: remove unused 11d.h as well,
 priv->countryinfo
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200910191014.05320.hs4233@mail.mn-solutions.de>
References: <200910191014.05320.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 21 Oct 2009 11:16:19 -0700
Message-Id: <1256148979.5010.38.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-10-19 at 10:14 +0200, Holger Schurig wrote:
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> --- linux-wl.orig/drivers/net/wireless/libertas/11d.h
> +++ /dev/null
> @@ -1,82 +0,0 @@
> -/**
> -  * This header file contains data structures and
> -  * function declarations of 802.11d
> -  */
> -#ifndef _LBS_11D_
> -#define _LBS_11D_
> -
> -#include "types.h"
> -#include "defs.h"
> -
> -#define UNIVERSAL_REGION_CODE			0xff
> -
> -/** (Beaconsize(256)-5(IEId,len,contrystr(3))/3(FirstChan,NoOfChan,MaxPwr)
> - */
> -#define MRVDRV_MAX_SUBBAND_802_11D		83
> -
> -#define COUNTRY_CODE_LEN			3
> -#define MAX_NO_OF_CHAN 				40
> -
> -struct cmd_ds_command;
> -
> -/** Data structure for Country IE*/
> -struct ieee_subbandset {
> -	u8 firstchan;
> -	u8 nrchan;
> -	u8 maxtxpwr;
> -} __attribute__ ((packed));
> -
> -struct ieee_ie_country_info_set {
> -	struct ieee_ie_header header;
> -
> -	u8 countrycode[COUNTRY_CODE_LEN];
> -	struct ieee_subbandset subband[1];
> -};
> -
> -struct ieee_ie_country_info_full_set {
> -	struct ieee_ie_header header;
> -
> -	u8 countrycode[COUNTRY_CODE_LEN];
> -	struct ieee_subbandset subband[MRVDRV_MAX_SUBBAND_802_11D];
> -} __attribute__ ((packed));
> -
> -struct mrvl_ie_domain_param_set {
> -	struct mrvl_ie_header header;
> -
> -	u8 countrycode[COUNTRY_CODE_LEN];
> -	struct ieee_subbandset subband[1];
> -} __attribute__ ((packed));
> -
> -struct cmd_ds_802_11d_domain_info {
> -	__le16 action;
> -	struct mrvl_ie_domain_param_set domain;
> -} __attribute__ ((packed));
> -
> -/** domain regulatory information */
> -struct lbs_802_11d_domain_reg {
> -	/** country Code*/
> -	u8 countrycode[COUNTRY_CODE_LEN];
> -	/** No. of subband*/
> -	u8 nr_subband;
> -	struct ieee_subbandset subband[MRVDRV_MAX_SUBBAND_802_11D];
> -};
> -
> -struct chan_power_11d {
> -	u8 chan;
> -	u8 pwr;
> -} __attribute__ ((packed));
> -
> -struct parsed_region_chan_11d {
> -	u8 band;
> -	u8 region;
> -	s8 countrycode[COUNTRY_CODE_LEN];
> -	struct chan_power_11d chanpwr[MAX_NO_OF_CHAN];
> -	u8 nr_chan;
> -} __attribute__ ((packed));
> -
> -struct region_code_mapping {
> -	u8 region[COUNTRY_CODE_LEN];
> -	u8 code;
> -};
> -
> -#endif
> --- linux-wl.orig/drivers/net/wireless/libertas/dev.h
> +++ linux-wl/drivers/net/wireless/libertas/dev.h
> @@ -360,8 +360,6 @@
>  	union ieee_phy_param_set phy;
>  	union ieee_ss_param_set ss;
>  
> -	struct ieee_ie_country_info_full_set countryinfo;
> -
>  	u8 wpa_ie[MAX_WPA_IE_LEN];
>  	size_t wpa_ie_len;
>  	u8 rsn_ie[MAX_WPA_IE_LEN];
> --- linux-wl.orig/drivers/net/wireless/libertas/host.h
> +++ linux-wl/drivers/net/wireless/libertas/host.h
> @@ -6,7 +6,8 @@
>  #ifndef _LBS_HOST_H_
>  #define _LBS_HOST_H_
>  
> -#include "11d.h"
> +#include "types.h"
> +#include "defs.h"
>  
>  #define DEFAULT_AD_HOC_CHANNEL                  6
>  
> @@ -961,9 +962,6 @@
>  		struct cmd_ds_bbp_reg_access bbpreg;
>  		struct cmd_ds_rf_reg_access rfreg;
>  
> -		struct cmd_ds_802_11d_domain_info domaininfo;
> -		struct cmd_ds_802_11d_domain_info domaininforesp;
> -
>  		struct cmd_ds_802_11_tpc_cfg tpccfg;
>  		struct cmd_ds_802_11_afc afc;
>  		struct cmd_ds_802_11_led_ctrl ledgpio;
> --- linux-wl.orig/drivers/net/wireless/libertas/scan.c
> +++ linux-wl/drivers/net/wireless/libertas/scan.c
> @@ -503,7 +503,6 @@
>  	struct ieee_ie_cf_param_set *cf;
>  	struct ieee_ie_ibss_param_set *ibss;
>  	DECLARE_SSID_BUF(ssid);
> -	struct ieee_ie_country_info_set *pcountryinfo;
>  	uint8_t *pos, *end, *p;
>  	uint8_t n_ex_rates = 0, got_basic_rates = 0, n_basic_rates = 0;
>  	uint16_t beaconsize = 0;
> @@ -626,26 +625,6 @@
>  			lbs_deb_scan("got IBSS IE\n");
>  			break;
>  
> -		case WLAN_EID_COUNTRY:
> -			pcountryinfo = (struct ieee_ie_country_info_set *) pos;
> -			lbs_deb_scan("got COUNTRY IE\n");
> -			if (pcountryinfo->header.len < sizeof(pcountryinfo->countrycode)
> -			    || pcountryinfo->header.len > 254) {
> -				lbs_deb_scan("%s: 11D- Err CountryInfo len %d, min %zd, max 254\n",
> -					     __func__,
> -					     pcountryinfo->header.len,
> -					     sizeof(pcountryinfo->countrycode));
> -				ret = -1;
> -				goto done;
> -			}
> -
> -			memcpy(&bss->countryinfo, pcountryinfo,
> -				pcountryinfo->header.len + 2);
> -			lbs_deb_hex(LBS_DEB_SCAN, "process_bss: 11d countryinfo",
> -				    (uint8_t *) pcountryinfo,
> -				    (int) (pcountryinfo->header.len + 2));
> -			break;
> -
>  		case WLAN_EID_EXT_SUPP_RATES:
>  			/* only process extended supported rate if data rate is
>  			 * already found. Data rate IE should come before
> 

