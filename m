Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAD635F619;
	Wed,  7 Oct 2026 23:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791415957; cv=none; b=LQz8J1psRiDX879SBOM3PcLsHvb4/O0SGJo8gcBNc1oyYQgKtv1maFYAN2XcnySjQgZgoAns9m881GgfUR1Pk/9BXeQR9g0afibvdPrleOzqmvSF2TqpBInoRSO9mRaw7x1lA8sNuas+iupFNqblJ2uaHUPZed3ajnyk/zVfCBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791415957; c=relaxed/simple;
	bh=306gKdIj03lb8UaRe0utojcZ7XSG0Ecb1msGZBLfTqs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PftTVvlpZnLIII3bvy1AUaXaKvg/tWxz3TFFYdccqc1IipST57neiujXKAXEa6GNOb0Qdi3dSAyy/Of1qFRxeRlRykY3mpKfY4lkbX88TAqYhlgwW4lmUTFjgqgcxj+sIop3+7jkkIZrDNhb5cvSTF3zO8+hYvmBuN6Fcn6dGfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eEBAgfz2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eEBAgfz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C16D1F000FF;
	Wed,  7 Oct 2026 23:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791415955;
	bh=RIx3jD7STH7OYsTyX8JirO6WGi0H54aSfwWZ7gJ0MTA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eEBAgfz2RV2MzSFnx7vVLJ1btxi3/gwcQmCT8c+x+wpNFMrTTJP+fKJoXpmZ1m4WM
	 Kj18F2QlCjly6JrkakQVooi4oWqZ1gCau1qDkcxNAH+3cLUtJqYP/wkvRUEsoremNI
	 JjeLlxqeypbHRFLwwY3Yv+xlwvjUl4pCfnuo4NBxKpQufhieYxGP6V9bPrh9ufR6SF
	 owiMZXc07TmekXzPmd+kFuRj1sEoidjd2uYOVrC3eKo0DNV0mrwrNCNunzZzfJ1uFL
	 f6c79iHU3Am50aaZSSeaxUDhyEa8I5+0GtPyLoSUh06jwoU88cxdwnN6AMvQb9hlhR
	 apWyGKrp4yCeQ==
Date: Wed, 7 Oct 2026 16:32:34 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [GIT PULL] wireless-2026-10-07
Message-ID: <20261007163234.385577dd@kernel.org>
In-Reply-To: <20261007205143.464714-3-johannes@sipsolutions.net>
References: <20261007205143.464714-3-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  7 Oct 2026 22:49:59 +0200 Johannes Berg wrote:
> So ... I pushed back as hard as I could, and Felix reduced
> by ~25 patches, and I told everyone I need to get fixes much
> earlier in the cycle.

Thanks, appreciated!

> Nevertheless, I ended up with 25 fixes (not counting merges).
> Hope that's OK, otherwise we'll try to whittle it down more.

/me looks sideways at the timer_delete_sync from @kylinos

I think / hope it's good enough. Next week, tho, if you have anything -
only security and regression fixes, please.
