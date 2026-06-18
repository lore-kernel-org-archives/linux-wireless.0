Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F174F3C1F4B;
	Thu, 18 Jun 2026 09:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781776220; cv=none; b=Po3fGtjKVcfQqoAfXlHNop0jIXcbMfzOJ9Rxbzsq59fAJ2/RHv9Dh6wSVVdLuLGOmc0SXAE4cAlDu1G7Mlv6iHOL/PovApOOGeUFop2/95AE+U0+hQfNTRNf6m3jLWqF8Pfu2AUyO/vTqpojGIfTGOTfQK7cnWVi24zhIBK4LRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781776220; c=relaxed/simple;
	bh=iK8VcMnc28NDB0ZD2a/gWBNfGEAvYuqYOjQNVyQ/k6Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KG/I0KL3R9GW/lE8WeW5VNeVpPA+rjJhQDvnnZ4AqTWT505YA2kbuDtmikF9yX3CnT2vj4upbFu7CdquVeuDjoxRjgX5xb0b81ZbcBKwGsscFlgXfHf+oqUXbbhxKSh3C7wpHSaCZ8vbI6MVNW90ddplW8ABLGue/cPBPadjR3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Authentication-Results: mail.toke.dk; dkim=none
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ath-next] wifi: ath9k: drop static from local pdadc and
 vpdTable arrays
In-Reply-To: <20260616030828.655310-1-rosenp@gmail.com>
References: <20260616030828.655310-1-rosenp@gmail.com>
Date: Thu, 18 Jun 2026 11:50:08 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87se6kfa9b.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Rosen Penev <rosenp@gmail.com> writes:

> Remove the static qualifier from mutable local arrays in three EEPROM
> power-calibration functions.  These arrays are written to during normal
> operation, so static storage is both unnecessary and misleading: it
> implies sharing across calls when no such sharing is intended, and it
> makes the code subtly non-reentrant.  The sibling function in
> eeprom_9287.c already uses an automatic (stack-local) pdadcValues,
> confirming this is the correct pattern.
>
> This keeps ~1 KB of data off the static data section at the cost of
> stack usage, consistent with the rest of the driver's coding style.

As pointed out by the test robot, putting this much data on the stack is
a bad idea. Pretty sure it's static for exactly this reason in the first
place.

-Toke
