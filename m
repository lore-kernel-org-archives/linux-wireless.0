Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.hammerl-bau.at ([213.235.197.82]:55341 "EHLO
	ns2.hammerl-bau.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613AbYBBDLL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 22:11:11 -0500
From: bruno randolf <bruno@thinktube.com>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Subject: Re: [PATCH 3/3] ath5k: Add build option to enable hardware encryption
Date: Sat, 2 Feb 2008 11:34:41 +0900
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com
References: <20080201133731.GH28995@ruslug.rutgers.edu>
In-Reply-To: <20080201133731.GH28995@ruslug.rutgers.edu>
MIME-Version: 1.0
Message-Id: <200802021134.41989.bruno@thinktube.com> (sfid-20080202_031114_743749_681F01F9)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 01 February 2008 22:37:31 Luis R. Rodriguez wrote:
> Add an option to enable hardware encryption (CONFIG_ATH5K_HARDWARE_ENC)
> and disable it by default. This will enforce software encryption
> for WEP, WPA (TKIP) and WPA2 (CCMP) until we fix hardware encryption.
>
> Changes-licensed-under: 3-clause-BSD
> Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
> ---
>  drivers/net/wireless/ath5k/Kconfig |   14 ++++++++++++++
>  drivers/net/wireless/ath5k/base.c  |    3 +++
>  2 files changed, 17 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/Kconfig
> b/drivers/net/wireless/ath5k/Kconfig index 31d570e..5e75328 100644
> --- a/drivers/net/wireless/ath5k/Kconfig
> +++ b/drivers/net/wireless/ath5k/Kconfig
> @@ -15,9 +15,23 @@ config ATH5K
>  	  If you choose to build a module, it'll be called ath5k. Say M if
>  	  unsure.
>
> +config ATH5K_HARDWARE_ENC
> +	bool "Atheros 5xxx hardware encryption"
> +	depends on ATH5K
> +	default n
> +	---help---
> +	  Atheros 5xxx hardware encryption.
> +
> +	  Say N for now unless you are a developer who wants to fix
> +	  hardware encryption. Hardware encryption doesn't work yet.
> +	  Disabling this will let you use software encrption in the
> +	  meantime, this gives you support for WEP, WPA (TKIP) and
> +	  WPA2 (CCMP) through mac80211 software encryption.
> +
>  config ATH5K_DEBUG
>  	bool "Atheros 5xxx debugging"
>  	depends on ATH5K
> +	default n
>  	---help---
>  	  Atheros 5xxx debugging messages.
>
> diff --git a/drivers/net/wireless/ath5k/base.c
> b/drivers/net/wireless/ath5k/base.c index 9f2c30b..a83a548 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -2921,7 +2921,10 @@ ath5k_set_key(struct ieee80211_hw *hw, enum
> set_key_cmd cmd,
>
>  	switch(key->alg) {
>  	case ALG_WEP:
> +/* XXX: fix hardware encryption, its not working */
> +#ifdef CONFIG_ATH5K_HARDWARE_ENC
>  		break;
> +#endif /* CONFIG_ATH5K_HARDWARE_ENC */
>  	case ALG_TKIP:
>  	case ALG_CCMP:
>  		return -EOPNOTSUPP;

hi luis!

i think this is pretty much overkill. why would anyone say Y to that? 
wouldn't it suffice to add that comment to the code and not bother the users?
developers would work on the code anyways.

bruno
