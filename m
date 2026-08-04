Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540603AAF7C
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 12:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785845617; cv=pass; b=lJOWM2ApvYHpXkGJcCkz/Wn959+RQTzVXr6XVz22pRCathHo5AfNOm3FYw7e/cCf0DrLSaOZ/jcNYTei8pQomlZZJK8IgHyUwXMiM03ZhXPPWTU6fwmTD/5+DCCXdKiFKbhaLLxuxGmmi+0vuj6WRIhAYibZCXXPUf687AktuiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785845617; c=relaxed/simple;
	bh=YhqoChrUWkC+QDkEyTwavUPj7jACeaC2X47k/AziJqQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A9eddZN6gTk0GDLjMZK7tWSyn3co9yY9YHCxS4ne+AIiNZ3hwOPX1mKy5wiH/hS0W8Pb6boJ00MklOR6finbGUDn5JEGcWoeAg7qRVqHzAiKaPdUn3e5JBvWBa9AILBy6BALaUL/49aZvufmA89A/z5SVRbB96mUOYOmVfkBjJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R5Cd4tHw; arc=pass smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R5Cd4tHw"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e54f8c051so227117485a.3
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 05:13:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785845615; cv=none;
        d=google.com; s=arc-20260327;
        b=nTGrPY7enkbBF77qyC3eJ3XDspyCoNyIfg5WKGSFsqpFWZIN9bAYq1zfqhLOZMhejx
         ppxsAJza6yr7STBxit0MOdqM6THHKQ4wZolvZ2Cj1n+mKhP+ojtwUA6SyztYc2EpGQHN
         oJmequYobW0Im4eel2kxxHS6vcnox5Fco9Viic2Co2itgkqV3BlarY5vew0G1/8+7L+z
         Aw7WZKc52bdQAeK9Mt4F9DHrtEXWicznDoEQEGhxomwsLfhMCIatdUeP+q751EKgKjk3
         tamzdZghg0I588FvJ7vV4jc40AT6g/LfYI5CXUEecN1FWkKDI1jVxHY3JpkLjrUtZT24
         CONg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MpnNxPs2kvssObanVQDUh/m4GaswozFxnPICO3pxlak=;
        fh=BzVcj3AOSjt+4oCebDOU6fO0kGZQwBEUFf03l6Edbvw=;
        b=gVzGrt0tybu2tPNlY5yyhdtkDW/2p8L87M+SrpKQFIrQI2oZpSspjV6cG9xy43BVu7
         GnoMK6c7iXqqlNL+fhWBmM2kASFBJdZm6VQQKiZQKcT8/EAzMd5+BM3wSXpi4lrXutEo
         5gOZTdNob8xFSgMMcTi1ZPhIqB0HShC0K1Zqr+H8fe3epABuYh7W386jYrvZeoL218qS
         KFOTjNP2HCsnUENiBZ/7xT5N+IG2q5bzDou46ZvIAAfTCmmKN2Nw5USScMytAyKSGOVm
         mHi0Y5i9/b0dGiZqBU3ifd3ex4khzVw3xRN1XASmdm3ljgER9546BNWnY8T2JFfdBVE0
         0sRw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785845615; x=1786450415; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MpnNxPs2kvssObanVQDUh/m4GaswozFxnPICO3pxlak=;
        b=R5Cd4tHwavS38+ebn3oYYDLjZJWiYkGjQQxpOT2vIXjlgsAEoZA/zA0j5eZtkPfHPG
         tvMEijokaifflNxv5G8TlW5L7vnrXqZ7bFVH8D6Ssfag5pTratbLcicEgeX5Y1yuv/nh
         BwyOKQXUU1FTEDcJlz6y+h5+PtXOuqnZ90xZdPjtVGsD69QEuxsJHs0rfvgwsdK0PGP7
         cwHCnmUNjyYGMs05FkYA+Xw3lrcbUHjLjx7l1SMPjDFgRGgsNImG5fFPdPkBTpB3XstE
         zZxWsUUyHh1LUK3hzo21rXAcD3zDAzyiu0zadNCfvSv/vdvSC1Z5NKpFv6QN/lWcLXMl
         f79w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785845615; x=1786450415;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MpnNxPs2kvssObanVQDUh/m4GaswozFxnPICO3pxlak=;
        b=U9Y27rgTCzZrjjXDGme5KeIRHyY638TcZfQ2oR1oAuI1xhDxCBSCkxDoreGT0k9f7k
         6ViS+K4/7NxKwS9Vo5iZ03wpt94rEvJel7phikXPai95POx4MpJMVbosRQXr1ANRtT8i
         Y8oukbfW1MCi5jpUlO8ef1jcdMdH/pZlv9RGUXOu4YdcWohBo0LjuhJ3KIBmHpyhEXxS
         +3gXV8+wIjkJW2Rg9Uisvn/YhALLgpJ9vjGo4vuzb5FRkQGDInjtFhR/6NbaZEhTUMuZ
         SFWx0ZYgITq/ndmhGDtMBhnU+wylw9gm+1MzAKM9WJ2K3r7rV0SNPRiJcwP90JwWBCKI
         ZO/A==
X-Gm-Message-State: AOJu0Yz0vHtHHYOJ0ApBOqi9LR1rFAiUmM4T4kHR9ZtG641yy5Ih52P/
	GIDwMe3V12cUC1xBfeOxqphcFRboYXJQYVBaY78P+ZkecEDtJJ+j+KwvQutLIOCDfcK2MilIAj+
	2PEi8F4MH0zb4OXRy1FsgHkubaip+oFI52YFP
X-Gm-Gg: AR+sD12vamsy3BEOqI9bg/yfoE8XCa6EUrrVAKON+fG715CRE0PCJGhq1KcRSba9CKj
	3S6f0Z3ck/m2u4F+8bF6e5Tl/1OHHewBWQvm81TbFA32qDV2GkU44X2yCoWZD4rY0Zjmnd4MqPh
	TvI62r/ANRbSnfYLVb3HsfKixspmWmmXmSkPOjvLC60C82jEeUUatM9Lfyu1vK31aMwug7P4pr1
	/yddxQWBvbOgq3yJDGaekMuUteFf7i9efmUOp6yViYlo3m2qgdh5lQo+/lTfgZGm3dwusughULF
	9D/rtKNkUAjvqfMIQwq1H2PRK1V5cq4fKZutOjT0agtjUw==
X-Received: by 2002:a05:620a:230a:20b0:932:fce7:dc66 with SMTP id
 af79cd13be357-934a0ac3160mr2111014985a.45.1785845615013; Tue, 04 Aug 2026
 05:13:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CABzKGg0YEm5PfW9YtEM0G1SYY6RD80DmFpu_Jpb9hoioK+tH-w@mail.gmail.com>
In-Reply-To: <CABzKGg0YEm5PfW9YtEM0G1SYY6RD80DmFpu_Jpb9hoioK+tH-w@mail.gmail.com>
From: Morgan Wong <pbodq2@gmail.com>
Date: Tue, 4 Aug 2026 20:13:23 +0800
X-Gm-Features: AUfX_mx15RRG_NO1G4syHthtl5Uhx9IY1aVX7haBwNh8VQCuAueAVLc-QZI1P5M
Message-ID: <CABzKGg3SeW+vUzyZ5Bq1cUoN2YGHo2vuBY3vuqLoa2dc9buMGQ@mail.gmail.com>
Subject: Re: wireless-regdb: Update regulatory rules for Hong Kong (HK) on
 5GHz and 6GHz
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear all,

Please keep the original value 24dbm instead of 23 in 6GHz.

I overlooked there was a small footnote at the bottom of document HKCA
1081. The government allows +1dmb on top of ETSI's 23dmb =3D 24dbm

https://git.kernel.org/pub/scm/linux/kernel/git/wens/wireless-regdb.git/com=
mit/?id=3D756d784aa2ee2810ded0dd314d9764c80660a75b

Morgan Wong <pbodq2@gmail.com> =E6=96=BC 2026=E5=B9=B48=E6=9C=883=E6=97=A5=
=E9=80=B1=E4=B8=80 =E4=B8=8B=E5=8D=889:37=E5=AF=AB=E9=81=93=EF=BC=9A
>
> Dear all,
>
> Currently:
>
> # Source:
> # https://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkca1039.pdf
> (2.4 GHz and 5 GHz)
> # https://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkca1081.pdf (6=
 GHz)
> country HK: DFS-ETSI
> (2400 - 2483.5 @ 40), (36)
> (5150 - 5250 @ 80), (23), AUTO-BW, NO-OUTDOOR
> (5250 - 5350 @ 80), (23), DFS, AUTO-BW, NO-OUTDOOR
> (5470 - 5730 @ 160), (27), DFS
> (5730 - 5850 @ 80), (36)
> (5945 - 6425 @ 160), (24), NO-OUTDOOR
>
>
>
> Update :
>
> # Source:
> # https://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkca1039.pdf
> (2.4 GHz and 5 GHz)
> # https://www.ecfr.gov/current/title-47/chapter-I/subchapter-A/part-15/su=
bpart-E
> (2.4 GHz and 5 GHz)
> # https://www.etsi.org/deliver/etsi_en/301800_301899/301893/02.00.07_20/e=
n_301893v020007a.pdf
> (2.4 GHz and 5 GHz)
> # https://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkca1081.pdf (6=
 GHz)
> # https://www.etsi.org/deliver/etsi_en/303600_303699/303687/01.00.00_20/e=
n_303687v010000a.pdf
> (6GHz)
> country HK: DFS-ETSI
> (2400 - 2483.5 @ 40), (36)
> (5150 - 5250 @ 80), (23), AUTO-BW, NO-OUTDOOR
> (5250 - 5350 @ 80), (23), DFS, AUTO-BW, NO-OUTDOOR
> (5470 - 5730 @ 160), (30), DFS
> (5730 - 5850 @ 80), (36)
> (5945 - 6425 @ 320), (23), NO-OUTDOOR
>
> Reason for change in 5470-5730 :
> The HK department, OFCA has its own requirement, 30dbm in addition to
> EITHER fulfilling FCC OR ETSI requirement. The rationale behind is
> having the biggest tolerance among major world standards to be an
> international city. The OFCA, 30dbm is the baseline value to be
> fulfilled in the highest priority.
>
> About FCC
> 27dbm (500mW) without TPC, 30dbm (1W) with TPC
> # https://www.ecfr.gov/current/title-47/part-15/subpart-E#p-15.407(h)(1)
>
> About UTSI (same as FCC)
> 27dbm (500mW) without TPC, 30dbm (1W) with TPC
> # https://www.etsi.org/deliver/etsi_en/301800_301899/301893/02.00.07_20/e=
n_301893v020007a.pdf
> (page 17)
>
> A TPC (30dbm), 802.11h edition should be taken instead of 27dbm as I sugg=
est.
> Or a TPC regulation flag may be a good idea to bind with 30dbm together.
>
>
> Reason for change in  5945 - 6425 :
> The HK department, OFCA requires to have its own EIPR limit, 24dbm in
> addition to ETSI 23dbm.
> Therefore, the smaller value should be taken.
> (6GHz in HK requires no reference to FCC standards, unlike 5GHz situation=
)
> WIFI 7 allows 320MHz, the previous value, 160MHz was in wifi 6E era.
>
> # https://www.etsi.org/deliver/etsi_en/303600_303699/303687/01.00.00_20/e=
n_303687v010000a.pdf
> (page 17)
>
>
> --
> Regards,
>
> Morgan Wong



--=20
Regards,

Morgan Wong
