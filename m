Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AC822157B
	for <linux-wireless@vger.kernel.org>; Sat,  8 Aug 2026 00:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786147224; cv=pass; b=c+J2HAWMO92YEk3FruiXjEukkJ/30vFYFbrKJLCBC0ZY2TdxYW6nlOWayDZ9+x55ZIQhik4DhL0nXkit37aDHCWQVh3j6P8QmMbQO1onmt+5Tmb3/ceJtboJwgHKNkisBED3lNcCNI9a6g1x8L0TVT4B0P2KUCb0yACSRR/nsc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786147224; c=relaxed/simple;
	bh=UdR7ZTFIL3V+BnNVq1UDIT4zKuWlbCjD0STBKjhwyC8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nM+ol6gPWoB4u3R7tXZM9DLrLPz1tdLYHNfvqQCve/uNhAAB23teNE4z2JxkPdmITFpianCtX0IU9nsDMBNaq+zi/90poAGEQY2EKECuf2VJIhXJpTQW8pQNYgO564ssSwCqsOXwZ2ZaR4KfLt996AdcdQlzRGZGj9/wUdt7zLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PWW25m0E; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PWW25m0E"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a18ef236ecso7491a12.2
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2026 17:00:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786147221; cv=none;
        d=google.com; s=arc-20260327;
        b=ms5npX3Cr2GN724CZkGUHhA9uedJ1wO84ulbjl70Hl8NSunmfuj0h+kz0tvEeEubZg
         r5xxf2qNdcn1bqm0pS2FoOeFvZeZkn79zMZuuCkQpE8+eDr/aRsnkvWBYkpz3p/G1Hmw
         65KIUa5Ga3UM+w9M+k9FANb1SdLNNR/m+4baKXq7ZcGFCxjielF68+9A78c9WTuGLiZS
         b1sDon4aLhqXqYplwSIDXYFqSlYcS4Iu7DSnDqRPzVBGxo5cPOQ+rBg6wWPrNK3PSc7A
         74Onj/p9BCYeuZT4qoybySD2mrqcWk2OozEj24GgDR4Pyu9+wYhMakSuCRQd7XDN/e+U
         Ak2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v8ZBSWIPrWKHHCg3jurXTVoAiywt7j3Be5iKukh07Cs=;
        fh=ZS1PzuDaSBRrfUbFIp52DxpIM6r9UAGY66vTeJXmclM=;
        b=Z96FLRDInJgY1hA+I8N2UYwifCgDunauqzIDClfBR70fOdG+B1/U5zr6fMdxNmXHhA
         VeuctZCEd95KfWyQCS24Y3Y3y9seG6L6W0rk97H0ren6YV/zlDJHJ/KU9vl2a+0casqx
         bro6fa0QSrfLc9MGwcoNPhomShXh2p999ZH+WSPcYhwszlPMgVYWegfXMU07zNeOJirU
         JuF8/z2GF4JEgAi+uvwG/qtm893/W7b+iwSFq44If8UscvdfS/VqTCaw4yhTh02kMkE1
         rpHO8GJEG2B8krqHge4TyixP9Whs2o7Hro19usbQnNllvHX+5dRaCXigj1s1tYQcmBJ3
         V8qg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786147221; x=1786752021; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v8ZBSWIPrWKHHCg3jurXTVoAiywt7j3Be5iKukh07Cs=;
        b=PWW25m0ECv5b+Id9VOVf0DA3DA+YziO8c308WlxIApCuUPgzm3eto5gv6jMxEf/0wr
         eZo5kkJQ19koMvI8W6H5Whrf/vdugIZiar1doHiJ6y0Xwr5dlaC8OkV7R+Q7cjvukesU
         5+8L7DmYjG19XiD8gM7TsN9C8BmWCjGyAAlvJ9OxhfyqJOjB3o+ciAvwLMLIteWPX6b5
         Op9kvvJemdK8LR29DCTaN69TSUth5gTixx0MVCz+g7TBDa3CtWyrU9CSiqELL3tqU1S9
         AzRFHr0MkEU51zy1kKssxNXCiyJO+wrKdDA5V6islR+ySeu8bGCizqc8pNevaf2DWhUN
         9OXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786147221; x=1786752021;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v8ZBSWIPrWKHHCg3jurXTVoAiywt7j3Be5iKukh07Cs=;
        b=En59uG99kN6TkeoUEsSauIB3cWnxnM0T8AVDzwNrVW1HzM9tuS7JFEJCqossYTQKqA
         1EQb7Cu48xfJlqO6YNHS9myP98zsPKFMZrmpMexyJN73JHjp/Vr58RNk/1vtbDj8mBXl
         L2CsNgFtT1bXJkuXcIv77J5Xg+cn8cuJw7xu5w59LUmPQpryPbotAjKvxoNQtKVqkJyr
         eVT9O1z95EQQrk2A/Sgp9xY9cexWRzoyQWxGZoE+qCdhglSmNWL9SB0tZKDsMW804VrB
         k6W2hXFHrLxvqi0iESb8PptVDyKvXEf/GTW86Z/f9RfKaHlY2Cz3CBBPBSZweyTysmdW
         HBTw==
X-Gm-Message-State: AOJu0Yxep/pLmXgNZOC6sn6SFwKOzI3Wn9MPEw/3wtyrzTvc+HoPTDsY
	evoniyVTZ2i8w9NjMHUWo7np91MFZ3anKVHleYZsJZYDjY3pM64SKmITQ6H0nrZtzxyQL2Nlxvz
	5E/1fxwikf+ibqMGVdxr33DemTGt/pbs=
X-Gm-Gg: AR+sD11xyvAlMUOw3GYOajka25w1llx0a5oj64VVfKY8i4YeURRzZAF/jwyJL1u517H
	ZC1k/bTw21Z8bLcjYUJftVJRDG4LMIfOv6T/Un08hvGTjHnNApinsmR+xcaqOWERh4MaCq6F99P
	BRpKnwOe7TYlh7o1pAGYNGwtQhYSRM0fxMdi/qIWODS0m/nnbM4bKlgfgGZZWxuz5cvVHV8kfZ+
	MUcZAUcTaMQSu/yHK9BmKFqh7yqdCjbgBwCNriE2uvq8mFxqgqpCP00VozOcZmWNaJlMi/VvCTX
	rXDj3Oa3LzpEmSXGBkCuo2j2+NHmSE2uEs03m3D8qYvzUh0kpZjrPRxosLvhG41NrjD09vx/XYu
	nFeZwS0l9mRAC4LP7PilTeaD2+o/l51IAqjc8O+UVcbQ=
X-Received: by 2002:a05:6402:28cb:b0:6a1:445f:1f3 with SMTP id
 4fb4d7f45d1cf-6a14f28502cmr6315290a12.4.1786147221307; Fri, 07 Aug 2026
 17:00:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260729053408.13715-1-bogdan.nicolae@gmail.com> <20260802083905.3819981-8-arend.vanspriel@broadcom.com>
In-Reply-To: <20260802083905.3819981-8-arend.vanspriel@broadcom.com>
From: Bogdan Nicolae <bogdan.nicolae@gmail.com>
Date: Fri, 7 Aug 2026 18:56:26 -0500
X-Gm-Features: AUfX_mzX12CQEWUDSZdNypV-f9oJzIXa5Pzlcmj9Okz8ULUQ91VkoAyJ9BvBYCo
Message-ID: <CA+ORkNSS1dOdUK51B0Q1r2Htc5NpP-=EmE4FO6=4rX5CUU_FpA@mail.gmail.com>
Subject: Re: [PATCH] wifi: brcmfmac: configure SAE PWE method for external SAE AP
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev, 
	brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org, 
	Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Gokul (representing Infineon) promised he would send a patch a while back.
This would be a preferred solution as it comes directly from the vendor.
But it also takes time. I can send a revised patch next week.

Regards,
Bogdan

On Sun, Aug 2, 2026 at 3:39=E2=80=AFAM Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
> On Wed, 29 Jul 2026 00:34:08 -0500, Bogdan Nicolae wrote:
> > When bringing up a WPA3-SAE SoftAP with external (user space) SAE, the
> > driver never told the firmware which SAE Password Element (PWE) method =
to
> > accept. The firmware was observed to corrupt its heap over time due to
> > this omission, leading to firmware trap (data abort in heap allocator).
> >
> > Parse the beacon IEs on start_ap() and set the extsae_pwe iovar
> > accordingly: 2 when the RSNX IE advertises H2E, 1 when an H2E-only
> > membership selector is present, 0 otherwise. This matches the behaviour
> > of the upstream/vendor driver and only applies to SAE-capable APs when
> > external SAE is supported.
> >
> > Signed-off-by: Bogdan Nicolae <bogdan.nicolae@gmail.com>
> > ---
> >  .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 75 +++++++++++++++++++
> >  1 file changed, 75 insertions(+)
>
> As discussed the extsae_pwe iovar is vendor specific so the fix needs to
> be gated on the CYW vendor. The cleanest approach would be to add a fwvid
> hook (following the pattern of set_sae_password in brcmfmac/cyw/) so
> brcmf_parse_configure_sae_pwe() is only invoked for CYW chipsets.
>
> [...]
>
> > +#define BSS_MEMBERSHIP_SELECTOR_SAE_H2E_ONLY 123
>
> This is already defined as BSS_MEMBERSHIP_SELECTOR_SAE_H2E in
> <linux/ieee80211.h>. Please reuse the existing constant.
>
> [...]
>
> Regards,
> Arend
