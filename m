Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.75
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792558056;
	b=qavKBoTFBBMDfN6apxdMIo6Czq93GP8aazSFLlecxflhRyV0eCiU1hR+1jiFXKYoSHlW
	 l/+VHiisvvVpZrcmJFnFc//5N9SbOgj+ybO64twTOhmOfZVdR9T5iRE/tFz316oRz3zO4
	 i0qTiOH/I7uS/R1mKnEq8BqwPKsC7P91GXdRFMzGyFosVSMnet5ksNSKunVtg/Jh4Bgek
	 SJqcpBMubQC6ilKX/HKSiMEbBDLIge4MG0L0yzVE0er7vqx+fs49RG/UWZUpSqfyub82S
	 jQnI+ljdH+Ll1o2/44uRIg6vfp36fPSxsz48CYU/L8EdZO85LlQ+W9aTXwCURql+ThQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792558056;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=K4khWqxme20IrV7RF/K+j++tNXxirG3OYUMGHBtKXvw=;
	b=satIDyd0RNQdvfqE5OBAMqwrYq+7rU10I1mp0vgYQ1DM28VXkbMYTd5zyziJG1nSfc29
	 HaopRuQy48JVuTNttXmlhSYJmZ6RaX8z9Sw6p6A3yBeVNIFGMW9UPfYmJZT25mCEU7zXU
	 3xBqKaPCjxCwBHc6RHr4tIxiJBaIaP+nEjeMIt1qFPqLBaDdpd+uuOunHCjUg/x4Z5ZoU
	 0bQIXdaDD8sSN196A5EidvJmMNGv4t4TUXhtqHDPantPofd5vIX/pu/X0lDoZl65Jr4Jr
	 QO/gXAr6i7LhXWPoao8+YUEAzPdPI5A+yWB91zIJIMS8H0WsoIxzHta3gCT0Ft2UxPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=D8sw8gLv;
	arc=none smtp.remote-ip=95.215.58.75
Received: from mta1.migadu.com (out-75.mta1.migadu.com [95.215.58.75])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C60E606A319
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 04:47:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C60E606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=D8sw8gLv
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=tAktVX5rxfCHRcc3RdNAOLJJmPExxrD8PHWfbSNheCY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792558053; v=1; x=1793162853;
 b=D8sw8gLvc8SdDxE0yHbkTe9ZATZ2F50iFzGHNZWV6YN3pv2RScMYJ/GPFlZc7Ty0XEy3qCRJ
 4rkeJegxyBnxHDnnsCzT0LZ59urfA5bxjnXxM4ioZphjecyJm2VpGsgP3mLXR1beMlj1sfXe0HY
 Yvnd4D1IxXWHl5pcttDltCtk=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3fdb9d13b85cacec;
	Wed, 21 Oct 2026 04:47:33 +0000
X-Mizu-Trace-ID: 3fdb9d13b85cacec
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Wed, 21 Oct 2026 04:47:29 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <bbdb0b32d88cc23641a0da4e2e9aedabf7a77fb2@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next] wifi: rtw88: sdio: limit the high queue to DTIM
 delivery
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1afaced93a78c382447af6c0f6cb209ba872e357@linux.dev>
References: <20261020191542.17207-1-luka.gejak@linux.dev>
 <08bc181d144544b08ed14d78a4fa5a89@realtek.com>
 <1afaced93a78c382447af6c0f6cb209ba872e357@linux.dev>

October 21, 2026 at 6:23 AM, "Luka Gejak" <luka.gejak@linux.dev> wrote:


>=20
>=20October 21, 2026 at 3:34 AM, "Ping-Ke Shih" <pkshih@realtek.com> wrot=
e:
>=20
>=20>=20
>=20> Luka Gejak <luka.gejak@linux.dev> wrote:
> >=20=20
>=20>=20=20
[...]
>=20>  This is totally the same as USB. To share with USB, move it to tx.=
c=20
>=20>  as an export function or to tx.h as an inline function.
> >=20
>=20I am aware of that, but ai wasn't sure

                          *I wasn't sure

 what is preferred approach so I
> resorted to changing as little shared code as possible to mitigate the
> risk of regression on other drivers. I will make it shared between USB
> and SDIO.
>=20
>=20>=20
>=20> +
> >  +static bool rtw_sdio_hiq_take_budget(struct rtw_sdio *rtwsdio)
> >  +{
> >  + unsigned long flags, elapsed, add;
> >  + bool ok;
> >  +
> >  + spin_lock_irqsave(&rtwsdio->hiq_lock, flags);
> >  +
> >  + elapsed =3D jiffies - rtwsdio->hiq_refill;
> >  + add =3D elapsed / RTW_SDIO_HIQ_REFILL_INTERVAL;
> >  + if (add) {
> >  + rtwsdio->hiq_budget =3D min_t(unsigned long,
> >  + rtwsdio->hiq_budget + add,
> >  + RTW_SDIO_HIQ_BUDGET_MAX);
> >  +
> >  + /* keep the unfinished part of the interval for the next unit */
> >  + rtwsdio->hiq_refill =3D jiffies -
> >  + elapsed % RTW_SDIO_HIQ_REFILL_INTERVAL;
> >  + }
> >  +
> >  + ok =3D rtwsdio->hiq_budget > 0;
> >  + if (ok)
> >  + rtwsdio->hiq_budget--;
> >  +
> >  + spin_unlock_irqrestore(&rtwsdio->hiq_lock, flags);
> >  +
> >  + return ok;
> >  +}
> >=20=20
>=20>  This is also the same as USB. Please consider how to share the log=
ic.
> >=20
>=20Same as above.
>=20
>=20Best regards,
> Luka Gejak
>
