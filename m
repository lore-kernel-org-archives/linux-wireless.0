Received: from mail-4319.protonmail.ch (mail-4319.protonmail.ch [185.70.43.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D5A477E21
	for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2026 10:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787308836; cv=none; b=FBoLLGf2uWc2+8NQM9KltZKBNz/ij9Rpnoe+G3T0XLqDlkid7DnVu3+lONQIHclL6wT+w9WAttX/Ya8Dxp9nsPuG72jBV+OU0hFP4bGdQud4xuDBp+BAErMCe5DhOLij/iNgSQbvyqmmrqHr3iTLPjaktNPPYxyj7qncMRHhZ+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787308836; c=relaxed/simple;
	bh=q1cswTBQwlfyKLjgpL/0p/xOuHzHelUpb/0O/Tv/eGo=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=R0JGotOyYvWvWQqtRzvbArkU4e246hW5ZBtDa4Pb/UxBaks9G794qlfxobcd/LpwRJPsLznJ5WlrbG+InoMqYCroqnwkWdlpa5iz90woubyJDNT4i2JO9V+PuMPzBALYMH6rK/dLv68Xl8CpdWrVJ1hYcCtp2NtfORMGK87KZHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=a23QH3JP; arc=none smtp.client-ip=185.70.43.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="a23QH3JP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1787308823; x=1787568023;
	bh=q1cswTBQwlfyKLjgpL/0p/xOuHzHelUpb/0O/Tv/eGo=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=a23QH3JPSszQ13w6n0oiuoHgBRAQHbon7SzTKxP9V/uxWtwJU/wZ7TrAOCo3g43gT
	 Y7v7yp4lJ6HqVCcmcHo4ML2mZSQLxH6IZ5VaxKAH6BZFTGNVaAZuPu75EJv5I2zhGD
	 o34NUq1SNPSPJzkfaJ3PxRm/7XAQjRSW9OI4BRDHxTqk0QQ1hgzweu/X/cQWjCWO4K
	 0brCshKKN6jO4/4azjTk733D7cdtlY5DugvAc2iVNx74nsg3gNd60mS685t3l7lzil
	 tmQuOcm4gPj7qHoxj+zmBNyNgE7CB1eOi4DFlHth3JjEtn/ke29zbR+O7W3R00rhx4
	 U/PvaoMiZ/DBg==
Date: Fri, 21 Aug 2026 10:40:18 +0000
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
From: Ryan Leung <untilscour@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, Ryan Leung <untilscour@protonmail.com>
Subject: [PATCH] wifi: mt76: fix unlocked wcid check in mt76_tx_status_skb_add()
Message-ID: <20260821-mt76-stale-wcid-race-v1-1-d6de3f842506@protonmail.com>
Feedback-ID: 184418679:user:proton
X-Pm-Message-ID: 020a7b2af528b10c02e7f3b790153a0ef2cff700
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

Move the check inside the status_lock section, so that it is atomic
with the idr_alloc() and wcid_list update.

Fixes: fcfe1b5e162b ("mt76: fix tx status related use-after-free race on st=
ation removal")
Signed-off-by: Ryan Leung <untilscour@protonmail.com>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless=
/mediatek/mt76/tx.c
index 3707ee19e4ae..fa635fe84ec2 100644
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
+=09if (!rcu_access_pointer(dev->wcid[wcid->idx])) {
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


