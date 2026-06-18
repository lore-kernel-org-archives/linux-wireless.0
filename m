Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9983BCD27;
	Thu, 18 Jun 2026 09:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781776302; cv=none; b=GroSw/FSRtULfYLCfNjNCPoniqhe6P4LFr0AuWsbPhsBH78a84faaLqxbxOtxCqb9R1+jrc++bSUxJXCTXR2vQS3j7VbjqiWBsn3EOaJY/4+ATEbhHgi6Kz1mdmqyO8eRH2Bsjb8VmZ1WvOhw7v9B1MvlGKOFdmFWuGAxACgYU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781776302; c=relaxed/simple;
	bh=RDq7N8/SPPSk1xsmOlIg7ku3pN4vpAp3BT7KAysxT8E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LX41dZCKuC2OzQiib2gLIHjXVenRXGV7iDBiXKX8KzE+CJ1leR9omJuipdExL5tPBK67kxY1gMbA0DowJnohiwVniTPMZxtgVWPC8/Qpj2DCkcqAIlGZjtrWs5nt2oHjep9L+GsG+ErxGdKrDB7KNGO0wXtni2yRDeghE64GTeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Authentication-Results: mail.toke.dk; dkim=none
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers
 <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>,
 Justin Stitt <justinstitt@google.com>, open list
 <linux-kernel@vger.kernel.org>, "open list:CLANG/LLVM BUILD
 SUPPORT:Keyword:b(?i:clang|llvm)b" <llvm@lists.linux.dev>
Subject: Re: [PATCH ath-next] ath9k: eeprom: alias vpdTableI onto vpdTableL
 to shrink stack frame
In-Reply-To: <20260617234105.284358-1-rosenp@gmail.com>
References: <20260617234105.284358-1-rosenp@gmail.com>
Date: Thu, 18 Jun 2026 11:51:38 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87pl1ofa6t.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Rosen Penev <rosenp@gmail.com> writes:

> vpdTableL, vpdTableR, and vpdTableI are never live simultaneously.
> vpdTableL and vpdTableR are consumed during the frequency-interpolation
> step that writes vpdTableI; after the if/else they are never read
> again.  Reuse vpdTableL for the interpolated result (what was
> vpdTableI), reducing the stack frame by one 256-byte array.
>
> The read-via-write in the else branch is safe: ath9k_hw_interpolate()
> receives vpdTableL[i][j] by value as a function argument before the
> return value is written back to vpdTableL[i][j].
>
> Stack frame size change (x86_64, clang):
>   before: 0x440 (1088 B)
>   after:  0x330 (816 B)

Huh? These are static variables, how is this affecting stack usage?
I assume this is against your previous (broken) patch?

Anyway, adding this kind of aliasing to fix a problem that you
introduced by changing working code with no real benefit is not an
improvement. I'm OK with fixing actual bugs, but this is just mindless
churn...

-Toke
