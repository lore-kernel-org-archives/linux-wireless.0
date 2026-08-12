Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [185.244.194.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2C841D12C;
	Wed, 12 Aug 2026 11:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.244.194.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786535913; cv=none; b=h75LgX3JBj3xVcGOEsGdmNF2kTREC5vvJHmpUmE8bUigqUVrsDBAeZbIQDRzFGly91QBfVwkq5JLhJiQ7r3h8n2A/tQMb4AK3U8KV70lPn8lSqB3S7ptp0D1wW/83fBdZjSpIyiEFh9sfcB5qz+0LETYoB0X6fy93AbXNR4Ipm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786535913; c=relaxed/simple;
	bh=bvmb/TiVePQoacyNeg/EPqKiK1zhRGjv56Pw0yKl1ro=;
	h=Message-ID:Date:MIME-Version:From:Subject:Cc:To:Content-Type; b=Si9X7Kq+7bXpGLLrOe0Vf00svyn5azLl2ZeJdOyUlDb8FcKTSK9Ps6zqrxhCiE4QR21o9QDzvq/m+YNbLOrQaMAyn08nk61f8YqVDAGMQpNPU+KZS2pPX2n/m68TjI0ohePBt1N5/wFKDryjWpWYIOQ5pB5y3TqFJbIVwpaKlYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=dGO+XS8p; arc=none smtp.client-ip=185.244.194.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="dGO+XS8p"
Received: from relay01-mors.netcup.net (localhost [127.0.0.1])
	by relay01-mors.netcup.net (Postfix) with ESMTPS id 4hKn6y71pDz975C;
	Wed, 12 Aug 2026 13:57:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1786535867;
	bh=bvmb/TiVePQoacyNeg/EPqKiK1zhRGjv56Pw0yKl1ro=;
	h=Date:From:Subject:Cc:To:From;
	b=dGO+XS8pj4A9/os5e6AyArwGHyKLPUo3EmyqtG5lmEWNGAr2/LUeAZkdc2dIuLirH
	 EoM4YhRh7hQeh79a8k6p0XRjA0M8zF0IPJmchegA2V9QK7g8H5FXW8ahS++JK5YUia
	 kDmCa+l9NWZ13KanM7NNT8aczltPUsmbJ9dthgpPTspVMnl656CXHPrtm15hZl8a/Y
	 uqSy6FzOclUlAmLNVyJ+f828dbIvWzQ8ljlpr3EXyM9OX8uZgF2T+w3N5VCgYNNOlG
	 aGwHC3ZlxlshfUD4e94M+B8SxrFn2+YDIO4IBTHHoNB5W2yBmQ8HNXiYw4bm5Lr1Yb
	 nT/MM1Fx/1ebQ==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by relay01-mors.netcup.net (Postfix) with ESMTPS id 4hKn6y6JDVz7xHY;
	Wed, 12 Aug 2026 13:57:46 +0200 (CEST)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4hKn6x5YWHz8sZg;
	Wed, 12 Aug 2026 13:57:45 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 7C2555F960;
	Wed, 12 Aug 2026 13:57:40 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <7e66ca09-fa70-4a3c-948a-0c46b268655c@leemhuis.info>
Date: Wed, 12 Aug 2026 13:57:38 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
Subject: wifi fixes that might be good to have in 7.2 final
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
 Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
 Linux kernel regressions list <regressions@lists.linux.dev>,
 LKML <linux-kernel@vger.kernel.org>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 netdev <netdev@vger.kernel.org>, Devin Wittmayer <lucid_duck@justthetip.ca>
To: Eric Dumazet <edumazet@google.com>, "David S. Miller"
 <davem@davemloft.net>, Johannes Berg <johannes@sipsolutions.net>,
 Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Ryder Lee <ryder.lee@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: 
 <178653586107.1439299.11653628339469674671@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: 7C2555F960
X-NC-CID: 1NwMoK8I3ZVzD21OQrVtGqKGwuDzwniGHhZtSLj/0tLP6qHZePQ=

Hi nt76, wifi driver and net maintainers, just a quick FYI:

I think it would be good if the following revert from Mikhail (CCed)
could make it to 7.2, as the 7.2-rc regression it fixes was reported
multiple times over the past few weeks -- at least seven times iirc:

Revert "wifi: mt76: Disable napi when removing device"
https://lore.kernel.org/lkml/20260804120004.523934-1-mikhail.v.gavrilov@gmail.com/
https://patchwork.kernel.org/project/linux-wireless/patch/20260804120004.523934-1-mikhail.v.gavrilov@gmail.com/

See that lore thread linked above for the details. The revert is sitting
on the list for a week now afaics; there was an earlier attempt to fix
this, but it was abandoned due to problems.

Note, as mentioned by Mikhail in that thread: that revert apparently
reintroduces some WARNs which a separate patch is supposed to fix that
Nicolas posted yesterday after coming back from vacation:

https://patchwork.kernel.org/project/linux-wireless/patch/20260810154923.32546-1-nicolas.cavallari@green-communications.fr/

Ciao, Thorsten


P.S.: I wonder if "wifi: mt76: mt7921: refactor regd update to fix
recursive mutex deadlock") (which is as 1f83a8378eb26c in net-next /
https://lore.kernel.org/linux-wireless/20260629083543.153564-1-jb.tsai@mediatek.com/
) would be good to have in 7.2, too. From the description of the 7.2-rc
regression Devin Wittmayer gave in
https://lore.kernel.org/linux-wireless/20260804185118.19705-1-lucid_duck@justthetip.ca/
it sounds a lot like it might be wise to have in 7.2. To quote:

> [...] wpa_supplicant blocks while
> holding the wiphy mutex, so NetworkManager, the cfg80211 workqueue and
> new ssh sessions pile up behind it and the machine has to be reset
