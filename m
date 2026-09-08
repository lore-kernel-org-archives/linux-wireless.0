Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5135959480C
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 17:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788888602; cv=none; b=iYKEVetvG8raF5fNChb+iEpxK0au5ikOdXIDUGEe2lZSGbIwxMPO5XxUgOEdw3pkO+4w48JGioDA3IL3qkVHlh0p/22jbC4/OEjRDf9TdoY+5Yw2pLvnZ2VfnWHxhDBnHsXZgJSvCIIbplnXiaf5EhLl2XReD20iog/dcGgrDkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788888602; c=relaxed/simple;
	bh=ludU3LRJrhrj779pVIkzn4OZyl+iut+KoDhwPlpmcjw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QVCXHTi8JMPu+teCOh7Ca89oroUCcEsgciQx/nmJJ63vwAGN5yb7F0qNgM5o7sXgYuyLJ0wfzxJ8rbh7mej7i5pPz2dWSuQs6EKfSLhOaizVTzqL59WD8yym+zutHxrxBYSYoIgiauqSv+DZQtt+EFRheRySXyeW8bn4/2EuTV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=orX0nvVg; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="orX0nvVg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=rZSvpjkoG14ys5qNARrHi0J8dkGSnvgSwSKW+TboaMo=; t=1788888600; x=1790098200; 
	b=orX0nvVgoNVpjIhBPDwepoPPmWMsZ8EbLbTQnQEH3OPaPDQwfJCmMYans70Fx6u2JuXechh5QDk
	ObDOC4BenJYLHR32jR4uY9BRRUyOVClmgOg0U3eRkNqyMFhWlajWQU+rI6xV5kxU66rmMN6DNQ6Mt
	u82ySD+BmCKUBvICIGs4fvTFNuLk/clh2NLyNY86D0BP7jfeFlYU9e81zTXyl+cfLVwyS0WqobXIx
	LL7l1sbj8/OCspIGKS78Bo/9oxauyJOzmtohMPmgWeyo0xjFrDkszwvC2malcbSrWzHNoU7/W4s1V
	wg+ZLOqU2GNzVgstsCxTRQ5+2lfE5gAEJ7GQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3zdt-00000006RDy-1oT2;
	Tue, 08 Sep 2026 19:29:57 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wifi: mt76: avoid iter_keys_rcu() where not needed
Date: Tue,  8 Sep 2026 19:29:55 +0200
Message-ID: <20260908192955.5cf136377203.I70dc9768829e44d43a68e62b8e0590044dd3c2d3@changeid>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This place already holds the wiphy mutex, so it doesn't
need the _rcu() variant. Simplify the code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 2f925d22b9aa..4351fbb617d8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -2490,9 +2490,7 @@ int mt76_connac_mcu_update_gtk_rekey(struct ieee80211_hw *hw,
 	gtk_tlv->rekey_mode = 2;
 	gtk_tlv->option = 1;
 
-	rcu_read_lock();
-	ieee80211_iter_keys_rcu(hw, vif, mt76_connac_mcu_key_iter, gtk_tlv);
-	rcu_read_unlock();
+	ieee80211_iter_keys(hw, vif, mt76_connac_mcu_key_iter, gtk_tlv);
 
 	memcpy(gtk_tlv->kek, key->kek, NL80211_KEK_LEN);
 	memcpy(gtk_tlv->kck, key->kck, NL80211_KCK_LEN);
-- 
2.55.0

