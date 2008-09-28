Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns1.dnstelecom.co.za ([196.44.87.201]:48966 "EHLO
	pbx.dnstelecom.co.za" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751707AbYI1LHJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 07:07:09 -0400
Message-ID: <48DF6535.8080407@dnstelecom.co.za> (sfid-20080928_130715_510017_43753A95)
Date: Sun, 28 Sep 2008 13:06:29 +0200
From: Gregory Nietsky <gregory@dnstelecom.co.za>
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: Re: [ath5k-devel] [PATCH 1/1] Ath5k: add AP mode
References: <1222519728-14989-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1222519728-14989-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Quick Observation  ...

it appears IEEE80211 types have been replaced with NL80211 types in 
kernel ... so would the following not be more correct and is opmode not 
defined as

struct ath5k_softc {
....
        enum nl80211_iftype     opmode;
.....

@@ -2130,14 +2129,15 @@ ath5k_beacon_config(struct ath5k_softc *sc)

                sc->imask |= AR5K_INT_SWBA;

-               if (ath5k_hw_hasveol(ah)) {
-                       spin_lock(&sc->block);
-                       ath5k_beacon_send(sc);
-                       spin_unlock(&sc->block);
-               }
+               if (sc->opmode == NL80211_IFTYPE_ADHOC) {
+                       if (ath5k_hw_hasveol(ah)) {
+                               spin_lock(&sc->block);
+                               ath5k_beacon_send(sc);
+                               spin_unlock(&sc->block);
+                       }
+               } else
+                       ath5k_beacon_update_timers(sc, -1);
        }
-       /* TODO else AP */
-
        ath5k_hw_set_imr(ah, sc->imask);
 }



Jiri Slaby wrote:
> Add support for AP mode. This involves:
> - enablement in ath5k_beacon_config -- initialize beacon timer
> - add AP to the supported modes in ath5k_add_interface
> - handle beacon change even for AP in ath5k_config_interface
> - remove useless test for IBSS in ath5k_beacon_update
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Nick Kossifidis <mickflemm@gmail.com>
> Cc: Luis R. Rodriguez <mcgrof@gmail.com>
> ---
>  drivers/net/wireless/ath5k/base.c |   42 +++++++++++++++----------------------
>  1 files changed, 17 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index e09ed2c..d5d8e2d 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -2130,13 +2128,15 @@ ath5k_beacon_config(struct ath5k_softc *sc)
>  
>  		sc->imask |= AR5K_INT_SWBA;
>  
> -		if (ath5k_hw_hasveol(ah)) {
> -			spin_lock(&sc->block);
> -			ath5k_beacon_send(sc);
> -			spin_unlock(&sc->block);
> -		}
> +		if (sc->opmode == IEEE80211_IF_TYPE_IBSS) {
> +			if (ath5k_hw_hasveol(ah)) {
> +				spin_lock(&sc->block);
> +				ath5k_beacon_send(sc);
> +				spin_unlock(&sc->block);
> +			}
> +		} else
> +			ath5k_beacon_update_timers(sc, -1);
>  	}
> -	/* TODO else AP */
>  
>  	ath5k_hw_set_imr(ah, sc->imask);
>  }
>   

--
This message has been scanned for viruses and
dangerous content by Network Sentry, and 
is believed to be clean.
http://www.dialandsave.co.za

