Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.145.95.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792435578;
	b=jBg2wFoy25SZGZRHlB+cxyuBuYy38gfWcvzqKKSITChI2dpVU2H52AP2nPhiv3RCyWjW
	 Bx+eurlfVdXK2J0jAh8Cyhsu2gW6DUYydlyuuVTeR3lIHN++EZDB+8O9Cow+5yMylSMnF
	 U+nC0SRKtEVlSJvo0sniWGABjoLxTa5U0gA6/gEge4cs7WRC7KoHWdMTKK7vYk9xLO8pS
	 mjvIQji3xw7QZ9fYOPUioT06SE/Qk+OyG6woOLQWUK2hjP7t/ORuCIsmrhTmDbemudo7m
	 hTuZwry3I9kZP9dNQawDPZ0PEN9h996H50R0WjLqO06FbyvsAHgZ94QAfaSaWI/u3BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792435578;
	h=DMARC-Filter:From:To:Cc:Subject:In-Reply-To:References:Date:
	 X-Clacks-Overhead:Message-ID:MIME-Version:Content-Type;
	bh=+hRafnmGtnX0Gmpp+5qnp4hQWU6BZlwPRu0BRGDJHOk=;
	b=IUHBOJ5/j05khJLONdjmE/+p8MaAaBsq3Q1OJsma/ZsPP58hvbNO2ij4C45NU04r7nQf
	 3wlZ2iB/2PMVbvLcdMUKMSKmOnJeeqmNj3dYbS+254Rg2w9Cw8NhtHlP4CMbyFilKcodV
	 mVYEAww18uET85ka+3gJ3xrIT3xjLJj0TYf0grtnrJ/U2TmCeHugofVgeyiXqkETemJLJ
	 n0ozrBIS6aqTDbHdlzbQ7wlxKdMHt6ty9JsWeKMkWLJ11pVXa1dPV+8D0g+vV8KINhHAb
	 CC/zP+Ef76z8OCEzDcp1XKoAqLXEJ9UEikYSXOxlzDGNDHO8itpSggaXf4REea+zVHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=toke.dk;
	spf=pass smtp.mailfrom=toke.dk;
	arc=none smtp.remote-ip=45.145.95.4
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F1F606A31D;
	Mon, 19 Oct 2026 18:46:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9F1F606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Nick Hainke <vincent@systemli.org>, linux-wireless@vger.kernel.org
Cc: Nick Hainke <vincent@systemli.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: ath9k: restore background spectral scan after reset
In-Reply-To: <20260915194327.30397-1-vincent@systemli.org>
References: <20260915194327.30397-1-vincent@systemli.org>
Date: Mon, 19 Oct 2026 20:46:14 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87fqy1wmtl.fsf@toke.dk>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Nick Hainke <vincent@systemli.org> writes:

> A reset leaves spectral_mode set to SPECTRAL_BACKGROUND, but resets the
> spectral registers and receive filter. The driver therefore still reports
> a background scan even though the hardware no longer produces FFT samples.
>
> Re-trigger background spectral scanning after reset recovery so the
> software and hardware state match again. Do not re-trigger spectral
> scanning in disabled, manual, channel-scan, radar, or off-channel
> modes.

What bug is this fixing, and how did you test the change?

-Toke
