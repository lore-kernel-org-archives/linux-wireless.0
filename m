Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792436483;
	b=YOyWQlzfj5i6AhNbFwL/0AQ2X7P/Tiao9qrfhRDnt1QEq/1lBAZKQBU38fPAJbWwJM77
	 gUlKE52ZeSFsGrmAuTRcyKMlfd/QezsQ263imixBINcr4Sys+aHjv9MvVwHytj1Tj5yfj
	 a3LvFCjTnZU3SvorPez2piQnwNY14xUQq3nq8jRPVwB3oyA42gQrJ4BluZIP79qzrggIF
	 mYwYdMv2prXRFll9TW+nuXGCkceu10haL9ZLMp1Ae/MHKlPuchn9IXA6q+1qwHPev63xE
	 IseqQDiFvEXf99NTpul5rq1qFLdl3YqJfcohEses7WLNlSoB7+gVZOfh2Du6dbobu1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792436483;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=09iLhdKoA+WjgjSiEhQrFgF/+LcrRb1ryygNNtnygEA=;
	b=3DquGN43h/21MbDI20HamDCdPCD2PLRujBxxZ69ZtpC5WwLbUv27ZwwQEJ7i8R6EkUoX
	 ddQ8sEw8JSRB74S3oj1ef+SkcUq84fSEj9KwU3x6mkuwvKlngkHE/YUJTxKfbO48n0FKL
	 jg0LLsyZsqbkVNd60xSfXTOkyJcrtuUkhuL5TD1dozipJ1O8LIccO6yEvfLCFrvxZxSHd
	 UbEvquh1VZX76gyf1QjYhlsQSMYuDPrFyhDvDoPzzRiARsNv4DC8+bohjXFWHrL1Kx4RC
	 O61oRtJxXUEqB4IgM/78mAtBnPq7YB0WqHOWW9VFb4F1/bTg29IXuxzTDOiE0qSOHAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rgjBWiNm;
	arc=none smtp.remote-ip=95.215.58.69
Received: from mta1.migadu.com (out-69.mta1.migadu.com [95.215.58.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368CD606A31D
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 19:01:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 368CD606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rgjBWiNm
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=09iLhdKoA+WjgjSiEhQrFgF/+LcrRb1ryygNNtnygEA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792436477; v=1; x=1793041277;
 b=rgjBWiNm7ij4VVOmDH6xN6QfCVE9RSCvwfDSiGdgvkdbaAc93sbHB9qYMf/97/P5wITWQIWd
 iKRpVi6p8UrK30ulueNymZxOXCUUuWN1sK2625k+ha7kGQTnVC6vwbIRwYULQzLytQ7eZcsw8JE
 P/7Xzq0Nkarf7qUiIMnr+mDM=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d7dc869a0a89dcb8;
	Mon, 19 Oct 2026 19:01:17 +0000
X-Mizu-Trace-ID: d7dc869a0a89dcb8
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
Date: Mon, 19 Oct 2026 19:01:17 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <5ae48a49833ada4e600ba4a72dc82d240bb3b354@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] wifi: rtw88: allow key removal when the CAM table is
 full
To: "Hungyu Lin" <dennylin0707@gmail.com>, pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 reza1234khan1234@gmail.com, "Hungyu Lin" <dennylin0707@gmail.com>
In-Reply-To: <20261019165103.5990-1-dennylin0707@gmail.com>
References: <20261019165103.5990-1-dennylin0707@gmail.com>

October 19, 2026 at 6:51 PM, "Hungyu Lin" <dennylin0707@gmail.com> wrote:


>=20
>=20rtw_ops_set_key() looks for a free CAM entry before checking the
> command. When all pairwise entries are in use, DISABLE_KEY returns
> -ENOSPC without clearing the existing entry.
>=20
>=20Move the allocation and bounds check into SET_KEY. DISABLE_KEY uses
> the existing key->hw_key_idx.
>=20
>=20Fixes: 10d58823cb44 ("wifi: rtw88: fix out-of-bounds CAM write when k=
ey table is full")
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---

Looking good to me.

Reviewed-by: Luka Gejak <luka.gejak@linux.dev>

Best regards,
Luka Gejak
