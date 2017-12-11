Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58966 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750836AbdLKPec (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 10:34:32 -0500
Date: Mon, 11 Dec 2017 17:34:03 +0200
From: Ramon Fried <rfried@codeaurora.org>
To: Loic Poulain <loic.poulain@linaro.org>
Cc: kvalo@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-wireless@vger.kernel.org, bjorn.andersson@linaro.org,
        wcn36xx@lists.infradead.org, k.eugene.e@gmail.com
Subject: Re: [PATCH v2] wcn36xx: Fix dynamic power saving
Message-ID: <20171211153403.GA30332@codeaurora.org> (sfid-20171211_163436_679691_54EF7E79)
References: <1512982342-10343-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1512982342-10343-1-git-send-email-loic.poulain@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 11, 2017 at 10:52:22AM +0200, Loic Poulain wrote:
> Since driver does not report hardware dynamic power saving cap,
> this is up to the mac80211 to manage power saving timeout and
> state machine, using the ieee80211 config callback to report
> PS changes. This patch enables/disables PS mode according to
> the new configuration.
> 
> Remove old behaviour enabling PS mode in a static way, this make
> the device unusable when power save is enabled since device is
> forced to PS regardless RX/TX traffic.
> 

Hi.
I tried to see if this patch solves the ping delay once power save is
turned on and it appears it doesn't (log below).
I do see some change in the delay though in comparison to testing without the patch.
Bjorn, How did you test it ?

Thanks, Ramon.


root@dragonboard-410c:~# ping 192.168.0.1
PING 192.168.0.1 (192.168.0.1): 56 data bytes
64 bytes from 192.168.0.1: seq=0 ttl=64 time=2.688 ms
64 bytes from 192.168.0.1: seq=1 ttl=64 time=1.593 ms
64 bytes from 192.168.0.1: seq=2 ttl=64 time=1.581 ms
64 bytes from 192.168.0.1: seq=3 ttl=64 time=1.466 ms
64 bytes from 192.168.0.1: seq=4 ttl=64 time=1.625 ms
64 bytes from 192.168.0.1: seq=5 ttl=64 time=1.620 ms
64 bytes from 192.168.0.1: seq=6 ttl=64 time=2.907 ms
64 bytes from 192.168.0.1: seq=7 ttl=64 time=1.426 ms
64 bytes from 192.168.0.1: seq=8 ttl=64 time=1.521 ms
64 bytes from 192.168.0.1: seq=9 ttl=64 time=1.543 ms
64 bytes from 192.168.0.1: seq=10 ttl=64 time=6.804 ms
64 bytes from 192.168.0.1: seq=11 ttl=64 time=1.562 ms
64 bytes from 192.168.0.1: seq=12 ttl=64 time=3.148 ms
64 bytes from 192.168.0.1: seq=13 ttl=64 time=1.568 ms
64 bytes from 192.168.0.1: seq=14 ttl=64 time=1.491 ms
64 bytes from 192.168.0.1: seq=15 ttl=64 time=2.884 ms
64 bytes from 192.168.0.1: seq=16 ttl=64 time=1.669 ms
64 bytes from 192.168.0.1: seq=17 ttl=64 time=1.556 ms
64 bytes from 192.168.0.1: seq=18 ttl=64 time=1.487 ms
64 bytes from 192.168.0.1: seq=19 ttl=64 time=1.377 ms
64 bytes from 192.168.0.1: seq=20 ttl=64 time=1.534 ms
^C
--- 192.168.0.1 ping statistics ---
21 packets transmitted, 21 packets received, 0% packet loss
round-trip min/avg/max = 1.377/2.050/6.804 ms
root@dragonboard-410c:~# iw dev wlan0 set power_save on
root@dragonboard-410c:~# ping 192.168.0.1
PING 192.168.0.1 (192.168.0.1): 56 data bytes
64 bytes from 192.168.0.1: seq=0 ttl=64 time=4.849 ms
64 bytes from 192.168.0.1: seq=1 ttl=64 time=11.250 ms
64 bytes from 192.168.0.1: seq=2 ttl=64 time=11.402 ms
64 bytes from 192.168.0.1: seq=3 ttl=64 time=11.732 ms
64 bytes from 192.168.0.1: seq=4 ttl=64 time=10.076 ms
64 bytes from 192.168.0.1: seq=5 ttl=64 time=11.532 ms
64 bytes from 192.168.0.1: seq=6 ttl=64 time=15.479 ms
64 bytes from 192.168.0.1: seq=7 ttl=64 time=11.318 ms
64 bytes from 192.168.0.1: seq=8 ttl=64 time=13.299 ms
64 bytes from 192.168.0.1: seq=9 ttl=64 time=11.068 ms
64 bytes from 192.168.0.1: seq=10 ttl=64 time=11.087 ms
64 bytes from 192.168.0.1: seq=11 ttl=64 time=11.362 ms
64 bytes from 192.168.0.1: seq=12 ttl=64 time=11.341 ms
64 bytes from 192.168.0.1: seq=13 ttl=64 time=15.945 ms
64 bytes from 192.168.0.1: seq=14 ttl=64 time=11.318 ms
64 bytes from 192.168.0.1: seq=15 ttl=64 time=11.343 ms
64 bytes from 192.168.0.1: seq=16 ttl=64 time=11.378 ms
64 bytes from 192.168.0.1: seq=17 ttl=64 time=7.693 ms
64 bytes from 192.168.0.1: seq=18 ttl=64 time=11.703 ms
64 bytes from 192.168.0.1: seq=19 ttl=64 time=11.528 ms
64 bytes from 192.168.0.1: seq=20 ttl=64 time=12.008 ms
64 bytes from 192.168.0.1: seq=21 ttl=64 time=11.522 ms
64 bytes from 192.168.0.1: seq=22 ttl=64 time=12.949 ms
64 bytes from 192.168.0.1: seq=23 ttl=64 time=12.056 ms
64 bytes from 192.168.0.1: seq=24 ttl=64 time=13.097 ms
64 bytes from 192.168.0.1: seq=25 ttl=64 time=11.638 ms
^C
--- 192.168.0.1 ping statistics ---


> Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  v2: remove error msg on unbalanced bmps exit
>      return -EALREADY if not in bmps mode
> 
>  drivers/net/wireless/ath/wcn36xx/main.c | 23 ++++++++++++-----------
>  drivers/net/wireless/ath/wcn36xx/pmc.c  |  6 ++++--
>  2 files changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c
> b/drivers/net/wireless/ath/wcn36xx/main.c
> index f0b4d43..436b8ea 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -384,6 +384,18 @@ static int wcn36xx_config(struct ieee80211_hw *hw,
> u32 changed)
>  		}
>  	}
>  
> +	if (changed & IEEE80211_CONF_CHANGE_PS) {
> +		list_for_each_entry(tmp, &wcn->vif_list, list) {
> +			vif = wcn36xx_priv_to_vif(tmp);
> +			if (hw->conf.flags & IEEE80211_CONF_PS) {
> +				if (vif->bss_conf.ps) /* ps allowed ? */
> +					wcn36xx_pmc_enter_bmps_state(wcn,
> vif);
> +			} else {
> +				wcn36xx_pmc_exit_bmps_state(wcn, vif);
> +			}
> +		}
> +	}
> +
>  	mutex_unlock(&wcn->conf_mutex);
>  
>  	return 0;
> @@ -747,17 +759,6 @@ static void wcn36xx_bss_info_changed(struct
> ieee80211_hw *hw,
>  		vif_priv->dtim_period = bss_conf->dtim_period;
>  	}
>  
> -	if (changed & BSS_CHANGED_PS) {
> -		wcn36xx_dbg(WCN36XX_DBG_MAC,
> -			    "mac bss PS set %d\n",
> -			    bss_conf->ps);
> -		if (bss_conf->ps) {
> -			wcn36xx_pmc_enter_bmps_state(wcn, vif);
> -		} else {
> -			wcn36xx_pmc_exit_bmps_state(wcn, vif);
> -		}
> -	}
> -
>  	if (changed & BSS_CHANGED_BSSID) {
>  		wcn36xx_dbg(WCN36XX_DBG_MAC, "mac bss changed_bssid
> %pM\n",
>  			    bss_conf->bssid);
> diff --git a/drivers/net/wireless/ath/wcn36xx/pmc.c
> b/drivers/net/wireless/ath/wcn36xx/pmc.c
> index 589fe5f..1976b80 100644
> --- a/drivers/net/wireless/ath/wcn36xx/pmc.c
> +++ b/drivers/net/wireless/ath/wcn36xx/pmc.c
> @@ -45,8 +45,10 @@ int wcn36xx_pmc_exit_bmps_state(struct wcn36xx *wcn,
>  	struct wcn36xx_vif *vif_priv = wcn36xx_vif_to_priv(vif);
>  
>  	if (WCN36XX_BMPS != vif_priv->pw_state) {
> -		wcn36xx_err("Not in BMPS mode, no need to exit from BMPS
> mode!\n");
> -		return -EINVAL;
> +		/* Unbalanced call or last BMPS enter failed */
> +		wcn36xx_dbg(WCN36XX_DBG_PMC,
> +			    "Not in BMPS mode, no need to exit\n");
> +		return -EALREADY;
>  	}
>  	wcn36xx_smd_exit_bmps(wcn, vif);
>  	vif_priv->pw_state = WCN36XX_FULL_POWER;
> -- 
> 2.7.4
> 
> 
> _______________________________________________
> wcn36xx mailing list
> wcn36xx@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/wcn36xx
