Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651940;
	b=wEtvyRDH214uAcEcWiP8K9UkLQL2KZEPeR0vhEysmrzXAIHKoNHBM3lVOET00ZltPun7
	 O3lWXGwhDrTm/S4eH8CiMlCi83+FZ19bZcLi1JzGRdEVaKVo7LnnBTrjch0Qdd+I73mkG
	 uOUR3FJrdxe1cp2lnLG8AIwrO5+QD/GfnqM1VF64hQPxvPJNYFwZvcmKBx4u5xvD++iYG
	 4Ow8BG4mfdJUi3INzBvYgMx4KSJjen3mt/1N0bSmnHaeCieYQkTRI71X9boEsVZ7HV5Dd
	 sWchhnoRFs22AiriTffFzKgZC5b7LMBeH5wTO0wp9J70jSu7fvo+n0G1GCo81wBsQ/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651940;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=tS8vjiFPeZFKdQojG8OhQqHCJ/1o0LoiyufA2C7jA1k=;
	b=qyLqlfM5VBRSubV7lh0H28NP0LiiyTqAUTggdgg8GvH/xFGgAFbItbt9RlgHkvBI3/vL
	 8WwV6Ww5dagt7hCkqyPc0UpO4DvkHlH1v15yasn+xkk7DZi0QGYbdLazVJtwqaAySljhP
	 TRxSvuuf8qLuFYmGb6juKqky4Wwn5NeLa/BZVfM4dTtE1JbiCi1qjnj9y3LcdwQNjYqL5
	 6F8PkOhHN2BoduOdGwkk+hHjjV5oVotvQxyig/qM720BBBWrxFI+T98Dt4D5FFWfj1joS
	 KCKRxUvBo7ZdUIvNuINcFbL7nWQFf8sFL5sbhc/sj+QtQWCr8/ofJfE4X6+D5mnUaUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=QrNpDt0B;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461C96082BD2
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=QrNpDt0B
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=tS8vjiFPeZFKdQojG8OhQqHCJ/1o0LoiyufA2C7jA1k=;
	t=1793651939; x=1794861539; b=QrNpDt0BaOWUIicn7aKpGtid34VrZdoXCDFeGoqsjGaTQut
	DomfSV1JRGjOZkfkqCT0kdRU4nRm0/Epfsf3OnVyhz38jYDOoQ0NmrNhm6MD9841tiVSwKlCkj1nQ
	zyddCJwiyOx7Biy4lboy1/9B6DH9jEarK4JolzO+n/GGdwa3+tOWnY/kcEI2HXgMcDXHq49QxU45+
	cdM8uDE8EHeCnahuKToFRq1QbEOcniZ5PSEETa9ZiYENfPggKhaPgW/9gBgwq87zjizpyTisPPWzQ
	9hDGYZPRvKQdabbYrDGfI6gT5w4e2nKtCzLco41/8GOxgVfXuC7+9rAHiVMrjBSA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNynx-00000001vzr-2G7b;
	Mon, 02 Nov 2026 21:38:57 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 20/30] wifi: mac80211: avoid reordering PS-release MMPDUs
Date: Mon,  2 Nov 2026 21:23:10 +0100
Message-ID: <20261102203831.1058362-52-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102203831.1058362-32-johannes@sipsolutions.net>
References: <20261102203831.1058362-32-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

MMPDUs released during powersave are transmitted through the
'pending' queues, per AC/HW queue, based on the SKB HW queue
mapping. This can mix up their order because we try to send
e.g. AddBA request for an AC on that AC, and if the station
then goes to sleep they might be released on wakeup together,
and cross on the TXQs.

To avoid this, assign the HW queue based on the TXQ AC when
releasing frames after/during powersave.

This isn't a new issue, but is much easier to fix now.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 32c36a54fb7e..0b322bef5a40 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4265,7 +4265,18 @@ EXPORT_SYMBOL(ieee80211_tx_dequeue);
 struct sk_buff *ieee80211_tx_dequeue_ps_release(struct ieee80211_local *local,
 						struct txq_info *txqi)
 {
-	return __ieee80211_tx_dequeue(&local->hw, &txqi->txq, true);
+	struct ieee80211_txq *txq = &txqi->txq;
+	struct sk_buff *skb;
+
+	skb = __ieee80211_tx_dequeue(&local->hw, txq, true);
+	if (!skb)
+		return NULL;
+
+	/* to avoid buffered MMPDUs for different ACs crossing each other */
+	skb_set_queue_mapping(skb, txq->ac);
+	IEEE80211_SKB_CB(skb)->hw_queue = txq->vif->hw_queue[txq->ac];
+
+	return skb;
 }
 
 static inline s32 ieee80211_sta_deficit(struct sta_info *sta, u8 ac)
-- 
2.56.0

