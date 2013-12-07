Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:38611 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758599Ab3LGQuW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Dec 2013 11:50:22 -0500
Received: by mail-la0-f54.google.com with SMTP id b8so737963lan.41
        for <linux-wireless@vger.kernel.org>; Sat, 07 Dec 2013 08:50:20 -0800 (PST)
Message-ID: <52A35082.3060206@27m.se> (sfid-20131207_175027_028793_95D94363)
Date: Sat, 07 Dec 2013 17:44:50 +0100
From: Jones Desougi <jones.desougi@27m.se>
MIME-Version: 1.0
To: Luciano Coelho <luciano.coelho@intel.com>
CC: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	yeohchunyeow@gmail.com, yeohchunyeow@cozybit.com,
	andrei.otcheretianski@intel.com
Subject: Re: [PATCH v8 2/5] mac80211: align ieee80211_ibss_csa_beacon() with
 ieee80211_csa_beacon()
References: <1386257143-29840-1-git-send-email-luciano.coelho@intel.com> <1386257143-29840-3-git-send-email-luciano.coelho@intel.com>
In-Reply-To: <1386257143-29840-3-git-send-email-luciano.coelho@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/12/13 16:25, Luciano Coelho wrote:
> The return value of ieee80211_ibss_csa_beacon is not aligned with the
> return value of ieee80211_csa_beacon().  For consistency and to be
> able to use both functions with similar code, change
> ieee80211_ibss_csa_beacon() not to send the bss changed notification
> itself, but return what has changed so the caller can send the
> notification instead.
> 
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> ---
>  net/mac80211/ibss.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index 3514aab..23e035f 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -522,7 +522,7 @@ int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
>  	if (csa_settings)
>  		ieee80211_send_action_csa(sdata, csa_settings);
>  
> -	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
> +	return BSS_CHANGED_BEACON;
>   out:
>  	return ret;
>  }
> @@ -559,11 +559,17 @@ int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata)
>  
>  	/* generate the beacon */
>  	err = ieee80211_ibss_csa_beacon(sdata, NULL);
> -	sdata_unlock(sdata);
>  	if (err < 0)
> -		return err;
> +		goto out;
>  
> -	return 0;
> +	if (err) {
> +		ieee80211_bss_info_change_notify(sdata, err);
> +		err = 0;
> +	}
> +out:
> +	sdata_unlock(sdata);

Why not simplify to something like this?
	/* generate the beacon */
	err = ieee80211_ibss_csa_beacon(sdata, NULL);
	if (err > 0) {
		ieee80211_bss_info_change_notify(sdata, err);
		err = 0;
	}
	sdata_unlock(sdata);

> +
> +	return err;
>  }
>  
>  void ieee80211_ibss_stop(struct ieee80211_sub_if_data *sdata)
> 

