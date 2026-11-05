Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793915093;
	b=lPIeHzUaVAPN4fpDnwuyBQDrI92v929UV+RQWe2/4uQeApkmtrJoUmcjpxrPQeoQ/mMx
	 o9g37GZSNx1zEowNeVhFf7MmW450SEHuYpo5ycy/9csjuRUHtwrJauNyA3PyCdPfQWWoU
	 3PqQUdTUjn9MyMcFui00NcEYFxwj96SLuEO7lHIbTzus7v5//yOir6YU5oFKkExVUzH0A
	 ZHSGUb3KUQczbECfnxVyB4YitpF7Sljg0N9J/DK0qoKetqU+1i9yNxAm686LdQbOEGMco
	 kBYTfmxw8w5hPDSFMpmW+ucWUOk0ljmMrj728/Y6ErzDnPe4lCf2T+o20e3wNNPLLgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793915093;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=oHIzt9l6ZqX1+4fgIF4dpM8hMXfpU4Wy6+rPpNQD3cg=;
	b=Gnrd6hNQZK4PtDnQ0L7+9SLkQGysSccoEDzBYB+TyN/NRI0H0Dy9I6BRMjzPw5Xsvpzq
	 51hYejcBRhkqoEVkU7smbW5sqpuBa3kkeV+9jgkAi5SyLueI6nLhNQdB95IdEOATAEnoi
	 ERQOxlM3nsRySslSAv5IZbac6R7nXMC0mQGMPR22E5Y/FrApo0LJdojcDDyTpDat+fOLy
	 nfUzvgYrSffP0ThNU+YWeuKkHRq85sep1QohjJDxntrR4ziebcyQQQT3q1uTg0GtxL5du
	 grF7wIkiTFNZTk1H2pwTK6YQpXK8uywVn6hcFdDSXHYvUDXhprL7GFMO4beYF17xf2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gompa.dev;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.161.49
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329EA606A329
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 21:44:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 329EA606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-6df5e315bd1so38931eaf.2
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 13:44:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793915092; x=1794519892;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oHIzt9l6ZqX1+4fgIF4dpM8hMXfpU4Wy6+rPpNQD3cg=;
        b=yfY6jdQutnuvKtxMvfEHVRvOH8T675IHP8OUQqytcKy76oqbFgWvXJxSpE7VEox/xo
         qIK6hQdMhW31TvRHBDMsAjrIXopeiag4hnjA/qehfzvHfWCM1Xi+h17c58ZabQf+IXsK
         SLocFQ1LK4Am1KfZ+1KIfOTSFKPq007nZvwkIOZhyjEW6mVz2lprTOfZo+aoagghewCZ
         EOOt6DxKK4gjCrAkyZyyR9qiHEE8fcQvbvSTjaODZrKunviC+X5NXlcSsUJTy8peuXRE
         YXB2J+rgFZn2HBid7REfdjNtmi22U6dYff6yS/OjVphu9s6kogKqmmGCb2J0JQ9+bL9G
         7byQ==
X-Forwarded-Encrypted: i=1; AKwUvBwXql1BVEAqLaKOkCM8wlNVRk7Hh3b3XEqSYGWuGcSM7I6TzLGQlaly3O8USSPw7Z3XEfA+S0c5qlBijCRFHw==@vger.kernel.org
X-Gm-Message-State: APuU4Z9k3eE7+nywuFaX8wtmRXt7jBMbUBVfBqOnZw4CEvoMsBzUUB2G
	Lj1dh2vaYvz3nZvaJ5zHA4hCCFF8rQmrqc0e253n1IVyO7jtztptg8wtNABO6Lf2
X-Gm-Gg: AYBFou2ZuTM+tLb7g8LF25qT5FHK6JFEw2m/ogUyJNYRqtHCjkqL6rhUXWK8UlN+VV3
	JzRW3bwm80JDDTLluVKgN3lLuMBXhuCZGqrQ+W9TZQ40k9nCuRMG0kcb+ArEjRabXs4e9siQOxg
	jHfUq4u46gWRotMYamZOSUd+JRJd3yy9DxmCV9sFiY/5drlRRTyF7dhe51cpDyv0nV7lm2wzUnQ
	pY58AJdvNeHSe1scR3v+gcM84md9p3Gtnw1JvXmku8N3BGN2hQjGdAvrkCWKSDBUz4A5lMWu5TH
	MIJwpcdBbMYQ5/pV5SqXGZwG364W8FxCmf4DOnk8VjnhXXkDDrLwCBwm2zs+zo7rrLlnCB9uqRA
	bnn2CF4lKTchJMSa9wJtZYn7r0GPgfIFygm7TxluC0TeVCskJH1sjCIFnRILWuTBfbtSL/qwkpz
	zaBfcZrpFUuI4hir2WL8LzIFLqvCkhU6BrGsPoThKKq0YCiU17RIruYtCKIZufNiOhXJFMjGvwh
	vKFA2oLrLifFXr3sQJs6OFCMnx18H3RBXyhdJL2DmvrmgJudnlveSyaaPYQgDc6WltIb9imqErd
	2Vbp8je1hGES8fxyWUcvZ/zCXh0jWeBhJe3wVPhfE014f7DqlOwE5R0PIJ0Xxi6EthW5M5zbblP
	4DQNC3irVOr1nmaA7olF4pMRp+FvJWzoOeJGSZcSLAJYfzK5q9xdU6jFakZNo1AGNfabqzUop6a
	4=
X-Received: by 2002:a4a:e90b:0:b0:6cd:3fdb:fa69 with SMTP id 006d021491bc7-716e7abb984mr612623eaf.84.1793915091984;
        Thu, 05 Nov 2026 13:44:51 -0800 (PST)
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com. [209.85.161.48])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-716e99465dbsm403634eaf.0.2026.11.05.13.44.51
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 13:44:51 -0800 (PST)
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-70b875f6f13so60308eaf.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 13:44:51 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBylSxe8AwtvZVuwb2KYoRdvL6rf4WWZ5BIS+LTbqefZ1efWE1lZ1QqigXwvKEFwkaiinn3IZ4/Oduodaeuu8w==@vger.kernel.org
X-Received: by 2002:a05:6820:4d48:b0:70b:8831:8c5e with SMTP id
 006d021491bc7-716e79aa3abmr562272eaf.51.1793915091517; Thu, 05 Nov 2026
 13:44:51 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20260925-brcm4388-submit-v1-0-b5cbc2cde2fb@gmail.com>
 <CAEg-Je918POdPr-=6Dzpdkx_i+Hv4wxv5-8A3MUDEqC8SA59NA@mail.gmail.com> <1a19d3270b8.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <1a19d3270b8.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
From: Neal Gompa <neal@gompa.dev>
Date: Thu, 5 Nov 2026 16:44:14 -0500
X-Gmail-Original-Message-ID: <CAEg-Je_xkZ1oGsg=uPtCT-Eh8_-TuLEwxEx02BfLiOB2bZyg-Q@mail.gmail.com>
X-Gm-Features: AclHuK92anjNPVWCBzaMzrlLgp2aPs-ERNpv9JXE7UUqwrJIWMbDdlGrpwi1rH4
Message-ID: <CAEg-Je_xkZ1oGsg=uPtCT-Eh8_-TuLEwxEx02BfLiOB2bZyg-Q@mail.gmail.com>
Subject: Re: [PATCH 00/13] wifi: brcmfmac: Add BCM4388 support
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: michael.reeves077@gmail.com, Pieter-Paul Giesberts <pieterpg@broadcom.com>, 
	"Franky Lin (Zhenhui)" <frankyl@broadcom.com>, Mathy Vanhoef <vanhoefm@gmail.com>, Kalle Valo <kvalo@kernel.org>, 
	Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-wireless@vger.kernel.org, 
	brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com, 
	asahi@lists.linux.dev, Hector Martin <marcan@marcan.st>, 
	Daniel Berlin <dberlin@dberlin.org>, Janne Grunau <j@jannau.net>, linux-kernel@vger.kernel.org, 
	Hante Meuleman <meuleman@broadcom.com>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 11:58=E2=80=AFAM Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
> Op 2 november 2026 01:43:07 schreef Neal Gompa <neal@gompa.dev>:
>
> > On Fri, Sep 25, 2026 at 9:49=E2=80=AFAM Michael Reeves via B4 Relay
> > <devnull+michael.reeves077.gmail.com@kernel.org> wrote:
> >>
> >> The Broadcom BCM4388 chipset requires new PCIe initialization and
> >> firmware interfaces. Add support for these interfaces to brcmfmac to
> >> enable basic station operation.
> >>
> >> This series adds:
> >> - Signed firmware loading and mailbox transport
> >> - Fixes for chip identification and firmware capability matching
> >> - Versioned scan and join requests, and extended PMK payloads
> >> - Updated event mask handling
> >>
> >> These changes include work by Hector Martin and Daniel Berlin from Asa=
hi
> >> Linux, refactored where needed for upstream inclusion.
> >>
> >> The series provides basic station support only. 6 GHz support is plann=
ed
> >> for a follow-up patchset after this lands. The driver retains legacy
> >> interfaces for older firmware.
> >>
> >> Tested on an Apple M3 MacBook Air (J613):
> >> - Device boot and network scanning
> >> - 5 GHz WPA2-PSK association and DHCP
> >> - Bidirectional TCP traffic
> >>
> >> Testing required separate Apple PCIe and devicetree patches, as well a=
s
> >> Janne Grunau's port-authorization fix [1].
> >>
> >> [1]
> >> https://lore.kernel.org/linux-wireless/20260915-brcmfmac-4way-handshak=
e-offload-authenticated-event-v2-1-fbb9cc7ac177@jannau.net/
> >>
> >> ---
> >> Daniel Berlin (1):
> >> wifi: brcmfmac: Support versioned scan parameter layouts
> >>
> >> Hector Martin (6):
> >> wifi: brcmfmac: Support newer PCIe core startup and interrupts
> >> wifi: brcmfmac: Negotiate PCIe mailbox transport with firmware
> >> wifi: brcmfmac: Load signed PCIe firmware images
> >> wifi: brcmfmac: Accept newer BSS information versions
> >> wifi: brcmfmac: Support versioned join requests
> >> wifi: brcmfmac: Add BCM4388 support
> >>
> >> Michael Reeves (6):
> >> wifi: brcmfmac: pcie: Report the detected chip ID to the bus
> >> wifi: brcmfmac: Match complete firmware capability names
> >> wifi: brcmfmac: Fall back to RSSI-only default join preferences
> >> wifi: brcmfmac: Use event_msgs_ext for event masks
> >> wifi: brcmfmac: Handle larger firmware band lists
> >> wifi: brcmfmac: Handle extended PMK command payloads
> >>
> >> .../wireless/broadcom/brcm80211/brcmfmac/Makefile  |   1 +
> >> .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |   9 +
> >> .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 368 +++++++------=
-
> >> .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |  36 +-
> >> .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  27 +-
> >> .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   5 +-
> >> .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  18 +
> >> .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 124 ++++-
> >> .../wireless/broadcom/brcm80211/brcmfmac/feature.h |   2 +
> >> .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    | 130 ++++-
> >> .../wireless/broadcom/brcm80211/brcmfmac/fweh.h    |   1 +
> >> .../broadcom/brcm80211/brcmfmac/fwil_types.h       | 141 +++++-
> >> .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |  65 ++-
> >> .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.h  |   9 +-
> >> .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 560 +++++++++++++=
++++----
> >> .../broadcom/brcm80211/brcmfmac/scan_param.c       | 416 +++++++++++++=
++
> >> .../broadcom/brcm80211/brcmfmac/scan_param.h       |  13 +
> >> .../broadcom/brcm80211/include/brcm_hw_ids.h       |   2 +
> >> .../broadcom/brcm80211/include/chipcommon.h        |   5 +
> >> 19 files changed, 1593 insertions(+), 339 deletions(-)
> >> ---
> >> base-commit: 42a9fb3382fc2573e92f41d203b095d9a372cfc9
> >> change-id: 20260925-brcm4388-submit-5cb8d3e6d6a5
> >
> > Works for me and looks good.
>
> So what does "Works for me" mean here. Did you verify it is working on so=
me
> hardware you have? If so, please share the info.
>

Sorry, I have tested on a 14" M1 Pro MacBook Pro and a 14" M2 Max MacBook P=
ro.



--
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
