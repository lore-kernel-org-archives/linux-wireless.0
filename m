Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC48348FF72
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 19:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791140496; cv=none; b=Im/grDKKovzEbmaNVp3X6mEym5q/m6ggUuyE1yjZcOxtbQRDWZU2JmO5xfezcyXwK1J5MJxcWv1VQoHILGjZu3XL5uvLL4Nw2691ANZjdjw0lKOHtbWbvOepCY3qlT/sJnoWpFDqO7ZjldPiTi0d1cq3WrrMFBk34ndObQxFjHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791140496; c=relaxed/simple;
	bh=6HMAQO+ySPboWQZUzbPwNs4rJ5X5XrbwXYdtSOcd8XM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=nPG/qGPQEo6e/eEsfd/Fv5Mt62p514d0z7nGKq76KHcL7S43LvkO+CuRaHMx6MuaIRwap1ChPSBTh6ZhgfHC+LRAK+bcsex3EtXgH22jjdd3YegDGbE0pQRAL8DOoIc2iOr2QCmjLhuRZJYjCvDspemjwhlwJgefMH6v89tbMhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=s9IITorf; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="s9IITorf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=oQ+VPY1FfrMsWZVa39gKW8NMbkFnLLm2wbbTCSmKjoQ=; t=1791140490; x=1792350090; 
	b=s9IITorfMdrNEUMl1NLHpDzRy+v5Fn6U0WWKjC/srob5yAWs/c7R51ZqIAnjpZ2IZq7wseElGr+
	xFDDmIkhxWKvQ4pKmzJeBCeJIvdxJ3pxwFDdhs7XlskMZVas8za3mGFDsYoldAlIAwSTq+8lp53e3
	pgn5LVJA1kGTQ0SWf1ceXLWeDRnq5ZbEkzmwkwZN/qgIiKvMKkIQqEheCT+B6F1r0/DBfndNBr9XW
	UsAlH/jgGjVmQcj5mBLyU927ttBIlPugRq/puZPKHd8Pb3JAjFJ+LfUpij57I5IVLykZvoiDOnExQ
	eIB/KCCC/InWvAjeb2Ek13klzwlRx3XarUtA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDRSf-00000004Jlo-1Db9
	for linux-wireless@vger.kernel.org;
	Sun, 04 Oct 2026 21:01:25 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 00/18] wifi: further RTNL redux
Date: Sun,  4 Oct 2026 21:01:14 +0200
Message-ID: <20261004190122.1559001-20-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

We've been discussing some issues around lock contention for a
while now, and syzbot keeps reporting RTNL hangs against wifi.
Inspired by both I looked at further reducing RTNL in the wifi
stack, addressing the two biggest concerns:

 1) After this, we no longer hold RTNL on (mostly) nl80211
    command paths, unless of course it's required for the
    specific command.

 2) Regulatory is disentangled and no longer requires RTNL.

johannes

