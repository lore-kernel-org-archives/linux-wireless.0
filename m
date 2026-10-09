Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F3F51120B
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 18:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569677; cv=none; b=GPSrm7MLcpUWxjqnL2RK9fIum/aCOdz0SqyFvML6jLb1BrTEHNFyHAvmgmD7Z+cvqE+VRPU7hh0q5MI0kn9JtSJK29Wernh1mzziKNx1nWX9YrQHK+a5IS7AsYrSsb8ZvGvJzpp4h3RyWzQAKaXxO16uQNt1CWYihlLdTdDYIzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569677; c=relaxed/simple;
	bh=6ovmRdVZlccrwfRRZQPrLNjjCWif6fVYq6dhqiyaxYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MatH2qDAKqSmtK0kwRdIHswgcmyO39sZDM0VRLoC7EnzOYXxNq/dGLG30iqy0z3Fu8s826D5M3c19e2F4whFreW0NMRl7dMq5yRRI17DQs119+X/DIcqpMTSgd/yFWbTgGK5iIVnBQQ4aoiP7EcyVONQpjaaupF2C7uriIIUVKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Flf7Rlsa; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Flf7Rlsa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=6ui+lwGfDHIbKKVt4GYi9SH0tbOeNJgme4cz0W1DjkE=;
	t=1791569676; x=1792779276; b=Flf7RlsawJ2ehvELEC4lACjmm+HrqQYXFOcEiI/aDLOYYvb
	W2MhGpOfGzTTGyYzpT0paR8csK+DLYuA6Chj1oa6zE2qJAnFioAGgavwQLG1OKSwtIW5gYSVuiiEM
	v86T0fdAB0QGSqPjp7u3XPjbAgrTH/dbw9b5HrgJpSLO05+vRVBoKzRYPTpwa1XJHe1JA1VdVaMQn
	GK5EmysPtF6hPL6UQ83prCQMkv2QyxTO7AV2dGvUTtnazRkDWOWQgdRWPSsEsK/R6saNdRUXXNjVY
	SQGVABzctffqeDyzAGU+wdc069izq28YX3omlYsVPQSufQWyCz6qp/a1UW78xZNQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFF73-0000000AtGH-2A9p;
	Fri, 09 Oct 2026 20:14:33 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 13/17] wifi: mac80211: don't require wiphy mutex for control port TX
Date: Fri,  9 Oct 2026 20:10:12 +0200
Message-ID: <20261009201417.dffb8da303aa.Ica8bba30018704a7c776f2ef08e6f2571cd8f8c4@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009181416.335754-19-johannes@sipsolutions.net>
References: <20261009181416.335754-19-johannes@sipsolutions.net>
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
index 4b0ffd0a6ac7..ef97d6d3bdcd 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -6640,9 +6640,6 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	u32 flags = 0;
 	int err;
 
-	/* mutex lock is only needed for incrementing the cookie counter */
-	lockdep_assert_wiphy(local->hw.wiphy);
-
 	/* Only accept CONTROL_PORT_PROTOCOL configured in CONNECT/ASSOCIATE
 	 * or Pre-Authentication
 	 */
@@ -6701,6 +6698,14 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
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
2.56.0

