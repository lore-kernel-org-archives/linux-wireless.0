Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6D0469859;
	Wed, 30 Sep 2026 21:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790803143; cv=none; b=JyoLUTcgaDyyA78dWiOtOrTviLlZd2zfk2jmsTqpUYidecMxealVwyy6vJQTqSHb/eG9E7ntPDmu6gEr167VUATKe6BaFmhharyJL3AZuoUFjSUcjKnUELoflmngWyIxY6D9UsktqYabhoTC6VL89zAAPBLgeH1HffIwMKk9BPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790803143; c=relaxed/simple;
	bh=DlQUTKzuK/SZuKtymZTL8FDkJ29DBcg2fxbaHp1qDhg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rNKe9MEbjbDM6Y6EySCy2YY/Y5aGKOIWshpvpcWE19MJmfiAAnbo7wLgE/Urt4U2zVxNAce4RqsQDLOOjuLLdPM2eWG6bTDrqTw+kWd1wi1itwlWSj5HDRz1gi9wK9BPwb/koBXN8ITEAOz9FPuDA0YoHSbvNzOXV8lNMwLFt1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZD2r0moX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZD2r0moX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091C71F000FF;
	Wed, 30 Sep 2026 21:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790803142;
	bh=DlQUTKzuK/SZuKtymZTL8FDkJ29DBcg2fxbaHp1qDhg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZD2r0moXQnjCevEdxjoNELUy1fvtD+z3l2Q1sfN7TJiY/E5pOynNFRu8PvzBhmCNy
	 TMhGpq8Hbi8rNtdMU1OLI+bYc4jfE9Nl8nZ4WqESHEt2oSyi24eQISCm9/jT/7VBaK
	 bF8cdTM0kTwbRXZX8kBFQyN5XC9o1hkhtpPnGdnmIjPZntRUZnl9lhoDeBX7xK68hM
	 CY3V4LgFqzsZDvFn5oModfjBo+jAKJY6rjWFrTJVr/t5vw8E2rsa3ukUv2Lb7vA9ca
	 i2fsqdcIgP+c6TJlD6uxX6jEAAwM8dlYmgLdsy6YnFlLNIFN2f++CQ+uJmDnT83Ehp
	 wHYXtAtwOY85Q==
Date: Wed, 30 Sep 2026 14:19:01 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [GIT PULL] wireless-2026-09-30
Message-ID: <20260930141901.618c04f3@kernel.org>
In-Reply-To: <20260930124440.224799-3-johannes@sipsolutions.net>
References: <20260930124440.224799-3-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 30 Sep 2026 14:43:00 +0200 Johannes Berg wrote:
> Things aren't really slowing down by that much, unfortunately, but
> these are mostly fairlyh obvious changes.

FWIW Linus started pushing back on the PR sizes last week.
So we gotta be more judicious going forward. I think you were already
more judicious than us in general, but keep that we got warned in mind.

I spotted some probe/remove fixes here (wlcore, iwlegacy etc), I tend
to queue anything like that to -next these days, those are infinite.
Potentially also the Tx status reporting ? (AFAIU that'd imply a
malicious device.)

All of that only if you have spare mental capacity.
Otherwise just ignore and keep doing what you're doing.
