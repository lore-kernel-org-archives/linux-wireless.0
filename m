Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6304C46A612
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 14:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785852128; cv=pass; b=Metqrgd9mmUS+pvyelA1j+bwQ18/EilzCsQsqjOcDKJAQnkVMkYHYYzRy2OXoFs6AHMCnaWEdv5+Iq3SH3gtfMS5P+4KKg1PnJPeBcCVj87o2h47aWgQaiBaRY3h7MfDwgkX72SDa7vq3X6Wnr20/OZhS1tigtQCtImI92Q10wg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785852128; c=relaxed/simple;
	bh=9AwYscXuXDJe7IEw3PyVw8EONq+8O99/ViywnHQXF1E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fjPZ5nGgkmXHsQG8JbUcZJs0GpGlgn9NDAPL9zCzLdhvsDLUZcHpeJDLqgid7Ckyz/MHH3L6t/xnNDYqTJzta6emtqdat1jhnnUy9HQol0cVrccLKbQwjG++gRFcOYp9Mhmj0dtSxONRNCIuYsQWcNUKJgnSdV1dEqHc/SLF2Nk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RhNikI/R; arc=pass smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RhNikI/R"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8ee88fce572so43745766d6.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 07:02:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785852125; cv=none;
        d=google.com; s=arc-20260327;
        b=qCW0aHg+/klQ4O+HBsrzd1zoSEQ0s2I6FWdZmB850K6hjXuTD+LW4XUwXALHlcD7HF
         gxmB2HDK/2qDArkI7svqnvxRqKAcRnotfiOCkgCV9NAy6neU6oxDi4SN+iWfzF9bkTbn
         lnutLGmLOCnveuwN77os1hICrRxEvbaoB0xxKQppEuYth9c3K2M4jBSqZDARYyN6BA5P
         vNo20EbyeZrL6aOVDlPlZ8GTwErU9MdzIpqtI/Zi/fk6zfRm/0E8kOHkPnkIWl8s3jIe
         iUjaA4GJbTLN/JbnaJwU7/30JGnfc7K17AuNM3hlxpBfVrSS80y7H4xu1Cp6O/r0V9yA
         /1CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=qh8UBNm5U/sfp98PJI7FDutd3EvD7SzMGXtfQ/QVld8=;
        fh=EEqq1nyX5noIwz+ZeuRwJY5LeYNGO0SH4elp/69PwDE=;
        b=mK9+/P3GvvHNb0X9u9OudlsAIYfVO83obCELGccD0RckU/af2rnT92EAXH3Vi5bkCn
         6dMDOrvLHYuuAJnsGwdOpSRerJ8BDdg0xu7FE3gjz/kA0+3kXdm/oJC3RdkTC4OLBKf4
         wp+50AvnoobvqNNuwSSuou+yKDAU5ajy22AsUT5C+3J5LQXgNsfLtPpwXuolg44yJ4u5
         E/EmoecLnrdxltpYUUjP1w8ZoAPc4cWtdF0E+r3b3hVtbc07sDxp7iyYly7Pk1wDDAOO
         YJLvzMZP+ke365V4w7RzZXFvpz7wSgwTsXZFDN+J6b6bTKmxwzTe83QSwAyhtl9OGctQ
         1Uqw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785852125; x=1786456925; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qh8UBNm5U/sfp98PJI7FDutd3EvD7SzMGXtfQ/QVld8=;
        b=RhNikI/RLyDCJwZqcn1UvgkKEt+84fBi9FksS4FUcFEOpi494Oa1VexDnpLBC3TWu2
         nZBW9WSInYjz/jiIrbf8maqcQdsv0rmV0VjMkFC5rP7Z1al1zmOxzJtfr+EUaR2gUnWy
         cGgHRLTEtu9ugqy66xULypI+1GYs+NN07+FlDXNwSNVS+FYoouVOtA1puwR7295oASwn
         ePUeX0OimGhYhuIbAetv12jbcvuQ8zH9MWb/+hWGg9fO+/nzngRHLx2V+UPRDctG+zyO
         VjwgFnlfw6iPGN8Fan54S6MGfE61b3Z2fWkObg1OzI81mTilTC+SgY45E+uvEwMfq0hL
         Dxsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785852125; x=1786456925;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qh8UBNm5U/sfp98PJI7FDutd3EvD7SzMGXtfQ/QVld8=;
        b=j0C0VZceiGvrO1ERh5+0EodD9tZ+7heLUXD8BC0XEA4LfocaYv2jMFgPg+hWB/pVJ0
         LrWFBIZrkRTpIDr6C/KvhK2EyB1LPACClYJVIittnDqUtf/7+etWtcBBu4Wi8tSPYTei
         4zEJ2UTUk8bWjaAfdZi8N+XDQA6F8sdlVpwJpZVC5DgVwtgn2v4PHqlSUvb7ayZPt3bt
         K295st2/Zp7fGCuPmngwhM3SLM3ThU9lqPXI4dMeLhUBd+IhjvG4q+R11AHlV8Qj3K1S
         0d04bUh4l5gVD7kzSgQ7dMKd6dkqSJjb/RvpiR8yx76WcpkYALvti6SGdBv5GkW6aN+w
         wzxw==
X-Gm-Message-State: AOJu0YxvBWcNWNNEGHb+RbSThj22Py3yur8W6RlpfckWfSHFWKqsJrdn
	Bwwzogre4qWgSCwOGY7IDftCe05lyqu7COxLFjDVRQD7w/uJlUgdLWvzPjqe5FuALvtFGeqL/gD
	Hl9Uorbrgs3W5IbvZgIRLGuSZj4s2984=
X-Gm-Gg: AR+sD13GdNHpUZp5IzgazKV2IfAh2UB3+V6EyvTf0pZ+PD0ZXvD3dRcuA3N9GLUC4aK
	bXegV/otF8+2t5gU/KvilZvVbSC3bo36PYrOU8gwTDZUfMqBRFhbuZkrdZ6xlJJMgRkfGMkHqYM
	S3NUhQmgabjoz971nogkHYunxASuewMTZV34PiLTDJkdSqBmgSM6SjD+JUn+aGAv4uFI29yZw5L
	O+gNt0D0Jz2k/mWdiRJMgnjx+TpprczKzq6X0Yl4Yf6zdQ5tkwhR2UPrvGPYEBF3CXskxfpuik4
	HrMzCgtuWeqzlHvQXr9nLAx74kWLvPijIqind/M+WCA=
X-Received: by 2002:ad4:4ea5:0:b0:8ce:ca7d:b099 with SMTP id
 6a1803df08f44-90849640102mr296902816d6.18.1785852124779; Tue, 04 Aug 2026
 07:02:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CABzKGg0YEm5PfW9YtEM0G1SYY6RD80DmFpu_Jpb9hoioK+tH-w@mail.gmail.com>
 <CAGb2v66RnAr_yPhZuuandeoE=wSh9tJMdfqkLLudWKpDmDKc4Q@mail.gmail.com>
In-Reply-To: <CAGb2v66RnAr_yPhZuuandeoE=wSh9tJMdfqkLLudWKpDmDKc4Q@mail.gmail.com>
From: Morgan Wong <pbodq2@gmail.com>
Date: Tue, 4 Aug 2026 22:01:52 +0800
X-Gm-Features: AUfX_mx96gvitYZPPaAXDF-ihaQsPZ3I4kuyxaAveLR8xsGdrH2wHiqJEl_dSd8
Message-ID: <CABzKGg2C-kb673u4o9Nk28-bp9ONuQAaDA39x47bJOpq6RrNHg@mail.gmail.com>
Subject: Re: wireless-regdb: Update regulatory rules for Hong Kong (HK) on
 5GHz and 6GHz
To: wens@kernel.org
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Content-Type: multipart/mixed; boundary="000000000000853eac06583919d6"

--000000000000853eac06583919d6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Tsai,

The patch from git diff is now attached.

I summarize again the changes, please decide.

1. 30dbm (1W) of TPC condition is applied on 5470-5730.

2. Now, 320MHz bandwidth can be applied in 6GHz as WIFI 7 rolled out.

Chen-Yu Tsai <wens@kernel.org> =E6=96=BC 2026=E5=B9=B48=E6=9C=884=E6=97=A5=
=E9=80=B1=E4=BA=8C =E4=B8=8B=E5=8D=888:48=E5=AF=AB=E9=81=93=EF=BC=9A
>
> On Mon, Aug 3, 2026 at 9:38=E2=80=AFPM Morgan Wong <pbodq2@gmail.com> wro=
te:
> >
> > Dear all,
> >
> > Currently:
> >
> > # Source:
> > # https://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkca1039.pdf
> > (2.4 GHz and 5 GHz)
> > # https://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkca1081.pdf =
(6 GHz)
> > country HK: DFS-ETSI
> > (2400 - 2483.5 @ 40), (36)
> > (5150 - 5250 @ 80), (23), AUTO-BW, NO-OUTDOOR
> > (5250 - 5350 @ 80), (23), DFS, AUTO-BW, NO-OUTDOOR
> > (5470 - 5730 @ 160), (27), DFS
> > (5730 - 5850 @ 80), (36)
> > (5945 - 6425 @ 160), (24), NO-OUTDOOR
> >
> >
> >
> > Update :
> >
> > # Source:
> > # https://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkca1039.pdf
> > (2.4 GHz and 5 GHz)
> > # https://www.ecfr.gov/current/title-47/chapter-I/subchapter-A/part-15/=
subpart-E
> > (2.4 GHz and 5 GHz)
> > # https://www.etsi.org/deliver/etsi_en/301800_301899/301893/02.00.07_20=
/en_301893v020007a.pdf
> > (2.4 GHz and 5 GHz)
> > # https://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkca1081.pdf =
(6 GHz)
> > # https://www.etsi.org/deliver/etsi_en/303600_303699/303687/01.00.00_20=
/en_303687v010000a.pdf
> > (6GHz)
> > country HK: DFS-ETSI
> > (2400 - 2483.5 @ 40), (36)
> > (5150 - 5250 @ 80), (23), AUTO-BW, NO-OUTDOOR
> > (5250 - 5350 @ 80), (23), DFS, AUTO-BW, NO-OUTDOOR
> > (5470 - 5730 @ 160), (30), DFS
> > (5730 - 5850 @ 80), (36)
> > (5945 - 6425 @ 320), (23), NO-OUTDOOR
>
> Please do a proper patch or at least diff. This is hard to spot differenc=
es.
> And if it's not a patch it's more work.
>
> > Reason for change in 5470-5730 :
> > The HK department, OFCA has its own requirement, 30dbm in addition to
> > EITHER fulfilling FCC OR ETSI requirement. The rationale behind is
> > having the biggest tolerance among major world standards to be an
> > international city. The OFCA, 30dbm is the baseline value to be
> > fulfilled in the highest priority.
> >
> > About FCC
> > 27dbm (500mW) without TPC, 30dbm (1W) with TPC
> > # https://www.ecfr.gov/current/title-47/part-15/subpart-E#p-15.407(h)(1=
)
> >
> > About UTSI (same as FCC)
> > 27dbm (500mW) without TPC, 30dbm (1W) with TPC
> > # https://www.etsi.org/deliver/etsi_en/301800_301899/301893/02.00.07_20=
/en_301893v020007a.pdf
> > (page 17)
> >
> > A TPC (30dbm), 802.11h edition should be taken instead of 27dbm as I su=
ggest.
> > Or a TPC regulation flag may be a good idea to bind with 30dbm together=
.
>
> There is no TPC flag, hence the limit is set at 27 dBm.
>
> > Reason for change in  5945 - 6425 :
> > The HK department, OFCA requires to have its own EIPR limit, 24dbm in
> > addition to ETSI 23dbm.
> > Therefore, the smaller value should be taken.
> > (6GHz in HK requires no reference to FCC standards, unlike 5GHz situati=
on)
> > WIFI 7 allows 320MHz, the previous value, 160MHz was in wifi 6E era.
> >
> > # https://www.etsi.org/deliver/etsi_en/303600_303699/303687/01.00.00_20=
/en_303687v010000a.pdf
> > (page 17)
>
> You mentioned in your reply that this change is invalid.
>
>
> So to summarize, I don't see any change at all.
>
>
> ChenYu



--=20
Regards,

Morgan Wong

--000000000000853eac06583919d6
Content-Type: application/octet-stream; name="1.patch"
Content-Disposition: attachment; filename="1.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mseq7kwm0>
X-Attachment-Id: f_mseq7kwm0

ZGlmZiAtLWdpdCBhL2RiLnR4dCBiL2RiLnR4dAppbmRleCBlYjYzZmY2Li4xNDRjOTQ1IDEwMDY0
NAotLS0gYS9kYi50eHQKKysrIGIvZGIudHh0CkBAIC04OTAsOSArODkwLDkgQEAgY291bnRyeSBI
SzogREZTLUVUU0kKIAkoMjQwMCAtIDI0ODMuNSBAIDQwKSwgKDM2KQogCSg1MTUwIC0gNTI1MCBA
IDgwKSwgKDIzKSwgQVVUTy1CVywgTk8tT1VURE9PUgogCSg1MjUwIC0gNTM1MCBAIDgwKSwgKDIz
KSwgREZTLCBBVVRPLUJXLCBOTy1PVVRET09SCi0JKDU0NzAgLSA1NzMwIEAgMTYwKSwgKDI3KSwg
REZTCisJKDU0NzAgLSA1NzMwIEAgMTYwKSwgKDMwKSwgREZTCiAJKDU3MzAgLSA1ODUwIEAgODAp
LCAoMzYpCi0JKDU5NDUgLSA2NDI1IEAgMTYwKSwgKDI0KSwgTk8tT1VURE9PUgorCSg1OTQ1IC0g
NjQyNSBAIDMyMCksICgyNCksIE5PLU9VVERPT1IKIAogIyBTb3VyY2U6CiAjIGh0dHBzOi8vd3d3
LmNvbmF0ZWwuZ29iLmhuL2RvYy9SZWd1bGFjaW9uL3Jlc29sdWNpb25lcy8yMDIzL05SMDUtMjMu
cGRmCg==
--000000000000853eac06583919d6--
