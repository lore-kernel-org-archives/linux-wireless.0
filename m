Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD22B35C180
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 17:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785430853; cv=pass; b=ncsgt7hpxPhW5IW1pQR2V1Yt5wNE8kZqJhajzwgitCp+a5mzAoj4ZJIfqVAegBxbm4Fjw+kiWyKJJhEbKFfJNrxx38xyHcZPd4X5DIFAytylyjatRD6+rC+UN9wwBaPzVnwuD+wyaiOdjgBFTIrrr+6m9hECX29UnC4nLSD45Os=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785430853; c=relaxed/simple;
	bh=jDxQFcH2sTQHpPzYvIM7rFgQX0uLnZZ8FJqMsuEklz8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D38BzbI7/B74eKyrPneg1+RR1R7BhdrsvwVny7rubyXHwlpsG736sFrYgeOPMzLUYyHhMqNUh+Ly1q044Mf6Q9S/qOxmRZL673eAGPa52jkOpFDzJksmQ9IoCOCxDrdiZC3iaJO18qNzrNTnqRoiyvBlj+gbwMuePnxTVv29RHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iNFlOtrC; arc=pass smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iNFlOtrC"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-37f9e2642deso16459a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 10:00:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785430852; cv=none;
        d=google.com; s=arc-20260327;
        b=nqleLZt3R3Qq71eZdE6AXTr3MWmpFaT/+BWGTqDscJJs3tLpXnNrAB15XjfeN2Ay2W
         5RG2XWE8Y+xjwa0JlnJ9VBhMoQJJY1X9jvl1wKQabh9KtOps3+EK26jda7eJ0xmxJ9gT
         OTG1aoy9HUqgpjJA635xbxlcl+svZgyCSBSOitZiuAgzI9lu/BjlqzYD70hBXmcR1xkg
         qkTezyhHalz1xmz1ZZGbqTufzU/zwaiwtmHS1MFs/GU7IOvIwURGfFEdmcy81CkTLm47
         FzbSBIUop1PsmENpxr4cBsA11EeNKChIb9rfn+AOJk/KvGC006wCo973ypG3I+X5XT9t
         vDCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SyQbuLv2xvKk7GAqzYBt6nrjCjQYAyz53am5+pvGUO8=;
        fh=+EX6mY6XdfuqWiiTZNdVT5smfPp5qPyj8E30xAHtUiU=;
        b=KRrpxLESOnAv3+cx6o54IfJMJyhmMV5HpiwbH6rTQXUYBx2gkaWR0SKNAW2sQ9Rc6K
         DQlsGzNrdrEvBbFWFELVFCW39wNacagQzhuSvvk/ijIe0Slm/UbSga7kETGttD/OSfm2
         aAZUHkyohK+lwacsKHWVqXQe6uLT+3bzqnCOOm6njsOObzzT11P4IYVEvQVQ4VNSBeCg
         7juA8FenmiSNfqAnwC+c5/B8kIW+2x7sVS7G4X97rR1bQcqEJtWIsud1Llls581c1tOg
         sM9MSUuxJYw8o8Ju49u2NIOvuD/xiI02CqwYGiREuvcj6yF8OFjmjcM+QGVt9O5sa+cq
         +vuw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785430852; x=1786035652; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SyQbuLv2xvKk7GAqzYBt6nrjCjQYAyz53am5+pvGUO8=;
        b=iNFlOtrC1ufZpylsmAbIYNYdM3ANxaGr0HRFN39/6mwHs0FHJG+5kmWDRUQ0my/89t
         tG3375McIdQVlBPyh9Zl/wPhfX6r4pBPfUVUijLw1C6llZbW/X+FxUp8YGuY/bjJs4vN
         gXlAi++886jQ9zaZQzE+w+eukaZq6W5lv0LAFCGJSgLQxFbX3Ie+5K7zGtUH5To1J52f
         UBBP+ccyAzU2BTOzzYJEOVjrV+mcovnKt5JLOvyDtiAygs9x65TPPNz+Oa/oboWN5ut2
         QRa+bNwEkDtv40kL4Yn+MzNtzYF3RW1Hp4LZsOpKY7hf5128tcF+cx39mWteSVJjJTdP
         G84g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785430852; x=1786035652;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SyQbuLv2xvKk7GAqzYBt6nrjCjQYAyz53am5+pvGUO8=;
        b=mR2FO1v8QdfSl9B+Fl9XOf9Xi9yrjnGCFULWPATtYrYWePZ5koaRxkb+BkQ3SCAOZ1
         L8D19kbfX83+i+sALK5NWke4/LeZkbZB1zA3ap1wQhEs9myU3Cu2+tTioFqXIfHQwTVv
         X9Xr1w3LM7WpXgkfD6ArjNbxrw8GCeowLkgJqY1eKv/T8X3i4x7SQCg9xBynb7WGx5t5
         Ad7hyZgzBni3fto2TWxJiJpCYIXQFsI/e+xr5FZjBTznTS5NPgq8VwyQqI+oKNWdDKei
         S0ASVs3aWhred6f3P2KXTizAsPqcuWag0JJlPg69J/njPbeikIPahnQStKOyGxibofVJ
         zjAw==
X-Gm-Message-State: AOJu0YwdcDvWHbJ3Mke13PXqZgkUz1BRtFPIZ4uHRsyaM2o4ESxr81XB
	iWeIPIPzi6hPw38bTE/GWiE9YYEe4/AsC66GQdAS36vdOdpObt7wv0pHCcmmBNnZ9Yf6SNh+vZc
	CrBNuanhL30BLnr+PdYUZsb/ILSqW6VQ=
X-Gm-Gg: AR+sD12e0g6keDU/jEK3Rn7bRXEzZJjBO9jbrsHM93uK4W3f5RxrYImPixAwDcmDB1t
	XorexyneUMWrQWrKE/Q1uYm3kEZVVR83TslgtIA2dm9+uPyalDDLmE6Efos4x3kVTA03sU2vkaD
	/37s1vkX/Gyw4eyAGImhCxi8N+Uuk2hFqKnpLP29P0JnhuoaB88ZhXrwpnvAA3/9fzA/cjKLrJ0
	rUx6FsS5elIggH1WYy9/PWgODwjJ98UfUZOqxSHYf3Ot4DUNB/L5TmNR4wrNUWrUBR48jye95wd
	toF71PtxjR3IYr4ngy1Y95xOhBPj6/mLXepr65sXc0MwoomS9yak9ra162txxS++2N98FTs7m/s
	=
X-Received: by 2002:a17:90b:1dcc:b0:381:bcfb:e710 with SMTP id
 98e67ed59e1d1-38fa8041704mr1018927a91.3.1785430851879; Thu, 30 Jul 2026
 10:00:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730161531.3535100-1-andcov23@gmail.com> <1dceded216618b1d7bb7b79846f15712161f2cc8.camel@sipsolutions.net>
In-Reply-To: <1dceded216618b1d7bb7b79846f15712161f2cc8.camel@sipsolutions.net>
From: Andrea Covelli <andcov23@gmail.com>
Date: Thu, 30 Jul 2026 19:00:40 +0200
X-Gm-Features: AUfX_mxCi3Ut2TO0lg7uVKJMDZZmCrRiEf04FuQr1sIBTD9v2_H2J1-oXrOoOKs
Message-ID: <CAOEJtZHV8HLxe70B7Rugkh2o34Sy9cr26BXji5LWB7b74JTL1A@mail.gmail.com>
Subject: Re: [PATCH] wifi: mac80211: defer AP-side FT key upload until association
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, 
	Kavita Kavita <kavita.kavita@oss.qualcomm.com>, 
	Sai Pratyusha Magam <sai.magam@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

Thanks for the review. Understood, I=E2=80=99ll hold the standalone patch a=
nd wait
for the SMD-transition series. I=E2=80=99ll review how it handles the defer=
red-key
and SW_CRYPTO_CONTROL paths and test it against the AP-side FT case on mt76=
.

Best,
Andrea


On Thu, Jul 30, 2026 at 6:21=E2=80=AFPM Johannes Berg <johannes@sipsolution=
s.net> wrote:
>
> On Thu, 2026-07-30 at 18:14 +0200, andcov23@gmail.com wrote:
> > From: Andrea Covelli <andcov23@gmail.com>
> >
> > During an AP-side Fast Transition, hostapd may install the PTK after
> > creating a station entry but before marking it associated. The ASSOC ga=
te
> > in ieee80211_add_key() rejects the request with -ENOENT, producing:
> >
> >   nl80211: kernel reports: key addition failed
> >
> > Userspace may retry after association, but this race can instead break
> > the roam, particularly with PMF.
> >
> > Accept pre-association pairwise keys on AP and AP_VLAN interfaces once
> > the station exists. Mark only those keys as deferred so hardware upload
> > is skipped while the key is stored in mac80211. Upload the marked PTKs
> > after the driver's AUTH-to-ASSOC state transition succeeds.
> >
> > Track deferred state on each key and scan the station's PTK slots at
> > ASSOC so hardware upload is limited to keys accepted before association=
.
> > EPP peers are excluded from this deferral because EPP requires the PTK
> > to be available before association to encrypt and decrypt
> > (Re)Association Request and Response frames.
> >
> > Fixes: 1626e0fa740d ("mac80211: fix FT roaming")
>
> This is _ages_ ago, so this bug has been around basically forever.
>
> > Cc: stable@vger.kernel.org
>
> I don't think the stable thing is appropriate then.
>
> I also have a very large set of changes in this area that actually end
> up doing something very similar for SMD Transition, and much more
> comprehensively, which I'm about to post, so I think it's better for
> this to be integrated with that work later.
>
> This also doesn't consider the case of failure on HW support, i.e. with
> SW_CRYPTO_CONTROL it just (without any comment I might add) skips the
> thing by pretending the driver said it was OK. Not convinced that's a
> good idea, although this might be something that can't really solved
> better, perhaps.
>
> johannes
