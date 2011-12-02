Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:32884 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab1LBLEd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 06:04:33 -0500
Message-ID: <4ED8B0BA.2020706@openwrt.org> (sfid-20111202_120436_953308_AA3C895B)
Date: Fri, 02 Dec 2011 12:04:26 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Nikolay Martynov <mar.kolya@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 3/4] ath9k: use config.enable_ani to check if ani should
 be performed
References: <20111130201051.GC2477@tuxdriver.com> <1322685980-8757-1-git-send-email-mar.kolya@gmail.com> <1322685980-8757-4-git-send-email-mar.kolya@gmail.com>
In-Reply-To: <1322685980-8757-4-git-send-email-mar.kolya@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-11-30 9:46 PM, Nikolay Martynov wrote:
>   Currently in ath9k code there is an attempt which is meant to
> disable ANI for ar9100 and ar9340. But it doesn't really achieve
> this. All it does is disable ANI init and setup (i.e. calls to
> ath9k_hw_ani_setup and ath9k_hw_ani_init). Since ath9k_hw_ani_setup is
> not called ah->config.ani_poll_interval is never initialized (i.e. it
> is always zero) and ath_ani_calibrate always executes ANI procedures
> (over uninitialized ANI parameters).
>   Moreover, ath_ani_calibrate is being called each 1ms because
> common->ani.timer is set to zero interval because
> ah->config.ani_poll_interval==0 (and thus smallest value of all
> intervals). Normally it should not be called this often.
>   This patch changes the code so config.enable_ani is used to check if
> ANI should be performed.
>   config.enable_ani is initialized to true by default. This patch sets
> it to false for ar9100 and ar9340.
> 
> Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c |    3 ++-
>  drivers/net/wireless/ath/ath9k/hw.c           |    6 +++++-
>  drivers/net/wireless/ath/ath9k/main.c         |    5 +++--
>  3 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> index 0b9a0e8..391d59c 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> @@ -808,7 +808,8 @@ void ath9k_htc_ani_work(struct work_struct *work)
>  	}
>  
>  	/* Verify whether we must check ANI */
> -	if ((timestamp - common->ani.checkani_timer) >= ATH_ANI_POLLINTERVAL) {
> +	if (sc->sc_ah->config.enable_ani &&
> +	    (timestamp - common->ani.checkani_timer) >= ATH_ANI_POLLINTERVAL) {
>  		aniflag = true;
>  		common->ani.checkani_timer = timestamp;
>  	}
Does not compile, there is no 'sc' variable, use ah->config.enable_ani.

- Felix
