Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55AE1F5825;
	Fri,  2 Oct 2026 00:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790900552; cv=none; b=p1gHWCX94Pmv6B+NaWwQ7PA3unwdOA88pbbgT7jZrzFBna0ooS/ML0EmN9fgmd+CRHD6FUDpynHhWldfuG7j0alebTVDEPGsZv4xTTBex3tfkUrpMAKtfwfgpgGb7eaHUavBTqjY6ttmiao033ndCX6BvFgKRmXOjxbvig/FQOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790900552; c=relaxed/simple;
	bh=FA2n0hgi/Iogpb+esMIigXB9gAPNNg+U5IlCe5ZP2Ds=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EOpvmcTvC1D0VfxJBjvJJr/97MGkOs++HEA/E97I+C1RAkTtFekKCfxoHf3IGBcfiS6sGqCZmvnXzPlt+Ys6n/rLRRCyoxIfDl6jOd0YanLaMwmDntaS3A76NcV4KE3Y6ecW+/ouS1mSS+GehQVwhYpPe+pakIEKw9QJU2Gi6XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=EP8m4qhI; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="EP8m4qhI"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6920M9Fs83379008, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790900529; bh=41gja881XwSD6Xcq97M62x8f1R1dF9f+sI6SMpG01yE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=EP8m4qhIHCZbmP0hQtqgFlrhg6ZsqSK4kdHV7kOvJLkSZieKQRgxIIb/O6nWIIpya
	 TcRTSnlsji/vQToiU/ktJmYeYhSOSmVUQItPagok96CvchCa7LmoHVa+zf3DtUhVDB
	 eaVAOZ/NXFzvQ/0pEMrh98qIw7q8s7mLCa7fwvSnNjnWgM6tvyWEWiluqTU91cp6jr
	 W1hH1B2HFBnXqZPv3veVE9f3nwiPN1G+9ewZcnEDJntgaFkTV4frHl4FAwIA/dOOJB
	 xxcdAKg0rYE8YDm7af3Zhk7+uw88xKdBk1hh+Z67MWTEcqgiUdDoETEtgV7xC+GHP/
	 Q7qYJrGwtfx2A==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6920M9Fs83379008
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 2 Oct 2026 08:22:09 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 2 Oct 2026 08:22:09 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 2 Oct 2026 08:22:09 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Fri, 2 Oct 2026 08:22:09 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>, "Johnson
 Tsai" <wenjie.tsai@realtek.com>
CC: "rtl8821cerfe2@gmail.com" <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw89: fix LED dependencies
Thread-Topic: [PATCH] wifi: rtw89: fix LED dependencies
Thread-Index: AQHdT/8uPx21cNsIcEC+oww+Nsu2prbmQl0w///4wwCAAyqZYA==
Date: Fri, 2 Oct 2026 00:22:09 +0000
Message-ID: <bdb19ff5e0bc456cb035a1aa0124612f@realtek.com>
References: <20260929104159.3236854-1-arnd@kernel.org>
 <1bde7ea5999c4915b184bf2fcb904901@realtek.com>
 <0162247f-ca33-4152-bd32-255343c7216b@app.fastmail.com>
In-Reply-To: <0162247f-ca33-4152-bd32-255343c7216b@app.fastmail.com>
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

Arnd Bergmann <arnd@arndb.de> wrote:
> On Wed, Sep 30, 2026, at 02:28, Ping-Ke Shih wrote:
> > Arnd Bergmann <arnd@kernel.org> wrote:
> >> The problem is a misunderstanding of how Kconfig dependencies
> >> work, as the 'imply' keyword is not sufficient to enable a
> >> a user-visible dependency, and the boolean 'RTW89_LEDS_MC'
> >> symbol cannot determine whether linking against the MC code is
> >> valid.
> >
> > People intend to weakly select the dependency. I think keeping
> > 'imply' is harmless.
>=20
> Whoever those 'people' are, please tell them to stop using 'imply'.
>=20
> It's obviously harmless in the sense that it doesn't do enforce
> anything, it just make it more error-prone:
>=20
>  - the first 'imply' only works because MAC80211_LEDS has
>    the same dependency as RTW89_LEDS, so it works as a 'select'
>    as long as the dependencies don't change. If the dependency
>    were to change, the only difference is that imply makes it
>    harder to debug because it skips the helpful message from
>    kconfig.
>=20
> - the second 'imply' turns on a random symbol from another
>   subsystem, which is discouraged.
>=20
> - we already have a mix of 'depends on' and 'select'
>   for the LED support, which can lead to circular dependencies
>   and other problems. Adding a third way can only make it
>   worse.
>=20

Agree. I'll remove these two discouraged 'imply'.=20

> >> Address this by using the correct construct to determing whether
> >> linking agains the MAC80211_LEDS and LEDS_CLASS_MULTICOLOR
> >> code is possible, respectively.
> >>
> >> Fixes: d910631ff352 ("wifi: rtw89: add LED support to reflect the wire=
less association status")
> >> Fixes: 721d90c8509a ("wifi: rtw89: add multicolor LED support for RTL8=
852CU valve board")
> >> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >> ---
> >>  drivers/net/wireless/realtek/rtw89/Kconfig | 6 ++----
> >>  1 file changed, 2 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/net/wireless/realtek/rtw89/Kconfig
> >> b/drivers/net/wireless/realtek/rtw89/Kconfig
> >> index 7c678dd1f6b3..4000ae344544 100644
> >> --- a/drivers/net/wireless/realtek/rtw89/Kconfig
> >> +++ b/drivers/net/wireless/realtek/rtw89/Kconfig
> >> @@ -208,15 +208,13 @@ config RTW89_DEBUGFS
> >>  config RTW89_LEDS
> >>         bool
> >>         depends on RTW89_CORE
> >> -       depends on LEDS_CLASS=3Dy || LEDS_CLASS=3DMAC80211
> >
> > I remember we fixed to this style years ago by imitating ath10k and iwl=
wifi,
> > which they look like that still.
>=20
> ath10k doesn't use ieee80211_led but seems to just duplicate that code.
>=20
> I do see that my version also got it wrong, as the
>=20
> +       depends on MAC80211_LEDS=3Dy || MAC80211_LEDS=3DRTW89_CORE
>=20
> line is nonsense with MAC80211_LEDS being a 'bool' symbol.
>=20
> The way this was meant to be used is to have
>=20
> config RTW89_LEDS
>       def_bool RTW89_CORE && MAC80211_LEDS
>=20

I'd keep first block as

        depends on LEDS_CLASS=3Dy || LEDS_CLASS=3DMAC80211

mac80211 implements ieee80211_get_assoc_led_name() used by this driver as

  static inline const char *ieee80211_get_assoc_led_name(struct ieee80211_h=
w *hw)
  {
  #ifdef CONFIG_MAC80211_LEDS
	  return __ieee80211_get_assoc_led_name(hw);
  #else
	  return NULL;
  #endif
  }

That means if CONFIG_MAC80211_LEDS wasn't defined, driver can still use
ieee80211_get_assoc_led_name() as default trigger, but just NULL.
More, use space can adjust LED trigger via sysfs, so having LED support
is still usable if LEDS_CLASS exists.

Ping-Ke

