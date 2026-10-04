Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5A8496D4E;
	Sun,  4 Oct 2026 21:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791150794; cv=none; b=YMQHMlyUbaGonwMKQ6AeVDwnqIxDkpXBk0VfWLfdI/VZz6/Urnqve875uAIUGC0CYwTRJ0tUlL3BYD5ARcBlFAdTPN3R1tlpTzbdONVQkvuyTi5Os4QZJHvQy9m63NfVXrUMrD6eRgg8rSAski8bbCux4308Tl/z86e44c5RWLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791150794; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=r/Dq3s9XQ+dL27Z3PJKoNYCD/0qxw7tF+Gh4oLwg05EzRIMDaRm0BOBVoDNVRjZ7DGG4S5aHBteRzj3Uto+x45oTRUYG3g6gl27hcB3oyxjE5Lr1Rtv+2QZBfcjLMClQazLui3OQ99mPITSghvPXfCNpO1QRSWwaBJ8DKNPkIN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ak2mUlF9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ak2mUlF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F791F000FF;
	Sun,  4 Oct 2026 21:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791150792;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ak2mUlF96R7OUbow7ay+Be0RdAiz7pq8E+aCT/TIbU5p2Vsxr1MEIZrHHDNc/YN11
	 jNbSxt9V+D1S/uviyjHrGpFGQJ2WSU8FSns74ekZBhYZFZgeOdhwggxjfj4BmM6sxJ
	 ccrJZ0hlAgMpsCnuofpgsbDCxBMnPPgcuwrCmEFGGWD04aLxzctMrVEe+615Djv2c4
	 dRV6/fFBQXGG1jrMlMqbME4wOgcN/hOQCLa1uefCTq5KrLwSvwbaSd3rZauB+JorSE
	 9kzcwkwnC4Y8dRrLwaeSELO64Fc89gDFq1ca8g2Oos87hFWU38amAl4x+2B0F0X7by
	 iicJ/URTjorgw==
From: netdev-bot+sinfo@kernel.org
To: Endrik Einberg <git@endrik.dev>
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: 
 Re: [PATCH] wifi: iwlwifi: mld: include VI packets in low latency detection
Date: Sun, 04 Oct 2026 21:53:12 +0000
Message-ID: <179115079203.1402591.13378681769152307097@kernel.org>
In-Reply-To: <20261004214438.128694-1-git@endrik.dev>
References: <20261004214438.128694-1-git@endrik.dev>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
