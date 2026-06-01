Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE5F3D7D94;
	Mon,  1 Jun 2026 15:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780326689; cv=none; b=rFX5t8MaT4GBzQ5fAryl2JC7nTQWUSaXJS0m+AYPSfMO2p+vasXc53N73P/i7TOJbAYN3qzfEkQ10dqlJSYyfw112Tv/InD/bIptxejFXsuyvwbpDofvR9DxdH6Q/yX+omE27E8Fn173tv+JS/xza3EC/gDBdP/oJJnDU9txd7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780326689; c=relaxed/simple;
	bh=DLOW3qlMFRfZYoro0+hzLw9BqETTZB2S5t4L4j6BMbU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gkCadKZXv5jzxdo8a31wQEx9yLzVU9v6hRo92qO+BlA6hBT3u+iaJswoxmWan2UxZHbi2APVuF3pTtcfdICsts9CuMjcQKuj34usRfbuJ85y9AhK106MrgVfEUb5JKZ6ZJQHE/6NYQvYjPP+A8+c5ORdFF1yvj5OqtX3y7VtUik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Authentication-Results: mail.toke.dk; dkim=none
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ath-next] wifi: ath9k: remove disabling of bands
In-Reply-To: <20260521231806.261220-1-rosenp@gmail.com>
References: <20260521231806.261220-1-rosenp@gmail.com>
Date: Mon, 01 Jun 2026 17:11:26 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87cxya1ejl.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Rosen Penev <rosenp@gmail.com> writes:

> The old platform data code that used this is gone and this serves no
> purpose.
>
> The modern way to disable bands is ieee80211-freq-limit, which is
> already implemented.
>
> Signed-off-by: Rosen Penev <rosenp@gmail.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
