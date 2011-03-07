Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30743 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab1CGFkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 00:40:06 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 21:39:43 -0800
Message-ID: <4D746FAE.8010303@atheros.com>
Date: Mon, 7 Mar 2011 11:09:58 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: =?UTF-8?B?VGhvbWFzIELDpGNobGVy?= <thomas@archlinux.org>
CC: Greg KH <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k: Fix ath9k prevents CPU to enter C3 states
References: <20110304213713.GA31324@kroah.com> <1299276030-4084-1-git-send-email-thomas@archlinux.org>
In-Reply-To: <1299276030-4084-1-git-send-email-thomas@archlinux.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 05 March 2011 03:30 AM, Thomas Bächler wrote:
> This is a backport of upstream commit 0f5cd45960173ba5b36727decbb4a241cbd35ef9.
>
> The DMA latency issue is observed only in Intel pinetrail platforms
> but in the driver we had a default PM-QOS value of 55. This caused
> unnecessary power consumption and battery drain in other platforms.
>
> Remove the pm-qos thing in the driver code and address the throughput
> issue in Intel pinetrail platfroms in user space using any one of
> the scripts in below links:
>
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/scripts/cpudmalatency.c
> http://johannes.sipsolutions.net/files/netlatency.c.txt
>
> More details can be found in the following bugzilla link:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=27532
>
> Signed-off-by: Thomas Bächler<thomas@archlinux.org>
> ---
>
> I hope this is right, it seems to work for me.
> Luis or John, can you sign off on this just
> to be sure?
>
>   drivers/net/wireless/ath/ath9k/ath9k.h |    3 ---
>   drivers/net/wireless/ath/ath9k/init.c  |    4 ----
>   drivers/net/wireless/ath/ath9k/main.c  |    4 ----
>   3 files changed, 0 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> index c0b60ce..94bd9bc 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -21,7 +21,6 @@
>   #include<linux/device.h>
>   #include<linux/leds.h>
>   #include<linux/completion.h>
> -#include<linux/pm_qos_params.h>
>
>   #include "debug.h"
>   #include "common.h"
> @@ -647,8 +646,6 @@ struct ath_softc {
>   	struct ath_descdma txsdma;
>
>   	struct ath_ant_comb ant_comb;
> -
> -	struct pm_qos_request_list pm_qos_req;
>   };
>
>   struct ath_wiphy {
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index 14b8ab3..91d9b2a 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -758,9 +758,6 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
>   	ath_init_leds(sc);
>   	ath_start_rfkill_poll(sc);
>
> -	pm_qos_add_request(&sc->pm_qos_req, PM_QOS_CPU_DMA_LATENCY,
> -			   PM_QOS_DEFAULT_VALUE);
> -
>   	return 0;
>
>   error_world:
> @@ -829,7 +826,6 @@ void ath9k_deinit_device(struct ath_softc *sc)
>   	}
>
>   	ieee80211_unregister_hw(hw);
> -	pm_qos_remove_request(&sc->pm_qos_req);
>   	ath_rx_cleanup(sc);
>   	ath_tx_cleanup(sc);
>   	ath9k_deinit_softc(sc);
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index d1b0db4..cb0b2b9 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1245,8 +1245,6 @@ static int ath9k_start(struct ieee80211_hw *hw)
>   			ath9k_btcoex_timer_resume(sc);
>   	}
>
> -	pm_qos_update_request(&sc->pm_qos_req, 55);
> -
>   mutex_unlock:
>   	mutex_unlock(&sc->mutex);
>
> @@ -1425,8 +1423,6 @@ static void ath9k_stop(struct ieee80211_hw *hw)
>
>   	sc->sc_flags |= SC_OP_INVALID;
>
> -	pm_qos_update_request(&sc->pm_qos_req, PM_QOS_DEFAULT_VALUE);
> -
>   	mutex_unlock(&sc->mutex);
>
>   	ath_print(common, ATH_DBG_CONFIG, "Driver halt\n");
>    
Thomas, thanks !
