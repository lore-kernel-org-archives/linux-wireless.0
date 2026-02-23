Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929F01EA7F4;
	Mon, 23 Feb 2026 15:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771860114; cv=none; b=aTx3VWRHu2YMNMmWn2Fb4unqufl2y9kaQnr5ooNbHukD2E/VZK0/5fyhbTnvHJPpHeK/EGuXN5hkZCfLayXd/asPXui9zzuoWboYimwyiQVbiFDJPZcukdoIs/wdALZ7rxkZz10nfuYgbbwiQoLiR7a1bIGiSOBBcgkoU8Rw+40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771860114; c=relaxed/simple;
	bh=0ai43CGkDvzAFtvytP0lRUYsD7whfLi4txJznfYa+fM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=sgxQjQ4WK4qlnS3iFgKipwwu0rIQVkRx7dj6RTLErYTTUBVxounIp35MRF4Gro6pFkVLledEUVbR01ntweuqPeDEaypPiewI4MnptyqqHuy1LxkbM0N+gA3UqYBZJwDTtCE2zsyhjsDMu9iNiqiUXzxCvdtfZLfKWnir9bnSLBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b=usP1VgzE; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="usP1VgzE"
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
	t=1771860111; bh=0ai43CGkDvzAFtvytP0lRUYsD7whfLi4txJznfYa+fM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=usP1VgzE9swzmud5yqXTEPRbgFoPwjeFaHSw3hZPc1e7QnIJqEgA1mWaNYDnpd7fP
	 O7jiZxGWlbMtxc+CxPxaAQq2SfEOVu0g6oOhBm5hyxvwOSyNHtrz8HS5P+JnyWlGvo
	 1B3R5Pcng3SEKmuyOF/Dd07WhP4N4OZJcl9SBlfqxxbWzOjBltqSnZL2iO3NuetyQf
	 C6fTBNf35LWnCkB/vN/5ViZ5nn77kf9CfndbfetiYiLAO3fF2j2GjgeHovRE4WmAgk
	 lNXCNQ7hYg6JCCYEt7KLaCrvbolshpT9xxZ9skGs/2ZLxAE/uO+HKSJu+rNEOTqYPC
	 6vgg1CLRW672A==
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ath-next] wifi: ath9k: use non devm for nvmem_cell_get
In-Reply-To: <20260223025021.19008-1-rosenp@gmail.com>
References: <20260223025021.19008-1-rosenp@gmail.com>
Date: Mon, 23 Feb 2026 16:21:52 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87y0kjmqnj.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Rosen Penev <rosenp@gmail.com> writes:

> There's absolutely no need to extend the lifetime of cell to post
> removal of the driver. It's only used in this function.
>
> Signed-off-by: Rosen Penev <rosenp@gmail.com>

Right, makes sense.

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
