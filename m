Received: from mail-yw1-f195.google.com (mail-yw1-f195.google.com [209.85.128.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB54409114
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 16:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.195
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789143493; cv=pass; b=MGOapCXxpYHJdH/V34/KLp3jnnpKUXNjZ1ORzfL5oPLF8zD8czuG6U/zdWCrEZ0rU4JKlpRHUBuhimlIuO+FTdY7xZgYebbBysv7G/czCQJAmFl+MuLsFiPdSnun2mYDrlyRCulF7K94icUFqMhbSqvgI+787/gSPnwjXVp0OxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789143493; c=relaxed/simple;
	bh=AjunjAZ8yDrgjlB1QcmEuzBag5QO6qqrFwjSaYNDefk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iLxhF+C9d7/U3RTNWqTs5f37OmeVOK6mRO4PNt4LMNLL0/c7sLAjrulSp57vSjkHQx9QGMg/6+GksCx6r3CmOtmWjWHFGfovV994gqqIBCig61zgKPsgB0hPkg1113V1FihSD0F8fOQZFQt9ehz0es47vp+zH2jvq3Ko176/SV0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IM5H/4T2; arc=pass smtp.client-ip=209.85.128.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IM5H/4T2"
Received: by mail-yw1-f195.google.com with SMTP id 00721157ae682-864cd11a932so8385047b3.0
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 09:18:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789143490; cv=none;
        d=google.com; s=arc-20260327;
        b=b9SMrpPPqxzwEn1uSbCegTxYe9c4N6sqUQ9HU5y9rmUyE4bqHvgo3HjxCcj9RaRjOs
         imldI/BK9WJCAK2mQ4ArJnMYSqVMg4RDGZa2hG2qpfVhWsy+0UuSFc+un7FQkPEqXaM6
         4nJxBOCVauigLVHOd6Kyv6D2t6xIM3qTVJrGlrI2dIzb2KmYVD/8+zwI0CLNUBX7Tsju
         hf5/B6oQfGT1ovLvGxvbDUiPScI7gHgkt4zaBOV+2FeeXqr+JVJhoS8mq2VAPSSGE+5X
         eZdMfmt0TYdsMklF7ikRoS27B/o3Vv1PjSR8NETkpl9/GRua5PNibWe9aGoetGBcGse4
         ySBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OLgVzX7cJ8A6TnTHJATcG5g8iq8wHaLlYPOOk+LPBwA=;
        fh=A5BFOlfGtNtLLVvovqo+K1m+qjaXwsuvZvBwq/NsLuU=;
        b=nYIWSI++geOkzNvIjr8t0PciXJHXrf7h4DXCNpwAucxYEnRXfHwAibrdDfLL86W5pm
         RtbM+D2h3Ix1rO29381KsJEablNrRXx8TmxpwMb0R8n+ljW3nBfz6goPrHUn3K5ShlRr
         1csuBpfFhWSPhDNAqQjQM9oToype03vfmQfN0/orMR+8q+Tuxmr9gXF5yZ0OqDEce9lw
         p6depa/9MSGaVbHCyCuFrEkhqt3M7I3pfC9bG9QzSYvw7RdcADw9zdUVQ/C0+gT6opjE
         RuI3k2mNDXoOzNR/PbJyeNzdGsjPzhUNxDt4GWKoynCGGZVJOcAHo70NE/Oq5hvzNPzZ
         NGwA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789143490; x=1789748290; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OLgVzX7cJ8A6TnTHJATcG5g8iq8wHaLlYPOOk+LPBwA=;
        b=IM5H/4T2NuiGsBe8v3wnUXpveoqqMag62B6HTg+tmsxSb6GdxDJ4uxUOhkjgULTa21
         /fOsWp0BNAhMfppiukM7MReUK/opdzXokNS9OiVVul1FkbLNGXRbM4Q5llXgAvsRVQke
         3e4AsYK2D4a7Sb+cIch3LAnbyFqUwAXjVlQtXTyqM111sSmAEfUQYtbHC4nR5nMCFRKe
         jwvrodQN3yrAYNtAHMDfsob13yexJs/mUvjcR/v2EnO/fowRdRRUlFwJhgGe49716Gde
         SizmdzvCnPKx706fEOapOEsvZ06cke1NB/nVRcpjBddSxvEbUNWiAn3Ob0LE2t0x4Vxn
         Smfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789143490; x=1789748290;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OLgVzX7cJ8A6TnTHJATcG5g8iq8wHaLlYPOOk+LPBwA=;
        b=JRERxhibKK/yDubsH0ejsf0jWkdAvdY3MtSbSsI4Qmjwt64177IuJ5kziEfViJoKg4
         hyU6CuLpWgz8i2nyGihCmjnV9WNPKi4nqi8/06l3V5yAnIfn4jW/71jFVLW/51q3wGcg
         AvswwN+/SL8WKd5vZzprLYmu6gOq8FUsMEwS3cjmLZbZRpPlcO9kOjLpA/Cd/pW7PK+K
         dJfRxj32NyVBN9b6SVD6pHcbgJza/nrUJ6kzeNJPjUurqIcGNHbZGqzAvVpj1ria3bCH
         rj86Hfy5uqrH8Tmm1YgQPeFexxfkgtOBrx2CmAxgoll+hFCo40vpeP/HBcRbR6gnlmQo
         B0TQ==
X-Gm-Message-State: AFuF++kZ873HXzxJoeTbpxbCXtuyJfqTaGDmjRA1OKCLBoFlvaUQmO5M
	isoNcC2uvCeFpNOQOWsgfDUZhfXcztsILWEvWb1zTc08CeYUVSLtuWy2+MwugWhUMOxWGHHQ68S
	gaYB3kaUjLUNDKN9DCAqL1ZYckMkdNMg=
X-Gm-Gg: AYBFou1Jg9/yFEfpIn6UnAgWSlgID2kuWxJkEYceDd3E17K9TwZ7TXlFZF3rdsdRH2t
	UIrdQzoMaPTVrTBJ4Hr+DU91vt8M1gkTL4zlpWjN51RkQ0dGxi6lDtptgErKYsdeyH5mktHJJS3
	Uwo7I2iyUtAj+VbAQnjuChBPaT8HbeVwJ5lLBFuOMmQ74GU/Uhv+0q8YZ1HuKruR29EflGjJ3i3
	mmCC2K5mRXfSPaQx20qg6BrnYADdpuwCKeJJ1rZCq3N9q8oD2t0i3VoUYzdr+2ltPi3bxCDdhTK
	903cvas2Nz+SF0aZCjNEViKvpDie1JAkP09hCnyADB18QzWCOVPDSW8HTJzDHXrkzS+QNpFYr8w
	HDxFRVhwbzDqxQBm4Bmv8a4NkdiH09gnzAqwOkHMI4YNoIfYopNDg/VQ2XLoSYIWbCg==
X-Received: by 2002:a05:690c:e1cd:20b0:878:cee5:989a with SMTP id
 00721157ae682-8820475cffdmr20331837b3.22.1789143490194; Fri, 11 Sep 2026
 09:18:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJF5HCtEvb-aiusJuzmCvu-db4orDwsSnG+mOfCbLXXYRCbtvg@mail.gmail.com>
 <CAGb2v66bvMC9wU9gYknRdM+0oG7UcGquHCu5KYiwJjWZDRtk1g@mail.gmail.com>
 <CAJF5HCtAVMbarNYDkrKWE97Lib+YJk8ZE+5eWsEZ4fKVTp8tOw@mail.gmail.com>
 <CAGb2v66-ee1n9E2-GmFZu02HRmFFWPQ1KB-L9uPQcq1i5HSpEw@mail.gmail.com>
 <CAJF5HCsYhv-JTMvXRHLesuOFsVFnySqEKWYzK6_B-bWEoAEW0g@mail.gmail.com> <CAGb2v65qs7NkSEL8Zg3x8a8aytV47uauNo6gj2XMi7_FfADz0Q@mail.gmail.com>
In-Reply-To: <CAGb2v65qs7NkSEL8Zg3x8a8aytV47uauNo6gj2XMi7_FfADz0Q@mail.gmail.com>
From: Ibrahim Hossain Abir <xbowpc@gmail.com>
Date: Fri, 11 Sep 2026 22:17:57 +0600
X-Gm-Features: AcwNN1V1s8Bug5fpu0aUQKgRcYXiLeYAXhxY6a21MZnALR5m60X_5m7b6BpleX0
Message-ID: <CAJF5HCuoBLW90qt1evG6U03HAhZaObkLZK2pTNQg-f2Qz8AqDA@mail.gmail.com>
Subject: Re: [PATCH] wireless-regdb: update regulatory rules for Bangladesh (BD)
To: wens@kernel.org
Cc: linux-wireless@vger.kernel.org, sforshee@kernel.org, 
	wireless-regdb@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi ChenYu,

I wanted to update you regarding the clarification request sent to
BTRC (Bangladesh Telecommunication Regulatory Commission).

Unfortunately, BTRC does not publish explicit EIRP power limits in
public circulars, and official inquiries regarding technical
specifications remain unanswered. However, the 5925-6425 MHz band
itself is officially authorized and legal for Wi-Fi use in Bangladesh
per their official circular.

Since the frequency allocation is officially valid, could we proceed
with applying a standard conservative fallback limit (e.g., standard
ETSI/ITU LPI rules of 20 dBm / 100mW) for the BD entry in
wireless-regdb? This will allow hardware in Bangladesh to safely
operate on the newly authorized 6 GHz band while strictly adhering to
safe international power boundaries.

Thanks,
Ibrahim Hossain Abir

On Mon, Aug 24, 2026 at 2:18=E2=80=AFPM Chen-Yu Tsai <wens@kernel.org> wrot=
e:
>
> On Mon, Aug 24, 2026 at 4:16=E2=80=AFPM Ibrahim Hossain Abir <xbowpc@gmai=
l.com> wrote:
> >
> > Hi ChenYu,
> >
> > Understood. I have reached out directly to the Spectrum Division of
> > BTRC (sohel@btrc.gov.bd) requesting technical clarification on
> > explicit EIRP limits and standards for 5925=E2=80=936425 MHz.
>
> If possible, could you ask for status updates on the 5 GHz bands
> as well? You intended to add them in your patch.
>
> > I will update this thread as soon as I receive an official response fro=
m them.
> >
> > Thanks,
> > Ibrahim Hossain Abir
> >
> >
> > On Mon, Aug 24, 2026 at 1:39=E2=80=AFPM Chen-Yu Tsai <wens@kernel.org> =
wrote:
> > >
> > > On Mon, Aug 24, 2026 at 3:23=E2=80=AFPM Ibrahim Hossain Abir <xbowpc@=
gmail.com> wrote:
> > > >
> > > > Hi ChenYu,
> > > >
> > > > Thank you for the review.
> > > >
> > > > Regarding the reference:
> > > > The official BTRC circular (dated Sept 15, 2024) specifically
> > > > authorizes the 5925=E2=80=936425 MHz frequency range for Wi-Fi/WLAN=
/IoT shared
> > > > usage in Bangladesh. However, this notice does not define explicit
> > > > EIRP power limits, TPC, or DFS requirements.
> > > >
> > > > In the initial patch, standard conservative limits (such as 23 dBm =
for
> > > > 6 GHz LPI) were derived from standard Wi-Fi 6E/7 spectrum norms.
> > > >
> > > > Could you advise on how wireless-regdb prefers to handle cases wher=
e
> > > > the regulatory body approves the band without listing explicit EIRP
> > > > limits in their notice? Would setting a conservative default (like =
20
> > > > dBm / 100 mW EIRP) for 5925=E2=80=936425 MHz be acceptable for Patc=
h v2?
> > >
> > > As previously mentioned we cannot accept random limits without justif=
ication.
> > > The regulatory body needs to specify limits, or outright state they d=
efer
> > > to some other standard.
> > >
> > > Please help reach out to the regulatory body for clarification. They =
should
> > > provide the information, otherwise folks doing the certification have=
 nothing
> > > to base it off of.
> > >
> > >
> > > Thanks
> > > ChenYu
> > >
> > > > Thanks,
> > > > Ibrahim Hossain Abir
> > > >
> > > >
> > > > On Mon, Aug 24, 2026 at 10:38=E2=80=AFAM Chen-Yu Tsai <wens@kernel.=
org> wrote:
> > > > >
> > > > > On Mon, Aug 24, 2026 at 4:26=E2=80=AFAM Ibrahim Hossain Abir <xbo=
wpc@gmail.com> wrote:
> > > > > >
> > > > > > wireless-regdb: update regulatory rules for Bangladesh (BD)
> > > > > >
> > > > > > Update regulatory rules for Bangladesh (BD) based on the offici=
al BTRC
> > > > > > (Bangladesh Telecommunication Regulatory Commission) directive =
dated
> > > > > > September 15, 2024.
> > > > > >
> > > > > > Enables U-NII-1/2A, U-NII-2C (DFS), U-NII-3/4, and lower 6 GHz =
(5925-6425 MHz).
> > > > > >
> > > > > > Official BTRC Notice:
> > > > > > https://btrc.gov.bd/pages/notices/6922ee00dbfbab28ce0c438d
> > > > >
> > > > > This only says that the lower 6 GHz range is allowed. It does not=
 say
> > > > > what the power limits are, or if there are any other restrictions=
.
> > > > >
> > > > > > User Impact Reference:
> > > > > > https://community.intel.com/t5/Wireless/6-GHz-Wi-Fi-6E-Not-Dete=
cted-on-Intel-AX211-in-Bangladesh/m-p/1740885
> > > > > >
> > > > > > Signed-off-by: Ibrahim Hossain Abir <xbowpc@gmail.com>
> > > > > > ---
> > > > > >  db.txt | 8 +++++---
> > > > > >  1 file changed, 5 insertions(+), 3 deletions(-)
> > > > > >
> > > > > > diff --git a/db.txt b/db.txt
> > > > > > index 0000000..1111111 100644
> > > > > > --- a/db.txt
> > > > > > +++ b/db.txt
> > > > > > @@ -223,5 +223,7 @@ country BD: DFS-JP
> > > > > >   (2402 - 2482 @ 40), (20)
> > > > > > - (5735 - 5835 @ 80), (30)
> > > > > > + (5150 - 5350 @ 80), (20), NO-OUTDOOR, AUTO-BW
> > > > > > + (5470 - 5725 @ 160), (20), DFS, AUTO-BW
> > > > > > + (5725 - 5850 @ 80), (30)
> > > > > > + (5925 - 6425 @ 320), (23), NO-OUTDOOR
> > > > >
> > > > > A reference with the band and power limits, as well as any other
> > > > > restrictions like DFS or TPC (andif TPC is required, what is the
> > > > > limit if TPC is not implemented) needs to be provided. We cannot
> > > > > put random numbers into the database without justification.
> > > > >
> > > > >
> > > > > Thanks
> > > > > ChenYu
