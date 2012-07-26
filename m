Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:57427 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577Ab2GZU4r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 16:56:47 -0400
Message-ID: <5011AF0C.9080304@net.t-labs.tu-berlin.de> (sfid-20120726_225654_610205_1A5F1571)
Date: Thu, 26 Jul 2012 22:56:44 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: Felix Fietkau <nbd@openwrt.org>, jirislaby@gmail.com,
	johannes.berg@intel.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [ath5k-devel] [PATCH 2/2] ath5k: fix phy_init() to respect user
 txpower changes
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1343059275-49590-3-git-send-email-thomas@net.t-labs.tu-berlin.de> <CAFtRNNwY-1JLEJa_qZpUfsyQVdUQLO3CWcEB9xef-g5jPzndNQ@mail.gmail.com> <50107C35.9050807@net.t-labs.tu-berlin.de> <CAFtRNNz2qG5Fsjd1WVfA-BOSPGZ=WvMzrMwyqn8d6tfiBpkSVw@mail.gmail.com> <501083F6.8060002@net.t-labs.tu-berlin.de> <CAFtRNNxEHaON-uBjgLyeJdgN6UKfed6fAeCYPpo6xToi3dixOw@mail.gmail.com> <50111BB3.9090802@openwrt.org> <CAFtRNNyk051oLGuZOMcthf_mO6sArQzp+yCDvLQR2b=mACe9tQ@mail.gmail.com> <50111ECF.1020706@openwrt.org> <CAFtRNNyP69cHcEscH8eeHcL9WW2-qrxKBa=5zmmmbnORTGFNXA@mail.gmail.com>
In-Reply-To: <CAFtRNNyP69cHcEscH8eeHcL9WW2-qrxKBa=5zmmmbnORTGFNXA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nick,

Nick Kossifidis schrieb:

> I think this is a better approach (I'll prepare a proper patch as soon
> as I have some bandwidth to work with wireless-testing, maybe
> tomorrow)...
> 
> --- old/phy.c	2012-07-26 20:40:00.869150187 +0300
> +++ new/phy.c	2012-07-26 20:43:25.074710577 +0300
> @@ -3562,6 +3562,12 @@
>  		for (i = 8; i <= 15; i++)
>  			rates[i] -= ah->ah_txpower.txp_cck_ofdm_gainf_delta;
> 
> +
> +	/* Min/max in 0.25dB units */
> +	ah->ah_txpower.txp_min_pwr = 2 * rates[7];
> +	ah->ah_txpower.txp_cur_pwr = 2 * rates[0];
> +	ah->ah_txpower.txp_ofdm = rates[7];
> +
>  	/* Now that we have all rates setup use table offset to
>  	 * match the power range set by user with the power indices
>  	 * on PCDAC/PDADC table */
> @@ -3571,11 +3577,6 @@
>  		if (rates[i] > 63)
>  			rates[i] = 63;
>  	}
> -
> -	/* Min/max in 0.25dB units */
> -	ah->ah_txpower.txp_min_pwr = 2 * rates[7];
> -	ah->ah_txpower.txp_cur_pwr = 2 * rates[0];
> -	ah->ah_txpower.txp_ofdm = rates[7];
>  }
> 

> @@ -3789,8 +3790,8 @@
>  	 * RF buffer settings on 5211/5212+ so that we
>  	 * properly set curve indices.
>  	 */
> -	ret = ath5k_hw_txpower(ah, channel, ah->ah_txpower.txp_cur_pwr ?
> -			ah->ah_txpower.txp_cur_pwr / 2 : AR5K_TUNE_MAX_TXPOWER);
> +	ret = ath5k_hw_txpower(ah, channel, ah->power_level ?
> +			ah->power_level * 2 : AR5K_TUNE_MAX_TXPOWER);
>  	if (ret)
>  		return ret;
> 
> Works for you ?

works as well.

There are now 2 unused variables as left over:
ah->ah_txpower.txp_cur_pwr
ah->ah_txpower.txp_min_pwr

Do we need them anymore to check for hw chan limit ?

> BTW is there a way to pass the actual tx power set back to
> mac80211/cfg80211 so that user knows what power his card is actually
> transmitting at ?
 

I think that on point of the todo list.

Greetings Thomas
