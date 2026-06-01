Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F9F3D7D7F;
	Mon,  1 Jun 2026 15:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780326627; cv=none; b=Ak79+OOsbxfwxKfKnYFvbz07EsfaTctNDp/DsWju1gs98DhRG7EAyc32z4YS6Bt8+vxsngfl6DlTedMdEQ6k3UHsk00uQ0dUUW9eXcI9JS/RrsPHMnSBExxgoNF8PHKdbJb9OzgGKo69EheU5toEamC1+GATLLa23xutggtmBq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780326627; c=relaxed/simple;
	bh=Wvh0edYTvMH4VyTkgnwVmOOoROBZi1jyR9hdo0y5eHY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JyiSRjm0PrWkQjqhX95TzO+t6/SsPIOgkMhghHN2lRJd5JjN+UC4P87oNmUhlD9XyUzUDq4jD2NFsGPZaFX6lBlI2J3JzK9TpOMEitlphceR4WLJP3qgX6eAST+nU6FNqtmEnOplWd9K68i8YqA4T0aouL9uQOIjjYqAeeffc10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Authentication-Results: mail.toke.dk; dkim=none
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ath-next] wifi: ath9k: Clear DMA descriptors without memset
In-Reply-To: <20260517042716.2218386-1-rosenp@gmail.com>
References: <20260517042716.2218386-1-rosenp@gmail.com>
Date: Mon, 01 Jun 2026 17:10:22 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87ik821eld.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Rosen Penev <rosenp@gmail.com> writes:

> Clear ath9k DMA descriptors with explicit status word stores instead of
> memset(). The descriptor rings are coherent DMA memory, which may be
> mapped uncached on 32-bit powerpc. The optimized memset() path can use
> dcbz there and trigger an alignment warning.
>
> Use WRITE_ONCE() for the descriptor status words so the compiler keeps
> the clears as ordinary stores instead of folding them back into bulk
> memset(). This covers AR9003 TX status descriptors as well as the RX
> status area cleared when setting up RX descriptors.
>
> Assisted-by: Codex:GPT-5.5
> Signed-off-by: Rosen Penev <rosenp@gmail.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
