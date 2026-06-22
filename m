Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E94A2D9EFB;
	Mon, 22 Jun 2026 11:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782128980; cv=none; b=tGYNnPCb2WLIRYsNuQwwSe3E9mi022mtH4MW81SwX/1KB99EkZmuRlvy0mYDuuV3xlVUQY6rZVw5dUcYA5YPnwnwdRObwrLyQRogDbcjGyvIdDNqeCz/cOHrmuVSFgJG1aq9rcnn4TAkyEyDndmmT2dLz3Mh38nCTKgBtUlkP00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782128980; c=relaxed/simple;
	bh=WqPNF1cxscolSasfFJVnJxbimxvRGyc6aiwQN9WKgCA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=S1u00lXHlnIlhItyt/FcMGxNnubJ9kTLuKUZMwmml5rBaSQ1Hd5Rsh2u7zAG5fsutxeA7FUq2Lt45t441qeMtmMOu5wjGOpvmD0cTgWyd7uTEupvjmnLN3mUsEjGquOGxNGhuVGfqb8iTNEt1gOv+hRHQy1RLXWaaezwDJ+Utgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Authentication-Results: mail.toke.dk; dkim=none
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 ath-next] wifi: ath9k: mark static arrays as const
In-Reply-To: <20260619175210.5348-1-rosenp@gmail.com>
References: <20260619175210.5348-1-rosenp@gmail.com>
Date: Mon, 22 Jun 2026 13:49:28 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87se6eeqwn.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Rosen Penev <rosenp@gmail.com> writes:

> PN9Data is a read-only lookup table and is never modified.  Adding const
> lets the compiler place it in .rodata and prevents accidental writes.
>
> Use the same treatment for bits_per_symbol. It's not modified either.
>
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>

Again, which actual bug are you fixing here?

-Toke
