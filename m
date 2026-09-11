Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4E638B7D1;
	Fri, 11 Sep 2026 10:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789122527; cv=none; b=ZExN1rB6n3ZdKRB4Zub0MGJmYNlG4bGOlsHT17qsMjT5SYJCB5wwNm4Ro6XYrVGQrtsi7ZzrmkyA4KcRmsT+5MUvnFG8wdC+L8l/BcI/RBWySDhfAicNzmsK70ZUAavO3J7ZDFTyhhlxRJ+FdyOmrp2swFVfQ1x/2tOkLZaSMek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789122527; c=relaxed/simple;
	bh=uOyMzbux8t6JCWm/PtIwZsC5MM2alGETeKnfNJH8UQ8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=r5zPo5K29Wu+/pL7wbBTUv8pMHwNJSsbbrF4QDC+nX0nZY3XEmgdyPHi5BJG83Ki3lh2Qtt21fcsYPapEQajrPavJOjtUN9BJ63psuc75/dmlK+JwAGJBYGp8LIiimrP9KA2G56pIaIxA7oTxXH2LgHrIbMCRy2R7gg4Jhrrr2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Nerijus =?utf-8?B?QmVuZMW+acWrbmFz?= <nerijus.bendziunas@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] wifi: ath9k: fix the RX filter handling around
 spectral scans
In-Reply-To: <20260911014653.1566388-1-nerijus.bendziunas@gmail.com>
References: <20260911014653.1566388-1-nerijus.bendziunas@gmail.com>
Date: Fri, 11 Sep 2026 12:28:42 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87se3gcc9x.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Nerijus Bend=C5=BEi=C5=ABnas <nerijus.bendziunas@gmail.com> writes:

> Patch 1 is v2
> (https://lore.kernel.org/linux-wireless/20260904181709.788886-1-nerijus.b=
endziunas@gmail.com/)
> with a shorter comment and message and the Assisted-by tag in the
> documented form. Patch 2 is new and needs the helper from patch 1.
>
> Tested on an AR9271 (ath9k_htc) together with the pending spectral
> stats fix; ath9k is build-tested.

You're resending new versions of patches faster than anyone has a chance
to look at them, with series boundaries that keep changing and have
weird dependencies between them. Please don't do that. If you're still
working on patches so that they require changes, then you sent them off
too early; this is not a race, don't submit things until you're
confident in them.

I'm dropping all patches from you from patchwork; if you have a series
of dependent patches, please resend as one series, explaining how they
relate to each other and how you tested them, and then *wait for someone
to look at them before resending*.

-Toke
