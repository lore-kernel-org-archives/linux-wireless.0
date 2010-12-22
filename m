Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:31802 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab0LVVQ4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 16:16:56 -0500
Subject: Re: [PATCH v2 04/18] wl1271: AP-mode high level commands
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1293028057-6212-5-git-send-email-arik@wizery.com>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
	 <1293028057-6212-5-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 23:16:54 +0200
Message-ID: <1293052614.14423.42.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-22 at 16:27 +0200, ext Arik Nemtsov wrote:
> Add commands to start/stop BSS, add/remove STA and configure encryption
> keys. Split the encryption commands "set key" and "set default key" into
> AP and STA specific versions.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

[...]

> @@ -850,3 +943,178 @@ out_free:
>  out:
>  	return ret;
>  }
> +
> +int wl1271_cmd_start_bss(struct wl1271 *wl)
> +{
> +	struct wl1271_cmd_bss_start *cmd;
> +	struct ieee80211_bss_conf *bss_conf = &wl->vif->bss_conf;
> +	int ret;
> +
> +	wl1271_debug(DEBUG_CMD, "cmd start bss");
> +
> +	/*
> +	 * FIXME: We currently do not support hidden SSID. The real SSID
> +	 * should be fetched from mac80211 first.
> +	 */
> +	if (wl->ssid_len == 0) {
> +		wl1271_warning("Hidden SSID currently not supported for AP");
> +		return -EINVAL;
> +	}
> +
> +	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> +	if (!cmd) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}

Please decide if you want to return directly here or set ret and goto
out.  For consistency, I'd suggest to set ret and goto out, since this
is how (most of) the rest of the code does.


> +int wl1271_cmd_add_sta(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid)
> +{
> +	struct wl1271_cmd_add_sta *cmd;
> +	int ret;
> +
> +	wl1271_debug(DEBUG_CMD, "cmd add sta %d", (int)hlid);
> +
> +	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> +	if (!cmd) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	/* currently we don't support UAPSD */
> +	memset(cmd->psd_type, 0, sizeof(cmd->psd_type));
> +	cmd->sp_len = 0;

No need to memset, since you're kzalloc'ing anyway.  I guess just a good
comment here is enough.


> diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
> index 2a1d9db..02f843c 100644
> --- a/drivers/net/wireless/wl12xx/cmd.h
> +++ b/drivers/net/wireless/wl12xx/cmd.h
> @@ -54,12 +54,20 @@ struct sk_buff *wl1271_cmd_build_ap_probe_req(struct wl1271 *wl,
>  int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, __be32 ip_addr);
>  int wl1271_build_qos_null_data(struct wl1271 *wl);
>  int wl1271_cmd_build_klv_null_data(struct wl1271 *wl);
> -int wl1271_cmd_set_default_wep_key(struct wl1271 *wl, u8 id);
> -int wl1271_cmd_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
> +int wl1271_cmd_set_sta_default_wep_key(struct wl1271 *wl, u8 id);
> +int wl1271_cmd_set_ap_default_wep_key(struct wl1271 *wl, u8 id);
> +int wl1271_cmd_set_sta_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
>  		       u8 key_size, const u8 *key, const u8 *addr,
>  		       u32 tx_seq_32, u16 tx_seq_16);

Indentation?

> +int wl1271_cmd_set_ap_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
> +			u8 key_size, const u8 *key, u8 hlid, u32 tx_seq_32,
> +			u16 tx_seq_16);

Ditto.


-- 
Cheers,
Luca.

