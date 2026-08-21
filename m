Received: from mail-43167.protonmail.ch (mail-43167.protonmail.ch [185.70.43.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A32347798C;
	Fri, 21 Aug 2026 11:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787312584; cv=none; b=H0uP7ZFVTrTc+2D9KGyOpY9HYmMsm6uc5+SDHG+wnC+nqhDQQ8r3y8GVr7diLuP/8ifZXxY3SJXjse186eJ1MvaiIUid101oJiC23jxA6O5rRssVEC7jkVJD0/A3EkUmEwBBZ+9bLXWGBKjf1pn04Q1NTdvdHDwhgr0RAjh+IQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787312584; c=relaxed/simple;
	bh=Gn5rXzgaCQ+pN2I1F5DQj309TVsHIfh0rSytoOr+BSQ=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=l8Uf5ijYrcKzapHUy3pZkNMfmW3Dq2DVq8sVXBvlAfrYn2TFIrIpGUD1qHEFbjD062FaSBH4CL4YdILgBjTgyxV4ID8q/v69sBj5p44VplGXwtf9e9VcA580VBQpyWTkuibERRXikwWHEwK7o1ICj9bkLRHFRZl6EyiZTMETqOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=g2m3bnfd; arc=none smtp.client-ip=185.70.43.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="g2m3bnfd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1787312573; x=1787571773;
	bh=jjKPMwvPqtf/gUezHlyDyQGNtBYP8TfCL07SrlXZxuY=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=g2m3bnfd51Jj38PRgNL9Gm5kKdQWw87vtLK0N/oPBRFDXEIH+gOFzqOMLVZoIVtx4
	 MP/ASCPT+DBlYB+wOX1RDmiA5yV/sNeSi7dAYhDCATwfqWUdMDVRAvZ9++kNFf3u0g
	 7cKJ1WQ7BduiLLz66rRIF60B6ldZXeL8s+iAmGdmgBTsAuCtXDAFF7VdTjcsgE/3P3
	 3Er4TOjnOID0UGtN/eWD3durdF7fBDuZOHUylmT1iq1MUroDsDVljOW56JEYWRvC8T
	 K5xA/hzk61oLrIsLVgrkyQMdnAiHq8xvTU1OBRsdULnQf82AXwaE1MGAFw4/QuP2AJ
	 P18m+iHQMaw1g==
Date: Fri, 21 Aug 2026 11:42:49 +0000
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
From: Ryan Leung <untilscour@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, Ryan Leung <untilscour@protonmail.com>
Subject: [PATCH mt76 v2] wifi: mt76: fix unlocked wcid check in mt76_tx_status_skb_add()
Message-ID: <20260821-mt76-stale-wcid-race-v2-1-8f41ee96fb73@protonmail.com>
Feedback-ID: 184418679:user:proton
X-Pm-Message-ID: 5be2479b9671e0d2d5fe00c1fbaec1404868cb17
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

mt76_tx_status_skb_add() checks rcu_access_pointer(dev->wcid[wcid->idx])
before taking dev->status_lock, then allocates a pktid afterwards. A
concurrent mt76_wcid_cleanup() can run between the check and the lock,
letting a stale wcid be re-added to dev->wcid_list after teardown.
Worse, the check only tests for a non-NULL slot, so it also passes if a
different wcid has since been published at the same idx.

Move the check under status_lock, alongside idr_alloc(), and compare
identity (rcu_access_pointer(dev->wcid[wcid->idx]) !=3D wcid) instead of
just testing for non-NULL, so that a reused index is correctly rejected.

Fixes: fcfe1b5e162b ("mt76: fix tx status related use-after-free race on st=
ation removal")
Signed-off-by: Ryan Leung <untilscour@protonmail.com>
---
Changes in v2:
- check that dev->wcid[wcid->idx] still points at this wcid, not just
  that it is non-NULL, since the slot can be reused by a different
  station between the unlocked check and the lock being taken.
- Link to v1: https://patch.msgid.link/20260821-mt76-stale-wcid-race-v1-1-d=
6de3f842506@protonmail.com
---
 drivers/net/wireless/mediatek/mt76/tx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless=
/mediatek/mt76/tx.c
index 3707ee19e4ae..0f74d808d328 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -129,7 +129,7 @@ mt76_tx_status_skb_add(struct mt76_dev *dev, struct mt7=
6_wcid *wcid,
=20
 =09memset(cb, 0, sizeof(*cb));
=20
-=09if (!wcid || !rcu_access_pointer(dev->wcid[wcid->idx]))
+=09if (!wcid)
 =09=09return MT_PACKET_ID_NO_ACK;
=20
 =09if (info->flags & IEEE80211_TX_CTL_NO_ACK)
@@ -147,6 +147,11 @@ mt76_tx_status_skb_add(struct mt76_dev *dev, struct mt=
76_wcid *wcid,
=20
 =09spin_lock_bh(&dev->status_lock);
=20
+=09if (rcu_access_pointer(dev->wcid[wcid->idx]) !=3D wcid) {
+=09=09pid =3D MT_PACKET_ID_NO_ACK;
+=09=09goto out;
+=09}
+
 =09pid =3D idr_alloc(&wcid->pktid, skb, MT_PACKET_ID_FIRST,
 =09=09=09MT_PACKET_ID_MASK, GFP_ATOMIC);
 =09if (pid < 0) {

---
base-commit: ca800a9302764c445de0da0e84d2252400a770ee
change-id: 20260821-mt76-stale-wcid-race-4d92f898437b

Best regards,
-- =20
Ryan Leung <untilscour@protonmail.com>


