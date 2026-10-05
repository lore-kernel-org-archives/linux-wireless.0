Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B7A43BDA3
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194735; cv=none; b=dBC34uBdyQrBVyc5Lq4jQgZrw1WlUoCRhTmYwjWPJRLQGH++WRDFPDSbBJPun5KjiI81ElPheaKOnYuuZ+ZMvZkP6mr4GYmOEpUN8+WS3pv6oKi45kJO8kwNgoXLWR+xw/2h9wl26OlNcdA86+1CgRqGYGtB5re4yHuNt3HTyAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194735; c=relaxed/simple;
	bh=G++tmpDjHVjz+hHWjx6NLIUKolKmwirLdIY3absOZEs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=YkoZUFk+iE85VozBb9uNwKYCX33kyNlsCmNyHZreknANGMVvFdgojPcJ9OGbVcLVFCvXdFYQwLAIgbAyMh39rkKe/FYgRjT+GOFzf1YwPn7WgY5dQWspfdo4pRagwJZ6pSKcwVzFmvrdaK+Nfpfj05VmLfudlBY5zfea1wV9AvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=vQUepORq; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="vQUepORq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=MuXptRtEfaimdpZibDPT9VH8DUa5XK4hyf7e93/CNaQ=; t=1791194733; x=1792404333; 
	b=vQUepORqeUF/Yr4TM70/5D2il+fgbJAYsACVg4dhFqMwOWOqnQOTFGiJRnuPkHKNYoGu7fYr9bj
	2pA92Ahu3enluQCs8aL4gxMj3CiHMWI/UMYc2a4l9tJJ2vFwkr/MRcV3+r65+YTW+HcAbF/9Dd5pM
	YqcB7JD4S6Hy5UNpwRQkb1z7NW5t32J6oyj8BJr+22APg9k7GE46x4TOVyPu1/VnzyWNhyL+P2dzd
	kbL0TylSkPVFkpWt7QTQ3FblVZ2OnX05AuD3UCVa4G+IGNB3y3no8iLWzvN7CwK1yzfRKKzI0jPiY
	hegKbPOMJtz95dsC4Px5JnjoKkfhNyZoWN6w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDfZa-00000005Bml-0wgq
	for linux-wireless@vger.kernel.org;
	Mon, 05 Oct 2026 12:05:30 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next v2 01/18] wifi: further RTNL redux
Date: Mon,  5 Oct 2026 12:03:27 +0200
Message-ID: <20261005100525.1991059-20-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v1: https://lore.kernel.org/linux-wireless/20261004190122.1559001-20-johannes@sipsolutions.net/

v2:
 - patch 3: fix netns check/crash, fix race in tests


No new notes, so as before:

We've been discussing some issues around lock contention for a
while now, and syzbot keeps reporting RTNL hangs against wifi.
Inspired by both I looked at further reducing RTNL in the wifi
stack, addressing the two biggest concerns:

 1) After this, we no longer hold RTNL on (mostly) nl80211
    command paths, unless of course it's required for the
    specific command.

 2) Regulatory is disentangled and no longer requires RTNL.

johannes


