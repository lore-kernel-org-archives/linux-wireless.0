Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F17469842
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320384; cv=none; b=M2kHFkJnzaczhMpZb/mot1uPUdGANNu/qBdYoj+AzHoUpwdbqQXOwrhE6XYL6LlJBVq4UaScqABdJtcUHF27cHmnKT3k+LoUMphdAAAjnDWe1mfjM4Ya0YFvr9IFNEi4oOAo82gVEPgJ2C3HawVyuESPI7cDucrsjcF9Fv5+oVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320384; c=relaxed/simple;
	bh=pVw5Y99UfTt03YLMmI8F+Dn/uwaWvr794wnv+Vysm9U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/o8zpfbBVpY96hf77ILXKaskZxiAuTUsP7/aSVsmSOy0AKwHBFHIGUAyJX/NvSZ0hGO8baJme4Emryrv17fkFn6Sb4MwIuq0WE6Z8dhB5mkLsxun/Lp1ye8KK1V0V0c0f45pevzhHl59jXc46boZkeBjSzHuMRoiq0JlE93e9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=YodPc9Fv; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="YodPc9Fv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8K91nDi34ZEnY9bpyCv8k4wudprdF9W7S9hW7a4MO1c=; b=YodPc9FvCqNywHH5iOI6US3EZ6
	96no1x7HRFAEEc6nOqbECO8Y8xwmsVnpoqzo3MV+JPwRo9rBNlJTjuOf91DO2gfrJgkKKVpe7uOZX
	gKaYEX0KKKKJEySU7IMaHn8IhYhLLLH9z1L/X5Clelm0Ua8EOTEC0p0G0UqCvostldVc=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGC-00HAg3-21
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:40 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 07/27] wifi: mt76: mt7996: upload only the keys of the link being set up
Date: Tue,  6 Oct 2026 22:59:16 +0200
Message-ID: <20261006205936.669125-7-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006205936.669125-1-nbd@nbd.name>
References: <20261006205936.669125-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7996_vif_link_add() and mt7996_vif_link_destroy() walk the vif keys
through mt7996_key_iter(), which passes every group key to
mt7996_set_hw_key() for the link being set up. On an MLD interface each
group key belongs to one link, as key->link_id says, so a new link gets
the GTK and BIGTK of the other links written to its group WTBL entry,
and its hw_key_idx set to their key index.

Skip keys that belong to a different link, as mt7996_set_key() already
does for keys that mac80211 installs.

Fixes: eddc7286f6bb ("wifi: mt76: mt7996: fix key add/remove imbalance")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index e5f74f23d469..e74254928578 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -291,6 +291,9 @@ mt7996_key_iter(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (sta)
 		return;
 
+	if (key->link_id >= 0 && key->link_id != it->link_id)
+		return;
+
 	WARN_ON(mt7996_set_hw_key(hw, it->cmd, vif, NULL, it->link_id, key));
 }
 
-- 
2.47.3

