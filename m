Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAC2391E7A
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 08:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785661107; cv=none; b=cCG3dRJ9NVi5vbUolp3KHXnVDPWIvvtapSc0FoBSEL/6mwgRU45+OxwXLtG8VLhhdZc2Xok+iiB85teQQOiWIlD/iTZ/mVX5/R0uzUaFiCd3GutHiV22BKEEcbx6NS9P2wOLLqd52zn2fCVMl31Mb7v4Rgj1OtSwyiQvvkDaCFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785661107; c=relaxed/simple;
	bh=bWFN5pieut+Oz8z8LMv2PP2Zq4A6HtAR+Th7IYONIps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etCO5iRHFmqtIV8HRt/P0zQzmNQB7sQqG0Uskl6UPKXemsHxVj/9xlCVUVd3+Z/k9ziz4ZI9ag9lznKZZaLc9zgy7u1YMzIUk7TEcMoA0tBgikNtcSZUsHnEHfEvVDFAD6YwtgWLidKP3VED8hczzpdwS9DMoJXQVSLcGgX0BQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=SAGDbb3K; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="SAGDbb3K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=tJtZhDqDV5F2Hj9nKvr8sftVWkwtH291nfWKnsEfZIw=;
	t=1785661106; x=1786870706; b=SAGDbb3K2j3gcyhvUbmdTwEqTz36fGSxOz0rigwRx3rmtUP
	By+QGxInLZrl91jAVVYM+ot3XvjRfXbtMqVpKfEZP2WeQBR0S9jl/9HY0LMVa7hj4WrcYBnpP0lW5
	CHWa3b+eOmCQJn+Vc3CZHRrZM+7BxUAuK4QnsTdTNC/diX0+53EDlu57qPJVCgsVMLVdXYltoDjXf
	ATxWK+1u66K4buuz7LHEymh1e7YhBSGfrX/PqZnl0EzZ8VXK228Iuiffbm25spHRyJYs91Ob9pRzQ
	O+QuROZuVbG3tt4putJHkwinfhIrHZJmsnRAtRe3otgKiD24BpvHgDUBSGtgEK4A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqS1X-00000004NaL-29uG;
	Sun, 02 Aug 2026 10:58:23 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 4/4] wifi: mac80211: drop encap offload frames with a tainted key
Date: Sun,  2 Aug 2026 10:57:21 +0200
Message-ID: <20260802105818.870b6ef31374.Ib87175b55b9fd94c16ba6d9cd816b7a09248df87@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802085818.1336616-6-johannes@sipsolutions.net>
References: <20260802085818.1336616-6-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

When a key is tainted, which happens in some WoWLAN and extended
key ID scenarios, frames that would use it should be dropped.
Fix that for encapsulation offload frames.

Fixes: 50ff477a8639 ("mac80211: add 802.11 encapsulation offloading support")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c6e1171876f9..d16c58dc09b3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -617,7 +617,13 @@ ieee80211_select_key_8023(struct ieee80211_tx_data *tx)
 		tx->key = rcu_dereference(tx->sdata->deflink.default_multicast_key);
 	}
 
-	if (tx->key && tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
+	if (!tx->key)
+		return TX_CONTINUE;
+
+	if (unlikely(tx->key->flags & KEY_FLAG_TAINTED))
+		return TX_DROP;
+
+	if (tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
 		info->control.hw_key = &tx->key->conf;
 
 	return TX_CONTINUE;
-- 
2.55.0

