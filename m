Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53B138399C
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 18:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785869504; cv=none; b=kRzcTHksxm6lcMwFPDOu6Fik0PWS4bQ4EHYz27W7jRbkv5/da/PvXpddF/1bd50lo/ODl1A5qp0R4/SBJ37Mq+Iv5PenFH0yZaSvX3QNA09hx1ttqpKQkKWhkOh5F7b0f6i6Ba8POGOo+0qk+re6xEeKz1qWxQNEhDhwbWzGt4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785869504; c=relaxed/simple;
	bh=/MzzPCUnDtjfXtg4gz1C+xzEwuEYtyQ/DlPeFZvVylM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuhpD6mQsNkV9GV2Meox9/cvLguCXFzTcP5//CobXf4AAciYX85FlqY2OOIDei2wB/JMjEc8N1rm836+fPUWCSmfsQw/nZ2u74nob8yYKIy/MsWs0gllL5ApU+b72+2Tj+jcOztkSmQyCjVUREBF836fwiQt1uvcHlA+jpgT9uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=PcrxqVgg; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="PcrxqVgg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1785869499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/MzzPCUnDtjfXtg4gz1C+xzEwuEYtyQ/DlPeFZvVylM=;
	b=PcrxqVggSRYNSrpviVJLGoTW2gcT2pZYAg1c8iVJWyqZrYKu69NNARy6JZ8IdWHrmHArx8
	TIMBE2oYA9aTG6MZhsX3ougThgJixZ1hZMCCoz7c0AwxIaTHTDuhvGKJhZgGXUs9pqab+h
	TL2jY/ddssnzG4n6qfuIbZGBsZw//sV6hx3EB+Zsgf1um7OAS17EgDbHLz7fyV3N913wbR
	mtm679bsw4Oxl82XcFRTDocl6uK3tjIe1qja5qdZIunXdAUigFeeNWLsfaH6DWoR1vigdb
	Bkpm41WCZSv0Lmcx7EZhIIwMwiI7WdtbcSgNVebH9A7BfH9LL39pFaXklOTySg==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: JB Tsai <jb.tsai@mediatek.com>,
	Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	regressions@lists.linux.dev
Subject: Re: [PATCH] wifi: mt76: mt7921: refactor regd update to fix recursive mutex deadlock
Date: Tue,  4 Aug 2026 11:51:18 -0700
Message-ID: <20260804185118.19705-1-lucid_duck@justthetip.ca>
In-Reply-To: <20260629083543.153564-1-jb.tsai@mediatek.com>
References: <20260629083543.153564-1-jb.tsai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This one is still missing from mainline, and the bug it fixes is in 7.2.
Could it go into a fixes pull before the release rather than waiting for
7.3?

Current master still has mt7921_mcu_regd_update() taking dev->mutex
unconditionally, and mt7921_regd_set_6ghz_power_type() still calling it
from mt7921_mac_sta_add(), which runs with that same mutex already held
by mt76_sta_state(). Any mt7921 station that associates to a 6 GHz AP
self-deadlocks. It is not only a warning: wpa_supplicant blocks while
holding the wiphy mutex, so NetworkManager, the cfg80211 workqueue and
new ssh sessions pile up behind it and the machine has to be reset. The
call site arrived in e88098133ed4, which is in v7.2-rc1 and not in v7.1,
so nothing released is affected and no stable backport is needed, but
7.2 would ship it.

I reproduced it on 7.2-rc5 with lockdep on an MT7922, then applied this
patch and repeated the same association. Before, the recursive acquire
fires and the box is gone. After, it associates on 5975 MHz in four
seconds with no splat and nothing left blocked. Nothing else changed
between the two runs.

Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>

One small thing for whenever it moves: the Fixes tag cites dc2608cf5224,
which is not a mainline commit. The mainline id for "wifi: mt76: mt7921:
refactor regulatory notifier flow" is e88098133ed4.
