Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:59071 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067Ab1HJJT0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 05:19:26 -0400
Received: by bkbzv15 with SMTP id zv15so363399bkb.16
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 02:19:22 -0700 (PDT)
Subject: Re: [PATCH 08/40] wl12xx: wl12xx-fw-3 - update commands & events
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-9-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-9-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 12:19:15 +0300
Message-ID: <1312967955.2407.452.camel@cumari> (sfid-20110810_111931_005354_7FC2B971)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> Change the commands and events according to the new fw api.
> 
> The main change is the replacement of JOIN/DISCONNECT commands,
> with ROLE_START/ROLE_START commands.

I guess you meant ROLE_START/ROLE_STOP?


> diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
> index 11b26d7..7d8d09b 100644
> --- a/drivers/net/wireless/wl12xx/boot.c
> +++ b/drivers/net/wireless/wl12xx/boot.c
> @@ -501,27 +501,26 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
>  	 */
>  
>  	/* unmask required mbox events  */
>  	wl->event_mask = BSS_LOSE_EVENT_ID |
>  		SCAN_COMPLETE_EVENT_ID |
>  		PS_REPORT_EVENT_ID |
> -		JOIN_EVENT_COMPLETE_ID |
>  		DISCONNECT_EVENT_COMPLETE_ID |
>  		RSSI_SNR_TRIGGER_0_EVENT_ID |
>  		PSPOLL_DELIVERY_FAILURE_EVENT_ID |
>  		SOFT_GEMINI_SENSE_EVENT_ID |
>  		PERIODIC_SCAN_REPORT_EVENT_ID |
> -		PERIODIC_SCAN_COMPLETE_EVENT_ID;
> +		PERIODIC_SCAN_COMPLETE_EVENT_ID |
> +		DUMMY_PACKET_EVENT_ID |
> +		PEER_REMOVE_COMPLETE_EVENT_ID |
> +		BA_SESSION_RX_CONSTRAINT_EVENT_ID |
> +		REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID;
>  
>  	if (wl->bss_type == BSS_TYPE_AP_BSS)
> -		wl->event_mask |= STA_REMOVE_COMPLETE_EVENT_ID |
> -				  INACTIVE_STA_EVENT_ID |
> +		wl->event_mask |= INACTIVE_STA_EVENT_ID |
>  				  MAX_TX_RETRY_EVENT_ID;

Do we really need to mask this stuff separately?


> diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
> index b6ef65a..99d81b6 100644
> --- a/drivers/net/wireless/wl12xx/cmd.c
> +++ b/drivers/net/wireless/wl12xx/cmd.c
> @@ -360,67 +360,300 @@ static int wl1271_cmd_wait_for_event(struct wl1271 *wl, u32 mask)
>  		return ret;
>  	}
>  
>  	return 0;
>  }
>  
> -int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
> +int wl1271_cmd_role_enable(struct wl1271 *wl, u8 role_type, u8 *role_id)

s/wl1271_cmd_role_enable/wl12xx_cmd_role_enable/

Same thing for wl1271_cmd_role_disable and all the other functions whose
declaration changed.

I was thinking that we could use the role_id directly from the wl struct
here, but then I changed my mind, because I think it's not good that the
cmd functions themselves change the wl struct.  At some point we need to
split the HW-related part of wl (phy) from the context-related elements
(vif).  For most of the cases, if not all, the cmd functions only use
the HW-related elements.

Anyway, this small detour just supports the usage of role_id as a
separate argument instead of taking it from wl. ;)


> {
> -	struct wl1271_cmd_join *join;
> -	int ret, i;
> -	u8 *bssid;
> +	struct wl1271_cmd_role_enable *cmd;
> +	int ret;
> +
> +	wl1271_debug(DEBUG_CMD, "cmd role enable");
> +
> +	if (WARN_ON(*role_id != WL1271_INVALID_ROLE_ID))
> +		return -EINVAL;

Shouldn't we return -EBUSY here instead?

> 
> -       join = kzalloc(sizeof(*join), GFP_KERNEL);
> -       if (!join) {
> +       cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> +       if (!cmd) {
>                 ret = -ENOMEM;
>                 goto out;
>         }
>  
> -       wl1271_debug(DEBUG_CMD, "cmd join");
> +       /* get role id */
> +       cmd->role_id = find_first_zero_bit(wl->roles_map, WL1271_MAX_ROLES);
> +       if (cmd->role_id >= WL1271_MAX_ROLES) {
> +               ret = -EBUSY;
> +               goto out_free;
> +       }
> +
> +       memcpy(cmd->mac_address, wl->mac_addr, ETH_ALEN);

To keep aligned with my comment about phy vs. vif context, I think it
would be nicer to pass the MAC address as an argument to this function
as well.  When we implement multirole, we will need different MAC
addresses for each role, so we can't really use the value from wl. 


> +int wl1271_cmd_role_disable(struct wl1271 *wl, u8 *role_id)
> +{
> +	struct wl1271_cmd_role_disable *cmd;
> +	int ret;
> +
> +	wl1271_debug(DEBUG_CMD, "cmd role disable");
> +
> +	if (WARN_ON(*role_id == WL1271_INVALID_ROLE_ID))
> +		return -EINVAL;

Maybe we should return -ENOENT instead?


> +static int wl1271_allocate_link(struct wl1271 *wl, u8 *hlid)
> +{
> +	u8 alloced = find_first_zero_bit(wl->links_map, WL1271_MAX_LINKS);

This is *very* netpicky, but could you call this variable "link" or
something instead of "alloced"? Alloced is annoying to read because of
the missing apostrophe! :P


> +int wl1271_cmd_role_start_sta(struct wl1271 *wl)
> +{
> +	struct wl1271_cmd_role_start *cmd;
> +	int ret;
> +
> +	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> +	if (!cmd) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	wl1271_debug(DEBUG_CMD, "cmd role start sta %d", wl->role_id);
> +
> +	cmd->role_id = wl->role_id;
>  	if (wl->band == IEEE80211_BAND_5GHZ)
> -		join->bss_type |= WL1271_JOIN_CMD_BSS_TYPE_5GHZ;
> +		cmd->band |= WL1271_BAND_5GHZ;
> +	cmd->channel = wl->channel;
> +	cmd->sta.basic_rate_set = cpu_to_le32(wl->basic_rate_set);
> +	cmd->sta.beacon_interval = cpu_to_le16(wl->beacon_int);
> +	cmd->sta.ssid_type = WL1271_SSID_TYPE_ANY;
> +	cmd->sta.ssid_len = wl->ssid_len;
> +	memcpy(cmd->sta.ssid, wl->ssid, wl->ssid_len);
> +	memcpy(cmd->sta.bssid, wl->bssid, ETH_ALEN);
> +	cmd->sta.local_rates = cpu_to_le32(wl->rate_set);
> +
> +	if (wl->sta_hlid == WL1271_INVALID_LINK_ID) {
> +		ret = wl1271_allocate_link(wl, &wl->sta_hlid);
> +		if (ret)
> +			goto out_free;
> +	}
> +	cmd->sta.hlid = wl->sta_hlid;
> +	cmd->sta.session = wl->session_counter;
> +	cmd->sta.remote_rates = cpu_to_le32(wl->rate_set);

Same thing here about all the vif context stuff that is in the wl
struct.  But let's not care about it right now, in this case we can't
pass everything as separate args to this function.  We'll need a
separate struct for it later on.


> +int wl1271_cmd_role_stop_sta(struct wl1271 *wl)
> +{
> +	struct wl1271_cmd_role_stop *cmd;
> +	int ret;
> +
> +	if (WARN_ON(wl->sta_hlid == WL1271_INVALID_LINK_ID))
> +		return -EINVAL;
> +
> +	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> +	if (!cmd) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	wl1271_debug(DEBUG_CMD, "cmd role stop");

s/cmd role stop"/cmd role stop sta %d" wl->role_id/ just to keep it
consistent.


> +
> +	cmd->role_id = wl->role_id;
> +	cmd->disc_type = WL1271_DISC_IMMEDIATE;
> +	cmd->reason = cpu_to_le16(1); /* STATUS_UNSPECIFIED */

Isn't there a more reasonable reason? :) In any case, this should at
least be in an enum together with the other possible reasons instead of
hardcoded here.


> +int wl1271_cmd_role_start_ap(struct wl1271 *wl)
> +{
> +	struct wl1271_cmd_role_start *cmd;
> +	struct ieee80211_bss_conf *bss_conf = &wl->vif->bss_conf;
> +	int ret;
> +
> +	wl1271_debug(DEBUG_CMD, "cmd start ap role");

Again, "cmd start role ap %d"...

> +
> +	/*
> +	 * We currently do not support hidden SSID. The real SSID
> +	 * should be fetched from mac80211 first.
> +	 */
> +	if (wl->ssid_len == 0) {
> +		wl1271_warning("Hidden SSID currently not supported for AP");
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> +	if (!cmd) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	cmd->role_id = wl->role_id;
> +	cmd->ap.aging_period = cpu_to_le16(wl->conf.tx.ap_aging_period);
> +	cmd->ap.bss_index = WL1271_AP_BSS_INDEX;
> +	cmd->ap.global_hlid = WL1271_AP_GLOBAL_HLID;
> +	cmd->ap.broadcast_hlid = WL1271_AP_BROADCAST_HLID;
> +	cmd->ap.basic_rate_set = cpu_to_le32(wl->basic_rate_set);
> +	cmd->ap.beacon_interval = cpu_to_le16(wl->beacon_int);
> +	cmd->ap.dtim_interval = bss_conf->dtim_period;
> +	cmd->ap.beacon_expiry = WL1271_AP_DEF_BEACON_EXP;
> +	cmd->channel = wl->channel;
> +	cmd->ap.ssid_len = wl->ssid_len;
> +	cmd->ap.ssid_type = WL1271_SSID_TYPE_PUBLIC;
> +	memcpy(cmd->ap.ssid, wl->ssid, wl->ssid_len);
> +	cmd->ap.local_rates = cpu_to_le32(0xffffffff);
> +
> +	switch (wl->band) {
> +	case IEEE80211_BAND_2GHZ:
> +		cmd->band = RADIO_BAND_2_4GHZ;
> +		break;
> +	case IEEE80211_BAND_5GHZ:
> +		cmd->band = RADIO_BAND_5GHZ;
> +		break;
> +	default:
> +		wl1271_warning("ap start - unknown band: %d", (int)wl->band);
> +		cmd->band = RADIO_BAND_2_4GHZ;
> +		break;
> +	}
> +
> +	ret = wl1271_cmd_send(wl, CMD_ROLE_START, cmd, sizeof(*cmd), 0);
> +	if (ret < 0) {
> +		wl1271_error("failed to initiate cmd start bss");

"cmd start role"


> +int wl1271_cmd_role_stop_ap(struct wl1271 *wl)
> +{
> +	struct wl1271_cmd_role_stop *cmd;
> +	int ret;
> +
> +	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> +	if (!cmd) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	wl1271_debug(DEBUG_CMD, "cmd role ap stop");

"cmd role stop ap %d"

This is all nitpicking again, but keeping this stuff consistent makes it
easier when grepping. ;)


> -int wl1271_cmd_set_sta_state(struct wl1271 *wl)
> +int wl1271_cmd_set_peer_state(struct wl1271 *wl)
>  {
> -	struct wl1271_cmd_set_sta_state *cmd;
> +	struct wl1271_cmd_set_peer_state *cmd;
>  	int ret = 0;
>  
> -	wl1271_debug(DEBUG_CMD, "cmd set sta state");
> +	wl1271_debug(DEBUG_CMD, "cmd set sta state (hlid=%d)", wl->sta_hlid);

"cmd set peer state"


> +	cmd->hlid = wl->sta_hlid;
>  	cmd->state = WL1271_CMD_STA_STATE_CONNECTED;
>  
> -	ret = wl1271_cmd_send(wl, CMD_SET_STA_STATE, cmd, sizeof(*cmd), 0);
> +	ret = wl1271_cmd_send(wl, CMD_SET_PEER_STATE, cmd, sizeof(*cmd), 0);
>  	if (ret < 0) {
>  		wl1271_error("failed to send set STA state command");

"...set peer state..."


> -int wl1271_cmd_add_sta(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid)
> +int wl1271_cmd_add_peer(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid)
>  {
> -	struct wl1271_cmd_add_sta *cmd;
> +	struct wl1271_cmd_add_peer *cmd;
>  	int ret;
>  
>  	wl1271_debug(DEBUG_CMD, "cmd add sta %d", (int)hlid);

"cmd add peer"


> @@ -1167,28 +1253,28 @@ int wl1271_cmd_add_sta(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid)
>  
>  	cmd->supported_rates = cpu_to_le32(wl1271_tx_enabled_rates_get(wl,
>  						sta->supp_rates[wl->band]));
>  
>  	wl1271_debug(DEBUG_CMD, "new sta rates: 0x%x", cmd->supported_rates);

s/sta/peer/


> -	ret = wl1271_cmd_send(wl, CMD_ADD_STA, cmd, sizeof(*cmd), 0);
> +	ret = wl1271_cmd_send(wl, CMD_ADD_PEER, cmd, sizeof(*cmd), 0);
>  	if (ret < 0) {
>  		wl1271_error("failed to initiate cmd add sta");

Again...


> -int wl1271_cmd_remove_sta(struct wl1271 *wl, u8 hlid)
> +int wl1271_cmd_remove_peer(struct wl1271 *wl, u8 hlid)
>  {
> -	struct wl1271_cmd_remove_sta *cmd;
> +	struct wl1271_cmd_remove_peer *cmd;
>  	int ret;
>  
>  	wl1271_debug(DEBUG_CMD, "cmd remove sta %d", (int)hlid);

and again...


> @@ -1198,23 +1284,24 @@ int wl1271_cmd_remove_sta(struct wl1271 *wl, u8 hlid)
>  
>  	cmd->hlid = hlid;
>  	/* We never send a deauth, mac80211 is in charge of this */
>  	cmd->reason_opcode = 0;
>  	cmd->send_deauth_flag = 0;
>  
> -	ret = wl1271_cmd_send(wl, CMD_REMOVE_STA, cmd, sizeof(*cmd), 0);
> +	ret = wl1271_cmd_send(wl, CMD_REMOVE_PEER, cmd, sizeof(*cmd), 0);
>  	if (ret < 0) {
>  		wl1271_error("failed to initiate cmd remove sta");

...and yet again.


> @@ -80,48 +83,58 @@ enum wl1271_commands {
>  	CMD_ENABLE_RX       = 3,
>  	CMD_ENABLE_TX       = 4,
>  	CMD_DISABLE_RX      = 5,
>  	CMD_DISABLE_TX      = 6,
>  	CMD_SCAN            = 8,
>  	CMD_STOP_SCAN       = 9,
> -	CMD_START_JOIN      = 11,
>  	CMD_SET_KEYS        = 12,
>  	CMD_READ_MEMORY     = 13,
>  	CMD_WRITE_MEMORY    = 14,
>  	CMD_SET_TEMPLATE    = 19,
>  	CMD_TEST            = 23,
>  	CMD_NOISE_HIST      = 28,
> -	CMD_LNA_CONTROL     = 32,
> +	CMD_QUIET_ELEMENT_SET_STATE  = 29,
>  	CMD_SET_BCN_MODE    = 33,
>  	CMD_MEASUREMENT      = 34,
>  	CMD_STOP_MEASUREMENT = 35,
> -	CMD_DISCONNECT       = 36,
>  	CMD_SET_PS_MODE      = 37,
>  	CMD_CHANNEL_SWITCH   = 38,
>  	CMD_STOP_CHANNEL_SWICTH = 39,
>  	CMD_AP_DISCOVERY     = 40,
>  	CMD_STOP_AP_DISCOVERY = 41,
> -	CMD_SPS_SCAN = 42,
> -	CMD_STOP_SPS_SCAN = 43,
>  	CMD_HEALTH_CHECK     = 45,
>  	CMD_DEBUG            = 46,
>  	CMD_TRIGGER_SCAN_TO  = 47,

Should we align all this?


> 	CMD_CONNECTION_SCAN_CFG      = 48,
>  	CMD_CONNECTION_SCAN_SSID_CFG = 49,
>  	CMD_START_PERIODIC_SCAN      = 50,
>  	CMD_STOP_PERIODIC_SCAN       = 51,
> -	CMD_SET_STA_STATE            = 52,
> -	CMD_CONFIG_FWLOGGER          = 53,
> -	CMD_START_FWLOGGER           = 54,
> -	CMD_STOP_FWLOGGER            = 55,
> +	CMD_SET_PEER_STATE           = 52,
> +	CMD_REMAIN_ON_CHANNEL        = 53,
> +	CMD_CANCEL_REMAIN_ON_CHANNEL = 54,
>  
> -	/* AP mode commands */
> -	CMD_BSS_START                = 60,
> -	CMD_BSS_STOP                 = 61,
> -	CMD_ADD_STA                  = 62,
> -	CMD_REMOVE_STA               = 63,
> +	CMD_CONFIG_FWLOGGER          = 55,
> +	CMD_START_FWLOGGER           = 56,
> +	CMD_STOP_FWLOGGER            = 57,
> +
> +	/* AP commands */
> +	CMD_ADD_PEER                 = 62,
> +	CMD_REMOVE_PEER              = 63,
> +
> +	/* Role API */
> +	CMD_ROLE_ENABLE              = 70,
> +	CMD_ROLE_DISABLE             = 71,
> +	CMD_ROLE_START               = 72,
> +	CMD_ROLE_STOP                = 73,
> +
> +	/* WIFI Direct */
> +	CMD_WFD_START_DISCOVERY      = 80,
> +	CMD_WFD_STOP_DISCOVERY	     = 81,
> +	CMD_WFD_ATTRIBUTE_CONFIG     = 82,
> +
> +	CMD_NOP                        = 100,

Please align.


> @@ -190,12 +201,13 @@ enum {
>  	CMD_STATUS_OUT_OF_MEMORY		= 16,
>  	CMD_STATUS_STA_TABLE_FULL		= 17,
>  	CMD_STATUS_RADIO_ERROR		= 18,
>  	CMD_STATUS_WRONG_NESTING		= 19,
>  	CMD_STATUS_TIMEOUT		= 21, /* Driver internal use.*/
>  	CMD_STATUS_FW_RESET		= 22, /* Driver internal use.*/
> +	CMD_STATUS_TEMPLATE_OUT_OF_TEMPORARY_MEMORY = 23,

Should we use CMD_STATUS_TEMPLATE_OOM or something?

> +enum wl1271_band {
> +	WL1271_BAND_2_4GHZ = 0,  /* 2.4 Ghz band */
> +	WL1271_BAND_5GHZ = 1,    /* 5 Ghz band */
> +	WL1271_BAND_JAPAN_4_9_GHZ = 2,
> +	WL1271_BAND_DEFAULT = WL1271_BAND_2_4GHZ,
> +	WL1271_BAND_INVALID = 0x7E,
> +	WL1271_BAND_MAX_RADIO = 0x7F,
> +};

The comments here are unnecessary and could we align the ='s?


> +		/* ap & p2p_go use the same struct */
> +		struct {
> +			/* Aging period in seconds*/
> +			__le16 aging_period;

Maybe instead of having the comment in a separate line we could use:

__le16 aging_period; /* in secs */

> +			/* Beacon expiry time in ms */
> +			u8 beacon_expiry;

Same here.


> +enum wl1271_disconnection_type {
> +	WL1271_DISC_IMMEDIATE,
> +	WL1271_DISC_DE_AUTH,
> +	WL1271_DISC_DIS_ASSOC,

Seems better if you use WL12XX_DISC_DEAUTH and WL12XX_DISC_DISASSOC.
But, in any case, this seems to be duplicate as it is already defined
below in enum wl1271_disconnect_type.


> +struct wl1271_cmd_role_stop {
> +	struct wl1271_cmd_header header;
> +
> +	u8 role_id;
> +	u8 disc_type; /* de-auth/de-asso  or not (only STA and P2P_CLI) */

I think we can remove the "de-auth/de-asso  o not" as it doesn't really
say anything.


> +enum wl1271_cmd_lid_key_type {
> +	UNICAST_LID_TYPE     = 0,
> +	BROADCAST_LID_TYPE   = 1,
> +	WEP_DEFAULT_LID_TYPE = 2
> +};

Doesn't LID_TYPE_UNICAST, LID_TYPE_BROADCAST and so on look better?


> @@ -493,75 +559,29 @@ struct wl1271_ext_radio_parms_cmd {
>  enum wl1271_disconnect_type {
>  	DISCONNECT_IMMEDIATE,
>  	DISCONNECT_DEAUTH,
>  	DISCONNECT_DISASSOC
>  };

Here, as I said above, the disconnection types are already defined.


> enum wl1271_ssid_type {
> -	SSID_TYPE_PUBLIC = 0,
> -	SSID_TYPE_HIDDEN = 1
> +	WL1271_SSID_TYPE_PUBLIC = 0,
> +	WL1271_SSID_TYPE_HIDDEN = 1,
> +	WL1271_SSID_TYPE_ANY = 2,
>  };

Since you're changing this, please use WL12XX and align the ='s.


> diff --git a/drivers/net/wireless/wl12xx/event.h b/drivers/net/wireless/wl12xx/event.h
> index e524ad6..2cc6788 100644
> --- a/drivers/net/wireless/wl12xx/event.h
> +++ b/drivers/net/wireless/wl12xx/event.h
> @@ -46,106 +46,91 @@ enum {
>  	RSSI_SNR_TRIGGER_5_EVENT_ID              = BIT(5),
>  	RSSI_SNR_TRIGGER_6_EVENT_ID              = BIT(6),
>  	RSSI_SNR_TRIGGER_7_EVENT_ID              = BIT(7),
>  	MEASUREMENT_START_EVENT_ID		 = BIT(8),
>  	MEASUREMENT_COMPLETE_EVENT_ID		 = BIT(9),
>  	SCAN_COMPLETE_EVENT_ID			 = BIT(10),
> -	SCHEDULED_SCAN_COMPLETE_EVENT_ID	 = BIT(11),
> +	WFD_DISCOVERY_COMPLETE_EVENT_ID		 = BIT(11),
>  	AP_DISCOVERY_COMPLETE_EVENT_ID		 = BIT(12),
>  	PS_REPORT_EVENT_ID			 = BIT(13),
>  	PSPOLL_DELIVERY_FAILURE_EVENT_ID	 = BIT(14),
>  	DISCONNECT_EVENT_COMPLETE_ID		 = BIT(15),
> -	JOIN_EVENT_COMPLETE_ID			 = BIT(16),
> +	RESERVED2				 = BIT(16),

Where is RESERVED1? Maybe this doesn't even have to be defined, just a
comment to make it clear we're jumping one value would suffice.


> struct event_mailbox {
>  	__le32 events_vector;
>  	__le32 events_mask;
>  	__le32 reserved_1;
>  	__le32 reserved_2;
>  
> -	u8 dbg_event_id;
> -	u8 num_relevant_params;
> -	__le16 reserved_3;
> -	__le32 event_report_p1;
> -	__le32 event_report_p2;
> -	__le32 event_report_p3;
> -
>  	u8 number_of_scan_results;
>  	u8 scan_tag;
> -	u8 reserved_4[2];
> -	__le32 compl_scheduled_scan_status;
> +	u8 completed_scan_status;
> +	u8 reserved_3[1];

It doesn't have to be an array.


> +	/* tuned channel (roc) */
> +	u8 channel;

Maybe roc_channel would be clearer?


> +	/* hlid removed (STA_REMOVE_COMPLETE_EVENT) */
> +	__le16 hlid_removed_bitmap;

The comment doesn't help much here.


> +	/* rx ba constraint */
> +
> +	/* role id for which this constraint is set. 0xFF means any role. */
> +	u8 role_id;

Can you move the comment about the role_id to the same line as it is
defined? Would look cleaner.

It would be nice if all these blocks would be defined in separate
structs, but you can decide.  They actually seem to be different structs
in the firmware, because of all the "reserved" paddings.  Even nicer if
they could be in a union, but that's not how the FW API is defined.
*sigh*


-- 
Cheers,
Luca.

