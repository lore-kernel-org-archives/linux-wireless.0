Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:39971 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934266AbeEJKYR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 06:24:17 -0400
Date: Thu, 10 May 2018 12:24:11 +0200
In-Reply-To: <000901d3e845$6d7fdd00$487f9700$@codeaurora.org>
References: <152594435934.24751.8979312538330792032.stgit@alrua-kau> <000901d3e845$6d7fdd00$487f9700$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: RE: [PATCH v4] wireless-drivers: Dynamically allocate struct station_info
To: Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org
From: =?ISO-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>
Message-ID: <55BC3C60-50B6-4227-ADEE-CCBAAA3EAE7B@toke.dk> (sfid-20180510_122421_665256_2B95D29F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10 May 2018 11:58:17 CEST, Dedy Lansky <dlansky@codeaurora=2Eorg> wrote=
:
>Hi Toke,
>
>Thanks for taking care of wil6210 part=2E See comment below=2E
>
>> @@ -824,7 +824,7 @@ static void wmi_evt_connect(struct wil6210_vif
>*vif, int id, void *d, int len)
>>  	struct wireless_dev *wdev =3D vif_to_wdev(vif);
>>  	struct wmi_connect_event *evt =3D d;
>>  	int ch; /* channel number */
>> -	struct station_info sinfo;
>> +	struct station_info *sinfo;
>>  	u8 *assoc_req_ie, *assoc_resp_ie;
>>  	size_t assoc_req_ielen, assoc_resp_ielen;
>>  	/* capinfo(u16) + listen_interval(u16) + IEs */ @@ -940,6 +940,11
>@@ static void wmi_evt_connect(struct wil6210_vif *vif, int id, void
>*d, int len)
>>  		vif->bss =3D NULL;
>>  	} else if ((wdev->iftype =3D=3D NL80211_IFTYPE_AP) ||
>>  		   (wdev->iftype =3D=3D NL80211_IFTYPE_P2P_GO)) {
>> +
>> +		sinfo =3D kzalloc(sizeof(*sinfo), GFP_KERNEL);
>> +		if (!sinfo)
>> +			rc =3D -ENOMEM;
>> +
>>  		if (rc) {
>>  			if (disable_ap_sme)
>>  				/* notify new_sta has failed */
>> @@ -947,16 +952,16 @@ static void wmi_evt_connect(struct wil6210_vif
>*vif, int id, void *d, int len)
>>  			goto out;
>
>Need to kfree sinfo here=2E I suggest instead to move the kzalloc below
>the whole "if (rc)"

Ah, right=2E And here I thought I was being clever by reusing the rc check=
=2E

Note to self: don't try to be clever=2E

Will fix, thanks :)

-Toke
