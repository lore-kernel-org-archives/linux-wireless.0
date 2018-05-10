Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60626 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753693AbeEJJ6W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 05:58:22 -0400
From: "Dedy Lansky" <dlansky@codeaurora.org>
To: =?utf-8?Q?'Toke_H=C3=B8iland-J=C3=B8rgensen'?= <toke@toke.dk>,
        <linux-wireless@vger.kernel.org>
References: <152594435934.24751.8979312538330792032.stgit@alrua-kau>
In-Reply-To: <152594435934.24751.8979312538330792032.stgit@alrua-kau>
Subject: RE: [PATCH v4] wireless-drivers: Dynamically allocate struct station_info
Date: Thu, 10 May 2018 12:58:17 +0300
Message-ID: <000901d3e845$6d7fdd00$487f9700$@codeaurora.org> (sfid-20180510_115825_818017_25EB55C9)
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Toke,

Thanks for taking care of wil6210 part. See comment below.

> @@ -824,7 +824,7 @@ static void wmi_evt_connect(struct wil6210_vif =
*vif, int id, void *d, int len)
>  	struct wireless_dev *wdev =3D vif_to_wdev(vif);
>  	struct wmi_connect_event *evt =3D d;
>  	int ch; /* channel number */
> -	struct station_info sinfo;
> +	struct station_info *sinfo;
>  	u8 *assoc_req_ie, *assoc_resp_ie;
>  	size_t assoc_req_ielen, assoc_resp_ielen;
>  	/* capinfo(u16) + listen_interval(u16) + IEs */ @@ -940,6 +940,11 @@ =
static void wmi_evt_connect(struct wil6210_vif *vif, int id, void *d, =
int len)
>  		vif->bss =3D NULL;
>  	} else if ((wdev->iftype =3D=3D NL80211_IFTYPE_AP) ||
>  		   (wdev->iftype =3D=3D NL80211_IFTYPE_P2P_GO)) {
> +
> +		sinfo =3D kzalloc(sizeof(*sinfo), GFP_KERNEL);
> +		if (!sinfo)
> +			rc =3D -ENOMEM;
> +
>  		if (rc) {
>  			if (disable_ap_sme)
>  				/* notify new_sta has failed */
> @@ -947,16 +952,16 @@ static void wmi_evt_connect(struct wil6210_vif =
*vif, int id, void *d, int len)
>  			goto out;

Need to kfree sinfo here. I suggest instead to move the kzalloc below =
the whole "if (rc)"


>  		}
> =20
> -		memset(&sinfo, 0, sizeof(sinfo));
> -
> -		sinfo.generation =3D wil->sinfo_gen++;
> +		sinfo->generation =3D wil->sinfo_gen++;

Thanks,
 Dedy.
