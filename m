Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757200AbXK1Vp6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 16:45:58 -0500
Subject: Re: [PATCH] remove numprobes
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <200711281729.37014.hs4233@mail.mn-solutions.de>
References: <200711281729.37014.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 16:40:02 -0500
Message-Id: <1196286002.4967.24.camel@localhost.localdomain> (sfid-20071128_214602_435959_6EABB2EF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-11-28 at 17:29 +0100, Holger Schurig wrote:
> Remove the ability to specify number of probes via debugfs
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: wireless-2.6/drivers/net/wireless/libertas/debugfs.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/debugfs.c	2007-11-28 18:11:47.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/debugfs.c	2007-11-28 18:12:02.000000000 +0100
> @@ -299,23 +299,6 @@ static int lbs_parse_dur(char *buf, size
>  	return val;
>  }
>  
> -static void lbs_parse_probes(char *buf, size_t count,
> -	struct lbs_ioctl_user_scan_cfg *scan_cfg)
> -{
> -	char *hold;
> -	int val;
> -
> -	hold = strstr(buf, "probes=");
> -	if (!hold)
> -		return;
> -	hold += 7;
> -	sscanf(hold, "%d", &val);
> -
> -	scan_cfg->numprobes = val;
> -
> -	return;
> -}
> -
>  static void lbs_parse_type(char *buf, size_t count,
>  	struct lbs_ioctl_user_scan_cfg *scan_cfg)
>  {
> @@ -367,7 +350,6 @@ static ssize_t lbs_setuserscan(struct fi
>  	scan_cfg->clear_bssid = lbs_parse_clear(buf, count, "clear_bssid=");
>  	lbs_parse_ssid(buf, count, scan_cfg);
>  	scan_cfg->clear_ssid = lbs_parse_clear(buf, count, "clear_ssid=");
> -	lbs_parse_probes(buf, count, scan_cfg);
>  	lbs_parse_type(buf, count, scan_cfg);
>  
>  	lbs_scan_networks(priv, scan_cfg, 1);
> Index: wireless-2.6/drivers/net/wireless/libertas/scan.h
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/scan.h	2007-11-28 18:12:16.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/scan.h	2007-11-28 18:12:23.000000000 +0100
> @@ -105,11 +105,6 @@ struct lbs_ioctl_user_scan_cfg {
>       */
>  	u8 bsstype;
>  
> -    /**
> -     *  @brief Configure the number of probe requests for active chan scans
> -     */
> -	u8 numprobes;
> -
>  	/**
>  	 *  @brief BSSID filter sent in the firmware command to limit the results
>  	 */
> Index: wireless-2.6/drivers/net/wireless/libertas/README
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/README	2007-11-28 18:14:13.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/README	2007-11-28 18:14:55.000000000 +0100
> @@ -201,15 +201,14 @@ setuserscan
>        ssid="[SSID]"            specify a SSID filter for the scan
>        keep=[0 or 1]            keep the previous scan results (1), discard (0)
>        dur=[scan time]          time to scan for each channel in milliseconds
> -      probes=[#]               number of probe requests to send on each chan
>        type=[1,2,3]             BSS type: 1 (Infra), 2(Adhoc), 3(Any)
>  
> -    Any combination of the above arguments can be supplied on the command line.
> -      If the chan token is absent, a full channel scan will be completed by
> -      the driver.  If the dur or probes tokens are absent, the driver default
> -      setting will be used.  The bssid and ssid fields, if blank,
> -      will produce an unfiltered scan. The type field will default to 3 (Any)
> -      and the keep field will default to 0 (Discard).
> +    Any combination of the above arguments can be supplied on the command
> +      line.  If the chan token is absent, a full channel scan will be
> +      completed by the driver.  If dur tokens are absent, the driver default
> +      setting will be used.  The bssid and ssid fields, if blank, will
> +      produce an unfiltered scan. The type field will default to 3 (Any) and
> +      the keep field will default to 0 (Discard).
>  
>      Examples:
>      1) Perform an active scan on channels 1, 6, and 11 in the 'g' band:
> @@ -230,10 +229,10 @@ setuserscan
>         the current scan table intact, update existing or append new scan data:
>              echo "bssid=00:50:43:20:12:82 keep=1" > setuserscan
>  
> -    6) Scan channel 6, for all infrastructure networks, sending two probe
> -       requests.  Keep the previous scan table intact. Update any duplicate
> -       BSSID/SSID matches with the new scan data:
> -            echo "chan=6g type=1 probes=2 keep=1" > setuserscan
> +    6) Scan channel 6, for all infrastructure networks.
> +       Keep the previous scan table intact. Update any duplicate BSSID/SSID
> +       matches with the new scan data:
> +            echo "chan=6g type=1 keep=1" > setuserscan
>  
>      All entries in the scan table (not just the new scan data when keep=1)
>      will be displayed upon completion by use of the getscantable ioctl.
> Index: wireless-2.6/drivers/net/wireless/libertas/scan.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/scan.c	2007-11-28 18:13:06.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/scan.c	2007-11-28 18:13:48.000000000 +0100
> @@ -41,7 +41,6 @@
>  
>  //! Maximum memory needed for a lbs_scan_cmd_config with all TLVs at max
>  #define MAX_SCAN_CFG_ALLOC (sizeof(struct lbs_scan_cmd_config)  \
> -                            + sizeof(struct mrvlietypes_numprobes)   \
>                              + CHAN_TLV_MAX_SIZE                 \
>                              + SSID_TLV_MAX_SIZE)
>  
> @@ -384,7 +383,6 @@ void lbs_scan_worker(struct work_struct 
>   *             - channel list
>   *
>   *  If the SSID or BSSID filter is not present, disable/clear the filter.
> - *  If the number of probes is not set, use the adapter default setting
>   *  Qualify the channel
>   *
>   *  @param priv             A pointer to struct lbs_private structure
> @@ -414,11 +412,9 @@ lbs_scan_setup_scan_config(struct lbs_pr
>  			    u8 * pfilteredscan,
>  			    u8 * pscancurrentonly)
>  {
> -	struct mrvlietypes_numprobes *pnumprobestlv;
>  	struct mrvlietypes_ssidparamset *pssidtlv;
>  	struct lbs_scan_cmd_config *pscancfgout = NULL;
>  	u8 *ptlvpos;
> -	u16 numprobes;
>  	int chanidx;
>  	int scantype;
>  	int scandur;
> @@ -467,9 +463,6 @@ lbs_scan_setup_scan_config(struct lbs_pr
>  		pscancfgout->bsstype =
>  		    puserscanin->bsstype ? puserscanin->bsstype : CMD_BSS_TYPE_ANY;
>  
> -		/* Set the number of probes to send, use adapter setting if unset */
> -		numprobes = puserscanin->numprobes ? puserscanin->numprobes : 0;
> -
>  		/*
>  		 * Set the BSSID filter to the incoming configuration,
>  		 *   if non-zero.  If not set, it will remain disabled (all zeros).
> @@ -501,22 +494,11 @@ lbs_scan_setup_scan_config(struct lbs_pr
>  		}
>  	} else {
>  		pscancfgout->bsstype = CMD_BSS_TYPE_ANY;
> -		numprobes = 0;
> -	}
> -
> -	/* If the input config or adapter has the number of Probes set, add tlv */
> -	if (numprobes) {
> -		pnumprobestlv = (struct mrvlietypes_numprobes *) ptlvpos;
> -		pnumprobestlv->header.type = cpu_to_le16(TLV_TYPE_NUMPROBES);
> -		pnumprobestlv->header.len = cpu_to_le16(2);
> -		pnumprobestlv->numprobes = cpu_to_le16(numprobes);
> -
> -		ptlvpos += sizeof(*pnumprobestlv);
>  	}
>  
>  	/*
>  	 * Set the output for the channel TLV to the address in the tlv buffer
> -	 *   past any TLVs that were added in this fuction (SSID, numprobes).
> +	 *   past any TLVs that were added in this fuction (SSID).
>  	 *   channel TLVs will be added past this for each scan command, preserving
>  	 *   the TLVs that were previously added.
>  	 */

