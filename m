Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C483392C25
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 08:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785661106; cv=none; b=h5bK/VkR93v8LnLaHp8ysi4Wp9HUXy+ma7CfCvdvtjghEl0GRcWxUR43m0jtByOI/AzxoRi9GaLoWhatZaQKIdwlQTcvJhoh1M7LyNvzENUyqSIWOLYIeE4NE9yIuW2k3//7nKJvOuDQivRZQ9kocbQ3VLR9hE0RY/VfZakx+JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785661106; c=relaxed/simple;
	bh=0tl+qparsK6eTiMMIg/8lsnv1XTHCfuJ70bnPvHwu18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSfVr6VTR3lgZ8H07YVLMmxIFIq9RgA2+tIQBZ+hN27iFm0cwHz+HmupnAxvyUP6C7KUf0VBcOAb/jnhCK91tGVOLpcg40i4pWQBN15uWI42nOA8XBaIuXHZFoaA4YL6oBHE0vTgMtE2IWx11GJkbOgzQnVKw9WTbOzCgQ7bY6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=wcJ1RYf3; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="wcJ1RYf3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=OJCnV6evyJHACLpQzgSpZMYKtctZLOhQh3op3ZJW7Jg=;
	t=1785661105; x=1786870705; b=wcJ1RYf3R/y6V1g2dQAnzc5vUyKnC/lWFrl/wnpxCqErPEM
	FWQba9Of8bfVotaLWeC907+ZGK1JjO4CfaEAQ2ftljN/AA7i/dLP1u9HUE6XyUGcejEZ17F7Dg0aV
	h2ff1RldttxXPDy8AOV0r0xVTdzkH6UXB6jgt2EGe+Z/JW3gzLKMdq+EzKo60Cp2C8smpO2PoDvcE
	cd9RkYWtC5zY2LFyUm2T84DNE+qDrjtCple54FI0v1AdD20wxhK6MEJmEiVo132RgtFEKuDYbuW23
	HPK8FbsVV0WasbplSYGm8+tYSdhZ2zl5kmTYdwjeoT7O7rYQGGCyIkuadfeaawsQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqS1W-00000004NaL-3Vlh;
	Sun, 02 Aug 2026 10:58:23 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 3/4] wifi: mac80211: don't send encap offload frames unencrypted
Date: Sun,  2 Aug 2026 10:57:20 +0200
Message-ID: <20260802085818.1336616-7-johannes@sipsolutions.net>
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

For 802.11 frames, ieee80211_tx_h_select_key() drops a data frame
that ended up without a key if the station requires encryption, so
that traffic can never leak out unprotected. Encapsulation offload
erroneously didn't get this code path. Fix that.

Fixes: 50ff477a8639 ("mac80211: add 802.11 encapsulation offloading support")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2ef77bb80b92..c6e1171876f9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -610,6 +610,9 @@ ieee80211_select_key_8023(struct ieee80211_tx_data *tx)
 		tx->key = rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx]);
 		if (!tx->key)
 			tx->key = rcu_dereference(tx->sdata->default_unicast_key);
+
+		if (!tx->key && test_sta_flag(tx->sta, WLAN_STA_USES_ENCRYPTION))
+			return TX_DROP;
 	} else if (!ieee80211_vif_is_mld(&tx->sdata->vif)) {
 		tx->key = rcu_dereference(tx->sdata->deflink.default_multicast_key);
 	}
-- 
2.55.0

