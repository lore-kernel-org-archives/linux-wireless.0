Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793767969;
	b=1kOAozwLjYXY6r/v2ND7RxbS4qmK8eHSydt8K7cWqSYBLvCDUNwa5CYPYiHnLtyF8281
	 FmupokbzWs9FSoWvOgCRxAmjyXlEyWO9CaPcb6so7X2W/wslOb0fyD03RvXKPYpLuFXkz
	 5uT0qMpwGNSsq3QFYL8xe7+GGy/khUYtHY3xkfQFkdolpqWkJqoIDVxpFkMRtTSyhdB07
	 WVzD+MtnGzFcHjltn4YL8AJ32egD0J5e6/8cRkLv5WW2yhWXRbuqgfEWE8cPB0X7rmZvq
	 CewtSuG4hB+Df4yg9ITNcW3vVayE6Giq9eCR9dEyWcTwdVbsZepPTApxSaLUgddMM5Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793767969;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=pFoH3xvN9EWBbrUcPIA3qDP5aom6jOQyZeF4FVw6u6w=;
	b=zlW91kiQ0E2aAFCWcVCcTnlc7HmDbshajwqrNMU824KuKsIUefiS3redHj5ENyW06N6b
	 vz43VTRDt+R4UKqLsT9NHahoVh2LsR0vUjRiNcnuC5NiPXcbD+qge90thS5vctq8tZ8Sy
	 UQA52esXnISiuzaNcYDQrIdQ0jgAwA0HjfuYaFUiVfRvNU/uXJTGPtx64il81vNlRhG+n
	 OCLROWnS5qJQzzOiWu1eEFUxPawdelEbCoApNu2Z2RnLxVxCCcqM3PffNcGFLQ20Qbgfc
	 RtEQ0fjr+3LMBDfThGq5WrPr6+tAuqqr/MJw78hGBy/8LbFqf7rCEolH8nvmQD4BHrA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aiRLH7pr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AC7606A32D
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 04:52:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81AC7606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aiRLH7pr
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c450ab1483cso43747866b.3
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 20:52:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793767968; cv=none;
        d=google.com; s=arc-20260327;
        b=cj1kE2i+0dEv03X7Zd419Vwq/FAOaG/ygF0RLxE7xKJRQxUvTMKkqLLtu8uCLtsF9+
         sPNbWd6YfwqU9eL4JJQjAUE7Vu3Op6pS0M90VrtJ9P/EwR3IcNMak6A/LWe+K5MXhs9K
         aov53cE7szPv4lwNtu/2H9gKk8UYCjbTxsCwMHAkUDrgHLE6hLiZp5H41j0IdMWgn1JC
         AVcLJilmgBcOcs9UA81QSYzXXtrf90k5n7SxoOTkbouQuhjPOYLsE5//E9OQKHo/Kl+t
         EyfNSm+g+c2mjRTCCleWFsyptjSIYOd/Bl1WY9TUuBJOpSf5HqBhMnc6QrNz3B38jWKz
         YtKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pFoH3xvN9EWBbrUcPIA3qDP5aom6jOQyZeF4FVw6u6w=;
        fh=tA/qOmjbHMAFsRsDEhDLXK2o0U0MdkZ/FQgef05ZCVc=;
        b=WzGihY7buD85CYtamLhToujU7HE8j7IfKiVVs0D5KkErV/BolEQk71Jb9shWfhjHVZ
         9D0w2Sev+9KMapThPdi6YqWU91dLUlsu1L0tHL5gJrG2TOyaUftn7TkKi2wBgEuz15lD
         c0meSgrW/zBr/Zz/U/tJjzuiYd7PgmYvoGeGMt0Ul61gmTB/kQgTrFscIgRpxqoe7ECT
         2mrcWJMsGiT4rhS3WV1BOVKJvXmAdqXv15GXFXWcYqMAa3k/7e5RgLB74S7FgQKFN/lu
         9nIwcKLScHphmG8ohX+qt8Hi6o8AdkJ273acVr0SFIA0x86y/XAxX8n6NIDRNzLcsEMK
         taaA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793767968; x=1794372768; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pFoH3xvN9EWBbrUcPIA3qDP5aom6jOQyZeF4FVw6u6w=;
        b=aiRLH7prZ4+gVrvOk5uBmzvbOq6/s+Sl1DQtGkGd+kW6YdlzA84iI56Z04BS8bIrtf
         +K4nk9U+6N03dxsTecuheaSE0EJ7/BoY/bWjqB2ZLIunjG00BsU6ITNCkyoPfvnsoCB4
         h6WlUZy1/WudE4DUlKC6qRUcZfTwj4nmnl+URpsfv4Qrmm8KxiJNq/YAnsCeHnlFM0xC
         +LLa2BH+NQn1hJQVnAndjjwbq0gRawOPU7m2qBvzkv10DQ3mpJSzoZfb8kxPE9Q2FDaF
         c0mwBVBhvYUa8GBmQIH47uaKc1/Lx+CsIm1cEdVXJE7wyZlDE210owyNtZ8zRgkTBP/P
         Bauw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793767968; x=1794372768;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pFoH3xvN9EWBbrUcPIA3qDP5aom6jOQyZeF4FVw6u6w=;
        b=2qxzIaauXC0H9A6lZsTcla9mCNc2eKBfS6IhHh6iWdPtLB/dad96OqGydqdOZ8DrTa
         ik5YjNlHNNJ93lsjzeOGn7qeJrHbCFW5c4Wlmtga+cJRehuaBEUlH/sB8BOb4d5Rr73/
         IOixjcKvpAjmEAvZpmTOwdx7lJcUfJHqqvjhcTTr4RnNiuyUTYDEOeeUbLSYpB8SCcf8
         KZeXhF7TGaVeFoS9C8NecWYG6tvd97qkxQYGzaKbGvr9U9mIF5dpa9942j9hOf3jFDVW
         nAcM9YSkVvfwSMDMIgkM7bpRkH61LXmUSG9Idy/mbf+GuXOxJHjHe5Oh8UpsC80AJJmM
         USJQ==
X-Gm-Message-State: APuU4Z81HrWlMDhusALEVNKrIl4w4THV078L8r56rAj3sLFEc+QZdZWd
	hg3r8lEDcj5NkZRyw6zMiFwd8E5JJdS3Tkr7/SuiXa320NN0MnqXCT8NAnQXe1Q7P8va2dG+mEX
	dw/BKkpGig9e+xMOn0nTA3n0qHFnLSUI=
X-Gm-Gg: AYBFou1o2Ef3KF0pIiWNNbMbMMGibWa4pl6k698c36eA4uCscQFe8O9NL16YUduzfM0
	CHR8W5wZenxZM1LdNDL5TdxG0jpQswgyTMK6Lh4Vu+t6wRjav8Yz+lRVhnOojhfzuKZDIv+nn+t
	SAeDiM+lndVtmDyf/8jwPtE/+tYG+lEDEbA2ffLt1XFPDfJF9mYnKp57oVZHq1EZ+SeQb0PCo2n
	6Byy0TLY3MBePm8ZRCi3zQrU+WrcG51O+6XELG9pexGUNxZgHhCeKyBPL7lw0tQAzQqPf8owYIK
	jcnaLpllb57poBzFw2dkzRJgLKD92xGtP9H6w0b6u85un0AOsedKDViBfRWToNJ5W9a8wDUfymI
	qCzjWB4cVMdq6E256esiQB64glm0FxCR3b52xKPtixH5nT3qgYyJXSI1mmtE3dwuguE+2GWLCkZ
	9VgoL08zgmMTSBEZo1T7zyDoYFyPVwoQc0Anlqq3hFxBpHEyAY7pdbr73F2Lr/1TFdnDfQv+kbe
	DDGMJq7eMdmf4OFm6PDTu2mlWnkG9jd1h3yLmGh5wK3NdzqQQ==
X-Received: by 2002:a17:906:f5a1:b0:c41:6de7:7dee with SMTP id
 a640c23a62f3a-c4ca7949b3dmr1198860166b.7.1793767967575; Tue, 03 Nov 2026
 20:52:47 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261103215557.183459-1-rosenp@gmail.com> <a5f044a803a64a1eb68815f075bda2ee@realtek.com>
In-Reply-To: <a5f044a803a64a1eb68815f075bda2ee@realtek.com>
From: Rosen Penev <rosenp@gmail.com>
Date: Tue, 3 Nov 2026 20:52:36 -0800
X-Gm-Features: AclHuK-PgB-kCA1qvvR-AVgXtcHeHVRUwBypOKy-ZNzFoSBd052ve_9ylaFIDM4
Message-ID: <CAKxU2N9OpxoKF6M5rJpNOJ1HWXx8oJ3wXHpfyGGVgQpZaMi+uA@mail.gmail.com>
Subject: Re: [PATCH rtw-next v2] wifi: rtw89: acpi: check for _DSM function
 support before evaluating it
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2026 at 4:47=E2=80=AFPM Ping-Ke Shih <pkshih@realtek.com> wr=
ote:
>
> Rosen Penev <rosenp@gmail.com> wrote:
> > When the WiFi device has no ACPI companion, or the firmware does not
> > implement a given rtw89 _DSM function, rtw89_acpi_evaluate_dsm() calls
> > acpi_evaluate_dsm() anyway. ACPI core then warns on every probe:
> >
> >   ACPI: \: failed to evaluate _DSM e8c3a8d2-694b-004f-82bd-fe8607803aa7=
 rev:0 func:10 (0x1001)
> >   ACPI: \: failed to evaluate _DSM e8c3a8d2-694b-004f-82bd-fe8607803aa7=
 rev:0 func:6 (0x1001)
> >
> > Here the handle is NULL, and acpi_evaluate_object() returns
> > AE_BAD_PARAMETER. All callers already treat failure as "no policy
> > provided by the platform", so this is only noise.
> >
> > Bail out early when there is no ACPI handle, as acpi_check_dsm() would
> > otherwise hit the same warning while querying function 0. Then use
> > acpi_check_dsm() so that functions the firmware does not advertise fail
> > quietly at debug level, as rtw89_acpi_evaluate_method() already does.
>
> Adding this check is fine to me. But my question in v1 is that
> acpi_check_dsm() checks func 0 to determine if BIT(func) is existing.
> Is it possible func 0 not existing, but BIT(func) existing?
Shouldn't happen, but who knows.  I can drop the acpi_check_dsm() part.

7bf2dfccc2dd70821104d15cbab7b6fca21872be

is effectively the same as this.

Note that this specific card was taken out of a laptop and placed in a
desktop, hence the warning.
>
> >
> > Seen on an RTL8852BE in a desktop PCIe slot.
> >
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> > ---
> >  v2: check handle separately. Remove Fixes.
> >  drivers/net/wireless/realtek/rtw89/acpi.c | 15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/wireless/realtek/rtw89/acpi.c b/drivers/net/wi=
reless/realtek/rtw89/acpi.c
> > index ebb6cf555747..3396d42594b3 100644
> > --- a/drivers/net/wireless/realtek/rtw89/acpi.c
> > +++ b/drivers/net/wireless/realtek/rtw89/acpi.c
> > @@ -372,11 +372,22 @@ int rtw89_acpi_evaluate_dsm(struct rtw89_dev *rtw=
dev,
> >                             enum rtw89_acpi_dsm_func func,
> >                             struct rtw89_acpi_dsm_result *res)
> >  {
> > +       acpi_handle handle =3D ACPI_HANDLE(rtwdev->dev);
> >         union acpi_object *obj;
> >         int ret;
> >
> > -       obj =3D acpi_evaluate_dsm(ACPI_HANDLE(rtwdev->dev), &rtw89_guid=
,
> > -                               0, func, NULL);
> > +       if (!handle) {
> > +               rtw89_debug(rtwdev, RTW89_DBG_ACPI, "acpi dsm no handle=
\n");
> > +               return -ENODEV;
> > +       }
> > +
> > +       if (!acpi_check_dsm(handle, &rtw89_guid, 0, BIT(func))) {
> > +               rtw89_debug(rtwdev, RTW89_DBG_ACPI,
> > +                           "acpi dsm func %d not supported\n", func);
> > +               return -ENOENT;
> > +       }
> > +
> > +       obj =3D acpi_evaluate_dsm(handle, &rtw89_guid, 0, func, NULL);
> >         if (!obj) {
> >                 rtw89_debug(rtwdev, RTW89_DBG_ACPI,
> >                             "acpi dsm fail to evaluate func: %d\n", fun=
c);
> > --
> > 2.56.0
>
