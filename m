Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3656 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab0IKRbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 13:31:51 -0400
Date: Sat, 11 Sep 2010 13:27:52 -0400
From: bob@bobcopeland.com
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Subject: Re: [PATCH 6/8] ath5k: Use common crypt capabilities flags
Message-ID: <20100911172752.GH20385@hash.localnet>
References: <20100908070427.11255.17659.stgit@tt-desk> <20100908070459.11255.52256.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100908070459.11255.52256.stgit@tt-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 08, 2010 at 04:04:59PM +0900, Bruno Randolf wrote:
> Replace ah_aes_support and ah_combined_mic with common ath_crypt_caps
> ATH_CRYPT_CAP_CIPHER_AESCCM and ATH_CRYPT_CAP_MIC_COMBINED.
> 
> Signed-off-by: Bruno Randolf <br1@einfach.org>

> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -3298,7 +3298,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>  	case WLAN_CIPHER_SUITE_TKIP:
>  		break;
>  	case WLAN_CIPHER_SUITE_CCMP:
> -		if (sc->ah->ah_aes_support)
> +		if (common->crypt_caps & ATH_CRYPT_CAP_CIPHER_AESCCM)
>  			break;
>  		return -EOPNOTSUPP;

This could be done by the common code too, right?

-- 
Bob Copeland %% www.bobcopeland.com

