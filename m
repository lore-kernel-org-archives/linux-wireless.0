Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793220910;
	b=F54cRQ/D75aOKnhMuhqMANh+7kVum4KDvnUNRWxlays4TeNcXCjtn6m0+uisZOx+XYtu
	 b5kiK1+N+G5VtP0NAPyZF57Ht0sY0fOVXLd7fDJq+zCIZJsRezyibhbVH0Gzw4rTSzDaH
	 xcM7fNpbIC0tNZhzejxheF1fg18HgR3Zo1AmN/MDwjgaAQIIq0vOEvvZqdbf65Pp3tRxn
	 SH9FFEYSnOEorGRqtHfbWqhfoqyI2zN4mwpjtzLjFVBo1/0552/cVnLwbdDTgEQUSXSzH
	 ENxSoY3sw7ciO2qNw00fzFLLZQ1shRCD6GAB9Pod9hf4OPtxoXDSqdmBMhq/QzOeNWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793220910;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Message-Id:
	 Cc:Subject:From:To:X-Mailer:References:In-Reply-To;
	bh=YJGCZGrXuYKSbtbthGQ4UJ9HIhPS+IvzoBo7ywSwUhA=;
	b=1dbOPUfq0QBW6wviCN5PHlBLoh7GBY37WyBIx2g+Sm9xh2esKUjr733lIPFHF2EHrncX
	 XtYetnhWOQ33JmjSFitoH+ScLK2Cd4+A5u3U+sIcc3WOGKUwzL4tQKnXulYgkkSXrVxTE
	 8LsEB5IjwDHmz3KiwvrcfXCK06nV4tGhM9NaEZSAK1/ozvFmA5GjZVHlWKnlkO1q9Da11
	 DLwGAXFX2k7WeXTED+VwDz77c3ZXV8+Qj1/9+QTw6QR5/iYfh6WGdFPKgbptL6pzVOekT
	 svp5pQOHHzLJaq1A/kUKkNKTRFwkQqLpd+ts94M36HuxLdV5v7yPMl5MenOh4pnQyLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Dt4JdHdW;
	arc=none smtp.remote-ip=74.125.82.169
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61F9606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 20:55:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A61F9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Dt4JdHdW
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-35829219da8so123010eec.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 13:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793220909; x=1793825709; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YJGCZGrXuYKSbtbthGQ4UJ9HIhPS+IvzoBo7ywSwUhA=;
        b=Dt4JdHdWU6gJbTpnpO/z6abmOYp4Bg5hSvmUPGjVCAbj+rCI1NQKHvl6RMNd4Guey9
         xX1Cl64RgX1fMYxYmVTOAYX6rhE5bKk+EJsIRDXNPA9UILM5YFLdfeM8sIowiBEXc6iX
         n6vBhYfApF3Mt6YgYlTacEV8q6m2/tJHUazKq+lDFPnC+B4UY+mvI9hgMWdTKiKWRdeC
         nad0HbumcRdveM3AuI3eqA+XzxqS6kyMDX35pe7rxzN25pLSS2FJjlfBovFuumV6EzUh
         piB9Yi0hxgX8rz24OQp326Jn0hsv9FASyFY7o0ulaIQsjvQPAdOtwrm06JEe/N8Q1x/F
         KmBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793220909; x=1793825709;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YJGCZGrXuYKSbtbthGQ4UJ9HIhPS+IvzoBo7ywSwUhA=;
        b=UrPDXqNuDp9sdc91hhJ57dG09hCHh+WteIgsmurO9zlp3q8kFsrZ4vSx7j1z6ggAVZ
         uVUx9/E5Qp8U0d6xEVPCq03eUyI2NFI5nBwCbWq38xDxlTPzReHTO3LDbc0jQU6xQ1AY
         1qA45GfLCoRuG3bQiKY5kGy6nJQPAA64qPLekTPKNeiCyn6RITDC1ma6iyn1ENXyY6Xv
         6M2mJFmF1RsQ1d2ak1nyxaV8WDp+KGfUiNAMssZLLhVNhjgYe9D7CSWIOgrPov19xIyF
         qA3QPz7/e+2LV0lPqFj0jNivjOT56IfcEdqjtpD9UrAd38lm7crkkXJTUeN8DLlknYh0
         gy5Q==
X-Forwarded-Encrypted: i=1; AKwUvBwU5va/oPnxd6vV3R1I3owipCPnF8d3UflH37FTi0lr6dNIGBzLx/CMEoUBHn08VngzO8oM9K2AvQWcSIal5A==@vger.kernel.org
X-Gm-Message-State: AFq9FYIVuMAd73f7SlkDX6L1LTlSGMRa7Q+0QqbpfYroKZD/YAcLmCed
	nZv7bcvrBKnWpoOTQofaFK7LzNWG4GkFIAkLyNEcj84By4r4v45A6lsc5Htev0ZvRwQ=
X-Gm-Gg: AYBFou26VHSKwCE80MJT5wye5pk9rWvzLRWxnv9XnlKihRYk8Rr8nzyB5keOXDbnMql
	l1aSdvzild2Pc9L4s2P2Etmk1eJlvm3mlUTyHT67S6lrX9UwtsXIAAhbbtNWkNbFkUxUUjG7iNy
	Svm2QAnPtX+SgAV5OSaLwnzjb68CAcnVEmEzHjusjsMfJAdrodSm93Cf67mG2w1PGgcjnxkVohZ
	JpZh7WCCM9QqxC0DVBUtMVrUyDX2q2BmXclzvccjCAbKfl575GCNaBz4Uwo5wvyST8N98J7ZYON
	W4/sP6CyutPB02f6oY/TiMiu3+vlKRzD1Cm6GwFHxTFrPhXsTDO/QHVeV39Ms4vJSLjYzaiNnyg
	ACRKL93bhB+VFLD8z6/17bZL9nHr7ty0oDQHaE/zRuD2/q1uxLxxv/VBoDhMohFNuKRvnioDNqx
	yN5BcsSvowoBXLstne3qZHy6zB/sxvxPYH9R9VpsHYmTCczrl4gZUeh7jaT7nAZUkGmNrlakIbj
	WXX5O/0FJ5QeABU45mUPBJ1mph7eX6SObPOkvE4Rc4qebHuELF8xUGZbPL84mT7rsC8cFWaVNV5
	pGoBzNR6PUOIgpWVI9+j+sjklQZBsyGS/ng=
X-Received: by 2002:a05:693c:820a:b0:361:8d0:6c7a with SMTP id 5a478bee46e88-36a300a4eabmr779804eec.26.1793220908456;
        Wed, 28 Oct 2026 13:55:08 -0700 (PDT)
Received: from localhost ([103.89.26.203])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a237be80csm20679864eec.2.2026.10.28.13.55.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 13:55:07 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 29 Oct 2026 02:55:03 +0600
Message-Id: <DMGRRA9L08L3.1IM2GZHXGLZQ1@gmail.com>
Cc: "Ping-Ke Shih" <pkshih@realtek.com>, "Luka Gejak"
 <luka.gejak@linux.dev>, <linux-wireless@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wifi: rtw88: allow key removal when the CAM table is
 full
From: "Imtiyaz Parvez" <reza1234khan1234@gmail.com>
To: "Hungyu Lin" <dennylin0707@gmail.com>, "Shagor Khan"
 <reza1234khan1234@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261019165103.5990-1-dennylin0707@gmail.com>
 <9bde49a2e7794e4fb6bc3ae104eef87e@realtek.com>
 <334c6e785a5d242c6f168d57d042d63b777a242a@linux.dev>
 <4f48c50cab1145fd9dbd6df6d424c877@realtek.com>
 <CAGEkeHevidTtTNj-qfy6kE_O0wRvqT=F=sG+Hy83BOkRjCUqeA@mail.gmail.com>
 <CANQ=N_C3+gpQ3O=SXYpRCGTh_MC1y4TEfnxF90SWgUVF_wYPUA@mail.gmail.com>
 <CAGEkeHdT1-WwJnF1wTkrrRQRzrEYESOoDeAYE+fiV0gROG+6sw@mail.gmail.com>
 <CAGEkeHf0CLjxhGySt2axf8gXMrCcn=cEHbe1aXRW4FgcbxjyZQ@mail.gmail.com>
In-Reply-To: <CAGEkeHf0CLjxhGySt2axf8gXMrCcn=cEHbe1aXRW4FgcbxjyZQ@mail.gmail.com>

Hi Hungyu,

> Have you had a chance to test this patch?

Yes, sorry for the delay. I tested it on my laptop.

Hardware: RTL8822CE 802.11ac | kernel version: 7.2.11-arch1-1

I built only the rtw88 modules from the v7.2.11 source
tree with this patch applied, and loaded them.

I used it for around 2 hours with normal browsing, suspend/resume and
reconnecting. No new warnings or errors in dmesg.

Tested-by: Imtiyaz Parvez <reza1234khan1234@gmail.com>

Thanks,
Imtiyaz

