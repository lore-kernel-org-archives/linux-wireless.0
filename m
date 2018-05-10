Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45470 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757098AbeEJNu1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 09:50:27 -0400
From: "Dedy Lansky" <dlansky@codeaurora.org>
To: =?utf-8?Q?'Toke_H=C3=B8iland-J=C3=B8rgensen'?= <toke@toke.dk>,
        <linux-wireless@vger.kernel.org>
References: <152595697934.5071.3080928108635708657.stgit@alrua-kau>
In-Reply-To: <152595697934.5071.3080928108635708657.stgit@alrua-kau>
Subject: RE: [PATCH v5] wireless-drivers: Dynamically allocate struct station_info
Date: Thu, 10 May 2018 16:50:23 +0300
Message-ID: <000d01d3e865$d9896f00$8c9c4d00$@codeaurora.org> (sfid-20180510_155030_963542_710927C8)
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Toke,

> --- a/drivers/net/wireless/ath/wil6210/wmi.c
> +++ b/drivers/net/wireless/ath/wil6210/wmi.c
> @@ -824,7 +824,7 @@ static void wmi_evt_connect(struct wil6210_vif =
*vif, int id, void *d, int len)
>  	struct wireless_dev *wdev =3D vif_to_wdev(vif);
>  	struct wmi_connect_event *evt =3D d;
>  	int ch; /* channel number */
> -	struct station_info sinfo;
> +	struct station_info *sinfo;
>  	u8 *assoc_req_ie, *assoc_resp_ie;
>  	size_t assoc_req_ielen, assoc_resp_ielen;
>  	/* capinfo(u16) + listen_interval(u16) + IEs */ @@ -940,6 +940,7 @@ =
static void wmi_evt_connect(struct wil6210_vif *vif, int id, void *d, =
int len)
>  		vif->bss =3D NULL;
>  	} else if ((wdev->iftype =3D=3D NL80211_IFTYPE_AP) ||
>  		   (wdev->iftype =3D=3D NL80211_IFTYPE_P2P_GO)) {
> +

Any reason for this extra empty line?

>  		if (rc) {
>  			if (disable_ap_sme)
>  				/* notify new_sta has failed */

Thanks,
 Dedy.
