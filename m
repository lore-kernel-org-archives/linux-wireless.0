Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DA83955E0
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 14:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785596027; cv=none; b=u55l/W0qcNR3jbDaq2NGknHrjri84rjSXkVCk5LZOw09dHv7fDTiwK4rP3qi84nxwMtm5LkGujb6xG7ZW2hLdz9bkwIiGrmZhhdlhdi4H3EeAM0XGkex1QfE+X/U/Tz0k0jmw4B/0s07wTg4Y1wj7sU4QZSx5xhzncP6P3G60Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785596027; c=relaxed/simple;
	bh=ZFWPoR3XPPorEysHrhZqPzJc7Bml6mUPDxJed+0ByzI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkfU/s7XEGCmHgIUEDxylqgHszRgxJLtWxj7iWO8MBa9rmOo7cGkVzld/L6/0uh84ILVWHBL7c7kOgiStJxXS5ks0DpEJTm26QS4lbq7KAg0Tb1eWtKmrd2tKbkHSZEyL+N2+NUz5h7Wjx2fMzDANyid/z8scWOQpEmeAjIpSzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=rKI91UbE; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="rKI91UbE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UszHAT4AkWEOy7SMvDXOlnG4kvInVA/WUAGEoUUhV6g=; b=rKI91UbE0rrp2jv12U/9bmewCE
	61mVKTMm7Oc+UzgPYPAn/PCafHzs9aEgh9rlH4Cn40LxIvQ2KpvbhxxZ3orj2WivNCrvmdJW/P59C
	b8hF9NZHsE6V14L3EdYfGyYAtWE4nrrjtqJnhXFhqwOQliOxrd2rqn/+nulPwSnrnMXY=;
Received: from p200300cadf14d100000000000000085c.dip0.t-ipconnect.de ([2003:ca:df14:d100::85c] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wqB5m-009znC-2S
	for linux-wireless@vger.kernel.org;
	Sat, 01 Aug 2026 16:53:38 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 09/10] wifi: mt76: reject out-of-range link ids in mt76_vif_link()
Date: Sat,  1 Aug 2026 14:53:33 +0000
Message-ID: <20260801145334.1166751-9-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260801145334.1166751-1-nbd@nbd.name>
References: <20260801145334.1166751-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt76_vif_link() indexes mvif->link[] without validating link_id, but
callers pass mvif->deflink_id / msta->deflink_id, which hold
IEEE80211_LINK_UNSPECIFIED (0xf) until the first link has been added.
Since IEEE80211_MLD_MAX_NUM_LINKS is 15, that reads one element past the
end of the array, aliasing mt76_vif_data.offchannel_link.

Reachable via mt7996_set_tsf()/mt7996_offset_tsf() and
mt7996_net_fill_forward_path(). Bounds check link_id and return NULL,
matching mt7996_sta_link() and mt7996_sta_link_protected().

Fixes: a9384b36a42a ("wifi: mt76: mt7996: rework set/get_tsf callabcks to support MLO")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index dc160d9ae537..61ef1b80feb8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -2131,6 +2131,9 @@ mt76_vif_link(struct mt76_dev *dev, struct ieee80211_vif *vif, int link_id)
 	if (!link_id)
 		return mlink;
 
+	if (link_id >= IEEE80211_MLD_MAX_NUM_LINKS)
+		return NULL;
+
 	return mt76_dereference(mvif->link[link_id], dev);
 }
 
-- 
2.53.0

