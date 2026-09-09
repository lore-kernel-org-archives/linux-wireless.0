Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8665335BB
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 10:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788951282; cv=none; b=ZfYaaxz/DKS0b32q2qQv5ir6W4IsgjspXmb1Yg+GBNgDCbn/HfApycL8ajub41KoJVuX+obm97yDW7r2+QYenG7Y9nDWbE+X710ufvOagystVRccdgqVmNNHLMeFKjkO8XOxBCY+N1G4DPBeI1NzMJGdPTKl5h3YQ0fzCdGcGr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788951282; c=relaxed/simple;
	bh=0IG1qzqBI7UqhZNKTFqwX9L/l3aV9Qk2mmaa1mEDYVw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fwJTq4j7/C+X64OtSnUvUy23EIiKwTHabllH2SXH5EqaKPu7wneUlHCVG/COviFw10H1tNC892NDMw4Ls9whWFFqYUHmTZr8RsJjGWvnuI1vzwtH9/KgcyWLlGaqwC505LUCmTSt2I6YxOn0UOPF/FgniuMc7goDjy4GKzUJmVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Julius Bairaktaris <julius@bairaktaris.de>, johannes@sipsolutions.net
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wifi: mac80211: don't reset the TXQ scheduling round
 number
In-Reply-To: <20260908144155.756569-1-julius@bairaktaris.de>
References: <20260908144155.756569-1-julius@bairaktaris.de>
Date: Wed, 09 Sep 2026 12:54:33 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87bja6g0eu.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Julius Bairaktaris <julius@bairaktaris.de> writes:

> A round is ended when ieee80211_next_txq() meets a txq whose remembered
> round number is the current one, meaning it has gone full circle.
>
> When the AC exceeds the airtime limit, ieee80211_txq_schedule_start()
> sets the round number to 0 to close the round. The next open round is
> 1. A txq from an earlier round 1 still remembers the "1", so the next
> round stops on it and serves nothing.
>
> Fix: use a separate open/closed flag and let the round number keep
> counting.
>
> Testing: ~4200 skipped selections per 20s without the fix and 20
> skipped selections per 20s with the fix on ath11k (with my AQL series
> applied) at BE 500/1000.
>
> Fixes: 8e4bac067105 ("wifi: mac80211: add a per-PHY AQL limit to improve =
fairness")
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>

Seems reasonable:

Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
