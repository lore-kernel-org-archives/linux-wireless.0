Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757844AbYCDRQa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 12:16:30 -0500
Subject: Re: [PATCH] libertas: convert 802_11_SCAN to a direct command
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803031218.03921.hs4233@mail.mn-solutions.de>
References: <200803031218.03921.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 12:12:19 -0500
Message-Id: <1204650739.30024.4.camel@localhost.localdomain> (sfid-20080304_171636_030262_5888DA67)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-03-03 at 12:18 +0100, Holger Schurig wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> 
>   
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-03-03 11:46:56.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-03-03 11:47:02.000000000 +0100
> @@ -1382,10 +1382,6 @@ int lbs_prepare_and_send_command(struct 
>  		ret = lbs_cmd_802_11_ps_mode(priv, cmdptr, cmd_action);
>  		break;
>  
> -	case CMD_802_11_SCAN:
> -		ret = lbs_cmd_80211_scan(priv, cmdptr, pdata_buf);
> -		break;
> -
>  	case CMD_MAC_CONTROL:
>  		ret = lbs_cmd_mac_control(priv, cmdptr);
>  		break;
> Index: wireless-testing/drivers/net/wireless/libertas/cmdresp.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/cmdresp.c	2008-03-03 11:46:56.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/cmdresp.c	2008-03-03 11:47:02.000000000 +0100
> @@ -352,10 +352,6 @@ static inline int handle_cmd_response(st
>  		ret = lbs_ret_reg_access(priv, respcmd, resp);
>  		break;
>  
> -	case CMD_RET(CMD_802_11_SCAN):
> -		ret = lbs_ret_80211_scan(priv, resp);
> -		break;
> -
>  	case CMD_RET(CMD_802_11_GET_LOG):
>  		ret = lbs_ret_get_log(priv, resp);
>  		break;
> Index: wireless-testing/drivers/net/wireless/libertas/hostcmd.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/hostcmd.h	2008-03-03 11:46:56.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/hostcmd.h	2008-03-03 11:47:02.000000000 +0100
> @@ -174,9 +174,11 @@ struct cmd_ds_802_11_subscribe_event {
>   * Define data structure for CMD_802_11_SCAN
>   */
>  struct cmd_ds_802_11_scan {
> -	u8 bsstype;
> -	u8 bssid[ETH_ALEN];
> -	u8 tlvbuffer[1];
> +	struct cmd_header hdr;
> +
> +	uint8_t bsstype;
> +	uint8_t bssid[ETH_ALEN];
> +	uint8_t tlvbuffer[0];
>  #if 0
>  	mrvlietypes_ssidparamset_t ssidParamSet;
>  	mrvlietypes_chanlistparamset_t ChanListParamSet;
> @@ -185,9 +187,11 @@ struct cmd_ds_802_11_scan {
>  };
>  
>  struct cmd_ds_802_11_scan_rsp {
> +	struct cmd_header hdr;
> +
>  	__le16 bssdescriptsize;
> -	u8 nr_sets;
> -	u8 bssdesc_and_tlvbuffer[1];
> +	uint8_t nr_sets;
> +	uint8_t bssdesc_and_tlvbuffer[0];
>  };
>  
>  struct cmd_ds_802_11_get_log {
> @@ -691,8 +695,6 @@ struct cmd_ds_command {
>  	/* command Body */
>  	union {
>  		struct cmd_ds_802_11_ps_mode psmode;
> -		struct cmd_ds_802_11_scan scan;
> -		struct cmd_ds_802_11_scan_rsp scanresp;
>  		struct cmd_ds_mac_control macctrl;
>  		struct cmd_ds_802_11_associate associate;
>  		struct cmd_ds_802_11_deauthenticate deauth;
> Index: wireless-testing/drivers/net/wireless/libertas/scan.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/scan.c	2008-03-03 11:11:31.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/scan.c	2008-03-03 11:49:58.000000000 +0100
> @@ -20,6 +20,7 @@
>  #include "dev.h"
>  #include "scan.h"
>  #include "join.h"
> +#include "cmd.h"
>  
>  //! Approximate amount of data needed to pass a scan result back to iwlist
>  #define MAX_SCAN_CELL_SIZE  (IW_EV_ADDR_LEN             \
> @@ -39,10 +40,9 @@
>  //! Memory needed to store a max number/size SSID TLV for a firmware scan
>  #define SSID_TLV_MAX_SIZE  (1 * sizeof(struct mrvlietypes_ssidparamset))
>  
> -//! Maximum memory needed for a lbs_scan_cmd_config with all TLVs at max
> -#define MAX_SCAN_CFG_ALLOC (sizeof(struct lbs_scan_cmd_config)  \
> -                            + CHAN_TLV_MAX_SIZE                 \
> -                            + SSID_TLV_MAX_SIZE)
> +//! Maximum memory needed for a cmd_ds_802_11_scan with all TLVs at max
> +#define MAX_SCAN_CFG_ALLOC (sizeof(struct cmd_ds_802_11_scan)	\
> +                            + CHAN_TLV_MAX_SIZE + SSID_TLV_MAX_SIZE)
>  
>  //! The maximum number of channels the firmware can scan per command
>  #define MRVDRV_MAX_CHANNELS_PER_SCAN   14
> @@ -64,8 +64,8 @@
>  static const u8 zeromac[ETH_ALEN] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
>  static const u8 bcastmac[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
>  
> -
> -
> +static int lbs_ret_80211_scan(struct lbs_private *priv, unsigned long dummy,
> +			      struct cmd_header *resp);
>  
>  /*********************************************************************/
>  /*                                                                   */
> @@ -492,24 +492,22 @@ static int lbs_scan_add_rates_tlv(u8 *tl
>   * Generate the CMD_802_11_SCAN command with the proper tlv
>   * for a bunch of channels.
>   */
> -static int lbs_do_scan(struct lbs_private *priv,
> -	u8 bsstype,
> -	struct chanscanparamset *chan_list,
> -	int chan_count,
> -	const struct lbs_ioctl_user_scan_cfg *user_cfg)
> +static int lbs_do_scan(struct lbs_private *priv, uint8_t bsstype,
> +		       struct chanscanparamset *chan_list, int chan_count,
> +		       const struct lbs_ioctl_user_scan_cfg *user_cfg)
>  {
>  	int ret = -ENOMEM;
> -	struct lbs_scan_cmd_config *scan_cmd;
> -	u8 *tlv;    /* pointer into our current, growing TLV storage area */
> +	struct cmd_ds_802_11_scan *scan_cmd;
> +	uint8_t *tlv;	/* pointer into our current, growing TLV storage area */
>  
> -	lbs_deb_enter_args(LBS_DEB_SCAN, "bsstype %d, chanlist[].chan %d, "
> -		"chan_count %d",
> -		bsstype, chan_list[0].channumber, chan_count);
> +	lbs_deb_enter_args(LBS_DEB_SCAN, "bsstype %d, chanlist[].chan %d, chan_count %d",
> +			   bsstype, chan_list[0].channumber, chan_count);
>  
>  	/* create the fixed part for scan command */
>  	scan_cmd = kzalloc(MAX_SCAN_CFG_ALLOC, GFP_KERNEL);
>  	if (scan_cmd == NULL)
>  		goto out;
> +
>  	tlv = scan_cmd->tlvbuffer;
>  	if (user_cfg)
>  		memcpy(scan_cmd->bssid, user_cfg->bssid, ETH_ALEN);
> @@ -523,13 +521,16 @@ static int lbs_do_scan(struct lbs_privat
>  	tlv += lbs_scan_add_rates_tlv(tlv);
>  
>  	/* This is the final data we are about to send */
> -	scan_cmd->tlvbufferlen = tlv - scan_cmd->tlvbuffer;
> -	lbs_deb_hex(LBS_DEB_SCAN, "SCAN_CMD", (void *)scan_cmd, 1+6);
> +	scan_cmd->hdr.size = cpu_to_le16(tlv - (uint8_t *)scan_cmd);
> +	lbs_deb_hex(LBS_DEB_SCAN, "SCAN_CMD", (void *)scan_cmd,
> +		    sizeof(*scan_cmd));
>  	lbs_deb_hex(LBS_DEB_SCAN, "SCAN_TLV", scan_cmd->tlvbuffer,
> -		scan_cmd->tlvbufferlen);
> +		    tlv - scan_cmd->tlvbuffer);
> +
> +	ret = __lbs_cmd(priv, CMD_802_11_SCAN, &scan_cmd->hdr,
> +			le16_to_cpu(scan_cmd->hdr.size),
> +			lbs_ret_80211_scan, 0);
>  
> -	ret = lbs_prepare_and_send_command(priv, CMD_802_11_SCAN, 0,
> -		CMD_OPTION_WAITFORRSP, 0, scan_cmd);
>  out:
>  	kfree(scan_cmd);
>  	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
> @@ -1485,44 +1486,6 @@ int lbs_get_scan(struct net_device *dev,
>  
> 
>  /**
> - *  @brief Prepare a scan command to be sent to the firmware
> - *
> - *  Called via lbs_prepare_and_send_command(priv, CMD_802_11_SCAN, ...)
> - *  from cmd.c
> - *
> - *  Sends a fixed length data part (specifying the BSS type and BSSID filters)
> - *  as well as a variable number/length of TLVs to the firmware.
> - *
> - *  @param priv       A pointer to struct lbs_private structure
> - *  @param cmd        A pointer to cmd_ds_command structure to be sent to
> - *                    firmware with the cmd_DS_801_11_SCAN structure
> - *  @param pdata_buf  Void pointer cast of a lbs_scan_cmd_config struct used
> - *                    to set the fields/TLVs for the command sent to firmware
> - *
> - *  @return           0 or -1
> - */
> -int lbs_cmd_80211_scan(struct lbs_private *priv,
> -	struct cmd_ds_command *cmd, void *pdata_buf)
> -{
> -	struct cmd_ds_802_11_scan *pscan = &cmd->params.scan;
> -	struct lbs_scan_cmd_config *pscancfg = pdata_buf;
> -
> -	lbs_deb_enter(LBS_DEB_SCAN);
> -
> -	/* Set fixed field variables in scan command */
> -	pscan->bsstype = pscancfg->bsstype;
> -	memcpy(pscan->bssid, pscancfg->bssid, ETH_ALEN);
> -	memcpy(pscan->tlvbuffer, pscancfg->tlvbuffer, pscancfg->tlvbufferlen);
> -
> -	/* size is equal to the sizeof(fixed portions) + the TLV len + header */
> -	cmd->size = cpu_to_le16(sizeof(pscan->bsstype) + ETH_ALEN
> -				+ pscancfg->tlvbufferlen + S_DS_GEN);
> -
> -	lbs_deb_leave(LBS_DEB_SCAN);
> -	return 0;
> -}
> -
> -/**
>   *  @brief This function handles the command response of scan
>   *
>   *  Called from handle_cmd_response() in cmdrespc.
> @@ -1548,13 +1511,14 @@ int lbs_cmd_80211_scan(struct lbs_privat
>   *
>   *  @return        0 or -1
>   */
> -int lbs_ret_80211_scan(struct lbs_private *priv, struct cmd_ds_command *resp)
> +static int lbs_ret_80211_scan(struct lbs_private *priv, unsigned long dummy,
> +			      struct cmd_header *resp)
>  {
> -	struct cmd_ds_802_11_scan_rsp *pscan;
> +	struct cmd_ds_802_11_scan_rsp *scanresp = (void *)resp;
>  	struct bss_descriptor * iter_bss;
>  	struct bss_descriptor * safe;
> -	u8 *pbssinfo;
> -	u16 scanrespsize;
> +	uint8_t *bssinfo;
> +	uint16_t scanrespsize;
>  	int bytesleft;
>  	int idx;
>  	int tlvbufsize;
> @@ -1571,48 +1535,45 @@ int lbs_ret_80211_scan(struct lbs_privat
>  		clear_bss_descriptor(iter_bss);
>  	}
>  
> -	pscan = &resp->params.scanresp;
> -
> -	if (pscan->nr_sets > MAX_NETWORK_COUNT) {
> -		lbs_deb_scan(
> -		       "SCAN_RESP: too many scan results (%d, max %d)!!\n",
> -		       pscan->nr_sets, MAX_NETWORK_COUNT);
> +	if (scanresp->nr_sets > MAX_NETWORK_COUNT) {
> +		lbs_deb_scan("SCAN_RESP: too many scan results (%d, max %d)\n",
> +			     scanresp->nr_sets, MAX_NETWORK_COUNT);
>  		ret = -1;
>  		goto done;
>  	}
>  
> -	bytesleft = le16_to_cpu(pscan->bssdescriptsize);
> +	bytesleft = le16_to_cpu(scanresp->bssdescriptsize);
>  	lbs_deb_scan("SCAN_RESP: bssdescriptsize %d\n", bytesleft);
>  
>  	scanrespsize = le16_to_cpu(resp->size);
> -	lbs_deb_scan("SCAN_RESP: scan results %d\n", pscan->nr_sets);
> +	lbs_deb_scan("SCAN_RESP: scan results %d\n", scanresp->nr_sets);
>  
> -	pbssinfo = pscan->bssdesc_and_tlvbuffer;
> +	bssinfo = scanresp->bssdesc_and_tlvbuffer;
>  
>  	/* The size of the TLV buffer is equal to the entire command response
>  	 *   size (scanrespsize) minus the fixed fields (sizeof()'s), the
>  	 *   BSS Descriptions (bssdescriptsize as bytesLef) and the command
>  	 *   response header (S_DS_GEN)
>  	 */
> -	tlvbufsize = scanrespsize - (bytesleft + sizeof(pscan->bssdescriptsize)
> -				     + sizeof(pscan->nr_sets)
> +	tlvbufsize = scanrespsize - (bytesleft + sizeof(scanresp->bssdescriptsize)
> +				     + sizeof(scanresp->nr_sets)
>  				     + S_DS_GEN);
>  
>  	/*
> -	 *  Process each scan response returned (pscan->nr_sets).  Save
> +	 *  Process each scan response returned (scanresp->nr_sets). Save
>  	 *    the information in the newbssentry and then insert into the
>  	 *    driver scan table either as an update to an existing entry
>  	 *    or as an addition at the end of the table
>  	 */
> -	for (idx = 0; idx < pscan->nr_sets && bytesleft; idx++) {
> +	for (idx = 0; idx < scanresp->nr_sets && bytesleft; idx++) {
>  		struct bss_descriptor new;
> -		struct bss_descriptor * found = NULL;
> -		struct bss_descriptor * oldest = NULL;
> +		struct bss_descriptor *found = NULL;
> +		struct bss_descriptor *oldest = NULL;
>  		DECLARE_MAC_BUF(mac);
>  
>  		/* Process the data fields and IEs returned for this BSS */
>  		memset(&new, 0, sizeof (struct bss_descriptor));
> -		if (lbs_process_bss(&new, &pbssinfo, &bytesleft) != 0) {
> +		if (lbs_process_bss(&new, &bssinfo, &bytesleft) != 0) {
>  			/* error parsing the scan response, skipped */
>  			lbs_deb_scan("SCAN_RESP: process_bss returned ERROR\n");
>  			continue;
> @@ -1647,8 +1608,7 @@ int lbs_ret_80211_scan(struct lbs_privat
>  			continue;
>  		}
>  
> -		lbs_deb_scan("SCAN_RESP: BSSID %s\n",
> -			     print_mac(mac, new.bssid));
> +		lbs_deb_scan("SCAN_RESP: BSSID %s\n", print_mac(mac, new.bssid));
>  
>  		/* Copy the locally created newbssentry to the scan table */
>  		memcpy(found, &new, offsetof(struct bss_descriptor, list));
> Index: wireless-testing/drivers/net/wireless/libertas/scan.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/scan.h	2008-03-03 11:11:31.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/scan.h	2008-03-03 11:47:02.000000000 +0100
> @@ -17,57 +17,16 @@
>   */
>  #define LBS_IOCTL_USER_SCAN_CHAN_MAX  50
>  
> -//! Infrastructure BSS scan type in lbs_scan_cmd_config
> +//! Infrastructure BSS scan type in cmd_ds_802_11_scan
>  #define LBS_SCAN_BSS_TYPE_BSS         1
>  
> -//! Adhoc BSS scan type in lbs_scan_cmd_config
> +//! Adhoc BSS scan type in cmd_ds_802_11_scan
>  #define LBS_SCAN_BSS_TYPE_IBSS        2
>  
> -//! Adhoc or Infrastructure BSS scan type in lbs_scan_cmd_config, no filter
> +//! Adhoc or Infrastructure BSS scan type in cmd_ds_802_11_scan, no filter
>  #define LBS_SCAN_BSS_TYPE_ANY         3
>  
>  /**
> - * @brief Structure used internally in the wlan driver to configure a scan.
> - *
> - * Sent to the command processing module to configure the firmware
> - *   scan command prepared by lbs_cmd_80211_scan.
> - *
> - * @sa lbs_scan_networks
> - *
> - */
> -struct lbs_scan_cmd_config {
> -    /**
> -     *  @brief BSS type to be sent in the firmware command
> -     *
> -     *  Field can be used to restrict the types of networks returned in the
> -     *    scan.  valid settings are:
> -     *
> -     *   - LBS_SCAN_BSS_TYPE_BSS  (infrastructure)
> -     *   - LBS_SCAN_BSS_TYPE_IBSS (adhoc)
> -     *   - LBS_SCAN_BSS_TYPE_ANY  (unrestricted, adhoc and infrastructure)
> -     */
> -	u8 bsstype;
> -
> -    /**
> -     *  @brief Specific BSSID used to filter scan results in the firmware
> -     */
> -	u8 bssid[ETH_ALEN];
> -
> -    /**
> -     *  @brief length of TLVs sent in command starting at tlvBuffer
> -     */
> -	int tlvbufferlen;
> -
> -    /**
> -     *  @brief SSID TLV(s) and ChanList TLVs to be sent in the firmware command
> -     *
> -     *  @sa TLV_TYPE_CHANLIST, mrvlietypes_chanlistparamset_t
> -     *  @sa TLV_TYPE_SSID, mrvlietypes_ssidparamset_t
> -     */
> -	u8 tlvbuffer[1];	//!< SSID TLV(s) and ChanList TLVs are stored here
> -};
> -
> -/**
>   *  @brief IOCTL channel sub-structure sent in lbs_ioctl_user_scan_cfg
>   *
>   *  Multiple instances of this structure are included in the IOCTL command
> @@ -179,13 +138,6 @@ int lbs_find_best_network_ssid(struct lb
>  int lbs_send_specific_ssid_scan(struct lbs_private *priv, u8 *ssid,
>  				u8 ssid_len, u8 clear_ssid);
>  
> -int lbs_cmd_80211_scan(struct lbs_private *priv,
> -				struct cmd_ds_command *cmd,
> -				void *pdata_buf);
> -
> -int lbs_ret_80211_scan(struct lbs_private *priv,
> -				struct cmd_ds_command *resp);
> -
>  int lbs_scan_networks(struct lbs_private *priv,
>  	const struct lbs_ioctl_user_scan_cfg *puserscanin,
>                  int full_scan);

