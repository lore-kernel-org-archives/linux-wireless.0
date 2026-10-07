Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FE54519A1
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 11:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791372282; cv=none; b=mItCqF8T7Xu7tx5PHVYNlUE0fBsuTimDo6FKUSreJZGSmM0q3rsKzgMYuUfFc/5ISaQdfJnJ6/S71CWyZYB4goM0SKN/2AEbB0kpgOBduGZZM9QCn8LjNA8TpXOq95mes0197Kfc43eotwidwl8ku4M69mgHinR2Q7NLqvsms7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791372282; c=relaxed/simple;
	bh=8Io+wLhRPdO0RLQgVztnOmUX54QHxXALH8jP+WX8wpE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ut/zZJLhm7TdfcHcKuQP/hCR/GdUMLCZ63z4XPzdfM6ENcKro/gP2Z54ldXtDTF77M8nPd0HnI/Pd0bgQsfbNqxL5wFROcPDlfnJzWcDRkgBXlHKZAREQdnNtPdjrcBl6b0ia3CAq22bWFAFAQhji2YSSbl5N+9q0nWj3HeYdZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=Gr7nhcLv; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Gr7nhcLv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gkmZmYOSzDtZgZfMlVKXMLsi46BSyXm60utSFKqR5nA=; b=Gr7nhcLviuy01f/jUIO0NyIZ3j
	QfXF4TIOAZDemgmi1iPMtmQb16iDZvSldCnlBPBKmrnyaH8Cza29G8zxyPwT6FtTeffCgfVI2uF+P
	6YI1NABPaDTgG5Rxodj+QITwRB0O6AFt6xgEFHm60bgp8r0K2mIeenCCiXfQEtP26ciQ=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xEPl2-00HY5A-0I
	for linux-wireless@vger.kernel.org;
	Wed, 07 Oct 2026 13:24:24 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 8/9] wifi: mt76: mt7996: scan all bands with one request
Date: Wed,  7 Oct 2026 13:24:18 +0200
Message-ID: <20261007112419.1277594-8-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261007112419.1277594-1-nbd@nbd.name>
References: <20261007112419.1277594-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: John Crispin <john@phrozen.org>

mt76 runs the channels of one scan request on all radios in parallel.
Let mac80211 pass all bands in one request, so that a scan across the
2.4, 5 and 6 GHz radios takes as long as the slowest radio, not the sum
of all three.

Signed-off-by: John Crispin <john@phrozen.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index ad9919c516e7..312b35ac622e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -541,6 +541,7 @@ mt7996_init_wiphy(struct ieee80211_hw *hw, struct mtk_wed_device *wed)
 	ieee80211_hw_set(hw, SUPPORTS_MULTI_BSSID);
 	ieee80211_hw_set(hw, CHANCTX_STA_CSA);
 	ieee80211_hw_set(hw, CONNECTION_MONITOR);
+	ieee80211_hw_set(hw, SINGLE_SCAN_ON_ALL_BANDS);
 
 	hw->max_tx_fragments = 4;
 	wiphy->txq_memory_limit = 32 << 20; /* 32 MiB */
-- 
2.47.3

