Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:35797 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbZELTIX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 15:08:23 -0400
Received: by mail-fx0-f158.google.com with SMTP id 2so173396fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 12:08:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890905121205v76d6b61cg94d0bbe55c04da7e@mail.gmail.com>
References: <1242125077.4331.0.camel@johannes.local>
	 <3ace41890905121205v76d6b61cg94d0bbe55c04da7e@mail.gmail.com>
Date: Tue, 12 May 2009 20:08:24 +0100
Message-ID: <3ace41890905121208s2029db39p730b2e174cd4b1e6@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: fix a couple of bugs with key ioctls
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 12, 2009 at 8:05 PM, Hin-Tak Leung <hintak.leung@gmail.com>=
 wrote:
> On Tue, May 12, 2009 at 11:44 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> There are a few small bugs/oversights in the key handling
>> code I wrote:
>> =A0* SIOCSIWENCODE should default to setting key 0 if no
>> =A0 default key is set already and no index is given,
>> =A0* key removal should not require key material,
>> =A0* SIOCSIWENCODEEXT should default to changing the default
>> =A0 management key if no index is given.
>>
>> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>> ---
>> =A0net/wireless/wext-compat.c | =A0 14 +++++---------
>> =A01 file changed, 5 insertions(+), 9 deletions(-)
>>
>> --- wireless-testing.orig/net/wireless/wext-compat.c =A0 =A02009-05-=
12 12:38:41.000000000 +0200
>> +++ wireless-testing/net/wireless/wext-compat.c 2009-05-12 12:38:59.=
000000000 +0200
>> @@ -557,7 +557,7 @@ int cfg80211_wext_siwencode(struct net_d
>> =A0 =A0 =A0 =A0if (idx =3D=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0idx =3D wdev->wext.default_key;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (idx < 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 idx =3D 0;
>> =A0 =A0 =A0 =A0} else if (idx < 1 || idx > 4)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>> =A0 =A0 =A0 =A0else
>> @@ -580,7 +580,7 @@ int cfg80211_wext_siwencode(struct net_d
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0params.cipher =3D WLAN_CIPHER_SUITE_W=
EP40;
>> =A0 =A0 =A0 =A0else if (erq->length =3D=3D 13)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0params.cipher =3D WLAN_CIPHER_SUITE_W=
EP104;
>> - =A0 =A0 =A0 else
>> + =A0 =A0 =A0 else if (!remove)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>>
>> =A0 =A0 =A0 =A0return cfg80211_set_encryption(rdev, dev, NULL, remov=
e,
>> @@ -640,13 +640,9 @@ int cfg80211_wext_siwencodeext(struct ne
>> =A0 =A0 =A0 =A0idx =3D erq->flags & IW_ENCODE_INDEX;
>> =A0 =A0 =A0 =A0if (cipher =3D=3D WLAN_CIPHER_SUITE_AES_CMAC) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (idx < 4 || idx > 5) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* XXX: Only wpa_sup=
plicant ever used this
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =A0 =A0 =A0can we=
 still change the ABI a little
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =A0 =A0 =A0so we =
do not need to keep track of
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =A0 =A0 =A0the de=
fault key?
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 idx =3D wdev->wext.def=
ault_mgmt_key;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (idx < 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return=
 -EINVAL;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0idx--;
>> =A0 =A0 =A0 =A0} else {
>>
>>
>>
>
> I tried this, NM/wpa_suplicany still doesn't work, but if I shut thos=
e
> down and do it the old fashioned iwconfig way, I can get
> connectivity... =A0the last chunk looks a bit funny - '(idx < 4 || id=
x >
> 5)' is just '(idx !=3D 4)' so why it isn't written simplier as such?
> also the idx < 0 maybe <1 ?
>
> Stiill needs some work...
>

BTW, nm fails to connect with
 <WARN>  nm_device_wifi_disable_encryption(): error setting key for
device wlan2: No such file or directory
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
