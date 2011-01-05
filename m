Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47573 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1AET1C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 14:27:02 -0500
Date: Wed, 5 Jan 2011 14:24:08 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath5k: qualify global modparam_nohwcrypt variable
Message-ID: <20110105192407.GB14497@tuxdriver.com>
References: <1294238399-4701-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1294238399-4701-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I believe I would prefer the version I just sent, that moves nohwcrypt to ath_common...

John


On Wed, Jan 05, 2011 at 09:39:59AM -0500, John W. Linville wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/ath/ath5k/base.c         |    4 ++--
>  drivers/net/wireless/ath/ath5k/mac80211-ops.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index fce9a98..019a74d 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -61,8 +61,8 @@
>  #include "debug.h"
>  #include "ani.h"
>  
> -int modparam_nohwcrypt;
> -module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
> +int ath5k_modparam_nohwcrypt;
> +module_param_named(nohwcrypt, ath5k_modparam_nohwcrypt, bool, S_IRUGO);
>  MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
>  
>  static int modparam_all_channels;
> diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
> index de257a3..d76d68c 100644
> --- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
> +++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
> @@ -46,7 +46,7 @@
>  #include "base.h"
>  #include "reg.h"
>  
> -extern int modparam_nohwcrypt;
> +extern int ath5k_modparam_nohwcrypt;
>  
>  /* functions used from base.c */
>  void set_beacon_filter(struct ieee80211_hw *hw, bool enable);
> @@ -485,7 +485,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>  	struct ath_common *common = ath5k_hw_common(ah);
>  	int ret = 0;
>  
> -	if (modparam_nohwcrypt)
> +	if (ath5k_modparam_nohwcrypt)
>  		return -EOPNOTSUPP;
>  
>  	switch (key->cipher) {
> -- 
> 1.7.3.4
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
