Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793772898;
	b=dN/voTlt6OVhI6zz/wNXSj513KUO4hYUkJzH9f5WGOlT4lfQC6gqA1ZlEOQ8iO19LVem
	 v2ifMCQxpniL8QrEB/UuUn65ysX6Nfn7ShhSWkv4bFsAeEWH42o5sfUcb/+TJHGx3Uynv
	 aKoJFwTfcsROLeFnN14ETDyCXMA0uE15+OGM1xvDMRf/REsxuS8Yw3pxl4W8ND3xWZj6C
	 V9TrLNjW7FySiQGmq0IwSuqDdKNBRsnW+F+sBkVW6/tQcUjkZOo1hsIXq0ouHXf7Gcz81
	 S/wWNDtr6UpEw9zdkiwXhasR9h2g8yqf5HFgvFaI1PbHiGCChZmV3Ec8LWIefdKeQAA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793772898;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=WXtfI0CtVUis1DTLl6ZkWUkR91YI6KmmXqM/+fvN/qM=;
	b=zU9bMWHmEebvslWGG3ZuO1kteHPBJSUNrLSjf7eLM0e2R67MDbfoy0c920jjdXnIrJu+
	 rsBNnqG9PiAIN32QtLOUpEiMfR3CoRUVH2C+BDKlCH+4cyrWphcTucK+ZDbTXQHQ0xpxR
	 xtwPN6ODedm/Hw7bh63vhCy1UxaVpihKu/3DhvSjhP6z+orQwalJSTa398VUD3s9H3hnu
	 oAqyCL92/fJDHxBT4V2AgGnwRW6VzOlSJ6Byth6S44k9uox/BC9rNZvcuwJ0qXEvgPzJn
	 m7uoevbQeVN0Kn6rBpy38gAZtK4gVf8QOZ/Qm1qeCvoSviiPaZS6qR4N5Wn4LbToorQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=O5V9G3Z8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9B3606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 06:14:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F9B3606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=O5V9G3Z8
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6ae305e3bd9so536819a12.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 22:14:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793772896; cv=none;
        d=google.com; s=arc-20260327;
        b=l0rmdTiX0Sf5RYgNGb9xBN+V6NWtyImqjpoKtaw/zuoW4hbPxSkaeodpa3Dz6LbZU1
         6/TiYCLwU0qlX1H6LWusXWALtFHHauw6tlKwuc+v9hl4GayJTpAlzHDrvbpWAe2oTkRt
         BEoJIA7F91RfIpO41xT9FxeNXGzQa8gCtx4SipS+UJgoUImv4Nji+7QsW+ZZg7jmgM26
         aoN9K17TROx14giXk8Bn/SeaUCrcbq6TPB37MpenQljH1qwljpBY5xEvBHf694mQz/sU
         qOk3PSZhAFjQP58I/0lo33nZH32v1Dbz3qPs8ZE3T16MHVXUPTssEu1bolMb3kJfkNjP
         w+Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WXtfI0CtVUis1DTLl6ZkWUkR91YI6KmmXqM/+fvN/qM=;
        fh=tA/qOmjbHMAFsRsDEhDLXK2o0U0MdkZ/FQgef05ZCVc=;
        b=URmZbz43TXrBm9PlmPAFS4neiI6JealH0PlY9Fh3fLZzWoRiH4cBaTal/fec6BcMkk
         ImYV81keur0NhE6Dq6TOp6Ki1ub3DsjVMPMzOpkOBXih/RTYmXXYUPyaofb/PRcu4Mrt
         /LXSC1GZIgUlrs580PRVit8j1GVg0e/yKTSHti2X4ciIEEpNcPgmj6MC+1fgjUxUSfJZ
         +OjGGUD2i8HUB8BELekc/QTw9v8IYpHP808sqKauHCO398wAmDzVLNZnrUs6tChDJ6IJ
         ddSmZbwLWPurFv2/dZwfjQDcxR0IyyUCx4F8e2q9N6441HDiGLjgkNqswTtG4lgeRnYY
         cX9A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793772896; x=1794377696; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WXtfI0CtVUis1DTLl6ZkWUkR91YI6KmmXqM/+fvN/qM=;
        b=O5V9G3Z8P+hZrzxtaR5wh4mx+r3d7HqKen9KoLNKmpLsaYappQ57NB4dhMhe6Ji3cI
         mIG+5HfgJUMiw6hEH2jVPyvkiNYrc5FXkpUwjhPMg6jebi+EtQ4H6Jugu8o8YEwdrdJG
         ucMo3Wcz6H4X8enRqO/M4/Kut/f3wYaN5LHuUrp5Nd7tW+NRi1MqSyyEJ08kMHTjQGuo
         bFBU9vLvynCZcj3SR9x/RpKBWoCQFbNG/vOAL2zOkLgAi/kPFp0hP7CmbbjwDImdS8ev
         NnGVAlXrcW43CXsvh4qt2PbIchrMG4Lq7qbxt45I57m6OCLg6wKMplwJSsXhdem5pUPA
         6U/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793772896; x=1794377696;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WXtfI0CtVUis1DTLl6ZkWUkR91YI6KmmXqM/+fvN/qM=;
        b=CUVDxNG5Io0vELXHu2kVTQzab2kYgZu4r5Cfp8mG2tRHZRNyTyFLmQeuxwNIhSHY0H
         lr0qrWHoPdr21p6g7d/CAHYdWTc2iLPoqbinUjaGKlBHvgRsP8u2SdX4BrvzeMlxZ8Yi
         SvIiwz0OJi0ppBxGs6qQxUz+EQTkwsJP5AytCfd5cge/F4qyM2TGhpL5XxY6wvsDAgup
         rr2HUVD0nX70aFhpAQ7o3Y1vIWkHjP8gfIMW5supL1FC/H05vhJM4N+vrRVnSLErNvIY
         rJYaA9Dcz5Ry66rcYMUTjJQmpYDC4k6m7oT7VS81GBaYANTDPVEwYvtNZtPbEyMBt2Zv
         gfJA==
X-Gm-Message-State: APuU4Z+xKA4DK1ukjvpux+FajOzZRYAUWv0katiawL5FzPGtP09fWyhv
	XzT5cCBbIkeKUnW6dRMo4uvFsAhm4HlRl/Nol23pSyQqZZp3qiM26Qv4+TFkpnAuy3JgD2Lh2oo
	WGGp2lyj9q/nkP65rLM439/251uWOFgY=
X-Gm-Gg: AYBFou1DPaxKUauHH9I0oIPv9Ex8DzaxrKRgesiFBxFqqqLF+q/k+dNcq9+xXt+EKZ+
	5+uIoMQaRwNkIFvWEh4Q9BchhwUfOWkWClMlAQf25cTloS0Amyob2OKqzZOS6xhAiyYlLdmKo/K
	ZTeVIPZfkkPuDg6C1WrmEwAb/wrHJG7jyremfWiFmi8kHx/rb7MVRwAYkmH42SvCh9FVry8/FtB
	9vgFjz4VWSag7L1vSVxGVh6QPQEq/hFvDSMQOGMaw7A47xaoC68tpo0o+dMNVz0GLa9bZhfVnLd
	9ovSW09mVQP/eG2ku+SomfF3t/ZLKD09/NjJLWshLfHJy+5IP7PpXej25e9lhsqNZpNwvft+HfN
	vf3Cg+DGFRwfGRvZ5FipP0GHpeMdbwHpASkW5eW3XpQLBAky5qzKSjUJGE+BawivOL2d+0KgtG7
	VhnByQ+FFKiU9o7PRtXH6H1QAlW/MtEN7AFJEtrxomsrvbgLIwZxH2hRkuRmSD0QWnjUs1X+qjU
	cmSuo9QLAtcLShxz1BBOJLhdmzYa+fNCGkl4OwDtEMVNN2LFA==
X-Received: by 2002:a05:6402:378c:b0:6b5:4cde:9115 with SMTP id
 4fb4d7f45d1cf-6b54cde93f1mr2124654a12.14.1793772896441; Tue, 03 Nov 2026
 22:14:56 -0800 (PST)
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
 <CAKxU2N9OpxoKF6M5rJpNOJ1HWXx8oJ3wXHpfyGGVgQpZaMi+uA@mail.gmail.com> <55e67132a79243cc9e214f9de7788132@realtek.com>
In-Reply-To: <55e67132a79243cc9e214f9de7788132@realtek.com>
From: Rosen Penev <rosenp@gmail.com>
Date: Tue, 3 Nov 2026 22:14:45 -0800
X-Gm-Features: AclHuK-R8dd2PGCMhHI3LZJWK6ZO8cOlM0h83Q1-A6jK8aBloOQEDV_UIvp2u9g
Message-ID: <CAKxU2N_JCRjWXkD8SNGf-LJGOHfCsAMM1JU+AoTD6cfZZYJ03g@mail.gmail.com>
Subject: Re: [PATCH rtw-next v2] wifi: rtw89: acpi: check for _DSM function
 support before evaluating it
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2026 at 9:21=E2=80=AFPM Ping-Ke Shih <pkshih@realtek.com> wr=
ote:
>
> Rosen Penev <rosenp@gmail.com> wrote:
> > On Tue, Nov 3, 2026 at 4:47=E2=80=AFPM Ping-Ke Shih <pkshih@realtek.com=
> wrote:
> > >
> > > Rosen Penev <rosenp@gmail.com> wrote:
> > > > When the WiFi device has no ACPI companion, or the firmware does no=
t
> > > > implement a given rtw89 _DSM function, rtw89_acpi_evaluate_dsm() ca=
lls
> > > > acpi_evaluate_dsm() anyway. ACPI core then warns on every probe:
> > > >
> > > >   ACPI: \: failed to evaluate _DSM e8c3a8d2-694b-004f-82bd-fe860780=
3aa7 rev:0 func:10 (0x1001)
> > > >   ACPI: \: failed to evaluate _DSM e8c3a8d2-694b-004f-82bd-fe860780=
3aa7 rev:0 func:6 (0x1001)
> > > >
> > > > Here the handle is NULL, and acpi_evaluate_object() returns
> > > > AE_BAD_PARAMETER. All callers already treat failure as "no policy
> > > > provided by the platform", so this is only noise.
> > > >
> > > > Bail out early when there is no ACPI handle, as acpi_check_dsm() wo=
uld
> > > > otherwise hit the same warning while querying function 0. Then use
> > > > acpi_check_dsm() so that functions the firmware does not advertise =
fail
> > > > quietly at debug level, as rtw89_acpi_evaluate_method() already doe=
s.
> > >
> > > Adding this check is fine to me. But my question in v1 is that
> > > acpi_check_dsm() checks func 0 to determine if BIT(func) is existing.
> > > Is it possible func 0 not existing, but BIT(func) existing?
> > Shouldn't happen, but who knows.
>
> I don't mind taking this patch, but this is the only one point I don't kn=
ow.
>
> > I can drop the acpi_check_dsm() part.
>
> If you drop the part, what will this patch do? almost nothing.
The !handle check is the big one that silences it.
>
> >
> > 7bf2dfccc2dd70821104d15cbab7b6fca21872be
> >
> > is effectively the same as this.
>
> Since rtw89_acpi_evaluate_dsm() is called at probe stage, I don't mind
> acpi_check_dsm() being called on every call.
>
> >
> > Note that this specific card was taken out of a laptop and placed in a
> > desktop, hence the warning.
>
> So, the warnings really bother you?
Yeah why not.
>
>
>
