Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AF72E764D
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 06:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786947470; cv=pass; b=u0vHJS1eUIHPeL/+TysdkS8l6md2b1ULYwrRQxQl3vtYtcsLO7bsheQ5ndaXvRkoqLZYS5tCBy1SSKWb/Jom8Zf4tgzH1vTMRkqiJkzcelvu7R/7NE7K6dJJnf/weRjaU8ewbZl2P8TdiGGIkpfZrmnGRmude5qU18bxT9XpUeE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786947470; c=relaxed/simple;
	bh=q62OUmLM+k48Kge64oBVn4iazSiNJptjiFrp81kytWM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jqMit0HPd1wVOeUVLUq1y/6EkrDGEzYFWV9d+n9IrJcH2xdFB/NvABAnIKEG+jQ948x9mmvH2Hg2SWKddg7POROtRGaGJcUCJmNShj9SKPi3j9TWUwKwplXVmfJz7xCBI0h861FFMhUkemuvf1NvxWLzsJBKZfMyFjOsJmiByms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V+OlC/yE; arc=pass smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V+OlC/yE"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8eeb4508f29so18162706d6.0
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 23:17:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786947465; cv=none;
        d=google.com; s=arc-20260327;
        b=R+4khPS3gwxIGxI0eYrGWHpOK7ZgQ1gb3sET7Sw2tE77EeJAXNZ3GO1LPfQvO+ifoh
         lT/W1702QIEM5D8ld897zBqfknFiuZZGLooxJ4kMr7Uo7bkjGl6cUGsScIwbeh+7taca
         oFfzsj5XzUbPGmVrQABXFldQcxz0XT5+DWP6HFm2jJB6YKFSQAx+vOTbfdEJoPsaZDAC
         x8BcdGT2ceWgMx+NaGHOdxes/dHnVtQ77PuCJD78k+OwGQosjwbKLNGq9JrkWizzKFO+
         vnQQYc9TAK8Iyq8AjJRy2rDXsx22LNum1Ek/n+XaZ3p2uhoKESqxWjlFlHxaywN4b8Wt
         Q93g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ULpKgCJjRO3FeWXvSmkBGFQFV6o2kwMzsT3tVXGHs2c=;
        fh=EEqq1nyX5noIwz+ZeuRwJY5LeYNGO0SH4elp/69PwDE=;
        b=Igfraezvqufg224hhx0vgO+nUZJFSufyyfNM1HsbR8df3wGKJt93GI8DBmWw6O07qS
         e+Z/IqVWuqwzJUlBBxv0cck8pFJGk4nA0OWzrS5HiRYEwYKJoWO5qNCD1CDD+iYNA6g6
         NZ2gBUJ84v8QPSxVR2+C6gs5tZgWexshesDya9RIUo46GNaHSCFz1vIAuF+GyDbcErES
         ZVpMsY1hvpNphIyBYiXyLdblEdwxwTFDkCR+c4Y+poesjBc/Uf4henBRUWajXH9os4Ud
         5RqGZ+pFsOKv5clvZFx53vf6lPstwe/vI0XIVDYlOPDd3sOAcnoW09e3ag3x1A4n0qlx
         8q+Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786947465; x=1787552265; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ULpKgCJjRO3FeWXvSmkBGFQFV6o2kwMzsT3tVXGHs2c=;
        b=V+OlC/yE/OenSLaNlEjZjqh8u6n7NOGg/wHJGfByempBeF4rGWsRvdMUr72E+H9DoN
         IfzMAsWynjRnpD+rd35U85uFky1qQDL5Ctohh8MZ4VHYqWMSfwJD8jfpXn+alNtQXisR
         xyV4+p9GA7gSFSz2A+JvTIU9x6gaOr6K4AcyKOlA3NltFUEi8GfM90I06nFgBtUfAP9Y
         g/eghQNqGjZrCap8zp4ESIteHMRSb/TZbQN2MHOBFJ1uE5q/2XLwjA+QX5+jtcUAnLA6
         RNQzMCfB392lPm1UWNuQWqHEMK7LuDTcSesg443gcfi64eaOeCjgqgmNvAweL7/qQD5I
         ZSKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786947465; x=1787552265;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ULpKgCJjRO3FeWXvSmkBGFQFV6o2kwMzsT3tVXGHs2c=;
        b=bFwxty6/DD+jmIpBpw0JzF2URdyRqtlS01A4ieHjlinnN1Synqi9d6DvlOJ0hit6Hg
         razMxCLH+JqKIH+IEffQE4BvkmgyxCiczKPdbWK+APPIj9sRqq0X++NY5Py9jOmw/sku
         eN5IpbVraMx5o1Un2ODRP8lH6ZyxVdrn/Y09wLkQWqOst27QSZdla7SCzVvreHX2y+ZA
         rUbG/eRpsYsVaxJ8nnDfqIosmzhNYA2cM967FDiR1EVazFXafVuitRUwfrFBwR9sY5S1
         0AIXWM+TIrKDeWFsOa+m1htNHKDK5j5P4I5cwwpMeiBYtA05bREOQxuGdai2cnJjHJ7E
         ZYkw==
X-Gm-Message-State: AOJu0YzKAINPztV0sTT8DH2OTw9vkSd7GAK+VeNnhm5r5HuyCVPDo3j/
	ZSbgHRxinM5OU/1b4oEwSZ+Cev4M3SV9sKmxG3dTPixjd8bXorf4vNwsBhWbmf7kdiTR/VEavn/
	7rdV7ZeBRSdcanV+agfmPEGo1ZghMsTex2Q==
X-Gm-Gg: AR+sD10DbtU8Q0dN8yU4LIaeLvyvV9v+aNy+6N2LrLWagqpio7jXbSCDSzKm0c8Q+N5
	SP7hUrnLgTDtpmRO/D9R4sNISVx7L/OnKiEknahHa03TfcSZTnEDePFISAwcDSuC93E9GzC5Bsv
	x7yu/u4kKyvk7S/8P3CLVg8bBFtlzO9nReIzRWQ61LdidR4kOy0d2IhrxCG/tCZshrGd8f5CJp0
	EgJX8KhppgLumv7dpXuwoqnJqEvj9uQk4IH9WKMIq/8nvUJEM/poLegONpGg8PQb3z/NYiBazOF
	D2rXa23hWgE5AAmsLUwQVdSABFXSl3b5dybAKXWD9JhViA==
X-Received: by 2002:ad4:5ce9:0:b0:8fe:b7a6:4ff3 with SMTP id
 6a1803df08f44-90a91d802c2mr263940006d6.23.1786947465150; Sun, 16 Aug 2026
 23:17:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CABzKGg0YEm5PfW9YtEM0G1SYY6RD80DmFpu_Jpb9hoioK+tH-w@mail.gmail.com>
 <CAGb2v66RnAr_yPhZuuandeoE=wSh9tJMdfqkLLudWKpDmDKc4Q@mail.gmail.com> <CABzKGg2C-kb673u4o9Nk28-bp9ONuQAaDA39x47bJOpq6RrNHg@mail.gmail.com>
In-Reply-To: <CABzKGg2C-kb673u4o9Nk28-bp9ONuQAaDA39x47bJOpq6RrNHg@mail.gmail.com>
From: Morgan Wong <pbodq2@gmail.com>
Date: Mon, 17 Aug 2026 14:17:32 +0800
X-Gm-Features: AcwNN1UGbJOzJrUdN01Ko_-VcJlNKqiySnt1yLlDBveeAaFXktz02q3MfOVLajo
Message-ID: <CABzKGg3-5yE19-_fiBuvaM9CBUnyJ7UYmt6M6w3BrEqu+3Unbw@mail.gmail.com>
Subject: Re: wireless-regdb: Update regulatory rules for Hong Kong (HK) on
 5GHz and 6GHz
To: wens@kernel.org
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear all,

Is there any problem about the patch and the reason? Any regulative
restriction conflict ?

Morgan Wong <pbodq2@gmail.com> =E6=96=BC 2026=E5=B9=B48=E6=9C=884=E6=97=A5=
=E9=80=B1=E4=BA=8C =E4=B8=8B=E5=8D=8810:01=E5=AF=AB=E9=81=93=EF=BC=9A
>
> Dear Tsai,
>
> The patch from git diff is now attached.
>
> I summarize again the changes, please decide.
>
> 1. 30dbm (1W) of TPC condition is applied on 5470-5730.
>
> 2. Now, 320MHz bandwidth can be applied in 6GHz as WIFI 7 rolled out.
>
> Chen-Yu Tsai <wens@kernel.org> =E6=96=BC 2026=E5=B9=B48=E6=9C=884=E6=97=
=A5=E9=80=B1=E4=BA=8C =E4=B8=8B=E5=8D=888:48=E5=AF=AB=E9=81=93=EF=BC=9A
> >
> > On Mon, Aug 3, 2026 at 9:38=E2=80=AFPM Morgan Wong <pbodq2@gmail.com> w=
rote:
> > >
> > > Dear all,
> > >
> > > Currently:
> > >
> > > # Source:
> > > # https://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkca1039.pd=
f
> > > (2.4 GHz and 5 GHz)
> > > # https://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkca1081.pd=
f (6 GHz)
> > > country HK: DFS-ETSI
> > > (2400 - 2483.5 @ 40), (36)
> > > (5150 - 5250 @ 80), (23), AUTO-BW, NO-OUTDOOR
> > > (5250 - 5350 @ 80), (23), DFS, AUTO-BW, NO-OUTDOOR
> > > (5470 - 5730 @ 160), (27), DFS
> > > (5730 - 5850 @ 80), (36)
> > > (5945 - 6425 @ 160), (24), NO-OUTDOOR
> > >
> > >
> > >
> > > Update :
> > >
> > > # Source:
> > > # https://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkca1039.pd=
f
> > > (2.4 GHz and 5 GHz)
> > > # https://www.ecfr.gov/current/title-47/chapter-I/subchapter-A/part-1=
5/subpart-E
> > > (2.4 GHz and 5 GHz)
> > > # https://www.etsi.org/deliver/etsi_en/301800_301899/301893/02.00.07_=
20/en_301893v020007a.pdf
> > > (2.4 GHz and 5 GHz)
> > > # https://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkca1081.pd=
f (6 GHz)
> > > # https://www.etsi.org/deliver/etsi_en/303600_303699/303687/01.00.00_=
20/en_303687v010000a.pdf
> > > (6GHz)
> > > country HK: DFS-ETSI
> > > (2400 - 2483.5 @ 40), (36)
> > > (5150 - 5250 @ 80), (23), AUTO-BW, NO-OUTDOOR
> > > (5250 - 5350 @ 80), (23), DFS, AUTO-BW, NO-OUTDOOR
> > > (5470 - 5730 @ 160), (30), DFS
> > > (5730 - 5850 @ 80), (36)
> > > (5945 - 6425 @ 320), (23), NO-OUTDOOR
> >
> > Please do a proper patch or at least diff. This is hard to spot differe=
nces.
> > And if it's not a patch it's more work.
> >
> > > Reason for change in 5470-5730 :
> > > The HK department, OFCA has its own requirement, 30dbm in addition to
> > > EITHER fulfilling FCC OR ETSI requirement. The rationale behind is
> > > having the biggest tolerance among major world standards to be an
> > > international city. The OFCA, 30dbm is the baseline value to be
> > > fulfilled in the highest priority.
> > >
> > > About FCC
> > > 27dbm (500mW) without TPC, 30dbm (1W) with TPC
> > > # https://www.ecfr.gov/current/title-47/part-15/subpart-E#p-15.407(h)=
(1)
> > >
> > > About UTSI (same as FCC)
> > > 27dbm (500mW) without TPC, 30dbm (1W) with TPC
> > > # https://www.etsi.org/deliver/etsi_en/301800_301899/301893/02.00.07_=
20/en_301893v020007a.pdf
> > > (page 17)
> > >
> > > A TPC (30dbm), 802.11h edition should be taken instead of 27dbm as I =
suggest.
> > > Or a TPC regulation flag may be a good idea to bind with 30dbm togeth=
er.
> >
> > There is no TPC flag, hence the limit is set at 27 dBm.
> >
> > > Reason for change in  5945 - 6425 :
> > > The HK department, OFCA requires to have its own EIPR limit, 24dbm in
> > > addition to ETSI 23dbm.
> > > Therefore, the smaller value should be taken.
> > > (6GHz in HK requires no reference to FCC standards, unlike 5GHz situa=
tion)
> > > WIFI 7 allows 320MHz, the previous value, 160MHz was in wifi 6E era.
> > >
> > > # https://www.etsi.org/deliver/etsi_en/303600_303699/303687/01.00.00_=
20/en_303687v010000a.pdf
> > > (page 17)
> >
> > You mentioned in your reply that this change is invalid.
> >
> >
> > So to summarize, I don't see any change at all.
> >
> >
> > ChenYu
>
>
>
> --
> Regards,
>
> Morgan Wong



--=20
Regards,

Morgan Wong
