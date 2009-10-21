Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbZJUSN4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2009 14:13:56 -0400
Subject: Re: [PATCH] libertas: remove unused 11d code
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200910190940.52830.hs4233@mail.mn-solutions.de>
References: <200910190940.52830.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 21 Oct 2009 11:13:57 -0700
Message-Id: <1256148837.5010.35.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-10-19 at 09:40 +0200, Holger Schurig wrote:
> Most of the 11d code was protected with an "if (priv->enable11d)" clause.
> But there was no code that anywhere that was able to set this
> variable to true. So all 11d code was dead for almost a year and no one
> complained. That's enought incentive to remove this code.
> 
> Besides removing old cruft, we gain back the 11d capability in a common way
> when we merge the cfg80211 functionality.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

Can add this back when somebody cares.  Nobody has touched it in at
least 3 years.

> ---
> 
> First I removed all protected with "if (priv->enable11d)".
> 
> Then I removed the now empty functions because of the first step (e.g.
> lbs_create_dnld_countryinfo_11d() and lbs_parse_dnld_countryinfo_11d()
> became empty.
> 
> Then there was no code that could invoke CMD_802_11D_DOMAIN_INFO, so I
> removed the parts from cmd.c and cmdresp.c that handled this.
> 
> Then I removed the functions and variables that were unused.
> 
> Then I removed priv->parsed_region_chan and it's initialisation code. It was
> only initialized and not used at all.
> 
> And suddenly 11d. was empty, so I removed that as well.
> 
> 
> --- linux-wl.orig/drivers/net/wireless/libertas/11d.h
> +++ linux-wl/drivers/net/wireless/libertas/11d.h
> @@ -79,27 +79,4 @@
>  	u8 code;
>  };
>  
> -struct lbs_private;
> -
> -u8 lbs_get_scan_type_11d(u8 chan,
> -			  struct parsed_region_chan_11d *parsed_region_chan);
> -
> -u32 lbs_chan_2_freq(u8 chan);
> -
> -void lbs_init_11d(struct lbs_private *priv);
> -
> -int lbs_set_universaltable(struct lbs_private *priv, u8 band);
> -
> -int lbs_cmd_802_11d_domain_info(struct lbs_private *priv,
> -				 struct cmd_ds_command *cmd, u16 cmdno,
> -				 u16 cmdOption);
> -
> -int lbs_ret_802_11d_domain_info(struct cmd_ds_command *resp);
> -
> -struct bss_descriptor;
> -int lbs_parse_dnld_countryinfo_11d(struct lbs_private *priv,
> -                                        struct bss_descriptor * bss);
> -
> -int lbs_create_dnld_countryinfo_11d(struct lbs_private *priv);
> -
>  #endif
> --- linux-wl.orig/drivers/net/wireless/libertas/assoc.c
> +++ linux-wl/drivers/net/wireless/libertas/assoc.c
> @@ -371,11 +371,6 @@
>  	/* update curbssparams */
>  	priv->curbssparams.channel = bss->phy.ds.channel;
>  
> -	if (lbs_parse_dnld_countryinfo_11d(priv, bss)) {
> -		ret = -1;
> -		goto done;
> -	}
> -
>  	ret = lbs_cmd_with_response(priv, command, &cmd);
>  	if (ret == 0) {
>  		ret = lbs_assoc_post(priv,
> @@ -650,11 +645,6 @@
>  		}
>  	}
>  
> -	if (lbs_parse_dnld_countryinfo_11d(priv, bss)) {
> -		ret = -1;
> -		goto out;
> -	}
> -
>  	ret = lbs_cmd_with_response(priv, CMD_802_11_AD_HOC_JOIN, &cmd);
>  	if (ret == 0) {
>  		ret = lbs_adhoc_post(priv,
> @@ -754,12 +744,6 @@
>  	lbs_deb_join("ADHOC_START: rates=%02x %02x %02x %02x\n",
>  	       cmd.rates[0], cmd.rates[1], cmd.rates[2], cmd.rates[3]);
>  
> -	if (lbs_create_dnld_countryinfo_11d(priv)) {
> -		lbs_deb_join("ADHOC_START: dnld_countryinfo_11d failed\n");
> -		ret = -1;
> -		goto out;
> -	}
> -
>  	lbs_deb_join("ADHOC_START: Starting Ad-Hoc BSS on channel %d, band %d\n",
>  		     assoc_req->channel, assoc_req->band);
>  
> --- linux-wl.orig/drivers/net/wireless/libertas/scan.c
> +++ linux-wl/drivers/net/wireless/libertas/scan.c
> @@ -144,31 +144,15 @@
>  	scantype = CMD_SCAN_TYPE_ACTIVE;
>  
>  	for (rgnidx = 0; rgnidx < ARRAY_SIZE(priv->region_channel); rgnidx++) {
> -		if (priv->enable11d && (priv->connect_status != LBS_CONNECTED)
> -		    && (priv->mesh_connect_status != LBS_CONNECTED)) {
> -			/* Scan all the supported chan for the first scan */
> -			if (!priv->universal_channel[rgnidx].valid)
> -				continue;
> -			scanregion = &priv->universal_channel[rgnidx];
> -
> -			/* clear the parsed_region_chan for the first scan */
> -			memset(&priv->parsed_region_chan, 0x00,
> -			       sizeof(priv->parsed_region_chan));
> -		} else {
> -			if (!priv->region_channel[rgnidx].valid)
> -				continue;
> -			scanregion = &priv->region_channel[rgnidx];
> -		}
> +		if (!priv->region_channel[rgnidx].valid)
> +			continue;
> +		scanregion = &priv->region_channel[rgnidx];
>  
>  		for (nextchan = 0; nextchan < scanregion->nrcfp; nextchan++, chanidx++) {
>  			struct chanscanparamset *chan = &scanchanlist[chanidx];
>  
>  			cfp = scanregion->CFP + nextchan;
>  
> -			if (priv->enable11d)
> -				scantype = lbs_get_scan_type_11d(cfp->channel,
> -								 &priv->parsed_region_chan);
> -
>  			if (scanregion->band == BAND_B || scanregion->band == BAND_G)
>  				chan->radiotype = CMD_SCAN_RADIO_TYPE_BG;
>  
> --- linux-wl.orig/drivers/net/wireless/libertas/wext.c
> +++ linux-wl/drivers/net/wireless/libertas/wext.c
> @@ -65,8 +65,6 @@
>  	for (j = 0; !cfp && (j < ARRAY_SIZE(priv->region_channel)); j++) {
>  		rc = &priv->region_channel[j];
>  
> -		if (priv->enable11d)
> -			rc = &priv->universal_channel[j];
>  		if (!rc->valid || !rc->CFP)
>  			continue;
>  		if (rc->band != band)
> @@ -106,8 +104,6 @@
>  	for (j = 0; !cfp && (j < ARRAY_SIZE(priv->region_channel)); j++) {
>  		rc = &priv->region_channel[j];
>  
> -		if (priv->enable11d)
> -			rc = &priv->universal_channel[j];
>  		if (!rc->valid || !rc->CFP)
>  			continue;
>  		if (rc->band != band)
> @@ -546,8 +542,6 @@
>  	struct chan_freq_power *cfp;
>  	u8 rates[MAX_RATES + 1];
>  
> -	u8 flag = 0;
> -
>  	lbs_deb_enter(LBS_DEB_WEXT);
>  
>  	dwrq->length = sizeof(struct iw_range);
> @@ -569,52 +563,21 @@
>  
>  	range->scan_capa = IW_SCAN_CAPA_ESSID;
>  
> -	if (priv->enable11d &&
> -	    (priv->connect_status == LBS_CONNECTED ||
> -	    priv->mesh_connect_status == LBS_CONNECTED)) {
> -		u8 chan_no;
> -		u8 band;
> -
> -		struct parsed_region_chan_11d *parsed_region_chan =
> -		    &priv->parsed_region_chan;
> -
> -		if (parsed_region_chan == NULL) {
> -			lbs_deb_wext("11d: parsed_region_chan is NULL\n");
> -			goto out;
> -		}
> -		band = parsed_region_chan->band;
> -		lbs_deb_wext("band %d, nr_char %d\n", band,
> -		       parsed_region_chan->nr_chan);
> -
> +	for (j = 0; (range->num_frequency < IW_MAX_FREQUENCIES)
> +	     && (j < ARRAY_SIZE(priv->region_channel)); j++) {
> +		cfp = priv->region_channel[j].CFP;
>  		for (i = 0; (range->num_frequency < IW_MAX_FREQUENCIES)
> -		     && (i < parsed_region_chan->nr_chan); i++) {
> -			chan_no = parsed_region_chan->chanpwr[i].chan;
> -			lbs_deb_wext("chan_no %d\n", chan_no);
> -			range->freq[range->num_frequency].i = (long)chan_no;
> +		     && priv->region_channel[j].valid
> +		     && cfp
> +		     && (i < priv->region_channel[j].nrcfp); i++) {
> +			range->freq[range->num_frequency].i =
> +			    (long)cfp->channel;
>  			range->freq[range->num_frequency].m =
> -			    (long)lbs_chan_2_freq(chan_no) * 100000;
> +			    (long)cfp->freq * 100000;
>  			range->freq[range->num_frequency].e = 1;
> +			cfp++;
>  			range->num_frequency++;
>  		}
> -		flag = 1;
> -	}
> -	if (!flag) {
> -		for (j = 0; (range->num_frequency < IW_MAX_FREQUENCIES)
> -		     && (j < ARRAY_SIZE(priv->region_channel)); j++) {
> -			cfp = priv->region_channel[j].CFP;
> -			for (i = 0; (range->num_frequency < IW_MAX_FREQUENCIES)
> -			     && priv->region_channel[j].valid
> -			     && cfp
> -			     && (i < priv->region_channel[j].nrcfp); i++) {
> -				range->freq[range->num_frequency].i =
> -				    (long)cfp->channel;
> -				range->freq[range->num_frequency].m =
> -				    (long)cfp->freq * 100000;
> -				range->freq[range->num_frequency].e = 1;
> -				cfp++;
> -				range->num_frequency++;
> -			}
> -		}
>  	}
>  
>  	lbs_deb_wext("IW_MAX_FREQUENCIES %d, num_frequency %d\n",
> @@ -699,7 +662,6 @@
>  		                  | IW_ENC_CAPA_CIPHER_CCMP;
>  	}
>  
> -out:
>  	lbs_deb_leave(LBS_DEB_WEXT);
>  	return 0;
>  }
> --- linux-wl.orig/drivers/net/wireless/libertas/11d.c
> +++ /dev/null
> @@ -1,697 +0,0 @@
> -/**
> -  * This file contains functions for 802.11D.
> -  */
> -#include <linux/ctype.h>
> -#include <linux/kernel.h>
> -#include <linux/wireless.h>
> -
> -#include "host.h"
> -#include "cmd.h"
> -#include "decl.h"
> -#include "11d.h"
> -#include "dev.h"
> -#include "wext.h"
> -
> -#define TX_PWR_DEFAULT	10
> -
> -static struct region_code_mapping region_code_mapping[] = {
> -	{"US ", 0x10},		/* US FCC      */
> -	{"CA ", 0x10},		/* IC Canada   */
> -	{"SG ", 0x10},		/* Singapore   */
> -	{"EU ", 0x30},		/* ETSI        */
> -	{"AU ", 0x30},		/* Australia   */
> -	{"KR ", 0x30},		/* Republic Of Korea */
> -	{"ES ", 0x31},		/* Spain       */
> -	{"FR ", 0x32},		/* France      */
> -	{"JP ", 0x40},		/* Japan       */
> -};
> -
> -/* Following 2 structure defines the supported channels */
> -static struct chan_freq_power channel_freq_power_UN_BG[] = {
> -	{1, 2412, TX_PWR_DEFAULT},
> -	{2, 2417, TX_PWR_DEFAULT},
> -	{3, 2422, TX_PWR_DEFAULT},
> -	{4, 2427, TX_PWR_DEFAULT},
> -	{5, 2432, TX_PWR_DEFAULT},
> -	{6, 2437, TX_PWR_DEFAULT},
> -	{7, 2442, TX_PWR_DEFAULT},
> -	{8, 2447, TX_PWR_DEFAULT},
> -	{9, 2452, TX_PWR_DEFAULT},
> -	{10, 2457, TX_PWR_DEFAULT},
> -	{11, 2462, TX_PWR_DEFAULT},
> -	{12, 2467, TX_PWR_DEFAULT},
> -	{13, 2472, TX_PWR_DEFAULT},
> -	{14, 2484, TX_PWR_DEFAULT}
> -};
> -
> -static u8 lbs_region_2_code(u8 *region)
> -{
> -	u8 i;
> -
> -	for (i = 0; i < COUNTRY_CODE_LEN && region[i]; i++)
> -		region[i] = toupper(region[i]);
> -
> -	for (i = 0; i < ARRAY_SIZE(region_code_mapping); i++) {
> -		if (!memcmp(region, region_code_mapping[i].region,
> -			    COUNTRY_CODE_LEN))
> -			return (region_code_mapping[i].code);
> -	}
> -
> -	/* default is US */
> -	return (region_code_mapping[0].code);
> -}
> -
> -static u8 *lbs_code_2_region(u8 code)
> -{
> -	u8 i;
> -
> -	for (i = 0; i < ARRAY_SIZE(region_code_mapping); i++) {
> -		if (region_code_mapping[i].code == code)
> -			return (region_code_mapping[i].region);
> -	}
> -	/* default is US */
> -	return (region_code_mapping[0].region);
> -}
> -
> -/**
> - *  @brief This function finds the nrchan-th chan after the firstchan
> - *  @param band       band
> - *  @param firstchan  first channel number
> - *  @param nrchan   number of channels
> - *  @return 	      the nrchan-th chan number
> -*/
> -static u8 lbs_get_chan_11d(u8 firstchan, u8 nrchan, u8 *chan)
> -/*find the nrchan-th chan after the firstchan*/
> -{
> -	u8 i;
> -	struct chan_freq_power *cfp;
> -	u8 cfp_no;
> -
> -	cfp = channel_freq_power_UN_BG;
> -	cfp_no = ARRAY_SIZE(channel_freq_power_UN_BG);
> -
> -	for (i = 0; i < cfp_no; i++) {
> -		if ((cfp + i)->channel == firstchan) {
> -			lbs_deb_11d("firstchan found\n");
> -			break;
> -		}
> -	}
> -
> -	if (i < cfp_no) {
> -		/*if beyond the boundary */
> -		if (i + nrchan < cfp_no) {
> -			*chan = (cfp + i + nrchan)->channel;
> -			return 1;
> -		}
> -	}
> -
> -	return 0;
> -}
> -
> -/**
> - *  @brief This function Checks if chan txpwr is learned from AP/IBSS
> - *  @param chan                 chan number
> - *  @param parsed_region_chan   pointer to parsed_region_chan_11d
> - *  @return 	                TRUE; FALSE
> -*/
> -static u8 lbs_channel_known_11d(u8 chan,
> -			  struct parsed_region_chan_11d * parsed_region_chan)
> -{
> -	struct chan_power_11d *chanpwr = parsed_region_chan->chanpwr;
> -	u8 nr_chan = parsed_region_chan->nr_chan;
> -	u8 i = 0;
> -
> -	lbs_deb_hex(LBS_DEB_11D, "parsed_region_chan", (char *)chanpwr,
> -		sizeof(struct chan_power_11d) * nr_chan);
> -
> -	for (i = 0; i < nr_chan; i++) {
> -		if (chan == chanpwr[i].chan) {
> -			lbs_deb_11d("found chan %d\n", chan);
> -			return 1;
> -		}
> -	}
> -
> -	lbs_deb_11d("chan %d not found\n", chan);
> -	return 0;
> -}
> -
> -u32 lbs_chan_2_freq(u8 chan)
> -{
> -	struct chan_freq_power *cf;
> -	u16 i;
> -	u32 freq = 0;
> -
> -	cf = channel_freq_power_UN_BG;
> -
> -	for (i = 0; i < ARRAY_SIZE(channel_freq_power_UN_BG); i++) {
> -		if (chan == cf[i].channel)
> -			freq = cf[i].freq;
> -	}
> -
> -	return freq;
> -}
> -
> -static int generate_domain_info_11d(struct parsed_region_chan_11d
> -				  *parsed_region_chan,
> -				  struct lbs_802_11d_domain_reg *domaininfo)
> -{
> -	u8 nr_subband = 0;
> -
> -	u8 nr_chan = parsed_region_chan->nr_chan;
> -	u8 nr_parsedchan = 0;
> -
> -	u8 firstchan = 0, nextchan = 0, maxpwr = 0;
> -
> -	u8 i, flag = 0;
> -
> -	memcpy(domaininfo->countrycode, parsed_region_chan->countrycode,
> -	       COUNTRY_CODE_LEN);
> -
> -	lbs_deb_11d("nrchan %d\n", nr_chan);
> -	lbs_deb_hex(LBS_DEB_11D, "parsed_region_chan", (char *)parsed_region_chan,
> -		sizeof(struct parsed_region_chan_11d));
> -
> -	for (i = 0; i < nr_chan; i++) {
> -		if (!flag) {
> -			flag = 1;
> -			nextchan = firstchan =
> -			    parsed_region_chan->chanpwr[i].chan;
> -			maxpwr = parsed_region_chan->chanpwr[i].pwr;
> -			nr_parsedchan = 1;
> -			continue;
> -		}
> -
> -		if (parsed_region_chan->chanpwr[i].chan == nextchan + 1 &&
> -		    parsed_region_chan->chanpwr[i].pwr == maxpwr) {
> -			nextchan++;
> -			nr_parsedchan++;
> -		} else {
> -			domaininfo->subband[nr_subband].firstchan = firstchan;
> -			domaininfo->subband[nr_subband].nrchan =
> -			    nr_parsedchan;
> -			domaininfo->subband[nr_subband].maxtxpwr = maxpwr;
> -			nr_subband++;
> -			nextchan = firstchan =
> -			    parsed_region_chan->chanpwr[i].chan;
> -			maxpwr = parsed_region_chan->chanpwr[i].pwr;
> -		}
> -	}
> -
> -	if (flag) {
> -		domaininfo->subband[nr_subband].firstchan = firstchan;
> -		domaininfo->subband[nr_subband].nrchan = nr_parsedchan;
> -		domaininfo->subband[nr_subband].maxtxpwr = maxpwr;
> -		nr_subband++;
> -	}
> -	domaininfo->nr_subband = nr_subband;
> -
> -	lbs_deb_11d("nr_subband=%x\n", domaininfo->nr_subband);
> -	lbs_deb_hex(LBS_DEB_11D, "domaininfo", (char *)domaininfo,
> -		COUNTRY_CODE_LEN + 1 +
> -		sizeof(struct ieee_subbandset) * nr_subband);
> -	return 0;
> -}
> -
> -/**
> - *  @brief This function generates parsed_region_chan from Domain Info learned from AP/IBSS
> - *  @param region_chan          pointer to struct region_channel
> - *  @param *parsed_region_chan  pointer to parsed_region_chan_11d
> - *  @return 	                N/A
> -*/
> -static void lbs_generate_parsed_region_chan_11d(struct region_channel *region_chan,
> -					  struct parsed_region_chan_11d *
> -					  parsed_region_chan)
> -{
> -	u8 i;
> -	struct chan_freq_power *cfp;
> -
> -	if (region_chan == NULL) {
> -		lbs_deb_11d("region_chan is NULL\n");
> -		return;
> -	}
> -
> -	cfp = region_chan->CFP;
> -	if (cfp == NULL) {
> -		lbs_deb_11d("cfp is NULL \n");
> -		return;
> -	}
> -
> -	parsed_region_chan->band = region_chan->band;
> -	parsed_region_chan->region = region_chan->region;
> -	memcpy(parsed_region_chan->countrycode,
> -	       lbs_code_2_region(region_chan->region), COUNTRY_CODE_LEN);
> -
> -	lbs_deb_11d("region 0x%x, band %d\n", parsed_region_chan->region,
> -	       parsed_region_chan->band);
> -
> -	for (i = 0; i < region_chan->nrcfp; i++, cfp++) {
> -		parsed_region_chan->chanpwr[i].chan = cfp->channel;
> -		parsed_region_chan->chanpwr[i].pwr = cfp->maxtxpower;
> -		lbs_deb_11d("chan %d, pwr %d\n",
> -		       parsed_region_chan->chanpwr[i].chan,
> -		       parsed_region_chan->chanpwr[i].pwr);
> -	}
> -	parsed_region_chan->nr_chan = region_chan->nrcfp;
> -
> -	lbs_deb_11d("nrchan %d\n", parsed_region_chan->nr_chan);
> -
> -	return;
> -}
> -
> -/**
> - *  @brief generate parsed_region_chan from Domain Info learned from AP/IBSS
> - *  @param region               region ID
> - *  @param band                 band
> - *  @param chan                 chan
> - *  @return 	                TRUE;FALSE
> -*/
> -static u8 lbs_region_chan_supported_11d(u8 region, u8 chan)
> -{
> -	struct chan_freq_power *cfp;
> -	int cfp_no;
> -	u8 idx;
> -	int ret = 0;
> -
> -	lbs_deb_enter(LBS_DEB_11D);
> -
> -	cfp = lbs_get_region_cfp_table(region, &cfp_no);
> -	if (cfp == NULL)
> -		return 0;
> -
> -	for (idx = 0; idx < cfp_no; idx++) {
> -		if (chan == (cfp + idx)->channel) {
> -			/* If Mrvl Chip Supported? */
> -			if ((cfp + idx)->unsupported) {
> -				ret = 0;
> -			} else {
> -				ret = 1;
> -			}
> -			goto done;
> -		}
> -	}
> -
> -	/*chan is not in the region table */
> -
> -done:
> -	lbs_deb_leave_args(LBS_DEB_11D, "ret %d", ret);
> -	return ret;
> -}
> -
> -/**
> - *  @brief This function checks if chan txpwr is learned from AP/IBSS
> - *  @param chan                 chan number
> - *  @param parsed_region_chan   pointer to parsed_region_chan_11d
> - *  @return 	                0
> -*/
> -static int parse_domain_info_11d(struct ieee_ie_country_info_full_set *countryinfo,
> -				 u8 band,
> -				 struct parsed_region_chan_11d *parsed_region_chan)
> -{
> -	u8 nr_subband, nrchan;
> -	u8 lastchan, firstchan;
> -	u8 region;
> -	u8 curchan = 0;
> -
> -	u8 idx = 0;		/*chan index in parsed_region_chan */
> -
> -	u8 j, i;
> -
> -	lbs_deb_enter(LBS_DEB_11D);
> -
> -	/*validation Rules:
> -	   1. valid region Code
> -	   2. First Chan increment
> -	   3. channel range no overlap
> -	   4. channel is valid?
> -	   5. channel is supported by region?
> -	   6. Others
> -	 */
> -
> -	lbs_deb_hex(LBS_DEB_11D, "countryinfo", (u8 *) countryinfo, 30);
> -
> -	if ((*(countryinfo->countrycode)) == 0
> -	    || (countryinfo->header.len <= COUNTRY_CODE_LEN)) {
> -		/* No region Info or Wrong region info: treat as No 11D info */
> -		goto done;
> -	}
> -
> -	/*Step1: check region_code */
> -	parsed_region_chan->region = region =
> -	    lbs_region_2_code(countryinfo->countrycode);
> -
> -	lbs_deb_11d("regioncode=%x\n", (u8) parsed_region_chan->region);
> -	lbs_deb_hex(LBS_DEB_11D, "countrycode", (char *)countryinfo->countrycode,
> -		COUNTRY_CODE_LEN);
> -
> -	parsed_region_chan->band = band;
> -
> -	memcpy(parsed_region_chan->countrycode, countryinfo->countrycode,
> -	       COUNTRY_CODE_LEN);
> -
> -	nr_subband = (countryinfo->header.len - COUNTRY_CODE_LEN) /
> -	    sizeof(struct ieee_subbandset);
> -
> -	for (j = 0, lastchan = 0; j < nr_subband; j++) {
> -
> -		if (countryinfo->subband[j].firstchan <= lastchan) {
> -			/*Step2&3. Check First Chan Num increment and no overlap */
> -			lbs_deb_11d("chan %d>%d, overlap\n",
> -			       countryinfo->subband[j].firstchan, lastchan);
> -			continue;
> -		}
> -
> -		firstchan = countryinfo->subband[j].firstchan;
> -		nrchan = countryinfo->subband[j].nrchan;
> -
> -		for (i = 0; idx < MAX_NO_OF_CHAN && i < nrchan; i++) {
> -			/*step4: channel is supported? */
> -
> -			if (!lbs_get_chan_11d(firstchan, i, &curchan)) {
> -				/* Chan is not found in UN table */
> -				lbs_deb_11d("chan is not supported: %d \n", i);
> -				break;
> -			}
> -
> -			lastchan = curchan;
> -
> -			if (lbs_region_chan_supported_11d(region, curchan)) {
> -				/*step5: Check if curchan is supported by mrvl in region */
> -				parsed_region_chan->chanpwr[idx].chan = curchan;
> -				parsed_region_chan->chanpwr[idx].pwr =
> -				    countryinfo->subband[j].maxtxpwr;
> -				idx++;
> -			} else {
> -				/*not supported and ignore the chan */
> -				lbs_deb_11d(
> -				       "i %d, chan %d unsupported in region %x, band %d\n",
> -				       i, curchan, region, band);
> -			}
> -		}
> -
> -		/*Step6: Add other checking if any */
> -
> -	}
> -
> -	parsed_region_chan->nr_chan = idx;
> -
> -	lbs_deb_11d("nrchan=%x\n", parsed_region_chan->nr_chan);
> -	lbs_deb_hex(LBS_DEB_11D, "parsed_region_chan", (u8 *) parsed_region_chan,
> -		2 + COUNTRY_CODE_LEN + sizeof(struct parsed_region_chan_11d) * idx);
> -
> -done:
> -	lbs_deb_enter(LBS_DEB_11D);
> -	return 0;
> -}
> -
> -/**
> - *  @brief This function calculates the scan type for channels
> - *  @param chan                 chan number
> - *  @param parsed_region_chan   pointer to parsed_region_chan_11d
> - *  @return 	                PASSIVE if chan is unknown; ACTIVE if chan is known
> -*/
> -u8 lbs_get_scan_type_11d(u8 chan,
> -			  struct parsed_region_chan_11d * parsed_region_chan)
> -{
> -	u8 scan_type = CMD_SCAN_TYPE_PASSIVE;
> -
> -	lbs_deb_enter(LBS_DEB_11D);
> -
> -	if (lbs_channel_known_11d(chan, parsed_region_chan)) {
> -		lbs_deb_11d("found, do active scan\n");
> -		scan_type = CMD_SCAN_TYPE_ACTIVE;
> -	} else {
> -		lbs_deb_11d("not found, do passive scan\n");
> -	}
> -
> -	lbs_deb_leave_args(LBS_DEB_11D, "ret scan_type %d", scan_type);
> -	return scan_type;
> -
> -}
> -
> -void lbs_init_11d(struct lbs_private *priv)
> -{
> -	priv->enable11d = 0;
> -	memset(&(priv->parsed_region_chan), 0,
> -	       sizeof(struct parsed_region_chan_11d));
> -	return;
> -}
> -
> -/**
> - *  @brief This function sets DOMAIN INFO to FW
> - *  @param priv       pointer to struct lbs_private
> - *  @return 	      0; -1
> -*/
> -static int set_domain_info_11d(struct lbs_private *priv)
> -{
> -	int ret;
> -
> -	if (!priv->enable11d) {
> -		lbs_deb_11d("dnld domain Info with 11d disabled\n");
> -		return 0;
> -	}
> -
> -	ret = lbs_prepare_and_send_command(priv, CMD_802_11D_DOMAIN_INFO,
> -				    CMD_ACT_SET,
> -				    CMD_OPTION_WAITFORRSP, 0, NULL);
> -	if (ret)
> -		lbs_deb_11d("fail to dnld domain info\n");
> -
> -	return ret;
> -}
> -
> -/**
> - *  @brief This function setups scan channels
> - *  @param priv       pointer to struct lbs_private
> - *  @param band       band
> - *  @return 	      0
> -*/
> -int lbs_set_universaltable(struct lbs_private *priv, u8 band)
> -{
> -	u16 size = sizeof(struct chan_freq_power);
> -	u16 i = 0;
> -
> -	memset(priv->universal_channel, 0,
> -	       sizeof(priv->universal_channel));
> -
> -	priv->universal_channel[i].nrcfp =
> -	    sizeof(channel_freq_power_UN_BG) / size;
> -	lbs_deb_11d("BG-band nrcfp %d\n",
> -	       priv->universal_channel[i].nrcfp);
> -
> -	priv->universal_channel[i].CFP = channel_freq_power_UN_BG;
> -	priv->universal_channel[i].valid = 1;
> -	priv->universal_channel[i].region = UNIVERSAL_REGION_CODE;
> -	priv->universal_channel[i].band = band;
> -	i++;
> -
> -	return 0;
> -}
> -
> -/**
> - *  @brief This function implements command CMD_802_11D_DOMAIN_INFO
> - *  @param priv       pointer to struct lbs_private
> - *  @param cmd        pointer to cmd buffer
> - *  @param cmdno      cmd ID
> - *  @param cmdOption  cmd action
> - *  @return 	      0
> -*/
> -int lbs_cmd_802_11d_domain_info(struct lbs_private *priv,
> -				 struct cmd_ds_command *cmd, u16 cmdno,
> -				 u16 cmdoption)
> -{
> -	struct cmd_ds_802_11d_domain_info *pdomaininfo =
> -	    &cmd->params.domaininfo;
> -	struct mrvl_ie_domain_param_set *domain = &pdomaininfo->domain;
> -	u8 nr_subband = priv->domainreg.nr_subband;
> -
> -	lbs_deb_enter(LBS_DEB_11D);
> -
> -	lbs_deb_11d("nr_subband=%x\n", nr_subband);
> -
> -	cmd->command = cpu_to_le16(cmdno);
> -	pdomaininfo->action = cpu_to_le16(cmdoption);
> -	if (cmdoption == CMD_ACT_GET) {
> -		cmd->size =
> -		    cpu_to_le16(sizeof(pdomaininfo->action) + S_DS_GEN);
> -		lbs_deb_hex(LBS_DEB_11D, "802_11D_DOMAIN_INFO", (u8 *) cmd,
> -			le16_to_cpu(cmd->size));
> -		goto done;
> -	}
> -
> -	domain->header.type = cpu_to_le16(TLV_TYPE_DOMAIN);
> -	memcpy(domain->countrycode, priv->domainreg.countrycode,
> -	       sizeof(domain->countrycode));
> -
> -	domain->header.len =
> -	    cpu_to_le16(nr_subband * sizeof(struct ieee_subbandset) +
> -			     sizeof(domain->countrycode));
> -
> -	if (nr_subband) {
> -		memcpy(domain->subband, priv->domainreg.subband,
> -		       nr_subband * sizeof(struct ieee_subbandset));
> -
> -		cmd->size = cpu_to_le16(sizeof(pdomaininfo->action) +
> -					     le16_to_cpu(domain->header.len) +
> -					     sizeof(struct mrvl_ie_header) +
> -					     S_DS_GEN);
> -	} else {
> -		cmd->size =
> -		    cpu_to_le16(sizeof(pdomaininfo->action) + S_DS_GEN);
> -	}
> -
> -	lbs_deb_hex(LBS_DEB_11D, "802_11D_DOMAIN_INFO", (u8 *) cmd, le16_to_cpu(cmd->size));
> -
> -done:
> -	lbs_deb_enter(LBS_DEB_11D);
> -	return 0;
> -}
> -
> -/**
> - *  @brief This function parses countryinfo from AP and download country info to FW
> - *  @param priv    pointer to struct lbs_private
> - *  @param resp    pointer to command response buffer
> - *  @return 	   0; -1
> - */
> -int lbs_ret_802_11d_domain_info(struct cmd_ds_command *resp)
> -{
> -	struct cmd_ds_802_11d_domain_info *domaininfo = &resp->params.domaininforesp;
> -	struct mrvl_ie_domain_param_set *domain = &domaininfo->domain;
> -	u16 action = le16_to_cpu(domaininfo->action);
> -	s16 ret = 0;
> -	u8 nr_subband = 0;
> -
> -	lbs_deb_enter(LBS_DEB_11D);
> -
> -	lbs_deb_hex(LBS_DEB_11D, "domain info resp", (u8 *) resp,
> -		(int)le16_to_cpu(resp->size));
> -
> -	nr_subband = (le16_to_cpu(domain->header.len) - COUNTRY_CODE_LEN) /
> -		      sizeof(struct ieee_subbandset);
> -
> -	lbs_deb_11d("domain info resp: nr_subband %d\n", nr_subband);
> -
> -	if (nr_subband > MRVDRV_MAX_SUBBAND_802_11D) {
> -		lbs_deb_11d("Invalid Numrer of Subband returned!!\n");
> -		return -1;
> -	}
> -
> -	switch (action) {
> -	case CMD_ACT_SET:	/*Proc Set action */
> -		break;
> -
> -	case CMD_ACT_GET:
> -		break;
> -	default:
> -		lbs_deb_11d("Invalid action:%d\n", domaininfo->action);
> -		ret = -1;
> -		break;
> -	}
> -
> -	lbs_deb_leave_args(LBS_DEB_11D, "ret %d", ret);
> -	return ret;
> -}
> -
> -/**
> - *  @brief This function parses countryinfo from AP and download country info to FW
> - *  @param priv    pointer to struct lbs_private
> - *  @return 	   0; -1
> - */
> -int lbs_parse_dnld_countryinfo_11d(struct lbs_private *priv,
> -                                        struct bss_descriptor * bss)
> -{
> -	int ret;
> -
> -	lbs_deb_enter(LBS_DEB_11D);
> -	if (priv->enable11d) {
> -		memset(&priv->parsed_region_chan, 0,
> -		       sizeof(struct parsed_region_chan_11d));
> -		ret = parse_domain_info_11d(&bss->countryinfo, 0,
> -					       &priv->parsed_region_chan);
> -
> -		if (ret == -1) {
> -			lbs_deb_11d("error parsing domain_info from AP\n");
> -			goto done;
> -		}
> -
> -		memset(&priv->domainreg, 0,
> -		       sizeof(struct lbs_802_11d_domain_reg));
> -		generate_domain_info_11d(&priv->parsed_region_chan,
> -				      &priv->domainreg);
> -
> -		ret = set_domain_info_11d(priv);
> -
> -		if (ret) {
> -			lbs_deb_11d("error setting domain info\n");
> -			goto done;
> -		}
> -	}
> -	ret = 0;
> -
> -done:
> -	lbs_deb_leave_args(LBS_DEB_11D, "ret %d", ret);
> -	return ret;
> -}
> -
> -/**
> - *  @brief This function generates 11D info from user specified regioncode and download to FW
> - *  @param priv    pointer to struct lbs_private
> - *  @return 	   0; -1
> - */
> -int lbs_create_dnld_countryinfo_11d(struct lbs_private *priv)
> -{
> -	int ret;
> -	struct region_channel *region_chan;
> -	u8 j;
> -
> -	lbs_deb_enter(LBS_DEB_11D);
> -	lbs_deb_11d("curbssparams.band %d\n", priv->curbssparams.band);
> -
> -	if (priv->enable11d) {
> -		/* update parsed_region_chan_11; dnld domaininf to FW */
> -
> -		for (j = 0; j < ARRAY_SIZE(priv->region_channel); j++) {
> -			region_chan = &priv->region_channel[j];
> -
> -			lbs_deb_11d("%d region_chan->band %d\n", j,
> -			       region_chan->band);
> -
> -			if (!region_chan || !region_chan->valid
> -			    || !region_chan->CFP)
> -				continue;
> -			if (region_chan->band != priv->curbssparams.band)
> -				continue;
> -			break;
> -		}
> -
> -		if (j >= ARRAY_SIZE(priv->region_channel)) {
> -			lbs_deb_11d("region_chan not found, band %d\n",
> -			       priv->curbssparams.band);
> -			ret = -1;
> -			goto done;
> -		}
> -
> -		memset(&priv->parsed_region_chan, 0,
> -		       sizeof(struct parsed_region_chan_11d));
> -		lbs_generate_parsed_region_chan_11d(region_chan,
> -						     &priv->
> -						     parsed_region_chan);
> -
> -		memset(&priv->domainreg, 0,
> -		       sizeof(struct lbs_802_11d_domain_reg));
> -		generate_domain_info_11d(&priv->parsed_region_chan,
> -					 &priv->domainreg);
> -
> -		ret = set_domain_info_11d(priv);
> -
> -		if (ret) {
> -			lbs_deb_11d("error setting domain info\n");
> -			goto done;
> -		}
> -
> -	}
> -	ret = 0;
> -
> -done:
> -	lbs_deb_leave_args(LBS_DEB_11D, "ret %d", ret);
> -	return ret;
> -}
> --- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
> +++ linux-wl/drivers/net/wireless/libertas/cmd.c
> @@ -191,11 +191,6 @@
>  		goto out;
>  	}
>  
> -	if (lbs_set_universaltable(priv, 0)) {
> -		ret = -1;
> -		goto out;
> -	}
> -
>  out:
>  	lbs_deb_leave(LBS_DEB_CMD);
>  	return ret;
> @@ -1512,11 +1507,6 @@
>  		ret = 0;
>  		goto done;
>  
> -	case CMD_802_11D_DOMAIN_INFO:
> -		ret = lbs_cmd_802_11d_domain_info(priv, cmdptr,
> -						   cmd_no, cmd_action);
> -		break;
> -
>  	case CMD_802_11_TPC_CFG:
>  		cmdptr->command = cpu_to_le16(CMD_802_11_TPC_CFG);
>  		cmdptr->size =
> --- linux-wl.orig/drivers/net/wireless/libertas/cmdresp.c
> +++ linux-wl/drivers/net/wireless/libertas/cmdresp.c
> @@ -228,10 +228,6 @@
>  		ret = lbs_ret_802_11_rssi(priv, resp);
>  		break;
>  
> -	case CMD_RET(CMD_802_11D_DOMAIN_INFO):
> -		ret = lbs_ret_802_11d_domain_info(resp);
> -		break;
> -
>  	case CMD_RET(CMD_802_11_TPC_CFG):
>  		spin_lock_irqsave(&priv->driver_lock, flags);
>  		memmove((void *)priv->cur_cmd->callback_arg, &resp->params.tpccfg,
> --- linux-wl.orig/drivers/net/wireless/libertas/dev.h
> +++ linux-wl/drivers/net/wireless/libertas/dev.h
> @@ -325,15 +325,6 @@
>  	/** region channel data */
>  	struct region_channel region_channel[MAX_REGION_CHANNEL_NUM];
>  
> -	struct region_channel universal_channel[MAX_REGION_CHANNEL_NUM];
> -
> -	/** 11D and Domain Regulatory Data */
> -	struct lbs_802_11d_domain_reg domainreg;
> -	struct parsed_region_chan_11d parsed_region_chan;
> -
> -	/** FSM variable for 11d support */
> -	u32 enable11d;
> -
>  	/**	MISCELLANEOUS */
>  	struct lbs_offset_value offsetvalue;
>  
> --- linux-wl.orig/drivers/net/wireless/libertas/Makefile
> +++ linux-wl/drivers/net/wireless/libertas/Makefile
> @@ -1,4 +1,3 @@
> -libertas-y += 11d.o
>  libertas-y += assoc.o
>  libertas-y += cfg.o
>  libertas-y += cmd.o
>  #define CMD_OPTION_WAITFORRSP                   0x0002
> --- linux-wl.orig/drivers/net/wireless/libertas/main.c
> +++ linux-wl/drivers/net/wireless/libertas/main.c
> @@ -1408,9 +1408,6 @@
>  	if (ret)
>  		goto done;
>  
> -	/* init 802.11d */
> -	lbs_init_11d(priv);
> -
>  	if (lbs_cfg_register(priv)) {
>  		lbs_pr_err("cannot register device\n");
>  		goto done;
> 

