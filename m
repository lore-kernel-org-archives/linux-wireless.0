Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F385351C33E;
	Tue, 29 Sep 2026 16:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790699584; cv=none; b=I7IzY7JFrnipejRVdOIYM4341zdXy1u7k0meMttMqKKnfnjuazg4Aej6VpraMCwFFm82yqiquQGT0c/Bh/xaNpx8UKDV3Ss3RKG920kMjeO+aUEqx2unqBUUasjYYd2/RJhCvi7SUYVeZCLJ91/6wnS/QG1ugQLstr1kXxfxDxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790699584; c=relaxed/simple;
	bh=M9ynqIpgrPrsaaforEaebtCSBtxUAGGFzr/xRYxiCEU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CMLQ/IBE0LBN7HDnuWaGItzghInt8c7xt9CVaYIxBzIGYU/mEkBqGpRSVhmiKbUhIocJbxo+/AkUIeHBKbzUN03MFTB5tP323celLNtu7pTpC72Wr4cNoXQtZspzEnBHXj033lEABAp61rbmVPGH7GPnCFPg5d5ByxsYqmuCZhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=pmOyb4bM; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="pmOyb4bM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=NjFgvSSC1jcBqJxa7KmFR2SqKxMrTZQsYjrInIMQ+Yw=;
	t=1790699582; x=1791909182; b=pmOyb4bM2srHMAHRiOSpd7yL8Mt6RJSx7YvQXbMehaa/2DU
	Y+/qjIUBSBS/DEy/qe7OlQ/XLdfscZjloSyTNlQsMnAXmaJBmUJCwkbJT5Cc1FaWho8oikqgkoQM+
	DX3hkQ3YGy+ACehr7xf1mT2fEIqsNdvgbuXbaf+YHJ+oiZZUcWd0Biz6jjrZjBjLYICwyGbreabRy
	GoQw+MTY2Y5s3woRZik7a7ZvJdm1pix/9GZ5ugDmypkbk7/JlTHI5EME9oTze1SBl7FDS7OugM8JN
	xJeRZk1cC1Z3yTKYyF7bfpSrW2juBx/NCjMfCsaEmnUQ8YrBJ6LxK32wg+ZKneRg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xBalF-0000000FAWd-3ih7;
	Tue, 29 Sep 2026 18:32:58 +0200
Message-ID: <d8227c92ab9c752dc6b591945ea8f9c5e3cc6223.camel@sipsolutions.net>
Subject: Re: [PATCH 1/1] wifi: mac80211: ignore PM bit in non-bufferable
 MMPDUs for PS start
From: Johannes Berg <johannes@sipsolutions.net>
To: Lee Jones <lee@kernel.org>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>, Luca Coelho
	 <luciano.coelho@intel.com>, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Tue, 29 Sep 2026 18:32:57 +0200
In-Reply-To: <20260928142434.GA2112133@google.com>
References: <20260928100508.3487525-1-lee@kernel.org>
	 <9b3efaebb9f5460f6bfaaa284fd235e76c940361.camel@sipsolutions.net>
	 <20260928142434.GA2112133@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2026-09-28 at 15:24 +0100, Lee Jones wrote:
>=20
> The commit message was purposely vague due to the fact that the change
> fixes a security issue and I didn't want to publish a HOWTO guide for
> exploiting it.  However, I obviously overdid it a little and left out
> the reasoning you'd need to review the patch.  The short version is that
> an unauthenticated peer can currently change an associated station's
> power save state with frames that shouldn't be able to have that
> capability which can be used against the station.
>=20
> Happy to send you the details off-list.

I think I've (conceptually) known about this issue for ... years?

First, arguably wake-to-doze are _less_ interesting to attack, since
then the TIM bit will end up getting set and if the STA isn't sleeping
it'll see the beacon and recover fairly easily (though not entirely sure
we actually implement that in mac80211), and if it keeps sending traffic
then the state corruption is short-lived.
OTOH, corrupting doze-to-wake could lead to traffic getting dropped if
TX filtering status isn't implemented well on the AP side/driver since
the STA is actually sleeping and won't see any frames.

Second, I don't think in general this issue is fixable, and while it's
good to implement this closer to the spec, security wise it doesn't
really do anything as is?

If, for example, there's any bufferable MMPDU the attacker can just
replay it - we've been doing this before MIC/replay check forever
(unless that's offloaded). It can also - although this is harder -
intercept and modify the PM bit, since it's not protected by the AAD.

It's also wrong that we're doing this *after* the reorder buffer, since
that potentially holds the frames for a long time, and the spec says to
look at the PM bit after the frame exchange sequence completes (REVmf
11.2.3.2). We should fix that too, but it doesn't really matter for this
discussion:

Any unprotected complete frame exchange sequence can modify the state
anyway, QoS NDP for example.

>  - Rewrite the commit message to explain the problem and the reasoning
>    properly, rather than just quoting the spec.
>=20
>  - Make the PM handling consistent in both directions, so it doesn't
>    honour the bit in one case and ignore it in the other, while keeping
>    the re-authenticating station case from 9fef65443388 working.
>=20
> Does that work for you?

Well, I think it's really only a spec compliance cleanup, but then we
might as well try to fix some of the other issues?

I also think we might be better off making sure that as a client we
handle the TIM indicating traffic while awake and send a wake frame, and
perhaps checking AP side handles filtered/un-acked traffic well.

johannes
