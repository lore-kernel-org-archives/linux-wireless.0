Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792791275;
	b=TtLBkEwVXYvzPy7bjcn7APVkCPiYjLaN4dV5u+aibKhJAflrJpl151rT+pHiH+gL4Ra+
	 mTqEX1n83U46N8SFvKaR958EB6imvGLrVTJQcR1EUs2xo0vTkxgAFghOPZs5j5AMahzUF
	 8gK+HHxHur/NZFwDhjGj+H1ZcBu5tnE2o3NfsIFbtJ6fQMwlWtUE9g8QmbzSynbCkVWvj
	 D9xWrJUTpala3HPkHsA2WHyH2nYiBMXOuheesyukG4FpyWMSFQVv7wrsUQrhqPGx0/s3S
	 +CdU4QKenHlJ91KO7TqXlety60z4M3l6OpzHS1Qh43SEr3QvPIc23pJU4AfImldj5xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792791275;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=hr1zPOfyiZqpY2vU4mmV+T085v++6VBMIs4U467d7Yw=;
	b=A4OjLm9u3hYghJXvYsiYlxbzRtnWwloeUXKiPkjcW8sFRqy0fss4kuYF3zJ8RIE7acTL
	 9AhKb2zYqQl+Wpw11Z+c/dGbJUXvIkdXjJ8TvYdL1MW3ZDZhhh72yGIzsShtB1O913ZJR
	 fFi/VBclj0ZoyAiPRDpEhgPgza12H6JmPxrh6jVP0nrXBJpN7usatOeizBUdu6y5zF6dO
	 Rnyf9AYqutwsKVP/Q+Kc62lxaDFHosnTO5fK5fwSN57wTi+DYCsOeuFrkbmSlvuowesjQ
	 k/7K8xXbqbelZdSl0C7rdyGCwI9094Gt48mZgDCeFSUdYdz1VgX+SMcPlLqDYVt5M9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TxngfrpR;
	arc=none smtp.remote-ip=91.218.175.177
Received: from mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63DF606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 21:34:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D63DF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TxngfrpR
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Yy/2ularjRrwqquDvE7W1R2qQMWoWbNC1XMmGFPCYis=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792791272; v=1; x=1793396072;
 b=TxngfrpRBmc/3c3G6ekAbpppP78ySvns7B7VAsQVHfPPA54Ruo0mVCpvNPg6BceB/6RbYWRe
 feIJrx5rWdH+TSRpXWbR16sDNF9QcceZs52fkI79a42n4GV0DJPkly9e80f65YnEGSqMdFNPiwc
 yNj0roFGB1EhOcG3honOCpc0=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 387b152527310d3e;
	Fri, 23 Oct 2026 21:34:32 +0000
X-Mizu-Trace-ID: 387b152527310d3e
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
Date: Fri, 23 Oct 2026 21:34:31 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <875b4e96891a2bf256ca1805140b57aeccee4aed@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v2 1/2] wifi: rtw88: move the bmc high queue
 decision to tx.c
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <5235fd68b703f756cc2ee1e7471339a512db59b8@linux.dev>
References: <20261021124318.15993-1-luka.gejak@linux.dev>
 <ac6d8824bdeb45148ffd6b5dee7da313@realtek.com>
 <5235fd68b703f756cc2ee1e7471339a512db59b8@linux.dev>

Hi Ping-Ke,

October 22, 2026 at 7:11 AM, "Luka Gejak" <luka.gejak@linux.dev> wrote:


>=20
>=20October 22, 2026 at 4:20 AM, "Ping-Ke Shih" <pkshih@realtek.com> wrot=
e:
>=20
>=20>=20
>=20> Luka Gejak <luka.gejak@linux.dev> wrote:
> >=20=20
>=20>=20=20
>=20>  USB decides in usb.c which broadcast and multicast (bmc) frames ma=
y use
> >  the high queue. SDIO needs the same decision, so move the helpers to
> >  tx.c behind a single exported rtw_tx_bmc_use_hiq() and keep the budg=
et
> >  state in struct rtw_dev.
> >=20=20
>=20>  No functional change.
> >=20=20
>=20>  By my review, I think it doesn't change logic at all, but I hope i=
f
> >  someone can help to test USB devices to confirm it still works well.
> >=20
>=20I ran the same test with rtl8723du and there is no regression.
>=20
>=20Best regards,
> Luka Gejak
>

I was thinking, as staging got removed, for 10-ish weeks(until 7.5)
users of RTL8723BS won't have AP mode. So I was wondering if these two
patches could pass as fixes into rc2 release(or whatever is the first
rc into which rtw tree is merged), as this would be DHCP stall fix. To
elaborate: when this driver was merged it, was exposingAP mode to
userspace, due to RTW88 doing it globally. Therefore AP mode existed,
but wasn't working properly. So maybe it's a bit of a stretch, but I
think it's a valid proposal to send it as a fix into next rc release.

Best regards,
Luka Gejak
