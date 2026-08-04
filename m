Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B949E3DB324
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 12:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785847728; cv=none; b=M39M+BfUKTHUyXK4Q/8u8U+b/bxCUoP+Os+yDeB/gWPIENFpgcb1dKjJaManZcuJP1OYHY9wCJ7E/kKeI7V7q1dC/0dNc9RmnyySTni5dhfrsi0ye8uwAabulVnUSsf9OUr5VZiM2B6XVWR0kjnK8PCO3JyT2YZNRos0ZdAjh7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785847728; c=relaxed/simple;
	bh=ui+WQ+CwUVnNronliB/hJD4a9T9fzzSU+uLOUrKDHgg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BBTi7FmWvMVJpU1tCboajIQF1e2Rk4U561W9GvNqUc04pdsJIANproJ2waK1UUUs5ZBRHZIa9QJTRZJF4/ZMNg3HDxZDIPmdaxN8PpE8tTndT0AIIH1ZbbGvr9B0P0NXSAdlYploPdJKsVm0Ls7ea1+RayyKvady6VGhywWciVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IrwvovdH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IrwvovdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083011F00A3A
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 12:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785847726;
	bh=emjsfCqiib1hqYDWIUXBBTRh/PpUBt6NWcDAEa8ZQVI=;
	h=References:In-Reply-To:Reply-To:From:Date:Subject:To:Cc;
	b=IrwvovdHJLbYPVkHEL6jgnXGkQtjcTPw8YPeAByJg6sfUt27wvJHkrKjCRYr1Pgfn
	 Yf+j2ShBsd3us2jByXlf8tzB6mCrHapXA60G4HtFrBQYB7AgLATu3zL9chZCCLK+mi
	 y+05Dy2KN5knwsjeWaPWlGYX014jlj0X9f+DxsikQW4yChGE2QWdx6ifn6DZ+exCIy
	 Zffdn0qXsfU1F7FfWqP7hF7iNpjMe0iWrC+RSo9gSjWYyHINV8tBflpc6FqgT1VV4u
	 xf/ONFt0t6VEtlw7YTcY5Va1v6Nn2//S4GIApaLznt3WjAJNXn3f/ZLLnoNRiRFDn5
	 k1PmrzWePmGew==
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-39fa5e3a428so8633511fa.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 05:48:45 -0700 (PDT)
X-Gm-Message-State: AOJu0YxyS3adD+ZRYTqYC8QjAuaKgK9TLaLOITeStrCkUvqy8LmCK9v2
	s5592Ajj34oEBXvv9IJPuZT98vaHx4KzlxT8XF1lIQ2fETHxtIAcqQhooNr7WcW21rIMlv4jN60
	E6rsATwhtil52K3UDZT18jEv/3xWA5HA=
X-Received: by 2002:a2e:964a:0:b0:39c:7ed7:8565 with SMTP id
 38308e7fff4ca-39fae65bfe0mr6223841fa.7.1785847724445; Tue, 04 Aug 2026
 05:48:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CABzKGg0YEm5PfW9YtEM0G1SYY6RD80DmFpu_Jpb9hoioK+tH-w@mail.gmail.com>
In-Reply-To: <CABzKGg0YEm5PfW9YtEM0G1SYY6RD80DmFpu_Jpb9hoioK+tH-w@mail.gmail.com>
Reply-To: wens@kernel.org
From: Chen-Yu Tsai <wens@kernel.org>
Date: Tue, 4 Aug 2026 20:48:33 +0800
X-Gmail-Original-Message-ID: <CAGb2v66RnAr_yPhZuuandeoE=wSh9tJMdfqkLLudWKpDmDKc4Q@mail.gmail.com>
X-Gm-Features: AUfX_mzqhAFU6N5eXfgE9kEzE3qPSJT4BQo_IW7i366UzdM4ls3Oq_MSoMI1MkI
Message-ID: <CAGb2v66RnAr_yPhZuuandeoE=wSh9tJMdfqkLLudWKpDmDKc4Q@mail.gmail.com>
Subject: Re: wireless-regdb: Update regulatory rules for Hong Kong (HK) on
 5GHz and 6GHz
To: Morgan Wong <pbodq2@gmail.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 3, 2026 at 9:38=E2=80=AFPM Morgan Wong <pbodq2@gmail.com> wrote=
:
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

Please do a proper patch or at least diff. This is hard to spot differences=
.
And if it's not a patch it's more work.

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

There is no TPC flag, hence the limit is set at 27 dBm.

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

You mentioned in your reply that this change is invalid.


So to summarize, I don't see any change at all.


ChenYu
