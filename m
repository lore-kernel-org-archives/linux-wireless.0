Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C793D7D94;
	Mon,  1 Jun 2026 15:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780326654; cv=none; b=LIMnaB+p+u6zqd6tTz5SNf4Znxz12tRH3CxMOVASwlbY+WQr0/wM3aVWO3MTf8eTLSCxf7qVivPMR3UtCZ9OJaidg+e7lDx2bYPDExsLqSRCnBJb+U+r+thpQhePwSaoxiDoEnMCn+HKJa810QiQYdOxG4owKppMJ/hC3QjmQU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780326654; c=relaxed/simple;
	bh=xNXJalnbgGlVGqeBVI4DRwA2Fqu11XktgvvkwHZsJI8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=icqL3fsplLmqI6piyYohoXQ0oc6RVXGCOLGwH5BvQvS9oQFLnE8VKrPJRcbzXhLlGEGC1wkJ7vTToCIIsaURzLmfdRzdOm9jyXr/55OajKipI3OU0cS6T+T5v1GXqzlw1BpFdfvsV52utJw1lvEjLWvuzR3bhu7gONNc8m0pzBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Authentication-Results: mail.toke.dk; dkim=none
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ath-next] wifi: ath9k: remove TX99 power array zero init
In-Reply-To: <20260517222136.1660347-1-rosenp@gmail.com>
References: <20260517222136.1660347-1-rosenp@gmail.com>
Date: Mon, 01 Jun 2026 17:10:50 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87fr361ekl.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Rosen Penev <rosenp@gmail.com> writes:

> This array is fully initialized in the loop itself. No need to zero
> initialize and then overwrite.
>
> Remove static from the array. This was a holdover from when the array
> was a static global variable. It no longer confers any benefit.
>
> Also add a min() call to avoid the manual if/ternary operation.
>
> Assisted-by: Codex:GPT-5.5
> Signed-off-by: Rosen Penev <rosenp@gmail.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
