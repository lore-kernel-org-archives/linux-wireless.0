Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.59
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792557722;
	b=IY0rVvY04qVrgAhthJbaw0jvCeAWO7aJeQCFTBxSgcyFVETwmNznWTcyBsenA/5DZA+a
	 RilLUJbgbTY3iMbh1Zdi79QW4cxL+6rfIs8x2tsbbnYYbUbINaOS2KPI9EiQoSgXheQD+
	 FXEbZ158xW5eCxnLD0/YgmrnTC9Fdg2owVHb7T9rxdBqVDpE1y8Y78CZPCdh6j1CdQkGZ
	 5q5aX5ihTiY6/gbUwWFD5ZdiFHzZaQ2m3MADlJKp/RxBt/cAf5OTc6oAdo18D9Idk0lkc
	 bzzb0IXjr+qZOWKQbcs4bsZn2eDX6rwwVS4rjIgX4nsxWjDZv18hLZ2AGB8iPgtevxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792557722;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=oyt2T3felGUqP8V69/cXpCsJNCOhbmotd/Pde5/47M8=;
	b=ro1eHtUZbDM+LRDU4emZVia76eKJNkMVHjRw9PpQriGEthcEQRGbIq8zH/YMuZsi7GY5
	 A7Tz2XsRLiGPDGbeXoO2/09IjgWnTWUal2zYiVv8nygg2NS2KbXqLehKmp/4JNMy6okWU
	 rdnIs1zTlWHA6sjdGWjTjaxMUK1M0ncWFYlntpPzDWBQL9mYhCf74SCu2uUP26OCMq4vL
	 /ykdxN0L9lJEr1mexffA0Zbk2uT4nW3//2FQMIe2LLa4812YRUJ/lr9HR6HyH5bQYd50M
	 ugc6KG7pMtHdiVmHrSsMA+ZU675OE7NcqP3Tej5H+JVfagWAWwQ+h4iYZtNcE/W1m+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CDeVj7qf;
	arc=none smtp.remote-ip=91.218.175.59
Received: from mta0.migadu.com (out-59.mta0.migadu.com [91.218.175.59])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429EB606A319
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 04:42:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 429EB606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CDeVj7qf
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=485gBd7/yxunY5NGwjieGbTLlAmDr4qE7opaOx6TdjQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792557718; v=1; x=1793162518;
 b=CDeVj7qfpljRBND0cuxBhWsPFiejfrzUif5fPZ6tRhO51cxjtZBLw8ququQk18Is3ahWwa70
 Mf7eIfNYoQJZFl3O+eQ18/hfdvXlhY6BVlmeSmfqhKdjIxjPZlBsLl9NbYbtLOXl2k1jNPCfQL2
 bCqUGnJAcq1+gbOAm95lfu4g=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b39a1222a273e94c;
	Wed, 21 Oct 2026 04:41:58 +0000
X-Mizu-Trace-ID: b39a1222a273e94c
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
Date: Wed, 21 Oct 2026 04:41:58 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <9f08d6a1e915751ef72018f32e2d4c54ee0585ee@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v2 2/3] wifi: rtw88: 8723b: Read the package
 type from efuse
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 linux-wireless@vger.kernel.org
Cc: "Ping-Ke Shih" <pkshih@realtek.com>
In-Reply-To: <2d1f9c05-4837-4c62-ba27-4275d2cc5d0c@gmail.com>
References: <8e47daa4-538d-4e0a-84f9-fd4e91613ff8@gmail.com>
 <2d1f9c05-4837-4c62-ba27-4275d2cc5d0c@gmail.com>

October 20, 2026 at 10:51 PM, "Bitterblue Smith" <rtl8821cerfe2@gmail.com=
> wrote:


>=20
>=20Some chip package types need different parts of the RF initialisation
> table, so read the package type from efuse.
>=20
>=20Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> ---
> v2:
>  - Get the byte from the efuse physical map stored in RAM instead of
>  reading it again from the chip.
>  - Use macros for the address and the mask.
>  - Read only the package type. The chip variant is now in patch 3.
> ---

Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Tested-by: Luka Gejak <luka.gejak@linux.dev>

Best regards,
Luka Gejak
