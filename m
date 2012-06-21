Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:32814 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752399Ab2FUOYF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 10:24:05 -0400
Received: by lbbgo11 with SMTP id go11so2114384lbb.3
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2012 07:24:02 -0700 (PDT)
Message-ID: <1340288640.1631.274.camel@cumari.coelho.fi> (sfid-20120621_162409_959903_EF9AA774)
Subject: Re: [PATCH 07/12] wlcore: do not report noise level in get survey op
From: Luciano Coelho <coelho@ti.com>
To: yoni.divinsky@ti.com
Cc: arik@wizery.com, linux-wireless@vger.kernel.org
Date: Thu, 21 Jun 2012 17:24:00 +0300
In-Reply-To: <1340287991-15241-8-git-send-email-coelho@ti.com>
References: <1340287991-15241-1-git-send-email-coelho@ti.com>
	 <1340287991-15241-8-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, forgot to include Yoni as CC on this one.

On Thu, 2012-06-21 at 17:13 +0300, Luciano Coelho wrote:
> From: Yoni Divinsky <yoni.divinsky@ti.com>
> 
> The get survey op expects the low level driver to report
> the noise level for a a given channel.
> 
> The noise calculated in wlcore is (rssi-snr/2), but since
> the snr reported by the FW is a derivative from the rssi
> this calculation is useless, and should not be reported
> to the user space.
> 
> Reporting incorrect noise, results in the wpa_supplicant
> miscalculating the roaming candidate priority, thus causing
> a situation where an AP with a lower rssi level would be
> chosen over a better AP.
> 
> Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
>  drivers/net/wireless/ti/wlcore/main.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index 3279a94..a7c5e32 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -4108,16 +4108,13 @@ out:
>  static int wl1271_op_get_survey(struct ieee80211_hw *hw, int idx,
>  				struct survey_info *survey)
>  {
> -	struct wl1271 *wl = hw->priv;
>  	struct ieee80211_conf *conf = &hw->conf;
>  
>  	if (idx != 0)
>  		return -ENOENT;
>  
>  	survey->channel = conf->channel;
> -	survey->filled = SURVEY_INFO_NOISE_DBM;
> -	survey->noise = wl->noise;
> -
> +	survey->filled = 0;
>  	return 0;
>  }
>  


