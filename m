Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DA13BD22F
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 19:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784834819; cv=pass; b=RW1WClD3Qv8DIJYR9nQGpupB0/r4d9u3F/jRwKH6cEXSEE5E4vSQUOS16QGe+ZEmhZTvg0wHRzhxYuKA49cD8+nTGu8AQlwBBOMLgDgdXHAhqKTA89vLzFAwr/EfTalyA5KPUykddWxmS5kN7VU5rimKH/79d1aEKKn9GpHZmpQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784834819; c=relaxed/simple;
	bh=3qDUJCleO9/mQDxvVj55P94PNa8vDe1TK7upIEPAyAU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fJLbd6clCfde4F6PGH20BJdD2vErw3GuQt1UYE2xcr14Lx7Tr4+QZsXYQzFDerOq4zyjt8snUbuStJdkKySEZczXS6/DrfKg+T5crZVA6Fkbz2JPeplHzoNawQgK4DxJxrG2y+UP4lB0lf2giJraj1wDk/kAJmJKlkJyp9plzRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UXaSW3HC; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UXaSW3HC"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-698e5859a3cso1910302a12.0
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:26:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784834815; cv=none;
        d=google.com; s=arc-20260327;
        b=A4PDav7chCx7y1/koGWvWHUMlql+mAW7tNNTUbT+jQT9FYCpwKuFUmrV54Ku07LVQA
         WRExoXqsDQP1wAyiYTnXo8yhfwbtjki67d4292Jt7E+V9LMV20PH0OTc5OV8S0Hz/+01
         CDVqpZysnFFN9s95EK/gGAEUGohWekSmaaV+f2pl1KP8ocFQpUi/ZDte/qy3UA8BegHI
         fpzWm4Oxcr7lgH3IjmvbWnc9krd/5bapgBeomQM2xtVxylXUrGIo5+T0OEXC1fOwXYys
         D9Ux+AxsllaCUqdfTtMEcA4hJXISJHovdbXifkh0Wkl2P5lRQPUVH52QJMUBKWeiG8tc
         m/sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c48oFHcUl73M+7xCb5JNWHbcfZqyaHeFDgmQTnaFHyM=;
        fh=CvQnD10pQMKx9c2xOLuyhTTG6dSx1W1QrkOBwjpkfW0=;
        b=V/v3v2zsLRDZHTJrtHIumw1vScUl8+XbnLt2ExWXy7WGcGRzHnkRJbYDpr4DztNnGS
         Ikb3881NpbLZGjwwq+VEW+Wc13RA3g/+UovvkulFg6P6swEGM2mYM7WIObYFN7Y7Hqpd
         UBTqeC9/7ENyUq2UOR3JIT8iOSYEgEkHlujHwNaQn5pA8B1wlF79gtGuW5DI6SIMcvUh
         tSvw0vEOtRQxfcTnHKAIO5b14ZEjZ/f3yDDU8TsbRVi47RiC2Rz5q0jEXzIKlE8FcV66
         3xnlQc83BByjZG+SLkw4kUhI4SMIU09R5qHFTlkCuaX7OvqwfoVXvQkGpetqqEb1yTX/
         GxgA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784834815; x=1785439615; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c48oFHcUl73M+7xCb5JNWHbcfZqyaHeFDgmQTnaFHyM=;
        b=UXaSW3HCerlbhByKSge9NZJmMicliu+mZs6lO/cyFlMtXX/oKRyuNtc878gOp5TW/Y
         SS1h5kWwX2lBrIfwegBn2UUFDEtEjmUZaCqK/GeQAexgTP4YBwU+TwsTQJ99UwqQ8pKC
         wndW3x+c8RFNeNgyeuxP7tUzcZvO+rxaH3Qj51u/2FncGAN/ZyYbh2uB5B8T1aE9z0pi
         14lHp03bTmQkPTEQ11vyLJcxUIf+fujPwQx5R5xgOLgXqilLx5nhXkppoUxZHgRE/89Q
         kVsk9JGrNa1lfMqDssK6BPceUtBWsP9INwRKgwj0gJTEmu89+5T5AkQ51o0SxZsQn4S7
         8+og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784834815; x=1785439615;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c48oFHcUl73M+7xCb5JNWHbcfZqyaHeFDgmQTnaFHyM=;
        b=JmQv1zLi+LVrme4wNvqYuu+REp07R7xZykdnzZHT1jjnZWRP46zMHqbdf62vkSUeZe
         EvrTT/PcUpLX3MQTx2B1rxk5ZvF5eQ0g/pEendqbNluGV9OVPQ5pzqhCIT/sxpZYw1Uy
         nMI0Z+T84G7//2/MmCAAHh2s2t10moyPoWbShFE5V0DfjhzBk/Y7263qYuqES+sH/0pX
         ZtrcA0oBWmnRstVW+y47j31L4J4Cd2E8K0OI1FTbGNXKFKhaP5taw0ZGmsezKXGk9IuW
         1YGIHqdifuUUggbjPt4+DqnNZ7vSbRKoIkQCH7QJx6K+idL+MS6oz1QeNtZVZuU1EWdu
         t34w==
X-Gm-Message-State: AOJu0YwXyMnR1AB3pyYYgT4RW4MuMfjHr1zdQCly0rLoKCjpbEF2H+NM
	ddbtI/DXqAkD182yHYyvFg0xVZwijD8yCVQu37f2aemLxeaWx52qP7ps57JV0xMG1gkBIxkKY+S
	7HnnXpCSxGSFu1DCkgOAfnQ7yaUZS9xA=
X-Gm-Gg: AR+sD13A1MyScR3IuMQxp3ybtvQPeOk6UiZ9jb/flovxnw60iMRoh4AzDwzwFkPIN0Z
	+5t7+VjfwnPxIfUa0MHwcWzBOkIlex4qjcAGoV7oFJNtZCRI0+/52Z2E6a6PloVtpkf1/DK9/n9
	+Ug+gmlTatvcZRV9ZF41wZIbxNChTpcAiXdw/q9b76FXGmbuSL/Am05cjlXsB9D4jBnhGEanGG7
	hEcuf6gePjMe7sthl9+DPf+NbexqPDE+TCkvzoOWUx1gL/lmGovbHyt1cXBQ48LYzAjV94BDc5z
	dy+2t83ZwGTqhsoottUqmLMEmqqNLSVUFhrjoLfEXrsvAeu3Le6686mdhsM48sfP6TRbeAojVjj
	+Q2LI80Pi6fR7NJOICiBE0q6WXgWtLLgJB4xq2U6Aex/HAFU+h4+TXcMpr4RyKxig/qqSoipDKo
	XeLNmWCIE=
X-Received: by 2002:a05:6402:2381:b0:69f:a71:8d69 with SMTP id
 4fb4d7f45d1cf-69f7484278bmr1704021a12.10.1784834814248; Thu, 23 Jul 2026
 12:26:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260629033156.2363850-1-rosenp@gmail.com> <20260723075304.GA4577@wp.pl>
In-Reply-To: <20260723075304.GA4577@wp.pl>
From: Rosen Penev <rosenp@gmail.com>
Date: Thu, 23 Jul 2026 12:26:41 -0700
X-Gm-Features: AUfX_mzpmUaJhE3D_n-zE7eGSgQLoC7It6rfepFnJRnT3lAzERi3FXxY9y0n_Wk
Message-ID: <CAKxU2N_LbndYqrGDQ__sAjj87mj-J8Hs-RWeD90eRcGK1dDAcw@mail.gmail.com>
Subject: Re: [PATCH wireless-next] wifi: rt2x00: Use flexible array for
 hw_mode_spec channels
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL HARDENING (not covered by other areas):Keyword:b__counted_by(_le|_be|_ptr)?b" <linux-hardening@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 12:53=E2=80=AFAM Stanislaw Gruszka <stf_xl@wp.pl> w=
rote:
>
> Hi,
>
> On Sun, Jun 28, 2026 at 08:31:56PM -0700, Rosen Penev wrote:
> > struct hw_mode_spec stores channel information that is allocated by the
> > individual rt2x00 drivers during hardware probing.  The channel info
> > array has the same lifetime as the hardware mode specification, but it
> > is currently allocated separately and then freed through a separate
> > pointer.
> >
> > Make struct rt2x00_dev hold a pointer to the hardware mode
> > specification, store the channel info as a flexible array member, and
> > allocate both pieces together with kzalloc_flex().
> >
> > Assisted-by: Codex:GPT-5.5
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> > ---
> >  .../net/wireless/ralink/rt2x00/rt2400pci.c    | 24 +++---
> >  .../net/wireless/ralink/rt2x00/rt2500pci.c    | 55 ++++++++------
> >  .../net/wireless/ralink/rt2x00/rt2500usb.c    | 55 ++++++++------
> >  .../net/wireless/ralink/rt2x00/rt2800lib.c    | 74 ++++++++++---------
> >  drivers/net/wireless/ralink/rt2x00/rt2x00.h   |  4 +-
> >  .../net/wireless/ralink/rt2x00/rt2x00config.c | 12 +--
> >  .../net/wireless/ralink/rt2x00/rt2x00dev.c    |  4 +-
> >  drivers/net/wireless/ralink/rt2x00/rt61pci.c  | 42 ++++++-----
> >  drivers/net/wireless/ralink/rt2x00/rt73usb.c  | 50 +++++++------
> >  9 files changed, 177 insertions(+), 143 deletions(-)
>
> This result in extra code. I do not see benefit of avoiding
> kzalloc calls at cost of adding more lines of code.
On runtime there's extra UBSAN analysis. Reducing allocations is always goo=
d.
>
> Regards
> Stanislaw
>
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c b/drivers/n=
et/wireless/ralink/rt2x00/rt2400pci.c
> > index cac191304bf5..3fb74dcbee63 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
> > @@ -1559,7 +1559,7 @@ static const struct rf_channel rf_vals_b[] =3D {
> >
> >  static int rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
> >  {
> > -     struct hw_mode_spec *spec =3D &rt2x00dev->spec;
> > +     struct hw_mode_spec *spec;
> >       struct channel_info *info;
> >       u8 *tx_power;
> >       unsigned int i;
> > @@ -1580,27 +1580,25 @@ static int rt2400pci_probe_hw_mode(struct rt2x0=
0_dev *rt2x00dev)
> >       /*
> >        * Initialize hw_mode information.
> >        */
> > -     spec->supported_bands =3D SUPPORT_BAND_2GHZ;
> > -     spec->supported_rates =3D SUPPORT_RATE_CCK;
> > +     spec =3D kzalloc_flex(*spec, channels_info, ARRAY_SIZE(rf_vals_b)=
);
> > +     if (!spec)
> > +             return -ENOMEM;
> >
> >       spec->num_channels =3D ARRAY_SIZE(rf_vals_b);
> >       spec->channels =3D rf_vals_b;
> >
> > -     /*
> > -      * Create channel information array
> > -      */
> > -     info =3D kzalloc_objs(*info, spec->num_channels);
> > -     if (!info)
> > -             return -ENOMEM;
> > -
> > -     spec->channels_info =3D info;
> > +     spec->supported_bands =3D SUPPORT_BAND_2GHZ;
> > +     spec->supported_rates =3D SUPPORT_RATE_CCK;
> >
> >       tx_power =3D rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
> >       for (i =3D 0; i < 14; i++) {
> > -             info[i].max_power =3D TXPOWER_FROM_DEV(MAX_TXPOWER);
> > -             info[i].default_power1 =3D TXPOWER_FROM_DEV(tx_power[i]);
> > +             info =3D &spec->channels_info[i];
> > +             info->max_power =3D TXPOWER_FROM_DEV(MAX_TXPOWER);
> > +             info->default_power1 =3D TXPOWER_FROM_DEV(tx_power[i]);
> >       }
> >
> > +     rt2x00dev->spec =3D spec;
> > +
> >       return 0;
> >  }
> >
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c b/drivers/n=
et/wireless/ralink/rt2x00/rt2500pci.c
> > index fc35b60e422c..4c85f401c091 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
> > @@ -1854,7 +1854,10 @@ static const struct rf_channel rf_vals_5222[] =
=3D {
> >
> >  static int rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
> >  {
> > -     struct hw_mode_spec *spec =3D &rt2x00dev->spec;
> > +     const struct rf_channel *channels;
> > +     unsigned int num_channels =3D 0;
> > +     unsigned int supported_bands;
> > +     struct hw_mode_spec *spec;
> >       struct channel_info *info;
> >       u8 *tx_power;
> >       unsigned int i;
> > @@ -1880,52 +1883,58 @@ static int rt2500pci_probe_hw_mode(struct rt2x0=
0_dev *rt2x00dev)
> >       /*
> >        * Initialize hw_mode information.
> >        */
> > -     spec->supported_bands =3D SUPPORT_BAND_2GHZ;
> > -     spec->supported_rates =3D SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
> > +     supported_bands =3D SUPPORT_BAND_2GHZ;
> >
> >       if (rt2x00_rf(rt2x00dev, RF2522)) {
> > -             spec->num_channels =3D ARRAY_SIZE(rf_vals_bg_2522);
> > -             spec->channels =3D rf_vals_bg_2522;
> > +             num_channels =3D ARRAY_SIZE(rf_vals_bg_2522);
> > +             channels =3D rf_vals_bg_2522;
> >       } else if (rt2x00_rf(rt2x00dev, RF2523)) {
> > -             spec->num_channels =3D ARRAY_SIZE(rf_vals_bg_2523);
> > -             spec->channels =3D rf_vals_bg_2523;
> > +             num_channels =3D ARRAY_SIZE(rf_vals_bg_2523);
> > +             channels =3D rf_vals_bg_2523;
> >       } else if (rt2x00_rf(rt2x00dev, RF2524)) {
> > -             spec->num_channels =3D ARRAY_SIZE(rf_vals_bg_2524);
> > -             spec->channels =3D rf_vals_bg_2524;
> > +             num_channels =3D ARRAY_SIZE(rf_vals_bg_2524);
> > +             channels =3D rf_vals_bg_2524;
> >       } else if (rt2x00_rf(rt2x00dev, RF2525)) {
> > -             spec->num_channels =3D ARRAY_SIZE(rf_vals_bg_2525);
> > -             spec->channels =3D rf_vals_bg_2525;
> > +             num_channels =3D ARRAY_SIZE(rf_vals_bg_2525);
> > +             channels =3D rf_vals_bg_2525;
> >       } else if (rt2x00_rf(rt2x00dev, RF2525E)) {
> > -             spec->num_channels =3D ARRAY_SIZE(rf_vals_bg_2525e);
> > -             spec->channels =3D rf_vals_bg_2525e;
> > +             num_channels =3D ARRAY_SIZE(rf_vals_bg_2525e);
> > +             channels =3D rf_vals_bg_2525e;
> >       } else if (rt2x00_rf(rt2x00dev, RF5222)) {
> > -             spec->supported_bands |=3D SUPPORT_BAND_5GHZ;
> > -             spec->num_channels =3D ARRAY_SIZE(rf_vals_5222);
> > -             spec->channels =3D rf_vals_5222;
> > +             supported_bands |=3D SUPPORT_BAND_5GHZ;
> > +             num_channels =3D ARRAY_SIZE(rf_vals_5222);
> > +             channels =3D rf_vals_5222;
> >       }
> >
> >       /*
> >        * Create channel information array
> >        */
> > -     info =3D kzalloc_objs(*info, spec->num_channels);
> > -     if (!info)
> > +     spec =3D kzalloc_flex(*spec, channels_info, num_channels);
> > +     if (!spec)
> >               return -ENOMEM;
> >
> > -     spec->channels_info =3D info;
> > +     spec->num_channels =3D num_channels;
> > +     spec->channels =3D channels;
> > +     spec->supported_bands =3D supported_bands;
> > +     spec->supported_rates =3D SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
> >
> >       tx_power =3D rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
> >       for (i =3D 0; i < 14; i++) {
> > -             info[i].max_power =3D MAX_TXPOWER;
> > -             info[i].default_power1 =3D TXPOWER_FROM_DEV(tx_power[i]);
> > +             info =3D &spec->channels_info[i];
> > +             info->max_power =3D MAX_TXPOWER;
> > +             info->default_power1 =3D TXPOWER_FROM_DEV(tx_power[i]);
> >       }
> >
> >       if (spec->num_channels > 14) {
> >               for (i =3D 14; i < spec->num_channels; i++) {
> > -                     info[i].max_power =3D MAX_TXPOWER;
> > -                     info[i].default_power1 =3D DEFAULT_TXPOWER;
> > +                     info =3D &spec->channels_info[i];
> > +                     info->max_power =3D MAX_TXPOWER;
> > +                     info->default_power1 =3D DEFAULT_TXPOWER;
> >               }
> >       }
> >
> > +     rt2x00dev->spec =3D spec;
> > +
> >       return 0;
> >  }
> >
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c b/drivers/n=
et/wireless/ralink/rt2x00/rt2500usb.c
> > index 58728df6666c..cbc1c1399cc6 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> > @@ -1661,7 +1661,10 @@ static const struct rf_channel rf_vals_5222[] =
=3D {
> >
> >  static int rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
> >  {
> > -     struct hw_mode_spec *spec =3D &rt2x00dev->spec;
> > +     const struct rf_channel *channels;
> > +     unsigned int num_channels =3D 0;
> > +     unsigned int supported_bands;
> > +     struct hw_mode_spec *spec;
> >       struct channel_info *info;
> >       u8 *tx_power;
> >       unsigned int i;
> > @@ -1693,52 +1696,58 @@ static int rt2500usb_probe_hw_mode(struct rt2x0=
0_dev *rt2x00dev)
> >       /*
> >        * Initialize hw_mode information.
> >        */
> > -     spec->supported_bands =3D SUPPORT_BAND_2GHZ;
> > -     spec->supported_rates =3D SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
> > +     supported_bands =3D SUPPORT_BAND_2GHZ;
> >
> >       if (rt2x00_rf(rt2x00dev, RF2522)) {
> > -             spec->num_channels =3D ARRAY_SIZE(rf_vals_bg_2522);
> > -             spec->channels =3D rf_vals_bg_2522;
> > +             num_channels =3D ARRAY_SIZE(rf_vals_bg_2522);
> > +             channels =3D rf_vals_bg_2522;
> >       } else if (rt2x00_rf(rt2x00dev, RF2523)) {
> > -             spec->num_channels =3D ARRAY_SIZE(rf_vals_bg_2523);
> > -             spec->channels =3D rf_vals_bg_2523;
> > +             num_channels =3D ARRAY_SIZE(rf_vals_bg_2523);
> > +             channels =3D rf_vals_bg_2523;
> >       } else if (rt2x00_rf(rt2x00dev, RF2524)) {
> > -             spec->num_channels =3D ARRAY_SIZE(rf_vals_bg_2524);
> > -             spec->channels =3D rf_vals_bg_2524;
> > +             num_channels =3D ARRAY_SIZE(rf_vals_bg_2524);
> > +             channels =3D rf_vals_bg_2524;
> >       } else if (rt2x00_rf(rt2x00dev, RF2525)) {
> > -             spec->num_channels =3D ARRAY_SIZE(rf_vals_bg_2525);
> > -             spec->channels =3D rf_vals_bg_2525;
> > +             num_channels =3D ARRAY_SIZE(rf_vals_bg_2525);
> > +             channels =3D rf_vals_bg_2525;
> >       } else if (rt2x00_rf(rt2x00dev, RF2525E)) {
> > -             spec->num_channels =3D ARRAY_SIZE(rf_vals_bg_2525e);
> > -             spec->channels =3D rf_vals_bg_2525e;
> > +             num_channels =3D ARRAY_SIZE(rf_vals_bg_2525e);
> > +             channels =3D rf_vals_bg_2525e;
> >       } else if (rt2x00_rf(rt2x00dev, RF5222)) {
> > -             spec->supported_bands |=3D SUPPORT_BAND_5GHZ;
> > -             spec->num_channels =3D ARRAY_SIZE(rf_vals_5222);
> > -             spec->channels =3D rf_vals_5222;
> > +             supported_bands |=3D SUPPORT_BAND_5GHZ;
> > +             num_channels =3D ARRAY_SIZE(rf_vals_5222);
> > +             channels =3D rf_vals_5222;
> >       }
> >
> >       /*
> >        * Create channel information array
> >        */
> > -     info =3D kzalloc_objs(*info, spec->num_channels);
> > -     if (!info)
> > +     spec =3D kzalloc_flex(*spec, channels_info, num_channels);
> > +     if (!spec)
> >               return -ENOMEM;
> >
> > -     spec->channels_info =3D info;
> > +     spec->num_channels =3D num_channels;
> > +     spec->channels =3D channels;
> > +     spec->supported_bands =3D supported_bands;
> > +     spec->supported_rates =3D SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
> >
> >       tx_power =3D rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
> >       for (i =3D 0; i < 14; i++) {
> > -             info[i].max_power =3D MAX_TXPOWER;
> > -             info[i].default_power1 =3D TXPOWER_FROM_DEV(tx_power[i]);
> > +             info =3D &spec->channels_info[i];
> > +             info->max_power =3D MAX_TXPOWER;
> > +             info->default_power1 =3D TXPOWER_FROM_DEV(tx_power[i]);
> >       }
> >
> >       if (spec->num_channels > 14) {
> >               for (i =3D 14; i < spec->num_channels; i++) {
> > -                     info[i].max_power =3D MAX_TXPOWER;
> > -                     info[i].default_power1 =3D DEFAULT_TXPOWER;
> > +                     info =3D &spec->channels_info[i];
> > +                     info->max_power =3D MAX_TXPOWER;
> > +                     info->default_power1 =3D DEFAULT_TXPOWER;
> >               }
> >       }
> >
> > +     rt2x00dev->spec =3D spec;
> > +
> >       return 0;
> >  }
> >
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/n=
et/wireless/ralink/rt2x00/rt2800lib.c
> > index 97290899674e..7b7f6dcc9247 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > @@ -11778,7 +11778,9 @@ static const struct rf_channel rf_vals_7620[] =
=3D {
> >
> >  static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
> >  {
> > -     struct hw_mode_spec *spec =3D &rt2x00dev->spec;
> > +     const struct rf_channel *channels;
> > +     unsigned int num_channels =3D 0;
> > +     struct hw_mode_spec *spec;
> >       struct channel_info *info;
> >       s8 *default_power1;
> >       s8 *default_power2;
> > @@ -11840,19 +11842,17 @@ static int rt2800_probe_hw_mode(struct rt2x00=
_dev *rt2x00dev)
> >       /*
> >        * Initialize hw_mode information.
> >        */
> > -     spec->supported_rates =3D SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
> > -
> >       switch (rt2x00dev->chip.rf) {
> >       case RF2720:
> >       case RF2820:
> > -             spec->num_channels =3D 14;
> > -             spec->channels =3D rf_vals;
> > +             num_channels =3D 14;
> > +             channels =3D rf_vals;
> >               break;
> >
> >       case RF2750:
> >       case RF2850:
> > -             spec->num_channels =3D ARRAY_SIZE(rf_vals);
> > -             spec->channels =3D rf_vals;
> > +             num_channels =3D ARRAY_SIZE(rf_vals);
> > +             channels =3D rf_vals;
> >               break;
> >
> >       case RF2020:
> > @@ -11870,44 +11870,52 @@ static int rt2800_probe_hw_mode(struct rt2x00=
_dev *rt2x00dev)
> >       case RF5372:
> >       case RF5390:
> >       case RF5392:
> > -             spec->num_channels =3D 14;
> > +             num_channels =3D 14;
> >               if (rt2800_clk_is_20mhz(rt2x00dev))
> > -                     spec->channels =3D rf_vals_3x_xtal20;
> > +                     channels =3D rf_vals_3x_xtal20;
> >               else
> > -                     spec->channels =3D rf_vals_3x;
> > +                     channels =3D rf_vals_3x;
> >               break;
> >
> >       case RF7620:
> > -             spec->num_channels =3D ARRAY_SIZE(rf_vals_7620);
> > -             spec->channels =3D rf_vals_7620;
> > +             num_channels =3D ARRAY_SIZE(rf_vals_7620);
> > +             channels =3D rf_vals_7620;
> >               break;
> >
> >       case RF3052:
> >       case RF3053:
> > -             spec->num_channels =3D ARRAY_SIZE(rf_vals_3x);
> > -             spec->channels =3D rf_vals_3x;
> > +             num_channels =3D ARRAY_SIZE(rf_vals_3x);
> > +             channels =3D rf_vals_3x;
> >               break;
> >
> >       case RF3853:
> > -             spec->num_channels =3D ARRAY_SIZE(rf_vals_3853);
> > -             spec->channels =3D rf_vals_3853;
> > +             num_channels =3D ARRAY_SIZE(rf_vals_3853);
> > +             channels =3D rf_vals_3853;
> >               break;
> >
> >       case RF5592:
> >               reg =3D rt2800_register_read(rt2x00dev, MAC_DEBUG_INDEX);
> >               if (rt2x00_get_field32(reg, MAC_DEBUG_INDEX_XTAL)) {
> > -                     spec->num_channels =3D ARRAY_SIZE(rf_vals_5592_xt=
al40);
> > -                     spec->channels =3D rf_vals_5592_xtal40;
> > +                     num_channels =3D ARRAY_SIZE(rf_vals_5592_xtal40);
> > +                     channels =3D rf_vals_5592_xtal40;
> >               } else {
> > -                     spec->num_channels =3D ARRAY_SIZE(rf_vals_5592_xt=
al20);
> > -                     spec->channels =3D rf_vals_5592_xtal20;
> > +                     num_channels =3D ARRAY_SIZE(rf_vals_5592_xtal20);
> > +                     channels =3D rf_vals_5592_xtal20;
> >               }
> >               break;
> >       }
> >
> > -     if (WARN_ON_ONCE(!spec->channels))
> > +     if (WARN_ON_ONCE(!channels))
> >               return -ENODEV;
> >
> > +     spec =3D kzalloc_flex(*spec, channels_info, num_channels);
> > +     if (!spec)
> > +             return -ENOMEM;
> > +
> > +     spec->num_channels =3D num_channels;
> > +     spec->channels =3D channels;
> > +     spec->supported_rates =3D SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
> > +
> >       spec->supported_bands =3D SUPPORT_BAND_2GHZ;
> >       if (spec->num_channels > 14)
> >               spec->supported_bands |=3D SUPPORT_BAND_5GHZ;
> > @@ -11959,19 +11967,13 @@ static int rt2800_probe_hw_mode(struct rt2x00=
_dev *rt2x00dev)
> >       /*
> >        * Create channel information and survey arrays
> >        */
> > -     info =3D kzalloc_objs(*info, spec->num_channels);
> > -     if (!info)
> > -             return -ENOMEM;
> > -
> >       rt2x00dev->chan_survey =3D
> >               kzalloc_objs(struct rt2x00_chan_survey, spec->num_channel=
s);
> >       if (!rt2x00dev->chan_survey) {
> > -             kfree(info);
> > +             kfree(spec);
> >               return -ENOMEM;
> >       }
> >
> > -     spec->channels_info =3D info;
> > -
> >       default_power1 =3D rt2800_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_B=
G1);
> >       default_power2 =3D rt2800_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_B=
G2);
> >
> > @@ -11982,10 +11984,11 @@ static int rt2800_probe_hw_mode(struct rt2x00=
_dev *rt2x00dev)
> >               default_power3 =3D NULL;
> >
> >       for (i =3D 0; i < 14; i++) {
> > -             info[i].default_power1 =3D default_power1[i];
> > -             info[i].default_power2 =3D default_power2[i];
> > +             info =3D &spec->channels_info[i];
> > +             info->default_power1 =3D default_power1[i];
> > +             info->default_power2 =3D default_power2[i];
> >               if (default_power3)
> > -                     info[i].default_power3 =3D default_power3[i];
> > +                     info->default_power3 =3D default_power3[i];
> >       }
> >
> >       if (spec->num_channels > 14) {
> > @@ -12002,10 +12005,11 @@ static int rt2800_probe_hw_mode(struct rt2x00=
_dev *rt2x00dev)
> >                       default_power3 =3D NULL;
> >
> >               for (i =3D 14; i < spec->num_channels; i++) {
> > -                     info[i].default_power1 =3D default_power1[i - 14]=
;
> > -                     info[i].default_power2 =3D default_power2[i - 14]=
;
> > +                     info =3D &spec->channels_info[i];
> > +                     info->default_power1 =3D default_power1[i - 14];
> > +                     info->default_power2 =3D default_power2[i - 14];
> >                       if (default_power3)
> > -                             info[i].default_power3 =3D default_power3=
[i - 14];
> > +                             info->default_power3 =3D default_power3[i=
 - 14];
> >               }
> >       }
> >
> > @@ -12033,6 +12037,8 @@ static int rt2800_probe_hw_mode(struct rt2x00_d=
ev *rt2x00dev)
> >               break;
> >       }
> >
> > +     rt2x00dev->spec =3D spec;
> > +
> >       return 0;
> >  }
> >
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/=
wireless/ralink/rt2x00/rt2x00.h
> > index 7d313e86d3f2..babc04210a65 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> > @@ -404,9 +404,9 @@ struct hw_mode_spec {
> >
> >       unsigned int num_channels;
> >       const struct rf_channel *channels;
> > -     const struct channel_info *channels_info;
> >
> >       struct ieee80211_sta_ht_cap ht;
> > +     struct channel_info channels_info[] __counted_by(num_channels);
> >  };
> >
> >  /*
> > @@ -802,7 +802,7 @@ struct rt2x00_dev {
> >       /*
> >        * hw capability specifications.
> >        */
> > -     struct hw_mode_spec spec;
> > +     struct hw_mode_spec *spec;
> >
> >       /*
> >        * This is the default TX/RX antenna setup as indicated
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00config.c b/driver=
s/net/wireless/ralink/rt2x00/rt2x00config.c
> > index f895f560a185..b97cb67c4361 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2x00config.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00config.c
> > @@ -165,7 +165,7 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt=
2x00dev,
> >  static u16 rt2x00ht_center_channel(struct rt2x00_dev *rt2x00dev,
> >                                  struct ieee80211_conf *conf)
> >  {
> > -     struct hw_mode_spec *spec =3D &rt2x00dev->spec;
> > +     struct hw_mode_spec *spec =3D rt2x00dev->spec;
> >       int center_channel;
> >       u16 i;
> >
> > @@ -194,6 +194,7 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
> >                     struct ieee80211_conf *conf,
> >                     unsigned int ieee80211_flags)
> >  {
> > +     struct hw_mode_spec *spec =3D rt2x00dev->spec;
> >       struct rt2x00lib_conf libconf;
> >       u16 hw_value;
> >       u16 autowake_timeout;
> > @@ -218,13 +219,8 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev=
,
> >                       hw_value =3D conf->chandef.chan->hw_value;
> >               }
> >
> > -             memcpy(&libconf.rf,
> > -                    &rt2x00dev->spec.channels[hw_value],
> > -                    sizeof(libconf.rf));
> > -
> > -             memcpy(&libconf.channel,
> > -                    &rt2x00dev->spec.channels_info[hw_value],
> > -                    sizeof(libconf.channel));
> > +             memcpy(&libconf.rf, &spec->channels[hw_value], sizeof(lib=
conf.rf));
> > +             memcpy(&libconf.channel, &spec->channels_info[hw_value], =
sizeof(libconf.channel));
> >
> >               /* Used for VCO periodic calibration */
> >               rt2x00dev->rf_channel =3D libconf.rf.channel;
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/n=
et/wireless/ralink/rt2x00/rt2x00dev.c
> > index edc1f8eac747..3ffbc8aabbae 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> > @@ -1097,7 +1097,7 @@ static void rt2x00lib_remove_hw(struct rt2x00_dev=
 *rt2x00dev)
> >               rt2x00dev->hw->wiphy->bands[NL80211_BAND_5GHZ] =3D NULL;
> >       }
> >
> > -     kfree(rt2x00dev->spec.channels_info);
> > +     kfree(rt2x00dev->spec);
> >       kfree(rt2x00dev->chan_survey);
> >  }
> >
> > @@ -1116,7 +1116,7 @@ static const struct ieee80211_tpt_blink rt2x00_tp=
t_blink[] =3D {
> >
> >  static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
> >  {
> > -     struct hw_mode_spec *spec =3D &rt2x00dev->spec;
> > +     struct hw_mode_spec *spec =3D rt2x00dev->spec;
> >       int status;
> >
> >       if (test_bit(DEVICE_STATE_REGISTERED_HW, &rt2x00dev->flags))
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net=
/wireless/ralink/rt2x00/rt61pci.c
> > index 79e1fd0a1fbd..479825f8bba9 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
> > @@ -2654,7 +2654,10 @@ static const struct rf_channel rf_vals_seq[] =3D=
 {
> >
> >  static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
> >  {
> > -     struct hw_mode_spec *spec =3D &rt2x00dev->spec;
> > +     const struct rf_channel *channels;
> > +     unsigned int num_channels =3D 0;
> > +     unsigned int supported_bands;
> > +     struct hw_mode_spec *spec;
> >       struct channel_info *info;
> >       u8 *tx_power;
> >       unsigned int i;
> > @@ -2693,46 +2696,51 @@ static int rt61pci_probe_hw_mode(struct rt2x00_=
dev *rt2x00dev)
> >       /*
> >        * Initialize hw_mode information.
> >        */
> > -     spec->supported_bands =3D SUPPORT_BAND_2GHZ;
> > -     spec->supported_rates =3D SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
> > +     supported_bands =3D SUPPORT_BAND_2GHZ;
> >
> >       if (!rt2x00_has_cap_rf_sequence(rt2x00dev)) {
> > -             spec->num_channels =3D 14;
> > -             spec->channels =3D rf_vals_noseq;
> > +             num_channels =3D 14;
> > +             channels =3D rf_vals_noseq;
> >       } else {
> > -             spec->num_channels =3D 14;
> > -             spec->channels =3D rf_vals_seq;
> > +             num_channels =3D 14;
> > +             channels =3D rf_vals_seq;
> >       }
> >
> >       if (rt2x00_rf(rt2x00dev, RF5225) || rt2x00_rf(rt2x00dev, RF5325))=
 {
> > -             spec->supported_bands |=3D SUPPORT_BAND_5GHZ;
> > -             spec->num_channels =3D ARRAY_SIZE(rf_vals_seq);
> > +             supported_bands |=3D SUPPORT_BAND_5GHZ;
> > +             num_channels =3D ARRAY_SIZE(rf_vals_seq);
> >       }
> >
> >       /*
> >        * Create channel information array
> >        */
> > -     info =3D kzalloc_objs(*info, spec->num_channels);
> > -     if (!info)
> > +     spec =3D kzalloc_flex(*spec, channels_info, num_channels);
> > +     if (!spec)
> >               return -ENOMEM;
> >
> > -     spec->channels_info =3D info;
> > +     spec->num_channels =3D num_channels;
> > +     spec->channels =3D channels;
> > +     spec->supported_bands =3D supported_bands;
> > +     spec->supported_rates =3D SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
> >
> >       tx_power =3D rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_G_START=
);
> >       for (i =3D 0; i < 14; i++) {
> > -             info[i].max_power =3D MAX_TXPOWER;
> > -             info[i].default_power1 =3D TXPOWER_FROM_DEV(tx_power[i]);
> > +             info =3D &spec->channels_info[i];
> > +             info->max_power =3D MAX_TXPOWER;
> > +             info->default_power1 =3D TXPOWER_FROM_DEV(tx_power[i]);
> >       }
> >
> >       if (spec->num_channels > 14) {
> >               tx_power =3D rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER=
_A_START);
> >               for (i =3D 14; i < spec->num_channels; i++) {
> > -                     info[i].max_power =3D MAX_TXPOWER;
> > -                     info[i].default_power1 =3D
> > -                                     TXPOWER_FROM_DEV(tx_power[i - 14]=
);
> > +                     info =3D &spec->channels_info[i];
> > +                     info->max_power =3D MAX_TXPOWER;
> > +                     info->default_power1 =3D TXPOWER_FROM_DEV(tx_powe=
r[i - 14]);
> >               }
> >       }
> >
> > +     rt2x00dev->spec =3D spec;
> > +
> >       return 0;
> >  }
> >
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt73usb.c b/drivers/net=
/wireless/ralink/rt2x00/rt73usb.c
> > index d6b7174d087a..17338378329b 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt73usb.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
> > @@ -2088,7 +2088,10 @@ static const struct rf_channel rf_vals_5225_2527=
[] =3D {
> >
> >  static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
> >  {
> > -     struct hw_mode_spec *spec =3D &rt2x00dev->spec;
> > +     const struct rf_channel *channels;
> > +     unsigned int num_channels =3D 0;
> > +     unsigned int supported_bands;
> > +     struct hw_mode_spec *spec;
> >       struct channel_info *info;
> >       u8 *tx_power;
> >       unsigned int i;
> > @@ -2114,49 +2117,54 @@ static int rt73usb_probe_hw_mode(struct rt2x00_=
dev *rt2x00dev)
> >       /*
> >        * Initialize hw_mode information.
> >        */
> > -     spec->supported_bands =3D SUPPORT_BAND_2GHZ;
> > -     spec->supported_rates =3D SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
> > +     supported_bands =3D SUPPORT_BAND_2GHZ;
> >
> >       if (rt2x00_rf(rt2x00dev, RF2528)) {
> > -             spec->num_channels =3D ARRAY_SIZE(rf_vals_bg_2528);
> > -             spec->channels =3D rf_vals_bg_2528;
> > +             num_channels =3D ARRAY_SIZE(rf_vals_bg_2528);
> > +             channels =3D rf_vals_bg_2528;
> >       } else if (rt2x00_rf(rt2x00dev, RF5226)) {
> > -             spec->supported_bands |=3D SUPPORT_BAND_5GHZ;
> > -             spec->num_channels =3D ARRAY_SIZE(rf_vals_5226);
> > -             spec->channels =3D rf_vals_5226;
> > +             supported_bands |=3D SUPPORT_BAND_5GHZ;
> > +             num_channels =3D ARRAY_SIZE(rf_vals_5226);
> > +             channels =3D rf_vals_5226;
> >       } else if (rt2x00_rf(rt2x00dev, RF2527)) {
> > -             spec->num_channels =3D 14;
> > -             spec->channels =3D rf_vals_5225_2527;
> > +             num_channels =3D 14;
> > +             channels =3D rf_vals_5225_2527;
> >       } else if (rt2x00_rf(rt2x00dev, RF5225)) {
> > -             spec->supported_bands |=3D SUPPORT_BAND_5GHZ;
> > -             spec->num_channels =3D ARRAY_SIZE(rf_vals_5225_2527);
> > -             spec->channels =3D rf_vals_5225_2527;
> > +             supported_bands |=3D SUPPORT_BAND_5GHZ;
> > +             num_channels =3D ARRAY_SIZE(rf_vals_5225_2527);
> > +             channels =3D rf_vals_5225_2527;
> >       }
> >
> >       /*
> >        * Create channel information array
> >        */
> > -     info =3D kzalloc_objs(*info, spec->num_channels);
> > -     if (!info)
> > +     spec =3D kzalloc_flex(*spec, channels_info, num_channels);
> > +     if (!spec)
> >               return -ENOMEM;
> >
> > -     spec->channels_info =3D info;
> > +     spec->num_channels =3D num_channels;
> > +     spec->channels =3D channels;
> > +     spec->supported_bands =3D supported_bands;
> > +     spec->supported_rates =3D SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
> >
> >       tx_power =3D rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_G_START=
);
> >       for (i =3D 0; i < 14; i++) {
> > -             info[i].max_power =3D MAX_TXPOWER;
> > -             info[i].default_power1 =3D TXPOWER_FROM_DEV(tx_power[i]);
> > +             info =3D &spec->channels_info[i];
> > +             info->max_power =3D MAX_TXPOWER;
> > +             info->default_power1 =3D TXPOWER_FROM_DEV(tx_power[i]);
> >       }
> >
> >       if (spec->num_channels > 14) {
> >               tx_power =3D rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER=
_A_START);
> >               for (i =3D 14; i < spec->num_channels; i++) {
> > -                     info[i].max_power =3D MAX_TXPOWER;
> > -                     info[i].default_power1 =3D
> > -                                     TXPOWER_FROM_DEV(tx_power[i - 14]=
);
> > +                     info =3D &spec->channels_info[i];
> > +                     info->max_power =3D MAX_TXPOWER;
> > +                     info->default_power1 =3D TXPOWER_FROM_DEV(tx_powe=
r[i - 14]);
> >               }
> >       }
> >
> > +     rt2x00dev->spec =3D spec;
> > +
> >       return 0;
> >  }
> >
> > --
> > 2.54.0
> >
