Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbYCMOmJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2008 10:42:09 -0400
Subject: Re: [PATCH, take 2] libertas: convert GET_LOG to a direct command
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803131010.32763.hs4233@mail.mn-solutions.de>
References: <200803131010.32763.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 10:37:01 -0400
Message-Id: <1205419021.23812.8.camel@localhost.localdomain> (sfid-20080313_144213_107225_5B0FA221)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-03-13 at 10:10 +0100, Holger Schurig wrote:
> Now uses __lbs_cmd() to get the "log" (it's actually more a
> snapshot of various counters, not a sequential log).
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>


I'd go one step further:

int lbs_get_log(struct lbs_private *priv, struct lbs_log *log);

then just have the copyback function copy to the passed-in log pointer,
and kill priv->logmsg entirely.  lbs_association_worker() doesn't really
seem to _use_ the log info and so it could probably be removed (I can't
think how updating it here would do anything unless it's some magic
firmware poke).  That would leave as the only caller
lbs_get_wireless_stats(), which can just use a local log struct.  Sound
OK?

Dan

> Index: wireless-testing/drivers/net/wireless/libertas/cmd.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/cmd.h	2008-03-13 08:38:50.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/cmd.h	2008-03-13 08:41:22.000000000 +0100
> @@ -34,6 +34,8 @@ int lbs_cmd_copyback(struct lbs_private 
>  
>  int lbs_update_hw_spec(struct lbs_private *priv);
>  
> +int lbs_get_log(struct lbs_private *priv);
> +
>  int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
>  		    struct cmd_ds_mesh_access *cmd);
>  
> Index: wireless-testing/drivers/net/wireless/libertas/wext.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/wext.c	2008-03-13 08:38:50.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/wext.c	2008-03-13 08:41:22.000000000 +0100
> @@ -892,8 +892,7 @@ static struct iw_statistics *lbs_get_wir
>  	/* update stats asynchronously for future calls */
>  	lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
>  					0, 0, NULL);
> -	lbs_prepare_and_send_command(priv, CMD_802_11_GET_LOG, 0,
> -					0, 0, NULL);
> +	lbs_get_log(priv);
>  out:
>  	if (!stats_valid) {
>  		priv->wstats.miss.beacon = 0;
> Index: wireless-testing/drivers/net/wireless/libertas/assoc.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/assoc.c	2008-03-13 08:38:50.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/assoc.c	2008-03-13 08:41:22.000000000 +0100
> @@ -629,9 +629,7 @@ void lbs_association_worker(struct work_
>  				CMD_802_11_RSSI,
>  				0, CMD_OPTION_WAITFORRSP, 0, NULL);
>  
> -			lbs_prepare_and_send_command(priv,
> -				CMD_802_11_GET_LOG,
> -				0, CMD_OPTION_WAITFORRSP, 0, NULL);
> +			lbs_get_log(priv);
>  		} else {
>  			ret = -1;
>  		}
> Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-03-13 08:38:50.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-03-13 08:41:22.000000000 +0100
> @@ -454,18 +454,37 @@ static int lbs_cmd_802_11_reset(struct l
>  	return 0;
>  }
>  
> -static int lbs_cmd_802_11_get_log(struct lbs_private *priv,
> -				   struct cmd_ds_command *cmd)
> +static int lbs_get_log_callback(struct lbs_private *priv, unsigned long dummy,
> +	struct cmd_header *resp)
>  {
> +	int ret;
> +	struct cmd_ds_802_11_get_log_resp *logresp = (void *) resp;
> +
>  	lbs_deb_enter(LBS_DEB_CMD);
> -	cmd->command = cpu_to_le16(CMD_802_11_GET_LOG);
> -	cmd->size =
> -		cpu_to_le16(sizeof(struct cmd_ds_802_11_get_log) + S_DS_GEN);
> +	ret = le16_to_cpu(logresp->hdr.result);
> +	if (!ret)
> +		memcpy(&priv->logmsg, &logresp->log, sizeof(logresp->log));
>  
> -	lbs_deb_leave(LBS_DEB_CMD);
> -	return 0;
> +	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
> +	return ret;
>  }
>  
> +int lbs_get_log(struct lbs_private *priv)
> +{
> +	struct cmd_header cmd;
> +	int ret;
> +
> +	lbs_deb_enter(LBS_DEB_CMD);
> +
> +	cmd.size = cpu_to_le16(sizeof(cmd));
> +	ret = __lbs_cmd(priv, CMD_802_11_GET_LOG, &cmd,
> +		sizeof(struct cmd_ds_802_11_get_log_rsp),
> +		lbs_get_log_callback, 0);
> +	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
> +	return ret;
> +}
> +
> +
>  static int lbs_cmd_802_11_get_stat(struct lbs_private *priv,
>  				    struct cmd_ds_command *cmd)
>  {
> @@ -1384,10 +1403,6 @@ int lbs_prepare_and_send_command(struct 
>  		ret = lbs_cmd_802_11_reset(priv, cmdptr, cmd_action);
>  		break;
>  
> -	case CMD_802_11_GET_LOG:
> -		ret = lbs_cmd_802_11_get_log(priv, cmdptr);
> -		break;
> -
>  	case CMD_802_11_AUTHENTICATE:
>  		ret = lbs_cmd_80211_authenticate(priv, cmdptr, pdata_buf);
>  		break;
> Index: wireless-testing/drivers/net/wireless/libertas/cmdresp.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/cmdresp.c	2008-03-13 08:38:50.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/cmdresp.c	2008-03-13 08:41:22.000000000 +0100
> @@ -303,20 +303,6 @@ static int lbs_ret_802_11_eeprom_access(
>  	return 0;
>  }
>  
> -static int lbs_ret_get_log(struct lbs_private *priv,
> -			    struct cmd_ds_command *resp)
> -{
> -	struct cmd_ds_802_11_get_log *logmessage = &resp->params.glog;
> -
> -	lbs_deb_enter(LBS_DEB_CMD);
> -
> -	/* Stored little-endian */
> -	memcpy(&priv->logmsg, logmessage, sizeof(struct cmd_ds_802_11_get_log));
> -
> -	lbs_deb_leave(LBS_DEB_CMD);
> -	return 0;
> -}
> -
>  static int lbs_ret_802_11_bcn_ctrl(struct lbs_private * priv,
>  					struct cmd_ds_command *resp)
>  {
> @@ -352,10 +338,6 @@ static inline int handle_cmd_response(st
>  		ret = lbs_ret_reg_access(priv, respcmd, resp);
>  		break;
>  
> -	case CMD_RET(CMD_802_11_GET_LOG):
> -		ret = lbs_ret_get_log(priv, resp);
> -		break;
> -
>  	case CMD_RET_802_11_ASSOCIATE:
>  	case CMD_RET(CMD_802_11_ASSOCIATE):
>  	case CMD_RET(CMD_802_11_REASSOCIATE):
> Index: wireless-testing/drivers/net/wireless/libertas/types.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/types.h	2008-03-13 08:38:50.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/types.h	2008-03-13 08:41:22.000000000 +0100
> @@ -252,4 +252,22 @@ struct mrvlietypes_ledbhv {
>  	struct led_bhv ledbhv[1];
>  } __attribute__ ((packed));
>  
> +/** This is the same structure as used in the CMD_802_11_GET_LOG
> + *  commands. Used in struct lbs_private and the get_log command */
> +struct lbs_log {
> +	__le32 mcasttxframe;
> +	__le32 failed;
> +	__le32 retry;
> +	__le32 multiretry;
> +	__le32 framedup;
> +	__le32 rtssuccess;
> +	__le32 rtsfailure;
> +	__le32 ackfailure;
> +	__le32 rxfrag;
> +	__le32 mcastrxframe;
> +	__le32 fcserror;
> +	__le32 txframe;
> +	__le32 wepundecryptable;
> +};
> +
>  #endif
> Index: wireless-testing/drivers/net/wireless/libertas/dev.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/dev.h	2008-03-13 08:38:50.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/dev.h	2008-03-13 08:41:22.000000000 +0100
> @@ -323,7 +323,7 @@ struct lbs_private {
>  	u8 *prdeeprom;
>  	struct lbs_offset_value offsetvalue;
>  
> -	struct cmd_ds_802_11_get_log logmsg;
> +	struct lbs_log logmsg;
>  
>  	u32 monitormode;
>  	u8 fw_ready;
> Index: wireless-testing/drivers/net/wireless/libertas/hostcmd.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/hostcmd.h	2008-03-13 08:38:50.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/hostcmd.h	2008-03-13 08:41:22.000000000 +0100
> @@ -194,20 +194,9 @@ struct cmd_ds_802_11_scan_rsp {
>  	uint8_t bssdesc_and_tlvbuffer[0];
>  };
>  
> -struct cmd_ds_802_11_get_log {
> -	__le32 mcasttxframe;
> -	__le32 failed;
> -	__le32 retry;
> -	__le32 multiretry;
> -	__le32 framedup;
> -	__le32 rtssuccess;
> -	__le32 rtsfailure;
> -	__le32 ackfailure;
> -	__le32 rxfrag;
> -	__le32 mcastrxframe;
> -	__le32 fcserror;
> -	__le32 txframe;
> -	__le32 wepundecryptable;
> +struct cmd_ds_802_11_get_log_rsp {
> +	struct cmd_header hdr;
> +	struct lbs_log log;
>  };
>  
>  struct cmd_ds_mac_control {
> @@ -701,7 +690,6 @@ struct cmd_ds_command {
>  		struct cmd_ds_802_11_ad_hoc_start ads;
>  		struct cmd_ds_802_11_reset reset;
>  		struct cmd_ds_802_11_ad_hoc_result result;
> -		struct cmd_ds_802_11_get_log glog;
>  		struct cmd_ds_802_11_authenticate auth;
>  		struct cmd_ds_802_11_get_stat gstat;
>  		struct cmd_ds_802_3_get_stat gstat_8023;

