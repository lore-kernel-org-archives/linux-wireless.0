Received: from mail-4319.protonmail.ch (mail-4319.protonmail.ch [185.70.43.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DCA3A16AA;
	Fri, 21 Aug 2026 13:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787318821; cv=none; b=f18NB0hcRmRerz/tybKHetnmRWFzkaLIuCWjt5I+tjx50a+4Q3QQpDpgl2cA6IGqsKh9ynR4WH/SFuZYPcSK6Hx8rdd06Wx7WvTYbnEp+HqEa7ByW5xU9FXhJMCVFWbQ5xEBQpWPCE8y5GeCm6uSmpEdPzobAK9WqOnONfYXtSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787318821; c=relaxed/simple;
	bh=RMOVq/yYVJ/t1zHFfNFBFWkMeYoxZiohJENLsBDPSw8=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=j96BzDWEtZ+SslnQjYwJ/xYy6ZCVi8Ll+s4sASJt5tJ9+cDWED/zIaIZn5LOnapfLNphXQavuqupX7TB3R/7kO4S0zbdgy/ISD2M8DSzG+qnkOzSxcaQYQCnSC2c/UBc0JUl8E8frAeJkLyANMNoHWP7yw8nWE8zDvm8dtonxOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=Jj4+o+sH; arc=none smtp.client-ip=185.70.43.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="Jj4+o+sH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1787318809; x=1787578009;
	bh=RMOVq/yYVJ/t1zHFfNFBFWkMeYoxZiohJENLsBDPSw8=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Jj4+o+sHnk0QyXaTkOcWoRiXcP+0Ztgdi86Jhsn+2sMQ3710fSX//lP+wty6TCqYE
	 7wRkhnCo2wNe53PdYNY6v1xtuvVfBwWISt0ErMpMUJdf6DAapYiIeEZu8Ic0oAPh9x
	 AFY/2esZrVP3qSiw6DgGXvuTJowOOFYeUU/LPrcUOxSVgTrG4m2p8o90M4qypE3CKc
	 PQUBXYBPBPwe844PqosYaVmGF9x1/GtRNTA6ehPU5r0gMJsm8rxkwY9+quaJHWAf55
	 OaaavzlysmX3eNZ8PhNsL5DSqaXtdPo/tFScou0p9YyTJGmMidt6K74w+tZVXdAa1t
	 Y6wBZQkchD6Zw==
Date: Fri, 21 Aug 2026 13:26:43 +0000
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
From: Ryan Leung <untilscour@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, Ryan Leung <untilscour@protonmail.com>
Subject: [PATCH mt76] wifi: mt76: fix wcid teardown ordering in mt76_reset_device()
Message-ID: <20260821-mt76-wcid-null-before-cleanup-v1-1-0e364d9062d6@protonmail.com>
Feedback-ID: 184418679:user:proton
X-Pm-Message-ID: 6c7e4c8903af770bdbcc283a100b1d8847502fc7
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

mt76_reset_device() tears down each wcid's pktid idr before clearing
dev->wcid[i], which is the reverse of the ordering used on the
sta removal path. Until the pointer is cleared, a concurrent lookup
under status_lock can still find the wcid and access its
already destroyed idr.

Clear dev->wcid[i] before calling mt76_wcid_cleanup(), reproducing
the ordering mac80211 already enforces for normal sta removal (where
mt76_sta_pre_rcu_remove() clears dev->wcid[idx] before
mt76_wcid_cleanup() runs via the .sta_state callback).

Fixes: 065c79df595a ("wifi: mt76: mt7915: fix list corruption after hardwar=
e restart")
Signed-off-by: Ryan Leung <untilscour@protonmail.com>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wi=
reless/mediatek/mt76/mac80211.c
index abbe65cbcd89..0eb021be837a 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -856,8 +856,8 @@ void mt76_reset_device(struct mt76_dev *dev)
 =09=09=09continue;
=20
 =09=09wcid->sta =3D 0;
-=09=09mt76_wcid_cleanup(dev, wcid);
 =09=09rcu_assign_pointer(dev->wcid[i], NULL);
+=09=09mt76_wcid_cleanup(dev, wcid);
 =09}
 =09rcu_read_unlock();
=20

---
base-commit: ca800a9302764c445de0da0e84d2252400a770ee
change-id: 20260821-mt76-wcid-null-before-cleanup-cdb4d640f7de

Best regards,
-- =20
Ryan Leung <untilscour@protonmail.com>


