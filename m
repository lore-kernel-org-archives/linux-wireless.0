Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 25.mail-out.ovh.net ([91.121.27.228]:41818 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759527AbZASNI4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 08:08:56 -0500
To: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH 2/2] iwl3945: Remove unused variables
MIME-Version: 1.0
Date: Mon, 19 Jan 2009 14:06:23 +0100
From: <samuel@sortiz.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <200901190955.32818.helmut.schaa@gmail.com>
References: <200901190955.32818.helmut.schaa@gmail.com>
Message-ID: <726c7ab86fd8a193ef621bac113b0ab4@localhost> (sfid-20090119_140903_647219_5F2E1E12)
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 19 Jan 2009 09:55:32 +0100, Helmut Schaa=0D
<helmut.schaa@googlemail.com> wrote:=0D
> Fix the following warnings in iwl-3945-rs.c by removing unused variab=
les.=0D
> =0D
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function=0D
> =E2=80=98iwl3945_rate_scale_flush_windows=E2=80=99:=0D
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:186: warning: unused varia=
ble=0D
> =E2=80=98priv=E2=80=99=0D
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function=0D
> =E2=80=98iwl3945_bg_rate_scale_flush=E2=80=99:=0D
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:219: warning: unused varia=
ble=0D
> =E2=80=98priv=E2=80=99=0D
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function=0D
> =E2=80=98iwl3945_collect_tx_data=E2=80=99:=0D
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:293: warning: unused varia=
ble=0D
> =E2=80=98priv=E2=80=99=0D
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function=0D
=E2=80=98rs_free_sta=E2=80=99:=0D
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:441: warning: unused varia=
ble=0D
> =E2=80=98priv=E2=80=99=0D
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function=0D
> =E2=80=98iwl3945_get_adjacent_rate=E2=80=99:=0D
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:559: warning: unused varia=
ble=0D
> =E2=80=98priv=E2=80=99=0D
> =0D
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>=0D
Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>=0D
=0D
Thanks Helmut.=0D
=0D
> ---=0D
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c=0D
> b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c=0D
> index ba64034..2af45f4 100644=0D
> --- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c=0D
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c=0D
> @@ -183,7 +183,6 @@ static int iwl3945_rate_scale_flush_windows(struc=
t=0D
> iwl3945_rs_sta *rs_sta)=0D
>  	int unflushed =3D 0;=0D
>  	int i;=0D
>  	unsigned long flags;=0D
> -	struct iwl_priv *priv =3D rs_sta->priv;=0D
>  =0D
>  	/*=0D
>  	 * For each rate, if we have collected data on that rate=0D
> @@ -216,7 +215,6 @@ static int iwl3945_rate_scale_flush_windows(struc=
t=0D
> iwl3945_rs_sta *rs_sta)=0D
>  static void iwl3945_bg_rate_scale_flush(unsigned long data)=0D
>  {=0D
>  	struct iwl3945_rs_sta *rs_sta =3D (void *)data;=0D
> -	struct iwl_priv *priv =3D rs_sta->priv;=0D
>  	int unflushed =3D 0;=0D
>  	unsigned long flags;=0D
>  	u32 packet_count, duration, pps;=0D
> @@ -290,7 +288,6 @@ static void iwl3945_collect_tx_data(struct=0D
> iwl3945_rs_sta *rs_sta,=0D
>  {=0D
>  	unsigned long flags;=0D
>  	s32 fail_count;=0D
> -	struct iwl_priv *priv =3D rs_sta->priv;=0D
>  =0D
>  	if (!retries) {=0D
>  		IWL_DEBUG_RATE("leave: retries =3D=3D 0 -- should be at least 1\n"=
);=0D
> @@ -438,7 +435,6 @@ static void rs_free_sta(void *iwl_priv, struct=0D
> ieee80211_sta *sta,=0D
>  {=0D
>  	struct iwl3945_sta_priv *psta =3D (void *) sta->drv_priv;=0D
>  	struct iwl3945_rs_sta *rs_sta =3D priv_sta;=0D
> -	struct iwl_priv *priv =3D rs_sta->priv;=0D
>  =0D
>  	psta->rs_sta =3D NULL;=0D
>  =0D
> @@ -556,7 +552,6 @@ static u16 iwl3945_get_adjacent_rate(struct=0D
> iwl3945_rs_sta *rs_sta,=0D
>  {=0D
>  	u8 high =3D IWL_RATE_INVALID;=0D
>  	u8 low =3D IWL_RATE_INVALID;=0D
> -	struct iwl_priv *priv =3D rs_sta->priv;=0D
>  =0D
>  	/* 802.11A walks to the next literal adjacent rate in=0D
>  	 * the rate table */=0D
> --=0D
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess"=0D
> in=0D
> the body of a message to majordomo@vger.kernel.org=0D
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
