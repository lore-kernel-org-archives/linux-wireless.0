Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:58524 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbZEMN1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 09:27:18 -0400
Received: by fxm2 with SMTP id 2so647439fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 06:27:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242209433.29288.6.camel@johannes.local>
References: <1242125077.4331.0.camel@johannes.local>
	 <1242209433.29288.6.camel@johannes.local>
Date: Wed, 13 May 2009 14:27:18 +0100
Message-ID: <3ace41890905130627s4fc2846em6ca4cbb6feb49f5b@mail.gmail.com>
Subject: Re: [PATCH v2] cfg80211: fix a couple of bugs with key ioctls
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 11:10 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> There are a few small bugs/oversights in the key handling
> code I wrote:
> =A0* SIOCSIWENCODE should default to setting key 0 if no
> =A0 default key is set already and no index is given,
> =A0* key removal should not require key material,
> =A0* SIOCSIWENCODEEXT should default to changing the default
> =A0 management key if no index is given.
> =A0* SIOCSIWENCODEEXT needs to use ext->key_len rather than
> =A0 erq->length to verify the key length
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>  ... I think I
truly earned it this time :-). This works, and I also tried the
iwconfig way and that is still working. I was using an earlier
wpa_supplicant 0.6.8-1, but switched to 0.6.8-3 (
http://koji.fedoraproject.org/koji/buildinfo?buildID=3D101920 )
yesterday seeing as Dan has put some new stuff in.

The other question -, the number was always 53.

Thanks for fixing this.

Hin-Tak

> ---
> =A0net/wireless/wext-compat.c | =A0 18 +++++++-----------
> =A01 file changed, 7 insertions(+), 11 deletions(-)
>
> --- wireless-testing.orig/net/wireless/wext-compat.c =A0 =A02009-05-1=
2 12:38:41.000000000 +0200
> +++ wireless-testing/net/wireless/wext-compat.c 2009-05-13 12:09:13.0=
00000000 +0200
> @@ -557,7 +557,7 @@ int cfg80211_wext_siwencode(struct net_d
> =A0 =A0 =A0 =A0if (idx =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0idx =3D wdev->wext.default_key;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (idx < 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 idx =3D 0;
> =A0 =A0 =A0 =A0} else if (idx < 1 || idx > 4)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
> =A0 =A0 =A0 =A0else
> @@ -580,7 +580,7 @@ int cfg80211_wext_siwencode(struct net_d
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0params.cipher =3D WLAN_CIPHER_SUITE_WE=
P40;
> =A0 =A0 =A0 =A0else if (erq->length =3D=3D 13)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0params.cipher =3D WLAN_CIPHER_SUITE_WE=
P104;
> - =A0 =A0 =A0 else
> + =A0 =A0 =A0 else if (!remove)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>
> =A0 =A0 =A0 =A0return cfg80211_set_encryption(rdev, dev, NULL, remove=
,
> @@ -614,9 +614,9 @@ int cfg80211_wext_siwencodeext(struct ne
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cipher =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0case IW_ENCODE_ALG_WEP:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (erq->length =3D=3D 5)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ext->key_len =3D=3D 5)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cipher =3D WLAN_CIPHER=
_SUITE_WEP40;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (erq->length =3D=3D 13)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (ext->key_len =3D=3D 13)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cipher =3D WLAN_CIPHER=
_SUITE_WEP104;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
> @@ -640,13 +640,9 @@ int cfg80211_wext_siwencodeext(struct ne
> =A0 =A0 =A0 =A0idx =3D erq->flags & IW_ENCODE_INDEX;
> =A0 =A0 =A0 =A0if (cipher =3D=3D WLAN_CIPHER_SUITE_AES_CMAC) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (idx < 4 || idx > 5) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* XXX: Only wpa_supp=
licant ever used this
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =A0 =A0 =A0can we =
still change the ABI a little
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =A0 =A0 =A0so we d=
o not need to keep track of
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =A0 =A0 =A0the def=
ault key?
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 idx =3D wdev->wext.defa=
ult_mgmt_key;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (idx < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
-EINVAL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0idx--;
> =A0 =A0 =A0 =A0} else {
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
