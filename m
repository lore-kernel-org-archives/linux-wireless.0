Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40586 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983Ab0JFF0v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 01:26:51 -0400
From: "Gabay, Benzy" <benzyg@ti.com>
To: Luciano Coelho <luciano.coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Date: Wed, 6 Oct 2010 00:26:46 -0500
Subject: RE: [PATCH 13/25] wl1271: Enable/disable 11a support based on INI
 configuration
Message-ID: <676FD6AA0F002F49B89E70F0C5EFD22C135ADBA314@dlee04.ent.ti.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
 <1285576669-8070-14-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-14-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Juuso ,
I thought that there is no .ini in the 1271 MAC802.11 solution. 
According to the code below you are deciding if it is "a" or not according to NVS file.

Is it a typo in your header description or did I get it wrong?

> Sent: Monday, September 27, 2010 3:38 AM
> 
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> Instead of hardcoding 11a support, enable/disable driver support based
> on
> the dual-mode-select parameter in the nvs-file general paramters.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> ---
>  drivers/net/wireless/wl12xx/wl1271.h          |   18 +++--------------
> -
>  drivers/net/wireless/wl12xx/wl1271_boot.c     |   22
> ++++++++++++++++++++++
>  drivers/net/wireless/wl12xx/wl1271_init.c     |    2 +-
>  drivers/net/wireless/wl12xx/wl1271_main.c     |   18 +++--------------
> -
>  drivers/net/wireless/wl12xx/wl1271_scan.c     |    2 +-
>  drivers/net/wireless/wl12xx/wl1271_testmode.c |   14 +-------------
>  6 files changed, 31 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/wl1271.h
> b/drivers/net/wireless/wl12xx/wl1271.h
> index 1098d16..763ece8 100644
> --- a/drivers/net/wireless/wl12xx/wl1271.h
> +++ b/drivers/net/wireless/wl12xx/wl1271.h
> @@ -117,11 +117,6 @@ enum {
>  #define WL1271_TX_SECURITY_LO16(s) ((u16)((s) & 0xffff))
>  #define WL1271_TX_SECURITY_HI32(s) ((u32)(((s) >> 16) & 0xffffffff))
> 
> -/*
> - * Enable/disable 802.11a support for WL1273
> - */
> -#undef WL1271_80211A_ENABLED
> -
>  #define WL1271_BUSY_WORD_CNT 1
>  #define WL1271_BUSY_WORD_LEN (WL1271_BUSY_WORD_CNT * sizeof(u32))
> 
> @@ -363,6 +358,7 @@ struct wl1271 {
>  	u8 *fw;
>  	size_t fw_len;
>  	struct wl1271_nvs_file *nvs;
> +	size_t nvs_len;
> 
>  	s8 hw_pg_ver;
> 
> @@ -476,6 +472,8 @@ struct wl1271 {
> 
>  	bool sg_enabled;
> 
> +	bool enable_11a;
> +
>  	struct list_head list;
> 
>  	/* Most recently reported noise in dBm */
> @@ -499,14 +497,4 @@ int wl1271_plt_stop(struct wl1271 *wl);
>  #define WL1271_PRE_POWER_ON_SLEEP 20 /* in miliseconds */
>  #define WL1271_POWER_ON_SLEEP 200 /* in miliseconds */
> 
> -static inline bool wl1271_11a_enabled(void)
> -{
> -	/* FIXME: this could be determined based on the NVS-INI file */
> -#ifdef WL1271_80211A_ENABLED
> -	return true;
> -#else
> -	return false;
> -#endif
> -}
> -
>  #endif
> diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c
> b/drivers/net/wireless/wl12xx/wl1271_boot.c
> index f750d5a..b910212 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_boot.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
> @@ -225,6 +225,28 @@ static int wl1271_boot_upload_nvs(struct wl1271
> *wl)
>  	if (wl->nvs == NULL)
>  		return -ENODEV;
> 
> +	/*
> +	 * FIXME: the LEGACY NVS image support (NVS's missing the 5GHz
> band
> +	 * configurations) can be removed when those NVS files stop
> floating
> +	 * around.
> +	 */
> +	if (wl->nvs_len == sizeof(struct wl1271_nvs_file) ||
> +	    wl->nvs_len == WL1271_INI_LEGACY_NVS_FILE_SIZE) {
> +		if (wl->nvs->general_params.dual_mode_select)
> +			wl->enable_11a = true;
> +	}
> +
> +	if (wl->nvs_len != sizeof(struct wl1271_nvs_file) &&
> +	    (wl->nvs_len != WL1271_INI_LEGACY_NVS_FILE_SIZE ||
> +	     wl->enable_11a)) {
> +		wl1271_error("nvs size is not as expected: %zu != %zu",
> +			     wl->nvs_len, sizeof(struct wl1271_nvs_file));
> +		kfree(wl->nvs);
> +		wl->nvs = NULL;
> +		wl->nvs_len = 0;
> +		return -EILSEQ;
> +	}
> +
>  	/* only the first part of the NVS needs to be uploaded */
>  	nvs_len = sizeof(wl->nvs->nvs);
>  	nvs_ptr = (u8 *)wl->nvs->nvs;
> diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c
> b/drivers/net/wireless/wl12xx/wl1271_init.c
> index 4447af1..879bae0 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_init.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_init.c
> @@ -61,7 +61,7 @@ int wl1271_init_templates_config(struct wl1271 *wl)
>  	if (ret < 0)
>  		return ret;
> 
> -	if (wl1271_11a_enabled()) {
> +	if (wl->enable_11a) {
>  		size_t size = sizeof(struct wl12xx_probe_req_template);
>  		ret = wl1271_cmd_template_set(wl,
> CMD_TEMPL_CFG_PROBE_REQ_5,
>  					      NULL, size, 0,
> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c
> b/drivers/net/wireless/wl12xx/wl1271_main.c
> index bbd075a..11e112f 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
> @@ -622,20 +622,6 @@ static int wl1271_fetch_nvs(struct wl1271 *wl)
>  		return ret;
>  	}
> 
> -	/*
> -	 * FIXME: the LEGACY NVS image support (NVS's missing the 5GHz
> band
> -	 * configurations) can be removed when those NVS files stop
> floating
> -	 * around.
> -	 */
> -	if (fw->size != sizeof(struct wl1271_nvs_file) &&
> -	    (fw->size != WL1271_INI_LEGACY_NVS_FILE_SIZE ||
> -	     wl1271_11a_enabled())) {
> -		wl1271_error("nvs size is not as expected: %zu != %zu",
> -			     fw->size, sizeof(struct wl1271_nvs_file));
> -		ret = -EILSEQ;
> -		goto out;
> -	}
> -
>  	wl->nvs = kmemdup(fw->data, sizeof(struct wl1271_nvs_file),
> GFP_KERNEL);
> 
>  	if (!wl->nvs) {
> @@ -644,6 +630,8 @@ static int wl1271_fetch_nvs(struct wl1271 *wl)
>  		goto out;
>  	}
> 
> +	wl->nvs_len = fw->size;
> +
>  out:
>  	release_firmware(fw);
> 
> @@ -2414,7 +2402,7 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
>  	wl->hw->wiphy->max_scan_ssids = 1;
>  	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl1271_band_2ghz;
> 
> -	if (wl1271_11a_enabled())
> +	if (wl->enable_11a)
>  		wl->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
> &wl1271_band_5ghz;
> 
>  	wl->hw->queues = 4;
> diff --git a/drivers/net/wireless/wl12xx/wl1271_scan.c
> b/drivers/net/wireless/wl12xx/wl1271_scan.c
> index 7f42ca9..8d30150 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_scan.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_scan.c
> @@ -188,7 +188,7 @@ void wl1271_scan_stm(struct wl1271 *wl)
>  		ret = wl1271_scan_send(wl, IEEE80211_BAND_2GHZ, true,
>  				       wl->conf.tx.basic_rate);
>  		if (ret == WL1271_NOTHING_TO_SCAN) {
> -			if (wl1271_11a_enabled())
> +			if (wl->enable_11a)
>  				wl->scan.state = WL1271_SCAN_STATE_5GHZ_ACTIVE;
>  			else
>  				wl->scan.state = WL1271_SCAN_STATE_DONE;
> diff --git a/drivers/net/wireless/wl12xx/wl1271_testmode.c
> b/drivers/net/wireless/wl12xx/wl1271_testmode.c
> index 6e0952f..a3aa843 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_testmode.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_testmode.c
> @@ -199,19 +199,6 @@ static int wl1271_tm_cmd_nvs_push(struct wl1271
> *wl, struct nlattr *tb[])
>  	buf = nla_data(tb[WL1271_TM_ATTR_DATA]);
>  	len = nla_len(tb[WL1271_TM_ATTR_DATA]);
> 
> -	/*
> -	 * FIXME: the LEGACY NVS image support (NVS's missing the 5GHz
> band
> -	 * configurations) can be removed when those NVS files stop
> floating
> -	 * around.
> -	 */
> -	if (len != sizeof(struct wl1271_nvs_file) &&
> -	    (len != WL1271_INI_LEGACY_NVS_FILE_SIZE ||
> -	     wl1271_11a_enabled())) {
> -		wl1271_error("nvs size is not as expected: %zu != %zu",
> -			     len, sizeof(struct wl1271_nvs_file));
> -		return -EMSGSIZE;
> -	}
> -
>  	mutex_lock(&wl->mutex);
> 
>  	kfree(wl->nvs);
> @@ -224,6 +211,7 @@ static int wl1271_tm_cmd_nvs_push(struct wl1271
> *wl, struct nlattr *tb[])
>  	}
> 
>  	memcpy(wl->nvs, buf, len);
> +	wl->nvs_len = len;
> 
>  	wl1271_debug(DEBUG_TESTMODE, "testmode pushed nvs");
> 
> --
>

Benzy Gabay

