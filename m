Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792557703;
	b=ciOq5WKEgiTYHsWZAIwn3blsGxm+cv79P9Hj54HKB4xcLQlZiedASefSbm/6XVGQUD0d
	 l1ZceY8hdDNBNPQGrKIHGU7xno+X+zIVsR5w7rEatH3RLK2NVpN36gcayuFf2fUWD7Mri
	 TGbQh1iDX9cqsZ4t/lr7IPG9iJa8v+5YDY2Sj0ZglhFEX59HGjbPFuhjl51qTQ6J/6xsE
	 zdr4TMbVJeTRnrqwCzlqUrwQIFVF9OwGOQxGhanmCg93lmrd3zRhAi4ygJRVBA10RbQh6
	 YVHuA5jqSSD4gfb5rIsPeq/BeE21MKvhsV68bso56tOsynN25bJLOp8ZBsIJTIHH2/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792557703;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=80/L7C5Q742aRmubzAszjlP4MxgWpcn8Xnh95KI+DTM=;
	b=hxYBrtH59Ac536pnfUVF46Pakc2I4HbnK4BCNfjubamm5yHcsL0EbNhM64Tkbumhz2xc
	 Wewq6AEctjK8Q967Cmu0v7caFXYZi8U27eTj/XSPN5cyq1pLv2cH8bUQjsddZRWiHVQ5t
	 we3DGw1v+UUCbVMV/5wSAUZVOILKMZzaHG2kkyTnxVzviCwXdOgD46sKdDhNUaO/SbLag
	 QqdYyH4CP+QhwEfXZe+iZb9LcurA/6XtQKanOJvU047EEaRbp64q9QvF8pJTOpId4Wg5z
	 phCWrxj/SnRUxIiXe96b78JpwApCAes5YQ0Kx6GpF4ZaSHL2Kk/TOxm6BeNKmEF8+5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vJMBqm9N;
	arc=none smtp.remote-ip=95.215.58.43
Received: from mta1.migadu.com (out-43.mta1.migadu.com [95.215.58.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF11606A319
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 04:41:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BF11606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vJMBqm9N
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=QTlfwCQpFC99yMYz4QNoPKAnueaaVHC4hf5ObvzYMFg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792557700; v=1; x=1793162500;
 b=vJMBqm9NApHiQC8At+B7SPBhmoIKQy+rkQE1Urkr4HZV0rUSrVMnzkKmDKZZMSOqfwmgwcCh
 LvjuNHKMvEZjDax7fL2UAkgOAHpXurkzSksyQwPvFBkjJ4fs3rtbJTAo9mdFoQzmbjAD2/N6NmQ
 PocwNC4RTcsTeBUDM0U1UOUU=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 36de97a2b98259ce;
	Wed, 21 Oct 2026 04:41:40 +0000
X-Mizu-Trace-ID: 36de97a2b98259ce
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
Date: Wed, 21 Oct 2026 04:41:39 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <496590df10b6397021dde6ebbdb5a15a9a9d7bbb@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v2 1/3] wifi: rtw88: Pass the physical map to
 the read_efuse chip op
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 linux-wireless@vger.kernel.org
Cc: "Ping-Ke Shih" <pkshih@realtek.com>
In-Reply-To: <8e47daa4-538d-4e0a-84f9-fd4e91613ff8@gmail.com>
References: <8e47daa4-538d-4e0a-84f9-fd4e91613ff8@gmail.com>

October 20, 2026 at 10:50 PM, "Bitterblue Smith" <rtl8821cerfe2@gmail.com=
> wrote:


>=20
>=20rtw8723b_read_efuse() will need to read a byte from the physical efus=
e
> map, so pass the map to the read_efuse chip op.
>=20
>=20Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> ---
> v2:
>  - Patch is new in v2.
> ---

Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Tested-by: Luka Gejak <luka.gejak@linux.dev>

Best regards,
Luka Gejak
