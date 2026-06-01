Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B493D8905;
	Mon,  1 Jun 2026 15:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780326749; cv=none; b=PA5mh7zUFrcUJkE+J1Kru3ExS+A64JNAowaNGBw5JGO5e79V2fz9c468f2CRjjVp3FLwkHfQWhen6NfpkTrooRDNA7aPVEC9JY7WSMNs/y5y6ok65tTKF22U2EdYhdAn9dmI3RRm/913sqMYhAvSfvbI+M3TXM+FHng3zzqx7sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780326749; c=relaxed/simple;
	bh=aRF+2Y6D1jnKi0mH2Wz7CdMrKPi/NcARzhImPTUUFDw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ZPWmhiY9KZ0jHDfkKZvN+1HlcIg+Du6OyTfyR944sLeYcj9KaYHqhPlgiGl3SSEd8BPIUeJjGjQat61J4y3CuTOurldvRgjrgrnnY/kfgeV/+XC3NqGw/ZdqXaUFCfQjS/I6r0yMULrS0HK+Wu5KHDHHh0IpeI+otFsl0PbsVCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Authentication-Results: mail.toke.dk; dkim=none
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ath-next] wifi: ath9k_htc: allocate tx_buf and buf together
In-Reply-To: <20260521232020.261405-1-rosenp@gmail.com>
References: <20260521232020.261405-1-rosenp@gmail.com>
Date: Mon, 01 Jun 2026 17:12:25 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87a4te1ehy.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Rosen Penev <rosenp@gmail.com> writes:

> Use a flexible array member to combine allocations. No need to have them
> separate as they are always together.
>
> Signed-off-by: Rosen Penev <rosenp@gmail.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
