Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbXLDQ6m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 11:58:42 -0500
Subject: Re: [PATCH] libertas: implement new scanning logic
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <200711290927.15915.hs4233@mail.mn-solutions.de>
References: <200711290927.15915.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 11:52:09 -0500
Message-Id: <1196787130.4772.2.camel@localhost.localdomain> (sfid-20071204_165846_769253_3C3BBE6A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-11-29 at 09:27 +0100, Holger Schurig wrote:
> This changes the code that is used for scanning and makes it hopefully
> easier to understand:
> 
> * move function into logical blocks
> * create a bunch of lbs_scan_add_XXXX_tlv() functions, that
>   help to create the TLV parameter of CMD_802_11_SCAN
> * all of them are now called from the much simpler lbs_do_scan()
> * no **puserscancfg double-pointers :-)
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

So I tested this one, not the one from libertas-dev (which was posted a
day earlier).  And this one seems fine.  Ack for commit to libertas-2.6.

Would you like me to confirm on SDIO?

Dan

> Index: wireless-2.6/drivers/net/wireless/libertas/scan.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/scan.c	2007-11-29 10:01:07.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/scan.c	2007-11-29 10:26:07.000000000 +0100
> @@ -79,6 +79,22 @@ static inline void clear_bss_descriptor 
>  	memset(bss, 0, offsetof(struct bss_descriptor, list));
>  }
>  
> +/**
> + *  @brief Compare two SSIDs
> + *
> + *  @param ssid1    A pointer to ssid to compare
> + *  @param ssid2    A pointer to ssid to compare
> + *
> + *  @return         0: ssid is same, otherwise is different
> + */
> +int lbs_ssid_cmp(u8 *ssid1, u8 ssid1_len, u8 *ssid2, u8 ssid2_len)
> +{
> +	if (ssid1_len != ssid2_len)
> +		return -1;
> +
> +	return memcmp(ssid1, ssid2, ssid1_len);
> +}
> +
>  static inline int match_bss_no_security(struct lbs_802_11_security *secinfo,
>  			struct bss_descriptor * match_bss)
>  {
> @@ -149,6 +165,18 @@ static inline int match_bss_dynamic_wep(
>  	return 0;
>  }
>  
> +static inline int is_same_network(struct bss_descriptor *src,
> +				  struct bss_descriptor *dst)
> +{
> +	/* A network is only a duplicate if the channel, BSSID, and ESSID
> +	 * all match.  We treat all <hidden> with the same BSSID and channel
> +	 * as one network */
> +	return ((src->ssid_len == dst->ssid_len) &&
> +		(src->channel == dst->channel) &&
> +		!compare_ether_addr(src->bssid, dst->bssid) &&
> +		!memcmp(src->ssid, dst->ssid, src->ssid_len));
> +}
> +
>  /**
>   *  @brief Check if a scanned network compatible with the driver settings
>   *
> @@ -184,9 +212,9 @@ static int is_network_compatible(struct 
>  		goto done;
>  	} else if ((matched = match_bss_wpa(&adapter->secinfo, bss))) {
>  		lbs_deb_scan(
> -		       "is_network_compatible() WPA: wpa_ie=%#x "
> -		       "wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s "
> -		       "privacy=%#x\n", bss->wpa_ie[0], bss->rsn_ie[0],
> +		       "is_network_compatible() WPA: wpa_ie 0x%x "
> +		       "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s "
> +		       "privacy 0x%x\n", bss->wpa_ie[0], bss->rsn_ie[0],
>  		       adapter->secinfo.wep_enabled ? "e" : "d",
>  		       adapter->secinfo.WPAenabled ? "e" : "d",
>  		       adapter->secinfo.WPA2enabled ? "e" : "d",
> @@ -194,9 +222,9 @@ static int is_network_compatible(struct 
>  		goto done;
>  	} else if ((matched = match_bss_wpa2(&adapter->secinfo, bss))) {
>  		lbs_deb_scan(
> -		       "is_network_compatible() WPA2: wpa_ie=%#x "
> -		       "wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s "
> -		       "privacy=%#x\n", bss->wpa_ie[0], bss->rsn_ie[0],
> +		       "is_network_compatible() WPA2: wpa_ie 0x%x "
> +		       "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s "
> +		       "privacy 0x%x\n", bss->wpa_ie[0], bss->rsn_ie[0],
>  		       adapter->secinfo.wep_enabled ? "e" : "d",
>  		       adapter->secinfo.WPAenabled ? "e" : "d",
>  		       adapter->secinfo.WPA2enabled ? "e" : "d",
> @@ -205,7 +233,7 @@ static int is_network_compatible(struct 
>  	} else if ((matched = match_bss_dynamic_wep(&adapter->secinfo, bss))) {
>  		lbs_deb_scan(
>  		       "is_network_compatible() dynamic WEP: "
> -		       "wpa_ie=%#x wpa2_ie=%#x privacy=%#x\n",
> +		       "wpa_ie 0x%x wpa2_ie 0x%x privacy 0x%x\n",
>  		       bss->wpa_ie[0], bss->rsn_ie[0],
>  		       (bss->capability & WLAN_CAPABILITY_PRIVACY));
>  		goto done;
> @@ -213,8 +241,8 @@ static int is_network_compatible(struct 
>  
>  	/* bss security settings don't match those configured on card */
>  	lbs_deb_scan(
> -	       "is_network_compatible() FAILED: wpa_ie=%#x "
> -	       "wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s privacy=%#x\n",
> +	       "is_network_compatible() FAILED: wpa_ie 0x%x "
> +	       "wpa2_ie 0x%x WEP %s WPA %s WPA2 %s privacy 0x%x\n",
>  	       bss->wpa_ie[0], bss->rsn_ie[0],
>  	       adapter->secinfo.wep_enabled ? "e" : "d",
>  	       adapter->secinfo.WPAenabled ? "e" : "d",
> @@ -226,22 +254,6 @@ done:
>  	return matched;
>  }
>  
> -/**
> - *  @brief Compare two SSIDs
> - *
> - *  @param ssid1    A pointer to ssid to compare
> - *  @param ssid2    A pointer to ssid to compare
> - *
> - *  @return         0--ssid is same, otherwise is different
> - */
> -int lbs_ssid_cmp(u8 *ssid1, u8 ssid1_len, u8 *ssid2, u8 ssid2_len)
> -{
> -	if (ssid1_len != ssid2_len)
> -		return -1;
> -
> -	return memcmp(ssid1, ssid2, ssid1_len);
> -}
> -
>  
> 
> 
> @@ -251,6 +263,16 @@ int lbs_ssid_cmp(u8 *ssid1, u8 ssid1_len
>  /*                                                                   */
>  /*********************************************************************/
>  
> +void lbs_scan_worker(struct work_struct *work)
> +{
> +	struct lbs_private *priv =
> +		container_of(work, struct lbs_private, scan_work.work);
> +
> +	lbs_deb_enter(LBS_DEB_SCAN);
> +	lbs_scan_networks(priv, NULL, 0);
> +	lbs_deb_leave(LBS_DEB_SCAN);
> +}
> +
>  
>  /**
>   *  @brief Create a channel list for the driver to scan based on region info
> @@ -271,7 +293,7 @@ int lbs_ssid_cmp(u8 *ssid1, u8 ssid1_len
>   *
>   *  @return              void
>   */
> -static void lbs_scan_create_channel_list(struct lbs_private *priv,
> +static int lbs_scan_create_channel_list(struct lbs_private *priv,
>  					  struct chanscanparamset * scanchanlist,
>  					  u8 filteredscan)
>  {
> @@ -284,8 +306,6 @@ static void lbs_scan_create_channel_list
>  	int nextchan;
>  	u8 scantype;
>  
> -	lbs_deb_enter_args(LBS_DEB_SCAN, "filteredscan %d", filteredscan);
> -
>  	chanidx = 0;
>  
>  	/* Set the default scan type to the user specified type, will later
> @@ -352,383 +372,147 @@ static void lbs_scan_create_channel_list
>  			}
>  		}
>  	}
> +	return chanidx;
>  }
>  
> 
> -/* Delayed partial scan worker */
> -void lbs_scan_worker(struct work_struct *work)
> +/*
> + * Add SSID TLV of the form:
> + *
> + * TLV-ID SSID     00 00
> + * length          06 00
> + * ssid            4d 4e 54 45 53 54
> + */
> +static int lbs_scan_add_ssid_tlv(u8 *tlv,
> +	const struct lbs_ioctl_user_scan_cfg *user_cfg)
>  {
> -	struct lbs_private *priv = container_of(work,
> -		struct lbs_private,
> -		scan_work.work);
> -
> -	lbs_scan_networks(priv, NULL, 0);
> +	struct mrvlietypes_ssidparamset *ssid_tlv =
> +		(struct mrvlietypes_ssidparamset *)tlv;
> +	ssid_tlv->header.type = cpu_to_le16(TLV_TYPE_SSID);
> +	ssid_tlv->header.len = cpu_to_le16(user_cfg->ssid_len);
> +	memcpy(ssid_tlv->ssid, user_cfg->ssid, user_cfg->ssid_len);
> +	return sizeof(ssid_tlv->header) + user_cfg->ssid_len;
>  }
>  
> 
> -/**
> - *  @brief Construct a lbs_scan_cmd_config structure to use in issue scan cmds
> - *
> - *  Application layer or other functions can invoke lbs_scan_networks
> - *    with a scan configuration supplied in a lbs_ioctl_user_scan_cfg struct.
> - *    This structure is used as the basis of one or many lbs_scan_cmd_config
> - *    commands that are sent to the command processing module and sent to
> - *    firmware.
> - *
> - *  Create a lbs_scan_cmd_config based on the following user supplied
> - *    parameters (if present):
> - *             - SSID filter
> - *             - BSSID filter
> - *             - Number of Probes to be sent
> - *             - channel list
> - *
> - *  If the SSID or BSSID filter is not present, disable/clear the filter.
> - *  Qualify the channel
> +/*
> + * Add CHANLIST TLV of the form
>   *
> - *  @param priv             A pointer to struct lbs_private structure
> - *  @param puserscanin      NULL or pointer to scan configuration parameters
> - *  @param ppchantlvout     Output parameter: Pointer to the start of the
> - *                          channel TLV portion of the output scan config
> - *  @param pscanchanlist    Output parameter: Pointer to the resulting channel
> - *                          list to scan
> - *  @param pmaxchanperscan  Output parameter: Number of channels to scan for
> - *                          each issuance of the firmware scan command
> - *  @param pfilteredscan    Output parameter: Flag indicating whether or not
> - *                          a BSSID or SSID filter is being sent in the
> - *                          command to firmware.  Used to increase the number
> - *                          of channels sent in a scan command and to
> - *                          disable the firmware channel scan filter.
> - *  @param pscancurrentonly Output parameter: Flag indicating whether or not
> - *                          we are only scanning our current active channel
> + * TLV-ID CHANLIST 01 01
> + * length          5b 00
> + * channel 1       00 01 00 00 00 64 00
> + *   radio type    00
> + *   channel          01
> + *   scan type           00
> + *   min scan time          00 00
> + *   max scan time                64 00
> + * channel 2       00 02 00 00 00 64 00
> + * channel 3       00 03 00 00 00 64 00
> + * channel 4       00 04 00 00 00 64 00
> + * channel 5       00 05 00 00 00 64 00
> + * channel 6       00 06 00 00 00 64 00
> + * channel 7       00 07 00 00 00 64 00
> + * channel 8       00 08 00 00 00 64 00
> + * channel 9       00 09 00 00 00 64 00
> + * channel 10      00 0a 00 00 00 64 00
> + * channel 11      00 0b 00 00 00 64 00
> + * channel 12      00 0c 00 00 00 64 00
> + * channel 13      00 0d 00 00 00 64 00
>   *
> - *  @return                 resulting scan configuration
>   */
> -static struct lbs_scan_cmd_config *
> -lbs_scan_setup_scan_config(struct lbs_private *priv,
> -			    const struct lbs_ioctl_user_scan_cfg *puserscanin,
> -			    struct mrvlietypes_chanlistparamset ** ppchantlvout,
> -			    struct chanscanparamset * pscanchanlist,
> -			    int *pmaxchanperscan,
> -			    u8 * pfilteredscan,
> -			    u8 * pscancurrentonly)
> +static int lbs_scan_add_chanlist_tlv(u8 *tlv,
> +	struct chanscanparamset *chan_list,
> +	int chan_count)
>  {
> -	struct mrvlietypes_ssidparamset *pssidtlv;
> -	struct lbs_scan_cmd_config *pscancfgout = NULL;
> -	u8 *ptlvpos;
> -
> -	lbs_deb_enter(LBS_DEB_SCAN);
> -
> -	pscancfgout = kzalloc(MAX_SCAN_CFG_ALLOC, GFP_KERNEL);
> -	if (pscancfgout == NULL)
> -		goto out;
> -
> -	/* The tlvbufferlen is calculated for each scan command.  The TLVs added
> -	 *   in this routine will be preserved since the routine that sends
> -	 *   the command will append channelTLVs at *ppchantlvout.  The difference
> -	 *   between the *ppchantlvout and the tlvbuffer start will be used
> -	 *   to calculate the size of anything we add in this routine.
> -	 */
> -	pscancfgout->tlvbufferlen = 0;
> -
> -	/* Running tlv pointer.  Assigned to ppchantlvout at end of function
> -	 *  so later routines know where channels can be added to the command buf
> -	 */
> -	ptlvpos = pscancfgout->tlvbuffer;
> -
> -	/*
> -	 * Set the initial scan paramters for progressive scanning.  If a specific
> -	 *   BSSID or SSID is used, the number of channels in the scan command
> -	 *   will be increased to the absolute maximum
> -	 */
> -	*pmaxchanperscan = MRVDRV_CHANNELS_PER_SCAN_CMD;
> -
> -	/* Initialize the scan as un-filtered by firmware, set to TRUE below if
> -	 *   a SSID or BSSID filter is sent in the command
> -	 */
> -	*pfilteredscan = 0;
> -
> -	/* Initialize the scan as not being only on the current channel.  If
> -	 *   the channel list is customized, only contains one channel, and
> -	 *   is the active channel, this is set true and data flow is not halted.
> -	 */
> -	*pscancurrentonly = 0;
> -
> -	if (puserscanin) {
> -		/* Set the bss type scan filter, use adapter setting if unset */
> -		pscancfgout->bsstype =
> -		    puserscanin->bsstype ? puserscanin->bsstype : CMD_BSS_TYPE_ANY;
> -
> -		/*
> -		 * Set the BSSID filter to the incoming configuration,
> -		 *   if non-zero.  If not set, it will remain disabled (all zeros).
> -		 */
> -		memcpy(pscancfgout->bssid, puserscanin->bssid,
> -		       sizeof(pscancfgout->bssid));
> -
> -		if (puserscanin->ssid_len) {
> -			pssidtlv =
> -			    (struct mrvlietypes_ssidparamset *) pscancfgout->
> -			    tlvbuffer;
> -			pssidtlv->header.type = cpu_to_le16(TLV_TYPE_SSID);
> -			pssidtlv->header.len = cpu_to_le16(puserscanin->ssid_len);
> -			memcpy(pssidtlv->ssid, puserscanin->ssid,
> -			       puserscanin->ssid_len);
> -			ptlvpos += sizeof(pssidtlv->header) + puserscanin->ssid_len;
> -		}
> -
> -		/*
> -		 *  The default number of channels sent in the command is low to
> -		 *    ensure the response buffer from the firmware does not truncate
> -		 *    scan results.  That is not an issue with an SSID or BSSID
> -		 *    filter applied to the scan results in the firmware.
> -		 */
> -		if (   puserscanin->ssid_len
> -		    || (compare_ether_addr(pscancfgout->bssid, &zeromac[0]) != 0)) {
> -			*pmaxchanperscan = MRVDRV_MAX_CHANNELS_PER_SCAN;
> -			*pfilteredscan = 1;
> -		}
> -	} else {
> -		pscancfgout->bsstype = CMD_BSS_TYPE_ANY;
> -	}
> -
> -	/*
> -	 * Set the output for the channel TLV to the address in the tlv buffer
> -	 *   past any TLVs that were added in this fuction (SSID).
> -	 *   channel TLVs will be added past this for each scan command, preserving
> -	 *   the TLVs that were previously added.
> -	 */
> -	*ppchantlvout = (struct mrvlietypes_chanlistparamset *) ptlvpos;
> +	size_t size = sizeof(struct chanscanparamset) * chan_count;
> +	struct mrvlietypes_chanlistparamset *chan_tlv =
> +		(struct mrvlietypes_chanlistparamset *) tlv;
>  
> -	lbs_scan_create_channel_list(priv, pscanchanlist,
> -				      *pfilteredscan);
> -out:
> -	return pscancfgout;
> +	chan_tlv->header.type = cpu_to_le16(TLV_TYPE_CHANLIST);
> +	memcpy(chan_tlv->chanscanparam, chan_list, size);
> +	chan_tlv->header.len = cpu_to_le16(size);
> +	return sizeof(chan_tlv->header) + size;
>  }
>  
> -/**
> - *  @brief Construct and send multiple scan config commands to the firmware
> - *
> - *  Only used from lbs_scan_networks()
> - *
> - *  Previous routines have created a lbs_scan_cmd_config with any requested
> - *   TLVs.  This function splits the channel TLV into maxchanperscan lists
> - *   and sends the portion of the channel TLV along with the other TLVs
> - *   to the lbs_cmd routines for execution in the firmware.
> +
> +/*
> + * Add RATES TLV of the form
>   *
> - *  @param priv            A pointer to struct lbs_private structure
> - *  @param maxchanperscan  Maximum number channels to be included in each
> - *                         scan command sent to firmware
> - *  @param filteredscan    Flag indicating whether or not a BSSID or SSID
> - *                         filter is being used for the firmware command
> - *                         scan command sent to firmware
> - *  @param pscancfgout     Scan configuration used for this scan.
> - *  @param pchantlvout     Pointer in the pscancfgout where the channel TLV
> - *                         should start.  This is past any other TLVs that
> - *                         must be sent down in each firmware command.
> - *  @param pscanchanlist   List of channels to scan in maxchanperscan segments
> + * TLV-ID RATES    01 00
> + * length          0e 00
> + * rates           82 84 8b 96 0c 12 18 24 30 48 60 6c
>   *
> - *  @return                0 or error return otherwise
> + * The rates are in lbs_bg_rates[], but for the 802.11b
> + * rates the high bit isn't set.
>   */
> -static int lbs_scan_channel_list(struct lbs_private *priv,
> -				  int maxchanperscan,
> -				  u8 filteredscan,
> -				  struct lbs_scan_cmd_config *pscancfgout,
> -				  struct mrvlietypes_chanlistparamset * pchantlvout,
> -				  struct chanscanparamset * pscanchanlist,
> -				  const struct lbs_ioctl_user_scan_cfg *puserscanin,
> -				  int full_scan)
> +static int lbs_scan_add_rates_tlv(u8 *tlv)
>  {
> -	struct chanscanparamset *ptmpchan;
> -	struct chanscanparamset *pstartchan;
> -	u8 scanband;
> -	int doneearly;
> -	int tlvidx;
> -	int ret = 0;
> -	int scanned = 0;
> -	union iwreq_data wrqu;
> -
> -	lbs_deb_enter_args(LBS_DEB_SCAN, "maxchanperscan %d, filteredscan %d, "
> -		"full_scan %d", maxchanperscan, filteredscan, full_scan);
> -
> -	if (!pscancfgout || !pchantlvout || !pscanchanlist) {
> -		lbs_deb_scan("pscancfgout, pchantlvout or "
> -			"pscanchanlist is NULL\n");
> -		ret = -1;
> -		goto out;
> -	}
> -
> -	pchantlvout->header.type = cpu_to_le16(TLV_TYPE_CHANLIST);
> -
> -	/* Set the temp channel struct pointer to the start of the desired list */
> -	ptmpchan = pscanchanlist;
> -
> -	if (priv->adapter->last_scanned_channel && !puserscanin)
> -		ptmpchan += priv->adapter->last_scanned_channel;
> -
> -	/* Loop through the desired channel list, sending a new firmware scan
> -	 *   commands for each maxchanperscan channels (or for 1,6,11 individually
> -	 *   if configured accordingly)
> -	 */
> -	while (ptmpchan->channumber) {
> -
> -		tlvidx = 0;
> -		pchantlvout->header.len = 0;
> -		scanband = ptmpchan->radiotype;
> -		pstartchan = ptmpchan;
> -		doneearly = 0;
> -
> -		/* Construct the channel TLV for the scan command.  Continue to
> -		 *  insert channel TLVs until:
> -		 *    - the tlvidx hits the maximum configured per scan command
> -		 *    - the next channel to insert is 0 (end of desired channel list)
> -		 *    - doneearly is set (controlling individual scanning of 1,6,11)
> -		 */
> -		while (tlvidx < maxchanperscan && ptmpchan->channumber
> -		       && !doneearly && scanned < 2) {
> -
> -			lbs_deb_scan("channel %d, radio %d, passive %d, "
> -				"dischanflt %d, maxscantime %d\n",
> -				ptmpchan->channumber,
> -				ptmpchan->radiotype,
> -			             ptmpchan->chanscanmode.passivescan,
> -			             ptmpchan->chanscanmode.disablechanfilt,
> -			             ptmpchan->maxscantime);
> -
> -			/* Copy the current channel TLV to the command being prepared */
> -			memcpy(pchantlvout->chanscanparam + tlvidx,
> -			       ptmpchan, sizeof(pchantlvout->chanscanparam));
> -
> -			/* Increment the TLV header length by the size appended */
> -			/* Ew, it would be _so_ nice if we could just declare the
> -			   variable little-endian and let GCC handle it for us */
> -			pchantlvout->header.len =
> -				cpu_to_le16(le16_to_cpu(pchantlvout->header.len) +
> -					    sizeof(pchantlvout->chanscanparam));
> -
> -			/*
> -			 *  The tlv buffer length is set to the number of bytes of the
> -			 *    between the channel tlv pointer and the start of the
> -			 *    tlv buffer.  This compensates for any TLVs that were appended
> -			 *    before the channel list.
> -			 */
> -			pscancfgout->tlvbufferlen = ((u8 *) pchantlvout
> -						     - pscancfgout->tlvbuffer);
> -
> -			/*  Add the size of the channel tlv header and the data length */
> -			pscancfgout->tlvbufferlen +=
> -			    (sizeof(pchantlvout->header)
> -			     + le16_to_cpu(pchantlvout->header.len));
> -
> -			/* Increment the index to the channel tlv we are constructing */
> -			tlvidx++;
> -
> -			doneearly = 0;
> -
> -			/* Stop the loop if the *current* channel is in the 1,6,11 set
> -			 *   and we are not filtering on a BSSID or SSID.
> -			 */
> -			if (!filteredscan && (ptmpchan->channumber == 1
> -					      || ptmpchan->channumber == 6
> -					      || ptmpchan->channumber == 11)) {
> -				doneearly = 1;
> -			}
> -
> -			/* Increment the tmp pointer to the next channel to be scanned */
> -			ptmpchan++;
> -			scanned++;
> -
> -			/* Stop the loop if the *next* channel is in the 1,6,11 set.
> -			 *  This will cause it to be the only channel scanned on the next
> -			 *  interation
> -			 */
> -			if (!filteredscan && (ptmpchan->channumber == 1
> -					      || ptmpchan->channumber == 6
> -					      || ptmpchan->channumber == 11)) {
> -				doneearly = 1;
> -			}
> -		}
> -
> -		/* Send the scan command to the firmware with the specified cfg */
> -		ret = lbs_prepare_and_send_command(priv, CMD_802_11_SCAN, 0,
> -					    0, 0, pscancfgout);
> -		if (scanned >= 2 && !full_scan) {
> -			ret = 0;
> -			goto done;
> -		}
> -		scanned = 0;
> -	}
> -
> -done:
> -	priv->adapter->last_scanned_channel = ptmpchan->channumber;
> +	int i;
> +	struct mrvlietypes_ratesparamset *rate_tlv =
> +		(struct mrvlietypes_ratesparamset *) tlv;
>  
> -	if (priv->adapter->last_scanned_channel) {
> -		/* Schedule the next part of the partial scan */
> -		if (!full_scan && !priv->adapter->surpriseremoved) {
> -			cancel_delayed_work(&priv->scan_work);
> -			queue_delayed_work(priv->work_thread, &priv->scan_work,
> -			                   msecs_to_jiffies(300));
> -		}
> -	} else {
> -		/* All done, tell userspace the scan table has been updated */
> -		memset(&wrqu, 0, sizeof(union iwreq_data));
> -		wireless_send_event(priv->dev, SIOCGIWSCAN, &wrqu, NULL);
> +	rate_tlv->header.type = cpu_to_le16(TLV_TYPE_RATES);
> +	tlv += sizeof(rate_tlv->header);
> +	for (i = 0; i < MAX_RATES; i++) {
> +		*tlv = lbs_bg_rates[i];
> +		if (*tlv == 0)
> +			break;
> +		if (*tlv == 0x02 || *tlv == 0x04 ||
> +		    *tlv == 0x0b || *tlv == 0x16)
> +			*tlv |= 0x80;
> +		tlv++;
>  	}
> -
> -out:
> -	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
> -	return ret;
> +	rate_tlv->header.len = i;
> +	return sizeof(rate_tlv->header) + i;
>  }
>  
> +
>  /*
> - * Only used from lbs_scan_networks()
> -*/
> -static void clear_selected_scan_list_entries(struct lbs_adapter *adapter,
> -	const struct lbs_ioctl_user_scan_cfg *scan_cfg)
> + * Generate the CMD_802_11_SCAN command with the proper tlv
> + * for a bunch of channels.
> + */
> +static int lbs_do_scan(struct lbs_private *priv,
> +	u8 bsstype,
> +	struct chanscanparamset *chan_list,
> +	int chan_count,
> +	const struct lbs_ioctl_user_scan_cfg *user_cfg)
>  {
> -	struct bss_descriptor *bss;
> -	struct bss_descriptor *safe;
> -	u32 clear_ssid_flag = 0, clear_bssid_flag = 0;
> -
> -	lbs_deb_enter(LBS_DEB_SCAN);
> -
> -	if (!scan_cfg)
> -		goto out;
> -
> -	if (scan_cfg->clear_ssid && scan_cfg->ssid_len)
> -		clear_ssid_flag = 1;
> +	int ret = -ENOMEM;
> +	struct lbs_scan_cmd_config *scan_cmd;
> +	u8 *tlv;    /* pointer into our current, growing TLV storage area */
>  
> -	if (scan_cfg->clear_bssid
> -	    && (compare_ether_addr(scan_cfg->bssid, &zeromac[0]) != 0)
> -	    && (compare_ether_addr(scan_cfg->bssid, &bcastmac[0]) != 0)) {
> -		clear_bssid_flag = 1;
> -	}
> +	lbs_deb_enter_args(LBS_DEB_SCAN, "bsstype %d, chanlist[].chan %d, "
> +		"chan_count %d",
> +		bsstype, chan_list[0].channumber, chan_count);
>  
> -	if (!clear_ssid_flag && !clear_bssid_flag)
> +	/* create the fixed part for scan command */
> +	scan_cmd = kzalloc(MAX_SCAN_CFG_ALLOC, GFP_KERNEL);
> +	if (scan_cmd == NULL)
>  		goto out;
> +	tlv = scan_cmd->tlvbuffer;
> +	if (user_cfg)
> +		memcpy(scan_cmd->bssid, user_cfg->bssid, ETH_ALEN);
> +	scan_cmd->bsstype = bsstype;
>  
> -	mutex_lock(&adapter->lock);
> -	list_for_each_entry_safe (bss, safe, &adapter->network_list, list) {
> -		u32 clear = 0;
> -
> -		/* Check for an SSID match */
> -		if (   clear_ssid_flag
> -		    && (bss->ssid_len == scan_cfg->ssid_len)
> -		    && !memcmp(bss->ssid, scan_cfg->ssid, bss->ssid_len))
> -			clear = 1;
> +	/* add TLVs */
> +	if (user_cfg && user_cfg->ssid_len)
> +		tlv += lbs_scan_add_ssid_tlv(tlv, user_cfg);
> +	if (chan_list && chan_count)
> +		tlv += lbs_scan_add_chanlist_tlv(tlv, chan_list, chan_count);
> +	tlv += lbs_scan_add_rates_tlv(tlv);
>  
> -		/* Check for a BSSID match */
> -		if (   clear_bssid_flag
> -		    && !compare_ether_addr(bss->bssid, scan_cfg->bssid))
> -			clear = 1;
> +	/* This is the final data we are about to send */
> +	scan_cmd->tlvbufferlen = tlv - scan_cmd->tlvbuffer;
> +	lbs_deb_hex(LBS_DEB_SCAN, "SCAN_CMD", (void *)scan_cmd, 1+6);
> +	lbs_deb_hex(LBS_DEB_SCAN, "SCAN_TLV", scan_cmd->tlvbuffer,
> +		scan_cmd->tlvbufferlen);
>  
> -		if (clear) {
> -			list_move_tail (&bss->list, &adapter->network_free_list);
> -			clear_bss_descriptor(bss);
> -		}
> -	}
> -	mutex_unlock(&adapter->lock);
> +	ret = lbs_prepare_and_send_command(priv, CMD_802_11_SCAN, 0,
> +		CMD_OPTION_WAITFORRSP, 0, scan_cmd);
>  out:
> -	lbs_deb_leave(LBS_DEB_SCAN);
> +	kfree(scan_cmd);
> +	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
> +	return ret;
>  }
>  
> 
> @@ -744,29 +528,30 @@ out:
>   *  @param priv          A pointer to struct lbs_private structure
>   *  @param puserscanin   Pointer to the input configuration for the requested
>   *                       scan.
> - *  @param full_scan     ???
>   *
>   *  @return              0 or < 0 if error
>   */
>  int lbs_scan_networks(struct lbs_private *priv,
> -	const struct lbs_ioctl_user_scan_cfg *puserscanin,
> +	const struct lbs_ioctl_user_scan_cfg *user_cfg,
>                         int full_scan)
>  {
>  	struct lbs_adapter *adapter = priv->adapter;
> -	struct mrvlietypes_chanlistparamset *pchantlvout;
> -	struct chanscanparamset * scan_chan_list = NULL;
> -	struct lbs_scan_cmd_config *scan_cfg = NULL;
> -	u8 filteredscan;
> -	u8 scancurrentchanonly;
> -	int maxchanperscan;
> -	int ret;
> +	int ret = -ENOMEM;
> +	struct chanscanparamset *chan_list;
> +	struct chanscanparamset *curr_chans;
> +	int chan_count;
> +	u8 bsstype = CMD_BSS_TYPE_ANY;
> +	int numchannels = MRVDRV_CHANNELS_PER_SCAN_CMD;
> +	int filteredscan = 0;
> +	union iwreq_data wrqu;
>  #ifdef CONFIG_LIBERTAS_DEBUG
> -	struct bss_descriptor * iter_bss;
> +	struct bss_descriptor *iter;
>  	int i = 0;
>  	DECLARE_MAC_BUF(mac);
>  #endif
>  
> -	lbs_deb_enter_args(LBS_DEB_SCAN, "full_scan %d", full_scan);
> +	lbs_deb_enter_args(LBS_DEB_SCAN, "full_scan %d",
> +		full_scan);
>  
>  	/* Cancel any partial outstanding partial scans if this scan
>  	 * is a full scan.
> @@ -774,84 +559,122 @@ int lbs_scan_networks(struct lbs_private
>  	if (full_scan && delayed_work_pending(&priv->scan_work))
>  		cancel_delayed_work(&priv->scan_work);
>  
> -	scan_chan_list = kzalloc(sizeof(struct chanscanparamset) *
> -				LBS_IOCTL_USER_SCAN_CHAN_MAX, GFP_KERNEL);
> -	if (scan_chan_list == NULL) {
> -		ret = -ENOMEM;
> -		goto out;
> +	/* Determine same scan parameters */
> +	if (user_cfg) {
> +		if (user_cfg->bsstype)
> +			bsstype = user_cfg->bsstype;
> +		if (compare_ether_addr(user_cfg->bssid, &zeromac[0]) != 0) {
> +			numchannels = MRVDRV_MAX_CHANNELS_PER_SCAN;
> +			filteredscan = 1;
> +		}
>  	}
> +	lbs_deb_scan("numchannels %d, bsstype %d, "
> +		"filteredscan %d\n",
> +		numchannels, bsstype, filteredscan);
>  
> -	scan_cfg = lbs_scan_setup_scan_config(priv,
> -					       puserscanin,
> -					       &pchantlvout,
> -					       scan_chan_list,
> -					       &maxchanperscan,
> -					       &filteredscan,
> -					       &scancurrentchanonly);
> -	if (scan_cfg == NULL) {
> -		ret = -ENOMEM;
> +	/* Create list of channels to scan */
> +	chan_list = kzalloc(sizeof(struct chanscanparamset) *
> +				LBS_IOCTL_USER_SCAN_CHAN_MAX, GFP_KERNEL);
> +	if (!chan_list) {
> +		lbs_pr_alert("SCAN: chan_list empty\n");
>  		goto out;
>  	}
>  
> -	clear_selected_scan_list_entries(adapter, puserscanin);
> +	/* We want to scan all channels */
> +	chan_count = lbs_scan_create_channel_list(priv, chan_list,
> +		filteredscan);
>  
> -	/* Keep the data path active if we are only scanning our current channel */
> -	if (!scancurrentchanonly) {
> -		netif_stop_queue(priv->dev);
> -		netif_carrier_off(priv->dev);
> -		if (priv->mesh_dev) {
> +	netif_stop_queue(priv->dev);
> +	if (priv->mesh_dev)
>  			netif_stop_queue(priv->mesh_dev);
> -			netif_carrier_off(priv->mesh_dev);
> -		}
> +
> +	/* Prepare to continue an interrupted scan */
> +	lbs_deb_scan("chan_count %d, last_scanned_channel %d\n",
> +		chan_count, adapter->last_scanned_channel);
> +	curr_chans = chan_list;
> +	/* advance channel list by already-scanned-channels */
> +	if (adapter->last_scanned_channel > 0) {
> +		curr_chans += adapter->last_scanned_channel;
> +		chan_count -= adapter->last_scanned_channel;
>  	}
>  
> -	ret = lbs_scan_channel_list(priv,
> -				     maxchanperscan,
> -				     filteredscan,
> -				     scan_cfg,
> -				     pchantlvout,
> -				     scan_chan_list,
> -				     puserscanin,
> -				     full_scan);
> +	/* Send scan command(s)
> +	 * numchannels contains the number of channels we should maximally scan
> +	 * chan_count is the total number of channels to scan
> +	 */
> +
> +	while (chan_count) {
> +		int to_scan = min(numchannels, chan_count);
> +		lbs_deb_scan("scanning %d of %d channels\n",
> +			to_scan, chan_count);
> +		ret = lbs_do_scan(priv, bsstype, curr_chans,
> +			to_scan, user_cfg);
> +		if (ret) {
> +			lbs_pr_err("SCAN_CMD failed\n");
> +			goto out2;
> +		}
> +		curr_chans += to_scan;
> +		chan_count -= to_scan;
> +
> +		/* somehow schedule the next part of the scan */
> +		if (chan_count &&
> +		    !full_scan &&
> +		    !priv->adapter->surpriseremoved) {
> +			/* -1 marks just that we're currently scanning */
> +			if (adapter->last_scanned_channel < 0)
> +				adapter->last_scanned_channel = to_scan;
> +			else
> +				adapter->last_scanned_channel += to_scan;
> +			cancel_delayed_work(&priv->scan_work);
> +			queue_delayed_work(priv->work_thread, &priv->scan_work,
> +				msecs_to_jiffies(300));
> +			/* skip over GIWSCAN event */
> +			goto out;
> +		}
> +
> +	}
> +	memset(&wrqu, 0, sizeof(union iwreq_data));
> +	wireless_send_event(priv->dev, SIOCGIWSCAN, &wrqu, NULL);
>  
>  #ifdef CONFIG_LIBERTAS_DEBUG
>  	/* Dump the scan table */
>  	mutex_lock(&adapter->lock);
> -	lbs_deb_scan("The scan table contains:\n");
> -	list_for_each_entry (iter_bss, &adapter->network_list, list) {
> -		lbs_deb_scan("scan %02d, %s, RSSI, %d, SSID '%s'\n",
> -		       i++, print_mac(mac, iter_bss->bssid), (s32) iter_bss->rssi,
> -		       escape_essid(iter_bss->ssid, iter_bss->ssid_len));
> -	}
> +	lbs_deb_scan("scan table:\n");
> +	list_for_each_entry(iter, &adapter->network_list, list)
> +		lbs_deb_scan("%02d: BSSID %s, RSSI %d, SSID '%s'\n",
> +		       i++, print_mac(mac, iter->bssid), (s32) iter->rssi,
> +		       escape_essid(iter->ssid, iter->ssid_len));
>  	mutex_unlock(&adapter->lock);
>  #endif
>  
> -	if (priv->adapter->connect_status == LBS_CONNECTED) {
> -		netif_carrier_on(priv->dev);
> -		netif_wake_queue(priv->dev);
> -		if (priv->mesh_dev) {
> -			netif_carrier_on(priv->mesh_dev);
> -			netif_wake_queue(priv->mesh_dev);
> -		}
> -	}
> +out2:
> +	adapter->last_scanned_channel = 0;
>  
>  out:
> -	if (scan_cfg)
> -		kfree(scan_cfg);
> -
> -	if (scan_chan_list)
> -		kfree(scan_chan_list);
> +	netif_start_queue(priv->dev);
> +	if (priv->mesh_dev)
> +		netif_start_queue(priv->mesh_dev);
> +	kfree(chan_list);
>  
>  	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
>  	return ret;
>  }
>  
> +
> +
> +
> +/*********************************************************************/
> +/*                                                                   */
> +/*  Result interpretation                                            */
> +/*                                                                   */
> +/*********************************************************************/
> +
>  /**
>   *  @brief Interpret a BSS scan response returned from the firmware
>   *
>   *  Parse the various fixed fields and IEs passed back for a a BSS probe
> - *   response or beacon from the scan command.  Record information as needed
> - *   in the scan table struct bss_descriptor for that entry.
> + *  response or beacon from the scan command.  Record information as needed
> + *  in the scan table struct bss_descriptor for that entry.
>   *
>   *  @param bss  Output parameter: Pointer to the BSS Entry
>   *
> @@ -896,7 +719,7 @@ static int lbs_process_bss(struct bss_de
>  	*bytesleft -= beaconsize;
>  
>  	memcpy(bss->bssid, pos, ETH_ALEN);
> -	lbs_deb_scan("process_bss: AP BSSID %s\n", print_mac(mac, bss->bssid));
> +	lbs_deb_scan("process_bss: BSSID %s\n", print_mac(mac, bss->bssid));
>  	pos += ETH_ALEN;
>  
>  	if ((end - pos) < 12) {
> @@ -912,7 +735,7 @@ static int lbs_process_bss(struct bss_de
>  
>  	/* RSSI is 1 byte long */
>  	bss->rssi = *pos;
> -	lbs_deb_scan("process_bss: RSSI=%02X\n", *pos);
> +	lbs_deb_scan("process_bss: RSSI %d\n", *pos);
>  	pos++;
>  
>  	/* time stamp is 8 bytes long */
> @@ -924,18 +747,18 @@ static int lbs_process_bss(struct bss_de
>  
>  	/* capability information is 2 bytes long */
>  	bss->capability = le16_to_cpup((void *) pos);
> -	lbs_deb_scan("process_bss: capabilities = 0x%4X\n", bss->capability);
> +	lbs_deb_scan("process_bss: capabilities 0x%04x\n", bss->capability);
>  	pos += 2;
>  
>  	if (bss->capability & WLAN_CAPABILITY_PRIVACY)
> -		lbs_deb_scan("process_bss: AP WEP enabled\n");
> +		lbs_deb_scan("process_bss: WEP enabled\n");
>  	if (bss->capability & WLAN_CAPABILITY_IBSS)
>  		bss->mode = IW_MODE_ADHOC;
>  	else
>  		bss->mode = IW_MODE_INFRA;
>  
>  	/* rest of the current buffer are IE's */
> -	lbs_deb_scan("process_bss: IE length for this AP = %zd\n", end - pos);
> +	lbs_deb_scan("process_bss: IE len %zd\n", end - pos);
>  	lbs_deb_hex(LBS_DEB_SCAN, "process_bss: IE info", pos, end - pos);
>  
>  	/* process variable IE */
> @@ -953,7 +776,7 @@ static int lbs_process_bss(struct bss_de
>  		case MFIE_TYPE_SSID:
>  			bss->ssid_len = elem->len;
>  			memcpy(bss->ssid, elem->data, elem->len);
> -			lbs_deb_scan("ssid '%s', ssid length %u\n",
> +			lbs_deb_scan("got SSID IE: '%s', len %u\n",
>  			             escape_essid(bss->ssid, bss->ssid_len),
>  			             bss->ssid_len);
>  			break;
> @@ -962,16 +785,14 @@ static int lbs_process_bss(struct bss_de
>  			n_basic_rates = min_t(u8, MAX_RATES, elem->len);
>  			memcpy(bss->rates, elem->data, n_basic_rates);
>  			got_basic_rates = 1;
> +			lbs_deb_scan("got RATES IE\n");
>  			break;
>  
>  		case MFIE_TYPE_FH_SET:
>  			pFH = (struct ieeetypes_fhparamset *) pos;
>  			memmove(&bss->phyparamset.fhparamset, pFH,
>  				sizeof(struct ieeetypes_fhparamset));
> -#if 0 /* I think we can store these LE */
> -			bss->phyparamset.fhparamset.dwelltime
> -			    = le16_to_cpu(bss->phyparamset.fhparamset.dwelltime);
> -#endif
> +			lbs_deb_scan("got FH IE\n");
>  			break;
>  
>  		case MFIE_TYPE_DS_SET:
> @@ -979,12 +800,14 @@ static int lbs_process_bss(struct bss_de
>  			bss->channel = pDS->currentchan;
>  			memcpy(&bss->phyparamset.dsparamset, pDS,
>  			       sizeof(struct ieeetypes_dsparamset));
> +			lbs_deb_scan("got DS IE, channel %d\n", bss->channel);
>  			break;
>  
>  		case MFIE_TYPE_CF_SET:
>  			pCF = (struct ieeetypes_cfparamset *) pos;
>  			memcpy(&bss->ssparamset.cfparamset, pCF,
>  			       sizeof(struct ieeetypes_cfparamset));
> +			lbs_deb_scan("got CF IE\n");
>  			break;
>  
>  		case MFIE_TYPE_IBSS_SET:
> @@ -992,18 +815,16 @@ static int lbs_process_bss(struct bss_de
>  			bss->atimwindow = le32_to_cpu(pibss->atimwindow);
>  			memmove(&bss->ssparamset.ibssparamset, pibss,
>  				sizeof(struct ieeetypes_ibssparamset));
> -#if 0
> -			bss->ssparamset.ibssparamset.atimwindow
> -			    = le16_to_cpu(bss->ssparamset.ibssparamset.atimwindow);
> -#endif
> +			lbs_deb_scan("got IBSS IE\n");
>  			break;
>  
>  		case MFIE_TYPE_COUNTRY:
>  			pcountryinfo = (struct ieeetypes_countryinfoset *) pos;
> +			lbs_deb_scan("got COUNTRY IE\n");
>  			if (pcountryinfo->len < sizeof(pcountryinfo->countrycode)
>  			    || pcountryinfo->len > 254) {
>  				lbs_deb_scan("process_bss: 11D- Err "
> -				       "CountryInfo len =%d min=%zd max=254\n",
> +				       "CountryInfo len %d, min %zd, max 254\n",
>  				       pcountryinfo->len,
>  				       sizeof(pcountryinfo->countrycode));
>  				ret = -1;
> @@ -1022,8 +843,11 @@ static int lbs_process_bss(struct bss_de
>  			 * already found. Data rate IE should come before
>  			 * extended supported rate IE
>  			 */
> -			if (!got_basic_rates)
> +			lbs_deb_scan("got RATESEX IE\n");
> +			if (!got_basic_rates) {
> +				lbs_deb_scan("... but ignoring it\n");
>  				break;
> +			}
>  
>  			n_ex_rates = elem->len;
>  			if (n_basic_rates + n_ex_rates > MAX_RATES)
> @@ -1042,24 +866,36 @@ static int lbs_process_bss(struct bss_de
>  				bss->wpa_ie_len = min(elem->len + 2,
>  				                      MAX_WPA_IE_LEN);
>  				memcpy(bss->wpa_ie, elem, bss->wpa_ie_len);
> -				lbs_deb_hex(LBS_DEB_SCAN, "process_bss: WPA IE", bss->wpa_ie,
> +				lbs_deb_scan("got WPA IE\n");
> +				lbs_deb_hex(LBS_DEB_SCAN, "WPA IE", bss->wpa_ie,
>  				            elem->len);
>  			} else if (elem->len >= MARVELL_MESH_IE_LENGTH &&
>  			    elem->data[0] == 0x00 &&
>  			    elem->data[1] == 0x50 &&
>  			    elem->data[2] == 0x43 &&
>  			    elem->data[3] == 0x04) {
> +				lbs_deb_scan("got mesh IE\n");
>  				bss->mesh = 1;
> +			} else {
> +				lbs_deb_scan("got generiec IE: "
> +					"%02x:%02x:%02x:%02x, len %d\n",
> +					elem->data[0], elem->data[1],
> +					elem->data[2], elem->data[3],
> +					elem->len);
>  			}
>  			break;
>  
>  		case MFIE_TYPE_RSN:
> +			lbs_deb_scan("got RSN IE\n");
>  			bss->rsn_ie_len = min(elem->len + 2, MAX_WPA_IE_LEN);
>  			memcpy(bss->rsn_ie, elem, bss->rsn_ie_len);
> -			lbs_deb_hex(LBS_DEB_SCAN, "process_bss: RSN_IE", bss->rsn_ie, elem->len);
> +			lbs_deb_hex(LBS_DEB_SCAN, "process_bss: RSN_IE",
> +				bss->rsn_ie, elem->len);
>  			break;
>  
>  		default:
> +			lbs_deb_scan("got IE 0x%04x, len %d\n",
> +				elem->id, elem->len);
>  			break;
>  		}
>  
> @@ -1271,8 +1107,6 @@ int lbs_find_best_network_ssid(struct lb
>  	if (adapter->surpriseremoved)
>  		goto out;
>  
> -	wait_event_interruptible(adapter->cmd_pending, !adapter->nr_cmd_pending);
> -
>  	found = lbs_find_best_ssid_in_list(adapter, preferred_mode);
>  	if (found && (found->ssid_len > 0)) {
>  		memcpy(out_ssid, &found->ssid, IW_ESSID_MAX_SIZE);
> @@ -1286,36 +1120,6 @@ out:
>  	return ret;
>  }
>  
> -/**
> - *  @brief Scan Network
> - *
> - *  @param dev          A pointer to net_device structure
> - *  @param info         A pointer to iw_request_info structure
> - *  @param vwrq         A pointer to iw_param structure
> - *  @param extra        A pointer to extra data buf
> - *
> - *  @return             0 --success, otherwise fail
> - */
> -int lbs_set_scan(struct net_device *dev, struct iw_request_info *info,
> -		  struct iw_param *vwrq, char *extra)
> -{
> -	struct lbs_private *priv = dev->priv;
> -	struct lbs_adapter *adapter = priv->adapter;
> -
> -	lbs_deb_enter(LBS_DEB_SCAN);
> -
> -	if (!delayed_work_pending(&priv->scan_work)) {
> -		queue_delayed_work(priv->work_thread, &priv->scan_work,
> -		                   msecs_to_jiffies(50));
> -	}
> -
> -	if (adapter->surpriseremoved)
> -		return -1;
> -
> -	lbs_deb_leave(LBS_DEB_SCAN);
> -	return 0;
> -}
> -
>  
>  /**
>   *  @brief Send a scan command for all available channels filtered on a spec
> @@ -1327,8 +1131,6 @@ int lbs_set_scan(struct net_device *dev,
>   *  @param ssid_len         Length of the SSID
>   *  @param clear_ssid       Should existing scan results with this SSID
>   *                          be cleared?
> - *  @param prequestedssid   A pointer to AP's ssid
> - *  @param keeppreviousscan Flag used to save/clear scan table before scan
>   *
>   *  @return                0-success, otherwise fail
>   */
> @@ -1355,7 +1157,6 @@ int lbs_send_specific_ssid_scan(struct l
>  		ret = -1;
>  		goto out;
>  	}
> -	wait_event_interruptible(adapter->cmd_pending, !adapter->nr_cmd_pending);
>  
>  out:
>  	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
> @@ -1371,6 +1172,7 @@ out:
>  /*                                                                   */
>  /*********************************************************************/
>  
> +
>  #define MAX_CUSTOM_LEN 64
>  
>  static inline char *lbs_translate_scan(struct lbs_private *priv,
> @@ -1396,7 +1198,7 @@ static inline char *lbs_translate_scan(s
>  		goto out;
>  	}
>  
> -	/* First entry *MUST* be the AP BSSID */
> +	/* First entry *MUST* be the BSSID */
>  	iwe.cmd = SIOCGIWAP;
>  	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
>  	memcpy(iwe.u.ap_addr.sa_data, &bss->bssid, ETH_ALEN);
> @@ -1526,6 +1328,56 @@ out:
>  	return start;
>  }
>  
> +
> +/**
> + *  @brief Handle Scan Network ioctl
> + *
> + *  @param dev          A pointer to net_device structure
> + *  @param info         A pointer to iw_request_info structure
> + *  @param vwrq         A pointer to iw_param structure
> + *  @param extra        A pointer to extra data buf
> + *
> + *  @return             0 --success, otherwise fail
> + */
> +int lbs_set_scan(struct net_device *dev, struct iw_request_info *info,
> +		  struct iw_param *wrqu, char *extra)
> +{
> +	struct lbs_private *priv = dev->priv;
> +	struct lbs_adapter *adapter = priv->adapter;
> +	int ret = 0;
> +
> +	lbs_deb_enter(LBS_DEB_SCAN);
> +
> +	if (!netif_running(dev))
> +		return -ENETDOWN;
> +
> +	/* mac80211 does this:
> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	if (sdata->type != IEEE80211_IF_TYPE_xxx)
> +		return -EOPNOTSUPP;
> +
> +	if (wrqu->data.length == sizeof(struct iw_scan_req) &&
> +	    wrqu->data.flags & IW_SCAN_THIS_ESSID) {
> +		req = (struct iw_scan_req *)extra;
> +			ssid = req->essid;
> +		ssid_len = req->essid_len;
> +	}
> +	*/
> +
> +	if (!delayed_work_pending(&priv->scan_work))
> +		queue_delayed_work(priv->work_thread, &priv->scan_work,
> +			msecs_to_jiffies(50));
> +	/* set marker that currently a scan is taking place */
> +	adapter->last_scanned_channel = -1;
> +
> +	if (adapter->surpriseremoved)
> +		return -EIO;
> +
> +	lbs_deb_leave(LBS_DEB_SCAN);
> +	return 0;
> +}
> +
> +
>  /**
>   *  @brief  Handle Retrieve scan table ioctl
>   *
> @@ -1550,6 +1402,10 @@ int lbs_get_scan(struct net_device *dev,
>  
>  	lbs_deb_enter(LBS_DEB_SCAN);
>  
> +	/* iwlist should wait until the current scan is finished */
> +	if (adapter->last_scanned_channel)
> +		return -EAGAIN;
> +
>  	/* Update RSSI if current BSS is a locally created ad-hoc BSS */
>  	if ((adapter->mode == IW_MODE_ADHOC) && adapter->adhoccreate) {
>  		lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
> @@ -1607,7 +1463,8 @@ int lbs_get_scan(struct net_device *dev,
>  /**
>   *  @brief Prepare a scan command to be sent to the firmware
>   *
> - *  Called from lbs_prepare_and_send_command() in cmd.c
> + *  Called via lbs_prepare_and_send_command(priv, CMD_802_11_SCAN, ...)
> + *  from cmd.c
>   *
>   *  Sends a fixed lenght data part (specifying the BSS type and BSSID filters)
>   *  as well as a variable number/length of TLVs to the firmware.
> @@ -1621,7 +1478,7 @@ int lbs_get_scan(struct net_device *dev,
>   *  @return           0 or -1
>   */
>  int lbs_cmd_80211_scan(struct lbs_private *priv,
> -			 struct cmd_ds_command *cmd, void *pdata_buf)
> +	struct cmd_ds_command *cmd, void *pdata_buf)
>  {
>  	struct cmd_ds_802_11_scan *pscan = &cmd->params.scan;
>  	struct lbs_scan_cmd_config *pscancfg = pdata_buf;
> @@ -1633,32 +1490,14 @@ int lbs_cmd_80211_scan(struct lbs_privat
>  	memcpy(pscan->bssid, pscancfg->bssid, ETH_ALEN);
>  	memcpy(pscan->tlvbuffer, pscancfg->tlvbuffer, pscancfg->tlvbufferlen);
>  
> -	cmd->command = cpu_to_le16(CMD_802_11_SCAN);
> -
>  	/* size is equal to the sizeof(fixed portions) + the TLV len + header */
>  	cmd->size = cpu_to_le16(sizeof(pscan->bsstype) + ETH_ALEN
>  				+ pscancfg->tlvbufferlen + S_DS_GEN);
>  
> -	lbs_deb_scan("SCAN_CMD: command 0x%04x, size %d, seqnum %d\n",
> -		     le16_to_cpu(cmd->command), le16_to_cpu(cmd->size),
> -		     le16_to_cpu(cmd->seqnum));
> -
>  	lbs_deb_leave(LBS_DEB_SCAN);
>  	return 0;
>  }
>  
> -static inline int is_same_network(struct bss_descriptor *src,
> -				  struct bss_descriptor *dst)
> -{
> -	/* A network is only a duplicate if the channel, BSSID, and ESSID
> -	 * all match.  We treat all <hidden> with the same BSSID and channel
> -	 * as one network */
> -	return ((src->ssid_len == dst->ssid_len) &&
> -		(src->channel == dst->channel) &&
> -		!compare_ether_addr(src->bssid, dst->bssid) &&
> -		!memcmp(src->ssid, dst->ssid, src->ssid_len));
> -}
> -
>  /**
>   *  @brief This function handles the command response of scan
>   *
> @@ -1723,7 +1562,7 @@ int lbs_ret_80211_scan(struct lbs_privat
>  	lbs_deb_scan("SCAN_RESP: bssdescriptsize %d\n", bytesleft);
>  
>  	scanrespsize = le16_to_cpu(get_unaligned((u16*)&resp->size));
> -	lbs_deb_scan("SCAN_RESP: returned %d AP before parsing\n",
> +	lbs_deb_scan("SCAN_RESP: scan results %d\n",
>  	       pscan->nr_sets);
>  
>  	pbssinfo = pscan->bssdesc_and_tlvbuffer;
> @@ -1786,7 +1625,7 @@ int lbs_ret_80211_scan(struct lbs_privat
>  			continue;
>  		}
>  
> -		lbs_deb_scan("SCAN_RESP: BSSID = %s\n",
> +		lbs_deb_scan("SCAN_RESP: BSSID %s\n",
>  			     print_mac(mac, new.bssid));
>  
>  		/* Copy the locally created newbssentry to the scan table */
> Index: wireless-2.6/drivers/net/wireless/libertas/dev.h
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/dev.h	2007-11-29 10:13:04.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/dev.h	2007-11-29 10:13:19.000000000 +0100
> @@ -363,9 +363,8 @@ struct lbs_adapter {
>  	struct cmd_ds_802_11_get_log logmsg;
>  
>  	u32 monitormode;
> +	int last_scanned_channel;
>  	u8 fw_ready;
> -
> -	u8 last_scanned_channel;
>  };
>  
>  #endif

