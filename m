Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758159AbYCSTnk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:43:40 -0400
Subject: Re: [RFC] libertas: change quality calculation
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <200803181510.52726.hs4233@mail.mn-solutions.de>
References: <200803181510.52726.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 19 Mar 2008 10:45:28 -0400
Message-Id: <1205937928.26119.29.camel@localhost.localdomain> (sfid-20080319_194451_261947_293B7B64)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-03-18 at 15:10 +0100, Holger Schurig wrote:
> I wasn't really satisfied with a graphical program that displayed
> the link quality, the display was bit erratically. While changing
> this, I noticed some other things which this and the next patch
> addresses.
> 
> However, for this patch I'm not sure if it goes into the right
> direction.
> 
> 
> This changes the quality calculation for wireless statistics to
> only consider signal & noise, but not number of tx-retries.
> Also changes a the rather complicated formular for quality to be
> more like http://www.ces.clemson.edu/linux/signal_quality.shtml.
> 
> Note that tx_retries are no longer used for the quality number. I
> don't know of any other driver that does it, and tx_retries is
> only increasing, so the quality would become smaller and 
> smaller ...  which wouldn't reflect reality.

I actually tried to emulate the ipw2200 quality calculations, and of
course may have made some mistakes.  The ipw2200 uses a combination of
things to indicate quality, txretries being one of them.  I still think
txretries is a good thing to include, because if you have to keep
retrying then something is definitely wrong.  However, it should
probably be a running average of the retries over the last 20 or 30
seconds or something, which was my mistake.

> Questionable things:
> 
> I also found that the average noise floor is -86 dBm, not -96
> dBm. So I changed this constant. Maybe this is wrong, what values 
> do your cards report?

When possible, we should use a window-ed average of the cards reported
noise from beacons or received frames instead of a constant, that's a
further improvement though.

> The wireless stats have SNR and noise floor to calcutate the
> quality. However, the scanning logic (for "iwlist XXX scan") only
> has a not-really-described dimensionless RSSI value. So the 

Well, when we had the (badly) averaged array values in there, the noise
floor was available to the scan reporting.  There are tables to map RSSI
-> dBm for each part which should be in the firmware spec or seen in the
driver code.  We should definitely be using averaged noise floor and the
RSSI converted to dBm/SNR in the scan function.

> quality display for both outputs are a bit different, althought 
> not too much. I don't know any good method, not even from above 
> website, that would make both calculation results identical. 
> However, this was also not the case with the old code.

We can't really make the identical since we can't use the received
frames quality indicators when doing scan results, but we could as I
said above use the converted RSSI and the averaged noise floor.

Dan

> 
> Index: wireless-testing/drivers/net/wireless/libertas/wext.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/wext.c	
> 2008-03-18 13:42:42.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/wext.c	
> 2008-03-18 13:42:55.000000000 +0100
> @@ -805,21 +805,8 @@ out:
>  
>  static struct iw_statistics *lbs_get_wireless_stats(struct 
> net_device *dev)
>  {
> -	enum {
> -		POOR = 30,
> -		FAIR = 60,
> -		GOOD = 80,
> -		VERY_GOOD = 90,
> -		EXCELLENT = 95,
> -		PERFECT = 100
> -	};
>  	struct lbs_private *priv = dev->priv;
> -	u32 rssi_qual;
> -	u32 tx_qual;
> -	u32 quality = 0;
>  	int stats_valid = 0;
> -	u8 rssi;
> -	u32 tx_retries;
>  	struct cmd_ds_802_11_get_log log;
>  	u16 snr, nf;
>  
> @@ -838,24 +825,6 @@ static struct iw_statistics *lbs_get_wir
>  	priv->wstats.qual.level = CAL_RSSI(snr, nf);
>  	priv->wstats.qual.noise = CAL_NF(nf);
>  
> -	lbs_deb_wext("signal level %#x\n", priv->wstats.qual.level);
> -	lbs_deb_wext("noise %#x\n", priv->wstats.qual.noise);
> -
> -	rssi = priv->wstats.qual.level - priv->wstats.qual.noise;
> -	if (rssi < 15)
> -		rssi_qual = rssi * POOR / 10;
> -	else if (rssi < 20)
> -		rssi_qual = (rssi - 15) * (FAIR - POOR) / 5 + POOR;
> -	else if (rssi < 30)
> -		rssi_qual = (rssi - 20) * (GOOD - FAIR) / 5 + FAIR;
> -	else if (rssi < 40)
> -		rssi_qual = (rssi - 30) * (VERY_GOOD - GOOD) /
> -		    10 + GOOD;
> -	else
> -		rssi_qual = (rssi - 40) * (PERFECT - VERY_GOOD) /
> -		    10 + VERY_GOOD;
> -	quality = rssi_qual;
> -
>  	/* Quality by TX errors */
>  	priv->wstats.discard.retries = priv->stats.tx_errors;
>  
> @@ -863,28 +832,19 @@ static struct iw_statistics *lbs_get_wir
>  	log.hdr.size = cpu_to_le16(sizeof(log));
>  	lbs_cmd_with_response(priv, CMD_802_11_GET_LOG, &log);
>  
> -	tx_retries = le32_to_cpu(log.retry);
> -
> -	if (tx_retries > 75)
> -		tx_qual = (90 - tx_retries) * POOR / 15;
> -	else if (tx_retries > 70)
> -		tx_qual = (75 - tx_retries) * (FAIR - POOR) / 5 + POOR;
> -	else if (tx_retries > 65)
> -		tx_qual = (70 - tx_retries) * (GOOD - FAIR) / 5 + FAIR;
> -	else if (tx_retries > 50)
> -		tx_qual = (65 - tx_retries) * (VERY_GOOD - GOOD) /
> -		    15 + GOOD;
> -	else
> -		tx_qual = (50 - tx_retries) *
> -		    (PERFECT - VERY_GOOD) / 50 + VERY_GOOD;
> -	quality = min(quality, tx_qual);
> -
>  	priv->wstats.discard.code = le32_to_cpu(log.wepundecryptable);
> -	priv->wstats.discard.retries = tx_retries;
> +	priv->wstats.discard.retries = le32_to_cpu(log.retry);
>  	priv->wstats.discard.misc = le32_to_cpu(log.ackfailure);
>  
>  	/* Calculate quality */
> -	priv->wstats.qual.qual = min_t(u8, quality, 100);
> +	/* see http://www.ces.clemson.edu/linux/signal_quality.shtml */
> +	snr = priv->wstats.qual.level  - priv->wstats.qual.noise;
> +	if (snr <= 0)
> +		priv->wstats.qual.qual = 0;
> +	else if (snr >= 40)
> +		priv->wstats.qual.qual = 100;
> +	else
> +		priv->wstats.qual.qual = 5*snr/2;
>  	priv->wstats.qual.updated = IW_QUAL_ALL_UPDATED | IW_QUAL_DBM;
>  	stats_valid = 1;
>  
> Index: wireless-testing/drivers/net/wireless/libertas/defs.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/defs.h	
> 2008-03-18 13:42:42.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/defs.h	
> 2008-03-18 13:42:55.000000000 +0100
> @@ -208,12 +208,9 @@ static inline void lbs_deb_hex(unsigned 
>  #define RxPD_MESH_FRAME RxPD_CONTROL_WDS_FRAME
>  
>  /** RSSI-related defines */
> -/*	RSSI constants are used to implement 802.11 RSSI threshold
> -*	indication. if the Rx packet signal got too weak for 5 
> consecutive
> -*	times, miniport driver (driver) will report this event to 
> wrapper
> -*/
>  
> -#define MRVDRV_NF_DEFAULT_SCAN_VALUE		(-96)
> +/* This is the average noise level */
> +#define MRVDRV_NF_DEFAULT_SCAN_VALUE		(-86)
>  
>  /** RTS/FRAG related defines */
>  #define MRVDRV_RTS_MIN_VALUE		0

