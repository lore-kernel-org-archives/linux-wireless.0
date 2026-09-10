Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCEC40BCAD
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 21:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789077301; cv=none; b=Vw055E3v6o0BYdjJJMrS5ldAcAXbqttwQsL7lR0pZcuaU9kmuDgtk07P9yT5OJhBlAmiTkTKCRpK9G4regpCjrq9SaGnc6cfGue/zH3wOoLF1WfAxBupy8LNiVfm9bZo+aiv0u2rDh7iX1/F88HBjXZP0Qm/QRUIjwqowfnxTc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789077301; c=relaxed/simple;
	bh=9Ehzebo+wU9MfyAVuGh2eu09vGLDnCZgCBDV/eCMhZA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zsl7p4lDH6y/exqlXRy/uDb4GI7xUc9nHD/UlDNyVQhPeddmgK4vuxtDyS0YToLZilS/1vb7ycrKlle+/LWP0Ex7Gn37tr1pXb713+4o0cBNTz4uMnWa4I5pi1yiBHcL9/ttBBLYRWqC1KVa7YjiHKCYixDRZNJJxO56OZhNsrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pyp95Dg/; arc=none smtp.client-ip=74.125.230.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pyp95Dg/"
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfc6db0bso1984266d6.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 14:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789077294; x=1789682094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5yA1J/Oc/mv6lA/Q/2/0pN8xrLK69dfWL8b6vtP2vm0=;
        b=pyp95Dg/MtYxe1bc98GkWytxVs0HvM1XpG/W/MgEaKymwuyhV5kq+xdAY16fO1BMFO
         8m0y9nA1S7sMmJmPe9V2pAPJkqfz+BepU0k24WQnXZ4o8R6K/9osadJYMVzVZs/VUgZ0
         txgDOVULey7LRmnK6i4r714J2J7hVDIKDsVqIJdzv/jempvj4Lu04RAmztSgTLxjwgsQ
         6lRogW/1ExivTA0ArsHeBxTPZWSmxKLOWXAJspMn2GhN8By62TNcsCN28vWcoBMhwJ7f
         UusSe23WfIWUnfZ2N+Y5XF/mHGcV16HO2MVZ7u/v0D5qqvjIzqxjvDRWjrwXk1swQ6Dc
         5i8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789077294; x=1789682094;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5yA1J/Oc/mv6lA/Q/2/0pN8xrLK69dfWL8b6vtP2vm0=;
        b=sEL3pA6EIlME9EgOU5tbD6rPi5X6kbnwKqRjSsvouNyjnWux26KFa18rvaZjQgne04
         JRw09REW+i6vWwy7RWV1HymDLnGazkywIDIX3r4czO0RMVBk1WyiXEfQTLdjzJyRsJgo
         /UUR584L94+QI4wyfNM3/QGdmAen8ZEl/NcGgWuRcvc4zv7tpYO0yYD0V22f4VWVO17J
         Ho5UInrNp+Kd71CqvK0Xnru45lEkBaQ0DROhcX4+/5IsvdrDdufbrQ0LjX6XsO7p9aTJ
         WkUljPSXuX48UMWJZabJk4xnY0hQNO8zT7IEX6Dxig3rdbBi1aO+lnEOuFAcuelpOe/+
         LF6w==
X-Forwarded-Encrypted: i=1; AKwUvBymeUiqZRbIVa4zHUk0aVQrBr9SxkH91USaUL6d1n9kayXjvE+fLkWu91uaNmO3qGfG3GD1UYlH9a/jXnHY5g==@vger.kernel.org
X-Gm-Message-State: AFuF++n8r7VGPbtRB16WkPhTkT+DZJyASsc939X7/dQ//WYuqWHbZTs2
	VzrJm1LmH7Cejd3Mr+HKutOqbJNHVe6RNfihW2M/xWK4nSyXdGQiGYI=
X-Gm-Gg: AYBFou3jp5p1gX2L3f/37adS6KeqTghatIB5nod4RN708E1/TtlpH19VJLQPCVwnosJ
	pRyVbrHZrNakd/ByLbxdEv/gcIlkXC0kjknaCqBUisN2xvvPdf9F06W2dgA3md4aAD2+mwVkeq0
	kqL5lVa3I8BIEXhZxey7sDQEyTTZ3+vEZjZTSD0ZCWgcIhY3hcMFG/T6rylIC5RrHuml4S2iPxf
	55rZKePz4pCXp4dmGRmr3888uWVvbT3y4AjnIoNL+pyF7VKSTiqE5MD5MiqdnNZ5vS+r1l9Pr0f
	lSPwtFyBdCutGSejqg0UWFFofeb65AZl/OFyKBVDnkXQxPZ7IwcMky0FZ9miLgKWAbyMqsYWMj0
	V8NIxrTch+Hdg+P/DSIgwQbto1cUtL1wb7Jqa+v20snwfZaElbzxOAHstghM7sU8+qoUORvYcOO
	klpsQuNwjz0KdEDpTCJKAY/GKzN6W/zXt2a/iABZ9XEJhsnu7YuR1jXbwWubF7uNP1MSijxtRaA
	l7YPjZMJOYz7PZOe/OP7FNWd6sqVRm6gD5FS7RFOWi7KpnLkGUvBb733IZgSiOQzCsKGqujRazm
	hu0SNMDPuxUM14WjRBS21SuJxX1D
X-Received: by 2002:a05:6214:3d9b:b0:90e:93b2:3205 with SMTP id 6a1803df08f44-912120d689emr17573146d6.22.1789077290445;
        Thu, 10 Sep 2026 14:54:50 -0700 (PDT)
Received: from localhost.localdomain ([104.39.73.78])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f496598sm5826736d6.35.2026.09.10.14.54.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 14:54:49 -0700 (PDT)
From: Myeonghun Pak <mhun512@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	stable@vger.kernel.org,
	Ijae Kim <ae878000@gmail.com>
Subject: [PATCH] wifi: mt76: mt7615: restore DBDC state after ext PHY failure
Date: Thu, 10 Sep 2026 17:54:41 -0400
Message-ID: <20260910215441.76683-1-mhun512@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7615_register_ext_phy() limits the primary PHY to DBDC capabilities
before allocating and registering the secondary PHY. If allocation,
EEPROM override, or PHY registration fails, it returns without restoring
the primary PHY capabilities. The EEPROM override failure also leaks the
newly allocated ieee80211_hw.

Route all failures through common labels that free the secondary hardware
when it was allocated and restore the primary PHY capabilities.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 0f2173f093b3 ("mt76: mt7615: add support for registering a second wiphy via debugfs")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
---
 .../net/wireless/mediatek/mt76/mt7615/init.c    | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index 42e11ba1206ee..02e51b2d42ed8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -542,8 +542,10 @@ int mt7615_register_ext_phy(struct mt7615_dev *dev)
 
 	mt7615_cap_dbdc_enable(dev);
 	mphy = mt76_alloc_phy(&dev->mt76, sizeof(*phy), &mt7615_ops, MT_BAND1);
-	if (!mphy)
-		return -ENOMEM;
+	if (!mphy) {
+		ret = -ENOMEM;
+		goto error;
+	}
 
 	phy = mphy->priv;
 	phy->dev = dev;
@@ -573,7 +575,7 @@ int mt7615_register_ext_phy(struct mt7615_dev *dev)
 
 	ret = mt76_eeprom_override(mphy);
 	if (ret)
-		return ret;
+		goto error_free_hw;
 
 	/* second phy can only handle 5 GHz */
 	mphy->cap.has_5ghz = true;
@@ -591,7 +593,14 @@ int mt7615_register_ext_phy(struct mt7615_dev *dev)
 	ret = mt76_register_phy(mphy, true, mt76_rates,
 				ARRAY_SIZE(mt76_rates));
 	if (ret)
-		ieee80211_free_hw(mphy->hw);
+		goto error_free_hw;
+
+	return 0;
+
+error_free_hw:
+	ieee80211_free_hw(mphy->hw);
+error:
+	mt7615_cap_dbdc_disable(dev);
 
 	return ret;
 }
-- 
2.47.1
