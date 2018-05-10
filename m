Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:34329 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965199AbeEJOSf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 10:18:35 -0400
Date: Thu, 10 May 2018 16:18:26 +0200
In-Reply-To: <000d01d3e865$d9896f00$8c9c4d00$@codeaurora.org>
References: <152595697934.5071.3080928108635708657.stgit@alrua-kau> <000d01d3e865$d9896f00$8c9c4d00$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: RE: [PATCH v5] wireless-drivers: Dynamically allocate struct station_info
To: Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org
From: =?ISO-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>
Message-ID: <A02A0E6D-F332-46EC-B390-FF047695129A@toke.dk> (sfid-20180510_161838_643172_235F1C00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10 May 2018 15:50:23 CEST, Dedy Lansky <dlansky@codeaurora=2Eorg> wrote=
:
>Hi Toke,
>
>> --- a/drivers/net/wireless/ath/wil6210/wmi=2Ec
>> +++ b/drivers/net/wireless/ath/wil6210/wmi=2Ec
>> @@ -824,7 +824,7 @@ static void wmi_evt_connect(struct wil6210_vif
>*vif, int id, void *d, int len)
>>  	struct wireless_dev *wdev =3D vif_to_wdev(vif);
>>  	struct wmi_connect_event *evt =3D d;
>>  	int ch; /* channel number */
>> -	struct station_info sinfo;
>> +	struct station_info *sinfo;
>>  	u8 *assoc_req_ie, *assoc_resp_ie;
>>  	size_t assoc_req_ielen, assoc_resp_ielen;
>>  	/* capinfo(u16) + listen_interval(u16) + IEs */ @@ -940,6 +940,7 @@
>static void wmi_evt_connect(struct wil6210_vif *vif, int id, void *d,
>int len)
>>  		vif->bss =3D NULL;
>>  	} else if ((wdev->iftype =3D=3D NL80211_IFTYPE_AP) ||
>>  		   (wdev->iftype =3D=3D NL80211_IFTYPE_P2P_GO)) {
>> +
>
>Any reason for this extra empty line?

Heh, no=2E Just an artifact of editing patches over a painfully bad connec=
tion on a moving train=2E=2E=2E

-Toke
