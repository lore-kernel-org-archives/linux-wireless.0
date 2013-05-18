Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2474 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab3ERTyE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 15:54:04 -0400
Message-ID: <5197DC4F.7030503@broadcom.com> (sfid-20130518_215410_404745_1221C3D8)
Date: Sat, 18 May 2013 21:53:51 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: REGRESSION: v3.10-rc1: [PATCH 04/15] brcmsmac: remove
 brcms_bss_cfg->associated
References: <1364085963-25940-1-git-send-email-hauke@hauke-m.de>
 <1364085963-25940-5-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1364085963-25940-5-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/24/2013 01:45 AM, Hauke Mehrtens wrote:
> Replaced the usage with pub->associated.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>   drivers/net/wireless/brcm80211/brcmsmac/main.c |   12 +++---------
>   drivers/net/wireless/brcm80211/brcmsmac/main.h |    2 --
>   2 files changed, 3 insertions(+), 11 deletions(-)

Hi Hauke,

I had a problem with bcm43224 in STA mode and bisecting it shows this 
change as culprit. On laptop I installed kernel with brcmsmac compiled 
as module. It comes up and associates during boot, but after logging in 
there is no connectivity. Triggering reassoc gives connectivity for some 
time, but after a while (1-2 min) it stops.

I am looking into it. Given the function name below (brcms_c_ps_allowed) 
it may be power-save related. I will keep you informed.

Gr. AvS

> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> index 90e6c0d..810b7e2 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> @@ -3049,8 +3049,6 @@ static void brcms_b_antsel_set(struct brcms_hardware *wlc_hw, u32 antsel_avail)
>    */
>   static bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
>   {
> -	struct brcms_bss_cfg *cfg = wlc->bsscfg;
> -
>   	/* disallow PS when one of the following global conditions meets */
>   	if (!wlc->pub->associated)
>   		return false;
> @@ -3059,9 +3057,6 @@ static bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
>   	if (wlc->filter_flags & FIF_PROMISC_IN_BSS)
>   		return false;
>
> -	if (cfg->associated)
> -		return false;
> -
>   	return true;
>   }
>
> @@ -3819,7 +3814,7 @@ static void brcms_c_set_home_chanspec(struct brcms_c_info *wlc, u16 chanspec)
>   	if (wlc->home_chanspec != chanspec) {
>   		wlc->home_chanspec = chanspec;
>
> -		if (wlc->bsscfg->associated)
> +		if (wlc->pub->associated)
>   			wlc->bsscfg->current_bss->chanspec = chanspec;
>   	}
>   }
> @@ -5433,7 +5428,7 @@ static void brcms_c_ofdm_rateset_war(struct brcms_c_info *wlc)
>   	u8 r;
>   	bool war = false;
>
> -	if (wlc->bsscfg->associated)
> +	if (wlc->pub->associated)
>   		r = wlc->bsscfg->current_bss->rateset.rates[0];
>   	else
>   		r = wlc->default_bss->rateset.rates[0];
> @@ -5527,7 +5522,7 @@ int brcms_c_set_rateset(struct brcms_c_info *wlc, struct brcm_rateset *rs)
>   	/* merge rateset coming in with the current mcsset */
>   	if (wlc->pub->_n_enab & SUPPORT_11N) {
>   		struct brcms_bss_info *mcsset_bss;
> -		if (wlc->bsscfg->associated)
> +		if (wlc->pub->associated)
>   			mcsset_bss = wlc->bsscfg->current_bss;
>   		else
>   			mcsset_bss = wlc->default_bss;
> @@ -7496,7 +7491,6 @@ void brcms_c_scan_stop(struct brcms_c_info *wlc)
>   void brcms_c_associate_upd(struct brcms_c_info *wlc, bool state)
>   {
>   	wlc->pub->associated = state;
> -	wlc->bsscfg->associated = state;
>   }
>
>   /*
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
> index 0cfe782..96dc2f4 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
> @@ -589,7 +589,6 @@ enum brcms_bss_type {
>    * type: interface type
>    * up: is this configuration up operational
>    * enable: is this configuration enabled
> - * associated: is BSS in ASSOCIATED state
>    * SSID_len: the length of SSID
>    * SSID: SSID string
>    *
> @@ -608,7 +607,6 @@ struct brcms_bss_cfg {
>   	enum brcms_bss_type type;
>   	bool up;
>   	bool enable;
> -	bool associated;
>   	u8 SSID_len;
>   	u8 SSID[IEEE80211_MAX_SSID_LEN];
>   	u8 BSSID[ETH_ALEN];
>


