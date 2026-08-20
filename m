Received: from mail-106104.protonmail.ch (mail-106104.protonmail.ch [79.135.106.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167FA445AD2
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 12:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229917; cv=none; b=YVcRx34QH5Q/6GvEehd76dbqgkJeAqXFQZZApZuUiUDixccWywpaycnzdOuZdH82P7Uh4EbyI7tTeo0ZVMFIFohDHdepm7WboV3hc0tSi2gwU4SGSnHEp/WlaLVYgXRmYAcP6xL8Udm18Zdpces/t6nAFo8oW4KH4Jrp9nDjuVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229917; c=relaxed/simple;
	bh=AS3sZF4MOHOL/PnrFHGmfd8I3tCjlqKL1VISYbtbo64=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=YDoXXmwLIi7PEQB6VoNI78Sy+PIlwqVGI86DfbMLG1gzwuS3zU8oz9Pw5mpZK7u9BKGRGf1mtvdzm7WanEFsdS93eO+80nh7FAXRfHrO+iQJuVvn+IwrnRazjku/5l/9aSlEFGg+cvPooyJ7OeymTsDcRv8aQNxlPcARfR1myn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=f30/HuIh; arc=none smtp.client-ip=79.135.106.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="f30/HuIh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1787229912; x=1787489112;
	bh=AS3sZF4MOHOL/PnrFHGmfd8I3tCjlqKL1VISYbtbo64=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=f30/HuIhgSkLsmObikl71bREAHuLWbsagZhJ6Fy8l/A7wYXljz7OjAhw5hPwqPdnn
	 nR1dK47UD9iHzpEcQxcrxTX4ME7pzpH68fg2V9cdaagzFF+x173CD/l2lRcyMl658m
	 ofw0RhIenIquM2joQ7A8D8ILaRft17Ti5iZiE9PSwcBGHynEoNr4u2YWBYp1oU7st2
	 4xhktZU1X0zhZiYXrrGIcLwLCTBoejqXbP8aB7dwGWN17Is3bwMZcNKqxDTal0jZxe
	 kKNnIKIQ7c5M++AXd9Yc+JZCMaiciifjVE7984jXcsT9GWvX8SeBHvWWPkXRvL8aKy
	 7us2bTocPH5KA==
Date: Thu, 20 Aug 2026 12:45:01 +0000
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
From: Ryan Leung <untilscour@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, Ryan Leung <untilscour@protonmail.com>
Subject: [PATCH mt76] wifi: mt76: fix wcid->pktid corruption in mt76_wcid_cleanup()
Message-ID: <20260820-mt76-pktid-idr-race-v1-1-451f176a6495@protonmail.com>
Feedback-ID: 184418679:user:proton
X-Pm-Message-ID: e3e10a410ba36c1cb116a12f4f84991ddc9ac07f
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

mt76_wcid_cleanup() releases dev->status_lock before calling
idr_destroy(&wcid->pktid) to tear down the pktid idr. Meanwhile,
mt76_tx_status_skb_add() from tx.c can concurrently insert into
that same idr during tx completion handling:

=09spin_lock_bh(&dev->status_lock);

=09pid =3D idr_alloc(&wcid->pktid, skb, MT_PACKET_ID_FIRST,
=09=09=09MT_PACKET_ID_MASK, GFP_ATOMIC);

Since idr_destroy() runs outside the lock, it can execute concurrently
with idr_alloc() on the same idr, corrupting its internal data
structures. Because idr nodes are freed through the generic slab
allocator, this corruption can resurface later as an unrelated-looking
crash anywhere in the kernel that happens to reuse the same freed
memory.

Fix this by calling idr_destroy() before releasing dev->status_lock,
so that the table teardown and any concurrent insertion are mutually
exclusive.

Closes: https://github.com/openwrt/openwrt/issues/24594
Fixes: bd1e3e7b693c ("mt76: introduce packet_id idr")
Signed-off-by: Ryan Leung <untilscour@protonmail.com>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wi=
reless/mediatek/mt76/mac80211.c
index abbe65cbcd89..16e53c4593cb 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1744,9 +1744,12 @@ void mt76_wcid_cleanup(struct mt76_dev *dev, struct =
mt76_wcid *wcid)
=20
 =09mt76_tx_status_lock(dev, &list);
 =09mt76_tx_status_skb_get(dev, wcid, -1, &list);
-=09mt76_tx_status_unlock(dev, &list);
-
+=09/*
+=09 * must run under status_lock to avoid racing mt76_tx_status_skb_add()
+=09 * in tx.c, which allocates pktid entries via idr_alloc() concurrently.
+=09 */
 =09idr_destroy(&wcid->pktid);
+=09mt76_tx_status_unlock(dev, &list);
=20
 =09/* Remove from sta_poll_list to prevent list corruption after reset.
 =09 * Without this, mt76_reset_device() reinitializes sta_poll_list but

---
base-commit: ca800a9302764c445de0da0e84d2252400a770ee
change-id: 20260820-mt76-pktid-idr-race-29f92c15b089

Best regards,
-- =20
Ryan Leung <untilscour@protonmail.com>


