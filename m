Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793387079;
	b=Xv0PD9p5U9eaZb5mJ2VgrSJ+pnnzJiZZQ+ghLK/iwQgmgDzZjmZxls7YolXshwQWIl8L
	 IH+4Dgt5J98/OXbdn6spEgqKoqsvRN3Xm8N0m6fVYE00ybpTU9XN59SBc/ts39cU4UHEc
	 5cxSuI36S3i4zQeSeELazYGBTuErhYdHY9oYCCSlEAG80uD2t2iQV9Rf5ovCLY2VkHkZY
	 wDSFMjd/NwHwOpiFtFazhykhTUAXbsqaIsyrV/nvjAMy4xy/7ZEYW54iEvTGwaVYVIsIG
	 FEaXM/LjOpbZVu+EU27eCWVZ2WKlINR7NRtsw3JkrgJFM2oVP63VO1YbuIR66hxj+eA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793387079;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=EfGzKkGzKQIm3C48OZ3+mAYFxJWuPNjlDI4vKSoVEzk=;
	b=nYIHG1oFacVxuvFMB8Zo9nbIMhIQSePYOArHFKY1uzxikuGGuMJ1XLxeRyiFWi5+BTUP
	 mHtTcoRLl+84rYkc5NUXyB/ti3quTmwBdpoLoLVF3RkKauaYqtoDR8w9qyG672K/Q+QRp
	 lsg+vX7GNh7mBm3X9tyTm6RYhBDjSz/OdqG5eM/yRkrEPRr5ORW+jH3KfHQ9Phaenh9o3
	 zxXr1XJiZVWDQgGXId4bYIckQkUNXhP/ZcGICi6mgWAo8CC+4WeHOVtzq4hVkR33oQtdp
	 JJeSwcCBO+xu8Jhyto6nFUMpvUkw4kE4mhqOCJqNdd3iFE+JmWW73GWZfVoPCMlZCeA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=acio.nl;
	spf=none smtp.mailfrom=acio.nl;
	dkim=pass header.d=acio-nl.20260707.gappssmtp.com header.i=@acio-nl.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=LV8agx2r;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD563606A321
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 19:04:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD563606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=acio.nl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=acio.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acio-nl.20260707.gappssmtp.com header.i=@acio-nl.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=LV8agx2r
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b3dc272dcfso1460048a12.3
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 12:04:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793387076; cv=none;
        d=google.com; s=arc-20260327;
        b=I73pU6wvfGKIRZv4OZmuoh/DhPi2vetkwuZPDQ3GMRRX6S8oPfZlkb2YlUL5qrYHBR
         Z8aJZbI7QJMhrmOqUnZB9hXnmqXQelgAN9FH6eRZgYTY4M4lqKv4wpLVNIN+D+io+GFK
         uXLbijhGzycG4Ef1f6P78eSRJkFY2qC6mRuzvDT4rIn1E6T+UxjJBi70f0iFu+4O486S
         X+8jHdRtqSOWsDjduecNSWoNHUClxZWRfFHxiTHIKaFZIyIn00UTUoGBek7EgbWaKVCh
         OgOZjnMa+KajvxeOqjBOBLX+KihK5iLifgZUWxw9l5HZ6bpK5sHkub3PWRIV8ILRpjhq
         wuvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EfGzKkGzKQIm3C48OZ3+mAYFxJWuPNjlDI4vKSoVEzk=;
        fh=zFCB9yj6tbPtiNOgT9n/qK9LnQKfgtX1AWhCxXtoerY=;
        b=FQVymW7iIeh4dLvQaLl/0netB8kK+/XNtgV128V7Ybodna11ixm7rEOHTVrj2VoGzB
         /uZa6QuS2fkyKVaNlvnzO5lOpj8xQGUEFS8avH6YLYyP8cUe7DJzuhkq8SWUHijystc0
         vccWux0fFeP/k6uRNfQy6/wVngy0xE7eakv7mI/bhLvlzwl1r8pipMSBbCCwUv5+2/10
         gAo9FqK8uc4kKYfH1vne5Ht3yYTd322YoI0mSb/35Qkz0aeFGRPPxDOgzJJafwJtCr8q
         qJAwyPCEy6RSX4mTYN5jY3SIvMO/XXOHGATPS7ycZnxO9ZvM5hmPlq3jmdJONwjXDFfH
         gaEw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=acio-nl.20260707.gappssmtp.com; s=20260707; t=1793387076; x=1793991876; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EfGzKkGzKQIm3C48OZ3+mAYFxJWuPNjlDI4vKSoVEzk=;
        b=LV8agx2r3nHw8ESTF2jlznTK7t3O3mN1cTKvkvL/LbmbOeEAG4Qn9MUVu9BZJsnWOn
         TqSi5dQ2292bg3eHPBAEDi2j5UJspT85ZLAShe6wdz1lMy5QP6S8zmxNYfWnpxSulw3A
         B3Er0QPzBEq8HG82KS22Aiuj1BzSyPgZlqobBxZxgERjvJcWy4k682GM6xJi/VGr5nih
         LOi6NAOVFXbaFxYitmR/tc/xLMw+uCxCCPM41euIhoo9TBcsHZtdJ8qBse7FUtP8JSx9
         pm29FU1mxTXLaqGipROHR5FwRMKx+PvkrSVjwTX7EpMj9Ypy1mQheskcVKVIZPzBD0ic
         noew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793387076; x=1793991876;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EfGzKkGzKQIm3C48OZ3+mAYFxJWuPNjlDI4vKSoVEzk=;
        b=mQcJWkULq8956AFqrq9yaggIJVKpiiLRayRifa3OGQBMPE41Edddt0kz7p6j3cE5GE
         B9YkLTh8h8tGvK317LgKzS64l71gJ4j9FgtwBDktixlRa+33Lpod6lMjW+maW1dZCVK+
         lpVgdWEXwbTVDRcn8mBewWeqGq5ofjuODfBNN08JlOvkbTuLpmOflSRW/7+RZWOtdhyp
         9EnGYrWxjtA5LVRIScIuKGlqdKVMZT1+bT+zuttpoVxCxjNk/Gj8VDQewfuhIC3RJwx3
         ySAdMmAM0EJhJOriPtpHo26ZTG6AdEDjHvNIl7HbdQAoDajo4G2TeQhuiGATmaoK1NG3
         klIQ==
X-Gm-Message-State: AFq9FYJbBET3XiaOEoR92Vr5zuwBUqD9oAVTgyyM1DLRSALAWSPQFMZY
	vK5t9H0TBLPeYkKEVtFUqz2biu+ewSIIWasmaVM4gjuHfEf8L1CSjyp3mNLD+u+zZ4C0mqmVlwY
	y8NghRjc7uBAINzsYNn9RbcSdZljgTbEKwIVdkvz/eCjk0cn0OfNNHzUe
X-Gm-Gg: AYBFou0sJgcx8YvNVbQgvv/r86RENhnCcu82aRuAbBCbpcwJEJ4O5wS8O7mryn5XFB/
	20fvwZCmSP2OljmHN5kNEY/SpYRlbYtYRWRGK4XqBF2mWNztL07tPymsDfYStByRYBwgC3NpYbo
	/yweNFhi3n3ZI6XzTftOMxTqVNgjqoFJCYLnx9rJM+FeGg4ipPjG6Xvkg5scDnXmNKGeuLncdCO
	m5SdIhpk5I9CyojcStRs3eWyzx19JjA9wZ7STP96+WYVce8vkFo78qbYr9oJArZBVjIjmJCkFB7
	Dp4xtt774ZYnhEC7VHskDoZRsnOaZyt0zlvdUBLolWn45ZQwWxntCCjkus+kadk8khzw7YjBBkv
	jt7sND6ueuIDRaqeLSH6fIxaoHhPsAfnshC4BmEaX7uV6CVwjoLstYcrvhkKx
X-Received: by 2002:a05:6402:342:b0:6b4:43e6:6b28 with SMTP id
 4fb4d7f45d1cf-6b4d5ce335cmr1744456a12.35.1793387075322; Fri, 30 Oct 2026
 12:04:35 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261020130019.137170-1-spam@acio.nl> <1ca81a8669be41a6924ad0c5e042fcdc@realtek.com>
In-Reply-To: <1ca81a8669be41a6924ad0c5e042fcdc@realtek.com>
From: "V. S." <spam@acio.nl>
Date: Fri, 30 Oct 2026 20:04:24 +0100
X-Gm-Features: AclHuK_z5xvbnqr1Kc4Tt1rSykNaDkXLNvqRezRgQZ5CwY3VYh85KaeT7tfiIEk
Message-ID: <CAJKtVVb8XedNH4Dcfbe2--CdtWM45JYWVA=2arTEW37Er-e8NA@mail.gmail.com>
Subject: Re: [PATCH rtw-next] wifi: rtw89: do BIP in software when not in
 station mode
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ping-Ke Shih <pkshih@realtek.com> wrote:
> A RFT patch for test purpose.
>
> It needs software generate MMIC header but excluding 8-byte MIC space.

Thank you. The patch works on my device.

Test setup:
- RTL8912AU (RTL8922A, USB) in AP mode, firmware 0.35.80.3.
- Raspberry Pi 5, kernel 6.18, out-of-tree rtw89 from
  morrownr/rtw89 with this patch applied.
- hostapd 2.10, WPA2-PSK/CCMP, ieee80211w=3D1.
- Client: Intel Meteor Lake CNVi (iwlwifi), connected with MFP.

Test: I sent a protected broadcast deauthentication with
"hostapd_cli deauthenticate ff:ff:ff:ff:ff:ff" and read the kernel
log of the client. I did the test in the sequence A/B/B/A, with
A =3D BIP in software (my patch) and B =3D this RFT patch.

  driver             client log                          delay
  A  BIP software    deauthenticated from <AP> (Reason 2)  < 0.01 s
  B  RFT, run 1      deauthenticated from <AP> (Reason 2)    0.15 s
  B  RFT, run 2      deauthenticated from <AP> (Reason 2)    0.02 s
  A  BIP software    deauthenticated from <AP> (Reason 2)    0.12 s

The delay is the time between the hostapd command on the AP and the
client log. The two clocks use NTP, but the delay values are not
exact.

With the RFT patch, the client accepts the protected broadcast frame
at once, and the driver does not log "key cipher not supported". My
earlier test of BIP in hardware did not trim the 8-byte MIC space, and
the client did not accept the frame. Thus, your diagnosis is correct.

Tested-by: V schurink <spam@acio.nl>

Please drop my patch "wifi: rtw89: do BIP in software when not in
station mode". This patch replaces it.

One note: mac80211 increments key->tx_pn when it writes the IPN into
the MMIE, and rtw89_core_tx_update_sec_key() increments it again for
sec_seq. Thus, the PN increases by 2 for each frame. This did not
cause a problem in my test. I do not know which value the hardware
uses for the MIC.


On Thu, Oct 29, 2026 at 2:57=E2=80=AFAM Ping-Ke Shih <pkshih@realtek.com> w=
rote:
>
> V schurink <spam@acio.nl> wrote:
> > rtw89_cam_sec_key_add() installs the AES-CMAC key (BIP, 802.11w PMF)
> > in hardware. rtw89_core_tx_update_sec_key() has no case for
> > WLAN_CIPHER_SUITE_AES_CMAC, and the driver does not set
> > IEEE80211_KEY_FLAG_GENERATE_MMIE. Thus, an AP with PMF sends each
> > protected group-addressed management frame without an MMIE, for
> > example a broadcast deauthentication. For each frame, the driver logs
> > "key cipher not supported 1027078". PMF clients discard these frames.
> >
> > An AP sends these frames. Thus, return -EOPNOTSUPP for AES-CMAC when
> > the interface is not a station, so that mac80211 does BIP in software.
> > A station only receives these frames, so it keeps the IGTK in
> > hardware. This does not change WoWLAN, which uses the IGTK of a
> > station.
> >
> > BIP in hardware does not work for an AP on RTL8922A. The test used
> > IEEE80211_KEY_FLAG_GENERATE_MMIE and RTW89_SEC_KEY_TYPE_BIP_CCMP128 in
> > the TX descriptor. The client did not accept the protected broadcast
> > deauthentication.
> >
> > Tested on RTL8912AU (RTL8922A, USB) in AP mode with hostapd 2.10,
> > WPA2-PSK and SAE, ieee80211w=3D1. The client accepts the protected
> > broadcast deauthentication, and the driver does not log the warning.
>
> We made a RFT patch [1]. Please try if it can work to you.
>
> I think the reason why your try in github doesn't work is missing to
> trim MIC space of MMIC.
>
> [1] https://lore.kernel.org/linux-wireless/20261029014857.9753-1-pkshih@r=
ealtek.com/T/#u
>
> >
> > Fixes: 940cd99625de ("wifi: rtw89: wow: support 802.11w PMF IGTK rekey"=
)
> > Signed-off-by: V schurink <spam@acio.nl>
> > ---
> >  drivers/net/wireless/realtek/rtw89/cam.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/drivers/net/wireless/realtek/rtw89/cam.c b/drivers/net/wir=
eless/realtek/rtw89/cam.c
> > index 22f21a0..58a7e8f 100644
> > --- a/drivers/net/wireless/realtek/rtw89/cam.c
> > +++ b/drivers/net/wireless/realtek/rtw89/cam.c
> > @@ -514,6 +514,12 @@ int rtw89_cam_sec_key_add(struct rtw89_dev *rtwdev=
,
> >                 ext_key =3D true;
> >                 break;
> >         case WLAN_CIPHER_SUITE_AES_CMAC:
> > +               /* TX does not support BIP. An AP sends group-addressed=
 robust
> > +                * management frames, so let mac80211 do BIP in softwar=
e there.
> > +                * A station only receives them; keep its IGTK in hardw=
are.
> > +                */
>
> The first line of block comment should be empty. Even, I think this comme=
nt
> is not necessary. The change blow says that, or it should be 'vif =3D=3D =
IFTYPE_AP'
> to match the comment.
>
> > +               if (vif->type !=3D NL80211_IFTYPE_STATION)
> > +                       return -EOPNOTSUPP;
> >                 hw_key_type =3D RTW89_SEC_KEY_TYPE_BIP_CCMP128;
> >                 break;
> >         default:
> > --
> > 2.53.0
> > ---
> > Also discussed in the out-of-tree repository:
> > https://github.com/morrownr/rtw89/pull/135
>
