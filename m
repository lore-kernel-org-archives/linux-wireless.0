Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2714AA03D
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 21:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791150321; cv=none; b=XFhcsxf3UEXuUj856QFXZ4w6ILpN4ConxeHCn4VsGr1DI+25zyWHGvh1U0R3Vex6BUkwEdMTVUyv3iCttjbKA/YVxA6/MkI8dSLYClHa6xjUiT/rjmoZ7GR1VeEf/sCWijAsqy1vrn1jlepW+xgM4khxRkU+dKouOw2Ng1fhjZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791150321; c=relaxed/simple;
	bh=qL4fU8I5N4X9t8LLn4Crt3PkY96P5EAamW16AcaF+R8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSFlfKiK4464FQEXwQs8YfoM4Z76b+hqZk3WbNYGqNpJbNiV2aVQcThCIhcEiVgOp7lZJpLn3N1jaEQWDhtpQI+GYVUGmeG1dzrWAww79q2i6Q1U2c/9cP6YRpnES8J6m/uVOrrADTH7S6nxOm9sQjNC6/B2L66dE4Q6j5xogmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=aiHkBsO5; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="aiHkBsO5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=31EETAx0XEBT6M7TTzJ1h6hpOGS562q6eTKB5pou79w=;
	t=1791150319; x=1792359919; b=aiHkBsO5G4rLxOxV145ct54n+aPPUfOP0Wzq7sx3pJdFxWp
	ge02BdV3IO0fGZ3Bc2SAk8x1qXYCLgZHmqeJv78cn6Zcjfc/FE2gwKZZ9S9cRHQ8yQkWEIpzSbHQe
	1dyRjZWfNA67jW34b5LnzytEuX6oVH/RYhr6eOCL5bi9tJO6edvDbpzOOPMjUyLkqYZmfBMTDmi4X
	7pcC5sY9985rO0SErVz5WfRVl6jAF12S9cIi9P6yvouJaHMZizbMfTcst7z4yI3fnm7G7jGWbCStH
	ftKeS8DfUIZNe58MOuxl5l6zrf3gc3jl4xqpvJMgz6jTEhI8sRuBW3Bv9UNyq36Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDU1E-00000004OqT-02ln;
	Sun, 04 Oct 2026 23:45:16 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 11/12] wifi: mac80211: don't require wiphy mutex for control port TX
Date: Sun,  4 Oct 2026 23:40:57 +0200
Message-ID: <20261004234504.d95577ee9017.Ica8bba30018704a7c776f2ef08e6f2571cd8f8c4@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261004214504.1636783-14-johannes@sipsolutions.net>
References: <20261004214504.1636783-14-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The wiphy mutex was only required for the cookie counter,
but that's been in cfg80211 for a while. The rest is just
datapath, so can work under RCU, just need to be careful
to handle interface type changes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1953ec35c783..46134bda1e8f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -6600,9 +6600,6 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	u32 flags = 0;
 	int err;
 
-	/* mutex lock is only needed for incrementing the cookie counter */
-	lockdep_assert_wiphy(local->hw.wiphy);
-
 	/* Only accept CONTROL_PORT_PROTOCOL configured in CONNECT/ASSOCIATE
 	 * or Pre-Authentication
 	 */
@@ -6661,6 +6658,14 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	 * AF_PACKET
 	 */
 	rcu_read_lock();
+
+	/* do_stop() synchronizes RCU before the interface type can change */
+	if (!ieee80211_sdata_running(sdata)) {
+		dev_kfree_skb(skb);
+		rcu_read_unlock();
+		return -ENETDOWN;
+	}
+
 	err = ieee80211_lookup_ra_sta(sdata, skb, &sta, true);
 	if (err) {
 		dev_kfree_skb(skb);
-- 
2.55.0

