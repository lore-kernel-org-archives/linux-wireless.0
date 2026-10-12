Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CE41B6D1A;
	Mon, 12 Oct 2026 02:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791770857; cv=none; b=GYKXqPbbfGZTmvlpbkqA+lLlUGJS/0wneNkiHG/8xDBmgbod+LN/S7K3vkUM9G+JakOwNeeX4L1m7HIkaMCi2f38xN5C0V4TXrQe+OWdh7/VccXWbXPg6itRMGzSCxEsXaS3/AKsnhw7da79Je7PtmbhkrL0JoTfh5PhJJvt9R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791770857; c=relaxed/simple;
	bh=2Q2BIV5lp9ImlKJdn0QZWEu2BGye0/1dmfiJ9NgpBTA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Xx+OmWm+FfPCzttwB169mZkBB01sMXu33ZHFE47cEOcvYUL9UZbRnb7FAXahpuU53iTOej1NHehMK4aEGRJaYwrAQ9YuBSDfm8APxOaAb4fp3PN01gSq6LcopY+y1nePneDowM5vCytf2e3Sjt09Qc4LT34jh4eUoDAgacf2pYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=HF6lEFAv; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="HF6lEFAv"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69C27NPC03443873, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791770843; bh=QeXmRr3AiKq8hUNmBmRhA+tlOKyC9490H0cQFFtlgoA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=HF6lEFAvjVDnLkI1kMhPZtIe/G771qOxndtj/9xhPEgeU3eQKBg2M2tuQtc0xE1BW
	 hTiB/7JSS2oI6acj9RfMF3EbeioFXRPPQhsKXSqng7CaabxaT3fs9ELbzf7wj+iKkM
	 CbxrQuHfHaadaQNSRVhg+n5AtGcnk3e+htldbMZSdR6floyWoStll5kv9g1TYyDCL/
	 /Ms/l20bfcd8VsdCvtafyViHsjKdGP3PgCsJUXAj267XZrtZLv5PRVchWoC0G6dK8A
	 hNQJuZSekShpyHYgLHLCuqTtxrifOMYUWCeyiBOsI3pEMRWDRpYmFXR5vDMypGLPMz
	 Czr3upx95ILQg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69C27NPC03443873
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 12 Oct 2026 10:07:23 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 10:07:29 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 12 Oct 2026 10:07:29 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Jeremy Fareau <jeremy.fareau@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kalle Valo
	<kvalo@kernel.org>, Brian Norris <briannorris@chromium.org>
Subject: RE: [PATCH wireless 1/2] wifi: rtw88: program the channel when the
 device is started
Thread-Topic: [PATCH wireless 1/2] wifi: rtw88: program the channel when the
 device is started
Thread-Index: AQHdVjwahGgi/otdOEaUNh5a7YEQ/7b5Lmpg
Date: Mon, 12 Oct 2026 02:07:28 +0000
Message-ID: <1db01a5856b54d17a8f3d07728ad3e87@realtek.com>
References: <20261007091225.413-1-jeremy.fareau@gmail.com>
 <20261007091225.413-2-jeremy.fareau@gmail.com>
In-Reply-To: <20261007091225.413-2-jeremy.fareau@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Jeremy Fareau <jeremy.fareau@gmail.com> wrote:
> The chip is reset by power_off()/power_on(), but mac80211 only calls
> ieee80211_ops::config() when its own channel state changes.  After a
> stop/start cycle, such as
>=20
>     ip link set <dev> down
>     ip link set <dev> up
>=20
> the channel is unchanged from mac80211's point of view, so the radio is
> never reprogrammed.

Not sure why you use 'program' I have never seen the term using to set chan=
nel.

>  The device then listens on whatever channel the
> hardware came up on while iw reports the configured one, and receives
> almost nothing.
>=20
> Observed with an RTL8814AU (ALFA AWUS1900) in monitor mode on an
> aarch64 host.

Only monitor mode doesn't work as your expectation, right?

>  A 25 s capture on channel 6 after a down/up cycle yields
> 3 frames, and 431 frames as soon as any real channel change is
> requested.  An RTL8812AU (Linksys WUSB6300) on the same host, the same
> channel and the same second yields 2438 frames.
>=20
> Program the channel in rtw_ops_start(), like rtw_ips_pwr_up() already
> does when leaving IPS.
>=20
> Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
> Assisted-by: LLM
> Signed-off-by: Jeremy Fareau <jeremy.fareau@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/mac80211.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c
> b/drivers/net/wireless/realtek/rtw88/mac80211.c
> index b01b98d24b0a..827f38390969 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac80211.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
> @@ -57,6 +57,17 @@ static int rtw_ops_start(struct ieee80211_hw *hw)
>=20
>         mutex_lock(&rtwdev->mutex);
>         ret =3D rtw_core_start(rtwdev);
> +
> +       /* The chip is reset by power_off()/power_on(), but mac80211 only=
 calls
> +        * ieee80211_ops::config() when its own channel state changes. Af=
ter a
> +        * stop/start cycle the channel is unchanged from mac80211's poin=
t of
> +        * view, so the radio would never be reprogrammed and the device =
would
> +        * receive nothing. Program it here, like rtw_ips_pwr_up() alread=
y does
> +        * when leaving IPS.
> +        */
> +       if (!ret && hw->conf.chandef.chan)

I think we can flag that it is working on monitor mode in
rtw_ops_{add,remove,change}_interface and do set_channel() only if monitor =
mode.

I suppose we can have a name containing 'monitor_mode', so the comment is n=
ot
necessary.=20

An existing flag is "rtwdev->hw->conf.flags & IEEE80211_CONF_MONITOR".
I'm not sure if it is enough here.=20

> +               rtw_set_channel(rtwdev);
> +
>         mutex_unlock(&rtwdev->mutex);
>=20
>         return ret;
> --
> 2.43.0

