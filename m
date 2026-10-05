Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D5C37E5D9
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 20:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791233404; cv=none; b=epzFZlh6avRCrc9t0ar+4ndQAYbgQgZFW7saAh1fAiEdu3/nEH2Gv2c3PWBGNd1CiKNiQ+8xtm7iE2ZyMLWP90If5vKOP3JYOSx7vYoqHadbkfWG3Dhk112ACkidR7KQNAcf4ocZVpRylV0uX1SooytezJswoEZDxeXIFJE4dY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791233404; c=relaxed/simple;
	bh=y+rbQd6TFqVjytI0tOFMZ3T62bw79vZAtdADV0W7gH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZ/TXwPnRz5FhrWMf/eHMl7/CJNLLI4UHCoXlfpRYgu33XY2DiSNmgIuIk0W0w6YKP5oNTnTl7WqiW+++PTxnCpCZqhbP1CO4gdLJ42Ag9H78YX8PuvWiVFaglVgJZQtliESOGxi5kE1ESvbTCuKq8kTXJs3HKJVezhpRn5pv/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=SNYpmnA8; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="SNYpmnA8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ru7mZ4iwYqKypzdacqlMzq9mfH064WItceb5con2feQ=;
	t=1791233403; x=1792443003; b=SNYpmnA8fZZFUhY0JMNpeoMzvhzehoilaGJsuhAMRVxFjEn
	Cztl/uHtN1i9y31kiDrGisv1JFkXOjhruqllBttbvJ/6mIy6T5nvhxvT6S2Z2OLa0jA+t/ebBVJ9a
	K4ZA+KpZ4Ny6caVfve2YBWg4fsXj0ISB7ttTSSwsmlObEeAAsOrARtlzMF3VzdwMvvoLUJWi+2LZa
	ZcZ+IN9q87szfh+WyUJs7Sa2pkRph036tzfkuzE4yZbez056duorre2dsv+PF+pIITCd6inL7eCGb
	EsEhIb+9ODvD6h/mbBs4MRO+AB36T75WW+YU2FQYHHspdJUDzWcvTIgPg9wTShgA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDpdI-00000005cw8-2mNo;
	Mon, 05 Oct 2026 22:50:00 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 10/10] wifi: mac80211: fix TDLS setup frame length check
Date: Mon,  5 Oct 2026 22:48:01 +0200
Message-ID: <20261005224950.c3cf023d5191.Id537db8aca13e6df999938a3bc4cc6ce2a28f733@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005204950.2303430-12-johannes@sipsolutions.net>
References: <20261005204950.2303430-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

If TDLS setup packets are created by AF_PACKET or so, then
the payload may not be present. Since we only care about
those mac80211 generated (which are linear), just replace
the skb->len check with a skb_headlen() check to avoid any
out-of-bounds accesses.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 27294466958d..8a9466ad9fe3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2606,7 +2606,7 @@ static inline bool ieee80211_is_tdls_setup(struct sk_buff *skb)
 	u16 ethertype = (skb->data[12] << 8) | skb->data[13];
 
 	return ethertype == ETH_P_TDLS &&
-	       skb->len > 14 &&
+	       skb_headlen(skb) > 14 &&
 	       skb->data[14] == WLAN_TDLS_SNAP_RFTYPE;
 }
 
-- 
2.55.0

