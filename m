Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9FF3D5662
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 22:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784240862; cv=pass; b=oK2/uYxadLhunMLt0/rVtDpwYPQovHh+rjhPR/lhblLpI3pGON0jT8EqpRawpURANCdQGNvMvp/da3IgMZhsfNfOrO/o1T5/zKhHIBNC+DkgH5a819hgjMsRZzOgjWHLIF/QuU5afpz72/l5KmiCyzvyiiTuFv6jNck4KYJB+mA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784240862; c=relaxed/simple;
	bh=6ZU0yywrvxPHG6hK8bj9GpWMCRYihvW5KONWikHDtR4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bEogK5cxNPubUUUxP0ULuABjAvD+Lk6Q0AAxdxN0FzWS9tG8tErHcCjXFcjRj0gb4Xs4Avv6B0Tnl2oC7GkUFQl9zlH1+ak/zsZSklxPLjYs0sF2/43F3kZf8M5gzuNd8ul7GgdUTpx3QzfArPZm8jE4DJZzYUoKetKFP0M35yo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com; spf=pass smtp.mailfrom=tenstorrent.com; dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b=B7uReKqc; arc=pass smtp.client-ip=74.125.224.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b="B7uReKqc"
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-664db84f074so10400287d50.0
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 15:27:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784240860; cv=none;
        d=google.com; s=arc-20260327;
        b=DX15zbNVRBPD5JmU0cBxxw00UB/hlHWpwoRd0yzNnSj6dUsl/zs7PyA/sVZ2wLHp9T
         uKFr7t7gRYDSmq615oFpEfbuEm4pURsYlIjJvdvWGBG+2frTS0ZJ/Md69cvmoR6lXZn+
         ZVhOCUb/PiCjEssQjsRizmGR1axE6LORUOrllhjdOqU3FKGKB8DvdNuXPvlJWrcPRegK
         x0vMq+IPX3N+Yj4wLFrXcnxl6njbyW1jW7v0M9nDUeaWP3BjXGNywi6+eUq13a9LHQ+K
         VOovSgA8omWHyDl/ILNJdAu9I/QbLDx/bO1wOBVECB0ZuTr04ZHAEjWeWBQrabtKWsJJ
         q34w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6ZU0yywrvxPHG6hK8bj9GpWMCRYihvW5KONWikHDtR4=;
        fh=oGgCq91l/aIPkbMekyGnVOkSkTqBkKdHh7if+P1n3fg=;
        b=F+9fHQivA9Z/RQaKXqtQQLSd0JHtqvGy3fg1kCGNp3AdT2ULkoDKbla18Ef5mKMufF
         oiW7M83qDKf4Apbfo+oZ3FCjm588+z1IAHNJhpHscSd5S79Qn5vYMMpgTsltQm+PQ6N+
         Gi2d8PLF1jypVrl9hMTSX8shx+hDycQeIHhIewGjmKfxcALIOqdXukY+7Mk1s9QqH2L5
         jJ8LNVMM0en+/StCi6uaC/QuCDMVXkKIdgTZQ63FkFL5sE4j+pk2gGhKayOJJAov6gyx
         dWr75Pt3vq3rar7MNFH2v7RteBgA4X+hUAEhuguM0qhF8OXeUJmrEngk0e16eSudkfnG
         9JWg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tenstorrent.com; s=google; t=1784240860; x=1784845660; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6ZU0yywrvxPHG6hK8bj9GpWMCRYihvW5KONWikHDtR4=;
        b=B7uReKqcY4oJJaC/d5Lw5AgCqRE4obs0t/0AKhxqX/OPqpCAcD6jS4g7FOJP9pJ69l
         oda8N4kNpk+cQ43/DYcaTMESqEwkkIL4q6LLaFDtlvOL6ma37FMQ23jmHQ5Zxh3EQUXW
         Zu1t4cdF7My1hJQPySUkMwAweowYJN2zNMWE2sFjNUsrcMGnu48/a5hGKCy+mel8aspH
         rv3/2w6Hl1akqpSYRvboLKv9AzEpiXW9vDoxXnxC7y6YaMWHNWAX3GM/xPV1pJsSvTEU
         g0r9JHGIrIr3TQ11ok+mjHqunli37NYi+9eYzzdKQpMxbmc04Sj8pqLFX8ZBPBsohoV0
         VyQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784240860; x=1784845660;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6ZU0yywrvxPHG6hK8bj9GpWMCRYihvW5KONWikHDtR4=;
        b=PLPk1j9LfI8b5ORLWsh7C7amH9RK6daI1HJtGxWwq6EXAHAxPcdNNEcMq7hsD+F3fz
         F1GdM+oy3S5kHtydOtNjVH5HQm9iI4iF3klVriTm9qqMXb/DUpDpwPhtNm/UnK/umceR
         2Df1odB+pKtmx7ibqzEwVpCLVQOUdphPYiyPvIxaBG5x5iFff85S9QSkbu+v1MUau0PH
         qYNzpdfNc65P2xmb/zT6kC6mN7oIiNiMC8vx4gSd5SCYRkkV2pVOR5E/4Hb0Knbl6MST
         8V8K3pzYQgGf7lyWDX/HeRggLezfuJYyRL/dK3AZYR93qWj2CGGOFBfSuZKVilV+2J+6
         6w6w==
X-Forwarded-Encrypted: i=1; AHgh+RoAPC6n0I8dN4Rf3tStZZ4jtH3EAiUpc4Fy/L4Au02xl0U3I/lMgsFUkGaTQzWWZ4apzYev1+7qOH8GjuvPsA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyGUVroxBzXNM8FgWA2XyXWatRfMlt1DgyIOrnTHkD++eaDLsT6
	PatyA+S8GnEviDt6POWge+1R9D6WlS//tHZ4b79RlpDiwS7j6bBvIlWAnYOu72e8DMVuoAVo2uG
	eIKrSH4pYYI7SMAdjBqxXui6HMvE/kx1z0Gs6uStp+Q==
X-Gm-Gg: AfdE7clG6ETUc4zsHKNPFpKYZAsSfBzlMiqiObiF4AfbtXQHHoVINx2mdz2gVZ37tlV
	L3aYFgB/0v5faeZdsGCTLuw7FHNc2Vx2ZtAcoSUW8oZIFRBYdmhs3hfQxsw6R4aQbSMmKBpbGs+
	Uy1qOtsuSNahPT3RV+C4xMg6TeOMsFVE5nkxodl6yf3snb+Nm/CM1Q8gWR3FLWDtOW66XRRawG9
	+ZaDSPWsNiTsB35EkXLllaiZ0Oj5yanBkSwsZIMDX+MrGOAyyUjSQaMNL80QKmkcGE+Ao7gVoVw
	UTOh68D1ny9gLHHBSg==
X-Received: by 2002:a05:690e:4292:20b0:664:ae6b:b499 with SMTP id
 956f58d0204a3-668134128f7mr5521399d50.78.1784240860157; Thu, 16 Jul 2026
 15:27:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715-rtw89-spacemit-k3-v1-0-e577bc63706b@oss.tenstorrent.com>
 <20260715-rtw89-spacemit-k3-v1-2-e577bc63706b@oss.tenstorrent.com>
 <e7a43955e41c4dbdb864e89edc3d9fe6@realtek.com> <allZOmTRIvot39Gj@inochi.infowork>
In-Reply-To: <allZOmTRIvot39Gj@inochi.infowork>
From: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Date: Thu, 16 Jul 2026 17:27:29 -0500
X-Gm-Features: AUfX_mwxPqzyWp7O4WLTTM2K_5Fn9GaDNvcy6d1xA8kFX3CnozHTqWZXOkjwN2k
Message-ID: <CAEev2e_QaaGmc-fSd4dWQAm2YOqOmBDn-xi1coWrAnoh0JUqRQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] wifi: rtw89: pci: enable 36-bit DMA on spacemit K3
To: Inochi Amaoto <inochiama@gmail.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>, Bjorn Helgaas <bhelgaas@google.com>, Yixun Lan <dlan@kernel.org>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>, 
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"spacemit@lists.linux.dev" <spacemit@lists.linux.dev>, 
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Inochi,

On Thu, Jul 16, 2026 at 5:24=E2=80=AFPM Inochi Amaoto <inochiama@gmail.com>=
 wrote:
>
> On Thu, Jul 16, 2026 at 09:22:17AM +0000, Ping-Ke Shih wrote:
> > Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com> wrote:
> > > The Spacemit K3 Pico ITX Board has a RTL8852BE pcie card behind a PCI=
e
> > > root port, but the SoC doesn't have any 32 DMA addreseses which the
> > > rtw89 seems to use by default. Enable 36 bit DMA ability that the dri=
ver
> > > has when this particular root port is detected so that the driver can
> > > probe on this SoC.
> > >
> > > Signed-off-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
> >
> > This patch looks good to me:
> >
> > Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> >
> > But I wonder how this patchset goes via which tree. I'm happy to merge
> > them into rtw tree and then wireless-next tree if people can ack
> > patch 1/2.
> >
> >
>
> These IDs are from my patchset.
> https://lore.kernel.org/spacemit/20260709040027.958400-1-inochiama@gmail.=
com/
>
> I think Anirudh can move this ID and add them to the pci_ids.h
> directly, And I can adjust my patch to depend on this. It still
> needs some improvement to be merged.

Sounds good, I'll drop the dependency on your series and just have my
series add these IDs to linux.pci_ids.h. I'll send out a V2 tonight.

>
> Regards,
> Inochi
>
>
