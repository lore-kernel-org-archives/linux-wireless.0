Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A645E4052A2
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 10:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787568311; cv=none; b=oBTKE88lR/CbiVxB7Ad+z+RCooYOoM5ZgolPYZ0bNSRe7GXWYiXXXdbUkFgOLgZ/H4EpjwtuEIzAbK/ShnNbnhnqgVONHd9/b2Zg7I9H+ewp1On+h6qP5YGJPSzkTnP36XNL0LyEweX5/vpqRhfNopafcIxYpe0l7ReKMYmU9fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787568311; c=relaxed/simple;
	bh=6c8bVM/kMY8j46uxMODtzdStBLKw7OmWf+gypNXrSPs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=GrZLw7KQwcvIEt+GP+DTiuUCqVzeM4+4EzPVDvNOF+wVqSecxSEG9907Laou40vTxoET3h+oPChgku3N9bhbrPgRBpXrp7ioFmVO5scfp1G19W2L6LDYZaQrdd3gS9rx/Rwn0DhVbViTYNb7A4q/Hmuf9JxzoPjQQtcW8OH4mio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Julius Bairaktaris <julius@bairaktaris.de>, Johannes Berg
 <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v1] wifi: mac80211: fix swapped
 fq_overlimit/fq_overmemory in aqm debugfs
In-Reply-To: <20260823195739.49222-1-julius@bairaktaris.de>
References: <20260823195739.49222-1-julius@bairaktaris.de>
Date: Mon, 24 Aug 2026 12:44:59 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87y0dver10.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Julius Bairaktaris <julius@bairaktaris.de> writes:

> The aqm file prints fq_overlimit with fq->overmemory and fq_overmemory
> with fq->overlimit. The fq_overmemory line was added to the format string
> after fq_overlimit while its argument went in before it, and the two have
> been crossed since.
>
> The counters are not interchangeable: fq_tin_enqueue() bumps fq->overlimit
> for every packet the eviction loop drops, and fq->overmemory only for the
> subset dropped because the memory limit was exceeded, so overmemory is
> always the smaller of the two. Reading the file to tell which limit is
> binding gives the opposite answer.
>
> Fixes: 2a4e675d887b ("mac80211: Export fq memory limit information in deb=
ugfs")
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>

Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
