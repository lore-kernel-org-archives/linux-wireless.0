Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CF3385D7E
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 04:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786337647; cv=none; b=PzE6xHQBV43dUYldZPGf6/JE0Gbw3eQKHxskpiFydBcy9UpmZcQyYDtQg/VyJhCNXMRTxOZ3ZCq85rAmi8JZUD+CKGmWIILaZH9pqH+cvbutyZPyQjzRkHD+MGG/cLbzjCO9Y0GOGO8wI1juU07Eszko3lB9yUDe6OJrkB8cFx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786337647; c=relaxed/simple;
	bh=1q1G0Lvmkf+l3APz28JnIINKg0rUFkYZwoIb6klQPn4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hTDej4QTHvKwuVCWB+Icq15fvyy4rBlz30XbXOMSA2Gk7iitZP8f55yW0t17reFUheD/LGMY77kXFxXuvAT5qCFX+yB55goimVgKV3ooPW+Z0OJH/kJHXjzBPhPn77ICAQ5fY7H2XWq3Zr4GRAHulE1+7Jc5tJlsDHtnSDGyZJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=fMJiT5uZ; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="fMJiT5uZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1786337638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HklBtXT5z2eP6Jd+6xFEIxRxNCWdG9+0mFY5FBdjaSI=;
	b=fMJiT5uZCjkZR53vAo4a1PebCXDYnNbxWsln+Pq4tR9QatR8dK63IidfBkA/8xuJMqS8BO
	rBV3suhM7/KJ13efnKkdbg1uuowXLPKXhqnor4Kj75IRv1txESABM3PXdAp8Kpkd6idxbf
	6OuKZdFo2BfONwOPNrpIX8ZFnquyn/evPpUoNMo+YqDK2++XyoWcJ8+IoolMke+slFvATS
	W+4UNPWjZepLrfVLdekNB/U0thHwMzeiGWOl0vWH0TD2uSnPWIn4Nnd6/xepjN3fB4rB7G
	sRgXqWOrBi9+MH3f1zQuUtLbou8p94Z5XwKPlzUSJLBUaqs8qvBf8zI1O36qnQ==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH wireless 0/2] wifi: mt76: fix the dev->mutex / iflist_mtx inversion in .config
Date: Sun,  9 Aug 2026 21:53:36 -0700
Message-ID: <20260810045338.118923-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

mt7921_config() and mt7925_config() hold dev->mutex across
ieee80211_iterate_active_interfaces(), which takes local->iflist_mtx.
mac80211 goes the other way round: it calls drv_unassign_vif_chanctx() with
iflist_mtx held, and mt792x_unassign_vif_chanctx() takes dev->mutex.

Deleting a monitor interface that has a channel assigned hits it. On an
MT7922 with lockdep:

  ip link set wlp4s0 down
  iw phy phy0 interface add mon0 type monitor
  ip link set mon0 up
  iw dev mon0 set freq 5180
  iw dev mon0 del

The splat comes on the last line and nowhere earlier. I reported it in July
and had no reply:
https://lore.kernel.org/linux-wireless/20260730053916.109426-1-lucid_duck@justthetip.ca/

Both ops are reached only from drv_config(), which asserts the wiphy mutex,
so ieee80211_iterate_active_interfaces_mtx() applies and never takes
iflist_mtx. Reproduced and fixed on an MT7922 and an MT7925: splat before,
none after, monitor mode configured and capturing on either arm.

Its kerneldoc says the iterator cannot sleep and these two do, since they
send MCU commands. That line is identical to the _atomic variant's directly
above it, and no version of the helper has taken RCU, a spinlock or
disabled preemption. I can send a doc fix separately if you want one.

The other sites from that report are follow-ups.

Devin Wittmayer (2):
  wifi: mt76: mt7921: fix lock inversion between dev->mutex and
    iflist_mtx
  wifi: mt76: mt7925: fix lock inversion between dev->mutex and
    iflist_mtx

 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 6 +++---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.55.0

