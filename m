Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90457474272
	for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 13:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787058653; cv=pass; b=fJB5gmM7InOGkWUxpFy9WxuNqt8TIUh43KNOOs8rrqzr1zOnHVGhnVVmrgPjGyb8GgKkahmE5NErKJT1akW8XrjnFqu7YNUT4cxfo0IGGGNgzoRJtDOn6iBhxDrUnHDdqltNFfTCCohbemB3nCKyjPBamcPEj0/rg1Bpbmk9heA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787058653; c=relaxed/simple;
	bh=lqj4n1WaqZ3NTZdgkD2iQcOU4gVUOfNnxygjucwvs2k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HCsSJkGfB6yVV2wvvyFueG3hyPK+DUaM7epHlWMMxq9xe3L4xSYGDhOymarw0QB+jx/XnEX3+d4okWPvBC1ivbgjHMG2/GTk3FmqON/POpGwSk9V0apNS9GbO5bvMIDWWwfR5leycwwyPJeGj1wqjPod9QTKsj5ep+TJe4+qSV0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wv+olwsl; arc=pass smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wv+olwsl"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8efbafa1bacso24965616d6.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 06:10:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787058650; cv=none;
        d=google.com; s=arc-20260327;
        b=bpq6cIuqlqyf4nL5YWEj/lkYxBAEr/XlGVVEvfEgXDDC4OgxEyXAMkXrtltA2O+OEl
         aTIOH7SsDHSqw5VXmVzefQqdPrw7NUjrkZX+jc3vSCwSJM7mlMmIPATjH/g/x8olpkNq
         lWL09HLUF4ZTfGO+SDzeqCXGmKJl4fjhAwOZmf0fyRNkN6McWz1kJb8gMhRYpVp5gSBw
         kzHGHMetu9S0Q8tO7sC/8nLuTGWiUZ0mbqMsYP7OEt20tnA7ejRqLusEhALJ2LMPbKmc
         ej6IVEIAqqCVi2qmzfANP+9zLdAxwinYA0WBGYlBOHIE5RNWrLrbONY6bKWP+bliA8P9
         TQhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1kLtpbFR5SYSksD0nL4IXXu9FNfott2NZaHxkpQa/Nc=;
        fh=EEqq1nyX5noIwz+ZeuRwJY5LeYNGO0SH4elp/69PwDE=;
        b=A9OLKvDQCYtl1doF1KVC4Li5kWw560rFD079ssQEXcbdlA75rh4tWT81AoLB4dFLMN
         resiT/G2YCjCW+70h0AuDsvVjT8Aopju5qE8BelySi0OT0TvOhy+JXEqbaZvCUY+dMQI
         dUTUtDuo2FxtlwOjOrpi3r3CbXR0LDOAdKYU0xJ2/YCwaRUpz26/e7AMuVsgs8CgyOc5
         w3JJYCwQ6GUcYC0m4V1WJYlPFx0KJTxRk43/SJcW7op3UTUcoscRPSAou0Phh0UJk+DU
         kWGzC6cFjQTldr4JfCxCgO9wY6od/bMGBS6rGZzA2OMRQv43rukMpPNOlq0ip3waDgVN
         vCFQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787058650; x=1787663450; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1kLtpbFR5SYSksD0nL4IXXu9FNfott2NZaHxkpQa/Nc=;
        b=Wv+olwslOS1cDw8KAFUyY4ZQN4yrWnBiffiCP8i822Xw0LZXfEhHD3CJUH4xB9P4Ne
         xBj6tEytuikxXAgeX01qEs7WQH//GmcIpb/jIbppb7hK34oQc3pioZQqafJQptCMM2Mx
         SVQ0sZF8PvCp4/2zaXG6cucmJ+66emjpgMsc198tc+NEDjLVVbxgiYj2GLRbfSPBWrJa
         /4khqx12RaIuPNM1ZLeBqOaGdB7vfV7g2qcaXGcoHzSI2oI8hWU53OCVuAw+MW1dF7up
         HptKUnYzc98u3/3wMhmp6+esCjhIjvBY8a1v30DOCQBr75skLmGnO0m6UXeEGLzuQI8q
         rDnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787058650; x=1787663450;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1kLtpbFR5SYSksD0nL4IXXu9FNfott2NZaHxkpQa/Nc=;
        b=Sx9io86Me36cdCctzmHUrVke6J3wOTcOtQ/L9/nCDp685ccJnhaL1T0YG9jz4EwXNJ
         CxdCrQZLL2PUfimMg3TfRj9EeY620aVbdmSVi4uA00lDeCiTBU8pK5foPSXu3bJI7rtj
         Ot38uqCjXLLQcFMi8ZKgf+g2JJrJCyvwaXrM3Wc2yXyIDSX/cyv9euPWjoag7ZmndNNr
         fjB3kFolH/o4+uYrHQxGS2G0iqY2pgbJf6LmAKeyXJG0D4Mv4Xxfe8Hxm3K/D1llzUWe
         r+iWx7Ng47j6QK2KWwpHmxQXiv20KEcTBcuD7XkfkODjN1sl+oMuweiMTiFYXp3vt1I5
         vNiA==
X-Gm-Message-State: AOJu0YykKs8td0PBFOP5ELASXd7OkuTI0eDuikALo9YcZNHkaXR7lEEM
	4l2FkURu2ORDVIkPXAhE4hBKy+I30tCKQBk5W51oGB26WvtUJZxhKFiTIs7jrT47FvTfZRH17bm
	Nv79d3nVuXH8DoQ6R/7EX2Xwpj4d2IAo=
X-Gm-Gg: AR+sD13sczgSJoroMV+qUNi9+L5V6H7v4FptPTYTj1eOFjNoY2G9xFMK8z2XHwanSys
	khC/N7VEMgD7baqRjPvZJDK/eqe2I5b/IV64GSaHv/izvtrkcVcgXH6wR9R7B16QFhYbAwLQVrX
	nB0KJwE3+RWBbTJqCsYsB6Cgjl7iN6jmqBgBWLeTqBZiW2wTXaJbmTLEKdCelKmOFs0hjTbkjXE
	bYlAzcj67Su156GwcOQBgcuqka4ASHQyrjqfreHAVghOeEr4Xi18HGSZ2qjoCZFS9SlSxnO3Z90
	LknZZt+0ISKQKHCSNPEqtRgei79fxI2ToxOocfuHRadtDS05Ppzm6f2B
X-Received: by 2002:a05:6214:130b:b0:8fe:40a0:7cbb with SMTP id
 6a1803df08f44-90a91d481cfmr367261746d6.15.1787058649864; Tue, 18 Aug 2026
 06:10:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CABzKGg0YEm5PfW9YtEM0G1SYY6RD80DmFpu_Jpb9hoioK+tH-w@mail.gmail.com>
 <CAGb2v66RnAr_yPhZuuandeoE=wSh9tJMdfqkLLudWKpDmDKc4Q@mail.gmail.com>
 <CABzKGg2C-kb673u4o9Nk28-bp9ONuQAaDA39x47bJOpq6RrNHg@mail.gmail.com>
 <CABzKGg3-5yE19-_fiBuvaM9CBUnyJ7UYmt6M6w3BrEqu+3Unbw@mail.gmail.com> <CAGb2v6592_Tp7UbAKcXm3FZGMWCfxNriH3VJWDm5yZA-atYN0g@mail.gmail.com>
In-Reply-To: <CAGb2v6592_Tp7UbAKcXm3FZGMWCfxNriH3VJWDm5yZA-atYN0g@mail.gmail.com>
From: Morgan Wong <pbodq2@gmail.com>
Date: Tue, 18 Aug 2026 21:10:35 +0800
X-Gm-Features: AcwNN1WRpw_IiFjKGWtUde7Em2CGw78XjtwYZfIg6_z69NRkehqPU2QhCCj0PKw
Message-ID: <CABzKGg0knPnFARuf_+yZjpVhFV_O2ihCRTAEZqcDJ=S6JN3NZw@mail.gmail.com>
Subject: Re: wireless-regdb: Update regulatory rules for Hong Kong (HK) on
 5GHz and 6GHz
To: wens@kernel.org
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Tsai,

Sorry about overlooking the second paragraph.


1. About the TPC issue, you are right, please ignore this part of request.

2. About 6GHz 320MHz bandwidth, I am grateful if you could generate the fil=
e.

Take your time. Thanks for your help. Have a good day.

Chen-Yu Tsai <wens@kernel.org> =E6=96=BC 2026=E5=B9=B48=E6=9C=8817=E6=97=A5=
=E9=80=B1=E4=B8=80 =E4=B8=8B=E5=8D=882:54=E5=AF=AB=E9=81=93=EF=BC=9A
>
> On Mon, Aug 17, 2026 at 2:17=E2=80=AFPM Morgan Wong <pbodq2@gmail.com> wr=
ote:
> >
> > Dear all,
> >
> > Is there any problem about the patch and the reason? Any regulative
> > restriction conflict ?
>
> Sorry I haven't gotten around to it.
>
> > Morgan Wong <pbodq2@gmail.com> =E6=96=BC 2026=E5=B9=B48=E6=9C=884=E6=97=
=A5=E9=80=B1=E4=BA=8C =E4=B8=8B=E5=8D=8810:01=E5=AF=AB=E9=81=93=EF=BC=9A
> > >
> > > Dear Tsai,
> > >
> > > The patch from git diff is now attached.
> > >
> > > I summarize again the changes, please decide.
> > >
> > > 1. 30dbm (1W) of TPC condition is applied on 5470-5730.
>
> As previously mentioned, Linux does not support TPC, so any power limits
> that require TPC do not apply. So the option is to use the "without TPC"
> option that normally halves the power limit.
>
> > > 2. Now, 320MHz bandwidth can be applied in 6GHz as WIFI 7 rolled out.
>
> This is fine.
>
> Do you want to do a proper Git patch? Or I will do the patch and list you
> as the issue reporter.
>
>
> Thanks
> ChenYu
>
> > > Chen-Yu Tsai <wens@kernel.org> =E6=96=BC 2026=E5=B9=B48=E6=9C=884=E6=
=97=A5=E9=80=B1=E4=BA=8C =E4=B8=8B=E5=8D=888:48=E5=AF=AB=E9=81=93=EF=BC=9A
> > > >
> > > > On Mon, Aug 3, 2026 at 9:38=E2=80=AFPM Morgan Wong <pbodq2@gmail.co=
m> wrote:
> > > > >
> > > > > Dear all,
> > > > >
> > > > > Currently:
> > > > >
> > > > > # Source:
> > > > > # https://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkca103=
9.pdf
> > > > > (2.4 GHz and 5 GHz)
> > > > > # https://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkca108=
1.pdf (6 GHz)
> > > > > country HK: DFS-ETSI
> > > > > (2400 - 2483.5 @ 40), (36)
> > > > > (5150 - 5250 @ 80), (23), AUTO-BW, NO-OUTDOOR
> > > > > (5250 - 5350 @ 80), (23), DFS, AUTO-BW, NO-OUTDOOR
> > > > > (5470 - 5730 @ 160), (27), DFS
> > > > > (5730 - 5850 @ 80), (36)
> > > > > (5945 - 6425 @ 160), (24), NO-OUTDOOR
> > > > >
> > > > >
> > > > >
> > > > > Update :
> > > > >
> > > > > # Source:
> > > > > # https://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkca103=
9.pdf
> > > > > (2.4 GHz and 5 GHz)
> > > > > # https://www.ecfr.gov/current/title-47/chapter-I/subchapter-A/pa=
rt-15/subpart-E
> > > > > (2.4 GHz and 5 GHz)
> > > > > # https://www.etsi.org/deliver/etsi_en/301800_301899/301893/02.00=
.07_20/en_301893v020007a.pdf
> > > > > (2.4 GHz and 5 GHz)
> > > > > # https://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkca108=
1.pdf (6 GHz)
> > > > > # https://www.etsi.org/deliver/etsi_en/303600_303699/303687/01.00=
.00_20/en_303687v010000a.pdf
> > > > > (6GHz)
> > > > > country HK: DFS-ETSI
> > > > > (2400 - 2483.5 @ 40), (36)
> > > > > (5150 - 5250 @ 80), (23), AUTO-BW, NO-OUTDOOR
> > > > > (5250 - 5350 @ 80), (23), DFS, AUTO-BW, NO-OUTDOOR
> > > > > (5470 - 5730 @ 160), (30), DFS
> > > > > (5730 - 5850 @ 80), (36)
> > > > > (5945 - 6425 @ 320), (23), NO-OUTDOOR
> > > >
> > > > Please do a proper patch or at least diff. This is hard to spot dif=
ferences.
> > > > And if it's not a patch it's more work.
> > > >
> > > > > Reason for change in 5470-5730 :
> > > > > The HK department, OFCA has its own requirement, 30dbm in additio=
n to
> > > > > EITHER fulfilling FCC OR ETSI requirement. The rationale behind i=
s
> > > > > having the biggest tolerance among major world standards to be an
> > > > > international city. The OFCA, 30dbm is the baseline value to be
> > > > > fulfilled in the highest priority.
> > > > >
> > > > > About FCC
> > > > > 27dbm (500mW) without TPC, 30dbm (1W) with TPC
> > > > > # https://www.ecfr.gov/current/title-47/part-15/subpart-E#p-15.40=
7(h)(1)
> > > > >
> > > > > About UTSI (same as FCC)
> > > > > 27dbm (500mW) without TPC, 30dbm (1W) with TPC
> > > > > # https://www.etsi.org/deliver/etsi_en/301800_301899/301893/02.00=
.07_20/en_301893v020007a.pdf
> > > > > (page 17)
> > > > >
> > > > > A TPC (30dbm), 802.11h edition should be taken instead of 27dbm a=
s I suggest.
> > > > > Or a TPC regulation flag may be a good idea to bind with 30dbm to=
gether.
> > > >
> > > > There is no TPC flag, hence the limit is set at 27 dBm.
> > > >
> > > > > Reason for change in  5945 - 6425 :
> > > > > The HK department, OFCA requires to have its own EIPR limit, 24db=
m in
> > > > > addition to ETSI 23dbm.
> > > > > Therefore, the smaller value should be taken.
> > > > > (6GHz in HK requires no reference to FCC standards, unlike 5GHz s=
ituation)
> > > > > WIFI 7 allows 320MHz, the previous value, 160MHz was in wifi 6E e=
ra.
> > > > >
> > > > > # https://www.etsi.org/deliver/etsi_en/303600_303699/303687/01.00=
.00_20/en_303687v010000a.pdf
> > > > > (page 17)
> > > >
> > > > You mentioned in your reply that this change is invalid.
> > > >
> > > >
> > > > So to summarize, I don't see any change at all.
> > > >
> > > >
> > > > ChenYu
> > >
> > >
> > >
> > > --
> > > Regards,
> > >
> > > Morgan Wong
> >
> >
> >
> > --
> > Regards,
> >
> > Morgan Wong



--=20
Regards,

Morgan Wong
