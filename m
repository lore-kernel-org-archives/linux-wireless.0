Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:33263 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbYL2WRS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 17:17:18 -0500
Received: by fk-out-0910.google.com with SMTP id 18so2543196fkq.5
        for <linux-wireless@vger.kernel.org>; Mon, 29 Dec 2008 14:17:16 -0800 (PST)
Message-ID: <1ba2fa240812291417w6e99dd17t3ffc2973774ed824@mail.gmail.com> (sfid-20081229_231722_761439_6C2CDFE9)
Date: Tue, 30 Dec 2008 00:17:16 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: clean up set_key callback
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1230551709.3116.30.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1230551709.3116.30.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
> -                          const u8 *local_addr, const u8 *addr,
> +                          struct ieee80211_vif *vif,
> +                          struct ieee80211_sta *sta,
>                           struct ieee80211_key_conf *key)
>  {
>        struct iwl_priv *priv = hw->priv;
> @@ -3038,6 +3039,9 @@ static int iwl_mac_set_key(struct ieee80
>        int ret = 0;
>        u8 sta_id = IWL_INVALID_STATION;
>        u8 is_default_wep_key = 0;
> +       static const u8 bcast_addr[ETH_ALEN] =
> +               { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, };
> +       static const u8 *addr;

>        IWL_DEBUG_MAC80211("enter\n");
>
> @@ -3046,9 +3050,7 @@ static int iwl_mac_set_key(struct ieee80
>                return -EOPNOTSUPP;
>        }
>
> -       if (is_zero_ether_addr(addr))
> -               /* only support pairwise keys */
> -               return -EOPNOTSUPP;
> +       addr = sta ? sta->addr : bcast_addr;
>

Please use this code instead in both iwlwifi drivers.

+sta_id = sta ? iwl_find_station(priv, sta->addr) :
priv->hw_params.bcast_sta_id;
- sta_id = iwl_find_station(priv, addr);



>        if (sta_id == IWL_INVALID_STATION) {
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c   2008-12-24 12:03:05.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl3945-base.c        2008-12-24 12:25:51.000000000 +0100
> @@ -6561,12 +6561,16 @@ out_unlock:
>  }
>
>  static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
> -                          const u8 *local_addr, const u8 *addr,
> -                          struct ieee80211_key_conf *key)
> +                              struct ieee80211_vif *vif,
> +                              struct ieee80211_sta *sta,
> +                              struct ieee80211_key_conf *key)
>  {
>        struct iwl_priv *priv = hw->priv;
> +       const u8 *addr;
>        int rc = 0;
>        u8 sta_id;
> +       static const u8 bcast_addr[ETH_ALEN] =
> +               { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
>
>        IWL_DEBUG_MAC80211("enter\n");
>
> @@ -6575,9 +6579,7 @@ static int iwl3945_mac_set_key(struct ie
>                return -EOPNOTSUPP;
>        }
>
> -       if (is_zero_ether_addr(addr))
> -               /* only support pairwise keys */
> -               return -EOPNOTSUPP;
> +       addr = sta ? sta->addr : bcast_addr;
>
>        sta_id = iwl3945_hw_find_station(priv, addr);
>        if (sta_id == IWL_INVALID_STATION) {
> --- wireless-testing.orig/drivers/net/wireless/p54/p54common.c  2008-12-24 12:03:05.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/p54/p54common.c       2008-12-24 12:03:17.000000000 +0100
> @@ -2067,7 +2067,7 @@ static void p54_bss_info_changed(struct
>  }

Thanks
Tomas
